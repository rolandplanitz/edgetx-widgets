
-- Constants
local textStyle = RIGHT + WHITE + SHADOWED
local lineHeight = 18
local months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", 
"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
local iconPathFmt = "/WIDGETS/ClockWidget/BMP/connection-%s.png"


-- Function to format time string
local function getFormattedTime(datetime, is24Hour)
  local hour = datetime.hour
  local amPm = ""

  if not is24Hour then
    if hour == 0 then
      hour = 12
      amPm = " AM"
    elseif hour == 12 then
      amPm = " PM"
    elseif hour > 12 then
      hour = hour - 12
      amPm = " PM"
    else
      amPm = " AM"
    end
  end

  return string.format("%02d:%02d%s", hour, datetime.min, is24Hour and "" or amPm)
end

-- Widget creation: preload bitmaps
local function create(zone, options)
  local icons = {
    red = Bitmap.open(string.format(iconPathFmt, "red")),
    yellow = Bitmap.open(string.format(iconPathFmt, "yellow")),
    green = Bitmap.open(string.format(iconPathFmt, "green")),
    black = Bitmap.open(string.format(iconPathFmt, "black")),
  }

  return {
    zone = zone,
    cfg = options,
    icons = icons,
  }
end

-- Widget config update
local function update(widget, options)
  widget.cfg = options
end

-- Main drawing function
local function refresh(widget, event, touchState)
  local datetime = getDateTime()
  if not datetime then
    lcd.drawText(widget.zone.x + 10, widget.zone.y + 10, "No Date/Time", MIDSIZE + RED)
    return
  end

  local tpwr = tonumber(getValue("TPWR")) or 0
  local iconState

  if tpwr > 0 then
    local rqly = tonumber(getValue("RQly")) or 0
    if rqly < 60 then
      iconState = "red"
    elseif rqly < 80 then
      iconState = "yellow"
    else
      iconState = "green"
    end
  else
    iconState = "black"
  end

  local is24Hour = widget.cfg.Format24H == 1
  local timeStr = getFormattedTime(datetime, is24Hour)
  local dateStr = string.format("%02d %s", datetime.day, months[datetime.mon] or "???")
  local isoStr = string.format("%04d-%02d-%02d %02d:%02d", datetime.year, datetime.mon, datetime.day, datetime.hour, datetime.min)

  local xRight = widget.zone.x + widget.zone.w - 10
  local yStart = widget.zone.y + 5
  local iconRight = xRight - (is24Hour and 85 or 110)
  if widget.cfg.iso8601 == 1 then iconRight = xRight - 160 end

  local icon = widget.icons[iconState]
  if icon then
    lcd.drawBitmap(icon, iconRight, yStart + 2)
  end

  if widget.cfg.iso8601 == 0 then
    lcd.drawText(xRight, yStart, timeStr, textStyle)
    lcd.drawText(xRight, yStart + lineHeight, dateStr, textStyle)
  else
    lcd.drawText(xRight, yStart, isoStr, textStyle)
  end

  if widget.cfg.timers == 1 then
    -- define height - adjust based on one line ISO or two line date/time
    local timerY = yStart + lineHeight
    if widget.cfg.iso8601 == 0 then timerY = timerY + lineHeight end

    -- get timers
    local t0 = model.getTimer(0)
    local t1 = model.getTimer(1)
    local t2 = model.getTimer(2)

    -- mode == 0 means 'off'
    if t0 ~= nil and t0.mode > 0 then
      local t0H = math.floor(t0.value/3600)
      local t0M = math.floor(t0.value/60) - t0H*60
      local t0S = t0.value - t0H*3600 - t0M*60
      local t0Str = string.format("%s %02d:%02d", t0.name, t0M, t0S)
      if t0H > 0 then local t0Str = string.format("%s %02d:%02d:%02d", t0.name, t0H, t0M, t0S) end
      lcd.drawText(xRight, timerY, t0Str, textStyle)

      -- shift down y by one line
      timerY = timerY + lineHeight
    end

    if t1 ~= nil and t1.mode > 0 then
      local t1H = math.floor(t1.value/3600)
      local t1M = math.floor(t1.value/60) - t1H*60
      local t1S = t1.value - t1H*3600 - t1M*60
      local t1Str = string.format("%s %02d:%02d", t1.name, t1M, t1S)
      if t1H > 0 then local t1Str = string.format("%s %02d:%02d:%02d", t1.name, t1H, t1M, t1S) end
      lcd.drawText(xRight, timerY, t1Str, textStyle)

      -- shift down y by one line
      timerY = timerY + lineHeight
    end

    if t2 ~= nil and t2.mode > 0 then
      local t2H = math.floor(t2.value/3600)
      local t2M = math.floor(t2.value/60) - t2H*60
      local t2S = t2.value - t2H*3600 - t2M*60
      local t2Str = string.format("%s %02d:%02d", t2.name, t2M, t2S)
      if t2H > 0 then local t2Str = string.format("%s %02d:%02d:%02d", t2.name, t2H, t2M, t2S) end
      lcd.drawText(xRight, timerY, t2Str, textStyle)

      -- shift down y by one line
      timerY = timerY + lineHeight
    end
  end
end

-- Return widget definition
return {
  name = "ClockWidget",
  create = create,
  update = update,
  refresh = refresh,
  options = {
    {"Format24H", BOOL, 1}, -- 1 = 24-hour, 0 = 12-hour

    -- show ISO 8601 Timestamp (%Y-%m-%d %H:%M)
    -- instead of two lines with date and time
    { "iso8601", BOOL, 0 },

    -- show timers below timestamp
    -- only shows ones with mode other than 'off'
    { "timers", BOOL, 0 },
  },
}
