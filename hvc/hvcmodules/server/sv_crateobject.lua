RegisterServerCallback("HVC:CreateObject", function(source, model)
    if string.sub(model, 1, 1) == "w" then -- just a check to make sure its a weapon body
        local Coords = GetEntityCoords(GetPlayerPed(source))
        local Weapon = CreateObject(GetHashKey(model), 1.0, 1.0, 1.0, true, true, false)
        while not DoesEntityExist(Weapon) do
            Wait(0)
        end
        local NetID = NetworkGetNetworkIdFromEntity(Weapon)
        return NetID;
    end
end)