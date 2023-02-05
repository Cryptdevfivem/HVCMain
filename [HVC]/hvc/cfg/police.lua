
local cfg = {}

-- PCs positions
cfg.pcs = {
  
}

-- vehicle tracking configuration
cfg.trackveh = {
  min_time = 300, -- min time in seconds
  max_time = 600, -- max time in seconds
  service = "police",  -- service to alert when the tracking is successful
  "SWAT",
  "sheriff",
  "highway",
  "trafficguard",
  "Chief",
  "Commander",
  "Lieutenant",
  "Detective",
  "Sergeant",
  "Deputy",
  "Bounty",
  "Dispatch"
}

-- wanted display
cfg.wanted = {
  blipid = 458,
  blipcolor = 38,
  service = "police",
  "SWAT",
  "sheriff",
  "highway",
  "trafficguard",
  "Chief",
  "Dispatch",
  "Commander",
  "Lieutenant",
  "Detective",
  "Deputy",
  "Bounty",
  "Sergeant"
}

-- illegal items (seize)
cfg.seizable_items = {
  "dirty_money",
  "heroin",
  "weed",
  "Cocaine",
  -- Custom Weapons --




  -- {{Assault-Rifles | 5KG Bodies | 0.01KG Ammo}  --

  "WEAPON_ACWR_AMMO",
  "WEAPON_AK74_AMMO",
  "WEAPON_AK200_AMMO",
  "WEAPON_HK417_AMMO",
  "WEAPON_HK870_AMMO",
  "WEAPON_AK74KASHNAR_AMMO",
  "WEAPON_SCARL_AMMO",
  "WEAPON_KITTYREVENGE_AMMO",
  "WEAPON_RUST_AMMO",

  -- {{Assault-Rifles Whitelist | 5KG Bodies | 0.01KG Ammo}  --

  "WEAPON_AK74U_AMMO",
  "WEAPON_ANARCHYLR300HVC_AMMO",
  "WEAPON_MK4_AMMO",
  "WEAPON_M13RAYZ_AMMO",
  "WEAPON_MK18HVC_AMMO",
  "WEAPON_HYPERBEASTHVC_AMMO",

  -- {{Assault-Rifles MetPD | 5KG Bodies | 0.01KG Ammo}  --

  "WEAPON_G36K_AMMO",
  "WEAPON_IA2_AMMO",
  "WEAPON_M4A1_AMMO",
  "WEAPON_MCX_AMMO",
  "WEAPON_SIGMCX_AMMO",

  -- {{Assault-Rifles MetPD Whitelist | 5KG Bodies | 0.01KG Ammo}  --

  "WEAPON_GCDMR_AMMO",
  "WEAPON_PARAFAL_AMMO",

  -- {LMGs | 7.5KG Bodies | 0.01KG Ammo}  --

  "WEAPON_M249_AMMO",

  -- {Melees | 1KG Bodies} --

  "WEAPON_CAPSHIELD_AMMO",

  -- {Pistols | 2.50KG | 0.01KG Ammo} --

  "WEAPON_M1911_AMMO",
  "WEAPON_SR40_AMMO",
  "WEAPON_TX22_AMMO",

  -- {Pistols Whitelist | 2.50KG | 0.01KG Ammo} --

  "WEAPON_FNX45_AMMO",
  "WEAPON_NAILGUNHVC_AMMO",
  "WEAPON_REVOHVC_AMMO",

  -- {Pistols MetPD | 2.50KG | 0.01KG Ammo} --

  "WEAPON_GLOCK17_AMMO",

  -- {Shotguns | 5KG Bodies | 0.01KG Ammo} --

  "WEAPON_WINCHESTER12_AMMO",

  -- {Shotguns MetPD | 5KG Bodies | 0.01KG Ammo} --

  "WEAPON_REMINGTON870_AMMO",

  -- {Smgs | 5KG Bodies | 0.01KG Ammo} --

  "WEAPON_VESPER_AMMO",
  "WEAPON_UMP45_AMMO",
  "WEAPON_UZI_AMMO",
  "WEAPON_MPX_AMMO",

  -- {Smgs Whitelist | 5KG Bodies | 0.01KG Ammo} --

  "WEAPON_PPSHHVC_AMMO",
  "WEAPON_DRAGONTHOMPSONHVC_AMMO",
  "WEAPON_MP7HVC_AMMO",

  -- {Smgs MetPD | 5KG Bodies | 0.01KG Ammo} --

  "WEAPON_MP5_AMMO",

  -- {Sniper-Rifles | 7.50KG | 0.01KG Ammo} --

  "WEAPON_MOSIN_AMMO",
  "WEAPON_SVD_AMMO",
  "WEAPON_SV98_AMMO",

  -- {Sniper-Rifles MetPD | 7.50KG | 0.01KG Ammo} --

  "WEAPON_BARRET_AMMO",
  "WEAPO_BORA_AMMO",
  "WEAPON_REMINGTON700_AMMO",










    -- Custom Weapons --




  -- {{Assault-Rifles | 5KG Bodies | 0.01KG Ammo}  --

  "WEAPON_ACWR",
  "WEAPON_AK74",
  "WEAPON_AK200",
  "WEAPON_HK417",
  "WEAPON_HK870",
  "WEAPON_AK74KASHNAR",
  "WEAPON_SCARL",
  "WEAPON_KITTYREVENGE",
  "WEAPON_RUST",

  -- {{Assault-Rifles Whitelist | 5KG Bodies | 0.01KG Ammo}  --

  "WEAPON_AK74U",
  "WEAPON_ANARCHYLR300HVC",
  "WEAPON_MK4",
  "WEAPON_M13RAYZ",
  "WEAPON_MK18HVC",
  "WEAPON_HYPERBEASTHVC",

  -- {{Assault-Rifles MetPD | 5KG Bodies | 0.01KG Ammo}  --

  "WEAPON_G36K",
  "WEAPON_IA2",
  "WEAPON_M4A1",
  "WEAPON_MCX",
  "WEAPON_SIGMCX",

  -- {{Assault-Rifles MetPD Whitelist | 5KG Bodies | 0.01KG Ammo}  --

  "WEAPON_GCDMR",
  "WEAPON_PARAFAL",

  -- {LMGs | 7.5KG Bodies | 0.01KG Ammo}  --

  "WEAPON_M249",

  -- {Melees | 1KG Bodies} --

  "WEAPON_CAPSHIELD",

  -- {Pistols | 2.50KG | 0.01KG Ammo} --

  "WEAPON_M1911",
  "WEAPON_SR40",
  "WEAPON_TX22",

  -- {Pistols Whitelist | 2.50KG | 0.01KG Ammo} --

  "WEAPON_FNX45",
  "WEAPON_NAILGUNHVC",
  "WEAPON_REVOHVC",

  -- {Pistols MetPD | 2.50KG | 0.01KG Ammo} --

  "WEAPON_GLOCK17",

  -- {Shotguns | 5KG Bodies | 0.01KG Ammo} --

  "WEAPON_WINCHESTER12",

  -- {Shotguns MetPD | 5KG Bodies | 0.01KG Ammo} --

  "WEAPON_REMINGTON870",

  -- {Smgs | 5KG Bodies | 0.01KG Ammo} --

  "WEAPON_VESPER",
  "WEAPON_UMP45",
  "WEAPON_UZI",
  "WEAPON_MPX",

  -- {Smgs Whitelist | 5KG Bodies | 0.01KG Ammo} --

  "WEAPON_PPSHHVC",
  "WEAPON_DRAGONTHOMPSONHVC",
  "WEAPON_MP7HVC",

  -- {Smgs MetPD | 5KG Bodies | 0.01KG Ammo} --

  "WEAPON_MP5",

  -- {Sniper-Rifles | 7.50KG | 0.01KG Ammo} --

  "WEAPON_MOSIN",
  "WEAPON_SVD",
  "WEAPON_SV98",

  -- {Sniper-Rifles MetPD | 7.50KG | 0.01KG Ammo} --

  "WEAPON_BARRET",
  "WEAPO_BORA",
  "WEAPON_REMINGTON700",

}

-- jails {x,y,z,radius}
cfg.jails = {
  {1789.7, 2578.23, 45.8,2.1},
  {1789.88, 2581.94, 45.8,2.1},
  {1789.83, 2586.0, 45.8,1.6}
}

-- fines
-- map of name -> money
cfg.fines = {
  ["Insult"] = 100,
  ["Speeding"] = 250,
  ["Red Light"] = 250,
  ["Stealing"] = 1000,
  ["Credit Cards - Per Card"] = 1000,
  ["Drugs - Per Drug"] = 2000,
  ["Dirty Money - Per $1000"] = 1500,
  ["Organized crime (low)"] = 10000,
  ["Organized crime (medium)"] = 25000,
  ["Organized crime (high)"] = 50000
}

return cfg
