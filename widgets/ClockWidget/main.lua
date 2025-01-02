-- Basic LUA Script with Date and Time Widget
-- Displays the current date and time with a modified date format
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

-- Function to update the widget configuration
local function update(widget, options)
    widget.cfg = options
end

-- Function to refresh the widget display
local function refresh(widget, event, touchState)
    -- Get the current date and time
    local datetime = getDateTime()
    if not datetime then
        lcd.drawText(widget.zone.x + 10, widget.zone.y + 10, "No Date/Time", MIDSIZE + RED)
        return
    end

    local tpwr = tonumber(getValue("TPWR")) or 0

    local iconState
    -- Determine battery icon based on RXBt value
    local iconPath = "/WIDGETS/ClockWidget/BMP/connection-%s.png"

        
	if tpwr > 0 then

		-- Get telemetry data
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


    -- Convert month to 3-letter abbreviation
    local months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
    local monthStr = months[datetime.mon] or "???"

    local timeStr = string.format("%02d:%02d", datetime.hour, datetime.min)
    local dateStr = string.format("%02d %s", datetime.day, monthStr)

    -- Define positions
    local xRight = widget.zone.x + widget.zone.w - 10
    local yStart = widget.zone.y + 5

    -- Draw connection icon
    local icon = Bitmap.open(string.format(iconPath, iconState))
    lcd.drawBitmap(icon, xRight - 100, yStart + 5)


    -- Draw Date and Time Block
    lcd.drawText(xRight, yStart, timeStr, textStyle + MIDSIZE)
    lcd.drawText(xRight, yStart + midLineHeight, dateStr, textStyle)
end

return {
    name = "ClockWidget",
    options = {},
    create = create,
    update = update,
    refresh = refresh,
}
