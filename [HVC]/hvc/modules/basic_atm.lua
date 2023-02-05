-- a basic ATM implementation
local lang = HVC.lang
local cfg = module("cfg/atms")
local atms = cfg.atms

local function play_atm_enter(player)
    HVCclient.playAnim(player, {false,{{"amb@prop_human_atm@male@enter", "enter"},{"amb@prop_human_atm@male@idle_a", "idle_a"}}, false})
end

local function play_atm_exit(player)
    HVCclient.playAnim(player, {false, {{"amb@prop_human_atm@male@exit", "exit"}}, false})
end


--events for anims???????? lol who done this

RegisterNetEvent('HVC:AtmAnim')
AddEventHandler('HVC:AtmAnim', function()
    local source = source 
    HVCclient.playAnim(source, {false,{{"amb@prop_human_atm@male@enter", "enter"},{"amb@prop_human_atm@male@idle_a", "idle_a"}}, false})
end)

RegisterNetEvent('HVC:AtmAnim2')
AddEventHandler('HVC:AtmAnim2', function()
    local source = source 
    HVCclient.playAnim(source, {false, {{"amb@prop_human_atm@male@exit", "exit"}}, false})
end)


RegisterNetEvent('HVC:Withdraw')
AddEventHandler('HVC:Withdraw', function(amount)
    local source = source
    amount = parseInt(amount)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    for i, v in pairs(cfg.atms) do
        local coords = vec3(v[1], v[2], v[3])
        if #(playerCoords - coords) <= 5.0 then
            if amount > 0 then
                local user_id = HVC.getUserId(source)
                if user_id ~= nil then
                    if HVC.tryWithdraw(user_id, amount) then
                        HVCclient.notify(source, {"~g~£"..Comma(amount).." ~w~Withdrawn"})
                    else
                        HVCclient.notify(source, {lang.atm.withdraw.not_enough()})
                    end
                end
            else
                HVCclient.notify(source, {lang.common.invalid_value()})
            end
        end
    end
end)


RegisterNetEvent('HVC:Deposit')
AddEventHandler('HVC:Deposit', function(amount)
    local source = source
    amount = parseInt(amount)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    for i, v in pairs(cfg.atms) do
        local coords = vec3(v[1], v[2], v[3])
        if #(playerCoords - coords) <= 5.0 then
            if amount > 0 then
                local user_id = HVC.getUserId(source)
                if user_id ~= nil then
                    if HVC.tryDeposit(user_id, amount) then
                        HVCclient.notify(source, {"~g~£"..Comma(amount).." ~w~Deposited"})
                    else
                        HVCclient.notify(source, {lang.atm.withdraw.not_enough()})
                    end
                end
            else
                HVCclient.notify(source, {lang.common.invalid_value()})
            end
        end
    end
end)


RegisterNetEvent('HVC:DepositAll')
AddEventHandler('HVC:DepositAll', function()
    local source = source
    local Ped = GetPlayerPed(source)
    local Coords = GetEntityCoords(Ped)
    for i, v in pairs(cfg.atms) do
        local coords = vec3(v[1], v[2], v[3])
        if #(Coords - coords) <= 5.0 then
            local user_id = HVC.getUserId(source)
            local amount = HVC.getMoney(user_id)
            if amount > 0 then
                if user_id ~= nil then
                    if HVC.tryDeposit(user_id, amount) then
                        HVCclient.notify(source, {"~g~£"..Comma(amount).." ~w~Deposited"})
                    else
                        HVCclient.notify(source, {"~g~£"..Comma(amount).." ~w~Deposited"})
                    end
                end
            else
                HVCclient.notify(source, {lang.common.invalid_value()})
            end
        end
    end
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
