-- Widget LUA Script: Battery Widget
-- Displays RXBt, Curr, and Capa values with specific behaviors and icons

local textStyle = RIGHT + WHITE + SHADOWED
local midLineHeight = 33
local lineHeight = 18

-- Function to get the voltage per cell using the vbat as input
local function getVoltagePerCell(rxBt)
    -- Define the typical voltage range for a LiPo cell
	local maxCellVoltage = 4.35
    local minCellVoltage = 3.0

    -- Check if vbat is greater than a minimum threshold to be considered a valid battery voltage
    if rxBt > 5 then
        -- Calculate the estimated cell count


		-- try to lock on to the cell count, so as the voltage sags we don't change S
		local estimatedCellCount = math.floor(rxBt / maxCellVoltage) + 1  -- At least 1 cell

        -- Calculate the average voltage per cell
        local averageVoltagePerCell = rxBt / estimatedCellCount

        -- Ensure the average voltage per cell is within a reasonable range
        if averageVoltagePerCell >= minCellVoltage and averageVoltagePerCell <= maxCellVoltage then
            return averageVoltagePerCell, estimatedCellCount
        else
            return rxBt, 1
        end
    else
        return rxBt, 1
    end
end

local function drawBatteryTelemetry(widget)

	-- Define positions
	local xRight = widget.zone.x + widget.zone.w - 10
	local xLeft = widget.zone.x + 10
	local yStart = widget.zone.y + 15
	
	local totalBatt = tonumber(tonumber(getValue("RxBt"))) or 0

	local voltagePerCell, cellCount = getVoltagePerCell(totalBatt)
	local rxBt = tonumber(voltagePerCell) or 0

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
	lcd.drawBitmap(icon, xRight - 22, yStart - 2)

	-- Draw RXBt

	if cellCount > 1 then
		lcd.drawText(xRight - 25, yStart + 2 , string.format("%.2fV", rxBt) .. "-" .. cellCount .. "S ", textStyle + MIDSIZE)
		--lcd.drawText(xRight - 26 , yStart - 4 + lineHeight, cellCount .. "S ", textStyle)
	else
		lcd.drawText(xRight - 29, yStart + 2, string.format("%.1fV", rxBt), textStyle + MIDSIZE) 
	end
	-- Draw Curr
	lcd.drawText(xRight, yStart + midLineHeight, string.format("Curr: %.2fA", curr), textStyle)

	-- Draw Capa
	lcd.drawText(xRight, yStart + midLineHeight + lineHeight, string.format("Cap: %dmAh", capa), textStyle)

end

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

	local tpwr = tonumber(getValue("TPWR")) or 0
  
	if tpwr > 0 then

		-- draw telemetry data
		drawBatteryTelemetry(widget)
		
	end
	
end

return {
    name = "BattWidget",
    options = {},
    create = create,
    update = update,
    refresh = refresh,

}
