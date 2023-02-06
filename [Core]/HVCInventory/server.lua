-- A JamesUK Production. Licensed users only. Use without authorisation is illegal, and a criminal offence under UK Law.
local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
local HVC = Proxy.getInterface("HVC")
local HVCclient = Tunnel.getInterface("HVC","HVC") -- server -> client tunnel
local Inventory = module("hvc", "cfg/inventory")
local HVCHomes = Proxy.getInterface("HVCHoming")
local InventorySpamTrack = {} -- Stops inventory being spammed by users.
local LootBagEntities = {}
local MoneyBagTable = {}
local InventoryCoolDown = {}
local CrateLogs = {}


RegisterNetEvent('HVC:FetchPersonalInventory')
AddEventHandler('HVC:FetchPersonalInventory', function()
    local source = source
    if not InventorySpamTrack[source] then
        InventorySpamTrack[source] = true;
        local UserId = HVC.getUserId({source}) 
        local data = HVC.getUserDataTable({UserId})
        if HVC.getInventoryMaxWeight({UserId}) == nil then
            HVC.updateInvCap({UserId, 0})
        end
        if HVC.getInventoryMaxWeight({UserId}) > 100 then
            HVCclient.notify(source, {"~r~Inventory Capacity Reset, UseBug: Previous Capacity:" ..HVC.getInventoryMaxWeight({UserId})})
            HVC.updateInvCap({UserId, 0})
        end
        if data and data.inventory then
            local FormattedInventoryData = {}
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
            end
            --HVCclient.GetBackpackCapacity(source)
            TriggerClientEvent('HVC:FetchPersonalInventory', source, FormattedInventoryData, HVC.computeItemsWeight({data.inventory}), HVC.getInventoryMaxWeight({UserId}))
            InventorySpamTrack[source] = false;
        else 
            --print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
        end
    end
end)

RegisterNetEvent('HVCInventory:OpenBoot')
AddEventHandler('HVCInventory:OpenBoot', function()
    local source = source
    repeat Wait(0) until not InventoryCoolDown[source];
    local user_id = HVC.getUserId({source})
    HVCclient.getNearestOwnedVehicle(source, {3.5}, function(ok, vtype, name)
        if ok then 
            TriggerClientEvent('HVC:RetrieveCarOpenedViaRadial', source, vtype, name)
            local carformat = "chest:" .. user_id ..  ":u1veh_" .. name
            HVC.getSData({carformat, function(cdata)
                local processedChest = {};
                cdata = json.decode(cdata) or {}
                local FormattedInventoryData = {}
                for i, v in pairs(cdata) do
                    FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                end
                local maxVehKg = Inventory.vehicle_chest_weights[name] or Inventory.default_vehicle_chest_weight
                TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
            end})
        end
    end)
end)


function updateInvCap(user_id,cap)
    if HVC.isConnected({user_id}) then
        if user_id ~= nil then
            local data = HVC.getUserDataTable({user_id})
            if data ~= nil then
                if data.invcap == nil then
                  data.invcap = 30
                  --print("[DEBUG] Inventory Capacity Is Nil")
                end
                if cap > 0 then
                  data.invcap = data.invcap + cap
                 -- print("[DEBUG] Inventory Capacity Has Been Updated To " ..data.invcap)
                else
                  data.invcap = 30
                end
            end
        end
    end
end


RegisterNetEvent('HVCInventory:OpenHomeStorage')
AddEventHandler('HVCInventory:OpenHomeStorage', function(hometag)
    local source = source
    repeat Wait(0) until not InventoryCoolDown[source];
    local user_id = HVC.getUserId({source})
    exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @HomeIdentifier" , {HomeIdentifier = hometag}, function(result)
        if result[1].UserID == user_id then
            TriggerClientEvent('HVC:RetrieveHomeStorageOpend', source, result[1].HomeIdentifier, result[1].HomeName)
            local cdata = result[1].HomeStorage
            local processedChest = {};
            cdata = json.decode(cdata) or {}
            local FormattedInventoryData = {}
            for i, v in pairs(cdata) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
            end
            local maxVehKg = HVCHomes.GetHouseCapacity({hometag})
            TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
        end
    end)
end)

RegisterNetEvent('HVCInventory:POpenHomeStorage')
AddEventHandler('HVCInventory:POpenHomeStorage', function(hometag)
    local source = source
    repeat Wait(0) until not InventoryCoolDown[source];
    local user_id = HVC.getUserId({source})
    if HVC.hasPermission({user_id, "police.menu"}) then 
        exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @HomeIdentifier" , {HomeIdentifier = hometag}, function(result)
            if HVC.hasPermission({user_id, "police.menu"}) then
                if HVC.getUserSource({result[1].UserID}) ~= nil then
                    TriggerClientEvent('HVC:RetrieveHomeStorageOpend', source, result[1].HomeIdentifier, result[1].HomeName)
                    local cdata = result[1].HomeStorage
                    local processedChest = {};
                    cdata = json.decode(cdata) or {}
                    local FormattedInventoryData = {}
                    for i, v in pairs(cdata) do
                        FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                    end
                    local maxVehKg = HVCHomes.GetHouseCapacity({hometag})

                    HVCclient.notify(HVC.getUserSource({result[1].UserID}), {"~b~Your house ( " ..result[1].HomeName.. " ) is being searched by the Metropolitan Police"})
                    HVCclient.notify(source, {"~b~You Are Searching ( " ..result[1].HomeName.. " )"})
                    Wait(2500)
                    if result[1].HomeStorage == "[]" or result[1].HomeStorage == "{}" then
                        HVCclient.notify(source, {"~b~No Illegal Items Found In House ( " ..result[1].HomeName.. " )"})
                        TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                    else
                        if result[1].HomeStorage ~= "{}" or result[1].HomeStorage ~= nil or result[1].HomeStorage ~= "NULL" then
                            TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                            HVCclient.notify(source, {"~r~Illegal Items Found & Siezed In House ( " ..result[1].HomeName.. " )"})
                            exports['ghmattimysql']:execute("UPDATE hvc_housing_data SET HomeStorage = @HomeStorage WHERE HomeIdentifier = @HomeIdentifier ", {HomeIdentifier = hometag, HomeStorage = "{}"}, function() end)
                            Wait(1000)
                            exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @HomeIdentifier" , {HomeIdentifier = hometag}, function(result)
                                if HVC.hasPermission({user_id, "police.menu"}) then
                                    if HVC.getUserSource({result[1].UserID}) ~= nil then
                                        TriggerClientEvent('HVC:RetrieveHomeStorageOpend', source, result[1].HomeIdentifier, result[1].HomeName)
                                        local cdata = result[1].HomeStorage
                                        local processedChest = {};
                                        cdata = json.decode(cdata) or {}
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                                        end
                                        local maxVehKg = HVCHomes.GetHouseCapacity({hometag})

                                        TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                    end
                                end
                            end)
                            TriggerEvent('HVC:RefreshInventory', source)
                        end
                    end
                end
            end
        end)
    end
end)


