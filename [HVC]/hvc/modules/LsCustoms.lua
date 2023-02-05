--[[
HVC Los Santos Customs V1.2
Credits - MythicalBro and マーモット#2533 for the HVC version and some bug fixes
]]



local tbl = {
	[1] = {locked = false, player = nil},
	[2] = {locked = false, player = nil},
	[3] = {locked = false, player = nil},
	[4] = {locked = false, player = nil},
	[5] = {locked = false, player = nil},
	[6] = {locked = false, player = nil},
}

RegisterServerEvent('lockGarage')
AddEventHandler('lockGarage', function(b,garage)
	tbl[tonumber(garage)].locked = b
	if not b then
		tbl[tonumber(garage)].player = nil
	else
		tbl[tonumber(garage)].player = source
	end
	TriggerClientEvent('lockGarage',-1,tbl)
end)

RegisterServerEvent('getGarageInfo')
AddEventHandler('getGarageInfo', function()
	TriggerClientEvent('lockGarage',-1,tbl)
end)

AddEventHandler('playerDropped', function()
	for i,g in pairs(tbl) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
				TriggerClientEvent('lockGarage',-1,tbl)
			end
		end
	end
end)

RegisterServerEvent("LSC:buttonSelected")
AddEventHandler("LSC:buttonSelected", function(name, button)
	local source = source
	local user_id = HVC.getUserId(source)
	if user_id then
		TriggerClientEvent("LSC:buttonSelected", source, name, button, HVC.tryFullPayment(HVC.getUserId(source), button.price or 0)) -- money
	end
end)

RegisterServerEvent("LSC:finished")
AddEventHandler("LSC:finished", function(veh)
	local source = source
	local user_id = HVC.getUserId(source)
	if user_id then
		MySQL.execute("HVCls/update_vehicle_modifications", {user_id = user_id, vehicle = veh.model, modifications = json.encode({color = veh.color, extraColor = veh.extracolor, neon = veh.neon, neonColor = veh.neoncolor, xenonColor = veh.xenoncolor, smokeColor = veh.smokecolor, wheelType = veh.wheeltype, bulletProofTyres = veh.bulletProofTyres, windowTint = veh.windowtint, plateIndex = veh.plateindex, mods = veh.mods})})
	end
end)

RegisterServerEvent("LSC:applyModifications")
AddEventHandler("LSC:applyModifications", function (model, vehicle)
	local source = source
	local user_id = HVC.getUserId(source)
	local PlayerMoney = HVC.getBankMoney(user_id)
	local TakenMoney = math.floor(PlayerMoney*0.01/100)

	if HVC.tryBankPayment(user_id, math.floor(PlayerMoney*0.01/100)) then
		HVCclient.notify(source, {"~g~Paid £" ..Comma(TakenMoney).." for vehicle tax."})
	end
	
	if model and vehicle and user_id then
		local rows = MySQL.query("HVCls/get_vehicle_modifications", {user_id = user_id, vehicle = model}, function(rows, affected) 
			if rows ~= nil then 
				if #rows > 0 then
					local modifications = json.decode(rows[1].modifications)
					if modifications then
						TriggerClientEvent("LSC:applyModifications", source, vehicle, modifications)
					end
				else
					print("#rows is 0")
				end
			else
				print("rows is nil. line 91")
			end
		end)
	end
end)

function Comma(amount)
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
  end