local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVC_TebexPayments")


function addmoney(_, args)
    local permid = args[1]
    local packageid = args[2]
    local price = args[3]
    local transactionid = args[4]
    local packagename = args[5] .. " " .. args[6] .. " " .. args[7]
    local allplayers = GetPlayers() 

    for _, ids in pairs(allplayers) do
        if HVC.getUserId({ids}) == tonumber(permid) then
            print("Player Names: " ..GetPlayerName(ids))
            print("TempID: " ..ids)
            print("PermID: " ..HVC.getUserId({ids}))
            print("Entered PermID: " ..permid)
            print(HVC.getUserId({ids}) == tonumber(permid))
            HVCclient.notify(ids, {"~g~Thankyou for donating to HVC. Your money bag has been added."})
            print()
            print("----------------------------------------------------------------------")

            local logs = "https://canary.discord.com/api/webhooks/887423418536951839/aJxtCuNtY8I1iduLBYnSaHB5-QYqm7x7L7Bo3iOznDDmR6-McQo6-FmuMdCX2k7xNfJH" -- Main Discord | HVC
            local communityname = "HVC Tebex Logs"
            local communtiylogo = "" --Must end with .png or .jpg

            local command = {
                {
                    ["fields"] = {
                        {
                            ["name"] = "**Player Name**",
                            ["value"] = "" ..GetPlayerName(ids),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Player TempID**",
                            ["value"] = "" ..ids,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Player PermID**",
                            ["value"] = "" ..HVC.getUserId({ids}),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Package Name**",
                            ["value"] = "" .. packagename,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Tebex Donation ID**",
                            ["value"] = "" ..transactionid,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Tebex Package Name**",
                            ["value"] = "" ..packagename,
                            ["inline"] = true
                        },
                    },
                    ["color"] = "15536128",
                    ["title"] = GetPlayerName(ids).." Has Donated",
                    ["description"] = "",
                    ["footer"] = {
                    ["text"] = communityname,
                    ["icon_url"] = communtiylogo,
                    },
                }
            }
            if packagename == "£1,000,000 Money Bag" then
                HVC.giveBankMoney({HVC.getUserId({ids}), 1000000})
            elseif packagename == "£2,500,000 Money Bag" then
                HVC.giveBankMoney({HVC.getUserId({ids}), 2500000})
            elseif packagename == "£5,000,000 Money Bag" then
                HVC.giveBankMoney({HVC.getUserId({ids}), 5000000})
            elseif packagename == "£10,000,000 Money Bag" then
                HVC.giveBankMoney({HVC.getUserId({ids}), 10000000})
            elseif packagename == "£20,000,000 Money Bag" then
                HVC.giveBankMoney({HVC.getUserId({ids}), 20000000})
            elseif packagename == "£50,000,000 Money Bag" then
                HVC.giveBankMoney({HVC.getUserId({ids}), 50000000})
            end
            PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Tebex Logs", embeds = command}), { ['Content-Type'] = 'application/json'})
        else
            exports["ghmattimysql"]:execute("SELECT bank FROM hvc_user_moneys WHERE user_id = @user_id", {user_id = permid}, function(Result)
                local Bank = Result
                if packagename == "£1,000,000 Money Bag" then
                    HVC.giveBankMoney({HVC.getUserId({ids}), 1000000})
                elseif packagename == "£2,500,000 Money Bag" then
                    HVC.giveBankMoney({HVC.getUserId({ids}), 2500000})
                elseif packagename == "£5,000,000 Money Bag" then
                    HVC.giveBankMoney({HVC.getUserId({ids}), 5000000})
                elseif packagename == "£10,000,000 Money Bag" then
                    HVC.giveBankMoney({HVC.getUserId({ids}), 10000000})
                elseif packagename == "£20,000,000 Money Bag" then
                    HVC.giveBankMoney({HVC.getUserId({ids}), 20000000})
                elseif packagename == "£50,000,000 Money Bag" then
                    HVC.giveBankMoney({HVC.getUserId({ids}), 50000000})
                end
        end
        --TriggerClientEvent("chatMessage", -1, "^1^*[HVC]", {180, 0, 0}, " ^7 Users Found: "..GetPlayerName(ids))
    end
end

RegisterCommand('addmoney', addmoney, false)

























all = {
    {name = "Audi A7", price = 700000, spawncode = "a7", bootsize = 30},
    {name = "Porshe 992-C", price = 700000, spawncode = "992c", bootsize = 30},
    {name = "Audi Q7", price = 850000, spawncode = "audiq7", bootsize = 50},
    {name = "Aventador j", price = 700000, spawncode = "aventadorj", bootsize = 30},
    {name = "CBR 600", price = 700000, spawncode = "cbr600", bootsize = 30},
    {name = "Dodge SRT", price = 700000, spawncode = "chargerdemon", bootsize = 30},
    {name = "Mansory Cyrus", price = 700000, spawncode = "cyrus", bootsize = 30},
    {name = "Ferrari 430", price = 700000, spawncode = "f430scuderia", bootsize = 30},
    {name = "Subaru Impreza 2019", price = 700000, spawncode = "impreza2019", bootsize = 30},
    {name = "M977L", price = 2000000, spawncode = "M977L", bootsize = 200},
    {name = "M977T", price = 2000000, spawncode = "M977T", bootsize = 200},
    {name = "Pakunek", price = 1000000, spawncode = "pakunek", bootsize = 100},
    {name = "Rolls Royce", price = 700000, spawncode = "silver67", bootsize = 30},
    {name = "Silvia", price = 700000, spawncode = "silvia", bootsize = 30},
    {name = "BMW Z4", price = 700000, spawncode = "z4alchemist", bootsize = 30},
    {name = "Zetro", price = 2000000, spawncode = "zetro", bootsize = 200},
}








function addprimetouser(_, args)
    local permid = args[1]
    local packagename = args[2] .. " " .. args[3]
    local Car = args[4]
    local selectedcar = nil
    local selectedcarname = nil
    local allplayers = GetPlayers()

    if Car then
        for i , p in pairs(all) do 
            if p.spawncode == Car then
                selectedcar = p.spawncode
                selectedcarname = p.name
                print(selectedcar)
                print(selectedcarname)
            end
        end
    else
        selectedcar = "NULL"
        selectedcarname = "NULL"
    end

    for _, ids in pairs(allplayers) do
        if HVC.getUserId({ids}) == tonumber(permid) then
            print(json.encode(allplayers))
            print("Player Names: " ..GetPlayerName(ids))
            print("TempID: " ..ids)
            print("PermID: " ..HVC.getUserId({ids}))
            print("Package Name: " ..packagename)
            print("Entered PermID: " ..permid)
            print("Selected Car Spawn Code: " ..selectedcar)
            print(HVC.getUserId({ids}) == tonumber(permid))
            print()
            print("----------------------------------------------------------------------")

            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

            local logs = "https://canary.discord.com/api/webhooks/887778942067560458/FUwr1KZy4g7OHUdKTjOPo4DZhJCFfSFLkzdJv34y3ESoIadR14Q8Xl8mhagw9Ggs21Xa"
            if packagename == "Prime Rank" then
                local command = {
                    {
                        ["fields"] = {
                            {
                                ["name"] = "**Player Name**",
                                ["value"] = "" ..GetPlayerName(ids),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player TempID**",
                                ["value"] = "" ..ids,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player PermID**",
                                ["value"] = "" ..HVC.getUserId({ids}),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Package Name**",
                                ["value"] = "" .. packagename,
                                ["inline"] = true
                            },
                            --{
                               -- ["name"] = "**Tebex Donation ID**",
                                --["value"] = "" ..transactionid,
                                --["inline"] = true
                            --},
                            {
                                ["name"] = "**Selected Car**",
                                ["value"] = "" ..selectedcarname,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Money Amount**",
                                ["value"] = "£500,000",
                                ["inline"] = true
                            },
                        },
                        ["color"] = "15536128",
                        ["title"] = GetPlayerName(ids).." Has Donated",
                        ["description"] = "**Added Perks**\n```\n++ Prime Rank\n++ ".. selectedcarname .."\n++ Access To VIP Island\n++ Access To VIP Garages\n++ Access To VIP Helipad\n```",
                        ["footer"] = {
                        ["text"] = communityname,
                        ["icon_url"] = communtiylogo,
                        },
                    }
                }


                PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Tebex Logs", embeds = command}), { ['Content-Type'] = 'application/json'})


                ------------- Add everything

                HVCclient.notify(ids, {"~g~Thankyou for donating to HVC.\nItems Added:\n- Prime Rank\n- £500,000\n- "..selectedcarname})
                HVCclient.notify(ids, {"~g~- Access To VIP Island\n- Access To VIP Garages\n- Access To VIP Helipad"})
                
                HVC.addUserGroup({HVC.getUserId({ids}), "prime"})
                HVC.giveBankMoney({HVC.getUserId({ids}), 500000})

                exports['ghmattimysql']:execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {user_id = HVC.getUserId({ids}), vehicle = selectedcar}, function() end)
            end
        end
        

        ----TriggerClientEvent("chatMessage", -1, "^1^*[HVC]", {180, 0, 0}, " ^7 Users Found: "..GetPlayerName(ids))

    end

    
