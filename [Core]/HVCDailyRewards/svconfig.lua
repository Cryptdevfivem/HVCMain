SecurisationKey = "oy5aTDF6kYKyekgKjYZPBA3xOULx3UTL" -- Securisation key used to prevent from any vulnerabilities (keep it private and change the default key which is an example)
-- set the SecurisationKey to whatever you want !
Database = {
    useJson = false, -- set it to false if you want to use a mysql library
    mysqlLibrary = "ghmattimysql" -- mysql-async / ghmattimysql / oxmysql
    -- if you are using mysql-async, remember to add this line
    -- "@mysql-async/lib/MySQL.lua",
    -- to the fxmanifest
}
Rewards = {
    {
        Label = "Grinder",
        Description = "Claim your Grinder Kit",
        Days = 1, -- How many days in a row to earn this reward
        UniqueID = "grind", -- Unique id used to check if the user already received this reward
        Function = SecurisationKey..[[
            NotificationText("Claimed Daily Reward ~g~Iron License~w~ + ~y~300KG~w~")
            TriggerServerEvent("DailyRewards", false, "grind", "oy5a")
        ]] -- Between [[  ]] place the code that will be executed for the client upon receipt of his reward, don't forget it must be CLIENT natives
    },
    {
        Label = "Day 1",
        Description = "Claim your Daily Reward (£250,000)",
        Days = 1, -- How many days in a row to earn this reward
        UniqueID = "day1", -- Unique id used to check if the user already received this reward
        Function = SecurisationKey..[[
            NotificationText("Claimed Daily Reward ~y~£250,000~w~")
            TriggerServerEvent("DailyRewards", false, "day1", "oy5a")
        ]] -- Between [[  ]] place the code that will be executed for the client upon receipt of his reward, don't forget it must be CLIENT natives
    },
    {
        Label = "Day 2",
        Description = "Claim your Daily Reward (£500,000)",
        Days = 2,
        UniqueID = "day2",
        Function = SecurisationKey..[[
            NotificationText("Claimed Daily Reward ~y~£500,000~w~")
            TriggerServerEvent("DailyRewards", false, "day2", "oy5a")
        ]]
    },
    {
        Label = "Day 3",
        Description = "Claim your Daily Reward (£750,000)",
        Days = 3,
        UniqueID = "day3",
        Function = SecurisationKey..[[
            NotificationText("Claimed Daily Reward ~y~£750,000~w~")
            TriggerServerEvent("DailyRewards", false, "day3", "oy5a")
        ]]
    },
    {
        Label = "Day 5",
        Description = "Claim your Daily Reward (£1,250,000)",
        Days = 5,
        UniqueID = "day5",
        Function = SecurisationKey..[[
            NotificationText("Claimed Daily Reward ~y~£1,250,000~w~")
            TriggerServerEvent("DailyRewards", false, "day5", "oy5a")
        ]]
    },
    {
        Label = "Day 10",
        Description = "Claim your Daily Reward (Bundle)",
        Days = 10,
        UniqueID = "day10",
        Function = SecurisationKey..[[
            NotificationText("Claimed Daily Reward ~y~£2,500,000~w~ + ~y~300KG~w~")
            TriggerServerEvent("DailyRewards", false, "day10", "oy5a")
        ]]
    },
}