AddEventHandler('HVC:RefreshInventory', function(source)
    local UserId = HVC.getUserId({source}) 
    local data = HVC.getUserDataTable({UserId})
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
        end
        TriggerClientEvent('HVC:FetchPersonalInventory', source, FormattedInventoryData, HVC.computeItemsWeight({data.inventory}), HVC.getInventoryMaxWeight({UserId}))
    else 
        --print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)

RegisterNetEvent('HVC:GiveItem')
AddEventHandler('HVC:GiveItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  HVCclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        HVC.RunGiveTask({source, itemId})
    else
        HVCclient.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)

RegisterNetEvent('HVC:TrashItem')
AddEventHandler('HVC:TrashItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  HVCclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        HVC.RunTrashTask({source, itemId})
    else
        HVCclient.notify(source, {'~r~You need to have this item on you to drop it.'})
    end
end)

RegisterNetEvent('HVC:FetchTrunkInventory')
AddEventHandler('HVC:FetchTrunkInventory', function(spawnCode)
    local source = source
    repeat Wait(0) until not InventoryCoolDown[source];
    local user_id = HVC.getUserId({source})
    local carformat = "chest:" .. user_id ..  ":u1veh_" .. spawnCode
    HVC.getSData({carformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
        end
        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
    end})
end)


local LockPick = {}
LockPick.Legit = {}
RegisterNetEvent('HVC:FetchLockPickedTrunkInventory')
AddEventHandler('HVC:FetchLockPickedTrunkInventory', function(spawnCode, VehicleNetID)
    local source = source
    local Vehicle = NetworkGetEntityFromNetworkId(VehicleNetID)
    local VCoords = GetEntityCoords(Vehicle)
    local Ped = GetPlayerPed(source)
    local EntityCoords = GetEntityCoords(Ped)
    if #(VCoords - EntityCoords) < 2.0 then
        if LockPick.Legit[source] and not (os.time() > LockPick.Legit[source]) then
            return Log(source)
        else
            LockPick.Legit[source] = nil
        end
        local Target = NetworkGetEntityOwner(Vehicle)
        local TargetName = GetPlayerName(Target)
        local UserID = HVC.getUserId({source})
        local PermID = HVC.getUserId({Target})
        if UserID ~= PermID then
            local carformat = "chest:" .. PermID ..  ":u1veh_" .. spawnCode
            HVC.getSData({carformat, function(cdata)
                local processedChest = {};
                cdata = json.decode(cdata) or {}
                local FormattedInventoryData = {}
                for i, v in pairs(cdata) do
                    FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                end
                local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
                LockPick[source] = {TargetID = PermID, Vehicle = Vehicle, InventoryInfo = spawnCode, NetID = VehicleNetID}
                TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                HVCclient.notify(source, {"~g~You have lockpicked " ..TargetName.. "'s vehicle."})
            end})
        else
            TriggerClientEvent("HVC:InventoryOpen", source, false,false)
            HVCclient.notify(source, {"~r~This vehicle cannot be lockpicked right now, returned lockpick!"})
            HVC.giveInventoryItem({UserID, "Lockpick", 1, false})
            LockPick.Legit[source] = nil;
        end
    end
end)

RegisterNetEvent("HVC:CancelLockpick")
AddEventHandler("HVC:CancelLockpick", function()
    local source = source
    if LockPick.Legit[source] then
        LockPick.Legit[source] = nil
        return true;
    end
end)

RegisterServerCallback("HVC:OpenLockPickedVehicle", function(source)
    local Check = LockPick[source]
    if Check then
        local VCoords = GetEntityCoords(Check.Vehicle)
        local Ped = GetPlayerPed(source)
        local EntityCoords = GetEntityCoords(Ped)
        if #(VCoords - EntityCoords) < 2.0 then
            local PermID = HVC.getUserId({Target})
            local carformat = "chest:" ..  Check.TargetID ..  ":u1veh_" .. Check.InventoryInfo
            HVC.getSData({carformat, function(cdata)
                local processedChest = {};
                cdata = json.decode(cdata) or {}
                local FormattedInventoryData = {}
                for i, v in pairs(cdata) do
                    FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                end
                local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
                TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                return true;
            end})
        end
    end
end)

RegisterServerCallback("HVC:GetLockpickList", function(source)
    return LockPick[source];
end)

RegisterServerCallback("HVC:GetLockPick", function(source)
    local Ped = GetPlayerPed(source)
    local user_id = HVC.getUserId({source})
    if HVC.tryGetInventoryItem({user_id, "Lockpick", 1, false}) then
        LockPick.Legit[source] = os.time() + tonumber(98)
        return true;
    else
        return false;
    end
end)

RegisterNetEvent('HVC:UseItem')
AddEventHandler('HVC:UseItem', function(itemId, itemLoc)
    local source = source
    local UserId = HVC.getUserId({source})
    if not itemId then HVCclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        if HVC.getInventoryMaxWeight({UserId}) == 30 then
            if itemId == "guccipouch" then
                HVC.tryGetInventoryItem({UserId, itemId, 1, true})
                HVC.updateInvCap({UserId, 20})
            elseif itemId == "nikeschoolbackpack" then 
                HVC.tryGetInventoryItem({UserId, itemId, 1, true})
                HVC.updateInvCap({UserId, 30})
            elseif itemId == "louisvuittonbag" then 
                HVC.tryGetInventoryItem({UserId, itemId, 1, true})
                HVC.updateInvCap({UserId, 45})
            elseif itemId == "rebelpack" then 
                HVC.tryGetInventoryItem({UserId, itemId, 1, true})
                HVC.updateInvCap({UserId, 70})
            end
        else
            if itemId == "guccipouch" or itemId == "nikeschoolbackpack" or itemId == "louisvuittonbag" or itemId == "rebelpack" then
                HVCclient.notify(source, {'~r~You already have a backpack equipped.'})
            end
        end
    end
    if itemLoc == "Plr" then
        HVC.RunInventoryTask({source, itemId})
    else
        HVCclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)


