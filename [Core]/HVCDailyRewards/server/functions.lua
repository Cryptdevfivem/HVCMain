function GetLicense(userInformations)
    for i = 1, #userInformations, 1 do
        if string.sub(userInformations[i], 1, string.len("license:")) == "license:" then
            return userInformations[i]
        end
    end
end

function IsValueInTable(value, table)
    for k, v in pairs(table) do
        if type(v) == "table" then
            if IsValueInTable(value, v) then 
                return true
            end
        end

        if v == value then
            return true
        end
    end
    return false
end

function GetPositionInTable(value, table)
    for k, v in pairs(table) do
        if type(v) == "table" then
            if IsValueInTable(value, v) then
                return k
            end
        end

        if v == value then
            return k
        end
    end
    return -1
end

function IsValidDayDifferent(playerDay, time, serverDay)
    if playerDay ~= serverDay then
        if os.time(os.date("!*t")) - time < 172800 then
            if playerDay == "monday" and serverDay == "tuesday" then
                return "next"
            elseif playerDay == "tuesday" and serverDay == "wednesday" then
                return "next"
            elseif playerDay == "wednesday" and serverDay == "thursday" then
                return "next"
            elseif playerDay == "thursday" and serverDay == "friday" then
                return "next"
            elseif playerDay == "friday" and serverDay == "saturday" then
                return "next"
            elseif playerDay == "saturday" and serverDay == "sunday" then
                return "next"
            elseif playerDay == "sunday" and serverDay == "monday" then  
                return "next"
            end 
        end
    else
        if os.time(os.date("!*t")) - time < 172800 then
            return "same"
        end
    end
    return "diff"
end

function CheckRewards(player, playerData, position, uniqueID)
    for i = 1, #Rewards, 1 do
        if Rewards[i].UniqueID == uniqueID then
            local cancel = false
            if tostring(position) ~= "notjson" then
                for j = 1, #playerData.rewardsReceived, 1 do
                    if playerData.rewardsReceived[j] == uniqueID then 
                        cancel = true
                    end
                end
            else
                for _uniqueID in string.gmatch(playerData.rewardsReceived, '([^,]+)') do
                    if _uniqueID == uniqueID then 
                        print(_uniqueID.." already")
                        cancel = true
                    end
                end
            end

            if not cancel then
                if tostring(position) ~= "notjson" then
                    -- TriggerClientEvent("ccrwds:sendNotification", player, "You claimed ~y~"..Rewards[i].Label)
                    if position ~= -1 then
                        local rRewards = playerData.rewardsReceived
                        rRewards[#rRewards + 1] = uniqueID
                        
                        playersDataJson[position] = { 
                            _license = playerData._license,
                            days = playerData.days,
                            weekday =   playerData.weekday,
                            time = playerData.time,
                            rewardsReceived = rRewards
                        }
                        
                        SaveResourceFile(GetCurrentResourceName(), "./data/svplys.json", json.encode(playersDataJson, { indent = true }), -1)
                        playersDataJson = json.decode(LoadResourceFile(GetCurrentResourceName(), "./data/svplys.json"))
                    end
                    TriggerClientEvent("ccrwds:reward", player, Rewards[i].Function, SecurisationKey)
                else
                    -- TriggerClientEvent("ccrwds:sendNotification", player, "You claimed ~y~"..Rewards[i].Label)
                    local rRewards = playerData.rewardsReceived
                    if playerData.rewardsReceived == "" then
                        rRewards = uniqueID
                    else
                        rRewards = rRewards..","..uniqueID
                    end
                    
                    SetRewardsForUser(playerData.license, rRewards)

                    TriggerClientEvent("ccrwds:reward", player, Rewards[i].Function, SecurisationKey)
                end
            else
                TriggerClientEvent("ccrwds:sendNotification", player, "You have already claimed ~y~"..Rewards[i].Label)
            end
        end
    end
end

function DataManipulation(_source, license, rewardsListForClients)
    local response
    local uData
    local dataPosition
    if Database.useJson then
        dataPosition = GetPositionInTable(license, playersDataJson)
        response = IsValidDayDifferent(playersDataJson[dataPosition].weekday, playersDataJson[dataPosition].time, string.lower(os.date("%A")))
    else
        uData = GetInformationsForUser(license)
        response = IsValidDayDifferent(uData.weekday, uData.time, string.lower(os.date("%A")))
    end

    if response == "next" then
        if Database.useJson then
            playersDataJson[dataPosition] = { 
                _license = playersDataJson[dataPosition]._license, 
                days = playersDataJson[dataPosition].days + 1,
                weekday = string.lower(os.date("%A")),
                time = os.time(os.date("!*t")),
                rewardsReceived = playersDataJson[dataPosition].rewardsReceived
            }

            SaveResourceFile(GetCurrentResourceName(), "./data/svplys.json", json.encode(playersDataJson, { indent = true }), -1)
            playersDataJson = json.decode(LoadResourceFile(GetCurrentResourceName(), "./data/svplys.json"))
        else 
            SetDaysForUser(license, uData.days + 1)
        end
    else
        if response == "diff" then
            if Database.useJson then
                playersDataJson[dataPosition] = { 
                    _license = playersDataJson[dataPosition]._license, 
                    days = 1,
                    weekday = string.lower(os.date("%A")),
                    time = os.time(os.date("!*t")),
                    rewardsReceived = playersDataJson[dataPosition].rewardsReceived
                }

                SaveResourceFile(GetCurrentResourceName(), "./data/svplys.json", json.encode(playersDataJson, { indent = true }), -1)
                playersDataJson = json.decode(LoadResourceFile(GetCurrentResourceName(), "./data/svplys.json"))
            else
                SetDaysForUser(license, 1)
            end
        end
    end
    if Database.useJson then
        TriggerClientEvent("ccrwds:clList", _source, rewardsListForClients, playersDataJson[dataPosition].days, playersDataJson[dataPosition].rewardsReceived)
    else
        TriggerClientEvent("ccrwds:clList", _source, rewardsListForClients, uData.days, uData.rewardsReceived, true)
    end
end