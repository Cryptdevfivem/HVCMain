local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVC_TruckJob")


--This one is even worse then the previous one (rewrite also coming soon.)

RegisterServerEvent("HVC:052105kd1490")
AddEventHandler("HVC:052105kd1490",function(coords, pay, JobStarted, plycoords)
    local source = source
    local user_id = HVC.getUserId({source})
    local plycoords = GetEntityCoords(GetPlayerPed(source))

    if #(plycoords - coords) > 15 then
        -- ban function here
        print("Banning Player")
        return
    end


    if plycoords == "d1cm,19uj4lca014" then
        print("Banning Player")
        return
    end     
    if JobStarted then
        if pay > 30000 then
            -- ban function here
            print("Banning Player")
            return
        else
            print("Paid Player")
            HVC.giveMoney({user_id, pay})
        end
    else
        HVCclient.notify(source, {"~r~How The Fuck You Finishing Job With Out It Being Started?"})
        -- ban function here
        print("Banning Player")
    end
end)

RegisterServerCallback("HVC:RoyalMailVeh", function(source)
    local Ped = GetPlayerPed(source)
    local VehicleHash = GetHashKey("royalmail") --royalmail
    local Coords = GetEntityCoords(Ped)
    local Vehicle = CreateVehicle(VehicleHash, Coords, 200, true, false)
    while not DoesEntityExist(Vehicle) do
        Wait(100)
    end
    local NetID = NetworkGetNetworkIdFromEntity(Vehicle)
    return NetID;
end)

RegisterServerCallback("HVC:TruckJobVeh", function(source)
    local Ped = GetPlayerPed(source)
    local VehicleHash = GetHashKey("royalmail") --royalmail
    local Coords = GetEntityCoords(Ped)
    local Vehicle = CreateVehicle(VehicleHash, Coords, 200, true, false)
    while not DoesEntityExist(Vehicle) do
        Wait(100)
    end
    local NetID = NetworkGetNetworkIdFromEntity(Vehicle)
    return NetID;
end)



RegisterServerEvent("HVC:TruckJobPay")
AddEventHandler("HVC:TruckJobPay",function(price)

end)