-- Script Made @
-- 20/12/2021 
-- 02:21 AM
-- @Vrxith#8692

-- Paintball Script
-- This Script Includes:

-- Paintball Guns (Normal + Paid Machine Pistol)
-- Wagers (Min = $50,000 | Max = $10,000,000)
-- Scoreboard Upon Death

local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "Paintball")



local GameStarted = false
local TotalPot = 0
local RedTeamWager = 0
local BlueTeamWager = 0
local RedTeamPoints = 0
local BlueTeamPoints = 0

local RedTeam = {
    --[1] = {"Name", "TempID", "PermID"}, -- 1 TO BE REPLACED WITH SOURCE
}

local BlueTeam = {
    --[1] = {"Name", "TempID", "PermID"}, -- 1 TO BE REPLACED WITH SOURCE
}


RegisterServerEvent("HVC:JoinTeam")
AddEventHandler("HVC:JoinTeam", function(TeamColor)

    local source = source
    local UserId = HVC.getUserId({source})

    HVCclient.notify(source, {"~y~Attempting To Join " .. TeamColor .. " Team"})

    if GameStarted then
        HVCclient.notify(source, {"~r~Error~w~: The Game Has Already Started."})
        return
    end
 
    if RedTeam[GetPlayerName(source)] then
        HVCclient.notify(source, {"~r~Error~w~: You Are Already Part Of ~r~Red Team."})
        return
    end

    if BlueTeam[GetPlayerName(source)] then
        HVCclient.notify(source, {"~r~Error~w~: You Are Already Part Of ~b~Blue Team."})
        return
    end

    if (tablelength(RedTeam) + tablelength(BlueTeam)) == 10 then
        HVCclient.notify(source, {"~r~Error~w~: Both Teams Have Reached The Max Player Slots."})
        return
    end

    if TeamColor == "Red" then
 
        if BlueTeam[GetPlayerName(source)] == nil and RedTeam[GetPlayerName(source)] == nil then

            if tablelength(RedTeam) == 5 then
                return
            end

            RedTeam[GetPlayerName(source)] = {GetPlayerName(source), source, UserId} 
            TriggerClientEvent("HVC:Client:AddPlayerToTeam", source, TeamColor)
            Wait(500)
            for i,v in pairs(RedTeam) do 
                --TriggerClientEvent("HVC:Client:AddPlayerToTeam", i, TeamColor)
                HVCclient.notify(v[2], {GetPlayerName(source).. " ~w~Joined The ~r~Red Team."})
            end

            for i,v in pairs(BlueTeam) do 
                --TriggerClientEvent("HVC:Client:AddPlayerToTeam", i, TeamColor)
            end

        end

    else

        if TeamColor == "Blue" then

            if tablelength(BlueTeam) == 5 then
                return
            end

            BlueTeam[GetPlayerName(source)] = {GetPlayerName(source), source, UserId} 
            TriggerClientEvent("HVC:Client:AddPlayerToTeam", source, TeamColor)
            Wait(500)
            for i,v in pairs(RedTeam) do 
                --TriggerClientEvent("HVC:Client:AddPlayerToTeam", i, TeamColor)
            end

            for i,v in pairs(BlueTeam) do 
                --TriggerClientEvent("HVC:Client:AddPlayerToTeam", i, TeamColor)
                HVCclient.notify(v[2], {GetPlayerName(source).. " ~w~Joined The ~b~Blue Team."})
            end


        end

    end

    
    -- HVCclient.notify(source, {"~r~" ..tablelength(RedTeam)})
    -- HVCclient.notify(source, {"~b~" ..tablelength(BlueTeam)})

end)



RegisterServerEvent("HVC:LeaveTeam")
AddEventHandler("HVC:LeaveTeam", function(TeamColor)
    local source = source
    local UserId = HVC.getUserId({source})

    if TeamColor == "Blue" then
        HVCclient.notify(source, {"You have left the ~b~Blue Team"})
        BlueTeam[GetPlayerName(source)] = nil
        TriggerClientEvent("HVC:Client:RemovelayerToTeam", source)
        Wait(500)
        for i,v in pairs(BlueTeam) do 
            HVCclient.notify(v[2], {GetPlayerName(source).. " ~w~Left the ~b~Blue team."})
        end
    elseif TeamColor == "Red" then
        HVCclient.notify(source, {"You have left the ~r~Red Team"})
        RedTeam[GetPlayerName(source)] = nil
        TriggerClientEvent("HVC:Client:RemovelayerToTeam", source)
        Wait(500)
        for i,v in pairs(RedTeam) do 
            HVCclient.notify(v[2], {GetPlayerName(source).. " ~w~Left the ~r~Red team."})
        end
    end
end)


