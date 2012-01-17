--oUF_Lust By Othgar A.K.A. lust of Borean Tundra
--email: othgar.medivh@gmail.com
--v1.0b Initial build  
  
  local addon, ns = ...
  
  local cfg = ns.cfg
  local lib = ns.lib
  
			
oUF.colors.smooth = {0.44, 0.44, 0.44, 0.44, 0.44, 0.44, 0.44, 0.44, 0.44,}

local MyPvPUpdate = function(self, event, unit)
	if(unit ~= self.unit) then return end

	local pvp = self.MyPvP
	if(pvp) then
		local factionGroup = UnitFactionGroup(unit)
		-- FFA!
		if(UnitIsPVPFreeForAll(unit)) then
			pvp:SetTexture([[Interface\TargetingFrame\UI-PVP-FFA]])
			pvp:Show()
		elseif(UnitIsPVP(unit) and factionGroup) then
			if(factionGroup == 'Horde') then
				pvp:SetTexture([[Interface\Addons\oUF_Lust\media\Horde]])
			else
				pvp:SetTexture([[Interface\Addons\oUF_Lust\media\Alliance]])
			end
			pvp:Show()
		else
			pvp:Hide()
		end
	end
end

-----------------------------
-- STYLE FUNCTIONS
-----------------------------

