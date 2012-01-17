  local addon, ns = ...
  local cfg = ns.cfg
  local cast = ns.cast
  local lib = CreateFrame("Frame")  
  local _, playerClass = UnitClass("player")

  oUF.colors.power['MANA'] = {0.0, 0.56, 1.0}
  oUF.colors.power['RAGE'] = {1.0,0,0}
  oUF.colors.power['FOCUS'] = {1.0,0.75,0.25}
  oUF.colors.power['ENERGY'] = {0.9, 0.7, 0.1}
--  oUF.colors.power['RUNIC_POWER'] = {0.44,0.44,0.44}
  oUF.colors.power['AMMOSLOT'] = {0.8,0.6,0}
  oUF.colors.power['FUEL'] = {0,0.55,0.5}
  oUF.colors.power['POWER_TYPE_STEAM'] = {0.55,0.57,0.61}
  oUF.colors.power['POWER_TYPE_PYRITE'] = {0.6,0.09,0.17}
  oUF.colors.power['POWER_TYPE_HEAT'] = {0.9,0.45,0.1}
  oUF.colors.power['POWER_TYPE_OOZE'] = {0.1,0.1,0.9}
  oUF.colors.power['POWER_TYPE_BLOOD_POWER'] = {0.9,0.1,0.1}
  local _, pType = UnitPowerType("player")
  local pcolor = oUF.colors.power[pType] or {.3,.45,.65}
  oUF.colors.runes = {{196/255, 30/255, 58/255};{173/255, 217/255, 25/255};{35/255, 127/255, 255/255};{178/255, 53/255, 240/255};}
    
  -- FUNCTIONS
 
 local retVal = function(f, val1, val2, val3)
	if f.mystyle == "player" or f.mystyle == "target" then
		return val1
	elseif f.mystyle == "raid" or f.mystyle == "party" then
		return val3
	else
		return val2
	end
end
  
  --status bar filling fix (from oUF_Mono)
  local fixStatusbar = function(b)
    b:GetStatusBarTexture():SetHorizTile(false)
    b:GetStatusBarTexture():SetVertTile(false)
  end

  --backdrop table
  local backdrop_tab = { 
    bgFile = cfg.backdrop_texture, 
    edgeFile = cfg.backdrop_edge_texture,
    tile = false,
    tileSize = 0, 
    edgeSize = 5, 
    insets = { 
      left = 3, 
      right = 3, 
      top = 3, 
      bottom = 3,
    },
  }
  
-- backdrop func
lib.gen_backdrop = function(f)
	f:SetBackdrop(backdrop_tab);
	f:SetBackdropColor(0,0,0,1)
	f:SetBackdropBorderColor(0,0,0,0.8)
end

lib.gen_castbackdrop = function(f)
	f:SetBackdrop(backdrop_tab);
	f:SetBackdropColor(0,0,0,0.6)
	f:SetBackdropBorderColor(0,0,0,1)
end
  
lib.gen_totemback = function(f)
	f:SetBackdrop(backdrop_tab);
	f:SetBackdropColor(0,0,0,0.6)
	f:SetBackdropBorderColor(0,0,0,0.8)
end
--right click menu------
lib.spawnMenu = function(self)
	local dropdown = CreateFrame("Frame", "MyAddOnUnitDropDownMenu", UIParent, "UIDropDownMenuTemplate")
	UIDropDownMenu_Initialize(dropdown, function(self)
		local unit = self:GetParent().unit
		if not unit then return end

		local menu, name, id
		if UnitIsUnit(unit, "player") then
		menu = "SELF"
		elseif UnitIsUnit(unit, "vehicle") then
			menu = "VEHICLE"
		elseif UnitIsUnit(unit, "pet") then
			menu = "PET"
		elseif UnitIsPlayer(unit) then
			id = UnitInRaid(unit)
			if id then
				menu = "RAID_PLAYER"
				name = GetRaidRosterInfo(id)
			elseif UnitInParty(unit) then
				menu = "PARTY"
			else
				menu = "PLAYER"
			end
		else
			menu = "TARGET"
			name = RAID_TARGET_ICON
		end
		if menu then
			UnitPopup_ShowMenu(self, menu, unit, name, id)
		end
	end, "MENU")


	dropdown:SetParent(self)
	ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)

	
	--remove SET_FOCUS & CLEAR_FOCUS from menu, to prevent errors
	do 
		for k,v in pairs(UnitPopupMenus) do
			for x,y in pairs(UnitPopupMenus[k]) do
				if y == "SET_FOCUS" then
					table.remove(UnitPopupMenus[k],x)
				elseif y == "CLEAR_FOCUS" then
					table.remove(UnitPopupMenus[k],x)
				end
			end
		end
	end
end	
  
  --fontstring func
  lib.gen_fontstring = function(f, name, size, outline)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(name, size, outline)
    fs:SetShadowColor(0,0,0,0.8)
    fs:SetShadowOffset(1,-1)
    return fs
  end  
  
