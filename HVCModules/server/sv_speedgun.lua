local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVC_SpeedGun")


RegisterServerEvent("HVC:FineSpeedingCunt")
AddEventHandler("HVC:FineSpeedingCunt",function(target, speed)
    local source = source
    local source_id = HVC.getUserId({source})
    if target == -1 then
		local curdate = os.time() + (60 * 60 * 500000)
		HVC.BanUser(source, "Triggering Events with blacklisted arguments", curdate, "HVC")
    else
        if HVC.hasPermission({source_id, "police.menu"}) then
            local user_id = HVC.getUserId({target})
            local newmoney = HVC.getBankMoney({user_id}) - (speed * 100)
            local TargetName = GetPlayerName(target)
            local newmoney2 = HVC.getBankMoney({source_id}) + ((speed * 100) * 0.20)
            HVC.setBankMoney({user_id, newmoney})
            HVC.setBankMoney({source_id, newmoney2})
            HVCclient.notify(target, {"~r~You have been fined for £" ..(speed * 100).. " for going " ..speed.. " MPH"})
            HVCclient.notify(source, {"~g~You have fined " .. TargetName .." £" ..(speed * 100).. " for going " ..speed.. " MPH "})
            TriggerClientEvent("FINE.EXE", target)
        else
            print("UserID " ..source_id.. " triggered event without permission.")
        end
    end
end)