end

RegisterCommand('addprimetouser', addprimetouser, true)












function addelitetouser(_, args)
    local permid = args[1]
    local packagename = args[2] .. " " .. args[3]
    local Car = args[4]
    local Car2 = args[5]
    local allplayers = GetPlayers()

    --------------------------------------------------------------------------------------

    local selectedcar = nil
    local selectedcarname = nil

    local selectedcar2 = nil
    local selectedcarname2 = nil


    if Car then
        for i , p in pairs(all) do 
            if p.spawncode == Car then
                selectedcar = p.spawncode
                selectedcarname = p.name
                print(selectedcar)
                print(selectedcarname)
            end
        end
    else
        selectedcar = "NULL"
        selectedcarname = "NULL"
    end


    if Car2 then
        for i , p in pairs(all) do 
            if p.spawncode == Car2 then
                selectedcar2 = p.spawncode
                selectedcarname2 = p.name
                print(selectedcar2)
                print(selectedcarname2)
            end
        end
    else
        selectedcar2 = "NULL"
        selectedcarname2 = "NULL"
    end

    --------------------------------------------------------------------------------------

    for _, ids in pairs(allplayers) do
        if HVC.getUserId({ids}) == tonumber(permid) then
            print(json.encode(allplayers))
            print("Player Names: " ..GetPlayerName(ids))
            print("TempID: " ..ids)
            print("PermID: " ..HVC.getUserId({ids}))
            print("Entered PermID: " ..permid)
            print("Package Name: " ..packagename)
            print("Selected Car Spawn Code: " ..selectedcar)
            print("Selected Car2 Spawn Code: " ..selectedcar2)
            print(HVC.getUserId({ids}) == tonumber(permid))
            print()
            print("----------------------------------------------------------------------")

            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

            local logs = "https://canary.discord.com/api/webhooks/887778942067560458/FUwr1KZy4g7OHUdKTjOPo4DZhJCFfSFLkzdJv34y3ESoIadR14Q8Xl8mhagw9Ggs21Xa"
            if packagename == "Elite Rank" then
                local command = {
                    {
                        ["fields"] = {
                            {
                                ["name"] = "**Player Name**",
                                ["value"] = "" ..GetPlayerName(ids),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player TempID**",
                                ["value"] = "" ..ids,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player PermID**",
                                ["value"] = "" ..HVC.getUserId({ids}),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Package Name**",
                                ["value"] = "" .. packagename,
                                ["inline"] = true
                            },
                            --{
                               -- ["name"] = "**Tebex Donation ID**",
                                --["value"] = "" ..transactionid,
                                --["inline"] = true
                            --},
                            {
                                ["name"] = "**Selected Car (1)**",
                                ["value"] = "" ..selectedcarname,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Selected Car (2)**",
                                ["value"] = "" ..selectedcarname2,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Money Amount**",
                                ["value"] = "£2,500,000",
                                ["inline"] = true
                            },
                        },
                        ["color"] = "15536128",
                        ["title"] = GetPlayerName(ids).." Has Donated",
                        ["description"] = "**Added Perks**\n```\n++ Elite Rank\n++ ".. selectedcarname .."\n++" .. selectedcarname2.. "\n++ Access To VIP Island\n++ Access To VIP Garages\n++ Access To VIP Helipad\n```",
                        ["footer"] = {
                        ["text"] = communityname,
                        ["icon_url"] = communtiylogo,
                        },
                    }
                }


                PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Tebex Logs", embeds = command}), { ['Content-Type'] = 'application/json'})


                ------------- Add everything

                HVCclient.notify(ids, {"~g~Thankyou for donating to HVC.\nItems added:\n- Elite Rank\n- £2,500,000\n- " ..selectedcarname.. "\n- VIP Access"})
                HVC.addUserGroup({HVC.getUserId({ids}), "eilte"})
                HVC.giveBankMoney({HVC.getUserId({ids}), 2500000})

                --------------------------------------------------------------------------------------

                exports['ghmattimysql']:execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {user_id = HVC.getUserId({ids}), vehicle = selectedcar}, function() end)
                exports['ghmattimysql']:execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {user_id = HVC.getUserId({ids}), vehicle = selectedcar2}, function() end)
            end
        end

        ----TriggerClientEvent("chatMessage", -1, "^1^*[HVC]", {180, 0, 0}, " ^7 Users Found: "..GetPlayerName(ids))

    end

    