-->> Healthbar <<--
lib.gen_hpbar = function(f, unit, min, max)
    --statusbar--
    local s = CreateFrame("StatusBar", nil, f)
	s:SetStatusBarTexture(cfg.statusbar_texture)
	--s:SetOrientation("VERTICAL")	
	s:SetWidth(f:GetWidth())
    s:SetPoint("TOP",0,0)
    s:SetFrameLevel(4)	
	
	if f.mystyle == "player" then
		s:SetStatusBarTexture(cfg.statusbar_texture)
		--s:SetReverseFill(true)
		s:SetSize(512, 128)
	elseif f.mystyle == "target" then
		s:SetStatusBarTexture(cfg.tstatusbar_texture)
		s:SetSize(512, 128)
	elseif f.mystyle == "party" then
		s:SetStatusBarTexture(cfg.ostatusbar_texture)
		s:SetSize(128, 32)
		s:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
	elseif f.mystyle == "partytarget" then
		s:SetStatusBarTexture(cfg.statusbar_texture)
		s:SetSize(80)
	elseif f.mystyle == "pet" then
		s:SetStatusBarTexture(cfg.statusbar_texture)
		s:SetSize(128,16)
	elseif f.mystyle == "tot" or f.mystyle == "focus" or f.mystyle == "focustarget" then
		s:SetStatusBarTexture(cfg.ostatusbar_texture)
		s:SetSize(128, 32)
	else
		s:SetStatusBarTexture(cfg.statusbar_texture)
		s:SetSize(64, 16)
	end

	
	--helper
	local h = CreateFrame("StatusBar", nil, s)
	h:SetFrameLevel(0)
	h:SetAlpha(0)
	--bg
    local b = s:CreateTexture(nil, "BACKGROUND")
	if f.mystyle == "target" then
	b:SetTexture(cfg.tstatusbarbg_texture)	
	b:SetAllPoints(s)
	b:SetVertexColor(0.8, 0.05, 0.05, 0.75)
	elseif f.mystyle == "tot" or f.mystyle == "party" or f.mystyle == "focus" or f.mystyle == "focustarget" then
	b:SetTexture(cfg.ostatusbarbg_texture)
	b:SetAllPoints(s)
	b:SetVertexColor(0.8, 0.05, 0.05, 0.75)
    else
	b:SetTexture(cfg.statusbarbg_texture)
	b:SetAllPoints(s)
	b:SetVertexColor(0.8, 0.05, 0.05, 0.75)
	end

	f.Health = s
	f.Health.bg2 = b
  end
  
  --gen hp strings func
  lib.gen_hpstrings = function(f, unit)
    --creating helper frame here so our font strings don't inherit healthbar parameters
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(15)
    local fontsize
		if f.mystyle == "player" then fontsize = 32
		elseif f.mystyle == "target" then fontsize = 32
		elseif f.mystyle == "party" then fontsize = 15 
		elseif f.mystyle == "raid" then fontsize = 12
		else fontsize = 16 
	end 

	local name = lib.gen_fontstring(f.Health, cfg.font, retVal(f,18,16,14), "THINOUTLINE")
		if f.mystyle == "player" then
		name:SetPoint("RIGHT", f.Health, "RIGHT", 0, 0)
		name:SetJustifyH("LEFT")
		elseif f.mystyle == "party" then
		name:SetPoint("LEFT", f.Health, "BOTTOMLEFT", -2, 4)
		name:SetJustifyH("LEFT")
		elseif f.mystyle == "raid" then
		name:SetPoint("BOTTOM", f.Health, "BOTTOM", 0, -6)
		name:SetJustifyH("CENTER")
		elseif f.mystyle == "target" then
		name:SetPoint("LEFT", f.Health, "BOTTOMLEFT", 0, 3)
		name:SetJustifyH("LEFT")
		else
		name:SetPoint("LEFT", f.Health, "BOTTOMLEFT", 0, 3)
		name:SetJustifyH("LEFT")
	end
	
    local hpval = lib.gen_fontstring(f.Health, cfg.font, fontsize, "THINOUTLINE")
		if f.mystyle == "player" then
		hpval:SetPoint("LEFT", f.Health, "LEFT", 165, -3)
		hpval:SetJustifyH("RIGHT")
		elseif f.mystyle == "target" then
		hpval:SetPoint("RIGHT", f.Health, "RIGHT", -165, -3)
		hpval:SetJustifyH("LEFT")
		elseif f.mystyle == "party" then
		hpval:SetPoint("RIGHT", f.Health, "RIGHT", 6, -12)
		hpval:SetJustifyH("LEFT")
		elseif f.mystyle == "raid" then
		hpval:SetPoint("RIGHT", f.Health, "RIGHT", 4, 5)
		hpval:SetJustifyH("LEFT")
		else
		hpval:SetPoint("RIGHT", f.Health, "TOPRIGHT", retVal(f,4,0,-3), retVal(f,-44,-32,-17))
		hpval:SetJustifyH("RIGHT")
	end

	
	if f.mystyle == "player" or f.mystyle == "target" then
		name:SetPoint("RIGHT", f, "RIGHT", 4, -36)
	elseif f.mystyle == "raid" or f.mystyle == "party" then
		name:SetPoint("CENTER", f, "CENTER", 0, 6)
	elseif f.mystyle == "pet" then
		name:SetPoint("RIGHT", f, "RIGHT", 0, -12)	
	else
		name:SetPoint("RIGHT", hpval, "LEFT", -2, 0)
	end

	if f.mystyle == "player" then
		f:Tag(name, "[karma:afkdnd] [karma:pp]")
	elseif f.mystyle == "target" then
		f:Tag(name, "[karma:color][karma:afkdnd]")
	elseif f.mystyle == "raid" or f.mystyle == "party" then
		f:Tag(name, "[karma:color][name][karma:afkdnd]")
	else
		f:Tag(name, "[karma:color][name]")
	end
	if f.mystyle == "player" then
	f:Tag(hpval, "[karma:color][perhp]")
	else
	f:Tag(hpval, retVal(f,"[karma:color][perhp]","[karma:color][karma:hp]","[karma:color][karma:raidhp]"))
	end

	local level 
		if f.mystyle == "player" or f.mystyle == "target" then level = lib.gen_fontstring(f.Health, cfg.font, fontsize/2, "THINOUTLINE")
		--elseif f.mystyle == "target" then level = lib.gen_fontstring(f.Health, cfg.font, fontsize/2, "THINOUTLINE")
		end
	if f.mystyle == "player" and cfg.ShowPlayerName then
		level:SetPoint("TOPRIGHT", f.Health, "TOPRIGHT", -100, -30)
		level:SetJustifyH("RIGHT")
	elseif f.mystyle =="target" then
		level:SetPoint("TOPLEFT", f.Health, "TOPLEFT", 100, -30)
		level:SetJustifyH("LEFT")
	end
	if f.mystyle == "player" and cfg.ShowPlayerName then
		f:Tag(level, "[karma:level] [karma:color][name]")
	elseif f.mystyle =="target" then
		f:Tag(level, "[karma:color] [name] [karma:level]")
	end
