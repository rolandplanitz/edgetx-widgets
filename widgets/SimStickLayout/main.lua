-- Basic LUA Script with Date and Time Widget
-- Displays the current date and time with a modified date format
local textStyle = WHITE + SHADOWED
local midLineHeight = 25
local lineHeight = 18
local xLeft = 10
local yStart = 5

-- Function to create the widget
local function create(zone, options)
    local widget = {
      zone = zone,
      cfg = options,
    }
  
    idTxV = getFieldInfo('tx-voltage').id
    local _, rv = getVersion()
    widget.DEBUG = string.sub(rv, -5) == "-simu"
  
    vcache = {}
  
    -- stick labels and ids
    sticks = {
        {name = 'A', idX = getFieldInfo('ail').id, idY = getFieldInfo('ele').id, align = RIGHT},
        {name = 'T', idX = getFieldInfo('thr').id, idY = getFieldInfo('rud').id, align = LEFT},
    }

      -- stick labels and ids
	sticksVales={
		{name='R', id=getFieldInfo('rud').id},
        {name='T', id=getFieldInfo('thr').id},
		{name='A', id=getFieldInfo('ail').id},
		{name='E', id=getFieldInfo('ele').id},
  }
  
    return widget
  end

local function drawSticksValues (x,y)
	for _, st in ipairs (sticksVales) do
    lcd.drawText (x, y,
      st.name .. ":" .. math.floor (0.5 + getValue(st.id)/10.24),
      textStyle
      )
    x = x + 120
	end
end

-- Custom function to draw a circle with a border and center color
local function drawCustomCircle(x, y, outerRadius, innerRadius, borderColor, centerColor)
    -- Function to draw a pixel
    local function drawPixel(x, y, color)
        lcd.drawPoint(x, y, color)
    end

    -- Function to draw a filled circle
    local function drawFilledCircle(x, y, radius, color)
        for i = -radius, radius do
            for j = -radius, radius do
                if i * i + j * j <= radius * radius then
                    drawPixel(x + i, y + j, color)
                end
            end
        end
    end

    -- Draw the outer circle (border)
    drawFilledCircle(x, y, outerRadius, borderColor)
    -- Draw the inner circle (center)
    drawFilledCircle(x, y, innerRadius, centerColor)
end

-- Function to draw the stick positions as 2-axis charts
local function drawSticks(widget)
    local axisLength = 45
    local axisThickness = 1

    -- Calculate center positions
    local centerX = widget.zone.x + widget.zone.w / 2
    local centerY = widget.zone.y + widget.zone.h / 2 + 10

    -- Draw T-R axis chart (left)
    local xTR = centerX - 80 -- Adjust offset as needed
    local yTR = centerY
    --lcd.drawText(xTR, yTR - axisLength - 10, "T-R", textStyle + MIDSIZE)
    for i = -axisThickness, axisThickness do
        lcd.drawLine(xTR - axisLength, yTR + i, xTR + axisLength, yTR + i, SOLID, WHITE) -- X-axis
        lcd.drawLine(xTR + i, yTR + axisLength, xTR + i, yTR - axisLength, SOLID, WHITE) -- Y-axis
    end
    local stickT = getValue(sticks[2].idX) or 0
    local stickR = getValue(sticks[2].idY) or 0
    local plotTX = xTR + (stickR / 1024) * axisLength -- Switched T and R axes
    local plotTY = yTR - (stickT / 1024) * axisLength -- Switched T and R axes
    lcd.drawCircle(plotTX, plotTY, 7, SOLID, WHITE) -- Draw larger circle with white border
    drawCustomCircle(plotTX, plotTY, 7, 5, WHITE, GREEN) -- Draw custom circle

    -- Draw A-E axis chart (right)
    local xAE = centerX + 60 -- Adjust offset as needed
    local yAE = centerY
    --lcd.drawText(xAE, yAE - axisLength - 10, "A-E", textStyle + MIDSIZE)
    for i = -axisThickness, axisThickness do
        lcd.drawLine(xAE - axisLength, yAE + i, xAE + axisLength, yAE + i, SOLID, WHITE) -- X-axis
        lcd.drawLine(xAE + i, yAE + axisLength, xAE + i, yAE - axisLength, SOLID, WHITE) -- Y-axis
    end
    local stickA = getValue(sticks[1].idX) or 0
    local stickE = getValue(sticks[1].idY) or 0
    local plotAX = xAE + (stickA / 1024) * axisLength
    local plotAY = yAE - (stickE / 1024) * axisLength
    drawCustomCircle(plotAX, plotAY, 7, 5, WHITE, GREEN) -- Draw custom circle
   -- lcd.drawText(plotAX + 5, plotAY, sticks[1].name, textStyle + SMLSIZE)

end

-- Function to refresh the widget display
local function refresh(widget, event, touchState)

    drawSticks (widget)
    drawSticksValues (xLeft + 30, yStart)

end

return {
    name = "SimStickLayout",
    options = {},
    create = create,
    update = update,
    refresh = refresh,
}
