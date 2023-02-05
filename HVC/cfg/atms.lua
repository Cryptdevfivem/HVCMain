
local cfg = {}

-- list of atms positions

cfg.atms = {
  {89.577018737793,2.16031360626221,68.322021484375},
  {-526.497131347656,-1222.79455566406,18.4549674987793},
  {-2072.48413085938,-317.190521240234,13.315972328186},
  {-821.565551757813,-1081.90270996094,11.1324348449707},
  {1686.74694824219,4815.8828125,42.0085678100586},
  {-386.899444580078,6045.78466796875,31.5001239776611},
  {1968.11157226563,3743.56860351563,32.3437271118164},
  {2558.85815429688,351.045166015625,108.621520996094},
  {1153.75634765625,-326.805023193359,69.2050704956055},
  {-56.9172439575195,-1752.17590332031,29.4210166931152},
  {-3241.02856445313,997.587158203125,12.5503988265991},
  {-1827.1884765625,784.907104492188,138.302581787109},
  {-1091.54748535156,2708.55786132813,18.9437484741211},
  {112.45637512207,-819.25048828125,31.3392715454102},
  {-256.173187255859,-716.031921386719,33.5202751159668},
  {174.227737426758,6637.88623046875,31.5730476379395},
  {-660.727661132813,-853.970336914063,24.484073638916},
  {-97.318870544434,6455.4028320313,31.466884613037}, --Paleto Bank ATM
  {1701.3077392578,6426.39453125,32.763957977295}, --Paleto Hway Store Gas Station
  {1735.3564453125,6410.501953125,35.037220001221}, --Paleto Hway Store
  {155.82150268555,6642.8354492188,31.602630615234}, --Paleto Gas Station
  {-132.95559692383,6366.5170898438,31.475271224976}, --Paleto Another one
  {-283.0432434082,6226.0288085938,31.493282318115}, --Paleto Baber Shop
  {1172.5115966797,2702.3454589844,38.175170898438}, --Sandy Fleeca
  {-31.459299087524,-1659.7590332031,29.479042053223}, --Rustys new garage
  {-721.15582275391,-415.53540039063,34.981830596924}, --Rockford Hills ATMsedeeeeeeeeeeeeeeeeeeeeee
  {119.17403411865,-883.63446044922,31.123058319092}, --Legion 
  {24.544145584106,-945.98687744141,29.357563018799}, --Legion Lombank
  {5.2137904167175,-919.73706054688,29.560270309448}, --Legion Lombank2
  {111.23844909668,-775.33514404297,31.438276290894}, --Legion Pillbox
  {-1409.7249755859,-100.37629699707,52.387901306152}, --Cougar Ave
  {-1430.1789550781,-211.10549926758,46.500411987305}, --Theatre (small arms)
  {-1305.2406005859,-706.41412353516,25.322587966919}, --Vespucci Shopping
  {-846.77276611328,-340.21868896484,38.680271148682}, --Int Online Unlimted
  {315.17980957031,-593.70971679688,43.284069061279}, --Pillbox 
  {1822.7102050781,3683.1733398438,34.276679992676}, --Sandy Hospital
  {380.998046875,323.42364501953,103.56638336182}, --Vinewood Store
  {-594.52264404297,-1161.3511962891,22.324245452881}, --CalaisATM1
  {-1390.9808349609,-590.39825439453,30.319551467896}, --Bahamma Mammas
  {295.64172363281,-896.18548583984,29.213527679443}, --Legion another1
  {-1205.7397460938,-324.81350708008,37.858993530273}, --Fleeca Rockford
  {-866.634765625,-187.81442260742,37.84789276123}, --Lombank Rockford
  {-577.17767333984,-194.70608520508,38.219661712646}, --CityHall
  {-527.74395751953,-166.08276367188,38.235130310059}, --CityHall2 
  {-586.50158691406,-143.2963104248,47.201084136963}, --CityHall5 
  {-567.88458251953,-234.33578491211,34.242748260498}, --Courtroom1 
  {380.76007080078,323.49118041992,103.56636810303}, --Vinewood Store
  {33.22045135498,-1348.2536621094,29.497026443481}, -- Asda store
  {129.62796020508,-1291.9389648438,29.26953125}, -- strip club
  {147.6721496582,-1035.7117919922,29.343036651611}, --Legion1
  {4475.37, -4469.77, 4.35}, --cayo atm
  {109.14,243.39,50.44}, --cayo a
  {1094.97,244.51,-50.44}, --casino
  {-2153.644, 5236.22, 18.76563}, --VIP Island
  {-1818.554, -1199.341, 14.30042}, -- hadde casino
}


cfg.atmblips={
  {-95.51131439209,6457.1625976563,31.460657119751}, --Paleto Bank ATM
  {-1205.7397460938,-324.81350708008,37.858993530273}, --Fleeca Rockford
  {147.6721496582,-1035.7117919922,29.343036651611}, --Legion1
  {129.62796020508,-1291.9389648438,29.26953125}, -- strip club
  {-567.82153320313,-199.13749694824,33.419605255127}, --Courtroom2 
  {-577.17767333984,-194.70608520508,38.219661712646}, --CityHall
  {-588.47845458984,-141.05685424805,47.201084136963}, --CityHall3 
  {295.64172363281,-896.18548583984,29.213527679443}, --Legion another1
  {-1430.1789550781,-211.10549926758,46.500411987305}, --Theatre (small arms)
  {-1409.7249755859,-100.37629699707,52.387901306152}, --Cougar Ave
  {-31.459299087524,-1659.7590332031,29.479042053223}, --Rustys new garage
  {89.577018737793,2.16031360626221,68.322021484375},
  {-526.497131347656,-1222.79455566406,18.4549674987793},
  {-2072.48413085938,-317.190521240234,13.315972328186},
  {-821.565551757813,-1081.90270996094,11.1324348449707},
  {1686.74694824219,4815.8828125,42.0085678100586},
  {-386.899444580078,6045.78466796875,31.5001239776611},
  {1171.52319335938,2702.44897460938,38.1754684448242},
  {1968.11157226563,3743.56860351563,32.3437271118164},
  {2558.85815429688,351.045166015625,108.621520996094},
  {1153.75634765625,-326.805023193359,69.2050704956055},
  {-56.9172439575195,-1752.17590332031,29.4210166931152},
  {-3241.02856445313,997.587158203125,12.5503988265991},
  {-1827.1884765625,784.907104492188,138.302581787109},
  {-1091.54748535156,2708.55786132813,18.9437484741211},
  {112.45637512207,-819.25048828125,31.3392715454102},
  {-256.173187255859,-716.031921386719,33.5202751159668},
  {174.227737426758,6637.88623046875,31.5730476379395},
  {-660.727661132813,-853.970336914063,24.484073638916},
  {4475.37, -4469.77, 4.35}, --cayo atm
  {1094.97,244.51,-50.44}, --casino
  {-2153.644, 5236.22, 18.76563}, --VIP Island
  {-1818.554, -1199.341, 14.30042}, -- hadde casino
}


return cfg