RegisterNetEvent('HVC:MoveItem')
AddEventHandler('HVC:MoveItem', function(inventoryType, itemId, inventoryInfo, Lootbag, House)
    local source = source
    local UserId = HVC.getUserId({source})
    local data = HVC.getUserDataTable({UserId})
    if data and data.inventory then
    if not itemId then HVCclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if InventoryCoolDown[source] then HVCclient.notify(source, {'~r~The server is still processing your request.'}) return end
    if LockPick[source] and DoesEntityExist(LockPick[source].Vehicle) and #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(LockPick[source].Vehicle)) < 2.0 then
        local TargetID = LockPick[source].TargetID
        InventoryCoolDown[source] = true; 
        local carformat = "chest:" .. TargetID ..  ":u1veh_" .. LockPick[source].InventoryInfo
            HVC.getSData({carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount >= 1 then
                    local weightCalculation = HVC.getInventoryWeight({UserId})+HVC.getItemWeight({itemId})
                    if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                        if cdata[itemId].amount > 1 then
                            cdata[itemId].amount = cdata[itemId].amount - 1; 
                            HVC.giveInventoryItem({UserId, itemId, 1, true})
                        else 
                            cdata[itemId] = nil;
                            HVC.giveInventoryItem({UserId, itemId, 1, true})
                        end 
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                        TriggerEvent('HVC:RefreshInventory', source)
                        HVC.setSData({"chest:" .. TargetID ..  ":u1veh_" ..LockPick[source].InventoryInfo, json.encode(cdata)})
                        InventoryCoolDown[source] = nil;
                    else 
                        HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                        InventoryCoolDown[source] = nil;
                    end
                else 
                    --print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                    InventoryCoolDown[source] = nil;
                end
            end})
        end
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true; 
            local Quantity = parseInt(1)
            if Quantity then
                local carformat = "chest:" .. UserId ..  ":u1veh_" .. inventoryInfo
                HVC.getSData({carformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and cdata[itemId].amount >= 1 then
                        local weightCalculation = HVC.getInventoryWeight({UserId})+HVC.getItemWeight({itemId})
                        if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                            if cdata[itemId].amount > 1 then
                                cdata[itemId].amount = cdata[itemId].amount - 1; 
                                HVC.giveInventoryItem({UserId, itemId, 1, true})
                            else 
                                cdata[itemId] = nil;
                                HVC.giveInventoryItem({UserId, itemId, 1, true})
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                            end
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                            TriggerEvent('HVC:RefreshInventory', source)
                            HVC.setSData({"chest:" .. UserId ..  ":u1veh_" .. inventoryInfo, json.encode(cdata)})
                            InventoryCoolDown[source] = nil;
                        else 
                            HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                            InventoryCoolDown[source] = nil;
                        end
                    else 
                        --print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                        InventoryCoolDown[source] = nil;
                    end
                end})
            end
        elseif inventoryType == "Housing" then
            InventoryCoolDown[source] = true; 
            local Quantity = parseInt(1)
            if Quantity then
                exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @HomeIdentifier" , {HomeIdentifier = inventoryInfo}, function(result)
                    if result[1].UserID == UserId then
                        local cdata = result[1].HomeStorage
                        cdata = json.decode(cdata) or {}
                        if cdata[itemId] and cdata[itemId].amount >= 1 then

                            local weightCalculation = HVC.getInventoryWeight({UserId})+HVC.getItemWeight({itemId})
                            if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                                if cdata[itemId].amount > 1 then
                                    cdata[itemId].amount = cdata[itemId].amount - 1; 
                                    HVC.giveInventoryItem({UserId, itemId, 1, true})
                                else 
                                    cdata[itemId] = nil;
                                    HVC.giveInventoryItem({UserId, itemId, 1, true})
                                end 
                                local FormattedInventoryData = {}
                                for i, v in pairs(cdata) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                                end
                                local maxVehKg = HVCHomes.GetHouseCapacity({inventoryInfo})
                                TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                TriggerEvent('HVC:RefreshInventory', source)
                                exports['ghmattimysql']:execute("UPDATE hvc_housing_data SET HomeStorage = @HomeStorage WHERE HomeIdentifier = @HomeIdentifier ", {HomeIdentifier = inventoryInfo, HomeStorage = json.encode(cdata)}, function() end)
                                --HVC.setSData({"chest:" .. UserId ..  ":u1veh_" .. inventoryInfo, json.encode(cdata)})
                                InventoryCoolDown[source] = nil;
                            else 
                                HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                InventoryCoolDown[source] = nil;
                            end
                        else 
                            --print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                            InventoryCoolDown[source] = nil;
                        end
                    end
                end)
            end
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                local weightCalculation = HVC.getInventoryWeight({UserId})+HVC.getItemWeight({itemId})
                if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                    if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > 1 then
                        LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - 1 
                        HVC.giveInventoryItem({UserId, itemId, 1, true})
                    else 
                        LootBagEntities[inventoryInfo].Items[itemId] = nil;
                        HVC.giveInventoryItem({UserId, itemId, 1, true})
                        if json.encode(LootBagEntities[inventoryInfo].Items) == "[]" then
                            DeleteEntity(LootBagEntities[inventoryInfo][1])
                            CloseInv(source)
                        end
                    end
                    local FormattedInventoryData = {}
                    for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                        FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                    end
                    local maxVehKg = 200
                    TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                    TriggerEvent('HVC:RefreshInventory', source)
                else 
                    HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                end
            end
        elseif inventoryType == "Crate" then    
            if CrateLogs[inventoryInfo].Items[itemId] then 
                local weightCalculation = HVC.getInventoryWeight({UserId})+HVC.getItemWeight({itemId})
                if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                    if CrateLogs[inventoryInfo].Items[itemId] and CrateLogs[inventoryInfo].Items[itemId].amount > 1 then
                        CrateLogs[inventoryInfo].Items[itemId].amount = CrateLogs[inventoryInfo].Items[itemId].amount - 1 
                        HVC.giveInventoryItem({UserId, itemId, 1, true})
                    else 
                        CrateLogs[inventoryInfo].Items[itemId] = nil;
                        HVC.giveInventoryItem({UserId, itemId, 1, true})
                        if json.encode(CrateLogs[inventoryInfo].Items) == "[]" then
                            DeleteEntity(CrateLogs[inventoryInfo][1])
                            CloseInv(source)
                            HVCclient.RemoveRecordedBlip(-1, {})
                            TriggerClientEvent("chatMessage", -1, "^1^*AIRDROP", {180, 0, 0},  "The Airdrop has been looted by " ..GetPlayerName(source).. ".", "alert")
                        end
                    end
                    local FormattedInventoryData = {}
                    for i, v in pairs(CrateLogs[inventoryInfo].Items) do
                        FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                    end
                    local maxVehKg = 500
                    TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({CrateLogs[inventoryInfo].Items}), maxVehKg)                
                    TriggerEvent('HVC:RefreshInventory', source)
                else 
                    HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                end
            end
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if not House then
                    if data.inventory[itemId] then
                        local carformat = "chest:" .. UserId ..  ":u1veh_" .. inventoryInfo
                        HVC.getSData({carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = HVC.computeItemsWeight({cdata})+HVC.getItemWeight({itemId})
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if HVC.tryGetInventoryItem({UserId, itemId, 1, true}) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('HVC:RefreshInventory', source)
                                    HVC.setSData({"chest:" .. UserId ..  ":u1veh_" .. inventoryInfo, json.encode(cdata)})
                                else 
                                    HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                --print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                            end
                        end})
                    else
                        --print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                    end
                else
                    if data.inventory[itemId] then
                        exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @HomeIdentifier" , {HomeIdentifier = inventoryInfo}, function(result)
                            if result[1].UserID == UserId then
                                local cdata = result[1].HomeStorage
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                    local weightCalculation = HVC.computeItemsWeight({cdata})+HVC.getItemWeight({itemId})
                                    local maxVehKg = HVCHomes.GetHouseCapacity({inventoryInfo})
                                    if weightCalculation <= maxVehKg then
                                        if HVC.tryGetInventoryItem({UserId, itemId, 1, true}) then
                                            if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + 1
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = 1
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                                        end
                                        local maxVehKg = HVCHomes.GetHouseCapacity({inventoryInfo})
                                        TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                        TriggerEvent('HVC:RefreshInventory', source)
                                        exports['ghmattimysql']:execute("UPDATE hvc_housing_data SET HomeStorage = @HomeStorage WHERE HomeIdentifier = @HomeIdentifier ", {HomeIdentifier = inventoryInfo, HomeStorage = json.encode(cdata)}, function() end)
                                        --HVC.setSData({"chest:" .. UserId ..  ":u1veh_" .. inventoryInfo, json.encode(cdata)})
                                    else 
                                        HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                end
                            end
                        end)
                    end
                end
            end
        end
    end