end
  
  --gen powerbar func
  lib.gen_ppbar = function(f)
    --statusbar
	local s = CreateFrame("StatusBar", nil, f)
	if f.mystyle == "target" then
	s:SetStatusBarTexture(cfg.tpowerbar_texture)
	s:SetWidth(512)
	s:SetHeight(retVal(f,128,16,14))
	s:SetPoint("BOTTOM",f,"BOTTOM",0,-75)
	s:SetFrameLevel(1)
	elseif f.mystyle== "player" then
	s:SetStatusBarTexture(cfg.powerbar_texture)
	--s:SetReverseFill(true)
	s:SetWidth(512)
	s:SetHeight(retVal (f, 128,16,14))
	s:SetPoint("BOTTOM",f,"BOTTOM",0,-75)
	elseif f.mystyle == "tot" or f.mystyle == "party" then
	s:SetStatusBarTexture(cfg.opowerbar_texture)
	s:SetWidth(f:GetWidth())
	s:SetHeight(retVal(f,128,30,30))
	s:SetPoint("BOTTOM",f,"BOTTOM",0,0)
	s:SetFrameLevel(1)
	elseif f.mystyle == "focus" or f.mystyle == "focustarget" then
	s:SetStatusBarTexture(cfg.opowerbar_texture)
	s:SetWidth(f:GetWidth())
	s:SetHeight(retVal(f,128,30,30))
	s:SetPoint("BOTTOM",f,"BOTTOM",0,0)
	s:SetFrameLevel(1)
	else
	s:SetStatusBarTexture(cfg.powerbar_texture)
	s:SetWidth(f:GetWidth())
	s:SetHeight(retVal(f,128,16,14))
	s:SetPoint("BOTTOM",f,"BOTTOM",0,-75)
	s:SetFrameLevel(1)
	end
    --bg
    local b = s:CreateTexture(nil, "BACKGROUND")
	if f.mystyle == "target" then
	b:SetTexture(cfg.tpowerbarbg_texture)
    b:SetAlpha(0.9)
    b:SetPoint("BOTTOMLEFT", -1, 0)
	b:SetPoint("TOPRIGHT", 0, -1)
    f.Power = s
    f.Power.bg = b
	elseif f.mystyle == "tot" or f.mystyle == "party" then
	b:SetTexture(cfg.opowerbarbg_texture)
    b:SetAlpha(0.9)
    b:SetPoint("BOTTOMLEFT", -1, 0)
	b:SetPoint("TOPRIGHT", 0, -1)
    f.Power = s
    f.Power.bg = b
	elseif f.mystyle == "focus" or f.mystyle == "focustarget" then
	b:SetTexture(cfg.opowerbarbg_texture)
    b:SetAlpha(0.9)
    b:SetPoint("BOTTOMLEFT", -1, 0)
	b:SetPoint("TOPRIGHT", 0, -1)
    f.Power = s
    f.Power.bg = b
	else
	b:SetTexture(cfg.powerbarbg_texture)
    b:SetAlpha(0.9)
    b:SetPoint("TOPLEFT", -1, 0)
	b:SetPoint("BOTTOMRIGHT", 0, -1)
    f.Power = s
    f.Power.bg = b
    end
  end
  
  --gen combat and LFD icons
  lib.gen_InfoIcons = function(f)
    local h = CreateFrame("Frame",nil,f)
    h:SetAllPoints(f)
    h:SetFrameLevel(10)
    --combat icon
    if f.mystyle == 'player' then
		f.Combat = h:CreateTexture(nil, 'OVERLAY')
		f.Combat:SetSize(20,20)
		f.Combat:SetPoint('LEFT', -14, 15)
		f.Combat:SetTexture([[Interface\Addons\oUF_Lust\media\combat]])
    end
	-- rest icon
    if f.mystyle == 'player' then
		f.Resting = h:CreateTexture(nil, 'OVERLAY')
		f.Resting:SetSize(32,32)
		f.Resting:SetPoint('LEFT', -14, 15)
		f.Resting:SetTexture([[Interface\Addons\oUF_Lust\media\resting]])
		f.Resting:SetAlpha(0.75)
	end
    --Leader icon
    li = h:CreateTexture(nil, "OVERLAY")
    if f.mystyle == 'player' then
		li:SetPoint("BOTTOMLEFT", f.Health, 0, 36)
	else	
		li:SetPoint("BOTTOMLEFT", f.Health, -2, 14)
    end
	li:SetSize(16,16)
    f.Leader = li
    --Assist icon
    ai = h:CreateTexture(nil, "OVERLAY")
    ai:SetPoint("TOPLEFT", f, 0, 8)
    ai:SetSize(12,12)
    f.Assistant = ai
    --ML icon
    local ml = h:CreateTexture(nil, 'OVERLAY')
    ml:SetSize(16,16)
    ml:SetPoint('LEFT', f.Leader, 'RIGHT', 0, 2)
    f.MasterLooter = ml
  end

	-- LFG Role Indicator
	lib.gen_LFDRole = function(f)
		local lfdi = lib.gen_fontstring(f.Health, cfg.smallfont, 10, "THINOUTLINE")
		lfdi:SetPoint('TOP', f.Health, 'TOP', 0, -4)
		f:Tag(lfdi, "[karma:lfdrole]")
	end

	-- quest icon
	lib.addQuestIcon = function(self)
		local qicon = self.Health:CreateTexture(nil, 'OVERLAY')
		qicon:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 8)
		qicon:SetSize(16, 16)

		self.QuestIcon = qicon
	end

	--gen raid mark icons
  lib.gen_RaidMark = function(f)
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f)
    h:SetFrameLevel(10)
    h:SetAlpha(0.8)
    local ri = h:CreateTexture(nil,'OVERLAY',h)
    ri:SetPoint("CENTER", f.Health, "BOTTOM", -8, 18)
	ri:SetTexture([[Interface\Addons\oUF_Lust\media\raidicons.blp]])
	local size = retVal(f, 24, 14, 18)
    ri:SetSize(size, size)
    f.RaidIcon = ri
  end
  
    --gen hilight texture
  lib.gen_highlight = function(f)
    local OnEnter = function(f)
		UnitFrame_OnEnter(f)
		f.Highlight:Show()
    end
    local OnLeave = function(f)
      UnitFrame_OnLeave(f)
      f.Highlight:Hide()
    end
    f:SetScript("OnEnter", OnEnter)
    f:SetScript("OnLeave", OnLeave)
    local hl = f.Health:CreateTexture(nil, "OVERLAY")
    hl:SetAllPoints(f.Health)
	if f.mystyle == "target" then
	hl:SetTexture(cfg.tstatusbarbg_texture)
	hl:SetVertexColor(.5,.5,.5,.3)
    hl:SetBlendMode("ADD")
    hl:Hide()
    f.Highlight = hl
	elseif f.mystyle == "tot" or f.mystyle == "party" or f.mystyle == "focus" or f.mystyle == "focustarget" then
	hl:SetTexture(cfg.ostatusbar_texture)
	hl:SetVertexColor(.5,.5,.5,.3)
	hl:SetBlendMode("ADD")
	hl:Hide()
	f.Highlight = hl
	else
    hl:SetTexture(cfg.statusbar_texture)
    hl:SetVertexColor(.5,.5,.5,.3)
    hl:SetBlendMode("ADD")
    hl:Hide()
    f.Highlight = hl
	end
  end
  
  --gen trinket
  lib.gen_arenatracker = function(f)
    t = CreateFrame("Frame", nil, f)
    t:SetSize(20,20)
    t:SetPoint("TOP", f, "BOTTOM", 1, 4)
    t:SetFrameLevel(30)
    t:SetAlpha(0.8)
    t.trinketUseAnnounce = true
    t.bg = CreateFrame("Frame", nil, t)
    t.bg:SetPoint("TOPLEFT",-4,4)
    t.bg:SetPoint("BOTTOMRIGHT",4,-4)
    t.bg:SetBackdrop(backdrop_tab);
    t.bg:SetBackdropColor(0,0,0,0)
    t.bg:SetBackdropBorderColor(0,0,0,1)
	t.remaining = lib.gen_fontstring(t, cfg.font, 18, "THINOUTLINE")
	t.remaining:SetPoint('CENTER', t, 0, 0)
    t:SetScript("OnUpdate", CreateAuraTimer)
    f.Trinket = t
  end

  -- Create Target Border
	function lib.CreateTargetBorder(self)
		self.TargetBorder = self.Health:CreateTexture("OVERLAY", nil, self)
		self.TargetBorder:SetPoint("TOPLEFT", self.Health, "TOPLEFT", -12, 8)
		self.TargetBorder:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", 12, -28)
		self.TargetBorder:SetTexture([[Interface\Addons\oUF_Lust\media\target]])
		self.TargetBorder:SetVertexColor(1.0, 1.0, 0.1,0.6)
		self.TargetBorder:SetBlendMode("ADD")
		self.TargetBorder:Hide()
	end

	--[[ Raid Frames Target Highlight Border
	function lib.ChangedTarget(self, event, unit)
	
		if UnitIsUnit('target', self.unit) then
			self.TargetBorder:Show()
		else
			self.TargetBorder:Hide()
		end
	end
	
	-- Create Raid Threat Status Border
	function lib.CreateThreatBorder(self)
		
		local glowBorder = {edgeFile = cfg.backdrop_edge_texture, edgeSize = 5}
		self.Thtborder = CreateFrame("Frame", nil, self)
		self.Thtborder:SetPoint("TOPLEFT", self, "TOPLEFT", -8, 9)
		self.Thtborder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 9, -8)
		self.Thtborder:SetBackdrop(glowBorder)
		self.Thtborder:SetFrameLevel(1)
		self.Thtborder:Hide()	
	end
  
  	-- Raid Frames Threat Highlight
	function lib.UpdateThreat(self, event, unit)
	
		if (self.unit ~= unit) then return end
		
		local status = UnitThreatSituation(unit)
		unit = unit or self.unit
		
		if status and status > 1 then
			local r, g, b = GetThreatStatusColor(status)
			self.Thtborder:Show()
			self.Thtborder:SetBackdropBorderColor(r, g, b, 1)
		else
			self.Thtborder:SetBackdropBorderColor(r, g, b, 0)
			self.Thtborder:Hide()
		end
	end

  
-- raid post update
lib.PostUpdateRaidFrame = function(Health, unit, min, max)

	local disconnnected = not UnitIsConnected(unit)
	local dead = UnitIsDead(unit)
	local ghost = UnitIsGhost(unit)

	if disconnnected or dead or ghost then
		Health:SetValue(max)
		
		if(disconnnected) then
			Health:SetStatusBarColor(0,0,0,0.6)
		elseif(ghost) then
			Health:SetStatusBarColor(1,1,1,0.6)
		elseif(dead) then
			Health:SetStatusBarColor(1,0,0,0.7)
		end
	else
		Health:SetValue(min)
		if(unit == 'vehicle') then
			Health:SetStatusBarColor(22/255, 106/255, 44/255)
		end
	end
	
	if not UnitInRange(unit) then
		Health.bg2:SetVertexColor(.6, 0.3, 0.3,1)
	else
		Health.bg2:SetVertexColor(1, 0.1, 0.1,1)
	end
end]]--