local UnitSpecific = {

	player = function(self, ...)

		self.mystyle = "player"
		
		
		-- Size and Scale
		self:SetScale(cfg.scale)
		self:SetSize(256, 102)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)
		lib.gen_combat_feedback(self)
		lib.gen_InfoIcons(self)
		lib.HealPred(self)
		

		self.Health.frequentUpdates = true
		self.Health.colorSmooth = true
		self.Health.Smooth = true
		self.Health.bg2.multiplier = 0.5
		self.Power.colorPower = true
		self.Power.Smooth = true
		self.Power.frequentUpdates = true
		self.Power.bg.multiplier = 0.4
		-- PvP Icon
		local pvp = self.Health:CreateTexture(nil, "OVERLAY")
		--pvp:SetTexture(1, 0, 0)
		pvp:SetHeight(36)
		pvp:SetWidth(36)
		pvp:SetPoint("TOPLEFT", -16, -32)
		self.MyPvP = pvp

		-- This makes oUF update the information.
		self:RegisterEvent("UNIT_FACTION", MyPvPUpdate)
		-- This makes oUF update the information on forced updates.
		table.insert(self.__elements, MyPvPUpdate)


		if cfg.showRunebar then lib.genRunes(self) end
		if cfg.showHolybar then lib.genHolyPower(self) end
		if cfg.showShardbar then lib.genShards(self) end
		if cfg.showEclipsebar then lib.addEclipseBar(self) end
		
		-- Addons
		if cfg.showTotemBar then lib.gen_TotemBar(self) end
		if cfg.showVengeance then lib.gen_Vengeance(self) end
		self.BarFade = true
		self.BarFadeMinAlpha = -1
		
	end,
	
	target = function(self, ...)
	
		self.mystyle = "target"
		
		-- Size and Scale
		self:SetScale(cfg.scale)
		self:SetSize(256,102)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)
		lib.gen_combat_feedback(self)
		lib.gen_InfoIcons(self)
		lib.addQuestIcon(self)
		
		--style specific stuff
		self.Health.frequentUpdates = true
		self.Health.colorSmooth = true
		self.Health.Smooth = true
		self.Health.bg2.multiplier = 0.5
		self.Power.frequentUpdates = true
		self.Power.Smooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorHealth = true
		self.Power.colorReaction = true
		self.Power.colorClass = true
		self.Power.bg.multiplier = 0.5
		local pvp = self.Health:CreateTexture(nil, "OVERLAY")
		pvp:SetHeight(36)
		pvp:SetWidth(36)
		pvp:SetPoint("TOPRIGHT", 28, -32)
		self.MyPvP = pvp

		-- This makes oUF update the information.
		self:RegisterEvent("UNIT_FACTION", MyPvPUpdate)
		-- This makes oUF update the information on forced updates.
		table.insert(self.__elements, MyPvPUpdate)

		lib.HealPred(self)


		if cfg.UseAnimatedCombo then 
			lib.AnimatedComboPoints(self)
		else
			lib.RogueComboPoints(self)
		end

	end,
	
	focus = function(self, ...)
	
		self.mystyle = "focus"
		
		-- Size and Scale
		self:SetScale(cfg.scale)
		self:SetSize(128, 70)
		
		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)

		--style specific stuff
		self.Health.frequentUpdates = true
		self.Health.Smooth = true
		self.Health.colorSmooth = true
		-- self.Health.bg.multiplier = 0.3
		self.Power.Smooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true
		self.Power.bg.multiplier = 0.5
	end,
	
	targettarget = function(self, ...)

		self.mystyle = "tot"
		
		-- Size and Scale
		self:SetScale(cfg.scale)
		self:SetSize(128, 70)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)

		--style specific stuff
		self.Health.frequentUpdates = true
		self.Health.colorSmooth = true
		self.Health.Smooth = true
		-- self.Health.bg.multiplier = 0.3
		self.Power.Smooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true
		self.Power.bg.multiplier = 0.5

	end,
	
	focustarget = function(self, ...)
		
		self.mystyle = "focustarget"
		
		-- Size and Scale
		self:SetScale(cfg.scale)
		self:SetSize(128, 70)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)
		
		--style specific stuff
		self.Health.frequentUpdates = true
		self.Health.colorClass = true
		self.Health.colorSmooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorPower = true
		self.Power.colorReaction = true
		self.Power.bg.multiplier = 0.6
	
	end,
	
	pet = function(self, ...)
		local _, playerClass = UnitClass("player")
		
		self.mystyle = "pet"
		
		-- Size and Scale
		self:SetScale(cfg.scale)
		self:SetSize(90,50)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)
		
		--style specific stuff
		self.Health.frequentUpdates = true
		self.Health.colorSmooth = true
		self.Health.Smooth = true
		-- self.Health.bg.multiplier = 0.3
		self.Power.Smooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorClass = true
		self.Power.colorReaction = true
		self.Power.colorHealth = true
		self.Power.bg.multiplier = 0.5
		self.BarFade = true
		self.BarFadeMinAlpha = -1
	end,

	party = function(self, ...)
				
		self.mystyle = "party"

		self.Range = {
			insideAlpha = 1,
			outsideAlpha = .3,
		}

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)
		lib.ReadyCheck(self)
		lib.gen_LFDRole(self)
		
		--style specific stuff
		self.Health.frequentUpdates = true
		self.Health.colorSmooth = true
		-- self.Health.bg.multiplier = 0.3
		self.Power.colorClass = true
		self.Power.bg.multiplier = 0.5
		lib.gen_InfoIcons(self)
		lib.CreateTargetBorder(self)
		lib.HealPred(self)

		local pvp = self.Health:CreateTexture(nil, "OVERLAY")
		pvp:SetHeight(24)
		pvp:SetWidth(24)
		pvp:SetPoint("TOPRIGHT", 18, -14)
		self.MyPvP = pvp

		-- This makes oUF update the information.
		self:RegisterEvent("UNIT_FACTION", MyPvPUpdate)
		-- This makes oUF update the information on forced updates.
		table.insert(self.__elements, MyPvPUpdate)
	
		self.Health.PostUpdate = lib.PostUpdateRaidFrame
		self:RegisterEvent('PLAYER_TARGET_CHANGED', lib.ChangedTarget)
		self:RegisterEvent('RAID_ROSTER_UPDATE', lib.ChangedTarget)
	end,

  --arena frames
	arena = function(self, unit, isSingle)
		
		self.mystyle = "arena"
		
		-- Size and Scale
		self:SetSize(126, 70)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)
		lib.gen_arenatracker(self)
		lib.gen_targetindicator(self)

		--style specific stuff
		self.Health.frequentUpdates = true
		self.Health.colorClass = true
		self.Health.colorSmooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorPower = true
		self.Power.colorReaction = true
		self.Power.bg.multiplier = 0.6

		if(isSingle) then self:SetSize(self.width,self.height) end

	end,

  -- arena targets
	arenatarget = function(self, unit, isSingle)
		
		self.mystyle = "arenatarget"
		
		-- Size and Scale
		self:SetSize(90, 50)

		-- Generate Bars
		lib.gen_hpbar(self)
		lib.gen_hpstrings(self)
		lib.gen_highlight(self)
		lib.gen_ppbar(self)
		lib.gen_RaidMark(self)
		
		--style specific stuff
		self.Health.frequentUpdates = true
		self.Health.colorClass = true
		self.Health.colorSmooth = true
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorPower = true
		self.Power.colorReaction = true
		self.Power.bg.multiplier = 0.6
		if(isSingle) then self:SetSize(self.width,self.height) end

  end  
}	
  
