local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC","HVC_barbershop")


RegisterServerEvent("HVC:SavePedData")
AddEventHandler("HVC:SavePedData", function(value)
  local user_id = HVC.getUserId({source})
  if user_id ~= nil then
    HVC.setUData({user_id,"HVC:head:overlay",json.encode(value)})
    --print(json.encode(value))
  end
end)

RegisterServerEvent("HVC:LoadPlayerSets")
AddEventHandler("HVC:LoadPlayerSets", function()
  local source = source
  local user_id = HVC.getUserId({source})
  if user_id ~= nil then
    HVC.getUData({user_id,"HVC:head:overlay",function(value)
      --print("Values\n" ..value)
      if value ~= nil then
          TriggerClientEvent("HVC:setOverlay", source, json.decode(value))
      end
    end})
  end
end)


AddEventHandler("HVC:playerSpawn",function(user_id, source)
    HVC.getUData({user_id,"HVC:head:overlay",function(value)
        --print("Values\n" ..value)
        if value ~= nil then
            TriggerClientEvent("HVC:setOverlay", source, json.decode(value))
        end
    end})
end)

