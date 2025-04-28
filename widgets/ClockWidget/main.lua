-- Basic LUA Script with Date and Time Widget
-- Displays the current date and time with a modified date format
local textStyle = RIGHT + WHITE + SHADOWED
local midLineHeight = 25
local lineHeight = 18

-- Function to create the widget
local function create(zone, options)
    return {
        zone = zone,
        options = options,
    }
end

-- Function to update the widget configuration
local function update(widget, options)
    widget.options = options
end

-- Function to get the formatted time
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

    -- Determine time format
    local is24Hour = widget.options.Format24H == 1 -- Check the TimeFormat option

    -- Get the formatted time string
    local timeStr = getFormattedTime(datetime, is24Hour)
    local dateStr = string.format("%02d %s", datetime.day, monthStr)

    -- Define positions
    local xRight = widget.zone.x + widget.zone.w - 10
    local yStart = widget.zone.y + 5

    -- Draw connection icon
    local iconRight
    if is24Hour then
        iconRight = xRight - 85
    else
        iconRight = xRight - 110
    end

     


    local icon = Bitmap.open(string.format(iconPath, iconState))
    lcd.drawBitmap(icon, iconRight, yStart + 2)


    -- Draw Date and Time Block
    lcd.drawText(xRight, yStart, timeStr, textStyle)
    lcd.drawText(xRight, yStart + lineHeight, dateStr, textStyle)
end

return {
    name = "ClockWidget",
    options = {},
    create = create,
    update = update,
    refresh = refresh,
    options = {
        {"Format24H", BOOL, 1}, -- 1 for 24-hour, 0 for 12-hour
      },
}
