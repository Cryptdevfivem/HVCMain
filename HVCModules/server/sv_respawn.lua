local Proxy = module("hvc", "lib/Proxy")
local Tunnel = module("hvc","lib/Tunnel")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC","HVC")

RegisterServerEvent("HVC:GlobalPoliceCheck")
AddEventHandler("HVC:GlobalPoliceCheck", function()
    local source = source
    local user_id = HVC.getUserId({source})
    if HVC.hasPermission({user_id, "police.menu"}) then
      MetPD = true
    else
      MetPD = false
    end
    TriggerClientEvent("HVC:PoliceClockedOnRSP", source, MetPD)
end)

RegisterServerEvent("HVC:GlobalRebelCheck")
AddEventHandler("HVC:GlobalRebelCheck", function()
    local source = source
    local user_id = HVC.getUserId({source})
    if HVC.hasPermission({user_id, "rebel.license"}) then
      Rebel = true
    else
      Rebel = false
    end
    TriggerClientEvent("HVC:HasRebelRSP", source, Rebel)
end)

RegisterServerEvent("HVC:GlobalVIPCheck")
AddEventHandler("HVC:GlobalVIPCheck", function()
    local source = source
    local user_id = HVC.getUserId({source})
    if HVC.hasPermission({user_id, "vip.garage"}) then
      VIP = true
    else
      VIP = false
    end
    TriggerClientEvent("HVC:HasVIPRSP", source, VIP)
end)



----------------------------- Simeons

RegisterServerEvent("HVC:GlobalPoliceCheckSMIS")
AddEventHandler("HVC:GlobalPoliceCheckSMIS", function()
    local source = source
    local user_id = HVC.getUserId({source})
    if HVC.hasPermission({user_id, "police.menu"}) then
      MetPD = true
    else
      MetPD = false
    end
    TriggerClientEvent("HVC:PoliceClockedOnSMS", source, MetPD)
end)


RegisterServerEvent("HVC:GlobalNHSCheckSMIS")
AddEventHandler("HVC:GlobalNHSCheckSMIS", function()
    local source = source
    local user_id = HVC.getUserId({source})
    if HVC.hasPermission({user_id, "emscheck.revive"}) then
      MetPD = true
    else
      MetPD = false
    end
    TriggerClientEvent("HVC:NHSClockedOnSMS", source, MetPD)
end)
