local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")

AddEventHandler("HVC:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		TriggerClientEvent('HVC:load', source, cfglocks.list)
	end
end)

Citizen.CreateThread(function()
  Citizen.Wait(1000)
  TriggerClientEvent('HVC:load', -1, cfglocks.list)
end)

RegisterServerEvent('HVC:open')
AddEventHandler('HVC:open', function(id)
	local user_id = HVC.getUserId({source})
	local player = HVC.getUserSource({user_id})
	if HVC.hasPermission({user_id, "#"..cfglocks.list[id].key..".>0"}) or HVC.hasPermission({user_id,cfglocks.list[id].permission}) then
		SetTimeout(100, function()
			cfglocks.list[id].locked = not cfglocks.list[id].locked
			TriggerClientEvent('HVC:statusSend', (-1), id,cfglocks.list[id].locked)
			if cfglocks.list[id].pair ~= nil then
				local idsecond = cfglocks.list[id].pair
				cfglocks.list[idsecond].locked = cfglocks.list[id].locked
				TriggerClientEvent('HVC:statusSend', (-1), idsecond,cfglocks.list[id].locked)
			end
			if cfglocks.list[id].locked then
				HVCclient.notify(player, {"~w~You ~d~closed ~w~the door."})
            elseif not cfglocks.list[id].locked then
				HVCclient.notify(player, {"~w~You ~g~opened ~w~the door."})
			end
		end)
	else
		if cfglocks.list[id].keyname ~= nil then
			HVCclient.notify(player, {"~d~You are not clocked on!"})
		else
			HVCclient.notify(player, {"~d~You are not police!"})
		end
	end
end)