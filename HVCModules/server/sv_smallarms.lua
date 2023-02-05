--[[ocal Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVC_gunshop")
local perm = "player.phone"

function logsmall(hash, user_id, source, amount)
    local amount = amount
    local source = source
    local userid = HVC.getUserId({source})
    local hash = hash
    local logs = "https://canary.discord.com/api/webhooks/886254634887434270/JfHY9FRW0hSKQbUo3TCytngg_PZguJZnHOZLs-ac3qEtlnqXKUb1C6T3JZItchP80vJ4"
    local name = GetPlayerName(source)
    local ping = GetPlayerPing(source)
    local communityname = "HVC Small Logs | Made By The HVC Development Team"
    local communtiylogo = "https://cdn.discordapp.com/attachments/884565104178364487/884823523024072784/agawe.png" --Must end with .png or .jpg

    local command = {
        {
            --[[["fields"] = {
                {
                    ["name"] = "**Player Name:**",
                    ["value"] = GetPlayerName(source),
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player TempID:**",
                    ["value"] = source,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player PermID:**",
                    ["value"] = user_id,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Weapon Name:**",
                    ["value"] = hash,
                    ["inline"] = true
                },
                {
                    ["name"] = "**Weapon Price:**",
                    ["value"] = price,
                    ["inline"] = true
                },
            },
            ["color"] = "8663711",
            ["title"] = "HVC Small Logs",
            ["description"] = "**Player Name:** " ..GetPlayerName(source).. "\n**Player TempID: **" ..source.. "\n**Player PermID: **" ..user_id.. "\n**Weapon Name: **" .. hash .. "\n**Weapon Price: **" ..amount,
            ["footer"] = {
            ["text"] = communityname,
            ["icon_url"] = communtiylogo,
            },
        }
    }
        
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Small Logs", embeds = command}), { ['Content-Type'] = 'application/json' })

end

function logArmour(level, userid, source, amout)
    local amount = amount
    local level = level
    local armourlogs = ""
    local name = GetPlayerName(source)
    local ping = GetPlayerPing(source)
    local tempid = GetPlayerGuid(source)
    local communityname = "HVC Small Armour Logs | Made By The HVC Development Team"
    local communtiylogo = "" --Must end with .png or .jpg

    local command = {
        {
            ["color"] = "8663711",
            ["title"] = "HVC Small Logs",
            ["description"] = "Player: **"..name.."\nPermID: " .. userid .. "**```"
             .. "\nPrice: " .. amount .. "\nItem: " .. hash ..
             "```",
            ["footer"] = {
            ["text"] = communityname,
            ["icon_url"] = communtiylogo,
            },
        }
    }
        
    PerformHttpRequest(armourlogs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Small Logs", embeds = command}), { ['Content-Type'] = 'application/json' })

end


RegisterServerEvent("SmallArms:buywap")
AddEventHandler('SmallArms:buywap', function(price, hash, name)
    local source = source
    local userid = HVC.getUserId({source})
    local admin_name = "HVC Anticheat"
    local reason1 = "Type#1"
    local reason = "Type#2"
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(-1499.76,-216.65,47.89)
    local pricemismatch = false 
    local curdate = os.time()
    curdate = curdate + (60 * 60 * 500000)

    if #(coords - comparison) > 30 then
        TriggerClientEvent("chatMessage", -1, "^1^*[HVC Anticheat]", {180, 0, 0}, GetPlayerName(source) .. " ^7 Was Banned | Reason: Type#oneteen")
        HVC.ban({source,reason1,curdate,admin_name})
        return
    end
    if price < 49999 then
        TriggerClientEvent("chatMessage", -1, "^1^*[HVC Anticheat]", {180, 0, 0}, GetPlayerName(source) .. " ^7 Tried To Buy A " ..name.. " For " ..price.. ".")
        HVC.ban({source,reason1,curdate,admin_name})
        return
    end
    if perm ~= nil then 
        if HVC.hasPermission({userid, perm}) then
            if HVC.tryPayment({userid, price}) then
                TriggerClientEvent("SmallArms:givewap", source,  hash)
                logSmall(name, userid, source, price)
                HVCclient.notify(source, {"~g~Purchased, "..name.." For Price: £" ..price})
            else 
                TriggerClientEvent("SmallArms:menu", source, false)
                HVCclient.notify(source, {"~r~Insufficient funds"})
            end
        else
            HVCclient.notify(source, {"~r~You do not have permission to buy guns"})
        end
    else 
        if HVC.tryPayment({userid, price}) then
            TriggerClientEvent("SmallArms:givewap", source,  hash)
            logSmall(hash, userid, source, price)
            HVCclient.notify(source, {"~g~Paid £"..price})
        else 
            TriggerClientEvent("SmallArms:menu", source, false)
            HVCclient.notify(source, {"~r~Insufficient funds"})
        end
    end
end)


RegisterServerEvent("Small:buyarmour")
AddEventHandler('Small:buyarmour', function(price, level)
    local source = source
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(-1499.76,-216.65,47.89)
    local reason1 = "CAS1.1"
    local reason = "CAS1.2"
    local admin_name = "HVC Anticheat"
    local pricemismatch = false 
    local curdate = os.time()
    curdate = curdate + (60 * 60 * 500000)
    local playerid = HVC.getUserId({source})
    
    if perm ~= nil then 
        if HVC.hasPermission({playerid, perm}) then
            if HVC.tryPayment({playerid, price}) then
                TriggerClientEvent("SmallArms:givearmour", source, level)
                TriggerClientEvent("HVC:ServerGotArmd", source)
                logSmall(level, userid, source, price)
                HVCclient.notify(source, {"~g~Paid £"..price})
            else 
                TriggerClientEvent("SmallArms:menu", source, false)
                HVCclient.notify(source, {"~r~Insufficient funds"})
            end
        else
            HVCclient.notify(source, {"~r~You do not have permission to buy guns"})
        end
    else 
        if HVC.tryPayment({playerid, price}) then
            TriggerClientEvent("SmallArms:givearmour", source,  level)
            TriggerClientEvent("HVC:ServerGotArmd", source)
            logSmall(level, userid, source, price)
            HVCclient.notify(source, {"~g~Paid £"..price})
        else 
            TriggerClientEvent("SmallArms:armour", source, false)
            HVCclient.notify(source, {"~r~Insufficient funds"})
        end
    end
end)


local weaponwhitelists = { 

    --{name = "", gunhash = "", permid = "", price = ""},
    {name = "Crutch", gunhash = "WEAPON_CRUTCHHVC", permid = 1, price = 60000},

}



RegisterServerEvent("HVC:smallBuyWapwl")
AddEventHandler(
    "HVC:smallBuyWapwl",
    function(price, hash)
        local source = source
        local coords = GetEntityCoords(GetPlayerPed(source))
        local comparison = vector3(-1106.67, 4935.38, 218.37)
        if #(coords - comparison) > 20 then
            TriggerClientEvent("HVC:DEEEATH", source, "Tried hacking small with distance: " .. #(coords - comparison))
            return
        end
        local hash = hash
        local foundweapon = false
        local pricemismatched = false
        local userid = HVC.getUserId({source})
        if HVC.hasPermission({userid, perm}) then
            for i, v in pairs(weaponwhitelists) do
                if v.gunhash == hash and tonumber(v.permid) == tonumber(userid) then
                    foundweapon = true
                    if HVC.tryPayment({userid, price}) then
                        if tonumber(v.price) ~= tonumber(price) then
                            pricemismatched = true
                            return
                        end
                        foundweapon = true
                        local kgcheck = HVC.getItemWeight({hash})
                        local kgcheck2 = HVC.getItemWeight({hash .. "_ammo"})
                        local currentw = HVC.getInventoryWeight({userid})
                        local maxw = HVC.getInventoryMaxWeight({userid})
                        if (currentw + kgcheck) + (kgcheck2 * 250) > maxw then
                            HVCclient.notify(source, "~r~You Do Not Have Enough Inventory Space To Buy This Weapon")
                            HVC.giveMoney(userid, price)
                        else
                            TriggerClientEvent("SmallArms:givewap", source, hash)
                            HVCclient.notify(source, {"~g~Paid £" .. price})
                            if pricemismatched == true then
                                TriggerClientEvent("HVCClient:CAS23")
                            end
                            if foundweapon == false then
                                TriggerClientEvent("HVCClient:CAS23")
                            end
                            return
                        end
                    else
                        HVCclient.notify(source, {"~r~Insufficient funds"})
                    end
                end
            end
            if pricemismatched == true then
                TriggerClientEvent("HVCClient:CAS23")
            end
            if foundweapon == false then
                TriggerClientEvent("HVCClient:CAS23")
            end
        else
            HVCclient.notify(source, {"~r~You do not have permission to buy guns"})
        end
    end
)


RegisterServerEvent("HVC:PULLWHITELISTEDWEAPONSHVCSMALL")
AddEventHandler("HVC:PULLWHITELISTEDWEAPONSHVCSMALL", function()
    local source = source
    local table = {}
    local user_id = HVC.getUserId({source})
    for i,v in pairs(weaponwhitelists) do
        if v.permid == user_id then 
       table[i] = {name = v.name, gunhash = v.gunhash, price = v.price}
        end 
end 
Wait(300)
TriggerClientEvent("HVC:GUNSRETURNEDHVCSMALL", source,table)
end)
]]