end

RegisterCommand('addelitetouser', addelitetouser, true)












function addchieftouser(_, args)
    local permid = args[1]
    local packagename = args[2] .. " " .. args[3]
    local Car = args[4]
    local Car2 = args[5]
    local allplayers = GetPlayers()

    --------------------------------------------------------------------------------------

    local selectedcar = nil
    local selectedcarname = nil

    local selectedcar2 = nil
    local selectedcarname2 = nil


    if Car then
        for i , p in pairs(all) do 
            if p.spawncode == Car then
                selectedcar = p.spawncode
                selectedcarname = p.name
                print(selectedcar)
                print(selectedcarname)
            end
        end
    else
        selectedcar = "NULL"
        selectedcarname = "NULL"
    end


    if Car2 then
        for i , p in pairs(all) do 
            if p.spawncode == Car2 then
                selectedcar2 = p.spawncode
                selectedcarname2 = p.name
                print(selectedcar2)
                print(selectedcarname2)
            end
        end
    else
        selectedcar2 = "NULL"
        selectedcarname2 = "NULL"
    end

    --------------------------------------------------------------------------------------

    for _, ids in pairs(allplayers) do
        if HVC.getUserId({ids}) == tonumber(permid) then
            print(json.encode(allplayers))
            print("Player Names: " ..GetPlayerName(ids))
            print("TempID: " ..ids)
            print("PermID: " ..HVC.getUserId({ids}))
            print("Entered PermID: " ..permid)
            print("Package Name: " ..packagename)
            print("Selected Car Spawn Code: " ..selectedcar)
            print("Selected Car2 Spawn Code: " ..selectedcar2)
            print(HVC.getUserId({ids}) == tonumber(permid))
            print()
            print("----------------------------------------------------------------------")

            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

            local logs = "https://canary.discord.com/api/webhooks/887778942067560458/FUwr1KZy4g7OHUdKTjOPo4DZhJCFfSFLkzdJv34y3ESoIadR14Q8Xl8mhagw9Ggs21Xa"
            if packagename == "Chief Rank" then
                local command = {
                    {
                        ["fields"] = {
                            {
                                ["name"] = "**Player Name**",
                                ["value"] = "" ..GetPlayerName(ids),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player TempID**",
                                ["value"] = "" ..ids,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player PermID**",
                                ["value"] = "" ..HVC.getUserId({ids}),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Package Name**",
                                ["value"] = "" .. packagename,
                                ["inline"] = true
                            },
                            --{
                               -- ["name"] = "**Tebex Donation ID**",
                                --["value"] = "" ..transactionid,
                                --["inline"] = true
                            --},
                            {
                                ["name"] = "**Selected Car (1)**",
                                ["value"] = "" ..selectedcarname,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Selected Car (2)**",
                                ["value"] = "" ..selectedcarname2,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Money Amount**",
                                ["value"] = "£5,000,000",
                                ["inline"] = true
                            },
                        },
                        ["color"] = "15536128",
                        ["title"] = GetPlayerName(ids).." Has Donated",
                        ["description"] = "**Added Perks**\n```\n++ Chief Rank\n++ ".. selectedcarname .."\n++" .. selectedcarname2.. "\n++ Access To VIP Island\n++ Access To VIP Garages\n++ Access To VIP Helipad\n```",
                        ["footer"] = {
                        ["text"] = communityname,
                        ["icon_url"] = communtiylogo,
                        },
                    }
                }


                PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Tebex Logs", embeds = command}), { ['Content-Type'] = 'application/json'})


                ------------- Add everything

                HVCclient.notify(ids, {"~g~Thankyou for donating to HVC.\nItems Added:\n- Chief Rank\n- £5,000,000\n- " ..selectedcarname.. "\n- VIP Access"})
                HVC.addUserGroup({HVC.getUserId({ids}), "eilte"})
                HVC.giveBankMoney({HVC.getUserId({ids}), 5000000})

                --------------------------------------------------------------------------------------

                exports['ghmattimysql']:execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {user_id = HVC.getUserId({ids}), vehicle = selectedcar}, function() end)
                exports['ghmattimysql']:execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {user_id = HVC.getUserId({ids}), vehicle = selectedcar2}, function() end)
            end
        end

        ----TriggerClientEvent("chatMessage", -1, "^1^*[HVC]", {180, 0, 0}, " ^7 Users Found: "..GetPlayerName(ids))

    end

    
