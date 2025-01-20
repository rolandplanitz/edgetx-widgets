-- Define positions
local xLeft = 10
local yStart = 5
local lineHeight = 18
local midLineHeight = 25
local textStyle = WHITE + LEFT + SHADOWED
local textStyleRight = RIGHT + WHITE + SHADOWED

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

-- Function to draw the battery icon based on voltage
local function drawBatteryIcon()

  local vBatt = tonumber(getValue(idTxV)) or 0
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

end

local function drawDateAndTime(widget)

  local datetime = getDateTime()
  if not datetime then
      lcd.drawText(widget.zone.x + 10, widget.zone.y + 10, "No Date/Time", MIDSIZE + RED)
      return
  end

  -- Convert month to 3-letter abbreviation
  local months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
  local monthStr = months[datetime.mon] or "???"

  local timeStr = string.format("%02d:%02d", datetime.hour, datetime.min)
  local dateStr = string.format("%02d %s", datetime.day, monthStr)

  -- Define positions
  local xRight = widget.zone.x + widget.zone.w - 10
  local yStart = widget.zone.y + 5

  -- Draw Date and Time Block
  lcd.drawText(xRight, yStart, timeStr, textStyleRight + MIDSIZE)
  lcd.drawText(xRight, yStart + midLineHeight, dateStr, textStyleRight)

end

local function refresh(widget, event, touchState)

	-- Draw Model Name
  lcd.drawText(xLeft, yStart, "dbarrios83", textStyle + MIDSIZE + BOLD)
  lcd.drawText(xLeft, yStart + 2*lineHeight, "Simulator", textStyle)

  drawBatteryIcon()

  drawDateAndTime(widget)

  --drawSticks (xLeft - 2, yStart + 5 + 5*lineHeight)

end

return {
  name = "SimModel",
  options = {},
  create = create,
  update = update,
  refresh = refresh,
  options = {}
}
