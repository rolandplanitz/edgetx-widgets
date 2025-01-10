-- Define positions
local xLeft = 10
local yStart = 5
local lineHeight = 18
local textStyle = WHITE + LEFT + SHADOWED

local idTxV
  
-- Variables used across all instances
local vcache -- valueId cache
local mod = {} -- module info

local function getV(id)
  -- Return the getValue of ID or nil if it does not exist
  local cid = vcache[id]
  if cid == nil then
    local info = getFieldInfo(id)
    -- use 0 to prevent future lookups
    cid = info and info.id or 0
    vcache[id] = cid
  end
  return cid ~= 0 and getValue(cid) or nil
end

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

	-- Draw Model Name
  lcd.drawText(xLeft, yStart, "dbarrios83", textStyle + MIDSIZE + BOLD)

  local txName = "Simulator"
  local vBatt = tonumber(getValue(idTxV)) or 0

  lcd.drawText(xLeft, yStart + 2*lineHeight, txName, textStyle)
  lcd.drawText(xLeft + 55, yStart + 8 + 3 * lineHeight, string.format("%.2fV", vBatt), textStyle + MIDSIZE)
  
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
	lcd.drawBitmap(icon, xLeft - 2, yStart + 5 + 3*lineHeight)

  drawSticks (xLeft - 2, yStart + 5 + 5*lineHeight)

end

return {
  name = "SimModel",
  options = {},
  create = create,
  update = update,
  refresh = refresh,
  options = {}
}

