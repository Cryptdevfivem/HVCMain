local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVCRageUIMenus")


RegisterServerCallback('HVC:GetPermission', function(source)
    local ReturnValue = 0;
    local PermID = HVC.getUserId({source})
    if HVC.hasGroup({PermID, "Commissioner"}) then
        ReturnValue = 7
    elseif HVC.hasGroup({PermID, "Deputy Commissioner"}) then
        ReturnValue = 7
    elseif HVC.hasGroup({PermID, "Assistant Commissioner"}) then
        ReturnValue = 7
    elseif HVC.hasGroup({PermID, "Deputy Assistant Commissioner"}) then
        ReturnValue = 7
    elseif HVC.hasGroup({PermID, "Commander"}) then
        ReturnValue = 6
    elseif HVC.hasGroup({PermID, "Chief Superintendent"}) then
        ReturnValue = 6
    elseif HVC.hasGroup({PermID, "Superintendent"}) then
        ReturnValue = 5
    elseif HVC.hasGroup({PermID, "Chief Inspector"}) then
        ReturnValue = 4
    elseif HVC.hasGroup({PermID, "Inspector"}) then
        ReturnValue = 4
    elseif HVC.hasGroup({PermID, "Sergeant"}) then
        ReturnValue = 3
    elseif HVC.hasGroup({PermID, "Senior Constable"}) then
        ReturnValue = 2
    elseif HVC.hasGroup({PermID, "Police Constable"}) then
        ReturnValue = 2
    elseif HVC.hasGroup({PermID, "PCSO"}) then
        ReturnValue = 1
    end
    if ReturnValue > 0 then
        return ReturnValue;
    else
        return 0;
    end
end)


function PoliceArmourLog(Item, source)
    local PlayerName = GetPlayerName(source)
    local UserId = HVC.getUserId({source})
    local Message = {
        {
            ["fields"] = {
                {
                    ["name"] = "**Player Name**",
                    ["value"] = PlayerName,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player UserId**",
                    ["value"] = UserId,
                    ["inline"] = true
                },
                {
                    ["name"] = "**What was taken from armoury**",
                    ["value"] = Item,
                    ["inline"] = true
                },
            },
            ["color"] = "15536128",
            ["title"] =  "**Police Armoury interaction**",
            ["thumbnail"] = {
                ["url"] = "https://cdn.discordapp.com/attachments/721345578075815966/892479760863756308/esreswrses.png",
            },
        }
    }
    PerformHttpRequest("https://discord.com/api/webhooks/906325690557796452/KZm3U7d-BTCQejFre6GtZhOwH8VGxFQlEgHnCYe-BDSSGuGISGfIp_b2i8Zppmb4M_Y8", function(err, text, headers) end, 'POST', json.encode({username = "HVC Police Armoury", embeds = Message}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("HVC:PurchaseKev")
AddEventHandler("HVC:PurchaseKev", function()
    local source = source
    local PermID = HVC.getUserId({source})
    local Ped = GetPlayerPed(source)
    local ReturnValue = 0;
    if HVC.hasGroup({PermID, "Commissioner"}) then
        ReturnValue = 7
    elseif HVC.hasGroup({PermID, "Deputy Commissioner"}) then
        ReturnValue = 7
    elseif HVC.hasGroup({PermID, "Assistant Commissioner"}) then
        ReturnValue = 7
    elseif HVC.hasGroup({PermID, "Deputy Assistant Commissioner"}) then
        ReturnValue = 7
    elseif HVC.hasGroup({PermID, "Commander"}) then
        ReturnValue = 6
    elseif HVC.hasGroup({PermID, "Chief Superintendent"}) then
        ReturnValue = 6
    elseif HVC.hasGroup({PermID, "Superintendent"}) then
        ReturnValue = 5
    elseif HVC.hasGroup({PermID, "Chief Inspector"}) then
        ReturnValue = 4
    elseif HVC.hasGroup({PermID, "Inspector"}) then
        ReturnValue = 4
    elseif HVC.hasGroup({PermID, "Sergeant"}) then
        ReturnValue = 3
    elseif HVC.hasGroup({PermID, "Senior Constable"}) then
        ReturnValue = 2
    elseif HVC.hasGroup({PermID, "Police Constable"}) then
        ReturnValue = 2
    elseif HVC.hasGroup({PermID, "PCSO"}) then
        ReturnValue = 1
    end
    if ReturnValue > 1 then
        TriggerEvent("HVC:ProvideArmour", source, 100)
        HVCclient.notify(source, {"~g~Applied 100% Kevlar"})
        TriggerClientEvent("HVC:ServerGotArmd", source)
        PoliceArmourLog("Applied 100% Kevlar", source)
    else
        TriggerEvent("HVC:ProvideArmour", source, 50)
        HVCclient.notify(source, {"~g~Applied 50% Kevlar"})
        TriggerClientEvent("HVC:ServerGotArmd", source)
        PoliceArmourLog("Applied 50% Kevlar", source)
    end
end)



RegisterNetEvent("HVC:PurchaseWeapon")
AddEventHandler("HVC:PurchaseWeapon", function(cfg, name)
    local source = source
    local PermID = HVC.getUserId({source})
    local Ped = GetPlayerPed(source)
    if cfg[name] and HVC.hasPermission({PermID, cfg[name].perm}) then
        HVCclient.WeaponType(source, {cfg[name].hash}, function(var)
            HVCclient.GetWeaponTypes(source, {}, function(types)
                if types[var] then
                    HVCclient.notify(source,{'~r~You already have a weapon of this type equipped.'})
                else
                    HVCclient.allowWeapon(source, {cfg[name].hash, "-1"})
                    HVCclient.notify(source, {"~g~Recieved "..name})
                    GiveWeaponToPed(Ped, cfg[name].hash, 250, false, false, 0)
                    PoliceArmourLog(cfg[name].hash, source)
                end
            end)
        end)
    else
        Log(source)
    end
end)



function Log(source)
    local Name = GetPlayerName(source)
    local PermID = HVC.getUserId({source})
    local communityname = "HVC Anticheat Logs"
    local communtiylogo = ""
    local command = {
        {
            ["color"] = "15536128",
            ["title"] = Name.. " has been banned for triggering event without permission",
            ["fields"] = {
                {
                    ["name"] = "**Player Name**",
                    ["value"] = "" ..Name,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player TempID**",
                    ["value"] = "" ..source,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player PermID**",
                    ["value"] = "" ..PermID,
                    ["inline"] = true
                },
            },
            ["description"] = "Event trigged: HVC:PurchaseWeapon",
            ["footer"] = {
            ["text"] = communityname,
            ["icon_url"] = communtiylogo,
            },
        }
    }
    PerformHttpRequest("https://canary.discord.com/api/webhooks/893174143246295090/Y_iOacr7fSFXO8fBrzn7D04ukag8Wm3DFCXm684pU-Ma6GisMRQKsT4vVU8AgqoxX8mm", function(err, text, headers) end, 'POST', json.encode({username = communityname, embeds = command}), { ['Content-Type'] = 'application/json' })
    local Time = os.time()
    Time = Time + (60 * 60 * 500000)
    HVC.BanUser({source, "Type #TE", Time, "HVC"})
end
