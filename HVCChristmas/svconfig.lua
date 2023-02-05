SecurisationKey = "oy5aTDF6kYKyekgKjYZPBA3xOULx3UTL" -- Securisation key used to prevent from any vulnerabilities (keep it private and change the default key which is an example)
-- set the SecurisationKey to whatever you want !
Database = {
    useJson = true, -- set it to false if you want to use a mysql library
    mysqlLibrary = "mysql-async" -- mysql-async / ghmattimysql / oxmysql
    -- if you are using mysql-async, remember to add this line
    -- "@mysql-async/lib/MySQL.lua",
    -- to the fxmanifest
}
Rewards = {
    {
        Label = "Day 1",
        Description = "Play 1 consecutive day",
        Days = 1, -- How many days in a row to earn this reward
        UniqueID = "gift1", -- Unique id used to check if the user already received this reward
        Function = SecurisationKey..[[
            print("GIFT 1")
            TriggerServerEvent("cpt:givemoney", 500000, true, false, nil)   
        ]] -- Between [[  ]] place the code that will be executed for the client upon receipt of his reward, don't forget it must be CLIENT natives
    },
    {
        Label = "Day 2",
        Description = "Play 2 consecutive days",
        Days = 2,
        UniqueID = "gift2",
        Function = SecurisationKey..[[
            print("GIFT 2")
            TriggerServerEvent("cpt:givemoney", 750000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 3",
        Description = "Play 3 consecutive days",
        Days = 3,
        UniqueID = "gift3",
        Function = SecurisationKey..[[
            print("GIFT 3")
            TriggerServerEvent("cpt:givemoney", 1000000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 4",
        Description = "Play 4 consecutive days",
        Days = 4,
        UniqueID = "gift4",
        Function = SecurisationKey..[[
            print("GIFT 4")
            TriggerServerEvent("cpt:givemoney", 1250000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 5",
        Description = "Play 5 consecutive days",
        Days = 5,
        UniqueID = "gift5",
        Function = SecurisationKey..[[
            print("GIFT 5")
            TriggerServerEvent("cpt:givemoney", 1500000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 6",
        Description = "Play 6 consecutive days",
        Days = 6,
        UniqueID = "gift6",
        Function = SecurisationKey..[[
            print("GIFT 6")
            TriggerServerEvent("cpt:givemoney", 1750000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 7",
        Description = "Play 7 consecutive days",
        Days = 7,
        UniqueID = "gift7",
        Function = SecurisationKey..[[
            print("GIFT 7")
            TriggerServerEvent("cpt:givemoney", 2000000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 8",
        Description = "Play 8 consecutive days",
        Days = 8,
        UniqueID = "gift8",
        Function = SecurisationKey..[[
            print("GIFT 8")
            TriggerServerEvent("cpt:givemoney", 2250000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 9",
        Description = "Play 9 consecutive days",
        Days = 9,
        UniqueID = "gift9",
        Function = SecurisationKey..[[
            print("GIFT 9")
            TriggerServerEvent("cpt:givemoney", 2500000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 10",
        Description = "Play 10 consecutive days",
        Days = 10,
        UniqueID = "gift10",
        Function = SecurisationKey..[[
            print("GIFT 10")
            TriggerServerEvent("cpt:givemoney", 2750000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 11",
        Description = "Play 11 consecutive days",
        Days = 11,
        UniqueID = "gift11",
        Function = SecurisationKey..[[
            print("GIFT 11")
            TriggerServerEvent("cpt:givemoney", 3000000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 12",
        Description = "Play 12 consecutive days",
        Days = 12,
        UniqueID = "gift12",
        Function = SecurisationKey..[[
            print("GIFT 12")
            TriggerServerEvent("cpt:givemoney", 3250000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 13",
        Description = "Play 13 consecutive days",
        Days = 13,
        UniqueID = "gift13",
        Function = SecurisationKey..[[
            print("GIFT 13")
            TriggerServerEvent("cpt:givemoney", 3500000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 14",
        Description = "Play 14 consecutive days",
        Days = 14,
        UniqueID = "gift14",
        Function = SecurisationKey..[[
            print("GIFT 14")
            TriggerServerEvent("cpt:givemoney", 3750000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 15",
        Description = "Play 15 consecutive days",
        Days = 15,
        UniqueID = "gift15",
        Function = SecurisationKey..[[
            print("GIFT 15")
            TriggerServerEvent("cpt:givemoney", 4000000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 16",
        Description = "Play 16 consecutive days",
        Days = 16,
        UniqueID = "gift16",
        Function = SecurisationKey..[[
            print("GIFT 16")
            TriggerServerEvent("cpt:givemoney", 4250000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 17",
        Description = "Play 17 consecutive days",
        Days = 17,
        UniqueID = "gift17",
        Function = SecurisationKey..[[
            print("GIFT 17")
            TriggerServerEvent("cpt:givemoney", 4500000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 18",
        Description = "Play 18 consecutive days",
        Days = 18,
        UniqueID = "gift18",
        Function = SecurisationKey..[[
            print("GIFT 18")
            TriggerServerEvent("cpt:givemoney", 4750000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 19",
        Description = "Play 19 consecutive days",
        Days = 19,
        UniqueID = "gift19",
        Function = SecurisationKey..[[
            print("GIFT 19")
            TriggerServerEvent("cpt:givemoney", 5000000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 20",
        Description = "Play 20 consecutive days",
        Days = 20,
        UniqueID = "gift20",
        Function = SecurisationKey..[[
            print("GIFT 20")
            TriggerServerEvent("cpt:givemoney", 5500000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 21",
        Description = "Play 21 consecutive days",
        Days = 21,
        UniqueID = "gift21",
        Function = SecurisationKey..[[
            print("GIFT 21")
            TriggerServerEvent("cpt:givemoney", 6000000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 22",
        Description = "Play 22 consecutive days",
        Days = 22,
        UniqueID = "gift22",
        Function = SecurisationKey..[[
            print("GIFT 22")
            TriggerServerEvent("cpt:givemoney", 6500000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 23",
        Description = "Play 23 consecutive days",
        Days = 23,
        UniqueID = "gift23",
        Function = SecurisationKey..[[
            print("GIFT 23")
            TriggerServerEvent("cpt:givemoney", 7000000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 24",
        Description = "Play 24 consecutive days",
        Days = 24,
        UniqueID = "gift24",
        Function = SecurisationKey..[[
            print("GIFT 24")
            TriggerServerEvent("cpt:givemoney", 8500000, true, false, nil)   
        ]]
    },
    {
        Label = "Day 25",
        Description = "Play 25 consecutive days & Make a ticket in our support Discord for your christmas lock!",
        Days = 25,
        UniqueID = "gift25",
        Function = SecurisationKey..[[
            print("GIFT 25 & MAKE A TICKET ON SUPPORT DISCORD FOR CHRISTMAS LOCK")
            NotificationText("Make a ticket on support Discord for the Christmas Lock")
            TriggerServerEvent("cpt:givemoney", 10000000, true, false, nil)   
        ]]
    },
}