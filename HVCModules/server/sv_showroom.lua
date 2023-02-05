local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "Vrxith_ShowRoom")



RegisterServerEvent("HVC:VrxithSimeonsPurchaceCar")
AddEventHandler("HVC:VrxithSimeonsPurchaceCar",function(price, spawncode)
    local source = source
    local player_id = HVC.getUserId({source})
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(-29.94, -1105.06, 26.42)

    if #(coords - comparison) > 30 then
        TriggerClientEvent("chatMessage", -1, "^1^*[HVC Anticheat]", {180, 0, 0}, GetPlayerName(source) .. " ^7 Was Banned | Reason: Type #11")
        HVC.BanUser({source, "Type #11", curdate, "HVC"})
        return
    end

    if HVC.tryPayment({player_id, price}) or HVC.tryBankPayment({player_id, price}) then
        if HVC.hasPermission({player_id, "player.phone"}) then
            --[[local logs = "" -- Main Discord | HVC
            local communityname = "HVC Staff Logs"
            local communtiylogo = "" --Must end with .png or .jpg

            local command = {
                {
                    ["color"] = "1170250",
                    ["title"] = "Donation Support (Add Car)",
                    ["description"] = "Admin Name: **" ..admin_name.. "**\nAdmin Perm ID:  **" ..admin_id.. "**\nAdmin Temp ID:  **" ..admin.. "**\n\nPlayer Perm ID: **".. player_id.."**\nCar Add: **"..car.."**",
                    ["footer"] = {
                    ["text"] = communityname,
                    ["icon_url"] = communtiylogo,
                    },
                }
            }
            
            PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json'})
]]
            exports['ghmattimysql']:execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {user_id = player_id, vehicle = spawncode}, function() end)
            HVCclient.notify(source, {"~g~Successfully Purchased Vehicle, Go to the nearest garage to pick up your vehicle."})
        end
    else
        print("ERROR.")
    end
end)
