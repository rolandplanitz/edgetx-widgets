--196x169 right half
--392x84 top half
--196x56 1 + 3
--196x42 1 + 4

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
  return widget
end

local function update(widget, options)
  -- Runs if options are changed from the Widget Settings menu
  widget.cfg = options
end


local function fieldGetString(data, off)
  local startOff = off
  while data[off] ~= 0 do
    data[off] = string.char(data[off])
    off = off + 1
  end

  return table.concat(data, nil, startOff, off - 1), off + 1
end

local function parseDeviceInfo(data)
  if data[2] ~= 0xEE then return end -- only interested in TX info
  local name, off = fieldGetString(data, 3)
  mod.name = name
  -- off = serNo ('ELRS') off+4 = hwVer off+8 = swVer
  mod.vMaj = data[off+9]
  mod.vMin = data[off+10]
  mod.vRev = data[off+11]
  mod.vStr = string.format("%s (%d.%d.%d)", mod.name, mod.vMaj, mod.vMin, mod.vRev)
  return true
end

local function updateElrsVer()
  local command, data = crossfireTelemetryPop()
  if command == 0x29 then
    if parseDeviceInfo(data) then
      -- Get rid of all the functions, only update once
      parseDeviceInfo = nil
      fieldGetString = nil
      updateElrsVer = nil
      mod.lastUpd = nil
    end
    return
  end

  local now = getTime()
  -- Poll the module every second
  if (mod.lastUpd or 0) + 100 < now then
    crossfireTelemetryPush(0x28, {0x00, 0xEA})
    mod.lastUpd = now
  end
end

local function refresh(widget, event, touchState)

  if updateElrsVer then updateElrsVer() end
  
  -- Get model name
  local modelName = model.getInfo().name or "Unknown"

	-- Draw Model Name
  lcd.drawText(xLeft, yStart, modelName, textStyle + MIDSIZE + BOLD)

  local tlm = { tpwr = getV("TPWR") }
  local txName = mod.vStr or "Initializing"
  lcd.drawText(xLeft, yStart + 2*lineHeight, txName, textStyle)
  local vBatt = tonumber(getValue(idTxV)) or 0
  lcd.drawText(xLeft + 55, yStart + 8 + 3*lineHeight, string.format("%.2fV", vBatt), textStyle + MIDSIZE)
  
  -- Determine battery icon based on RXBt value
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

return {
  name = "ModelWidget",
  options = {},
  create = create,
  update = update,
  refresh = refresh,
  options = {}
}

