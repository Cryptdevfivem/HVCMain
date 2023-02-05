Tunnel = module("hvc", "lib/Tunnel")
Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVC")

HVCTurfs = {}
Tunnel.bindInterface("HVCTurfs", HVCTurfs)
Proxy.addInterface("HVCTurfs", HVCTurfs)
HVCTurfC = Tunnel.getInterface("HVCTurfs","HVCTurfs")   


local Turfs = {
    [0] = {
        Name = "Cocaine",
        ChatName = "^7Cocaine^7",
        Commission = 0,
        Taken = false,
        BeingTaken = false,
        TurfTakeTime = 15,
        GangTaken = nil,
        GangTaking = nil,
        TurfCooldown = 0,
        TurfCentre = {136.2989, -1307.789, 28.94287},
        TurfDist = 50,
        TurfTakenTime = 180,
        PlayersInTurf = {
            --[[
                [TempID] = {"Name", "GangName", "Health"}
            ]]
        },
    },
    [1] = {
        Name = "LSD",
        ChatName = "^9LSD^7",
        Commission = 0,
        Taken = false,
        BeingTaken = false,
        TurfTakeTime = 15,
        GangTaken = nil,
        GangTaking = nil,
        TurfCooldown = 0,
        TurfCentre = {2482.971, -413.2615, 93.73047},
        TurfDist = 50,
        TurfTakenTime = 180,
        PlayersInTurf = {
            --[[
                [TempID] = {"Name", "GangName", "Health"}
            ]]
        },
    },
    [2] = {
        Name = "Meth",
        ChatName = "^4Meth^7",
        Commission = 0,
        Taken = false,
        BeingTaken = false,
        TurfTakeTime = 15,
        GangTaken = nil,
        GangTaking = nil,
        TurfCooldown = 0,
        TurfCentre = {871.2132, 2853.455, 56.96411},
        TurfDist = 50,
        TurfTakenTime = 180,
        PlayersInTurf = {
            --[[
                [TempID] = {"Name", "GangName", "Health"}
            ]]
        },
    },
    [3] = {
        Name = "MDMA",
        ChatName = "^3MDMA^7",
        Commission = 0,
        Taken = false,
        BeingTaken = false,
        TurfTakeTime = 15,
        GangTaken = nil,
        GangTaking = nil,
        TurfCooldown = 0,
        TurfCentre = {-560.9143, 307.0549, 84.58093},
        TurfDist = 50,
        TurfTakenTime = 180,
        PlayersInTurf = {
            --[[
                [TempID] = {"Name", "GangName", "Health"}
            ]]
        },
    },
    [4] = {
        Name = "Heroin",
        ChatName = "^1Heroin^7",
        Commission = 0,
        Taken = false,
        BeingTaken = false,
        TurfTakeTime = 15,
        GangTaken = nil,
        GangTaking = nil,
        TurfCooldown = 0,
        TurfCentre = {3576.884, 3665.116, 33.91357},
        TurfDist = 40,
        TurfTakenTime = 180,
        PlayersInTurf = {
            --[[
                [TempID] = {"Name", "GangName", "Health"}
            ]]
        },
    },
    [5] = {
        Name = "DMT",
        ChatName = "^1DMT^7",
        Commission = 0,
        Taken = false,
        BeingTaken = false,
        TurfTakeTime = 15,
        GangTaken = nil,
        GangTaking = nil,
        TurfCooldown = 0,
        TurfCentre = {-587.0242, -1609.266, 27.00513},
        TurfDist = 40,
        TurfTakenTime = 180,
        PlayersInTurf = {
            --[[
                [TempID] = {"Name", "GangName", "Health"}
            ]]
        },
    },
    [6] = {
        Name = "Weed",
        ChatName = "^2Weed^7",
        Commission = 0,
        Taken = false,
        BeingTaken = false,
        TurfTakeTime = 15,
        GangTaken = nil,
        GangTaking = nil,
        TurfCooldown = 0,
        TurfCentre = {327.1253, -2033.473, 20.93921},
        TurfDist = 40,
        TurfTakenTime = 180,
        PlayersInTurf = {
            --[[
                [TempID] = {"Name", "GangName", "Health"}
            ]]
        },
    },
    [7] = {
        Name = "Large Arms",
        ChatName = "^1Large Arms^7",
        Commission = 0,
        Taken = false,
        BeingTaken = false,
        TurfTakeTime = 15,
        GangTaken = nil,
        GangTaking = nil,
        TurfCooldown = 0,
        TurfCentre = {-1114.892, 4924.655, 218.0483},
        TurfDist = 40,
        TurfTakenTime = 180,
        PlayersInTurf = {
            --[[
                [TempID] = {"Name", "GangName", "Health"}
            ]]
        },
    },
}




