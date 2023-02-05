local CheckTime = 1


Citizen.CreateThread(function()
	while true do
        Citizen.Wait(600000)
        VehCleanup()
	end
end)

function VehCleanup()
    TriggerClientEvent("HVC:VehicleCleanup", -1)
end