-- Eclipse Bar function
local eclipseBarBuff = function(self, unit)
	if self.hasSolarEclipse then
		self.eBarBG:SetBackdropBorderColor(1,1,.5,.7)
	elseif self.hasLunarEclipse then
		self.eBarBG:SetBackdropBorderColor(.2,.2,1,.7)
	else
		self.eBarBG:SetBackdropBorderColor(0,0,0,1)
	end
end

lib.addEclipseBar = function(self)
	if playerClass ~= "DRUID" then return end
	
	local eclipseBar = CreateFrame('Frame', nil, self)
	eclipseBar:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, 2)
	eclipseBar:SetHeight(4)
	eclipseBar:SetWidth(self.Health:GetWidth())
	eclipseBar:SetFrameLevel(4)
	local h = CreateFrame("Frame", nil, eclipseBar)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	lib.gen_backdrop(h)
	eclipseBar.eBarBG = h

	local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
	lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
	lunarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
	lunarBar:SetStatusBarTexture(cfg.statusbar_texture)
	lunarBar:SetStatusBarColor(0, .1, .7)
	lunarBar:SetFrameLevel(5)

	local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
	solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
	solarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
	solarBar:SetStatusBarTexture(cfg.statusbar_texture)
	solarBar:SetStatusBarColor(1,1,.13)
	solarBar:SetFrameLevel(5)

    local EBText = lib.gen_fontstring(solarBar, cfg.font, 10, "OUTLINE")
	EBText:SetPoint('CENTER', eclipseBar, 'CENTER', 0, 0)
	self:Tag(EBText, '[pereclipse]')
	
	eclipseBar.SolarBar = solarBar
	eclipseBar.LunarBar = lunarBar
	self.EclipseBar = eclipseBar
	self.EclipseBar.PostUnitAura = eclipseBarBuff
