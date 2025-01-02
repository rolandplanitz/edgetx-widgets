-- Widget LUA Script: Battery Widget
-- Displays RXBt, Curr, and Capa values with specific behaviors and icons

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

local function refresh(widget, event, touchState)

	-- Define positions
	local xRight = widget.zone.x + widget.zone.w - 10
	local xLeft = widget.zone.x + 10
	local yStart = widget.zone.y + 35

	local tpwr = tonumber(getValue("TPWR")) or 0
  
	if tpwr > 0 then

		-- Get telemetry data
		local rxBt = tonumber(getValue("RxBt")) or 0
		local curr = tonumber(getValue("Curr")) or 0
		local capa = tonumber(getValue("Capa")) or 0

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
		lcd.drawBitmap(icon, xRight - 55, yStart -35)

		-- Draw RXBt
		lcd.drawText(xRight, yStart, string.format("%.2fV", rxBt), textStyle + MIDSIZE)

		-- Draw Curr
		lcd.drawText(xRight, yStart + midLineHeight, string.format("Curr: %.2fA", curr), textStyle)

		-- Draw Capa
		lcd.drawText(xRight, yStart + midLineHeight + lineHeight, string.format("Cap: %dmAh", capa), textStyle)
		
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
