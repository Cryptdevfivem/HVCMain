local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVCRageUIMenus")

local CarDevPerm = "cardev.acess";

RegisterServerCallback("HVC:FetchCarDev", function(source)
    local UserID = HVC.getUserId({source})
    if HVC.hasPermission({UserID, CarDevPerm}) then
        return true;
    else
        return false;
    end
end)

local World = {}
RegisterServerCallback("HVC:ChangeWorldsCarDev", function(source)
    local UserID = HVC.getUserId({source})
    local Entity = GetPlayerPed(source)
    if HVC.hasPermission({UserID, CarDevPerm}) then --Change Permission to what ever the fuck you want.
        if not World[UserID] then
            SetEntityRoutingBucket(Entity, UserID)
            HVCclient.notify(source,{"~g~You have teleported to your own world."}) 
            World[UserID] = {Coords = GetEntityCoords(Entity)};
        else
            local Vehicle = GetVehiclePedIsIn(Entity, false)
            if Vehicle ~= 0 then
                DeleteEntity(Vehicle)
            end
            SetEntityRoutingBucket(Entity, 0)
            SetEntityCoords(Entity, World[UserID].Coords, false, false, false, false)
            World[UserID] = nil;
            HVCclient.notify(source,{"~g~You have teleported back to main world."}) 
        end
    end
end)

RegisterServerCallback("HVC:SpawnVehicle", function(source)
    local UserID = HVC.getUserId({source})
    local Entity = GetPlayerPed(source)
    if HVC.hasPermission({UserID, CarDevPerm}) then --Change Permission to what ever the fuck you want.
        if World[UserID] then
            HVC.prompt({source, "Spawn code of vehicle to spawn","",function(player, hash)
                local Model = GetHashKey(hash)
                local Coords = GetEntityCoords(Entity)
                local nveh = CreateVehicle(Model, Coords + 0.5, 0.0, true, false)
                while not DoesEntityExist(nveh) do
                    Citizen.Wait(0)
                end
                SetPedIntoVehicle(Entity, nveh, -1)
                return true;
            end})
        else
            HVCclient.notify(source,{"~r~You can only spawn vehicles in your own world."}) 
        end
    end
end)

RegisterNetEvent("HVC:TeleportLoc")
AddEventHandler("HVC:TeleportLoc",function(coords, heading)
    local UserID = HVC.getUserId({source})
    local Entity = GetPlayerPed(source)
    if HVC.hasPermission({UserID, CarDevPerm}) then --Change Permission to what ever the fuck you want.
        if World[UserID] then
            local Vehicle = GetVehiclePedIsIn(Entity, false)
            if Vehicle ~= 0 then
                SetEntityCoords(Vehicle, coords, false, false, false, true)
                SetEntityHeading(Vehicle, heading)
                HVCclient.notify(source,{"~g~Teleported to location"})
            else
                SetEntityCoords(Entity, coords, false, false, false, true)
                SetEntityHeading(Entity, heading)
                HVCclient.notify(source,{"~g~Teleported to location"}) 
            end
        else
            HVCclient.notify(source,{"~r~You can only Teleport in your own world."}) 
        end
    end
end)


RegisterServerCallback("HVC:CheckWithinWorld", function(source)
    local UserID = HVC.getUserId({source})
    local Entity = GetPlayerPed(source)
    if HVC.hasPermission({UserID, CarDevPerm}) then --Change Permission to what ever the fuck you want.
        if World[UserID] then
            return true;
        else
            HVCclient.notify(source,{"~r~You can only perform this action within your own world."}) 
            return false;
        end
    end
end)

RegisterCommand("dv", function(source)
    local UserID = HVC.getUserId({source})
    local Entity = GetPlayerPed(source)
    if HVC.hasPermission({UserID, CarDevPerm}) then --Change Permission to what ever the fuck you want.
        if World[UserID] then
            local Vehicle = GetVehiclePedIsIn(Entity, false)
            if Vehicle ~= 0 then
                DeleteEntity(Vehicle)
                HVCclient.notify(source,{"~g~Deleted Vehicle"}) 
            end
        else
            HVCclient.notify(source,{"~r~This command can only be used within your own world."}) 
        end
    end
end)



