-- Widget LUA Script: GPS Widget
-- Displays satellite count, latitude, and longitude with small text aligned to the right
-- Includes color-coded satellite count and satellite icon

local textStyle = RIGHT + WHITE + SHADOWED
local midLineHeight = 33
local lineHeight = 18


-- Function to create the widget
local function create(zone, options)
  return {
    zone = zone,
    options = options,
    update = true,
    gpsSATS = 0,
    gpsLAT = 0,
    gpsLON = 0,
    isGPSValid = true,
  }
end

local function update(widget, newOptions)
  widget.options = newOptions
end

-- Helper function to convert decimal degrees to degrees, minutes, and seconds
local function toDMS(value)
  local degrees = math.floor(value)
  local minutes = math.floor((value - degrees) * 60)
  local seconds = ((value - degrees) * 60 - minutes) * 60
  return degrees, minutes, seconds
end

-- helper functions for MGRS
local function pad(val)
    val = tostring(val)
    while #val < 5 do
        val = "0" .. val
    end
    return val
end

function latlon_to_mgrs(lat, lon)
    if lat < -80 then return 'Too far South' end
    if lat > 84 then return 'Too far North' end

    local c = math.floor((lon + 180) / 6) + 1
    local e = c * 6 - 183
    local k = math.rad(lat)
    local l = math.rad(lon)
    local m = math.rad(e)
    local n = math.cos(k)
    local o = 0.006739496819936062 * (n^2)
    local p = 40680631590769 / (6356752.314 * math.sqrt(1 + o))
    local q = math.tan(k)
    local r = q * q
    local t = l - m
    local u = 1.0 - r + o
    local v = 5.0 - r + 9 * o + 4.0 * (o^2)
    local w = 5.0 - 18.0 * r + r * r + 14.0 * o - 58.0 * r * o
    local x = 61.0 - 58.0 * r + r * r + 270.0 * o - 330.0 * r * o
    local y = 61.0 - 479.0 * r + 179.0 * r * r - r * r * r
    local z = 1385.0 - 3111.0 * r + 543.0 * r * r - r * r * r

    local aa = p * n * t +
        (p / 6.0 * n^3 * u * t^3) +
        (p / 120.0 * n^5 * w * t^5) +
        (p / 5040.0 * n^7 * y * t^7)
    local ab = 6367449.14570093 * (k - (0.00251882794504 * math.sin(2 * k)) +
        (0.00000264354112 * math.sin(4 * k)) -
        (0.00000000345262 * math.sin(6 * k)) +
        (0.000000000004892 * math.sin(8 * k))) +
        (q / 2.0 * p * n^2 * t^2) +
        (q / 24.0 * p * n^4 * v * t^4) +
        (q / 720.0 * p * n^6 * x * t^6) +
        (q / 40320.0 * p * n^8 * z * t^8)

    aa = aa * 0.9996 + 500000.0
    ab = ab * 0.9996
    if ab < 0.0 then ab = ab + 10000000.0 end

    local latBands = "CDEFGHJKLMNPQRSTUVWXX"
    local ad = latBands:sub(math.floor(lat / 8 + 10) + 1, math.floor(lat / 8 + 10) + 1)
    local ae = math.floor(aa / 100000)
    local digraph1Array = {"ABCDEFGH", "JKLMNPQR", "STUVWXYZ"}
    local af = digraph1Array[(c - 1) % 3 + 1]:sub(ae, ae)
    local ag = math.floor(ab / 100000) % 20
    local digraph2Array = {"ABCDEFGHJKLMNPQRSTUV", "FGHJKLMNPQRSTUVABCDE"}
    local ah = digraph2Array[(c - 1) % 2 + 1]:sub(ag + 1, ag + 1)

    aa = math.floor(aa % 100000)
    ab = math.floor(ab % 100000)

    return string.format("%02d%s %s%s %s", c, ad, af, ah, pad(aa)), string.format("MGRS  %s", pad(ab))
end

