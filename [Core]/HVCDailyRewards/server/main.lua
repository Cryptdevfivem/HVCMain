if Database.useJson then
    playersDataFile, playersDataJson = LoadResourceFile(GetCurrentResourceName(), "./data/svplys.json"), {}
end

local rewardsListForClients = Rewards

CreateThread(function() 
    if Database.useJson then
        if playersDataFile ~= nil then
            playersDataJson = json.decode(playersDataFile)
        end
    end
end)

RegisterNetEvent("scrwds:dataCheck")
AddEventHandler("scrwds:dataCheck", function()
    local _source = source
    local license = GetLicense(GetPlayerIdentifiers(_source))

    if Database.useJson then
        if playersDataFile == nil then
            playersDataJson = { 
                { 
                    _license = license, 
                    days = 1, 
                    weekday = string.lower(os.date("%A")),
                    time = os.time(os.date("!*t"))
                } 
            }

            SaveResourceFile(GetCurrentResourceName(), "./data/svplys.json", json.encode(playersDataJson, { indent = true }), -1)
            playersDataJson = json.decode(LoadResourceFile(GetCurrentResourceName(), "./data/svplys.json"))
            TriggerClientEvent("ccrwds:clList", _source, rewardsListForClients, 1, {})
        else
            if not IsValueInTable(license, playersDataJson) then
                playersDataJson[#playersDataJson + 1] = { 
                    _license = license, 
                    days = 1, 
                    weekday = string.lower(os.date("%A")),
                    time = os.time(os.date("!*t")),
                    rewardsReceived = { }
                }

                SaveResourceFile(GetCurrentResourceName(), "./data/svplys.json", json.encode(playersDataJson, { indent = true }), -1)
                playersDataJson = json.decode(LoadResourceFile(GetCurrentResourceName(), "./data/svplys.json"))
                TriggerClientEvent("ccrwds:clList", _source, rewardsListForClients, 1, {})
            else
                DataManipulation(_source, license, rewardsListForClients)
            end
        end
    else
        if not IsUserExistingInDatabase(license) then
            InsertUserInDatabase(license)
            TriggerClientEvent("ccrwds:clList", _source, rewardsListForClients, 1, "", true)
        else
            DataManipulation(_source, license, rewardsListForClients)
        end
    end
end)

CreateThread(function()
    local definedServerDay = string.lower(os.date("%A"))
    while true do
        if definedServerDay ~= string.lower(os.date("%A")) then 
            definedServerDay = string.lower(os.date("%A"))
            for _, id in ipairs(GetPlayers()) do 
                local license = GetLicense(GetPlayerIdentifiers(id))
                DataManipulation(id, license, rewardsListForClients)
            end
        end
        Wait(20000)
    end
end)

RegisterNetEvent("scrwds:claimReward")
AddEventHandler("scrwds:claimReward", function(uniqueID) 
    local _source = source
    local license = GetLicense(GetPlayerIdentifiers(_source))
    local uData
    local dataPosition
    if Database.useJson then
        dataPosition = GetPositionInTable(license, playersDataJson)
    else
        uData = GetInformationsForUser(license)
    end

    local rewardPosition = 0
    for i = 1, #Rewards, 1 do 
        for k, v in pairs(Rewards[i]) do 
            if Rewards[i][k] == uniqueID then
                rewardPosition = i
                break
            end
        end
    end

    if Database.useJson then
        if playersDataJson[dataPosition].days >= Rewards[rewardPosition].Days then
            CheckRewards(_source, playersDataJson[dataPosition], dataPosition, uniqueID)
        else
            print("ID: ".._source.." is trying to exploit server event \"scrwds:claimReward\" from "..GetCurrentResourceName())
        end
    else
        if uData.days >= Rewards[rewardPosition].Days then
            CheckRewards(_source, uData, "notjson", uniqueID)
        else
            print("ID: ".._source.." is trying to exploit server event \"scrwds:claimReward\" from "..GetCurrentResourceName())
        end
    end
end)