local addon, ns = ...
local cfg = ns.cfg

local SVal = function(val)
	if val then
		if (val >= 1e6) then
			return ("%.1fm"):format(val / 1e6)
		elseif (val >= 1e3) then
			return ("%.1fk"):format(val / 1e3)
		else
			return ("%d"):format(val)
		end
	end
end

local function hex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end

pcolors = setmetatable({
	power = setmetatable({
		["MANA"] = {0.14, 0.35, 1.0},
		["RAGE"] = {1.0, 0.0, 0.0},
--		["RUNIC_POWER"] = {0.44, 0.44, 0.44},
		["FOCUS"] = {1.0,0.75,0.25},
		["ENERGY"] = {0.9, 0.7, 0.1},
		["HAPPINESS"] = {0.0, 1.0, 1.0},
		--["RUNES"] = {0.50, 0.50, 0.50},
		["AMMOSLOT"] = {0.80, 0.60, 0.00},
		["FUEL"] = {0.0, 0.55, 0.5},
		["SOUL_SHARDS"] = {0.46, 0.32, 0.87},
		["POWER_TYPE_HEAT"] = {0.55,0.57,0.61},
      	["POWER_TYPE_OOZE"] = {0.76,1,0},
      	["POWER_TYPE_BLOOD_POWER"] = {0.7,0,1},
	}, {__index = oUF.colors.power}),
}, {__index = oUF.colors})

oUF.Tags["karma:lfdrole"] = function(unit)
	local role = UnitGroupRolesAssigned(unit)
	if role == "HEALER" then
		return "|cff8AFF30Heals|r"
	elseif role == "TANK" then
		return "|cffFFF130Tank|r"
	elseif role == "DAMAGER" then
		return "|cffFF6161DPS|r"
	end
end
	
oUF.TagEvents["karma:lfdrole"] = "PARTY_MEMBERS_CHANGED PLAYER_ROLES_ASSIGNED"

oUF.Tags['karma:hp']  = function(u) 
  if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
    return oUF.Tags['karma:DDG'](u)
  else
	local per = oUF.Tags['perhp'](u).."%" or 0
    local min, max = UnitHealth(u), UnitHealthMax(u)
    if u == "player" or u == "target" then
      if min~=max then 
        return "|cFFFFAAAA"..SVal(min).."|r/"..SVal(max).."   "..per
      else
        return SVal(max).."   "..per
      end
    else
      return per
    end
  end
end
oUF.TagEvents['karma:hp'] = 'UNIT_HEALTH'

oUF.Tags['karma:raidhp']  = function(u) 
  if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
    return oUF.Tags['karma:DDG'](u)
  else
	local per = oUF.Tags['perhp'](u).."%" or 0
    return per
  end
end
oUF.TagEvents['karma:raidhp'] = 'UNIT_HEALTH'

oUF.Tags['karma:color'] = function(u, r)
	local _, class = UnitClass(u)
	local reaction = UnitReaction(u, "player")
	
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return "|cffA0A0A0"
	elseif (UnitIsTapped(u) and not UnitIsTappedByPlayer(u)) then
		return hex(oUF.colors.tapped)
	--elseif (u == "pet") and GetPetHappiness() then
		--return hex(oUF.colors.happiness[GetPetHappiness()])
	elseif (UnitIsPlayer(u)) then
		return hex(oUF.colors.class[class])
	elseif reaction then
		return hex(oUF.colors.reaction[reaction])
	else
		return hex(1, 1, 1)
	end
end
oUF.TagEvents['karma:color'] = 'UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS'

oUF.Tags["karma:afkdnd"] = function(unit) 
	
	return UnitIsAFK(unit) and "|cffCFCFCF <afk>|r" or UnitIsDND(unit) and "|cffCFCFCF <dnd>|r" or ""
end
oUF.TagEvents["karma:afkdnd"] = 'PLAYER_FLAGS_CHANGED UNIT_POWER UNIT_MAXPOWER'

oUF.Tags['karma:DDG'] = function(u)
	if UnitIsDead(u) then
		return "|cffCFCFCF Dead|r"
	elseif UnitIsGhost(u) then
		return "|cffCFCFCF Ghost|r"
	elseif not UnitIsConnected(u) then
		return "|cffCFCFCF D/C|r"
	end
end
oUF.TagEvents['karma:DDG'] = 'UNIT_HEALTH'

oUF.Tags['karma:power']  = function(u) 
	local min, max = UnitPower(u), UnitPowerMax(u)
	if min~=max then 
		return SVal(min).."/"..SVal(max)
	else
		return SVal(max)
	end
end
oUF.TagEvents['karma:power'] = 'UNIT_POWER UNIT_MAXPOWER'

oUF.Tags['karma:pp'] = function(u)
    if u == "player" or u == "target" and UnitLevel(u) < 0 then 
		local _, str = UnitPowerType(u)
		if str then
			return hex(pcolors.power[str] or {250/255,  75/255,  60/255})..SVal(UnitPower(u))
		end
	end
end
oUF.TagEvents['karma:pp'] = 'UNIT_POWER UNIT_MAXPOWER'

-- Level
oUF.Tags["karma:level"] = function(unit)
	
	local c = UnitClassification(unit)
	local l = UnitLevel(unit)
	local d = GetQuestDifficultyColor(l)
	
	local str = l
		
	if l <= 0 then l = "??" end
	
	if c == "worldboss" then
		str = string.format("|cff%02x%02x%02xBoss|r",250,20,0)
	elseif c == "eliterare" then
		str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r+",d.r*255,d.g*255,d.b*255,l)
	elseif c == "elite" then
		str = string.format("|cff%02x%02x%02x%s|r+",d.r*255,d.g*255,d.b*255,l)
	elseif c == "rare" then
		str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r",d.r*255,d.g*255,d.b*255,l)
	else
		if not UnitIsConnected(unit) then
			str = "??"
		else
			if UnitIsPlayer(unit) then
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			elseif UnitPlayerControlled(unit) then
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			else
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			end
		end		
	end
	
	return str
end
oUF.TagEvents["karma:level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

oUF.UnitlessTagEvents.PLAYER_REGEN_DISABLED = true
oUF.UnitlessTagEvents.PLAYER_REGEN_ENABLED = true