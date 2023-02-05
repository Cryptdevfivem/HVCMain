
print("MET PD PANIC MADE BY FЯΣΣD#9861")

local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")

-- Play tones on all clients
RegisterServerEvent("Police-Panic:NewPanic", function(Officer) 
    local source = source
    local user_id = HVC.getUserId({source})

	if(HVC.hasGroup({user_id, "cop"})) then
		print("Panic Has been triggered.")
        local policeOfficers = HVC.getUsersByPermission({"police.menu"})
        print(json.encode(policeOfficers))

        for _, policeOfficer in pairs(policeOfficers) do
            local officerSource = HVC.getUserSource({policeOfficer})
            TriggerClientEvent("Pass-Alarm:Return:NewPanic", officerSource, source, Officer) 
            print(officerSource)
        end
	else
		print("User without permission tried to /panic.")
	end
end)