-- The Shared Style Function
local GlobalStyle = function(self, unit, isSingle)

	self.menu = lib.spawnMenu
	self:RegisterForClicks('AnyDown')
	-- if(cfg.show_mirrorbars) then MirrorBars() end
	
	-- Call Unit Specific Styles
	if(UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

-- The Shared Style Function for Party and Raid
local GroupGlobalStyle = function(self, unit)

	self.menu = lib.spawnMenu
	self:RegisterForClicks('AnyDown')
	
	-- Call Unit Specific Styles
	if(UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end
	
  -----------------------------
  -- SPAWN UNITS
  -----------------------------

oUF:RegisterStyle("lust", GlobalStyle)
oUF:RegisterStyle("lustGroup", GroupGlobalStyle)
oUF:RegisterStyle("lustArena", GlobalStyle)
oUF:RegisterStyle("lustArenaTarget", GlobalStyle)

oUF:Factory(function(self)
  -- Single Frames
	self:SetActiveStyle('lust')
	self:Spawn('player'):SetPoint("CENTER", UIParent, cfg.PlayerRelativePoint, cfg.PlayerX, cfg.PlayerY)
	self:Spawn('target'):SetPoint("CENTER", UIParent, cfg.TargetRelativePoint, cfg.TargetX, cfg.TargetY)
	if cfg.showtot then self:Spawn('targettarget'):SetPoint("CENTER", UIParent, cfg.TotRelativePoint, cfg.TotX, cfg.TotY) end
	if cfg.showpet then self:Spawn('pet'):SetPoint("TOPRIGHT",oUF_lustPlayer,"TOPLEFT", -40, 50) end
	if cfg.showfocus then self:Spawn('focus'):SetPoint("BOTTOMRIGHT", oUF_lustPlayer, cfg.FocusRelativePoint, cfg.FocusX, cfg.FocusY) end
	if cfg.showfocustarget then self:Spawn('focustarget'):SetPoint("BOTTOMLEFT",oUF_lustFocus,"TOPLEFT", 0, 8) end
	
  -- Arena Frames
	if cfg.showarena and not IsAddOnLoaded('Gladius') then
		self:SetActiveStyle("lustArena")
		SetCVar("showArenaEnemyFrames", false)
		local arena = {}
		local arenatarget = {}
		for i = 1, 5 do
			arena[i] = self:Spawn("arena"..i, "oUF_Arena"..i)
			arena[i]:SetScale(cfg.scale)
			if i == 1 then
				arena[i]:SetPoint("BOTTOMRIGHT", UIParent, cfg.ArenaRelativePoint, cfg.ArenaX, cfg.ArenaY)
			else
				arena[i]:SetPoint("BOTTOMRIGHT", arena[i-1], "BOTTOMRIGHT", 0, 56)
			end
		end
		self:SetActiveStyle("lustArenaTarget")
		for i = 1, 5 do
			arenatarget[i] = self:Spawn("arena"..i.."target", "oUF_Arena"..i.."target")
			arenatarget[i]:SetPoint("TOPRIGHT",arena[i], "TOPLEFT", -4, 0)
			arenatarget[i]:SetScale(cfg.scale)
		end
	end

	-- Party Frames
	if cfg.ShowParty then
		self:SetActiveStyle('lustGroup')

		local party = oUF:SpawnHeader('oUF_Party', nil, 'custom  [group:party,nogroup:raid][@raid6,noexists,group:raid] show;hide',
		--local party = oUF:SpawnHeader('oUF_Party', nil, "solo", "showSolo", true,  -- debug
		"showParty", cfg.ShowParty, 
		"showPlayer", true,
		"yoffset", -15,
		"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
   		]]):format(128, 59))
		party:SetScale(cfg.raidScale)
		party:SetPoint('CENTER', UIParent, 'CENTER', cfg.PartyX, cfg.PartyY)
	end
end)