end

RegisterCommand('addchieftouser', addchieftouser, true)


















function addlegendtouser(_, args)
    local permid = args[1]
    local packagename = args[2] .. " " .. args[3]
    local Car = args[4]
    local Car2 = args[5]
    local Car3 = args[6]
    local allplayers = GetPlayers()

    --------------------------------------------------------------------------------------

    local selectedcar = nil
    local selectedcarname = nil

    local selectedcar2 = nil
    local selectedcarname2 = nil

    local selectedcar3 = nil
    local selectedcarname3 = nil


    if Car then
        for i , p in pairs(all) do 
            if p.spawncode == Car then
                selectedcar = p.spawncode
                selectedcarname = p.name
                print(selectedcar)
                print(selectedcarname)
            end
        end
    else
        selectedcar = "NULL"
        selectedcarname = "NULL"
    end


    if Car2 then
        for i , p in pairs(all) do 
            if p.spawncode == Car2 then
                selectedcar2 = p.spawncode
                selectedcarname2 = p.name
                print(selectedcar2)
                print(selectedcarname2)
            end
        end
    else
        selectedcar2 = "NULL"
        selectedcarname2 = "NULL"
    end

    if Car3 then
        for i , p in pairs(all) do 
            if p.spawncode == Car3 then
                selectedcar3 = p.spawncode
                selectedcarname3 = p.name
                print(selectedcar3)
                print(selectedcarname3)
            end
        end
    else
        selectedcar3 = "NULL"
        selectedcarname3 = "NULL"
    end

    --------------------------------------------------------------------------------------

    for _, ids in pairs(allplayers) do
        if HVC.getUserId({ids}) == tonumber(permid) then
            print(json.encode(allplayers))
            print("Player Names: " ..GetPlayerName(ids))
            print("TempID: " ..ids)
            print("PermID: " ..HVC.getUserId({ids}))
            print("Entered PermID: " ..permid)
            print("Package Name: " ..packagename)
            print("Selected Car Spawn Code: " ..selectedcar)
            print("Selected Car2 Spawn Code: " ..selectedcar2)
            print("Selected Car3 Spawn Code: " ..selectedcar3)
            print(HVC.getUserId({ids}) == tonumber(permid))
            print()
            print("----------------------------------------------------------------------")

            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

            local logs = "https://canary.discord.com/api/webhooks/887778942067560458/FUwr1KZy4g7OHUdKTjOPo4DZhJCFfSFLkzdJv34y3ESoIadR14Q8Xl8mhagw9Ggs21Xa"
            if packagename == "Legend Rank" then
                local command = {
                    {
                        ["fields"] = {
                            {
                                ["name"] = "**Player Name**",
                                ["value"] = "" ..GetPlayerName(ids),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player TempID**",
                                ["value"] = "" ..ids,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player PermID**",
                                ["value"] = "" ..HVC.getUserId({ids}),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Package Name**",
                                ["value"] = "" .. packagename,
                                ["inline"] = true
                            },
                            --{
                               -- ["name"] = "**Tebex Donation ID**",
                                --["value"] = "" ..transactionid,
                                --["inline"] = true
                            --},
                            {
                                ["name"] = "**Selected Car (1)**",
                                ["value"] = "" ..selectedcarname,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Selected Car (2)**",
                                ["value"] = "" ..selectedcarname2,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Selected Car (3)**",
                                ["value"] = "" ..selectedcarname3,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Money Amount**",
                                ["value"] = "£10,000,000",
                                ["inline"] = true
                            },
                        },
                        ["color"] = "15536128",
                        ["title"] = GetPlayerName(ids).." Has Donated",
                        ["description"] = "**Added Perks**\n```\n++ Legend Rank\n++ ".. selectedcarname .."\n++" .. selectedcarname2.. "\n++" .. selectedcarname3.. "\n++ Access To VIP Island\n++ Access To VIP Garages\n++ Access To VIP Helipad\n```",
                        ["footer"] = {
                        ["text"] = communityname,
                        ["icon_url"] = communtiylogo,
                        },
                    }
                }


                PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Tebex Logs", embeds = command}), { ['Content-Type'] = 'application/json'})


                ------------- Add everything

                HVCclient.notify(ids, {"~g~Thankyou for donating to HVC.\nItems Added:\n- Legend Rank\n- £10,000,000\n- " ..selectedcarname.. "\n- VIP Access"})
                HVC.addUserGroup({HVC.getUserId({ids}), "legend"})
                HVC.giveBankMoney({HVC.getUserId({ids}), 10000000})

                --------------------------------------------------------------------------------------

                exports['ghmattimysql']:execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {user_id = HVC.getUserId({ids}), vehicle = selectedcar}, function() end)
                exports['ghmattimysql']:execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {user_id = HVC.getUserId({ids}), vehicle = selectedcar2}, function() end)
                exports['ghmattimysql']:execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {user_id = HVC.getUserId({ids}), vehicle = selectedcar3}, function() end)
            end
        end

        ----TriggerClientEvent("chatMessage", -1, "^1^*[HVC]", {180, 0, 0}, " ^7 Users Found: "..GetPlayerName(ids))

    end

    
