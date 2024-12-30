-- Widget LUA Script: GPS Widget
-- Displays satellite count, latitude, and longitude with small text aligned to the right
-- Includes color-coded satellite count and satellite icon

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
    -- Check if RX is connected using telemetry link quality (LQ)
    local lq = tonumber(getValue("RQly")) or 0
    if lq > 0 then

	   -- Define positions
		local xRight = widget.zone.x + widget.zone.w - 10
		local xLeft = widget.zone.x + 10
		local yStart = widget.zone.y + 5
		local lineHeight = 15
		
		
		-- Get telemetry data
		local sats = tonumber(getValue("Sats")) or 0
		local gpsLatLon = getValue("GPS")

		-- Validate GPS data
		if type(gpsLatLon) ~= "table" then
			lcd.drawText(xRight, yStart, "No GPS", RIGHT + MIDSIZE + WHITE + SHADOWED)
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

		-- Define positions
		local xRight = widget.zone.x + widget.zone.w - 10
		local xLeft = widget.zone.x + 10
		local yStart = widget.zone.y + 5
		local lineHeight = 15

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
		lcd.drawBitmap(icon, xRight - 145, yStart + 10)

		-- Draw GPS Data
		lcd.drawText(xRight, yStart, string.format("Sats: %d", sats), RIGHT + MIDSIZE + WHITE + SHADOWED)
		lcd.drawText(xRight, yStart + 5 + lineHeight * 2, string.format("Lat: %.6f", latitude), RIGHT + SMLSIZE + WHITE)
		lcd.drawText(xRight, yStart + 5 + lineHeight * 3, string.format("Lon: %.6f", longitude), RIGHT + SMLSIZE + WHITE)
	
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
