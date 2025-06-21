-- Widget LUA Script: SimModel Widget
-- Displays model information, battery voltage, and date/time

-- Define positions and styles
local xLeft = 10
local yStart = 5
local lineHeight = 18
local midLineHeight = 25
local textStyle = LEFT + WHITE + SHADOWED
local textStyleRight = RIGHT + WHITE + SHADOWED

local options = {
  -- show ISO 8601 Timestamp (%Y-%m-%d %H:%M)
  -- instead of two lines with date and time
  { "iso8601", BOOL, 0 },

  -- show timers below timestamp
  -- only shows ones with mode other than 'off'
  { "timers", BOOL, 0 },

  -- show "Simulator" from below model name
  { "sim_designator", BOOL, 1 },
}

local idTxV

-- Variables used across all instances
local vcache -- valueId cache
local mod = {} -- module info

local function getV(id)
  -- Return the getValue of ID or nil if it does not exist
  local cid = vcache[id]
  if cid == nil then
    local info = getFieldInfo(id)
    -- use 0 to prevent future lookups
    cid = info and info.id or 0
    vcache[id] = cid
  end
  return cid ~= 0 and getValue(cid) or nil
end

local function create(zone, options)
  local widget = {
    zone = zone,
    cfg = options,
  }

  idTxV = getFieldInfo('tx-voltage').id
  local _, rv = getVersion()

  return widget
end

local function update(widget, options)
  -- Runs if options are changed from the Widget Settings menu
  widget.cfg = options
end

local function drawModelInfo(widget)
  -- Get model name from options or use default
  local modelName = model.getInfo().name

  -- Draw Model Name
  lcd.drawText(xLeft, yStart, modelName, textStyle + MIDSIZE + BOLD)

  -- o/s version
  local _, _, major, minor, rev, osname = getVersion()
  local strVer
  if widget.cfg.sim_designator == 1 then
    strVer = "Simulator. " .. (osname or "EdgeTX") .. " " .. major .. "." .. minor .. "." .. rev
  else
    strVer = (osname or "EdgeTX") .. " " .. major .. "." .. minor .. "." .. rev
  end

  lcd.drawText(xLeft, yStart + 2 * lineHeight, strVer, textStyle + SMLSIZE)
end

-- Function to draw the battery icon based on voltage
local function drawBattery()
  idTxV = getFieldInfo('tx-voltage').id
  local vBatt = tonumber(getValue(idTxV)) or 0
  lcd.drawText(xLeft, yStart + 8 + 3 * lineHeight, string.format("%.1fV", vBatt), textStyle + MIDSIZE)

  -- Determine battery icon based on RXBt vBatt
  local iconPath = "/WIDGETS/SimModel/BMP/battery-%s.png"
  local iconState
  if vBatt < 7.1 then
    iconState = "low"
  elseif vBatt < 7.5 then
    iconState = "yellow"
  elseif vBatt < 7.9 then
    iconState = "ok"
  else
    iconState = "full"
  end
  local icon = Bitmap.open(string.format(iconPath, iconState))

  -- Draw battery icon
  lcd.drawBitmap(icon, xLeft + 55, yStart + 5 + 3 * lineHeight)
end

local function drawDateAndTime(widget)
  local datetime = getDateTime()
  if not datetime then
    lcd.drawText(widget.zone.x + 10, widget.zone.y + 10, "No Date/Time", MIDSIZE + RED)
    return
  end

  if widget.cfg.iso8601 == 0 then
    -- default behavior - no ISO 8601 Timestamp
    -- display day and month with time below

    -- Convert month to 3-letter abbreviation
    local months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
    local monthStr = months[datetime.mon] or "???"

    local timeStr = string.format("%02d:%02d", datetime.hour, datetime.min)
    local dateStr = string.format("%02d %s", datetime.day, monthStr)

    -- Define positions
    local xRight = widget.zone.x + widget.zone.w - 10
    local yStart = widget.zone.y + 5

    -- Draw Date and Time Block
    lcd.drawText(xRight, yStart, timeStr, textStyleRight)
    lcd.drawText(xRight, yStart + lineHeight, dateStr, textStyleRight)
  else
    -- show date and time as ISO 8601 Timestamp in a single line
    local tsStr = string.format("%04d-%02d-%02d %02d:%02d", datetime.year, datetime.mon, datetime.day, datetime.hour, datetime.min)

    -- Define positions
    local xRight = widget.zone.x + widget.zone.w - 10
    local yStart = widget.zone.y + 5

    -- Draw Date and Time Block
    lcd.drawText(xRight, yStart, tsStr, textStyleRight)
  end
end

local function drawTimers(widget)
  local t0 = model.getTimer(0)
  local t1 = model.getTimer(1)
  local t2 = model.getTimer(2)

  -- Define positions
  local xRight = widget.zone.x + widget.zone.w - 10
  local y = widget.zone.y + 5 + lineHeight

  -- shift down one unless ISO8601 (two lines vs one)
  if widget.cfg.iso8601 == 0 then y = y + lineHeight end

  -- mode == 0 means 'off'
  if t0 ~= nil and t0.mode > 0 then
    local t0H = math.floor(t0.value/3600)
    local t0M = math.floor(t0.value/60) - t0H*60
    local t0S = t0.value - t0H*3600 - t0M*60
    local t0Str = string.format("%s %02d:%02d", t0.name, t0M, t0S)
    if t0H > 0 then local t0Str = string.format("%s %02d:%02d:%02d", t0.name, t0H, t0M, t0S) end
    lcd.drawText(xRight, y, t0Str, textStyleRight)

    -- shift down y by one line
    y = y + lineHeight
  end

  if t1 ~= nil and t1.mode > 0 then
    local t1H = math.floor(t1.value/3600)
    local t1M = math.floor(t1.value/60) - t1H*60
    local t1S = t1.value - t1H*3600 - t1M*60
    local t1Str = string.format("%s %02d:%02d", t1.name, t1M, t1S)
    if t1H > 0 then local t1Str = string.format("%s %02d:%02d:%02d", t1.name, t1H, t1M, t1S) end
    lcd.drawText(xRight, y, t1Str, textStyleRight)

    -- shift down y by one line
    y = y + lineHeight
  end

  if t2 ~= nil and t2.mode > 0 then
    local t2H = math.floor(t2.value/3600)
    local t2M = math.floor(t2.value/60) - t2H*60
    local t2S = t2.value - t2H*3600 - t2M*60
    local t2Str = string.format("%s %02d:%02d", t2.name, t2M, t2S)
    if t2H > 0 then local t2Str = string.format("%s %02d:%02d:%02d", t2.name, t2H, t2M, t2S) end
    lcd.drawText(xRight, y, t2Str, textStyleRight)

    -- shift down y by one line
    y = y + lineHeight
  end
end

local function refresh(widget, event, touchState)
  drawModelInfo(widget)
  drawBattery()
  drawDateAndTime(widget)
  if widget.cfg.timers == 1 then
    drawTimers(widget)
  end
end

return {
  name = "SimModel",
  options = options,
  create = create,
  update = update,
  refresh = refresh
}
