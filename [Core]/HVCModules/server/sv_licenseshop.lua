local Proxy = module("hvc", "lib/Proxy")
local Tunnel = module("hvc","lib/Tunnel")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC","HVC_drugs")

local function logLicense(license, userid, source, amount)
    local amount = amount
    local license = license
    local user_id = HVC.getUserId({source})
    local logs = "https://canary.discord.com/api/webhooks/889758559649267772/YKmzdK7Po5FCPzXQMfFW00VyqoTu0bso2cN7Ma4-G_9Eq1vRJf6Mwu_tcorolr3KgJKc"
    local name = GetPlayerName(source)
    local ping = GetPlayerPing(source)
    local tempid = GetPlayerGuid(source)
    local communityname = "HVC Shop Logs"
    local communtiylogo = "" --Must end with .png or .jpg

    local command = {
        {
            ["fields"] = {
                {
                    ["name"] = "**Player Name**",
                    ["value"] = "" ..name,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player TempID**",
                    ["value"] = "" ..source,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player PermID**",
                    ["value"] = "" ..user_id,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Price**",
                    ["value"] = "£" .. amount,
                    ["inline"] = true
                },
                {
                    ["name"] = "**License Name**",
                    ["value"] = ""..license,
                    ["inline"] = true
                },
            },
            ["color"] = "9837571",
            ["title"] = "HVC License Logs",
            ["description"] = "",
            ["footer"] = {
            ["text"] = communityname,
            ["icon_url"] = communtiylogo,
            },
        }
    }
        
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "Shop Logs", embeds = command}), { ['Content-Type'] = 'application/json' })

end

local ValidLicenses = {
    ["coal"] = true,
    ["iron"] = true,
    ["gold"] = true,
    ["diamond"] = true,
    ["ethereum"] = true,
    ["oil"] = true,
    ["weed"] = true,
    ["cocaine"] = true,
    ["large"] = true,
    ["meth"] = true,
    ["mdma"] = true,
    ["heroin"] = true,
    ["rebel"] = true,
    ["lsd"] = true,
    ["dmt"] = true,
}

RegisterServerEvent("HVC:BuyLicenses")
AddEventHandler("HVC:BuyLicenses", function(Price, Group, Name)
    local source = source
    local userid = HVC.getUserId({source})
    local player = GetPlayerPed(source)
    local coords = GetEntityCoords(player)
    local licenses = vector3(-546.99,-200.42,47.41)
    local curdate = os.time()
    curdate = curdate + (60 * 60 * 500000)

    if #(coords - licenses) > 20 then
        TriggerClientEvent("chatMessage", -1, "^7^*[HVC Anticheat]", {180, 0, 0}, GetPlayerName(source) .. " ^7 Was Banned | Reason: Type #9")
        HVC.BanUser({source, "Type #9", curdate, "HVC"})
    end

    if not ValidLicenses[Group] then
        TriggerClientEvent("chatMessage", -1, "^7^*[HVC]", {180, 0, 0}, GetPlayerName(source) .. " ^7 Was Banned | Reason: Type #23")
        HVC.BanUser({source, "Type #23", curdate, "HVC"})
    end
    
    if HVC.hasGroup({userid, Group}) then
        HVCclient.notify(source, {"~r~You already have the license: " ..Name})
    else
        if HVC.tryFullPayment({userid, Price}) then
            logLicense(Name, userid, source, Price)
            HVC.addUserGroup({userid, Group})
            HVCclient.notify(source, {"~g~Purchased, "..Name.." For Price: £"..tostring(Price)})
        else 
            HVCclient.notify(source, {"~r~Insufficient funds"})
        end
    end
end)