end)



RegisterNetEvent('HVC:MoveItemX')
AddEventHandler('HVC:MoveItemX', function(inventoryType, itemId, inventoryInfo, Lootbag, House)
    local source = source
    local UserId = HVC.getUserId({source}) 
    local data = HVC.getUserDataTable({UserId})

    if not itemId then  HVCclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if InventoryCoolDown[source] then HVCclient.notify(source, {'~r~The server is still processing your request.'}) return end
        if LockPick[source] and DoesEntityExist(LockPick[source].Vehicle) and #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(LockPick[source].Vehicle)) < 2.0 then
            local TargetID = LockPick[source].TargetID
            TriggerClientEvent('HVC:ToggleNUIFocus', source, false)
            HVC.prompt({source, 'How many ' .. HVC.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                Quantity = parseInt(Quantity)
                TriggerClientEvent('HVC:ToggleNUIFocus', source, true)

                if Quantity < 0 then
                    HVCclient.notify(source, {'~r~Dont Try Dupe U Silly Boy!'})
                    return
                end
                InventoryCoolDown[source] = true; 
                if Quantity then
                    local carformat = "chest:" .. TargetID ..  ":u1veh_" .. LockPick[source].InventoryInfo
                    HVC.getSData({carformat, function(cdata)
                        cdata = json.decode(cdata) or {}
                        if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                            local weightCalculation = HVC.getInventoryWeight({UserId})+(HVC.getItemWeight({itemId}) * Quantity)
                            if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                                if cdata[itemId].amount > Quantity then
                                    cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                    HVC.giveInventoryItem({UserId, itemId, Quantity, true})
                                else 
                                    cdata[itemId] = nil;
                                    HVC.giveInventoryItem({UserId, itemId, Quantity, true})
                                end 
                                local FormattedInventoryData = {}
                                for i, v in pairs(cdata) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                                end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                TriggerEvent('HVC:RefreshInventory', source)
                                HVC.setSData({"chest:" .. TargetID ..  ":u1veh_" .. LockPick[source].InventoryInfo, json.encode(cdata)})
                                InventoryCoolDown[source] = nil;
                            else 
                                HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                InventoryCoolDown[source] = nil;
                            end
                        else 
                            HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            InventoryCoolDown[source] = nil;
                        end
                    end})
                else 
                    HVCclient.notify(source, {'~r~Invalid input!'})
                    InventoryCoolDown[source] = nil;
                end
             end})
        end
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true; 
            TriggerClientEvent('HVC:ToggleNUIFocus', source, false)
            HVC.prompt({source, 'How many ' .. HVC.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                Quantity = parseInt(Quantity)
                TriggerClientEvent('HVC:ToggleNUIFocus', source, true)

                if Quantity < 0 then
                    HVCclient.notify(source, {'~r~Dont Try Dupe U Silly Boy!'})
                    return
                end
                if Quantity then
                    local carformat = "chest:" .. UserId ..  ":u1veh_" .. inventoryInfo
                    HVC.getSData({carformat, function(cdata)
                        cdata = json.decode(cdata) or {}
                        if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                            local weightCalculation = HVC.getInventoryWeight({UserId})+(HVC.getItemWeight({itemId}) * Quantity)
                            if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                                if cdata[itemId].amount > Quantity then
                                    cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                    HVC.giveInventoryItem({UserId, itemId, Quantity, true})
                                else 
                                    cdata[itemId] = nil;
                                    HVC.giveInventoryItem({UserId, itemId, Quantity, true})
                                end 
                                local FormattedInventoryData = {}
                                for i, v in pairs(cdata) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                                end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                TriggerEvent('HVC:RefreshInventory', source)
                                HVC.setSData({"chest:" .. UserId ..  ":u1veh_" .. inventoryInfo, json.encode(cdata)})
                                InventoryCoolDown[source] = nil;
                            else 
                                HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                InventoryCoolDown[source] = nil;
                            end
                        else 
                            HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            InventoryCoolDown[source] = nil;
                        end
                    end})
                else 
                    HVCclient.notify(source, {'~r~Invalid input!'})
                    InventoryCoolDown[source] = nil;
                end
            end})
        elseif inventoryType == "Housing" then
            InventoryCoolDown[source] = true; 
            TriggerClientEvent('HVC:ToggleNUIFocus', source, false)
            HVC.prompt({source, 'How many ' .. HVC.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                Quantity = parseInt(Quantity)
                TriggerClientEvent('HVC:ToggleNUIFocus', source, true)
                if Quantity < 0 then
                    HVCclient.notify(source, {'~r~Dont Try Dupe U Silly Boy!'})
                    return
                end
                if Quantity then
                    exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @HomeIdentifier" , {HomeIdentifier = inventoryInfo}, function(result)
                        if result[1].UserID == UserId then
                            local cdata = result[1].HomeStorage
                            cdata = json.decode(cdata) or {}
                            if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                                local weightCalculation = HVC.getInventoryWeight({UserId})+(HVC.getItemWeight({itemId}) * Quantity)
                                if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                                    if cdata[itemId].amount > Quantity then
                                        cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                        HVC.giveInventoryItem({UserId, itemId, Quantity, true})
                                    else 
                                        cdata[itemId] = nil;
                                        HVC.giveInventoryItem({UserId, itemId, Quantity, true})
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                                    end
                                    local maxVehKg = HVCHomes.GetHouseCapacity({inventoryInfo})
                                    TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('HVC:RefreshInventory', source)
                                    exports['ghmattimysql']:execute("UPDATE hvc_housing_data SET HomeStorage = @HomeStorage WHERE HomeIdentifier = @HomeIdentifier ", {HomeIdentifier = inventoryInfo, HomeStorage = json.encode(cdata)}, function() end)
                                    InventoryCoolDown[source] = nil;
                                else 
                                    HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                    InventoryCoolDown[source] = nil;
                                end
                            else 
                                HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                InventoryCoolDown[source] = nil;
                            end
                        end
                    end)
                else 
                    HVCclient.notify(source, {'~r~Invalid input!'})
                    InventoryCoolDown[source] = nil;
                end
            end})
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                TriggerClientEvent('HVC:ToggleNUIFocus', source, false)
                HVC.prompt({source, 'How many ' .. HVC.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                    Quantity = parseInt(Quantity)
                    TriggerClientEvent('HVC:ToggleNUIFocus', source, true)
                    if Quantity < 0 then
                        HVCclient.notify(source, {'~r~Dont Try Dupe U Silly Boy!'})
                        return
                    end
                    if Quantity then
                        local weightCalculation = HVC.getInventoryWeight({UserId})+(HVC.getItemWeight({itemId}) * Quantity)
                        if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                            if Quantity <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                                if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > Quantity then
                                    LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - Quantity
                                    HVC.giveInventoryItem({UserId, itemId, Quantity, true})
                                else 
                                    LootBagEntities[inventoryInfo].Items[itemId] = nil;
                                    HVC.giveInventoryItem({UserId, itemId, Quantity, true})
                                    if json.encode(LootBagEntities[inventoryInfo].Items) == "[]" then
                                        DeleteEntity(LootBagEntities[inventoryInfo][1])
                                        CloseInv(source)
                                    end
                                end
                                local FormattedInventoryData = {}
                                for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                                end
                                local maxVehKg = 200
                                TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                                TriggerEvent('HVC:RefreshInventory', source)
                            else 
                                HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end 
                        else 
                            HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        HVCclient.notify(source, {'~r~Invalid input!'})
                    end
                end})
            end
        elseif inventoryType == "Crate" then    
            if CrateLogs[inventoryInfo].Items[itemId] then 
                TriggerClientEvent('HVC:ToggleNUIFocus', source, false)
                HVC.prompt({source, 'How many ' .. HVC.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                    Quantity = parseInt(Quantity)
                    TriggerClientEvent('HVC:ToggleNUIFocus', source, true)
                    if Quantity < 0 then
                        HVCclient.notify(source, {'~r~Invalid Input.'})
                        return
                    end
                    if Quantity then
                        local weightCalculation = HVC.getInventoryWeight({UserId})+(HVC.getItemWeight({itemId}) * Quantity)
                        if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                            if Quantity <= CrateLogs[inventoryInfo].Items[itemId].amount then 
                                if CrateLogs[inventoryInfo].Items[itemId] and CrateLogs[inventoryInfo].Items[itemId].amount > Quantity then
                                    CrateLogs[inventoryInfo].Items[itemId].amount = CrateLogs[inventoryInfo].Items[itemId].amount - Quantity
                                    HVC.giveInventoryItem({UserId, itemId, Quantity, true})
                                else 
                                    CrateLogs[inventoryInfo].Items[itemId] = nil;
                                    HVC.giveInventoryItem({UserId, itemId, Quantity, true})
                                    if json.encode(CrateLogs[inventoryInfo].Items) == "[]" then
                                        DeleteEntity(CrateLogs[inventoryInfo][1])
                                        CloseInv(source)
                                        HVCclient.RemoveRecordedBlip(-1, {})
                                        TriggerClientEvent("chatMessage", -1, "^1^*AIRDROP", {180, 0, 0},  "The Airdrop has been looted by " ..GetPlayerName(source).. ".", "alert")
                                    end
                                end
                                local FormattedInventoryData = {}
                                for i, v in pairs(CrateLogs[inventoryInfo].Items) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                                end
                                local maxVehKg = 500
                                TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({CrateLogs[inventoryInfo].Items}), maxVehKg)                
                                TriggerEvent('HVC:RefreshInventory', source)
                            else 
                                HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end 
                        else 
                            HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        HVCclient.notify(source, {'~r~Invalid input!'})
                    end
                end})
            end
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if not House then
                    if data.inventory[itemId] then
                        TriggerClientEvent('HVC:ToggleNUIFocus', source, false)
                        HVC.prompt({source, 'How many ' .. HVC.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                            Quantity = parseInt(Quantity)
                            TriggerClientEvent('HVC:ToggleNUIFocus', source, true)
                            if Quantity < 0 then
                                HVCclient.notify(source, {'~r~Dont Try Dupe U Silly Boy!'})
                                return
                            end
                            if Quantity then
                                local carformat = "chest:" .. UserId ..  ":u1veh_" .. inventoryInfo
                                HVC.getSData({carformat, function(cdata)
                                    cdata = json.decode(cdata) or {}
                                    if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                        local weightCalculation = HVC.computeItemsWeight({cdata})+(HVC.getItemWeight({itemId}) * Quantity)
                                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                        if weightCalculation <= maxVehKg then
                                            if HVC.tryGetInventoryItem({UserId, itemId, Quantity, true}) then
                                                if cdata[itemId] then
                                                    cdata[itemId].amount = cdata[itemId].amount + Quantity
                                                else 
                                                    cdata[itemId] = {}
                                                    cdata[itemId].amount = Quantity
                                                end
                                            end 
                                            local FormattedInventoryData = {}
                                            for i, v in pairs(cdata) do
                                                FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                                            end
                                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                            TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                            TriggerEvent('HVC:RefreshInventory', source)
                                            HVC.setSData({"chest:" .. UserId ..  ":u1veh_" .. inventoryInfo, json.encode(cdata)})
                                        else 
                                            HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                        end
                                    else 
                                        HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                    end
                                end})
                            else 
                                HVCclient.notify(source, {'~r~Invalid input!'})
                            end
                        end})
                    end

                else
                    if data.inventory[itemId] then
                        TriggerClientEvent('HVC:ToggleNUIFocus', source, false)
                        HVC.prompt({source, 'How many ' .. HVC.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                            Quantity = parseInt(Quantity)
                            TriggerClientEvent('HVC:ToggleNUIFocus', source, true)
                            if Quantity then
                                exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @HomeIdentifier" , {HomeIdentifier = inventoryInfo}, function(result)
                                    if result[1].UserID == UserId then
                                        local cdata = result[1].HomeStorage
                                        cdata = json.decode(cdata) or {}
                                        if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                            local weightCalculation = HVC.computeItemsWeight({cdata})+(HVC.getItemWeight({itemId}) * Quantity)
                                            local maxVehKg = HVCHomes.GetHouseCapacity({inventoryInfo})
                                            if weightCalculation <= maxVehKg then
                                                if HVC.tryGetInventoryItem({UserId, itemId, Quantity, true}) then
                                                    if cdata[itemId] then
                                                        cdata[itemId].amount = cdata[itemId].amount + Quantity
                                                    else 
                                                        cdata[itemId] = {}
                                                        cdata[itemId].amount = Quantity
                                                    end
                                                end 
                                                local FormattedInventoryData = {}
                                                for i, v in pairs(cdata) do
                                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                                                end
                                                local maxVehKg = HVCHomes.GetHouseCapacity({inventoryInfo})
                                                TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                                TriggerEvent('HVC:RefreshInventory', source)
                                                exports['ghmattimysql']:execute("UPDATE hvc_housing_data SET HomeStorage = @HomeStorage WHERE HomeIdentifier = @HomeIdentifier ", {HomeIdentifier = inventoryInfo, HomeStorage = json.encode(cdata)}, function() end)
                                                --HVC.setSData({"chest:" .. UserId ..  ":u1veh_" .. inventoryInfo, json.encode(cdata)})
                                            else 
                                                HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                            end
                                        else 
                                            HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                        end
                                    end
                                end)
                            else 
                                HVCclient.notify(source, {'~r~Invalid input!'})
                            end
                        end})
                    end
                end
            end
        end
    end
