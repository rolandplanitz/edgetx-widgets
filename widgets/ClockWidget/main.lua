-- Basic LUA Script with Date and Time Widget
-- Displays the current date and time with a modified date format

local function create(zone, options)
    local widget = {
        zone = zone,
        cfg = options,
    }
    return widget
end

local function update(widget, options)
    widget.cfg = options
end

local function refresh(widget, event, touchState)
    -- Get the current date and time
    local datetime = getDateTime()
    if not datetime then
        lcd.drawText(widget.zone.x + 10, widget.zone.y + 10, "No Date/Time", MIDSIZE + RED)
        return
    end

    -- Convert month to 3-letter abbreviation
    local months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
    local monthStr = months[datetime.mon] or "???"

    local timeStr = string.format("%02d:%02d", datetime.hour, datetime.min)
    local dateStr = string.format("%02d %s", datetime.day, monthStr)

    -- Define positions
    local xRight = widget.zone.x + widget.zone.w - 10
    local yStart = widget.zone.y + 5
    local midLineHeight = 25

    -- Draw Date and Time Block
    lcd.drawText(xRight, yStart, timeStr, RIGHT + MIDSIZE + WHITE + SHADOWED)
    lcd.drawText(xRight, yStart + midLineHeight, dateStr, RIGHT + SMLSIZE + WHITE)
end

local function background(widget)
    -- No background tasks needed for this widget
end

return {
    name = "ClockWidget",
    options = {},
    create = create,
    update = update,
    refresh = refresh,
    background = background,
}