RegisterServerEvent("HVC:Server:RequestUpdate")
AddEventHandler("HVC:Server:RequestUpdate", function()
    local source = source
    local UserId = HVC.getUserId({source})

    TriggerClientEvent("HVC:Client:UpdateAllTeams", -1, BlueTeam, RedTeam)
end)

RegisterServerEvent("HVC:Server:AddFundsToPot")
AddEventHandler("HVC:Server:AddFundsToPot", function(Team, TeamPot)
    local source = source
    local UserId = HVC.getUserId({source})
    local Bank = HVC.getBankMoney({UserId})

    if Team == "Blue" then
        if TeamPot + BlueTeamWager > 5000000 then
            HVCclient.notify(source, {"~y~Entering £" ..Comma(TeamPot).." Will Exceed The Limit (£5,000,000) Per Team."})
            return
        end
    end

    if Team == "Red" then
        if TeamPot + RedTeamWager > 5000000 then
            HVCclient.notify(source, {"~y~Entering £" ..Comma(TeamPot).." Will Exceed The Limit (£5,000,000) Per Team."})
            return
        end
    end



    if TeamPot > 10000000 then
        HVCclient.notify(source, {"~y~Entering £" ..Comma(TeamPot).." Will Exceed The Limit (£10,000,000)"})
        return
    end
    

    if Team == "Blue" and BlueTeam[GetPlayerName(source)] then
        if (TeamPot+TotalPot) > 10000000 then
            HVCclient.notify(source, {"~y~Entering £" ..Comma(TeamPot).." Will Exceed The Limit (£10,000,000)"})
            return
        end

        if Bank > TeamPot then
            HVC.tryBankPayment({UserId, TeamPot})
            BlueTeamWager = BlueTeamWager + TeamPot
            for i,v in pairs(RedTeam) do 
                --TriggerClientEvent("HVC:Client:AddPlayerToTeam", i, TeamColor)
                HVCclient.notify(v[2], {GetPlayerName(source).. " ~w~Has Deposited £" ..Comma(TeamPot).. " Into The ~b~Blue Team's~w~ Pot."})
            end
    
            for i,v in pairs(BlueTeam) do 
                --TriggerClientEvent("HVC:Client:AddPlayerToTeam", i, TeamColor)
                HVCclient.notify(v[2], {GetPlayerName(source).. " ~w~Has Deposited £" ..Comma(TeamPot).. " Into The ~b~Blue Team's~w~ Pot."})
            end
        else
            HVCclient.notify(source, {"~r~You Do Not Have Enough Funds"})
        end
    elseif Team == "Red" and RedTeam[GetPlayerName(source)] then

        if (TeamPot+TotalPot) > 10000000 then
            HVCclient.notify(source, {"~y~Entering £" ..Comma(TeamPot).." Will Exceed The Limit (£10,000,000)"})
            return
        end

        if Bank > TeamPot then
            HVC.tryBankPayment({UserId, TeamPot})
            RedTeamWager = RedTeamWager + TeamPot
            for i,v in pairs(RedTeam) do 
                --TriggerClientEvent("HVC:Client:AddPlayerToTeam", i, TeamColor)
                HVCclient.notify(v[2], {GetPlayerName(source).. " ~w~Has Deposited £" ..Comma(TeamPot).. " Into The ~r~Red Team's~w~ Pot."})
            end
    
            for i,v in pairs(BlueTeam) do 
                --TriggerClientEvent("HVC:Client:AddPlayerToTeam", i, TeamColor)
                HVCclient.notify(v[2], {GetPlayerName(source).. " ~w~Has Deposited £" ..Comma(TeamPot).. " Into The ~r~Red Team's~w~ Pot."})
            end
        else
            HVCclient.notify(source, {"~r~You Do Not Have Enough Funds"})
        end

    end
    TotalPot = BlueTeamWager + RedTeamWager

    TriggerClientEvent("HVC:Client:UpdateAllPots", -1, BlueTeamWager, RedTeamWager, TotalPot)
end)