end)


RegisterNetEvent('HVC:MoveItemAll')
AddEventHandler('HVC:MoveItemAll', function(inventoryType, itemId, inventoryInfo, Lootbag, House)
    local source = source
    local UserId = HVC.getUserId({source}) 
    local data = HVC.getUserDataTable({UserId})
    if not itemId then  HVCclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if InventoryCoolDown[source] then HVCclient.notify(source, {'~r~The server is still processing your request.'}) return end
    if data and data.inventory then
        if LockPick[source] and DoesEntityExist(LockPick[source].Vehicle) and #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(LockPick[source].Vehicle)) < 2.0 then
            InventoryCoolDown[source] = true; 
            local carformat = "chest:" .. LockPick[source].TargetID ..  ":u1veh_" .. LockPick[source].InventoryInfo
            HVC.getSData({carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = HVC.getInventoryWeight({UserId})+(HVC.getItemWeight({itemId}) * cdata[itemId].amount)
                    if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                        HVC.giveInventoryItem({UserId, itemId, cdata[itemId].amount, true})
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                        TriggerEvent('HVC:RefreshInventory', source)
                        HVC.setSData({"chest:" .. LockPick[source].TargetID  ..  ":u1veh_" .. LockPick[source].InventoryInfo, json.encode(cdata)})
                        InventoryCoolDown[source] = nil;
                    else 
                        HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                        InventoryCoolDown[source] = nil; 
                    end
                else 
                    InventoryCoolDown[source] = nil; 
                end
            end})
        end
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true; 
            local carformat = "chest:" .. UserId ..  ":u1veh_" .. inventoryInfo
            HVC.getSData({carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = HVC.getInventoryWeight({UserId})+(HVC.getItemWeight({itemId}) * cdata[itemId].amount)
                    if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                        HVC.giveInventoryItem({UserId, itemId, cdata[itemId].amount, true})
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                        TriggerEvent('HVC:RefreshInventory', source)
                        HVC.setSData({"chest:" .. UserId ..  ":u1veh_" .. inventoryInfo, json.encode(cdata)})
                        InventoryCoolDown[source] = nil;
                    else 
                        HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                        InventoryCoolDown[source] = nil; 
                    end
                else 
                    HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    InventoryCoolDown[source] = nil; 
                end
            end})
        elseif inventoryType == "Housing" then
            InventoryCoolDown[source] = true; 
            exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @HomeIdentifier" , {HomeIdentifier = inventoryInfo}, function(result)
                if result[1].UserID == UserId then
                    local cdata = result[1].HomeStorage
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                        local weightCalculation = HVC.getInventoryWeight({UserId})+(HVC.getItemWeight({itemId}) * cdata[itemId].amount)
                        if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                            HVC.giveInventoryItem({UserId, itemId, cdata[itemId].amount, true})
                            cdata[itemId] = nil;
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                            end
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                            TriggerEvent('HVC:RefreshInventory', source)
                            HVC.setSData({"chest:" .. UserId ..  ":u1veh_" .. inventoryInfo, json.encode(cdata)})
                            local maxVehKg = HVCHomes.GetHouseCapacity({inventoryInfo})
                            TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                            TriggerEvent('HVC:RefreshInventory', source)
                            exports['ghmattimysql']:execute("UPDATE hvc_housing_data SET HomeStorage = @HomeStorage WHERE HomeIdentifier = @HomeIdentifier ", {HomeIdentifier = inventoryInfo, HomeStorage = json.encode(cdata)}, function() end)
                            --HVC.setSData({"chest:" .. UserId ..  ":u1veh_" .. inventoryInfo, json.encode(cdata)})
                            InventoryCoolDown[source] = nil;
                        else 
                            HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                            InventoryCoolDown[source] = nil; 
                        end
                    else 
                        HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        InventoryCoolDown[source] = nil; 
                    end
                end
            end)
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                local weightCalculation = HVC.getInventoryWeight({UserId})+(HVC.getItemWeight({itemId}) *  LootBagEntities[inventoryInfo].Items[itemId].amount)
                if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                    if  LootBagEntities[inventoryInfo].Items[itemId].amount <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                        HVC.giveInventoryItem({UserId, itemId, LootBagEntities[inventoryInfo].Items[itemId].amount, true})
                        LootBagEntities[inventoryInfo].Items[itemId] = nil;
                        if json.encode(LootBagEntities[inventoryInfo].Items) == "[]" then
                            DeleteEntity(LootBagEntities[inventoryInfo][1])
                            CloseInv(source)
                        end
                        local FormattedInventoryData = {}
                        for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                        end
                        local maxVehKg = 200
                        TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                        TriggerEvent('HVC:RefreshInventory', source)
                    else 
                        HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end 
                else 
                    HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                end
            end
        elseif inventoryType == "Crate" then    
            if CrateLogs[inventoryInfo].Items[itemId] then 
                local weightCalculation = HVC.getInventoryWeight({UserId})+(HVC.getItemWeight({itemId}) *  CrateLogs[inventoryInfo].Items[itemId].amount)
                if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                    if  CrateLogs[inventoryInfo].Items[itemId].amount <= CrateLogs[inventoryInfo].Items[itemId].amount then 
                        HVC.giveInventoryItem({UserId, itemId, CrateLogs[inventoryInfo].Items[itemId].amount, true})
                        CrateLogs[inventoryInfo].Items[itemId] = nil;
                        if json.encode(CrateLogs[inventoryInfo].Items) == "[]" then
                            DeleteEntity(CrateLogs[inventoryInfo][1])
                            CloseInv(source)
                            HVCclient.RemoveRecordedBlip(-1, {})
                            TriggerClientEvent("chatMessage", -1, "^1^*AIRDROP", {180, 0, 0},  "The Airdrop has been looted by " ..GetPlayerName(source).. ".", "alert")
                        end
                        local FormattedInventoryData = {}
                        for i, v in pairs(CrateLogs[inventoryInfo].Items) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                        end
                        local maxVehKg = 500
                        TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({CrateLogs[inventoryInfo].Items}), maxVehKg)                
                        TriggerEvent('HVC:RefreshInventory', source)
                    else 
                        HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end 
                else 
                    HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                end
            end
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if not House then
                    if data.inventory[itemId] then
                        local carformat = "chest:" .. UserId ..  ":u1veh_" .. inventoryInfo
                        HVC.getSData({carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local weightCalculation = HVC.computeItemsWeight({cdata})+(HVC.getItemWeight({itemId}) * data.inventory[itemId].amount)
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if HVC.tryGetInventoryItem({UserId, itemId, data.inventory[itemId].amount, true}) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + data.inventory[itemId].amount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = data.inventory[itemId].amount
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('HVC:RefreshInventory', source)
                                    HVC.setSData({"chest:" .. UserId ..  ":u1veh_" .. inventoryInfo, json.encode(cdata)})
                                else 
                                    HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end})
                    end
                else
                    if data.inventory[itemId] then
                        exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @HomeIdentifier" , {HomeIdentifier = inventoryInfo}, function(result)
                            if result[1].UserID == UserId then
                                local cdata = result[1].HomeStorage
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                    local weightCalculation = HVC.computeItemsWeight({cdata})+(HVC.getItemWeight({itemId}) * data.inventory[itemId].amount)
                                    local maxVehKg = HVCHomes.GetHouseCapacity({inventoryInfo})
                                    if weightCalculation <= maxVehKg then
                                        if HVC.tryGetInventoryItem({UserId, itemId, data.inventory[itemId].amount, true}) then
                                            if cdata[itemId] then
                                                cdata[itemId].amount = cdata[itemId].amount + data.inventory[itemId].amount
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = data.inventory[itemId].amount
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                                        end
                                        local maxVehKg = HVCHomes.GetHouseCapacity({inventoryInfo})
                                        TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                        TriggerEvent('HVC:RefreshInventory', source)
                                        exports['ghmattimysql']:execute("UPDATE hvc_housing_data SET HomeStorage = @HomeStorage WHERE HomeIdentifier = @HomeIdentifier ", {HomeIdentifier = inventoryInfo, HomeStorage = json.encode(cdata)}, function() end)
                                        --HVC.setSData({"chest:" .. UserId ..  ":u1veh_" .. inventoryInfo, json.encode(cdata)})
                                    else 
                                        HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                else 
                                    HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end
                            end
                        end)
                    end

                end
            end
        end
    end