-- Function to draw the satellite icon based on the satellite count
local function getIconColor(gpsSATS)   
  local iconColor
  if gpsSATS <= 5 then
    color = RED
    iconColor = "red"
  elseif gpsSATS <= 7 then
    color = YELLOW
    iconColor = "yellow"
  else
    color = GREEN
    iconColor = "green"
  end

  return iconColor
end

-- Function to format latitude and longitude
local function formatLatLon(lat, lon)
  local latDeg, latMin, latSec = toDMS(math.abs(lat))
  local lonDeg, lonMin, lonSec = toDMS(math.abs(lon))
  local latDir = lat >= 0 and "N" or "S"
  local lonDir = lon >= 0 and "E" or "W"
  return string.format("%d°%d'%d\"%s", latDeg, latMin, latSec, latDir),
  string.format("%d°%d'%d\"%s", lonDeg, lonMin, lonSec, lonDir)
end

local function drawGpsTelemetry(widget) 

  -- Define positions
  local xRight = widget.zone.x + widget.zone.w - 10
  local yStart = widget.zone.y + 5

  -- Get telemetry data
  widget.gpsSATS = tonumber(getValue("Sats")) or 0
  widget.gpsLatLon = getValue("GPS")


  if (type(widget.gpsLatLon) == "table") then       
    widget.gpsLAT = widget.gpsLatLon.lat or 0
    widget.gpsLON = widget.gpsLatLon.lon or 0 
    widget.isGPSValid = true  
    widget.update = true
  else
    widget.isGPSValid = false
    widget.update = false
  end

  -- Format latitude and longitude
  local latStr, lonStr = formatLatLon(widget.gpsLAT, widget.gpsLON)

  if widget.isGPSValid then
    local iconPath = "/WIDGETS/GPSWidget/BMP/satellite-%s.png"
    local icon = Bitmap.open(string.format(iconPath, getIconColor(widget.gpsSATS)))
    lcd.drawBitmap(icon, xRight-22, yStart)
    lcd.drawText(xRight - 35, yStart + 2, string.format("Sats: %d", widget.gpsSATS), textStyle  + MIDSIZE)

    if widget.options.MGRS == 1 then
      local a,b = latlon_to_mgrs(widget.gpsLAT, widget.gpsLON)
      lcd.drawText(xRight, yStart + midLineHeight + 2, a, textStyle + MIDSIZE)
      lcd.drawText(xRight, yStart + midLineHeight + lineHeight + 4, b, textStyle + MIDSIZE)
    elseif widget.options.Coordinates == 1 then
      lcd.drawText(xRight, yStart + midLineHeight, "Lat: " .. latStr, textStyle)
      lcd.drawText(xRight, yStart + midLineHeight + lineHeight, "Lon: " .. lonStr, textStyle)    
    end

  else
    if widget.gpsLAT == 0 and widget.gpsLON == 0 then
      lcd.drawText(xRight - 35, yStart + 2, "No GPS", textStyle + MIDSIZE)
    else
      lcd.drawText(xRight + 10, yStart + 2, "Last location: ", textStyle + MIDSIZE)

      if widget.options.MGRS == 1 then
        lcd.drawText(xRight, yStart + midLineHeight + 2, a, textStyle + MIDSIZE)
        lcd.drawText(xRight, yStart + midLineHeight + lineHeight + 4, b, textStyle + MIDSIZE)
      else
        lcd.drawText(xRight, yStart + midLineHeight, "Lat: " .. latStr, textStyle)
        lcd.drawText(xRight, yStart + midLineHeight + lineHeight, "Lon: " .. lonStr, textStyle)
      end
    end
  end

end

local function refresh(widget, event, touchState)
  drawGpsTelemetry(widget)
end

return {
  name = "GPSWidget",
  options = {},
  create = create,
  update = update,
  refresh = refresh,
  options = {
    {"Coordinates", BOOL, 1},
    {"MGRS", BOOL, 0},
  },
}
