local cfg = module("cfg/player_state")
local lang = HVC.lang

-- client -> server events
AddEventHandler("HVC:playerSpawn", function(user_id, source, first_spawn)
    Debug.pbegin("playerSpawned_player_state")
    local player = source
    local data = HVC.getUserDataTable(user_id)
    local tmpdata = HVC.getUserTmpTable(user_id)

    if first_spawn then -- first spawn
        -- cascade load customization then weapons
        if data.customization == nil then
            data.customization = cfg.default_customization
        end

        if data.position == nil and cfg.spawn_enabled then
            TriggerClientEvent("starterTut", player)
            local x = cfg.spawn_position[1] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local y = cfg.spawn_position[2] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local z = cfg.spawn_position[3] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            data.position = {
                x = x,
                y = y,
                z = z
            }
        end

        if data.position ~= nil then -- teleport to saved pos
            HVCclient.teleport(source, {data.position.x, data.position.y, data.position.z})
        end

        if data.customization ~= nil then
            HVCclient.setCustomization(source, {data.customization},
                function() -- delayed weapons/health, because model respawn
                    if data.coma == true then
                        HVCclient.removeallweapons({source})
                    end
                    if data.weapons ~= nil then -- load saved weapons
                        HVCclient.giveWeapons(source, {data.weapons, true})

                        if data.health ~= nil then -- set health
                            TriggerEvent("HVC:ProvideHealth", source, data.health)
                            -- print("Health: " ..data.health)
                            -- print("Coma: " ..tostring(data.coma))
                            -- print(json.encode(HVC.getUserDataTable(user_id)))
                            SetTimeout(1000, function() -- check coma, kill if in coma
                                if data.coma == true or tonumber(data.health) == 0 or  tonumber(data.health) == 100 or tonumber(data.health) == 102 then
                                    HVCclient.notify(source, {"~r~You Were Dead When You Left The City."})
                                    HVCclient.removeallweapons(source)
                                    HVC.clearInventory(user_id)
                                    HVCclient.killComa(player, {})
                                    HVCclient.setHealth(source, {0})
                                end
                            end)
                            TriggerEvent("HVC:ProvideHealth", source, data.health)
                            SetTimeout(5000, function() -- check coma, kill if in coma
                                HVCclient.isInComa(player, {}, function(in_coma)
                                    HVCclient.killComa(player, {})
                                end)
                            end)
                        end
                        
                        if data.armour ~= nil then
                            TriggerEvent("HVC:ProvideArmour", source, data.armour)
                        end
                    end
                end)
        else
            if data.weapons ~= nil then -- load saved weapons
                HVCclient.giveWeapons(source, {data.weapons, true})
            end

            if data.health ~= nil then
                TriggerEvent("HVC:ProvideHealth", source, data.health)
            end
        end

        -- notify last login
        SetTimeout(15000, function()
            HVCclient.notify(player, {lang.common.welcome({tmpdata.last_login})})
        end)
    else -- not first spawn (player died), don't load weapons, empty wallet, empty inventory
        HVC.setHunger(user_id, 0)
        HVC.setThirst(user_id, 0)

        if cfg.clear_phone_directory_on_death then
            data.phone_directory = {} -- clear phone directory after death
        end

        if cfg.lose_aptitudes_on_death then
            data.gaptitudes = {} -- clear aptitudes after death
        end

        if true then 
            HVC.clearInventory(user_id) 
        end
        
        HVC.setMoney(user_id, 0)

        -- disable handcuff
        HVCclient.setHandcuffed(player, {false})

        if cfg.spawn_enabled then -- respawn (CREATED SPAWN_DEATH)
            local x = cfg.spawn_death[1] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local y = cfg.spawn_death[2] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local z = cfg.spawn_death[3] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            data.position = {
                x = x,
                y = y,
                z = z
            }
            HVCclient.teleport(source, {x, y, z})
        end

        -- load character customization
        if data.customization ~= nil then
            HVCclient.setCustomization(source, {data.customization})
        end
    end
    Debug.pend()
end)

-- updates

function tHVC.updateComa(coma)
    local user_id = HVC.getUserId(source)
    if user_id ~= nil then
        local data = HVC.getUserDataTable(user_id)
        if data ~= nil then
            data.coma = coma
        end
    end
end

function tHVC.updatePos(x, y, z)
    local user_id = HVC.getUserId(source)
    if user_id ~= nil then
        local data = HVC.getUserDataTable(user_id)
        local tmp = HVC.getUserTmpTable(user_id)
        if data ~= nil and (tmp == nil or tmp.home_stype == nil) then -- don't save position if inside home slot
            data.position = {
                x = tonumber(x),
                y = tonumber(y),
                z = tonumber(z)
            }
        end
    end
end

