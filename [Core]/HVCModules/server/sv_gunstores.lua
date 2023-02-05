local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVC_GunShops")
HVCTurfs = Proxy.getInterface("HVCTurfs")

local Items = {
    ["Lockpick"] = {Price = 1500, hash = "Lockpick", kg = 1.0},
    ["Stim Shot"] = {Price = 1500, hash = "stimshot", kg = 1.0},
    ["Light"] = {Price = 75000, hash = "lightarmour", kg = 5.0},
    ["Heavy"] = {Price = 125000, hash = "heavyarmour", kg = 10.0},

}

RegisterCommand("event", function(source)
    local source = source
    local UserID = HVC.getUserId({source})
    if HVC.hasGroup({UserID, "founder"}) then
        HVC.giveInventoryItem({UserID, "wbody|WEAPON_AK200HVC", 30, true})
        HVC.giveInventoryItem({UserID, "7.62mm Bullets", 5000, true})
        HVC.giveInventoryItem({UserID, "heavyarmour", 50, true})
    end
end)

RegisterNetEvent("HVCStores:PurchaseWeapon")
AddEventHandler("HVCStores:PurchaseWeapon", function(Shop, name, hash, Item)
    local source = source
    local UserID = HVC.getUserId({source})
    local Store = GunCFG.Info[Shop]
    local Ped = GetPlayerPed(source)
    local PedCoords = GetEntityCoords(Ped)
    if HVC.hasPermission({UserID, Store.permission}) then
        if #(PedCoords - Store.Coords) < 5.0 then
            if Item ~= nil then
                local Check = Items[Item]
                if Check then
                    local InventoryKG = HVC.getInventoryWeight({UserID})
                    if InventoryKG + Check.kg > HVC.getInventoryMaxWeight({UserID}) then
                        HVCclient.notify(source, {"~r~Your Inventory is full."})
                    else
                        if HVC.tryPayment({UserID,Check.Price}) then
                            if Store.gangnum ~= 0 then
                                GangName, Commission = GetTurfOwnerCommission(Store.gangnum)
                                HVCTurfs.ModifyGangFundsSV("Give", GangName, Check.Price*(Commission/100))
                            end
                            HVC.giveInventoryItem({UserID, Check.hash, 1, false})
                            HVCclient.notify(source,{'~g~You have purchased ' ..Item.. " for £" ..Comma(Check.Price)})
                        else
                            HVCclient.notify(source,{'~r~You cannot afford' ..Check})
                        end
                    end
                end
            else
                local ActualPrice = nil;
                for k,v in ipairs(Store.weapons) do
                    if v.hash == hash then
                        ActualPrice = v.price
                    end
                end
                if GetPlayerRoutingBucket(source) ~= 0 then
                    SetPlayerRoutingBucket(source, 0)
                    HVCclient.notify(source, {"~r~You have been returned back to original bucket, do not exploit!"})
                    return 
                end
                HVCclient.WeaponType(source, {hash}, function(var)
                    HVCclient.GetWeaponTypes(source, {}, function(types)
                        if types[var] then
                            HVCclient.notify(source,{'~r~You already have a weapon of this type equipped.'})
                        else
                            if HVC.tryPayment({UserID,ActualPrice}) then
                                if Store.gangnum ~= 0 then
                                    GangName, Commission = GetTurfOwnerCommission(Store.gangnum)
                                    HVCTurfs.ModifyGangFundsSV("Give", GangName, ActualPrice*(Commission/100))
                                end
                                HVCclient.allowWeapon(source, {hash, "-1"})
                                GiveWeaponToPed(Ped, hash, 250, false, false, 0)
                                TriggerClientEvent("HVC:PlaySound", source, "purchase")
                                HVCclient.notify(source, {"~g~Purchased, "..name.." For Price: £" ..ActualPrice})
                            else
                                HVCclient.notify(source, {"~r~You cannot afford a " ..name})
                            end
                        end
                    end)
                end)
            end
        else
            print("Cheater Failed Distance Check")
        end
    else
        HVCclient.notify(source, {"~r~You do not have the correct license to purchase from here!"})
    end
end)


RegisterNetEvent("HVCStores:PurchaseWhitelistedWeapon")
AddEventHandler("HVCStores:PurchaseWhitelistedWeapon", function(Shop, Hash)
    local source = source
    local UserID = HVC.getUserId({source})
    local Store = GunCFG.Info[Shop]
    local Ped = GetPlayerPed(source)
    local PedCoords = GetEntityCoords(Ped)
    if HVC.hasPermission({UserID, Store.permission}) then
        if #(PedCoords - Store.Coords) < 5.0 then
            HVCclient.WeaponType(source, {Hash}, function(var)
                HVCclient.GetWeaponTypes(source, {}, function(types)
                    if types[var] then
                        HVCclient.notify(source,{'~r~You already have a weapon of this type equipped.'})
                    else
                        exports["ghmattimysql"]:execute("SELECT SpawnCode,Price,WeaponName from `vrxith_whitelisted_weapons` WHERE Shop = @Store and UserID = @UserID and SpawnCode = @SpawnCode", {Store = Shop, UserID = UserID, SpawnCode = Hash}, function(Weapons)
                            print(Weapons[1].Price,Weapons[1].SpawnCode, Weapons[1].WeaponName)
                            if json.encode(Weapons) ~= "[]" then
                                local Money = tonumber(Weapons[1].Price)
                                if HVC.tryPayment({UserID,Money}) then
                                    HVCclient.allowWeapon(source, {Weapons[1].SpawnCode, "-1"})
                                    GiveWeaponToPed(Ped, Weapons[1].SpawnCode, 250, false, false, 0)
                                    HVCclient.notify(source, {"~g~You have purchased a " ..Weapons[1].WeaponName.. " for £" ..Weapons[1].Price})
                                    TriggerClientEvent("HVC:PlaySound", source, "purchase")
                                else
                                    HVCclient.notify(source, {"~r~You cannot afford a "..Weapons[1].WeaponName})
                                end
                            end
                        end)
                    end
                end)
            end)
        end
    end
end)