end

RegisterCommand('addlegendtouser', addlegendtouser, true)





















function addchampiontouser(_, args)
    local permid = args[1]
    local packagename = args[2] .. " " .. args[3]
    local Car = args[4]
    local Car2 = args[5]
    local Car3 = args[6]
    local Car4 = args[7]
    local allplayers = GetPlayers()

    --------------------------------------------------------------------------------------

    local selectedcar = nil
    local selectedcarname = nil

    local selectedcar2 = nil
    local selectedcarname2 = nil

    local selectedcar3 = nil
    local selectedcarname3 = nil

    local selectedcar4 = nil
    local selectedcarname4 = nil


    if Car then
        for i , p in pairs(all) do 
            if p.spawncode == Car then
                selectedcar = p.spawncode
                selectedcarname = p.name
                print(selectedcar)
                print(selectedcarname)
            end
        end
    else
        selectedcar = "NULL"
        selectedcarname = "NULL"
    end


    if Car2 then
        for i , p in pairs(all) do 
            if p.spawncode == Car2 then
                selectedcar2 = p.spawncode
                selectedcarname2 = p.name
                print(selectedcar2)
                print(selectedcarname2)
            end
        end
    else
        selectedcar2 = "NULL"
        selectedcarname2 = "NULL"
    end

    if Car3 then
        for i , p in pairs(all) do 
            if p.spawncode == Car3 then
                selectedcar3 = p.spawncode
                selectedcarname3 = p.name
                print(selectedcar3)
                print(selectedcarname3)
            end
        end
    else
        selectedcar3 = "NULL"
        selectedcarname3 = "NULL"
    end

    if Car4 then
        for i , p in pairs(all) do 
            if p.spawncode == Car4 then
                selectedcar4 = p.spawncode
                selectedcarname4 = p.name
                print(selectedcar4)
                print(selectedcarname4)
            end
        end
    else
        selectedcar4 = "NULL"
        selectedcarname4 = "NULL"
    end 

    --------------------------------------------------------------------------------------

    for _, ids in pairs(allplayers) do
        if HVC.getUserId({ids}) == tonumber(permid) then
            print(json.encode(allplayers))
            print("Player Names: " ..GetPlayerName(ids))
            print("TempID: " ..ids)
            print("PermID: " ..HVC.getUserId({ids}))
            print("Entered PermID: " ..permid)
            print("Package Name: " ..packagename)
            print("Selected Car Spawn Code: " ..selectedcar)
            print("Selected Car2 Spawn Code: " ..selectedcar2)
            print("Selected Car3 Spawn Code: " ..selectedcar3)
            print("Selected Car4 Spawn Code: " ..selectedcar4)
            print(HVC.getUserId({ids}) == tonumber(permid))
            print()
            print("----------------------------------------------------------------------")

            -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

            local logs = "https://canary.discord.com/api/webhooks/887778942067560458/FUwr1KZy4g7OHUdKTjOPo4DZhJCFfSFLkzdJv34y3ESoIadR14Q8Xl8mhagw9Ggs21Xa"
            if packagename == "Champion Rank" then
                local command = {
                    {
                        ["fields"] = {
                            {
                                ["name"] = "**Player Name**",
                                ["value"] = "" ..GetPlayerName(ids),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player TempID**",
                                ["value"] = "" ..ids,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player PermID**",
                                ["value"] = "" ..HVC.getUserId({ids}),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Package Name**",
                                ["value"] = "" .. packagename,
                                ["inline"] = true
                            },
                            --{
                               -- ["name"] = "**Tebex Donation ID**",
                                --["value"] = "" ..transactionid,
                                --["inline"] = true
                            --},
                            {
                                ["name"] = "**Selected Car (1)**",
                                ["value"] = "" ..selectedcarname,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Selected Car (2)**",
                                ["value"] = "" ..selectedcarname2,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Selected Car (3)**",
                                ["value"] = "" ..selectedcarname3,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Selected Car (4)**",
                                ["value"] = "" ..selectedcarname4,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Money Amount**",
                                ["value"] = "£20,000,000",
                                ["inline"] = true
                            },
                        },
                        ["color"] = "15536128",
                        ["title"] = GetPlayerName(ids).." Has Donated",
                        ["description"] = "**Added Perks**\n```\n++ Champion Rank\n++ ".. selectedcarname .."\n++ " .. selectedcarname2.. "\n++ " .. selectedcarname3.. "\n++ " .. selectedcarname4.. "\n++ Access To VIP Island\n++ Access To VIP Garages\n++ Access To VIP Helipad\n```",
                        ["footer"] = {
                        ["text"] = communityname,
                        ["icon_url"] = communtiylogo,
                        },
                    }
                }


                PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Tebex Logs", embeds = command}), { ['Content-Type'] = 'application/json'})


                ------------- Add everything

                HVCclient.notify(ids, {"~g~Thankyou for donating to HVC.\nItems Added:\n- Champion Rank\n- £20,000,000\n- " ..selectedcarname.. "\n- VIP Access"})
                HVC.addUserGroup({HVC.getUserId({ids}), "champion"})
                HVC.giveBankMoney({HVC.getUserId({ids}), 20000000})

                --------------------------------------------------------------------------------------

                exports['ghmattimysql']:execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {user_id = HVC.getUserId({ids}), vehicle = selectedcar}, function() end)
                exports['ghmattimysql']:execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {user_id = HVC.getUserId({ids}), vehicle = selectedcar2}, function() end)
                exports['ghmattimysql']:execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {user_id = HVC.getUserId({ids}), vehicle = selectedcar3}, function() end)
                exports['ghmattimysql']:execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {user_id = HVC.getUserId({ids}), vehicle = selectedcar4}, function() end)
            end
        end

        ----TriggerClientEvent("chatMessage", -1, "^1^*[HVC]", {180, 0, 0}, " ^7 Users Found: "..GetPlayerName(ids))

    end

    
