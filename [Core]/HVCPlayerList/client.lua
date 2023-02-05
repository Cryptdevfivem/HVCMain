local firstSpawn = true
CreateThread(function()
	while firstSpawn do
		Wait(0)

		if NetworkIsPlayerActive(PlayerId()) then
            if firstSpawn then
			    TriggerServerEvent('vola:playerJoined')
                firstSpawn = false
            end
			break
		end
	end
    TriggerServerEvent('vola:getPlayers', false)
end)

local testing = {
    {
        ['UserID'] = 69,
        ['playersTime'] = '457239HRS 09M',
        ['playersId'] = 1,
        ['playersJob'] = 'Civilian',
        ['playersName'] = 'Shaz2'
    },
}

local Opened = false 
RegisterNetEvent('vola:updatePlayers', function(players, maxPlayers, runTime, jobs, value)
    SendNUIMessage({
        action = 'updatePlayers',
        players = players,
        maxPlayers = maxPlayers,
        runTime = runTime,
        jobs = jobs
    })
    if value then 
        SendNUIMessage({action = 'openScoreboard'})
        SetNuiFocus(true, true)
    end
end)


RegisterCommand("PlayerList", function()
    TriggerServerEvent('vola:getPlayers', true)
end)



RegisterKeyMapping("PlayerList", "PlayerList", "keyboard", "HOME")

RegisterNUICallback("exit",function()
    SendNUIMessage({action = 'destroy'})
    SetNuiFocus(false, false)
end)