function tHVC.updateWeapons(weapons)
    local user_id = HVC.getUserId(source)
    if user_id ~= nil then
        local data = HVC.getUserDataTable(user_id)
        if data ~= nil then
            data.weapons = weapons
        end
    end
end

function tHVC.updateCustomization(customization)
    local user_id = HVC.getUserId(source)
    if user_id ~= nil then
        local data = HVC.getUserDataTable(user_id)
        if data ~= nil then
            data.customization = customization
        end
    end
end

function tHVC.updateHealth(health)
    local user_id = HVC.getUserId(source)
    if user_id ~= nil then
        local data = HVC.getUserDataTable(user_id)
        if data ~= nil then
            data.health = health
        end
    end
end

function tHVC.updateArmour(armour)
    local user_id = HVC.getUserId(source)
    if user_id ~= nil then
        local data = HVC.getUserDataTable(user_id)
        if data ~= nil then
            data.armour = armour
        end
    end
end

function tHVC.updateTimePlayed()
    local user_id = HVC.getUserId(source)
    if user_id ~= nil then
        local data = HVC.getUserDataTable(user_id)
        if data ~= nil then
            if data.timePlayed == nil then
                data.timePlayed = 0
            end
            data.timePlayed = data.timePlayed + 30
        end
    end
end

function tHVC.updateBucket()
    local user_id = HVC.getUserId(source)
    if user_id ~= nil then
        local data = HVC.getUserDataTable(user_id)
        if data ~= nil then
            if data.BucketRoute == nil then
                data.BucketRoute = 0
            end
            data.BucketRoute = GetPlayerRoutingBucket(source)
        end
    end
end


local isStoring = {}
function tHVC.StoreWeaponsDead()
    local player = source 
    local user_id = HVC.getUserId(player)
    local data = HVC.getUserDataTable(user_id)
    if data.coma == true then
        HVCclient.removeallweapons({source})
        HVC.clearInventory(user_id)
        return
    end
	HVCclient.getWeapons(player,{},function(weapons)
        if not isStoring[player] then
            isStoring[player] = true
            HVCclient.giveWeapons(player,{{},true}, function(removedwep)
                for k,v in pairs(weapons) do
                    HVC.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                    if v.ammo > 0 then
                        for i,v in pairs(HVCAmmoTypes) do
                            for a,d in pairs(v) do
                                if d == k then  
                                    HVC.giveInventoryItem(user_id, i, v.ammo, true)
                                end
                            end   
                        end
                    end
                end
                HVCclient.notify(player,{"~g~Weapons stored!"})
                SetTimeout(10000,function()
                    isStoring[player] = nil 
                end)
            end)
        else
            HVCclient.notify(player,{"~o~Your weapons are already being stored!"})
        end
	end)
end

RegisterCommand("storeweapons", function(source)
    local player = source 
    local user_id = HVC.getUserId(player)
    HVCclient.getWeapons(player,{},function(weapons)
        if not isStoring[player] then
            isStoring[player] = true
            HVCclient.giveWeapons(player,{{},true}, function(removedwep)
                for k,v in pairs(weapons) do
                    HVC.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                    if v.ammo > 0 then
                        local amm = v.ammo
                        for i,v in pairs(HVCAmmoTypes) do
                            for a,d in pairs(v) do
                                if d == k then
                                    HVC.giveInventoryItem(user_id, i, amm, true)
                                end
                            end   
                        end
                    end
                end
                HVCclient.notify(player,{"~g~Weapons stored!"})
                SetTimeout(5000,function()
                    isStoring[player] = nil 
                end)
            end)
        else
            HVCclient.notify(player,{"~o~Your weapons are already being stored!"})
        end
    end)
end)

AddEventHandler('HVC:StoreWeaponsRequest', function(source)
    local player = source 
    local user_id = HVC.getUserId(player)
    HVCclient.getWeapons(player,{},function(weapons)
        if not isStoring[player] then
            isStoring[player] = true
            HVCclient.giveWeapons(player, {{}, true}, function(removedwep)
                for k,v in pairs(weapons) do
                    if v.ammo > 0 then
                        --vRP.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
                        HVC.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                    end
                end
                HVCclient.notify(player,{"~g~Weapons Stored"})
                SetTimeout(10000,function()
                    isStoring[player] = nil 
                end)
            end)
        end
	end)
end)

--[[
function tHVC.updateTimePlayed()
    local user_id = HVC.getUserId(source)
    if HVC.isConnected(user_id) then
        if user_id ~= nil then
            local data = HVC.getUserDataTable(user_id)
            if data ~= nil then
                if data.timePlayed == nil then
                    data.timePlayed = 0
                end
                data.timePlayed = data.timePlayed + 30
            end
        end
    end
end
]]