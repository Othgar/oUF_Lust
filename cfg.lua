  -----------------------------
  -- INIT
  -----------------------------

  local addon, ns = ...
  local cfg = CreateFrame("Frame")
  local mediaFolder = "Interface\\AddOns\\oUF_Lust\\media\\"	-- don't touch this ...

  -----------------------------
  -- CONFIG
  -----------------------------
  
  -- Units
  cfg.showarena = false -- Use included arena frames **!!NOT CURRENTLY WORKING!!**
  cfg.showtot = true -- show target of target frame
  cfg.showpet = true -- show pet frame
  cfg.showfocus = true -- show focus frame
  cfg.showfocustarget = true -- show focus target frame
  cfg.ShowPlayerName = true -- show player's name and level

  -- Raid and Party
  cfg.ShowParty = true -- show party frames
  cfg.party_leader_icon = true -- Show Leader Icon

--  cfg.ShowRaid = false -- show raid frames
--  cfg.RaidShowSolo = true -- show raid frames even when solo

  -- Positioning 
  cfg.PlayerX = -275 -- Player frame's x-offset position from the relative point of the screen
  cfg.PlayerY = -300 -- Player frame's y-offset position from the relative point of the screen
  -- Possible values are: "TOP"/"BOTTOM"/"LEFT"/"RIGHT"/"CENTER"/"TOPLEFT"/"ROPRIGHT"/"BOTTOMLEFT"/"BOTTOMRIGHT"
  cfg.PlayerRelativePoint = "CENTER" -- Player frame's reference point of the screen used for X and Y offsets. 
  cfg.TargetX = 275 -- Target frame's x-offset position from the relative point of the screen
  cfg.TargetY = -300 -- Target frame's y-offset position from the relative point of the screen
  cfg.TargetRelativePoint = "CENTER" -- Target frame's reference point of the screen used for X and Y offsets. 
  cfg.TotX = 0 -- Target of target frame's x-offset position from the relative point of the screen
  cfg.TotY = -300 -- Target of target frame's y-offset position from the relative point of the screen
  cfg.TotRelativePoint = "CENTER" -- Target of target frame's reference point of the screen used for X and Y offsets.   
  cfg.FocusX = -300 -- Focus frame's x-offset position from the relative point of the screen
  cfg.FocusY = 190 -- Focus frame's y-offset position from the relative point of the screen
  cfg.FocusRelativePoint = "TOPRIGHT" -- Focus frame's reference point of the screen used for X and Y offsets.   
  cfg.ArenaX = 260 -- Arena frame's x-offset position from the relative point of the screen
  cfg.ArenaY = 30 -- Arena frame's y-offset position from the relative point of the screen
  cfg.ArenaRelativePoint = "TOPRIGHT" -- Arena frame's reference point of the screen used for X and Y offsets. 

  cfg.PartyX = -900 -- Party Frames Horizontal Position
  cfg.PartyY = 250 -- Party Frames Vertical Position
  cfg.RaidX = -590 -- Party Frames Horizontal Position
  cfg.RaidY = -60 -- Party Frames Vertical Position
  cfg.raidScale = 1 -- scale factor for raid and party frames
  cfg.scale = 1 -- scale factor for all other frames
  


  -- Combo Points
  cfg.UseAnimatedCombo = false -- Set to true to use "Fireball" styled combo points.

  -- Misc
  cfg.showRunebar = true -- show DK's rune bar
  cfg.showHolybar = true -- show Paladin's HolyPower bar
  cfg.showEclipsebar = true -- show druid's Eclipse bar
  cfg.showShardbar = true -- show Warlock's SoulShard bar
  cfg.showTotemBar = true -- show Shaman Totem timer bar
  cfg.RCheckIcon = true -- show raid check icon
  cfg.ShowIncHeals = false -- Show incoming heals in player and raid frames
  cfg.showLFDIcons = true -- Show dungeon role icons in party
  
-- ===================================================================================
-- ========================= !!DO NOT EDIT BELOW THIS LINE!! =========================
-- ===================================================================================

  cfg.castbar_texture = mediaFolder.."Statusbar"
  cfg.statusbar_texture = mediaFolder.."healthbar"
  cfg.tstatusbar_texture = mediaFolder.."thealthbar"
  cfg.ostatusbar_texture = mediaFolder.."otherhpbar"
  cfg.statusbarbg_texture = mediaFolder.."healthbar_bg"
  cfg.tstatusbarbg_texture = mediaFolder.."thealthbar_bg"
  cfg.ostatusbarbg_texture = mediaFolder.."otherhpbar_bg"
  cfg.powerbar_texture = mediaFolder.."powerbar"
  cfg.tpowerbar_texture = mediaFolder.."tpowerbar"
  cfg.opowerbar_texture = mediaFolder.."otherppbar"
  cfg.powerbarbg_texture = mediaFolder.."powerbar_bg"
  cfg.tpowerbarbg_texture = mediaFolder.."tpowerbar_bg"
  cfg.opowerbarbg_texture = mediaFolder.."otherppbar_bg"
  cfg.backdrop_texture = mediaFolder.."backdrop"
  cfg.backline = mediaFolder.."backline"
  cfg.highlight_texture = mediaFolder.."raidbg"
  cfg.debuffhighlight_texture = mediaFolder.."debuff_highlight"
  cfg.backdrop_edge_texture = mediaFolder.."backdrop_edge"
  cfg.debuffBorder = mediaFolder.."iconborder"
  cfg.spark = mediaFolder.."spark"
  cfg.font = mediaFolder.."MinionPro.otf"
  cfg.smallfont = mediaFolder.."MinionPro.otf"
  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  ns.cfg = cfg
