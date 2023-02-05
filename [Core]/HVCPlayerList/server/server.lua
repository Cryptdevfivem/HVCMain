local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")


local playerData = {}

local allGroups = {
    {name = "Founder", type = "group", group = "founder"},
    {name = "Lead Developer", type = "group", group = "ldev"},
    {name = "Developer", type = "group", group = "dev"},
    {name = "Staff", type = "permission", group = "admin.menu"},
    {name = "MPD", type = "permission", group = "police.menu"},
    {name = "NHS", type = "permission", group = "emscheck.revive"},
}




local function getLicense(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)

    for _, v in pairs(identifiers) do
        if string.match(v, 'license:') then
            return v
        end
    end
    return false
end

local function getTime(playerId)
    local source = source
    local PlayerID = HVC.getUserId({source})
    local PlayerDate = HVC.getUserDataTable({PlayerID})
    local PlayerTime = PlayerDate.timePlayed
    return PlayerTime
end

local function getStatus(playerId)
    local user_id = HVC.getUserId({playerId})
    if user_id ~= nil then
        for _, v in pairs(allGroups) do
            if v.type == "permission" then
                if HVC.hasPermission({user_id, v.group}) then
                    return v.name
                end
            elseif v.type == "group" then
                if HVC.hasGroup({user_id, v.group}) then
                    return v.name
                end
            end
        end
    end
    return "Civilian"
end



local function getJobs()
    local status = {
        civilian = 0,
        police = 0,
        nhs = 0,
        admin = 0
    }

    for _, v in pairs(GetPlayers()) do
        local user_id = HVC.getUserId({tonumber(v)})
        if HVC.hasPermission({user_id, "admin.menu"}) then
            status.admin = status.admin + 1
        end
        if HVC.hasPermission({user_id, "police.menu"}) then
            status.police = status.police + 1
        elseif HVC.hasPermission({user_id, "emscheck.revive"}) then
            status.nhs = status.nhs + 1
        elseif HVC.hasGroup({user_id, "Unemployed"}) then
            status.civilian = status.civilian + 1
        end
    end
    return status
end

function formatTime(seconds)
    if not seconds then return 0 end
    local status = {
        hours = 0,
        minutes = 0
    }
    status.hours = ("%02.f"):format(math.floor(seconds / 3600))
    status.minutes = ("%02.f"):format(math.floor(seconds / 60 - (status.hours * 60)))
    return status
end


RegisterNetEvent('vola:getPlayers', function(value)
    local source = source
    local value = value
    if not playerData[source] then
        return print('Scoreboard needs to be refreshed. Tell an admin to use /restartScoreboard')
    end
    local currentPlayers = {}
    local players = 'Players: ' .. #GetPlayers() .. ' / ' .. GetConvarInt('sv_maxclients', 32)
    local time = os.time()
    local runTime =  playerData[tonumber(source)].Time().displayed(time)
    for k, v in pairs(GetPlayers()) do
        local player = playerData[tonumber(v)]
        local status = getStatus(v)
        currentPlayers[k] = {UserID = HVC.getUserId({v}),playersId = v, playersName = player.getName(), playersTime = player.Time().displayed(time), playersJob = status}
    end
    TriggerClientEvent('vola:updatePlayers', source, currentPlayers, players, runTime, getJobs(), value)
end)

RegisterNetEvent('vola:playerJoined', function()
    local playerId = source
    if getLicense(playerId) then
        local time = getTime(playerId)
        local actualTime = os.time()
        playerData[tonumber(playerId)] = playerStatus(playerId, getLicense(playerId), time, actualTime, GetPlayerName(playerId))
    end
end)

-- Save player on drop
AddEventHandler('playerDropped', function()
	local playerId = source
	local player = playerData[playerId]
    local time = os.time()

	if player then
		playerData[tonumber(playerId)] = nil
	end
end)

-- Command
RegisterCommand('restartScoreboard', function(source)
    local playerId = source
    local actualTime =  os.time()
    local players = GetPlayers()
    for i=0, #players do
        local time = getTime(players[i])
        playerData[tonumber(players[i])] = playerStatus(players[i], getLicense(players[i]), time, actualTime)
    end
end, true) -- False, everyone can use it