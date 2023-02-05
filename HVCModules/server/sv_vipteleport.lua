local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "Vrxith VIP Teleport")


RegisterServerEvent("HVC:VIPIslandTeleport")
AddEventHandler("HVC:VIPIslandTeleport", function(coords)
    local PlayerSrc = source
    local PlayerID = HVC.getUserId({PlayerSrc})

    if HVC.hasPermission({PlayerID, "vip.garage"}) then
        local PlayerPed = GetPlayerPed(PlayerSrc)
        HVCclient.ScreenFade(PlayerSrc)
        Wait(730)
        SetEntityCoords(PlayerPed, coords)
    else
        HVCclient.notify(PlayerSrc, {"~r~You do not have VIP Rank."})
    end
end)