end

-- SoulShard bar
lib.genShards = function(self)
	if playerClass ~= "WARLOCK" then return end
			local ssOverride = function(self, event, unit, powerType)
				if(self.unit ~= unit or (powerType and powerType ~= "SOUL_SHARDS")) then return end
				local ss = self.SoulShards
				local num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
				for i = 1, SHARD_BAR_NUM_SHARDS do
					if(i <= num) then
						ss[i]:SetAlpha(1)
					else
						ss[i]:SetAlpha(0.2)
					end
				end
			end
			
		local barFrame = CreateFrame("Frame", nil, self)
		barFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
		barFrame:SetHeight(4)
		barFrame:SetWidth(self:GetWidth())
		barFrame:SetFrameLevel(4)

		for i= 1, 3 do
			local shard = CreateFrame("StatusBar", nil, barFrame)
			shard:SetSize((self.Health:GetWidth() / 3)-6, 6)
			shard:SetStatusBarTexture(cfg.castbar_texture)
			shard:SetStatusBarColor(.86,.44, 1)
			shard:SetFrameLevel(4)
				
			local h = CreateFrame("Frame", nil, shard)
			h:SetFrameLevel(1)
			h:SetPoint("TOPLEFT",-5,5)
			h:SetPoint("BOTTOMRIGHT",5,-5)
			lib.gen_totemback(h)

		if (i == 1) then
			shard:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 3, 4)
		else
			shard:SetPoint("TOPLEFT", barFrame[i-1], "TOPRIGHT", 6, 0)
		end
		barFrame[i] = shard
	end
	self.SoulShards = barFrame
	self.SoulShards.Override = ssOverride
			
