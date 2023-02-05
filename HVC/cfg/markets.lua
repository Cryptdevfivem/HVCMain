
local cfg = {}

-- define market types like garages and weapons
-- _config: blipid, blipcolor, permissions (optional, only users with the permission will have access to the market)

cfg.market_types = {
  ["Robbable Store"] = {
    _config = {blipid=52, blipcolor=2},

    -- list itemid => price
    -- Drinks
    ["milk"] = 20,
    ["water"] = 20,
    ["coffee"] = 40,
    ["tea"] = 40,
    ["icetea"] = 80,
    ["orangejuice"] = 80,
    ["cocacola"] = 120,
    ["redbull"] = 120,
    ["lemonade"] = 140,
    ["vodka"] = 300,

    --Food
    ["bread"] = 20,
    ["donut"] = 20,
    ["tacos"] = 80,
    ["sandwich"] = 200,
    ["kebab"] = 200,
    ["pdonut"] = 650,
  },
  --["drugstore"] = {
  --  _config = {blipid=51, blipcolor=2},
  --  ["pills"] = 500
  --},
  ["NHS Loadout"] = {
    _config = {blipid=51, blipcolor=68, permissions={"emergency.market"}},
    ["medkit"] = 0,
    ["pills"] = 0
  },
  ["plantation"] = {
    _config = {blipid=473, blipcolor=4, permissions={"drugseller.market"}},
    ["seeds"] = 500,
	["benzoilmetilecgonina"] = 800,
	["harness"] = 1000
  },
  ["tools"] = {
    _config = {blipid=402, blipcolor=47, permissions={"repair.market"}},
    ["repairkit"] = 50
  }
}

-- list of markets {type,x,y,z}

cfg.markets = {
  --[[{"Robbable Store",128.1410369873, -1286.1120605469, 29.281036376953},
  {"Robbable Store",-47.522762298584,-1756.85717773438,29.4210109710693},
  {"Robbable Store",25.7454013824463,-1345.26232910156,29.4970207214355}, 
  {"Robbable Store",1135.57678222656,-981.78125,46.4157981872559}, 
  {"Robbable Store",1163.53820800781,-323.541320800781,69.2050552368164}, 
  {"Robbable Store",374.190032958984,327.506713867188,103.566368103027}, 
  {"Robbable Store",2555.35766601563,382.16845703125,108.622947692871}, 
  {"Robbable Store",2676.76733398438,3281.57788085938,55.2411231994629}, 
  {"Robbable Store",1960.50793457031,3741.84008789063,32.3437385559082},
  {"Robbable Store",1393.23828125,3605.171875,34.9809303283691}, 
  {"Robbable Store",1166.18151855469,2709.35327148438,38.15771484375}, 
  {"Robbable Store",547.987609863281,2669.7568359375,42.1565132141113}, 
  {"Robbable Store",1698.30737304688,4924.37939453125,42.0636749267578}, 
  {"Robbable Store",1729.54443359375,6415.76513671875,35.0372200012207}, 
  {"Robbable Store",-3243.9013671875,1001.40405273438,12.8307056427002}, 
  {"Robbable Store",-2967.8818359375,390.78662109375,15.0433149337769}, 
  {"Robbable Store",-3041.17456054688,585.166198730469,7.90893363952637}, 
  {"Robbable Store",-1820.55725097656,792.770568847656,138.113250732422}, 
  {"Robbable Store",-1486.76574707031,-379.553985595703,40.163387298584}, 
  {"Robbable Store",-1223.18127441406,-907.385681152344,12.3263463973999}, 
  {"Robbable Store",-707.408996582031,-913.681701660156,19.2155857086182},
  --{"drugstore",356.5361328125,-593.474304199219,28.7820014953613},
  {"NHS Loadout",242.42835998535,-1382.1253662109,39.534385681152}, -- Morge
  {"NHS Loadout",1841.4317626953,3673.5891113281,34.276752471924}, -- Sandy Shores
  {"NHS Loadout",-243.3074798584,6326.2265625,32.426181793213} -- Paleto Bay]]
}

return cfg
