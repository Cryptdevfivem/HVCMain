local cfg = module("cfg/survival")
local lang = HVC.lang

-- api

function HVC.getHunger(user_id)
    local data = HVC.getUserDataTable(user_id)
    if data then
        return data.hunger
    end

    return 0
end

RegisterServerCallback("HVC:FetchKillerID", function(source, killer)
    local ReturnID = HVC.getUserId(killer)
    if ReturnID ~= nil then
        return ReturnID;
    else
        return false;
    end
end)

function HVC.getThirst(user_id)
    local data = HVC.getUserDataTable(user_id)
    if data then
        return data.thirst
    end

    return 0
end

function HVC.setHunger(user_id, value)
    local data = HVC.getUserDataTable(user_id)
    if data then
        data.hunger = value
        if data.hunger < 0 then
            data.hunger = 0
        elseif data.hunger > 100 then
            data.hunger = 100
        end

        -- update bar
        local source = HVC.getUserSource(user_id)
        HVCclient.setProgressBarValue(source, {"HVC:hunger", data.hunger})
        if data.hunger >= 100 then
            HVCclient.setProgressBarText(source, {"HVC:hunger", lang.survival.starving()})
        else
            HVCclient.setProgressBarText(source, {"HVC:hunger", ""})
        end
    end
end

function HVC.setThirst(user_id, value)
    local data = HVC.getUserDataTable(user_id)
    if data then
        data.thirst = value
        if data.thirst < 0 then
            data.thirst = 0
        elseif data.thirst > 100 then
            data.thirst = 100
        end

        -- update bar
        local source = HVC.getUserSource(user_id)
        HVCclient.setProgressBarValue(source, {"HVC:thirst", data.thirst})
        if data.thirst >= 100 then
            HVCclient.setProgressBarText(source, {"HVC:thirst", lang.survival.thirsty()})
        else
            HVCclient.setProgressBarText(source, {"HVC:thirst", ""})
        end
    end
end

function HVC.varyHunger(user_id, variation)
    if HVCConfig.EnableFoodAndWater then 
        local data = HVC.getUserDataTable(user_id)
        if data then
            local was_starving = data.hunger >= 100
            data.hunger = data.hunger + variation
            local is_starving = data.hunger >= 100

            -- apply overflow as damage
            local overflow = data.hunger - 100
            if overflow > 0 then
                HVCclient.varyHealth(HVC.getUserSource(user_id), {-overflow * cfg.overflow_damage_factor})
            end

            if data.hunger < 0 then
                data.hunger = 0
            elseif data.hunger > 100 then
                data.hunger = 100
            end

            -- set progress bar data
            local source = HVC.getUserSource(user_id)
            HVCclient.setProgressBarValue(source, {"HVC:hunger", data.hunger})
            if was_starving and not is_starving then
                HVCclient.setProgressBarText(source, {"HVC:hunger", ""})
            elseif not was_starving and is_starving then
                HVCclient.setProgressBarText(source, {"HVC:hunger", lang.survival.starving()})
            end
        end
    end
end

function HVC.varyThirst(user_id, variation)
    if HVCConfig.EnableFoodAndWater then 
        local data = HVC.getUserDataTable(user_id)
        if data then
            local was_thirsty = data.thirst >= 100
            data.thirst = data.thirst + variation
            local is_thirsty = data.thirst >= 100

            -- apply overflow as damage
            local overflow = data.thirst - 100
            if overflow > 0 then
                HVCclient.varyHealth(HVC.getUserSource(user_id), {-overflow * cfg.overflow_damage_factor})
            end

            if data.thirst < 0 then
                data.thirst = 0
            elseif data.thirst > 100 then
                data.thirst = 100
            end

            -- set progress bar data
            local source = HVC.getUserSource(user_id)
            HVCclient.setProgressBarValue(source, {"HVC:thirst", data.thirst})
            if was_thirsty and not is_thirsty then
                HVCclient.setProgressBarText(source, {"HVC:thirst", ""})
            elseif not was_thirsty and is_thirsty then
                HVCclient.setProgressBarText(source, {"HVC:thirst", lang.survival.thirsty()})
            end
        end
    end