end			

-- HolyPowerbar
lib.genHolyPower = function(self)
	if playerClass ~= "PALADIN" then return end
		local hpOverride = function(self, event, unit, powerType)
				if(self.unit ~= unit or (powerType and powerType ~= "HOLY_POWER")) then return end
				
				local hp = self.HolyPower
				if(hp.PreUpdate) then hp:PreUpdate(unit) end
				
				local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)
				for i = 1, MAX_HOLY_POWER do
					if(i <= num) then
						hp[i]:SetAlpha(1)
					else
						hp[i]:SetAlpha(0.2)
					end
				end
			end
			
		local barFrame = CreateFrame("Frame", nil, self)
		barFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
		barFrame:SetHeight(4)
		barFrame:SetWidth(self:GetWidth())
		barFrame:SetFrameLevel(4)

		for i = 1, 3 do
			local holyShard = CreateFrame("StatusBar", self:GetName().."_Holypower"..i, self)
			holyShard:SetHeight(4)
			holyShard:SetWidth((self.Health:GetWidth() / 3)-6, 6)
			holyShard:SetStatusBarTexture(cfg.castbar_texture)
			holyShard:SetStatusBarColor(.9,.95,.33)
			holyShard:SetFrameLevel(4)
				
			local h = CreateFrame("Frame", nil, holyShard)
			h:SetFrameLevel(1)
			h:SetPoint("TOPLEFT",-5,5)
			h:SetPoint("BOTTOMRIGHT",5,-5)
			lib.gen_totemback(h)

		if (i == 1) then
			holyShard:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 3, 4)
		else
			holyShard:SetPoint("TOPLEFT", barFrame[i-1], "TOPRIGHT", 6, 0)
		end
		barFrame[i] = holyShard
	end
	self.HolyPower = barFrame
	self.HolyPower.Override = hpOverride
end

-- runebar
lib.genRunes = function(self)
	if playerClass ~= "DEATHKNIGHT" then return end

	local runeFrame = CreateFrame("Frame", nil, self)
	runeFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
	runeFrame:SetHeight(4)
	runeFrame:SetWidth(self:GetWidth())
	runeFrame:SetFrameLevel(4)
	
	for i= 1, 6 do
		local rune = CreateFrame("StatusBar", nil, runeFrame)
		rune:SetSize((self.Health:GetWidth() / 6)-6, 6)
		rune:SetStatusBarTexture(cfg.castbar_texture)
		rune:SetFrameLevel(4)
		
			local h = CreateFrame("Frame", nil, rune)
			h:SetFrameLevel(1)
			h:SetPoint("TOPLEFT",-5,5)
			h:SetPoint("BOTTOMRIGHT",5,-5)
			lib.gen_totemback(h)
	
		if (i == 1) then
			rune:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 3, 4)
		else
			rune:SetPoint("TOPLEFT", runeFrame[i-1], "TOPRIGHT", 6, 0)
		end

		runeFrame[i] = rune
	end
	self.Runes = runeFrame
end

-- ReadyCheck
lib.ReadyCheck = function(self)
	if cfg.RCheckIcon then
		rCheck = self.Health:CreateTexture(nil, "OVERLAY")
		rCheck:SetSize(14, 14)
		rCheck:SetPoint("BOTTOMLEFT", self.Health, "TOPRIGHT", -13, -12)
		self.ReadyCheck = rCheck
	end
end

