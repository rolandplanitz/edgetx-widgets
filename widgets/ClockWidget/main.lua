-- ClockWidget: Displays current date and time with telemetry-based connection icon

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
        options = options,
        icons = icons,
    }
end

-- Widget config update
local function update(widget, options)
    widget.options = options
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

    local is24Hour = widget.options.Format24H == 1
    local timeStr = getFormattedTime(datetime, is24Hour)
    local dateStr = string.format("%02d %s", datetime.day, months[datetime.mon] or "???")

    local xRight = widget.zone.x + widget.zone.w - 10
    local yStart = widget.zone.y + 5
    local iconRight = xRight - (is24Hour and 85 or 110)

    local icon = widget.icons[iconState]
    if icon then
        lcd.drawBitmap(icon, iconRight, yStart + 2)
    end

    lcd.drawText(xRight, yStart, timeStr, textStyle)
    lcd.drawText(xRight, yStart + lineHeight, dateStr, textStyle)
end

-- Return widget definition
return {
    name = "ClockWidget",
    create = create,
    update = update,
    refresh = refresh,
    options = {
        {"Format24H", BOOL, 1}, -- 1 = 24-hour, 0 = 12-hour
    },
}
