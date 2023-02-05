function IsUserExistingInDatabase(license)
    local _result = false
    local ended = false

    if Database.mysqlLibrary == "mysql-async" then
        MySQL.Async.fetchAll("SELECT license FROM user_rewards WHERE license = @license",
        {
            ["@license"] = license
        }, function(result)
            if result[1] ~= nil then
                _result = true
            end

            ended = true
        end)
    elseif Database.mysqlLibrary == "ghmattimysql" then
        exports.ghmattimysql:execute("SELECT license FROM user_rewards WHERE license = @license",
        {
            ["@license"] = license
        }, function(result)
            if result[1] ~= nil then
                _result = true
            end

            ended = true
        end)
    elseif Database.mysqlLibrary == "oxmysql" then
        exports.oxmysql:execute("SELECT license FROM user_rewards WHERE license = @license",
        {
            ["@license"] = license
        }, function(result)
            if result[1] ~= nil then
                _result = true
            end

            ended = true
        end)
    else
        print("Database.mysqlLibrary is not valid")
    end

    while not ended do 
        Wait(5) 
    end

    return _result
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

function InsertUserInDatabase(license)
    if Database.mysqlLibrary == "mysql-async" then
        MySQL.Sync.execute("INSERT INTO user_rewards (license, days, time, rewardsReceived, weekday) VALUES(@license, @days, @time, @rewardsReceived, @weekday)", 
        {
            ["@license"] = license,
            ["@days"] = 1,
            ["@time"] = os.time(os.date("!*t")),
            ["@rewardsReceived"] = "",
            ["@weekday"] = string.lower(os.date("%A"))
        })
    elseif Database.mysqlLibrary == "ghmattimysql" then
        exports.ghmattimysql:execute("INSERT INTO user_rewards (license, days, time, rewardsReceived, weekday) VALUES(@license, @days, @time, @rewardsReceived, @weekday)", 
        {
            ["@license"] = license,
            ["@days"] = 1,
            ["@time"] = os.time(os.date("!*t")),
            ["@rewardsReceived"] = "",
            ["@weekday"] = string.lower(os.date("%A"))
        })
    elseif Database.mysqlLibrary == "oxmysql" then
        exports.ghmattimysql:execute("INSERT INTO user_rewards (license, days, time, rewardsReceived, weekday) VALUES(@license, @days, @time, @rewardsReceived, @weekday)", 
        {
            ["@license"] = license,
            ["@days"] = 1,
            ["@time"] = os.time(os.date("!*t")),
            ["@rewardsReceived"] = "",
            ["@weekday"] = string.lower(os.date("%A"))
        })
    else
        print("Database.mysqlLibrary is not valid")
    end
end

function GetInformationsForUser(license)
    local ended = false
    local data = {}
    if Database.mysqlLibrary == "mysql-async" then
        MySQL.Async.fetchAll("SELECT * FROM user_rewards WHERE license = @license",
        {
            ["@license"] = license
        }, function(result)
            if result[1] ~= nil then

                data = {
                    license = result[1].license,
                    weekday = result[1].weekday,
                    days = result[1].days,
                    time = result[1].time,
                    rewardsReceived = result[1].rewardsReceived
                }
            end
            ended = true
        end)
    elseif Database.mysqlLibrary == "ghmattimysql" then
        exports.ghmattimysql:execute("SELECT * FROM user_rewards WHERE license = @license",
        {
            ["@license"] = license
        }, function(result)
            if result[1] ~= nil then
                data = {
                    license = result[1].license,
                    weekday = result[1].weekday,
                    days = result[1].days,
                    time = result[1].time,
                    rewardsReceived = result[1].rewardsReceived
                }
            end
            ended = true
        end)
    elseif Database.mysqlLibrary == "oxmysql" then
        exports.oxmysql:execute("SELECT * FROM user_rewards WHERE license = @license",
        {
            ["@license"] = license
        }, function(result)
            if result[1] ~= nil then
                data = {
                    license = result[1].license,
                    weekday = result[1].weekday,
                    days = result[1].days,
                    time = result[1].time,
                    rewardsReceived = result[1].rewardsReceived
                }
            end
            ended = true
        end)
    else
        print("Database.mysqlLibrary is not valid")
    end

    while not ended do Wait(5) end
    return data
end

function SetDaysForUser(license, days)
    if Database.mysqlLibrary == "mysql-async" then
        MySQL.Sync.execute("UPDATE user_rewards SET days = @days, time = @time, weekday = @weekday WHERE license = @license", 
        {
            ["@license"] = license,
            ["@days"] = days,
            ["@time"] = os.time(os.date("!*t")),
            ["@weekday"] = string.lower(os.date("%A"))
        })
    elseif Database.mysqlLibrary == "ghmattimysql" then
        exports.ghmattimysql:execute("UPDATE user_rewards SET days = @days, time = @time, weekday = @weekday WHERE license = @license", 
        {
            ["@license"] = license,
            ["@days"] = days,
            ["@time"] = os.time(os.date("!*t")),
            ["@weekday"] = string.lower(os.date("%A"))
        })
    elseif Database.mysqlLibrary == "oxmysql" then
        exports.ghmattimysql:execute("UPDATE user_rewards SET days = @days, time = @time, weekday = @weekday WHERE license = @license", 
        {
            ["@license"] = license,
            ["@days"] = days,
            ["@time"] = os.time(os.date("!*t")),
            ["@weekday"] = string.lower(os.date("%A"))
        })
    else
        print("Database.mysqlLibrary is not valid")
    end
end

function SetRewardsForUser(license, newRewards)
    if Database.mysqlLibrary == "mysql-async" then
        MySQL.Sync.execute("UPDATE user_rewards SET rewardsReceived = @rewards WHERE license = @license", 
        {
            ["@license"] = license,
            ["@rewards"] = newRewards
        })
    elseif Database.mysqlLibrary == "ghmattimysql" then
        exports.ghmattimysql:execute("UPDATE user_rewards SET rewardsReceived = @rewards WHERE license = @license", 
        {
            ["@license"] = license,
            ["@rewards"] = newRewards
        })
    elseif Database.mysqlLibrary == "oxmysql" then
        exports.ghmattimysql:execute("UPDATE user_rewards SET rewardsReceived = @rewards WHERE license = @license", 
        {
            ["@license"] = license,
            ["@rewards"] = newRewards
        })
    else
        print("Database.mysqlLibrary is not valid")
    end
end