-- oUF_HealPred
lib.HealPred = function(self)
	if not cfg.ShowIncHeals then return end
	
	local mhpb = CreateFrame('StatusBar', nil, self.Health)
	mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
	mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
	mhpb:SetWidth(self:GetWidth())
	mhpb:SetStatusBarTexture(cfg.castbar_texture)
	mhpb:SetStatusBarColor(1, 1, 1, 0.6)
	mhpb:SetFrameLevel(1)

	local ohpb = CreateFrame('StatusBar', nil, self.Health)
	ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
	ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
	ohpb:SetWidth(self:GetWidth())
	ohpb:SetStatusBarTexture(cfg.castbar_texture)
	ohpb:SetStatusBarColor(1, 1, 1, 0.6)
	mhpb:SetFrameLevel(1)
	self.HealPrediction = {
		myBar = mhpb,
		otherBar = ohpb,
		maxOverflow = 1,
	}
end

-- Combo points
lib.RogueComboPoints = function(self)
	if(playerClass == "ROGUE" or playerClass == "DRUID") then
		local bg = {}
		local fill = {}
		self.CPoints = {}
		for i = 1, MAX_COMBO_POINTS do
			self.CPoints[i] = CreateFrame("Frame", nil, self)
			self.CPoints[i]:SetSize(24, 24)
			if i > 1 then self.CPoints[i]:SetPoint("LEFT", self.CPoints[i - 1], "RIGHT") end
			bg[i] = self.CPoints[i]:CreateTexture(nil, "ARTWORK")
			bg[i]:SetTexture("Interface\\AddOns\\oUF_Sand\\media\\cpoint_bg.tga")
			bg[i]:SetBlendMode("BLEND")
			bg[i]:SetVertexColor(0,0,0)
			bg[i]:SetAllPoints(self.CPoints[i])
			fill[i] = self.CPoints[i]:CreateTexture(nil, "OVERLAY")
			fill[i]:SetTexture("Interface\\AddOns\\oUF_Sand\\media\\cpoint.tga")
			fill[i]:SetVertexColor(1.0, 0.9, 0)
			fill[i]:SetAllPoints(self.CPoints[i])
		end
		self.CPoints[1]:SetPoint("BOTTOM", oUF_lustPlayer.Health, "TOP", -56, -18)
		self.CPoints.unit = "player"
	end
	
end

lib.AnimatedComboPoints = function(self)
	if(playerClass == "ROGUE" or playerClass == "DRUID") then

		local bg = {}
		local fill = {}
		self.CPoints = {}
		self.CPointBG = {}

		for i = 1, MAX_COMBO_POINTS do
			self.CPoints[i] = CreateFrame("Frame", nil, self)
			self.CPoints[i]:SetSize(32, 40)
			if i > 1 then self.CPoints[i]:SetPoint("LEFT", self.CPoints[i - 1], "RIGHT") end

			fill[i] = self.CPoints[i]:CreateTexture(nil, "ARTWORK")
			fill[i]:SetTexture("Interface\\AddOns\\oUF_Sand\\media\\point.tga")
			fill[i]:SetVertexColor(1,0.1,0.1,0.8)
			fill[i]:SetAllPoints(self.CPoints[i]) 

			bg[i] = self.CPoints[i]:CreateTexture(nil,"OVERLAY")
			bg[i]:SetTexture("Interface\\AddOns\\oUF_Sand\\media\\fire.tga")
			bg[i]:SetBlendMode("BLEND")
			bg[i]:SetVertexColor(0.8,0,0)
			bg[i]:SetAllPoints(self.CPoints[i])
        
			self.CPoints[i].tex = bg[i]
			self.CPoints[i].tex.texcoord = 0 + (0.08333 * i * 2)
        
			local FrameOnUpdate = function (self, time)
				self.OnUpdateCounter = (self.OnUpdateCounter or 0) + time
				if self.OnUpdateCounter < 0.06 then return end
				self.OnUpdateCounter = 0
				self.tex:SetTexCoord(self.tex.texcoord, self.tex.texcoord + 0.08333,0,1.15)
				self.tex.texcoord = self.tex.texcoord + 0.08333
				if self.tex.texcoord > 0.99 then self.tex.texcoord = 0; end
			end

			self.CPoints[i]:SetScript("OnUpdate",FrameOnUpdate)
			self.CPoints[i]:SetAlpha(1)
			self.ani = bg[i]

		self.CPoints[1]:SetPoint("BOTTOM", oUF_lustPlayer.Health, "TOP", -64, -24)
		self.CPoints.unit = "player"

		end 
	end
end

-- Addons/Plugins -------------------------------------------

