-- Widget LUA Script: Battery Widget
-- Displays RXBt, Curr, and Capa values with specific behaviors and icons

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

	local lq = tonumber(getValue("RQly")) or 0
	
		if lq > 0 then
	
			-- Get telemetry data
			local rxBt = tonumber(getValue("RxBt")) or 0
			local curr = tonumber(getValue("Curr")) or 0
			local capa = tonumber(getValue("Capa")) or 0

			-- Define positions
			local xRight = widget.zone.x + widget.zone.w - 10
			local xLeft = widget.zone.x + 10
			local yStart = widget.zone.y + 5
			local lineHeight = 20
			local smlLineHeight = 18

			-- Determine battery icon based on RXBt value
			local iconPath = "/WIDGETS/BattWidget/BMP/battery-%s.png"
			local iconState
			if rxBt < 3.2 then
				iconState = "dead"
			elseif rxBt < 3.6 then
				iconState = "low"
			elseif rxBt < 3.8 then
				iconState = "yellow"
			elseif rxBt < 4.0 then
				iconState = "ok"
			else
				iconState = "full"
			end
			local icon = Bitmap.open(string.format(iconPath, iconState))

			-- Draw battery icon
			lcd.drawBitmap(icon, xRight - 105, yStart + 5)

			-- Draw RXBt
			lcd.drawText(xRight, yStart, string.format("%.2fV", rxBt), RIGHT + MIDSIZE + WHITE + SHADOWED)

			-- Draw Curr
			lcd.drawText(xRight, yStart + 8 + lineHeight, string.format("Curr: %.2fA", curr), RIGHT + SMLSIZE + WHITE)

			-- Draw Capa
			lcd.drawText(xRight, yStart + 8 + 2 * smlLineHeight, string.format("Cap: %dmAh", capa), RIGHT + SMLSIZE + WHITE)
			
		end
end

local function background(widget)
    -- No background tasks needed for this widget
end

return {
    name = "BattWidget",
    options = {},
    create = create,
    update = update,
    refresh = refresh,
    background = background,
}