end)


-- LOOTBAGS CODE BELOW HERE 

RegisterNetEvent('HVC:InComa')
AddEventHandler('HVC:InComa', function()
    local source = source
    HVCclient.isInComa(source, {}, function(in_coma) 
        if in_coma then
            TriggerEvent('HVC:StoreWeaponsRequest', source)
            Wait(350)
            local user_id = HVC.getUserId({source})
            local model = GetHashKey('xs_prop_arena_bag_01')
            local name1 = GetPlayerName(source)
            local ndata = HVC.getUserDataTable({user_id})
            local Money = HVC.getMoney({user_id})
            local Coords = GetEntityCoords(GetPlayerPed(source))
            if Money ~= 0 then
                HVC.setMoney({user_id, 0})
                local MoneyBag = CreateObjectNoOffset(GetHashKey("prop_poly_bag_money"), Coords.x-0.5, Coords.y, Coords.z, true, true, false)
                local NetworkID = NetworkGetNetworkIdFromEntity(MoneyBag)
                MoneyBagTable[NetworkID] = {source, MoneyBag}
                MoneyBagTable[NetworkID].Cash = Money
                HVCclient.PlaceOnFloor(-1,{NetworkID}) 
            end
            if ndata ~= nil and ndata.inventory ~= nil and json.encode(ndata.inventory) ~= "[]" then
                if not HVC.hasPermission({user_id, "police.menu"}) and not HVC.hasPermission({user_id, "emscheck.revive"}) then
                    local lootbag = CreateObjectNoOffset(model, Coords.x-0.5, Coords.y, Coords.z, true, true, false)
                    local lootbagnetid = NetworkGetNetworkIdFromEntity(lootbag)
                    LootBagEntities[lootbagnetid] = {lootbag, lootbag, false, source}
                    LootBagEntities[lootbagnetid].Items = {}
                    LootBagEntities[lootbagnetid].name = name1
                    local stored_inventory = nil;
                    stored_inventory = ndata.inventory
                    HVC.clearInventory({user_id})
                    for k, v in pairs(stored_inventory) do
                        LootBagEntities[lootbagnetid].Items[k] = {}
                        LootBagEntities[lootbagnetid].Items[k].amount = v.amount
                    end
                    HVCclient.PlaceOnFloor(-1,{lootbagnetid}) 
                else 
                    HVC.setMoney({user_id, 0})
                    HVC.clearInventory({user_id})
                end
            else 
                HVC.setMoney({user_id, 0})
                HVC.clearInventory({user_id})
            end
        end
    end)
end)


