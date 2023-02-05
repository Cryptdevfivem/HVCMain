-- Remember to use the cop group or this won't work
-- K > Admin > Add Group > User ID > cop

--- EDIT BY jackiazzking69 And BigUnit

local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVC")

local banks = {
	["Lindsay Circus"] = {
		position = { ['x'] = -705.94110107422, ['y'] = -915.48120117188, ['z'] = 18.215589523315 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Lindsay Circus LTD Gas Station",
		index = "lc",
		x = -705.94,
		y = -915.48,
		z = 18.21,
		lastrobbed = 0
	},
	["Prosperity St"] = {
		position = { ['x'] = -1487.1322021484, ['y'] = -375.54638671875, ['z'] = 39.163433074951 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Prosperity St Robs Liquor",
		index = "pst",
		x = -1487.12,
		y = -375.55,
		z = 39.16,
		lastrobbed = 0
	},
	["Barbareno Road Great Ocean"] = {
		position = { ['x'] = -3241.7280273438, ['y'] = 999.95611572266, ['z'] = 11.830716133118 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Barbareno Road(Great Ocean) 24/7 Supermarket",
		index = "brgo",
		x = -3241.72,
		y = 999.95,
		z = 11.83,
		lastrobbed = 0
	},
	["North Rockford Dr"] = {
		position = { ['x'] = -1828.9028320313, ['y'] = 798.63702392578, ['z'] = 137.18780517578 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "North Rockford Dr LTD Gas Station",
		index = "ntdr",
		x = -1828.90,
		y = 798.63,
		z = 137.18,
		lastrobbed = 0
	},
	["Great Ocean Hway East"] = {
		position = { ['x'] = 1727.6282958984, ['y'] = 6414.7607421875, ['z'] = 34.037220001221 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Great Ocean Hway East 24/7 Supermarket",
		index = "gohe",
		x = 1727.62,
		y = 6414.76,
		z = 34.03,
		lastrobbed = 0
	},
	["Alhambra Dr Sandy"] = {
		position = { ['x'] = 1960.3529052734, ['y'] = 3739.4997558594, ['z'] = 31.343742370605 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Alhambra Dr Sandy 24/7 Supermarket",
		index = "ads",
		x = 1960.35,
		y = 3739.50,
		z = 31.34,
		lastrobbed = 0
	},
	["Palomino Fwy Reststop"] = {
		position = { ['x'] = 2549.2858886719, ['y'] = 384.96740722656, ['z'] = 107.62294769287 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Palomino Fwy Reststop 24/7 Supermarket",
		index = "pfr",
		x = 2549.28,
		y = 384.96,
		z = 107.62,
		lastrobbed = 0
	},
	["Clinton Ave"] = {
		position = { ['x'] = 372.36227416992, ['y'] = 325.90933227539, ['z'] = 102.56638336182 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Clinton Ave 24/7 Supermarket",
		index = "ca",
		x = 372.36,
		y = 325.90,
		z = 102.56,
		lastrobbed = 0
	},
	["Grove St/Davis St"] = {
		position = { ['x'] = -47.860702514648, ['y'] = -1759.3477783203, ['z'] = 28.421016693115 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Grove St/Davis St LTD Gas Station",
		index = "gstdst",
		x = -47.86,
		y = -1759.34,
		z = 28.42,
		lastrobbed = 0
	},
	["Innocence Blvd"] = {
		position = { ['x'] = 24.360492706299, ['y'] = -1347.8098144531, ['z'] = 28.497026443481 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Innocence Blvd 24/7 Supermarket",
		index = "ib",
		x = 24.36,
		y = -1347.80,
		z = 28.49,
		lastrobbed = 0
	},
	["San Andreas Ave"] = {
		position = { ['x'] = -1220.7747802734, ['y'] = -915.93646240234, ['z'] = 10.326335906982 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "San Andreas Ave Robs Liquor",
		index = "saa",
		x = -1220.77,
		y = -915.93,
		z = 10.32,
		lastrobbed = 0
	},
	["Route 68 Outside Sandy"] = {
		position = { ['x'] = 1169.2320556641, ['y'] = 2717.8083496094, ['z'] = 36.157665252686 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Route 68 Outside Sandy 24/7 Supermarket",
		index = "ros",
		x = 1169.23,
		y = 2717.80,
		z = 36.15,
		lastrobbed = 0
	},
	["Great Ocean Hway"] = {
		position = { ['x'] = -2959.6359863281, ['y'] = 387.15356445313, ['z'] = 13.043292999268 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Great Ocean Hway Robs Liquor",
		index = "goh",
		x = -2959.63,
		y = 387.15,
		z = 13.04,
		lastrobbed = 0
	},
	["Inseno Rd Great Ocean"] = {
		position = { ['x'] = -3038.9475097656, ['y'] = 584.53924560547, ['z'] = 6.9089307785034 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Inseno Rd Great Ocean 24/7 Supermarket",
		index = "irgo",
		x = -3038.94,
		y = 584.53,
		z = 6.90,
		lastrobbed = 0
	},	
	["Grapeseed Main St"] = {
		position = { ['x'] = 1707.8717041016, ['y'] = 4920.2475585938, ['z'] = 41.063678741455 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Grapeseed Main St 24/7 Supermarket",
		index = "gmst",
		x = 1707.87,
		y = 4920.24,
		z = 41.06,
		lastrobbed = 0
	},	
	["Algonquin Blvd"] = {
		position = { ['x'] = 1392.9791259766, ['y'] = 3606.5573730469, ['z'] = 33.980918884277 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Algonquin Blvd Ace Liquors",
		index = "ab",
		x = 1392.97,
		y = 3606.55,
		z = 33.98,
		lastrobbed = 0
	},	
	["Panorama Dr"] = {
		position = { ['x'] = 1982.5057373047, ['y'] = 3053.4697265625, ['z'] = 46.215065002441 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Panorama Dr Yellow Jack Inn",
		index = "pdr",
		x = 1982.50,
		y = 3053.45,
		z = 46.21,
		lastrobbed = 0
	},	
	["Senora Fwy Sandy"] = {
		position = { ['x'] = 2678.1394042969, ['y'] = 3279.3344726563, ['z'] = 54.241130828857 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Senora Fwy Sandy 24/7 Supermarket",
		index = "sfs",
		x = 2678.13,
		y = 3279.33,
		z = 54.24,
		lastrobbed = 0
	},
	["Mirror Park Blvd"] = {
		position = { ['x'] = 1159.5697021484, ['y'] = -314.11761474609, ['z'] = 68.205139160156 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "Mirror Park Blvd LTD Gas Station",
		index = "mpb",
		x = 1159.56,
		y = -314.11,
		z = 68.20,
		lastrobbed = 0
	},	
	["El Rancho Blvd"] = {
		position = { ['x'] = 1134.2387695313, ['y'] = -982.76049804688, ['z'] = 45.415843963623 },
		reward = 100 + math.random(50000,65000),
		nameofbank = "El Rancho Blvd Robs Liquor",
		index = "erb",
		x = 1134.2387695313,
		y = -982.76,
		z = 45.41,
		lastrobbed = 0
	}	
}

local robbers = {}

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('es_bank:toofar')
AddEventHandler('es_bank:toofar', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_bank:toofarlocal', source)
		robbers[source] = nil
		local playerName =  "^4[Metropolitan Police] ^7"
		local players = GetPlayers()
		for i,v in pairs(players) do 
			local name = GetPlayerName(v)
			local user_id = HVC.getUserId({v})   
			if HVC.hasPermission({user_id, "police.menu"}) then
            	TriggerClientEvent('chatMessage', v, playerName, { 128, 128, 128 }, "^6Robbery was cancelled at: ^2" .. banks[robb].nameofbank, "metpd")
			end
		end
	end
end)

RegisterServerEvent('es_bank:playerdied')
AddEventHandler('es_bank:playerdied', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_bank:playerdiedlocal', source)
		robbers[source] = nil
		local playerName =  "^4[Metropolitan Police] ^7"
		local players = GetPlayers()
		for i,v in pairs(players) do 
			local name = GetPlayerName(v)
			local user_id = HVC.getUserId({v})   
			if HVC.hasPermission({user_id, "police.menu"}) then
            	TriggerClientEvent('chatMessage', v, playerName, { 128, 128, 128 }, "^6Robbery was cancelled at: ^2" .. banks[robb].nameofbank, "metpd")
			end
		end
	end
end)

RegisterServerEvent('es_bank:rob')
AddEventHandler('es_bank:rob', function(robb)
  local user_id = HVC.getUserId({source})
  local player = HVC.getUserSource({user_id})
  local cops = HVC.getUsersByGroup({"cop"}) -- remember to use the cop group or this won't work - K > Admin > Add Group > User ID > cop
  if HVC.hasPermission({user_id, "police.menu"}) then
    HVCclient.notify(player,{"~r~Officers cannot start robberies."})
  else
    if #cops >= 0 then -- change 2 to the minimum amount online necessary
	  if banks[robb] then
		  local bank = banks[robb]

		  if (os.time() - bank.lastrobbed) < 600 and bank.lastrobbed ~= 0 then
			HVCclient.notify(player,{"~r~This store has already been hit. You'll have to wait another: " .. (1200 - (os.time() - bank.lastrobbed)) .. " seconds."})
			  return
		  end
		local playerName =  "^4[Metropolitan Police] ^7"
		local players = GetPlayers()
		for i,v in pairs(players) do 
			local name = GetPlayerName(v)
			local user_id = HVC.getUserId({v})   
			if HVC.hasPermission({user_id, "police.menu"}) then
            	TriggerClientEvent('chatMessage', v, playerName, { 128, 128, 128 }, "^6Robbery in progress at ^1" .. bank.nameofbank, "metpd")
			end
		end
		  local x = bank.x
		  local y = bank.y
		  local z = bank.z
		  TriggerClientEvent("HVC:StorerobberyBlip", -1, banks[robb].index)
		  HVCclient.notify(player,{"~g~Store robbery started, stay low for 3 minutes and the money is yours."})
		  TriggerClientEvent('es_bank:currentlyrobbing', player, robb)
		  banks[robb].lastrobbed = os.time()
		  robbers[player] = robb
		  local savedSource = player
		  SetTimeout(180000, function()
				if(user_id)then
					local money = math.random(50000, 60000)
					HVC.giveMoney({user_id,money})
					for i,v in pairs(players) do 
						local user_id = HVC.getUserId({v})   
						if HVC.hasPermission({user_id, "police.menu"}) then
							TriggerClientEvent('chatMessage', v, 'NEWS', {255, 0, 0}, "Robbery is over at: ^2" .. bank.nameofbank .. "^0!")
						end
					end
					TriggerClientEvent('es_bank:robberycomplete', savedSource, money)
				end
		  end)		
	  end
    else
      HVCclient.notify(player,{"~r~Not enough cops online."})
    end
	end
end)