end

RegisterCommand('addchampiontouser', addchampiontouser, true)


















function testing(_, args)
    local permid = args[1]
    local allplayers = GetPlayers()

    for _, ids in pairs(allplayers) do
        if HVC.getUserId({ids}) == tonumber(permid) then
            print(json.encode(allplayers))
            print("Player Names: " ..GetPlayerName(ids))
            print("TempID: " ..ids)
            print("PermID: " ..HVC.getUserId({ids}))
            print("Entered PermID: " ..permid)
            print(HVC.getUserId({ids}) == tonumber(permid))
            HVC.giveBankMoney({HVC.getUserId({ids}), 50000000})
            HVCclient.notify(ids, {"~g~Thankyou for donating to HVC. Your money bag has been added."})
            print()
            print("----------------------------------------------------------------------")

            local logs = "https://canary.discord.com/api/webhooks/887423418536951839/aJxtCuNtY8I1iduLBYnSaHB5-QYqm7x7L7Bo3iOznDDmR6-McQo6-FmuMdCX2k7xNfJH" -- Main Discord | HVC
            local communityname = "HVC Tebex Logs"
            local communtiylogo = "" --Must end with .png or .jpg

            local command = {
                {
                    ["fields"] = {
                        {
                            ["name"] = "**Player Name**",
                            ["value"] = "" ..GetPlayerName(ids),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Player TempID**",
                            ["value"] = "" ..ids,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Player PermID**",
                            ["value"] = "" ..HVC.getUserId({ids}),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Package Name**",
                            ["value"] = "1",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Tebex Donation ID**",
                            ["value"] = "1",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "**Tebex Name**",
                            ["value"] = "1",
                            ["inline"] = true
                        },
                    },
                    ["color"] = "15536128",
                    ["title"] = GetPlayerName(ids).." Has Donated",
                    ["description"] = "",
                    ["footer"] = {
                    ["text"] = communityname,
                    ["icon_url"] = communtiylogo,
                    },
                }
            }
            
            PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Tebex Logs", embeds = command}), { ['Content-Type'] = 'application/json'})

        end

        --TriggerClientEvent("chatMessage", -1, "^1^*[HVC]", {180, 0, 0}, " ^7 Users Found: "..GetPlayerName(ids))

    end

    
end

RegisterCommand('testing', testing, true)