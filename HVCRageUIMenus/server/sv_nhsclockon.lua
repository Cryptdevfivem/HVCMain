local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVCRageUIMenus")


RegisterNetEvent("HVC:NHSStartShift")
AddEventHandler("HVC:NHSStartShift", function(Group)
    local source = source
    local coords = GetEntityCoords(GetPlayerPed(source))
    local UserID = HVC.getUserId({source})
    for k,v in pairs(Config.NhsClock) do
        if #(coords - vector3(v[1],v[2],v[3])) < 2.5 then
            if HVC.hasGroup({UserID, "ems"}) then
                for _ ,v in pairs(Config.NHSGroups) do 
                    if v.group == Group then
                        HVC.addUserGroup({UserID, v.group})
                        HVCclient.notify(source, {"~g~You have clocked on as " ..v.group})
                    end
                end
            else
                HVCclient.notify(source, {"~r~You do not have permission to clock on"})
            end
        end
    end
end)