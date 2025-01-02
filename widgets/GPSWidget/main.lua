-- Widget LUA Script: GPS Widget
-- Displays satellite count, latitude, and longitude with small text aligned to the right
-- Includes color-coded satellite count and satellite icon


local textStyle = RIGHT + WHITE + SHADOWED
local midLineHeight = 25
local lineHeight = 18


-- Function to create the widget
local function create(zone, options)
    return {
        zone = zone,
        cfg = options,
    }
end

local function update(widget, options)
    widget.cfg = options
end

-- Helper function to convert decimal degrees to degrees, minutes, and seconds
local function toDMS(value)
    local degrees = math.floor(value)
    local minutes = math.floor((value - degrees) * 60)
    local seconds = ((value - degrees) * 60 - minutes) * 60
    return degrees, minutes, seconds
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

local function refresh(widget, event, touchState)

    -- Check if RX is connected using telemetry link quality (LQ)
	local tpwr = tonumber(getValue("TPWR")) or 0
  
	if tpwr > 0 then

		-- Define positions
		local xRight = widget.zone.x + widget.zone.w - 10
		local xLeft = widget.zone.x + 10
		local yStart = widget.zone.y + 35
		
		-- Get telemetry data
		local sats = tonumber(getValue("Sats")) or 0
		local gpsLatLon = getValue("GPS")

		-- Validate GPS data
		if type(gpsLatLon) ~= "table" then
			lcd.drawText(xRight, yStart, "No GPS", textStyle  + MIDSIZE)
			return
		end

		local latitude = gpsLatLon.lat or 0
		local longitude = gpsLatLon.lon or 0

		-- Determine color based on satellite count
		local color
		if sats <= 5 then
			color = RED
		elseif sats <= 7 then
			color = YELLOW
		else
			color = GREEN
		end

		-- Draw satellite icon
		local iconPath = "/WIDGETS/GPSWidget/BMP/satellite-%s.png"
		local iconColor
		if sats <= 5 then
			iconColor = "red"
		elseif sats <= 7 then
			iconColor = "yellow"
		else
			iconColor = "green"
		end
		local icon = Bitmap.open(string.format(iconPath, iconColor))
		lcd.drawBitmap(icon, xRight-40, yStart - 35)

		-- Format latitude and longitude
		local latStr, lonStr = formatLatLon(latitude, longitude)

		-- Draw GPS Data
		lcd.drawText(xRight, yStart, string.format("Sats: %d", sats), textStyle  + MIDSIZE)
		lcd.drawText(xRight, yStart + midLineHeight, "Lat: " .. latStr, textStyle)
		lcd.drawText(xRight, yStart + midLineHeight + lineHeight, "Lon: " .. lonStr, textStyle)
	
    end


end

local function background(widget)
    -- No background tasks needed for this widget
end

return {
    name = "GPSWidget",
    options = {},
    create = create,
    update = update,
    refresh = refresh,
    background = background,
}
