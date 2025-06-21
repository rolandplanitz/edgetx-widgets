-- SimStick Widget: Displays stick positions visually with A-E and T-R axes
local textStyle = WHITE + SHADOWED
local midLineHeight = 25
local lineHeight = 18
local xLeft = 10
local yStart = 5

local options = {
  -- move values down
  { "values_down", BOOL, 0 },

  -- move sticks out
  { "sticks_out", BOOL, 0 },
}

-- Stick field IDs (initialized once)
local fieldInfo = {
    rud = getFieldInfo('rud').id,
    thr = getFieldInfo('thr').id,
    ail = getFieldInfo('ail').id,
    ele = getFieldInfo('ele').id
}

-- Stick layout definitions
local sticks = {
    {name = 'A', idX = fieldInfo.ail, idY = fieldInfo.ele, align = RIGHT},
    {name = 'T', idX = fieldInfo.rud, idY = fieldInfo.thr, align = LEFT}
}

local stickValues = {
    {name = 'R', id = fieldInfo.rud},
    {name = 'T', id = fieldInfo.thr},
    {name = 'A', id = fieldInfo.ail},
    {name = 'E', id = fieldInfo.ele},
}

-- Widget create function
local function create(zone, options)
    return {
        zone = zone,
        cfg = options or {},
        DEBUG = string.sub(select(2, getVersion()), -5) == "-simu"
    }
end

-- Widget update (required)
local function update(widget, options)
    widget.cfg = options
end

-- Draw stick values numerically
local function drawStickValues(x, y)
    for _, st in ipairs(stickValues) do
        local value = getValue(st.id) or 0
        lcd.drawText(x, y, st.name .. ":" .. math.floor(0.5 + value / 10.24), textStyle)
        x = x + 120
    end
end

-- Draw filled circle with border
local function drawCustomCircle(x, y, outerRadius, innerRadius, borderColor, centerColor)
    for i = -outerRadius, outerRadius do
        for j = -outerRadius, outerRadius do
            local dist2 = i * i + j * j
            local rOut2 = outerRadius * outerRadius
            local rIn2 = innerRadius * innerRadius
            if dist2 <= rOut2 then
                lcd.drawPoint(x + i, y + j, dist2 <= rIn2 and centerColor or borderColor)
            end
        end
    end
end

-- Draw 2D stick chart (T-R and A-E)
local function drawSticks(widget)
    local axisLength = 45
    local centerX = widget.zone.x + widget.zone.w / 2
    local centerY = widget.zone.y + widget.zone.h / 2 + 10

    local leftX = centerX - 80
    local rightX = centerX + 60

    -- move sticks slighly up
    if widget.cfg.sticks_out == 1 then
      centerY = centerY - 15
      leftX = leftX - 100
      rightX = rightX + 120
    end

    local function drawAxesAndStick(posX, posY, idX, idY)
        for i = -1, 1 do
            lcd.drawLine(posX - axisLength, posY + i, posX + axisLength, posY + i, SOLID, WHITE)
            lcd.drawLine(posX + i, posY - axisLength, posX + i, posY + axisLength, SOLID, WHITE)
        end
        local valX = getValue(idX) or 0
        local valY = getValue(idY) or 0
        local plotX = posX + (valX / 1024) * axisLength
        local plotY = posY - (valY / 1024) * axisLength
        drawCustomCircle(plotX, plotY, 7, 5, WHITE, GREEN)
    end

    -- T-R chart (left) and A-E chart (right)
    drawAxesAndStick(leftX, centerY, sticks[2].idX, sticks[2].idY)  -- R = X, T = Y
    drawAxesAndStick(rightX, centerY, sticks[1].idX, sticks[1].idY)  -- A = X, E = Y
end

-- Main refresh function
local function refresh(widget, event, touchState)
    drawSticks(widget)

    if widget.cfg.values_down == 0 then
      drawStickValues(xLeft + 30, yStart)
    else
      drawStickValues(xLeft + 30, 130)
    end
end

-- Widget registration
return {
    name = "SimStick",
    options = options,
    create = create,
    update = update,
    refresh = refresh,
}
