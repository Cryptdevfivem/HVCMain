--[[local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVC_gunshop")
local perm = "rebel.license"

function logRebel(hash, user_id, source, amount)
    local amount = amount
    local source = source
    local userid = HVC.getUserId({source})
    local hash = hash
    local logs = "https://canary.discord.com/api/webhooks/886242443224289280/RRVe-H5-q_rMUYm23tWyfYIl4QVxN_Ma9f0E8lsBkqfVHZ8sgQ2fi1Te98YvQjKinu_E"
    local name = GetPlayerName(source)
    local ping = GetPlayerPing(source)
    local communityname = "HVC Rebel Logs | Made By The HVC Development Team"
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
            ["title"] = "HVC Rebel Logs",
            ["description"] = "**Player Name:** " ..GetPlayerName(source).. "\n**Player TempID: **" ..source.. "\n**Player PermID: **" ..user_id.. "\n**Weapon Name: **" .. hash .. "\n**Weapon Price: **" ..amount,
            ["footer"] = {
            ["text"] = communityname,
            ["icon_url"] = communtiylogo,
            },
        }
    }
        
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Rebel Logs", embeds = command}), { ['Content-Type'] = 'application/json' })

end

function logArmour(level, userid, source, amout)
    local amount = amount
    local level = level
    local armourlogs = ""
    local name = GetPlayerName(source)
    local ping = GetPlayerPing(source)
    local tempid = GetPlayerGuid(source)
    local communityname = "HVC Rebel Armour Logs | Made By The HVC Development Team"
    local communtiylogo = "" --Must end with .png or .jpg

    local command = {
        {
            ["color"] = "8663711",
            ["title"] = "HVC Rebel Logs",
            ["description"] = "Player: **"..name.."\nPermID: " .. userid .. "**```"
             .. "\nPrice: " .. amount .. "\nItem: " .. hash ..
             "```",
            ["footer"] = {
            ["text"] = communityname,
            ["icon_url"] = communtiylogo,
            },
        }
    }
        
    PerformHttpRequest(armourlogs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Rebel Logs", embeds = command}), { ['Content-Type'] = 'application/json' })

end


RegisterServerEvent("Rebels:buywap")
AddEventHandler('Rebels:buywap', function(price, hash, name)
    local source = source
    local userid = HVC.getUserId({source})
    local admin_name = "HVC Anticheat"
    local reason1 = "CAS13"
    local reason = "CAS14"
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(1544.7969970703,6331.2475585938,24.077945709229)
    local pricemismatch = false 
    local curdate = os.time()
    curdate = curdate + (60 * 60 * 500000)

    print(#(coords - comparison))
    --[[if #(coords - comparison) > 30 then
        TriggerClientEvent("chatMessage", -1, "^1^*[HVC Anticheat]", {180, 0, 0}, GetPlayerName(source) .. " ^7 Was Banned | Reason: CAS13")
        HVC.ban({source,reason1,curdate,admin_name})
        logRebelBans(reason1, user_id, source, curdate) 
        return
    end
    if perm ~= nil then 
        if HVC.hasPermission({userid, perm}) then
            if HVC.tryPayment({userid, price}) then
                TriggerClientEvent("Rebels:givewap", source,  hash)
                logRebel(name, userid, source, price)
                HVCclient.notify(source, {"~g~Purchased, "..name.." For Price: £" ..price})
            else 
                TriggerClientEvent("Rebels:menu", source, false)
                HVCclient.notify(source, {"~r~Insufficient funds"})
            end
        else
            HVCclient.notify(source, {"~r~You do not have permission to buy guns"})
        end
    else 
        if HVC.tryPayment({userid, price}) then
            TriggerClientEvent("Rebels:givewap", source,  hash)
            logRebel(hash, userid, source, price)
            HVCclient.notify(source, {"~g~Paid £"..price})
        else 
            TriggerClientEvent("Rebels:menu", source, false)
            HVCclient.notify(source, {"~r~Insufficient funds"})
        end
    end
end)

RegisterServerEvent("Rebels:buyadvwap")
AddEventHandler('Rebels:buyadvwap', function(price, hash)
    local source = source
    local userid = HVC.getUserId({source})
    local admin_name = "HVC Anticheat"
    local reason1 = "CAS13"
    local reason = "CAS14"
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(1544.7969970703,6331.2475585938,24.077945709229)
    local pricemismatch = false 
    local curdate = os.time()
    curdate = curdate + (60 * 60 * 500000)

    --[[print(#(coords - comparison))
    if #(coords - comparison) > 20 then
        TriggerClientEvent("chatMessage", -1, "^7^*[HVC Anticheat]", {180, 0, 0}, GetPlayerName(source) .. " ^7 Was Banned | Reason: CAS13")
        HVC.ban({source,reason1,curdate,admin_name})
        logRebelBans(reason1, user_id, source, curdate) 
        return
    end
    if HVC.hasPermission({userid, perm}) then 
        if HVC.hasPermission({userid, "advanced.rebel"}) then
            if HVC.tryPayment({userid, price}) then
                TriggerClientEvent("Rebels:givewap", source,  hash)
                logRebel(hash, userid, source, price)
                HVCclient.notify(source, {"~g~Paid £"..price})
            else 
                TriggerClientEvent("Rebels:menu", source, false)
                HVCclient.notify(source, {"~r~Insufficient funds"})
            end
        else
            HVCclient.notify(source, {"~r~You do not have permission to buy guns"})
        end
    else 
        if HVC.tryPayment({userid, price}) then
            TriggerClientEvent("Rebels:givewap", source,  hash)
            logRebel(hash, userid, source, price)
            HVCclient.notify(source, {"~g~Paid £"..price})
        else 
            TriggerClientEvent("Rebels:menu", source, false)
            HVCclient.notify(source, {"~r~Insufficient funds"})
        end
    end
end)

RegisterServerEvent("Rebel:buyarmour")
AddEventHandler('Rebel:buyarmour', function(price, level)
    local source = source
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(1544.7969970703,6331.2475585938,24.077945709229)
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
                TriggerClientEvent("Rebels:givearmour", source, level)
                TriggerClientEvent("HVC:ServerGotArmd", source)
                logRebel(level, userid, source, price)
                HVCclient.notify(source, {"~g~Paid £"..price})
            else 
                TriggerClientEvent("Rebels:menu", source, false)
                HVCclient.notify(source, {"~r~Insufficient funds"})
            end
        else
            HVCclient.notify(source, {"~r~You do not have permission to buy guns"})
        end
    else 
        if HVC.tryPayment({playerid, price}) then
            TriggerClientEvent("Rebels:givearmour", source, level)
            TriggerClientEvent("HVC:ServerGotArmd", source)
            logRebel(level, userid, source, price)
            HVCclient.notify(source, {"~g~Paid £"..price})
        else 
            TriggerClientEvent("Rebels:armour", source, false)
            HVCclient.notify(source, {"~r~Insufficient funds"})
        end
    end
end)




-----------------------------------
--                               --
-- R e b e l   W h i t e l i s t --
--                               --
-----------------------------------





weaponwhitelists = { 

    --{name = "", gunhash = "", permid = "", price = ""},

}



RegisterServerEvent("HVC:rebelBuyWapwl")
AddEventHandler('HVC:rebelBuyWapwl', function(price, hash)
    local source = source
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(1544.7969970703,6331.2475585938,24.077945709229)
    if #(coords - comparison) > 20 then 
     print("Banned, Why U Cheater Man Coords")
   TriggerClientEvent("HVC:DEEEATH", source, "Tried hacking rebel with distance: " ..  #(coords - comparison))
    return 
    end   
    local hash = hash
    local foundweapon = false 
    local pricemismatched = false 
    local userid = HVC.getUserId({source}) 
    if HVC.hasPermission({userid, perm}) then
        for i,v in pairs(weaponwhitelists) do 
            if v.gunhash == hash and tonumber(v.permid) == tonumber(userid) then
                 
                foundweapon = true  
                if HVC.tryPayment({userid, price}) then
                 if tonumber(v.price) ~= tonumber(price) then 
                    pricemismatched = true
                    return 
                 end
                 foundweapon = true 
                 local kgcheck =  HVC.getItemWeight({hash}) 
                 local kgcheck2 =  HVC.getItemWeight({hash .. "_ammo"}) 
                 local currentw = HVC.getInventoryWeight({userid})
                 local maxw = HVC.getInventoryMaxWeight({userid})
                 if (currentw + kgcheck) + (kgcheck2 * 250) > maxw then 
                    HVCclient.notify(source, "~r~You Do Not Have Enough Inventory Space To Buy This Weapon") 
                    HVC.giveMoney(userid, price)
                 else 
                 TriggerClientEvent("Rebels:givewap", source,  hash)
                 logRebel(hash, userid, source, price)
                 HVCclient.notify(source, {"~g~Paid ".."£"..tostring(price)})
                 if pricemismatched == true then 
                    TriggerClientEvent("HVCClient:CAS23")
                    print("Banned, Why U Cheater Man pricemismatched")
                 end
                 if foundweapon == false then 
                    TriggerClientEvent("HVCClient:CAS23")
                    print("Banned, Why U Cheater Man foundweapon")
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
            print("Banned, Why U Cheater Man pricemismatched")
        end
        if foundweapon == false then 
            TriggerClientEvent("HVCClient:CAS23")
            print("Banned, Why U Cheater Man foundweapon")
        end
    else
        HVCclient.notify(source, {"~r~You do not have permission to buy guns"})
    end
end)

RegisterServerEvent("HVC:PULLWHITELISTEDWEAPONShvc")
AddEventHandler("HVC:PULLWHITELISTEDWEAPONShvc", function()
    local source = source
    local table = {}
    local user_id = HVC.getUserId({source})
    for i,v in pairs(weaponwhitelists) do
        if v.permid == user_id then 
       table[i] = {name = v.name, gunhash = v.gunhash, price = v.price}
        end 
end 
Wait(300)
TriggerClientEvent("HVC:GUNSRETURNEDHVC", source,table)
end)


---------------------------------------------
--                                         --
-- R e b e l   S k i n   W h i t e l i s t --
--                                         --
---------------------------------------------





skinpermids = { 

    {name = "[RUST] AK-74", gunhash = "WEAPON_RUST", permid = 1, price = 850000},
}



RegisterServerEvent("HVC:RebelBuyWepSkin")
AddEventHandler('HVC:RebelBuyWepSkin', function(price, hash)
    local source = source
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(1544.7969970703,6331.2475585938,24.077945709229)
    if #(coords - comparison) > 20 then 
    print("Banned, Why U Cheater Man Coords")
   TriggerClientEvent("HVC:DEEEATH", source, "Tried hacking rebel with distance: " ..  #(coords - comparison))
    return 
    end   
    local hash = hash
    local foundweapon = false 
    local pricemismatched = false 
    local userid = HVC.getUserId({source}) 
    if HVC.hasPermission({userid, perm}) then
        for i,v in pairs(skinpermids) do 
            if v.gunhash == hash and tonumber(v.permid) == tonumber(userid) then
                 
                foundweapon = true  
                if HVC.tryPayment({userid, price}) then
                 if tonumber(v.price) ~= tonumber(price) then 
                    pricemismatched = true
                    return 
                 end
                 foundweapon = true 
                 local kgcheck =  HVC.getItemWeight({hash}) 
                 local kgcheck2 =  HVC.getItemWeight({hash .. "_ammo"}) 
                 local currentw = HVC.getInventoryWeight({userid})
                 local maxw = HVC.getInventoryMaxWeight({userid})
                 if (currentw + kgcheck) + (kgcheck2 * 250) > maxw then 
                    HVCclient.notify(source, "~r~You Do Not Have Enough Inventory Space To Buy This Weapon") 
                    HVC.giveMoney(userid, price)
                 else 
                 TriggerClientEvent("Rebels:givewap", source,  hash)
                 logRebel(hash, userid, source, price)
                 HVCclient.notify(source, {"~g~Paid ".."£"..tostring(price)})
                 if pricemismatched == true then 
                    TriggerClientEvent("HVCClient:CAS23")
                    print("Banned, Why U Cheater Man")
                 end
                 if foundweapon == false then 
                    TriggerClientEvent("HVCClient:CAS23")
                    print("Banned, Why U Cheater Man")
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
            print("Banned, Why U Cheater Man")
        end
        if foundweapon == false then 
            TriggerClientEvent("HVCClient:CAS23")
            print("Banned, Why U Cheater Man")
        end
    else
        HVCclient.notify(source, {"~r~You do not have permission to buy guns"})
    end
end)

RegisterServerEvent("HVC:PullWepSkins")
AddEventHandler("HVC:PullWepSkins", function()
    local source = source
    local table = {}
    local user_id = HVC.getUserId({source})
    for i,v in pairs(skinpermids) do
        if v.permid == user_id then 
       table[i] = {name = v.name, gunhash = v.gunhash, price = v.price}
        end 
end 
Wait(300)
TriggerClientEvent("HVC:WepSkinReturned", source,table)
end)]]