RegisterServerEvent("HVC:Server:StartPaintball")
AddEventHandler("HVC:Server:StartPaintball", function()
    local source = source
    local UserId = HVC.getUserId({source})

    if GameStarted then
        HVCclient.notify(source, {"~r~Paintball Has Already Been Started."})
        return
    end
    print("Server Event Triggered (Paintball Game Starting In 30Seconds)")
    GameStarted = true
    if BlueTeam[GetPlayerName(source)] or RedTeam[GetPlayerName(source)] then
        if tablelength(RedTeam) > 0 then
            for i,v in pairs(RedTeam) do 
                HVCclient.notify(v[2], {GetPlayerName(source).. "("..UserId..") ~w~Has Started The Paintball Wager Total Pot: £"..Comma(TotalPot)})
                TriggerClientEvent("HVC:Client:StartPaintball", v[2], "Red")
                print("Triggered Paintball Start For [Red] " ..v[1])
            end
        end

        if tablelength(BlueTeam) > 0 then
            for i,v in pairs(BlueTeam) do 
                HVCclient.notify(v[2], {GetPlayerName(source).. "("..UserId..") ~w~Has Started The Paintball Wager Total Pot: £"..Comma(TotalPot)})
                TriggerClientEvent("HVC:Client:StartPaintball", v[2], "Blue")
                print("Triggered Paintball Start For [Blue] " ..v[1])
            end
        end

    end
end)

RegisterServerEvent("HVC:Server:UpdatePoints")
AddEventHandler("HVC:Server:UpdatePoints", function(CurrentTeam)
    local source = source
    if tablelength(RedTeam) > 0 then
        for i,v in pairs(RedTeam) do 
            GameStarted = false
        end
    end

    if tablelength(BlueTeam) > 0 then
        for i,v in pairs(BlueTeam) do 
            GameStarted = false
        end
    end
    print("Paintballer Detected " ..source, GetPlayerName(source) )
    
    if BlueTeam[GetPlayerName(source)] or RedTeam[GetPlayerName(source)] then
        if CurrentTeam == "Blue" then
            RedTeamPoints = RedTeamPoints + 1
            if RedTeamPoints == 15 then
                TriggerClientEvent("chatMessage", -1, "^1^*[Paintball]", {180, 0, 0}, " ^1 Red Team ^7Has Won The Wager.")
                if tablelength(RedTeam) > 0 then
                    for i,v in pairs(RedTeam) do 
                        HVCclient.notify(v[2], {"~g~Red Team Won Wager, £" ..Comma(TotalPot/tablelength(RedTeam).. " Each")})
                        HVC.giveBankMoney({v[3], TotalPot/tablelength(RedTeam)})
                        print("Gave Player Money " ..v[1])
                    end
                end


                TriggerClientEvent("HVC:Client:StopPaintbal", -1)
            else
                if tablelength(RedTeam) > 0 then
                    for i,v in pairs(RedTeam) do 
                        HVCclient.notify(v[2], {"~b~" ..BlueTeamPoints.. "~w~ - ~r~" ..RedTeamPoints})
                        print("Update Points [Red] " ..v[1])
                    end
                end
        
                if tablelength(BlueTeam) > 0 then
                    for i,v in pairs(BlueTeam) do 
                        HVCclient.notify(v[2], {"~b~" ..BlueTeamPoints.. "~w~ - ~r~" ..RedTeamPoints})
                        print("Update Points [Blue] " ..v[1])
                    end
                end
        
            end
        elseif CurrentTeam == "Red" then
            BlueTeamPoints = BlueTeamPoints + 1

            if BlueTeamPoints == 15 then
                TriggerClientEvent("chatMessage", -1, "^1^*[Paintball]", {180, 0, 0}, " ^5 Blue Team ^7Has Won The Wager.")
                if tablelength(BlueTeam) > 0 then
                    for i,v in pairs(BlueTeam) do 
                        HVCclient.notify(v[2], {"~g~Red Team Won Wager, £" ..Comma(TotalPot/tablelength(BlueTeam).. " Each")})
                        HVC.giveBankMoney({v[3], TotalPot/tablelength(BlueTeam)})
                        print("Gave Player Money " ..v[1])
                    end
                end
                Wait(100)
                GameStarted = false
                TotalPot = 0
                RedTeamWager = 0
                BlueTeamWager = 0
                RedTeamPoints = 0
                BlueTeamPoints = 0
                BlueTeam = {}
                RedTeam = {}
                TriggerClientEvent("HVC:Client:StopPaintbal", -1)
            else
                
                if tablelength(RedTeam) > 0 then
                    for i,v in pairs(RedTeam) do 
                        HVCclient.notify(v[2], {"~b~" ..BlueTeamPoints.. "~w~ - ~r~" ..RedTeamPoints})
                        print("Update Points [Red] " ..v[1])
                    end
                end
        
                if tablelength(BlueTeam) > 0 then
                    for i,v in pairs(BlueTeam) do 
                        HVCclient.notify(v[2], {"~b~" ..BlueTeamPoints.. "~w~ - ~r~" ..RedTeamPoints})
                        print("Update Points [Blue] " ..v[1])
                    end
                end
        
            end
            
        end
    else

    end
end)