RegisterNetEvent("HVC:CollectMoney")
AddEventHandler("HVC:CollectMoney", function(NetworkID)
    local source = source
    local Ped = GetPlayerPed(source)
    local UserID = HVC.getUserId({source})
    HVCclient.isInComa(source, {}, function(in_coma)
        if not in_coma then
            if MoneyBagTable[NetworkID] and #(GetEntityCoords(MoneyBagTable[NetworkID][2]) - GetEntityCoords(Ped)) < 2.0 then
                HVC.giveMoney({UserID,MoneyBagTable[NetworkID].Cash})
                HVCclient.notify(source,{"~g~You have picked up £"..MoneyBagTable[NetworkID].Cash})
                DeleteEntity(MoneyBagTable[NetworkID][2])
                MoneyBagTable[NetworkID] = {}
            end
        end
    end)
end)

RegisterNetEvent('HVC:LootBag')
AddEventHandler('HVC:LootBag', function(netid)
    local source = source
    HVCclient.isInComa(source, {}, function(in_coma)
        if not in_coma then
            if LootBagEntities[netid] and not LootBagEntities[netid][3] and #(GetEntityCoords(LootBagEntities[netid][1]) - GetEntityCoords(GetPlayerPed(source))) < 3.00 then
                LootBagEntities[netid][3] = true;
                local user_id = HVC.getUserId({source})
                if user_id ~= nil then
                    if HVC.hasPermission({user_id, "police.menu"}) then
                        LootBagEntities[netid][5] = source
                        LootBagEntities[netid].Items = {}
                        TriggerClientEvent("HVC:PlaySound", source, "zipper")
                        TaskPlayAnim(GetPlayerPed(source), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false)
                        HVCclient.notify(source,{"~b~You have seized " .. LootBagEntities[netid].name .. "'s lootbag"})
                        DeleteEntity(LootBagEntities[netid][1])
                        CloseInv(source)                      
                    else
                        LootBagEntities[netid][5] = source
                        OpenInv(source, netid, LootBagEntities[netid].Items)
                        HVCclient.notify(source,{"~g~You have opened " .. LootBagEntities[netid].name .. "'s lootbag"})
                    end
                end
            else
                HVCclient.notify(source, {'~r~This loot bag is already being looted.'})
            end
        else 
            HVCclient.notify(source, {'~r~You cannot open this while dead silly.'})
        end
    end)
end)

Citizen.CreateThread(function()
    while true do 
        Wait(250)
        for i,v in pairs(LootBagEntities) do 
            if v[5] then 
                local coords = GetEntityCoords(GetPlayerPed(v[5]))
                local objectcoords = GetEntityCoords(v[1])
                if #(objectcoords - coords) > 3.0 then
                    CloseInv(v[5])
                    Wait(3000)
                    v[3] = false; 
                    v[5] = nil;
                end
            end
        end
    end
end)

RegisterNetEvent('HVC:CloseLootbag')
AddEventHandler('HVC:CloseLootbag', function()
    local source = source
    for i,v in pairs(LootBagEntities) do 
        if v[5] and v[5] == source then 
            CloseInv(v[5])
            Wait(3000)
            v[3] = false; 
            v[5] = nil;
        end
    end
end)

function CloseInv(source)
    TriggerClientEvent('HVC:InventoryOpen', source, false, false)
end