Citizen.CreateThread(function()
    while true do
        for k,v in pairs(Turfs) do
            if v.TurfCooldown > 0 then
                v.TurfCooldown = v.TurfCooldown - 1
            end
        end
        Citizen.Wait(60000)
    end
end)

function GetPlayerGangInfo(source)
    local Src = source
    local PlayerID = HVC.getUserId({Src})
	local IsInGang = false
    local GangName, GangMembers = nil
    local GangIndexing = 0
    print("[^1HVC Modules^7] [^4Turfs^7] [^2Server^7] " ..PlayerID.." Requested GangInfo.")
	exports['ghmattimysql']:execute("SELECT * FROM vrxith_gangs", {}, function(GangIndex)
        print("[^1HVC Modules^7] [^4Turfs^7] [^2Server^7] " ..PlayerID.." Request Is Pending.")
		if #GangIndex > 0 then
            print("[^1HVC Modules^7] [^4Turfs^7] [^2Server^7] " ..PlayerID.." Request Is Processing.")
			for i = 1, #GangIndex do
				GangTable = json.decode(GangIndex[i].GangMembers)
				for k,v in pairs(GangTable) do
					if not IsInGang then
						if tonumber(k) == PlayerID then
							IsInGang = true 
                            print("[^1HVC Modules^7] [^4Turfs^7] [^2Server^7] " ..PlayerID.." Request has been processed and is in a Gang." ..GangIndex[i].GangName)
							GangIndexing = i
                            GangName, GangMembers = GangIndex[i].GangName, json.decode(GangIndex[i].GangMembers)
						end
					end
				end
			end
			print("[^1HVC Modules^7] [^4Turfs^7] Finished Table Search ^2Gang Index: ^7" ..GangIndexing.." UserID, InGang?: " ..PlayerID.. ", " ..tostring(IsInGang))
		else
			print("[^1HVC Modules^7] [^4Turfs^7] Error Fetching Gangs. ^2Table Search Result^7: " ..tostring(#GangIndex))
		end
	end)
    repeat
        Wait(100)
    until GangName ~= nil and GangMembers ~= nil
    return GangName, GangMembers
end

function HVCTurfs.GetTurfOwnerCommission(TurfID)
    print(tostring(Turfs[tonumber(TurfID)]["GangTaken"]))
    print(tonumber(Turfs[tonumber(TurfID)]["Commission"]))

    return tostring(Turfs[tonumber(TurfID)]["GangTaken"]), tonumber(Turfs[tonumber(TurfID)]["Commission"])
end

function GetTurfOwnerCommission(TurfID)
    return tostring(Turfs[tonumber(TurfID)]["GangTaken"]), tonumber(Turfs[tonumber(TurfID)]["Commission"])
end

function HVCTurfs.SetTurfCommissionakeTurf(TurfID, Commission)
    local Src = source
    local PlayerID = HVC.getUserId({Src})
    local GangName, GangMembers = GetPlayerGangInfo(source)
    if GangName ~= nil then
        if Turfs[TurfID]["GangTaken"] == GangName then
            if Commission < 1 then
                return
            elseif Commission >= 1 then
                if Commission <= 15 then
                    Turfs[TurfID]["Commission"] = tonumber(Commission)
                    TriggerClientEvent("chatMessage", -1, Turfs[TurfID]["ChatName"].. " Commission has been set to " ..Commission.."% by " ..GangName, {180, 0, 0}, "", "alert")
                else
                    HVCclient.notify(Src, {"~r~Commission cannot be over 15%."})
                end
            else
                HVCclient.notify(Src, {"~r~Commission has to be at least 1%."})
            end
        else
            HVCclient.notify(Src, {"~r~Your gang doesn't own this turf"})
        end
    end
end



function HVCTurfs.ModifyGangFundsSV(Type, GangName, Amount)
	exports['ghmattimysql']:execute("SELECT * FROM vrxith_gangs WHERE GangName = @GangName", {GangName = GangName}, function(GangIndex)
		if #GangIndex > 0 then
			GFunds = GangIndex[1].GangFunds
			if Type == "Deduct" then
				GFunds = GFunds - Amount
				if GFunds > 0 then
					exports['ghmattimysql']:execute("UPDATE vrxith_gangs SET GangFunds = @GangFunds WHERE GangName = @GangName", {GangFunds = tonumber(GFunds), GangName = GangName}, function() end)
				else
					return
				end
			elseif Type == "Give" then
				GFunds = GFunds + Amount
				exports['ghmattimysql']:execute("UPDATE vrxith_gangs SET GangFunds = @GangFunds WHERE GangName = @GangName", {GangFunds = tonumber(GFunds), GangName = GangName}, function() end)
			end
		end
	end)
end



function HVCTurfs.TakeTurf(TurfID, TurfName)
    local Src = source
    local PlayerID = HVC.getUserId({Src})
    local GangName, GangMembers = GetPlayerGangInfo(source)
    if GangName ~= nil then

        print(GangName, Turfs[TurfID]["GangTaken"], Turfs[TurfID]["BeingTaken"])
        if GangName == Turfs[TurfID]["GangTaken"] then
            print("[^1HVC Modules^7] [^4Turfs^7] " ..GangName.." Can't Take The Turf As They Already Own It")
            HVCclient.notify(Src, {"~r~Your gang already owns " ..Turfs[TurfID]["Name"].." trader."})
            return
        end

        if Turfs[TurfID]["BeingTaken"] == true then
            print("[^1HVC Modules^7] [^4Turfs^7] " ..GangName.." Can't Take The Turf As It Is Already Being Taken.")
            HVCclient.notify(Src, {"~r~" ..Turfs[TurfID]["Name"].." trader is already being taken."})
            return
        end

        if Turfs[TurfID]["TurfCooldown"] == 0 then
           
            Turfs[TurfID]["TurfCooldown"] = 15
            Turfs[TurfID]["BeingTaken"] = true
            Turfs[TurfID]["GangTaking"] = GangName
            TriggerClientEvent("chatMessage", -1, "", {180, 0, 0}, "^7The " ..Turfs[TurfID]["ChatName"].." trader is being attacked by " ..GangName, "alert")
            HVCTurfC.SetTurfZone(-1, {TurfID, true})
        else
            HVCclient.notify(Src, {"~r~" ..Turfs[TurfID]["Name"].. " turf is on cooldown, there is " ..Turfs[TurfID]["TurfCooldown"].. " minutes before you can take it! "})
            print("[^1HVC Modules^7] [^4Turfs^7] "..PlayerID.." Take "..TurfName.." Turf Request Was Denied. [^1Reason: ^4"..TurfName.." Is On CoolDown^7]")
        end
    else
        print("[^1HVC Modules^7] [^4Turfs^7] "..PlayerID.." Take "..TurfName.." Turf Request Was Denied. [^1Reason: ^4Player Is Not In A Gang.^7]")
        return
    end
end


function HVCTurfs.PlayerEnteredTurf(TurfID, TurfName)
    local Src = source
    local PlayerID = HVC.getUserId({Src})
    local GangName, GangMembers = GetPlayerGangInfo(Src)

    if Turfs[TurfID]["PlayersInTurf"][Src] == nil then
        Turfs[TurfID]["PlayersInTurf"][Src] = {PlayerID, GangName}
        print("[^1HVC Modules^7] [^4Turfs^7] " ..GetPlayerName(Src).." Just Entered " ..TurfName)
        HVCTurfC.NotifyTurfs(Src, {true})
    end
end



function HVCTurfs.PlayerLeftTurf(TurfID, TurfName)
    local Src = source
    local PlayerID = HVC.getUserId({Src})
    local GangName, GangMembers = GetPlayerGangInfo(Src)

    if Turfs[TurfID]["PlayersInTurf"][Src] ~= nil then
        Turfs[TurfID]["PlayersInTurf"][Src] = nil
        print("[^1HVC Modules^7] [^4Turfs^7] " ..GetPlayerName(Src).." Just Left " ..TurfName)
        HVCTurfC.NotifyTurfs(Src, {false})
    end
end


-- local Turfs = {
--     [0] = {
            -- Name = "Cocaine",
            -- Commission = 0,
            -- Taken = false,
            -- BeingTaken = false,
            -- TurfTakeTime = 15,
            -- GangTaken = nil,
            -- TurfCooldown = 0,
            -- TurfCentre = {136.2989, -1307.789, 28.94287},
            -- TurfDist = 50,
            -- TurfTakenTime = 180,
            -- PlayersInTurf = {
            --     --[[
            --         [TempID] = {"Name", "GangName", "Health"}
            --     ]]
            -- },
--     }
-- }


Citizen.CreateThread(function()
    while true do 
        for k,v in pairs(Turfs) do
            if v.BeingTaken then
                if v.GangTaken then
                    -- Notify The Gang Manigga
                end

                if v.TurfTakenTime > 0 then
                    v.TurfTakenTime = v.TurfTakenTime - 1
                    HVCTurfC.SetTurfTimer(-1, {k, v.TurfTakenTime})
                end

                if v.TurfTakenTime == 0 and v.GangTaken ~= v.GangTaking then
                    v.Taken = true
                    v.BeingTaken = false
                    v.TurfCooldown = 15
                    v.TurfTakenTime = 180

                    if v.GangTaken ~= nil then
                        TriggerClientEvent("chatMessage", -1, "", {180, 0, 0}, "^7"..v.GangTaking.. " has just taken the "..v.ChatName.." trader from " ..v.GangTaken.."!", "alert")
                    else
                        TriggerClientEvent("chatMessage", -1, "", {0,0,0}, "^7"..v.GangTaking.. " has just taken the "..v.ChatName.." trader!", "alert")
                    end
                    v.GangTaken = v.GangTaking
                    HVCTurfC.SetTurfZone(-1, {k, false})
                    HVCTurfC.SetTurfTimer(-1, {k, 0})
                end

                if GetGangMembersInTurf(k, v.GangTaking) == 0 then
                    v.BeingTaken = false
                    v.TurfCooldown = 15
                    v.TurfTakenTime = 180 
                    TriggerClientEvent("chatMessage", -1, "", {180, 0, 0}, "^7"..v.GangTaking.." has failed to take the "..v.ChatName.."^7 trader!", "alert")
                    HVCTurfC.SetTurfZone(-1, {k, false})
                    HVCTurfC.SetTurfTimer(-1, {k, 0})
                end

            end
        end
        Wait(1000)
    end
end)




function GetGangMembersInTurf(TurfID, GangName)
    local Amt = 0
    for k,v in pairs(Turfs) do
        if TurfID == k then
            for i,g in pairs(v.PlayersInTurf) do
                if tostring(g[2]) == GangName then
                    local EntityHealth = GetEntityHealth(GetPlayerPed(HVC.getUserSource({tonumber(g[1])})))
                    if EntityHealth <= 102 then
                    else
                        Amt = Amt + 1
                    end
                end
            end
            return Amt
        end
    end
end







--[[
    To Implement:
    Pause Timer While Enemies In Turf
]]



-- function GetEnemiesInTurf(TurfID, GangName)
--     local Enemies = 0
--     for k,v in pairs(Turfs) do
--         if TurfID == k then

--         end
--     end
-- end