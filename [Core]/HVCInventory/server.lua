-- A JamesUK Production. Licensed users only. Use without authorisation is illegal, and a criminal offence under UK Law.
local Tunnel = module("HVC", "lib/Tunnel")
local Proxy = module("HVC", "lib/Proxy")
local HVC = Proxy.getInterface("HVC")
local HVCclient = Tunnel.getInterface("HVC","HVC") -- server -> client tunnel
local Inventory = module("CXVehicles", "cfg/cfg_inventory")
local Housing = module("CXModules", "cfg/cfg_homes")
local InventorySpamTrack = {} -- Stops inventory being spammed by users.
local LootBagEntities = {}
local InventoryCoolDown = {}
local houseName = ""


RegisterNetEvent('HVC:FetchPersonalInventory')
AddEventHandler('HVC:FetchPersonalInventory', function()
    local source = source
    if not InventorySpamTrack[source] then
        InventorySpamTrack[source] = true;
        local UserId = HVC.getUserId({source}) 
        local data = HVC.getUserDataTable({UserId})
        if data and data.inventory then
            local FormattedInventoryData = {}
            --print(json.encode(data.inventory))
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
            end
            TriggerClientEvent('HVC:FetchPersonalInventory', source, FormattedInventoryData, HVC.computeItemsWeight({data.inventory}), HVC.getInventoryMaxWeight({UserId}))
            InventorySpamTrack[source] = false;
        else 
            -- print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
        end
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
        -- print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
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

RegisterServerEvent("ORP:flashLights")
AddEventHandler("ORP:flashLights", function(nearestVeh)
    local nearestVeh = nearestVeh
    TriggerClientEvent("ORP:flashCarLightsAlarm", -1, nearestVeh)

end) 

RegisterNetEvent('HVC:FetchTrunkInventory')
AddEventHandler('HVC:FetchTrunkInventory', function(spawnCode, vehid)
    local source = source
    local idz = NetworkGetEntityFromNetworkId(vehid)
    local user_id = HVC.getUserId({NetworkGetEntityOwner(idz)})
    if InventoryCoolDown[source] then HVCclient.notify(source, {'~r~The server is having trouble caching the boot linked with your ID. Please rejoin.'}) return end
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
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

RegisterNetEvent('HVC:FetchHouseInventory')
AddEventHandler('HVC:FetchHouseInventory', function(nameHouse)
    local source = source
    houseName = nameHouse
    local user_id = HVC.getUserId({source})
    local homeformat = "chest:u" .. user_id .. "home" ..houseName
    --print(homeformat)
    HVC.getSData({homeformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
        end
        local maxVehKg = Housing.chestsize[houseName] or 500
      
        TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
    
    end})
end)



RegisterNetEvent('HVC:LockPick')
AddEventHandler('HVC:LockPick', function()
    local user_id = HVC.getUserId({source})
    if HVC.tryGetInventoryItem({user_id, "lockpick", 1, true}) then
        TriggerClientEvent('HVC:whatIsThis', source)
    end  
end)

RegisterNetEvent('HVC:UseItem')
AddEventHandler('HVC:UseItem', function(itemId, itemLoc)
    local source = source
    if not itemId then    HVCclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        HVC.RunInventoryTask({source, itemId})
    else
        HVCclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)


RegisterNetEvent('HVC:MoveItem')
AddEventHandler('HVC:MoveItem', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local UserId = HVC.getUserId({source}) 
    local data = HVC.getUserDataTable({UserId})
    if InventoryCoolDown[source] then HVCclient.notify(source, {'~r~Inventory Cooldown.'}) return end
    if not itemId then  HVCclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            --InventoryCoolDown[source] = true;
            local Quantity = parseInt(1)
            if Quantity then
                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
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
                            --InventoryCoolDown[source] = false;
                            HVC.setSData({carformat, json.encode(cdata)})
                        else 
                            --InventoryCoolDown[source] = false;
                            HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        --InventoryCoolDown[source] = false;
                        -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                    end
                end})
            end
        elseif inventoryType == "LootBag" then  
            if LootBagEntities[inventoryInfo] ~= nil then  
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = HVC.getInventoryWeight({UserId})+HVC.getItemWeight({itemId})
                    if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                        if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > 1 then
                            LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - 1 
                            HVC.giveInventoryItem({UserId, itemId, 1, true})
                        else 
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            HVC.giveInventoryItem({UserId, itemId, 1, true})
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
            else
                HVCclient.notify(source,{"~r~This item isn't available!"})
            end
        elseif inventoryType == "Housing" then
            local Quantity = parseInt(1)
            if Quantity then
                local homeformat = "chest:u" .. UserId .. "home" ..houseName
                HVC.getSData({homeformat, function(cdata)
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
                            local maxVehKg = Housing.chestsize[houseName] or 500
                            --local maxVehKg = 500
                            TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                            TriggerEvent('HVC:RefreshInventory', source)
                            HVC.setSData({homeformat, json.encode(cdata)})
                        else 
                            HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the home.')
                    end
                end})
            end
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    --InventoryCoolDown[source] = true;
                    if inventoryInfo == "home" then --start of housing intergration (moveitem)
                        local homeFormat = "chest:u" .. UserId .. "home" ..houseName
                        HVC.getSData({homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = HVC.computeItemsWeight({cdata})+HVC.getItemWeight({itemId})
                                local maxVehKg = Housing.chestsize[houseName] or 500
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
                                    local maxVehKg = Housing.chestsize[houseName] or 500
                                    TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('HVC:RefreshInventory', source)
                                    HVC.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
                                else 
                                    HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the home.')
                            end
                        end}) --end of housing intergration (moveitem)
                    else
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
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
                                    --InventoryCoolDown[source] = nil;
                                    HVC.setSData({carformat, json.encode(cdata)})
                                else 
                                    --InventoryCoolDown[source] = nil;
                                    HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                --InventoryCoolDown[source] = nil;
                                -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                            end
                        end})
                    end
                else
                    --InventoryCoolDown[source] = nil;
                    -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        --InventoryCoolDown[source] = nil;
        -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)



