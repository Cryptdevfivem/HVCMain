local cfg = {}

cfg.inventory_weight = 30 -- weight for an user inventory per strength level (no unit, but thinking in "kg" is a good norm)

-- default chest weight for vehicle trunks
cfg.default_vehicle_chest_weight = 30

cfg.vehicle_chest_weights = {
    ["uzibentaygaheli"] = 30,
    ["hycadeevo"] = 50,
    ["octane"] = 200,
    ["stogger"] = 30,
    ["warthogheli"] = 50,
    ["q3rsabt"] = 30,
    ["slyx5"] = 100,
    ["ovx"] = 50,
    ["beck"] = 30,
    ["ben"] = 200,
    ["rs3hycade"] = 30,
    ["v10"] = 30,
    ["canxrs"] = 30,
    ["lloydzurus"] = 100,
    ["rs666"] = 30,
    ["keyrusheli"] = 30,
    ["svlwb18"] = 200,
    ["m977hl"] = 200,
    ["candyvan"] = 300,
    ["transvan"] = 300,
    ["asdavan"] = 300,
    ["fordconnect"] = 300,
    ["royalmailvan"] = 300,
    ["dpdvan"] = 300,
    ["dpdconnect"] = 300,
    ["DHL"] = 300,
    ["bt"] = 300,
    ["bt1"] = 300,
    ["refluxsprint"] = 300,
    ["17jamb"] = 300,
    ["apecar50"] = 300,
    ["ateam"] = 300,
    ["berlingo"] = 300,
    ["boxvan"] = 300,
    ["crafter17"] = 300,
    ["e15082"] = 300,
    ["econoline"] = 300,
    ["expertpeug"] = 300,
    ["expresscoach"] = 300,
    ["kangoo"] = 300,
    ["swissc"] = 300,
    ["mercvan"] = 300,
    ["minivan22"] = 300,
    ["NSPEEDO"] = 300,
    ["p600coca"] = 300,
    ["pedalbeer"] = 300,
    ["peugotvan2"] = 300,
    ["sprinter211"] = 300,
    ["sprinter2020"] = 300,
    ["steed3"] = 300,
    ["tgfvan"] = 300,
    ["thomastruck"] = 300,
    ["trannysport"] = 300,
    ["ukvan"] = 300,
    ["vito"] = 300,
    ["woodyvan"] = 300,
    ["youga22"] = 300,
    ["yougat"] = 300,
    ["onlyfans"] = 50,
    ["uzibentayga"] = 300,
    ["uziurus"] = 100,
    ["car"] = 1000,
} 

return cfg