RegisterServerEvent("HVC:Server:StopPainting")
AddEventHandler("HVC:Server:StopPainting", function(CurrentTeam)
    print(tablelength(RedTeam))
    print(tablelength(BlueTeam))
    print(GameStarted)

    if GameStarted then
    
        for i,v in pairs(RedTeam) do 
            GameStarted = false
            TotalPot = 0
            RedTeamWager = 0
            BlueTeamWager = 0
            RedTeamPoints = 0
            BlueTeamPoints = 0
            print(v[1], v[2], v[3])
            TriggerClientEvent("HVC:Client:StopPaintbal", v[2])
        end

        for i,v in pairs(BlueTeam) do 
            print(v[1], v[2], v[3])
            TriggerClientEvent("HVC:Client:StopPaintbal", v[2])
        end

        Wait(500)
        GameStarted = false
        TotalPot = 0
        RedTeamWager = 0
        BlueTeamWager = 0
        RedTeamPoints = 0
        BlueTeamPoints = 0
        BlueTeam = {}
        RedTeam = {}
    end

end)


RegisterCommand("leavepaintball", function(source, args, RawCommand)
    local source = source

    if not GameStarted then
        HVCclient.notify(source, {"~r~The Game Hasn't Even Started.."})
        return
    end

    if BlueTeam[GetPlayerName(source)] then

        if tablelength(BlueTeam) > 0 then
            for i,v in pairs(BlueTeam) do 
                HVCclient.notify(v[2], {"~b~" ..GetPlayerName(source).. "~w~ Has Left Paintball"})
                print("Player Left [~b~Blue~w~] " ..GetPlayerName(source))

                BlueTeam[GetPlayerName(source)] = nil

                TriggerClientEvent("HVC:Client:LeaveGame", source)
            end
        end

    end

    if RedTeam[GetPlayerName(source)] then

        if tablelength(RedTeam) > 0 then
            for i,v in pairs(RedTeam) do 
                HVCclient.notify(v[2], {"~r~" ..GetPlayerName(source).. "~w~ Has Left Paintball"})
                print("Player Left [~r~Red~w~] " ..GetPlayerName(source))

                RedTeam[GetPlayerName(source)] = nil

                TriggerClientEvent("HVC:Client:LeaveGame", source)
            end
        end

    end

end)



RegisterServerEvent("HVC:Server:PurchaseWeapon")
AddEventHandler("HVC:Server:PurchaseWeapon", function()
    local source = source
    local UserId = HVC.getUserId({source})

    

    if BlueTeam[GetPlayerName(source)] or RedTeam[GetPlayerName(source)] then
        if HVC.tryPayment({UserId, 15000}) then
            TriggerClientEvent("HVC:Client:PurchasedGun", source)
            HVCclient.notify(source, {"~g~Purchased Paintball Gun"})
        else 
            HVCclient.notify(source, {"~r~Insufficient funds"})
        end
    else
        HVCclient.notify(source, {"~r~You Arent Even In A Game..."})
    end
end)



function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end