RegisterNetEvent('HVC:MoveItemX')
AddEventHandler('HVC:MoveItemX', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local UserId = HVC.getUserId({source}) 
    local data = HVC.getUserDataTable({UserId})
    if InventoryCoolDown[source] then HVCclient.notify(source, {'~r~Inventory Cooldown.'}) return end
    if not itemId then  HVCclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            --InventoryCoolDown[source] = true;
            TriggerClientEvent('HVC:ToggleNUIFocus', source, false)
            HVC.prompt({source, 'How many ' .. HVC.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                Quantity = parseInt(Quantity)
                TriggerClientEvent('HVC:ToggleNUIFocus', source, true)
                if Quantity >= 1 then
                    local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
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
                                --InventoryCoolDown[source] = nil;
                                HVC.setSData({carformat, json.encode(cdata)})
                            else 
                                --InventoryCoolDown[source] = nil;
                                HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                            end
                        else 
                            --InventoryCoolDown[source] = nil;
                            HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end
                    end})
                else
                    --InventoryCoolDown[source] = nil;
                    HVCclient.notify(source, {'~r~Invalid Amount!'})
                end
            end})
        elseif inventoryType == "LootBag" then 
            if LootBagEntities[inventoryInfo] ~= nil then  
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    TriggerClientEvent('HVC:ToggleNUIFocus', source, false)
                    HVC.prompt({source, 'How many ' .. HVC.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                        Quantity = parseInt(Quantity)
                        TriggerClientEvent('HVC:ToggleNUIFocus', source, true)
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
                else
                    HVCclient.notify(source,{"~r~This item isn't available!"})
                end
            end
        elseif inventoryType == "Housing" then
            TriggerClientEvent('HVC:ToggleNUIFocus', source, false)
            HVC.prompt({source, 'How many ' .. HVC.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                Quantity = parseInt(Quantity)
                TriggerClientEvent('HVC:ToggleNUIFocus', source, true)
                if Quantity then
                    local homeformat = "chest:u" .. UserId .. "home" ..houseName
                    HVC.getSData({homeformat, function(cdata)
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
                                local maxVehKg = Housing.chestsize[houseName] or 500
                                TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                TriggerEvent('HVC:RefreshInventory', source)
                                HVC.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
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
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    --InventoryCoolDown[source] = true;
                    TriggerClientEvent('HVC:ToggleNUIFocus', source, false)
                    if inventoryInfo == "home" then --start of housing intergration (moveitemx)
                        TriggerClientEvent('HVC:ToggleNUIFocus', source, false)
                        HVC.prompt({source, 'How many ' .. HVC.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                            Quantity = parseInt(Quantity)
                            TriggerClientEvent('HVC:ToggleNUIFocus', source, true)
                            if Quantity then
                                local homeFormat = "chest:u" .. UserId .. "home" ..houseName
                                HVC.getSData({homeFormat, function(cdata)
                                    cdata = json.decode(cdata) or {}
                                    if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                        local weightCalculation = HVC.computeItemsWeight({cdata})+(HVC.getItemWeight({itemId}) * Quantity)
                                        local maxVehKg = Housing.chestsize[houseName] or 500
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
                                            local maxVehKg = Housing.chestsize[houseName] or 500
                                            TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                            TriggerEvent('HVC:RefreshInventory', source)
                                            HVC.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
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
                        end}) --end of housing intergration (moveitemx)
                    else
                        HVC.prompt({source, 'How many ' .. HVC.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                            Quantity = parseInt(Quantity)
                            TriggerClientEvent('HVC:ToggleNUIFocus', source, true)
                            if Quantity then
                                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
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
                                            --InventoryCoolDown[source] = nil;
                                            HVC.setSData({carformat, json.encode(cdata)})
                                        else 
                                            --InventoryCoolDown[source] = nil;
                                            HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                        end
                                    else 
                                        --InventoryCoolDown[source] = nil;
                                        HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                    end
                                end})
                            else 
                                HVCclient.notify(source, {'~r~Invalid input!'})
                            end
                        end})
                    end
                else
                    -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


RegisterNetEvent('HVC:MoveItemAll')
AddEventHandler('HVC:MoveItemAll', function(inventoryType, itemId, inventoryInfo, vehid)
    local source = source
    local UserId = HVC.getUserId({source}) 
    local data = HVC.getUserDataTable({UserId})
    if not itemId then  HVCclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if InventoryCoolDown[source] then HVCclient.notify(source, {'~r~Inventory Cooldown.'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            --InventoryCoolDown[source] = true;
            local idz = NetworkGetEntityFromNetworkId(vehid)
            local user_id = HVC.getUserId({NetworkGetEntityOwner(idz)})
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
            HVC.getSData({carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = HVC.getInventoryWeight({user_id})+(HVC.getItemWeight({itemId}) * cdata[itemId].amount)
                    if weightCalculation <= HVC.getInventoryMaxWeight({user_id}) then
                        HVC.giveInventoryItem({user_id, itemId, cdata[itemId].amount, true})
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                        TriggerEvent('HVC:RefreshInventory', source)
                        --InventoryCoolDown[source] = nil;
                        HVC.setSData({carformat, json.encode(cdata)})
                    else 
                        --InventoryCoolDown[source] = nil;
                        HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    --InventoryCoolDown[source] = nil;
                    HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end})
        elseif inventoryType == "LootBag" then 
            if LootBagEntities[inventoryInfo] ~= nil then  
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = HVC.getInventoryWeight({UserId})+(HVC.getItemWeight({itemId}) *  LootBagEntities[inventoryInfo].Items[itemId].amount)
                    if weightCalculation <= HVC.getInventoryMaxWeight({UserId}) then
                        if  LootBagEntities[inventoryInfo].Items[itemId].amount <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                            HVC.giveInventoryItem({UserId, itemId, LootBagEntities[inventoryInfo].Items[itemId].amount, true})
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
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
            else
                HVCclient.notify(source,{"~r~This item isn't available!"})
            end
        elseif inventoryType == "Housing" then
            local homeformat = "chest:u" .. UserId .. "home" ..houseName
            HVC.getSData({homeformat, function(cdata)
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
                        local maxVehKg = Housing.chestsize[houseName] or 500
                        TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                        TriggerEvent('HVC:RefreshInventory', source)
                        HVC.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
                    else 
                        HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end})
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    --InventoryCoolDown[source] = true;
                    if inventoryInfo == "home" then --start of housing intergration (moveitemall)
                        local homeFormat = "chest:u" .. UserId .. "home" ..houseName
                        HVC.getSData({homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local weightCalculation = HVC.computeItemsWeight({cdata})+(HVC.getItemWeight({itemId}) * data.inventory[itemId].amount)
                                local maxVehKg = Housing.chestsize[houseName] or 500
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
                                    local maxVehKg = Housing.chestsize[houseName] or 500
                                    TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('HVC:RefreshInventory', source)
                                    HVC.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
                                else 
                                    HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end}) --end of housing intergration (moveitemall)
                    else 
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
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
                                    --InventoryCoolDown[source] = nil;
                                    HVC.setSData({carformat, json.encode(cdata)})
                                else 
                                    --InventoryCoolDown[source] = nil;
                                    HVCclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                --InventoryCoolDown[source] = nil;
                                HVCclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end})
                    end
                else
                    --InventoryCoolDown[source] = nil;
                    -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        --InventoryCoolDown[source] = nil;
        -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


-- LOOTBAGS CODE BELOW HERE 

RegisterNetEvent('HVC:InComa')
AddEventHandler('HVC:InComa', function()
    local source = source
    local user_id = HVC.getUserId({source})
    HVCclient.isInComa(source, {}, function(in_coma) 
        if in_coma then
            Wait(3000)
           
            local weight = HVC.getInventoryWeight({user_id})

            if HVC.hasPermission({user_id, "pd.armory"}) or weight == 0 then 
                return 
            end

            local model = GetHashKey('ch_prop_ch_bag_02a')
            local name1 = GetPlayerName(source)
            local lootbag = CreateObjectNoOffset(model, GetEntityCoords(GetPlayerPed(source)), true, true, false)
            local lootbagnetid = NetworkGetNetworkIdFromEntity(lootbag)
            --PlaceObjectOnGroundProperly(lootbag)
            local ndata = HVC.getUserDataTable({user_id})
            local stored_inventory = nil;

            TriggerEvent('HVC:StoreWeaponsRequest', source)

            LootBagEntities[lootbagnetid] = {lootbag, lootbag, false, source}
            LootBagEntities[lootbagnetid].Items = {}
            LootBagEntities[lootbagnetid].name = name1 
         
            if ndata ~= nil then
                if ndata.inventory ~= nil then
                    stored_inventory = ndata.inventory
                    HVC.clearInventory({user_id})
                    for k, v in pairs(stored_inventory) do
                        LootBagEntities[lootbagnetid].Items[k] = {}
                        LootBagEntities[lootbagnetid].Items[k].amount = v.amount
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('HVC:LootBag')
AddEventHandler('HVC:LootBag', function(netid)
    local source = source
    HVCclient.isInComa(source, {}, function(in_coma) 
        if not in_coma then
            if LootBagEntities[netid] then
                LootBagEntities[netid][3] = true;
                local user_id = HVC.getUserId({source})
                if user_id ~= nil then
                    TriggerClientEvent("HVC:PlaySound", source, "zipper")
                    LootBagEntities[netid][5] = source

                    if HVC.hasPermission({user_id, "pd.armory"}) then
                        HVC.clearInventory({LootBagEntities[netid].id})
                        HVCclient.notify(source,{"~r~You have seized " .. LootBagEntities[netid].name .. "'s items"})

                        OpenInv(source, netid, LootBagEntities[netid].Items)
                    else
                        OpenInv(source, netid, LootBagEntities[netid].Items)
                    end  
                end
            else
                HVCclient.notify(source, {'~r~This loot bag is unavailable.'})
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
                if #(objectcoords - coords) > 5.0 then
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
        -- print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
    TriggerClientEvent('HVC:InventoryOpen', source, true, true)
    local FormattedInventoryData = {}

    if HVC.hasPermission({UserId, "pd.armory"}) then
        for i,v in pairs(LootBagEntities) do 
            if DoesEntityExist(v[1]) then 
                DeleteEntity(v[1])
                -- print('Deleted Lootbag')
                LootBagEntities[i] = nil;
            end
        end
    else
        for i, v in pairs(LootBagItems) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = HVC.getItemName({i}), Weight = HVC.getItemWeight({i})}
        end
        local maxVehKg = 200
        TriggerClientEvent('HVC:SendSecondaryInventoryData', source, FormattedInventoryData, HVC.computeItemsWeight({LootBagItems}), maxVehKg)

        HVCclient.notify(source,{"~g~You have opened " .. LootBagEntities[netid].name .. "'s lootbag"})
    end
    -- print(json.encode(FormattedInventoryData))
end


-- Garabge collector for empty lootbags.
Citizen.CreateThread(function()
    while true do 
        Wait(500)
        for i,v in pairs(LootBagEntities) do 
            local itemCount = 0;
            for i,v in pairs(v.Items) do
                itemCount = itemCount + 1
            end
            if itemCount == 0 then
                if DoesEntityExist(v[1]) then 
                    DeleteEntity(v[1])
                    --print('Deleted Lootbag')
                    LootBagEntities[i] = nil;
                end
            end
        end
        --print('All Lootbag garbage collected.')
    end
end)