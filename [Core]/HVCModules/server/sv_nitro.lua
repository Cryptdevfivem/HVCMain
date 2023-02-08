local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVCModules")



local Cooldown = {} --Better to have server sided checks rather then on the client (never trust the client)
RegisterServerEvent("CheckNitro")
AddEventHandler("CheckNitro", function()
    local source = source
    local Ped = GetPlayerPed(source)
    local discord = "https://discord.gg/hvc5m"
    local id = "1071225849455579206"
    local Health = GetEntityHealth(Ped)
    local Vehicle = GetVehiclePedIsIn(Ped, false)
    if Cooldown[source] and not (os.time() > Cooldown[source]) then
        return TriggerClientEvent("HVC:DisplayImageNotify", source, "Discord Nitro", "~y~You recently performed this action please wait.")
    else
        Cooldown[source] = nil;
    end
    if Health < 102 then
        return TriggerClientEvent("HVC:DisplayImageNotify", source, "Discord Nitro", "~y~You cannot use this command while in a coma.")
    end
    if Vehicle ~= 0 then
        return TriggerClientEvent("HVC:DisplayImageNotify", source, "Discord Nitro", "~y~You cannot use this command while in a vehicle.")
    end
    local identifiers = GetNumPlayerIdentifiers(source)
    for i = 0, identifiers + 1 do
        if GetPlayerIdentifier(source, i) ~= nil then
            if string.match(GetPlayerIdentifier(source, i), "discord") then
                discord = GetPlayerIdentifier(source, i)
                id = string.sub(discord, 9, -1)
            end
        end
    end
    if id == "" or id == nil then
        return TriggerClientEvent("HVC:DisplayImageNotify", source, "Discord Nitro", "~r~It seems you don't have discord running or installed try restart fivem")
    end
    exports["discordroles"]:isRolePresent(source, {'1071245159037141003'} --[[ can be a table or just a string. ]], function(hasRole)
        if hasRole == true then
            local Ped = GetPlayerPed(source)
            local Model = GetHashKey("bmx")
            local Vehicle = CreateVehicle(Model, GetEntityCoords(Ped), GetEntityHeading(Ped), true, false)
            while not DoesEntityExist(Vehicle) do
                Wait(100)
            end
            SetPedIntoVehicle(Ped, Vehicle, -1)
            Cooldown[source] = os.time() + tonumber(15)
        else
            return TriggerClientEvent("HVC:DisplayImageNotify", source, "Discord Nitro", "~y~This command is only available for nitro boosters of the HVC discord.")
        end
    end)
end)