RegisterNetEvent("HVCStores:Armour")
AddEventHandler("HVCStores:Armour", function(Shop, Replenish, lvl)
    local source = source
    local UserID = HVC.getUserId({source})
    local Store = GunCFG.Info[Shop]
    local Ped = GetPlayerPed(source)
    local PedCoords = GetEntityCoords(Ped)
    if HVC.hasPermission({UserID, Store.permission}) then
        if #(PedCoords - Store.Coords) < 5.0 then
            if GetPlayerRoutingBucket(source) ~= 0 then
                SetPlayerRoutingBucket(source, 0)
                HVCclient.notify(source, {"~r~You have been returned back to original bucket, do not exploit!"})
                return 
            end
            if Replenish then
                local Armour = Store.maxarmour - GetPedArmour(Ped)
                local Price = Armour*1000
                if HVC.tryPayment({UserID, Price}) then
                    TriggerEvent("HVC:ProvideArmour", source, Store.maxarmour)
                    HVCclient.notify(source, {"~g~You have replenished your armour."})
                    TriggerClientEvent("HVC:PlaySound", source, "purchase")
                else
                    HVCclient.notify(source, {"~r~You cannot afford a replenish"})
                end
            else
                if lvl <= Store.maxarmour then
                    local Armour = GetPedArmour(Ped)
                    if Armour >= lvl then
                        HVCclient.notify(source, {"~r~You already have armour."})
                    else
                        local Price = lvl*1000
                        if HVC.tryPayment({UserID,Price}) then
                            TriggerEvent("HVC:ProvideArmour", source, lvl)
                            HVCclient.notify(source, {"~g~You have purchased armour."})
                            TriggerClientEvent("HVC:PlaySound", source, "purchase")
                        else
                            HVCclient.notify(source, {"~r~You cannot afford " ..lvl.. "% armour"})
                        end
                    end
                else
                    local Message = {
                        {
                            ["color"] = "16384000",
                            ["title"] = "Player Banned for failing distance check on purchase" ..Shop,
                            ["description"] = "User Banned by Anticheat \nName: "..GetPlayerName(source).." / User Id: " ..HVC.getUserId({source}).. " \nCoords: " ..GetEntityCoords(GetPlayerPed(source)),
                        }
                    }
                    PerformHttpRequest("https://discord.com/api/webhooks/961242860009717791/ApQrTUJFivtDckdRqDvPNzbI4atiCpkd0P7GS1EcHw5WWXVc2Lctlpa0rKPQywazPhBh", function(err, text, headers) end, "POST", json.encode({username = "HVC Ban logs", embeds = Message}), { ["Content-Type"] = "application/json" })
                    BanPlayer(source, "Executor")
                end
            end
        end
    end
end)


RegisterServerEvent("Vrxith:Whitelists:RequestWeapons")
AddEventHandler("Vrxith:Whitelists:RequestWeapons", function(shop)
    local source = source
    local UserID = HVC.getUserId({source})
    local ShopHash = shop
    local CollectedWeapons = {}
    local CachedIds = 0
    exports["ghmattimysql"]:execute("SELECT * from `vrxith_whitelisted_weapons` WHERE UserID = @ID", {ID = UserID}, function(GunsList)
        for k,v in pairs(GunsList) do
            if v.Shop == ShopHash then
                CachedIds = CachedIds + 1 
                CollectedWeapons[CachedIds] = {WeaponName = v.WeaponName, SpawnCode = v.SpawnCode, Price = v.Price, Model = v.WeaponModel}
                Guns = v.SpawnCode
            end
        end

        if Guns ~= nil then
            TriggerClientEvent("Vrxith:Client:CallBackWeapons", source, CollectedWeapons, ShopHash)
        else
        end
    end)
end)


Citizen.CreateThread(function()
    Wait(1500)
    exports['ghmattimysql']:execute([[
        CREATE TABLE IF NOT EXISTS `vrxith_whitelisted_weapons` (
            `UserID` INT(11) NULL DEFAULT NULL,
            `Shop` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            `Price` INT(11) NULL DEFAULT NULL,
            `SpawnCode` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            `WeaponName` TEXT NULL,
            `WeaponModel` TEXT NULL
        );
    ]])
    print("[Vrxith] Weapon Whitelists Datatables Initialised!")
end)



function Comma(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end 