-- Totem timer support (requires oUF_boring_totembar) 
lib.gen_TotemBar = function(self)
	if ( playerClass == "SHAMAN" and IsAddOnLoaded("oUF_boring_totembar") ) then
		local TotemBar = CreateFrame("Frame", nil, self)
		TotemBar:SetPoint("TOP", self, "BOTTOM", 0, -4)
		TotemBar:SetWidth(self:GetWidth())
		TotemBar:SetHeight(8)

		TotemBar.Destroy = true
		TotemBar.AbbreviateNames = true
		TotemBar.UpdateColors = true
		
		oUF.colors.totems = {
			{ 233/255, 46/255, 16/255 }, -- fire
			{ 173/255, 217/255, 25/255 }, -- earth
			{ 35/255, 127/255, 255/255 }, -- water
			{ 178/255, 53/255, 240/255 }  -- air
		}

		for i = 1, 4 do
		local t = CreateFrame("Frame", nil, TotemBar)
			t:SetHeight(8)
			t:SetWidth(self.Health:GetWidth()/4 - 6)

			local bar = CreateFrame("StatusBar", nil, t)
			bar:SetAllPoints(t)
			bar:SetStatusBarTexture(cfg.castbar_texture)
			t.StatusBar = bar

			local h = CreateFrame("Frame", nil, t)
			h:SetFrameLevel(1)
			h:SetPoint("TOPLEFT",-5,5)
			h:SetPoint("BOTTOMRIGHT",5,-5)
			lib.gen_totemback(h)
			
			if (i == 1) then
				t:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 3, 4)
			else
				t:SetPoint('TOPLEFT', TotemBar[i-1], "TOPRIGHT", 6, 0)
			end

			t.bg = t:CreateTexture(nil, "BORDER")
			t.bg:SetAllPoints(t)
			t.bg:SetTexture(cfg.backdrop_texture)
			t.bg.multiplier = 0.15
			t.bg:SetAlpha(0.6)
	
			local text = lib.gen_fontstring(t, cfg.smallfont, 10, "THINOUTLINE")
			text:SetPoint("CENTER",t,"TOP",0,8)
			text:SetFontObject"GameFontNormal"
			t.Text = text

			TotemBar[i] = t
		end
	self.TotemBar = TotemBar
	end
end

  -- oUF_CombatFeedback
  lib.gen_combat_feedback = function(f)
    if IsAddOnLoaded("oUF_CombatFeedback") then
      local h = CreateFrame("Frame", nil, f.Health)
      h:SetAllPoints(f.Health)
      h:SetFrameLevel(30)
      local cfbt = lib.gen_fontstring(h, cfg.font, 18, "THINOUTLINE")
      cfbt:SetPoint("CENTER", f.Health, "BOTTOM", 0, -1)
      cfbt.maxAlpha = 0.75
      cfbt.ignoreEnergize = true
      f.CombatFeedbackText = cfbt
    end
  end

  -- oUF_WeaponEnchant (temporary weapon enchant icon)
local function WeapEnchantIcon(self, icon, icons)
	local iconwidth = icon:GetWidth()
	icon.time = icon:CreateFontString(nil, 'OVERLAY')
	icon.time:SetFont(cfg.font, iconwidth/2.6, 12)
	icon.time:SetPoint("BOTTOM", icon, 0, -2)
	icon.time:SetJustifyH('CENTER')
	icon.time:SetVertexColor(1.0, 0.8, 0.1)
	
	icon.overlay:SetTexture("Interface\\AddOns\\oUF_Sand\\media\\iconborder.tga")
	icon.overlay:SetTexCoord(0, 1, 0, 1)
	icon.overlay:SetVertexColor(0,0,0,0.9)	

	icon.icon:SetTexCoord(.08, .92, .08, .92)	

	end

local CreateEnchantTimer = function(self, icons)
	for i = 1, 2 do
		local icon = icons[i]
		if icon.expTime then
			icon.timeLeft = icon.expTime - GetTime()
			icon.time:Show()
		else
			icon.time:Hide()
		end
		icon:SetScript("OnUpdate", CreateAuraTimer)
	end
end

lib.gen_WeaponEnchant = function(self)
	if IsAddOnLoaded("oUF_WeaponEnchant") then
		self.Enchant = CreateFrame("Frame", nil, self)
		self.Enchant:SetSize(64, 32)
		self.Enchant:SetPoint("TOPRIGHT", oUF_SandPlayer.Power, "BOTTOMLEFT", 0, 0)
		self.Enchant.size = 32
		self.Enchant.spacing = 2
		self.Enchant.initialAnchor = "TOPRIGHT"
		self.Enchant["growth-x"] = "LEFT"
		self.Enchant:SetFrameLevel(10)
		self.PostCreateEnchantIcon = WeapEnchantIcon
		self.PostUpdateEnchantIcons = CreateEnchantTimer
	end
end

lib.gen_Vengeance = function(self)
	if IsAddOnLoaded("oUF_Vengeance") then
		--statusbar
		local v = CreateFrame("StatusBar", nil, self)
		v:SetWidth(self.Health:GetWidth())
		v:SetHeight(18)
		v:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -28)
		v:SetStatusBarTexture(cfg.vbar)
		v:SetStatusBarColor(1, 0.1, 0.1,1)
		--bg
		local b = v:CreateTexture(nil, "BACKGROUND")
		b:SetTexture(cfg.vbarbg)
		b:SetAllPoints(v)
		b:SetVertexColor(0.44,0.44,0.44,0.6)
		-- text label
		v.Text = lib.gen_fontstring(v, cfg.smallfont, 10, "THINOUTLINE")
		v.Text:SetPoint("CENTER",v,"CENTER",0,0)
		v.Text:SetJustifyH("LEFT")
		
		self.Vengeance = v
		self.Vengeance.bg = b
	end
end

--hand the lib to the namespace for further usage
ns.lib = lib