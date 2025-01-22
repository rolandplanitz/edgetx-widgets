-- Define positions
local xLeft = 10
local yStart = 5
local lineHeight = 18
local textStyle = WHITE + LEFT + SHADOWED

local idTxV
  
-- Variables used across all instances
local sticks 
local mod = {} -- module info


local function create(zone, options)

  local widget = {
    zone = zone,
    cfg = options,
  }

  idTxV = getFieldInfo('tx-voltage').id

    -- stick labels and ids
	sticks={
		{name='A', id=getFieldInfo('ail').id},
		{name='E', id=getFieldInfo('ele').id},
		{name='T', id=getFieldInfo('thr').id},
		{name='R', id=getFieldInfo('rud').id},
  }

  return widget
end

local function update(widget, options)
  -- Runs if options are changed from the Widget Settings menu
  widget.cfg = options
end


local function drawSticks (x,y)
	for _, st in ipairs (sticks) do
    lcd.drawText (x, y,
      st.name .. ":" .. math.floor (0.5 + getValue(st.id)/10.24),
      textStyle
      )
    x = x + 50
	end
end

local function refresh(widget, event, touchState)
  
  -- Get model name
  local modelName = model.getInfo().name or "Unknown"

	-- Draw Model Name
  lcd.drawText(xLeft, yStart, modelName, textStyle + MIDSIZE + BOLD)
  
  --local txName = mod.vStr or "Initializing"

    -- o/s version
	local _, _, major, minor, rev, osname = getVersion()
	strVer = (osname or "EdgeTX") .. " " .. major .. "." .. minor.. "." .. rev


  lcd.drawText(xLeft, yStart + 2*lineHeight, strVer, textStyle + SMLSIZE)
  local vBatt = tonumber(getValue(idTxV)) or 0
  lcd.drawText(xLeft , yStart + 8 + 3*lineHeight, string.format("%.1fV", vBatt), textStyle + MIDSIZE)
  
  -- Determine battery icon based on RXBt vBatt
	local iconPath = "/WIDGETS/ModelWidget/BMP/battery-%s.png"
	local iconState
  if vBatt < 7.1 then
		iconState = "low"
	elseif vBatt < 7.5 then
		iconState = "yellow"
	elseif vBatt < 7.9 then
		iconState = "ok"
	else
		iconState = "full"
	end
	local icon = Bitmap.open(string.format(iconPath, iconState))

	-- Draw battery icon
	lcd.drawBitmap(icon, xLeft + 55 , yStart + 5 + 3*lineHeight)

  drawSticks (xLeft, yStart + 5 + 5*lineHeight)

end

return {
  name = "ModelWidget",
  options = {},
  create = create,
  update = update,
  refresh = refresh
}

