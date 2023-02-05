local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVC_RadialMenu")

RegisterServerEvent("HVC:PoliceCheck")
AddEventHandler("HVC:PoliceCheck", function()
    local source = source
    local user_id = HVC.getUserId({source})
    if HVC.hasPermission({user_id, "police.menu"}) then
        MetPD = true
    else
        MetPD = false
    end
    TriggerClientEvent("HVC:PoliceClockedOn", source, MetPD)
end)

RegisterServerEvent("HVC:PoliceCheck2")
AddEventHandler("HVC:PoliceCheck2", function()
    local source = source
    local user_id = HVC.getUserId({source})
    if HVC.hasPermission({user_id, "police.menu"}) then
        MetPD = true
    else
        MetPD = false
    end
    TriggerClientEvent("HVC:PoliceClockedOn2", source, MetPD)
end)

RegisterServerEvent("Vrxith:RepairVehicle")
AddEventHandler("Vrxith:RepairVehicle", function()
  local source = source
  local user_id = HVC.getUserId({source})
  if user_id ~= nil then
  
    if HVC.tryGetInventoryItem({user_id,"repairkit",1,true}) then
      HVCclient.playAnim(source,{false,{task="WORLD_HUMAN_WELDING"},false})
      SetTimeout(15000, function()
        HVCclient.fixeNearestVehicle(source,{7})
        HVCclient.stopAnim(source,{false})
      end)
    end
  end
end)