end

-- tunnel api (expose some functions to clients)

function tHVC.varyHunger(variation)
    if HVCConfig.EnableFoodAndWater then 
        local user_id = HVC.getUserId(source)
        if user_id ~= nil then
            HVC.varyHunger(user_id, variation)
        end
    end
end

function tHVC.varyThirst(variation)
    if HVCConfig.EnableFoodAndWater then 
        local user_id = HVC.getUserId(source)
        if user_id ~= nil then
            HVC.varyThirst(user_id, variation)
        end
    end
end

-- tasks

-- hunger/thirst increase
function task_update()
    for k, v in pairs(HVC.users) do
        HVC.varyHunger(v, cfg.hunger_per_minute)
        HVC.varyThirst(v, cfg.thirst_per_minute)
    end

    SetTimeout(60000, task_update)
end

if HVCConfig.EnableFoodAndWater then 
    task_update()
end

-- handlers

-- init values
AddEventHandler("HVC:playerJoin", function(user_id, source, name, last_login)
    local data = HVC.getUserDataTable(user_id)
    if data.hunger == nil then
        data.hunger = 0
        data.thirst = 0
    end
end)

-- add survival progress bars on spawn
AddEventHandler("HVC:playerSpawn", function(user_id, source, first_spawn)
    local data = HVC.getUserDataTable(user_id)
    HVCclient.setPolice(source, {cfg.police})
    HVCclient.setFriendlyFire(source, {cfg.pvp})
    if HVCConfig.SurvivalUiEnabled then 
        HVCclient.setProgressBar(source, {"HVC:hunger", "minimap", htxt, 255, 153, 0, 0})
        HVCclient.setProgressBar(source, {"HVC:thirst", "minimap", ttxt, 0, 125, 255, 0})
    end
    HVC.setHunger(user_id, data.hunger)
    HVC.setThirst(user_id, data.thirst)
end)

-- EMERGENCY

---- revive
local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

local choice_revive = {function(player, choice)
    local user_id = HVC.getUserId(player)
    if user_id ~= nil then
        HVCclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = HVC.getUserId(nplayer)
            if nuser_id ~= nil then
                HVCclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        if HVC.tryGetInventoryItem(user_id, "medkit", 1, true) then
                            HVCclient.playAnim(player, {false, revive_seq, false}) -- anim
                            SetTimeout(15000, function()
                                HVCclient.varyHealth(nplayer, {50}) -- heal 50
                            end)
                        end
                    else
                        HVCclient.notify(player, {lang.emergency.menu.revive.not_in_coma()})
                    end
                end)
            else
                HVCclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, lang.emergency.menu.revive.description()}

-- add choices to the main menu (emergency)
HVC.registerMenuBuilder("main", function(add, data)
    local user_id = HVC.getUserId(data.player)
    if user_id ~= nil then
        local choices = {}
        if HVC.hasPermission(user_id, "emergency.revive") then
            choices[lang.emergency.menu.revive.title()] = choice_revive
        end

        add(choices)
    end
end)




RegisterServerEvent("HVC:ForceStoreBackpack")
AddEventHandler("HVC:ForceStoreBackpack", function()
    local user_id = HVC.getUserId(source)
    local data = HVC.getUserDataTable(user_id)

    if data.invcap == 30 then

      return
    end
    if data.invcap - 20 == 30 then
      HVC.giveInventoryItem(user_id, "guccipouch", 1, false)
    elseif data.invcap - 30 == 30  then
      HVC.giveInventoryItem(user_id, "nikeschoolbackpack", 1, false)
    elseif data.invcap - 45 == 30  then
      HVC.giveInventoryItem(user_id, "louisvuittonbag", 1, false)
    elseif data.invcap - 70 == 30  then
      HVC.giveInventoryItem(user_id, "rebelpack", 1, false)
    end

    updateInvCap(user_id, 0)
    HVCclient.notify(source,{"~g~Backpack Stored"})

end)