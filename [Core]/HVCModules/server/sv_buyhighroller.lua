local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVC_BoatRentals")


local function logLicense2(license, userid, source, amount)
    local amount = amount
    local license = license
    local logs = "https://discord.com/api/webhooks/903483916458008576/ih1Yc1iUpzPlBJR2SHdjJljYGfiH6tpEkpCo5QyYzNntGECMTb-MYh3ugQDcpWkaTX65"
    local name = GetPlayerName(source)
    local ping = GetPlayerPing(source)
    local tempid = GetPlayerGuid(source)
    local communityname = "HVC Diamond Casino & Resort"
    local communtiylogo = "" --Must end with .png or .jpg

    local command = {
        {
            ["fields"] = {
                {
                    ["name"] = "**Player Name**",
                    ["value"] = "" ..GetPlayerName(source),
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player TempID**",
                    ["value"] = "" ..source,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player PermID**",
                    ["value"] = "" ..HVC.getUserId({source}),
                    ["inline"] = true
                },
                {
                    ["name"] = "**Price**",
                    ["value"] = "" ..amount,
                    ["inline"] = true
                },
                {
                    ["name"] = "**License**",
                    ["value"] = "" ..license,
                    ["inline"] = true
                },
            },
            ["color"] = "8663711",
            ["title"] = "Highroller Purchased",
            ["description"] = "",
            ["footer"] = {
            ["text"] = communityname,
            ["icon_url"] = communtiylogo,
            },
        }
    }
        
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Diamond Casino & Resort", embeds = command}), { ['Content-Type'] = 'application/json' })

end

RegisterServerEvent("HVCServer:DiamondCasinoBuyHighroller")
AddEventHandler('HVCServer:DiamondCasinoBuyHighroller', function(price)
    local source = source
    local userid = HVC.getUserId({source})

    --if #(coords - comparison) > 20 then

        --return
    --end

    if tonumber(price) < 9999999 then 

        return
    end
    if HVC.hasGroup({userid, "highroller"}) then
        HVCclient.notify(source, {"~r~You Already Have This License"})
    else
        if HVC.tryFullPayment({userid, price}) then
            HVC.addUserGroup({userid,"highroller"})
            HVCclient.notify(source, {"~g~Paid £" ..tostring(price)})
            logLicense2("Highroller", userid, source, "10000000")
        else 
            HVCclient.notify(source, {"~r~Insufficient Funds"})
        end
    end
end)