local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVCRageUIMenus")


RegisterNetEvent("HVC:StartShift")
AddEventHandler("HVC:StartShift", function(Group)
    local source = source
    local Ped = GetPlayerPed(source)
    local coords = GetEntityCoords(Ped)
    local UserID = HVC.getUserId({source})
    for k,v in pairs(Config.PoliceClock) do
        if #(coords - vector3(v[1],v[2],v[3])) < 2.5 then
            if HVC.hasGroup({UserID, "cop"}) then
                for _ ,v in pairs(Config.PoliceGroups) do
                    if v.group == Group then
                        if Group == "Unemployed" then
                            RemoveAllPedWeapons(Ped, true)
                            SetPedArmour(Ped, 0)

                        end
                        LogAction(source, v.group)
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

function LogAction(source, group)
    if group == "Unemployed" then
        local Message = {
            {
                ["color"] = "3093151",
                ["title"] = "Player has clocked off.",
                ["description"] = "Name: "..GetPlayerName(source).." /  User Id: " ..HVC.getUserId({source}).. " \nClocked on as: " ..group,
            }
        }
        PerformHttpRequest("https://discord.com/api/webhooks/906326371511464027/QmsbGel-PSb8QUXiSuNxJl1DiTgOabx1R074mC1RFykJ7CQoBtjhrcP1O3sFcws4qXG6", function(err, text, headers) end, "POST", json.encode({username = "HVC Met Police", embeds = Message}), { ["Content-Type"] = "application/json" })
    else
        local Message = {
            {
                ["color"] = "3093151",
                ["title"] = "Player has clocked on.",
                ["description"] = "Name: "..GetPlayerName(source).." /  User Id: " ..HVC.getUserId({source}).. " \nClocked on as: " ..group,
            }
        }
        PerformHttpRequest("https://discord.com/api/webhooks/906326371511464027/QmsbGel-PSb8QUXiSuNxJl1DiTgOabx1R074mC1RFykJ7CQoBtjhrcP1O3sFcws4qXG6", function(err, text, headers) end, "POST", json.encode({username = "HVC Met Police", embeds = Message}), { ["Content-Type"] = "application/json" })
    end
end