function OpenInv(source, netid, LootBagItems)
    local UserId = HVC.getUserId({source})
    local data = HVC.getUserDataTable({UserId})
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
        end
        TriggerClientEvent('HVC:FetchPersonalInventory', source, FormattedInventoryData, HVC.computeItemsWeight({data.inventory}), HVC.getInventoryMaxWeight({UserId}))
        InventorySpamTrack[source] = false;
    else 
        print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
    TriggerClientEvent('HVC:InventoryOpen', source, true, true)
    local FormattedInventoryData = {}
    for i, v in pairs(LootBagItems) do
        FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
    end
    local maxVehKg = 200
    TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({LootBagItems}), maxVehKg)
end




function Log(source)
    local Name = GetPlayerName(source)
    local PermID = HVC.getUserId({source})
    local communityname = "HVC Anticheat Logs"
    local communtiylogo = ""
    local command = {
        {
            ["color"] = "15536128",
            ["title"] = Name.. " has been banned for triggering event without finishing first steps",
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
            ["description"] = "Triggered lockpick event without completing full 100 seconds",
            ["footer"] = {
            ["text"] = communityname,
            ["icon_url"] = communtiylogo,
            },
        }
    }
    PerformHttpRequest("https://canary.discord.com/api/webhooks/893174143246295090/Y_iOacr7fSFXO8fBrzn7D04ukag8Wm3DFCXm684pU-Ma6GisMRQKsT4vVU8AgqoxX8mm", function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
    local Time = os.time()
    Time = Time + (60 * 60 * 500000)
    HVC.BanUser({source, "Type #TE", Time, "HVC"})
end


------------------CRATE DROPS BY CENCH---------------------------------------------------------------------------------------

local OnlinePlayers = 5; --Change this to what ever number of players must be on to start airdrop
local HowOftenCrateDrops = 3; --This changes how often the crate drops in hours.
local DropTimeConverter = HowOftenCrateDrops * 3600000 -- Ignore

local Locations = {
    [1] = {-830.2418, 2085.732, 115.6351},
    [2] = {2038.594,2129.968,93.43976},
    [3] = {-1627.528,720.173,192.08515},
    [4] = {386.280,6806.735,3.39590},
    [5] = {28.658,4336.290,42.90967},
    [6] = {-1716.04, 8878.84, 27.35901},
    [7] = {-1716.04, 8878.84, 27.35901},
}

local CrateItems = {"stimshot", "paracetamol"}
local CrateGuns = { "wbody|WEAPON_MOSINHVC","WEAPON_LVOAHVC","wbody|WEAPON_KASHNARHVC","wbody|WEAPON_AK74HVC","wbody|WEAPON_UMPHVC","wbody|WEAPON_MK1EMRHVC","wbody|WEAPON_MXMHVC","wbody|WEAPON_SVDHVC","wbody|WEAPON_AK200HVC","wbody|WEAPON_LR300HVC","wbody|WEAPON_M1911HVC","wbody|WEAPON_UZIHVC","wbody|WEAPON_MAKAROVHVC","wbody|WEAPON_WINCHESTER12HVC"}
local CrateAmmo = {".308 Sniper Rounds","NATO 5.56 Bullets","9mm Bullets","7.62mm Bullets","12 Gauge Shells",}
local Crate = false;
local Timer = false;
local UnlockTimer = false;
local DisplayedNotication = false;

Citizen.CreateThread(function()
    while true do
        Wait(DropTimeConverter)
        if GetPlayersCount() > OnlinePlayers then
            local Randomizer = math.random(1,7)
            local Location = Locations[Randomizer]
            if not DisplayedNotication then 
                Timer = true;
                UnlockTimer = 0;
                HVCclient.notifyPicture(-1,{"CHAR_CARE_PACK",1,"~h~Care Package",false,"Care package is ready for deployment!"})
                TriggerClientEvent("HVC:PlaySound", -1, "care")
                DisplayedNotication = true;         
            end
            if Location then
                Wait(5000)
                TriggerClientEvent("chatMessage", -1, "^1^*EVENT", {180, 0, 0},  "Airdrop has been located and has been marked on your map.", "alert")
                Crate = CreateObjectNoOffset(GetHashKey("gr_prop_gr_rsply_crate04b"),Location[1],Location[2],Location[3], true, true, false)
                while not DoesEntityExist(Crate) do
                    Citizen.Wait(0)
                end
                local NetworkID = NetworkGetNetworkIdFromEntity(Crate)
                CrateLogs[NetworkID] = {Crate,NetworkID}
                CrateLogs[NetworkID].Items = {}
                local PickRandomItem = CrateItems[math.random(2, #CrateItems)]
                CrateLogs[NetworkID].Items[PickRandomItem] = {}
                CrateLogs[NetworkID].Items[PickRandomItem].amount = math.random(1,3)
                --guns
                local PickRandomGun = CrateGuns[math.random(2, #CrateGuns)]
                CrateLogs[NetworkID].Items[PickRandomGun] = {}
                CrateLogs[NetworkID].Items[PickRandomGun].amount = math.random(1,2)
                --ammo
                local PickRandomAmmo = CrateAmmo[math.random(2, #CrateAmmo)]
                CrateLogs[NetworkID].Items[PickRandomAmmo] = {}
                CrateLogs[NetworkID].Items[PickRandomAmmo].amount = math.random(50,150)
                HVCclient.PlaceBlip(-1, {Location[1],Location[2],Location[3]})
                HVCclient.PlaceOnFloor(-1,{NetworkID}) 
            end
        end
    end
end)


RegisterNetEvent('HVC:LootCrate')
AddEventHandler('HVC:LootCrate', function(NetID)
    local source = source
    local PermID = HVC.getUserId({source})
    local PlayerName = GetPlayerName(source)
    if UnlockTimer > 0 then 
        HVCclient.notify(source,{"~r~Crate is still locked. Unlocking in " ..UnlockTimer.. " minutes"})
        return;
    else
        if PermID ~= nil and CrateLogs[NetID] and #(GetEntityCoords(CrateLogs[NetID][1]) - GetEntityCoords(GetPlayerPed(source))) < 2.0 then
            if HVC.hasPermission({PermID, "police.drag"}) then 
                HVCclient.notify(source,{"~r~Police can not loot crates."})
            else
                HVCclient.notify(-1,{"~r~Crate is being looted by " ..PlayerName})
                OpenInvCrate(source, NetID, CrateLogs[NetID].Items)
                TriggerClientEvent("HVC:PlaySound", source,"opencare")
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        if Timer then 
            UnlockTimer = UnlockTimer -1
            if UnlockTimer == 0 then
                Timer = false
            end
        end
        Wait(60000)
    end
end)

function GetPlayersCount()
    local count = 0
    for _, i in ipairs(GetPlayers()) do
        count = count + 1
    end
    return count
end

function OpenInvCrate(source, netid, CrateItems)
    local UserId = HVC.getUserId({source})
    local data = HVC.getUserDataTable({UserId})
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
        end
        TriggerClientEvent('HVC:FetchPersonalInventory', source, FormattedInventoryData, HVC.computeItemsWeight({data.inventory}), HVC.getInventoryMaxWeight({UserId}))
    else 
        --print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
    TriggerClientEvent('HVC:InventoryOpen', source, true, false, true)
    local FormattedInventoryData = {}
    for i, v in pairs(CrateItems) do
        FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
    end
    local maxVehKg = 500
    TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({CrateItems}), maxVehKg)
end
        