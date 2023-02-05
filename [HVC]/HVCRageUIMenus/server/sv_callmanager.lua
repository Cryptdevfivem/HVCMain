local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVCRageUIMenu")
HVCModuleC = Tunnel.getInterface("HVC_Modules","HVC_Modules")

local Tickets = {}
Tickets.Admin = {}
Tickets.NHS = {}
Tickets.PD = {}


RegisterServerCallback("HVC:GetCallmanagerPerms", function(source)
    local UserID = HVC.getUserId({source})
    local Admin = false;
    local NHS = false;
    local PD = false;
    if HVC.hasPermission({UserID, "admin.menu"}) then
        Admin = true;
    end
    if HVC.hasPermission({UserID, "emscheck.revive"}) then
        NHS = true;
    end
    if HVC.hasPermission({UserID, "police.menu"}) then
        PD = true;
    end
    return {Admin,NHS,PD}
end)

RegisterServerCallback("HVC:GetAdminTickets", function(source)
    local UserID = HVC.getUserId({source})
    if HVC.hasPermission({UserID, "admin.menu"}) then
        return {Tickets.Admin}
    end
end)

RegisterServerCallback("HVC:GetNHSCalls", function(source)
    local UserID = HVC.getUserId({source})
    if HVC.hasPermission({UserID, "emscheck.revive"}) then
        return {Tickets.NHS}
    end
end)

RegisterServerCallback("HVC:GetPDCalls", function(source)
    local UserID = HVC.getUserId({source})
    if HVC.hasPermission({UserID, "police.menu"}) then
        return {Tickets.PD}
    end
end)


local SavedCoords = {}
RegisterNetEvent("HVC:TakeTicket")
AddEventHandler("HVC:TakeTicket", function(Index)
    local source = source
    local UserID = HVC.getUserId({source})
    if HVC.hasPermission({UserID, "admin.menu"}) then
        if Tickets.Admin[Index] then
            if SavedCoords[source] then
                HVCclient.notify(source,{"~r~You must return before taking another ticket."})
            end

            local TargetSource = Tickets.Admin[Index][4]
            if TargetSource == source then
                HVCclient.notify(source,{"~r~You cannot take your own ticket."})
            else
                local TargetPed = GetPlayerPed(TargetSource)
                local TargetCoords = GetEntityCoords(TargetPed)
                if CheckRedZone(TargetCoords) then
                    HVCclient.notify(source,{"~r~"..GetPlayerName(TargetSource).. " is currently in a redzone."})
                    HVCclient.notify(TargetSource,{"~r~"..GetPlayerName(source).. " tried taking your ticket but your in a redzone, alert them once your out."})
                else
                    SavedCoords[source] = GetEntityCoords(GetPlayerPed(source))
                    TriggerEvent("HVC:TeleportPlayer", source, TargetCoords.x, TargetCoords.y, TargetCoords.z, false, false, false, false)
                    local Health = GetEntityHealth(GetPlayerPed(source))
                    if Health < 200 then
                        TriggerEvent("HVC:ProvideHealth", source, 200)
                    end
                    HVCModuleC.ClientStaffOnDuty(source, {"Staffon"})
                    PayAdmin(source)
                    Tickets.Admin[Index] = nil;
                    HVCclient.notify(source,{"~g~Thank you for taking an admin ticket, as appreciation, we have given you some money!"})
                    HVCclient.notify(TargetSource,{"~g~" ..GetPlayerName(source).. " has taken your ticket."})
                    exports['ghmattimysql']:execute("SELECT * FROM HVC_admintickets WHERE UserID = @user_id", {user_id = UserID}, function(result)
                        if #result > 0 then
                            local tTickets = result[1].Tickets
                            local wTickets = result[1].weeklyTickets
                            local newtTickets = tonumber(tTickets) + 1
                            local newwTickets = tonumber(wTickets) + 1
                            exports['ghmattimysql']:execute("UPDATE HVC_admintickets SET weeklyTickets = @weeklyTickets, Tickets = @Tickets WHERE UserID = @user_id", {weeklyTickets = tonumber(newwTickets), Tickets = tonumber(newtTickets), user_id = UserID}, function() end)
                        else
                             exports['ghmattimysql']:execute("INSERT INTO HVC_admintickets (UserID, Name, weeklyTickets, Tickets) VALUES( @user_id, @Name, @weeklyTickets, @Tickets) ON DUPLICATE KEY UPDATE `Tickets` = @Tickets, `weeklyTickets` = @weeklyTickets", {user_id = UserID, Name = GetPlayerName(source), weeklyTickets = 1, Tickets = 1}, function() end)    
                        end    
                    end)
                end
            end
        end
    end
end)

function CheckRedZone(Coords)
    if #(Coords - vec3(3558.87, 3719.74, 37.75)) < 180.0 then --in H
      return true;
    elseif #(Coords - vec3(2530.03, -382.58, 92.99)) <  123.0 then -- Old LSD
      return true;
    elseif #(Coords - vec3(-1109.77, 4922.12, 217.46)) < 120.0 then -- Large
      return true;
    elseif #(Coords - vec3(1485.78, 6330.06, 23.70)) <  92.0 then-- Rebel
      return true;
    elseif #(Coords - vec3(-586.41, -1599.27, 27.01)) < 92.0 then -- DMT
      return true;
    elseif #(Coords - vec3(135.4286, -3095.433, 5.892334)) < 92.0 then -- Blackmarket
      return true;
    elseif #(Coords - vec3(-1705.81, 8886.57, 28.72)) < 92.0 then -- rig
      return true;
    elseif #(Coords - vec3(866.5978, -966.6725, 27.84766)) < 121.0 then -- rig
      return true;
    end
    return false;
  end


RegisterCommand("return", function(source)
    local source = source
    local Ped = GetPlayerPed(source)
    local UserID = HVC.getUserId({source})
    if HVC.hasPermission({UserID, "admin.menu"}) then
        if SavedCoords[source] then
            TriggerEvent("HVC:TeleportPlayer", source, SavedCoords[source].x, SavedCoords[source].y, SavedCoords[source].z, false, false, false, false)
             HVCclient.notify(source,{"~g~You have returned."})
             HVCModuleC.ClientStaffOnDuty(source, {"Staffoff"})
             SavedCoords[source] = nil;
        else
            HVCclient.notify(source,{"~r~You do not have any saved coords."})
        end
    end
end)

function PayAdmin(source)
    local UserID = HVC.getUserId({source})
    if HVC.hasGroup({UserID, "trialstaff"}) then
        HVC.giveBankMoney({UserID,2000})
    elseif HVC.hasGroup({UserID, "support"}) then
        HVC.giveBankMoney({UserID,2000})
    elseif HVC.hasGroup({UserID, "moderator"}) then
        HVC.giveBankMoney({UserID,3000})
    elseif HVC.hasGroup({UserID, "smoderator"}) then
        HVC.giveBankMoney({UserID,4000})
    elseif HVC.hasGroup({UserID, "administrator"}) then
        HVC.giveBankMoney({UserID,5000})
    elseif HVC.hasGroup({UserID, "senioradmin"}) then
        HVC.giveBankMoney({UserID,6000})
    elseif HVC.hasGroup({UserID, "headadmin"}) then
        HVC.giveBankMoney({UserID,7000})
    elseif HVC.hasGroup({UserID, "commanager"}) then
        HVC.giveBankMoney({UserID,8000})
    elseif HVC.hasGroup({UserID, "staffmanager"}) then
        HVC.giveBankMoney({UserID,9000})
    elseif HVC.hasGroup({UserID, "operationsmanager"}) then
        HVC.giveBankMoney({UserID,10000})
    elseif HVC.hasGroup({UserID, "founder"}) then
        HVC.giveBankMoney({UserID,15000})
    end
end


local Cooldowns = {}
Cooldowns.NHS = {}
Cooldowns.PD = {}
RegisterCommand("calladmin", function(source, args, raw)
    local source = source
    local UserID = HVC.getUserId({source})
    if Cooldowns[source] and not (os.time() > Cooldowns[source]) then
        return HVCclient.notify(source,{"~r~You have recently called an admin."})
    else
        Cooldowns[source] = nil
    end
    HVC.prompt({source, "Describe your problem","",function(player, Reason)
        index = #Tickets.Admin + 1
        Tickets.Admin[index] = {GetPlayerName(source), tostring(Reason), UserID, source}
        HVCclient.notify(source, {"~o~Admin ticket sent"})
        Cooldowns[source] = os.time() + tonumber(60)
        local OnlinePlayers = GetPlayers()
		for i,v in pairs(OnlinePlayers) do 
			local name = GetPlayerName(v)
			local user_id = HVC.getUserId({v})   
			if HVC.hasPermission({user_id, "admin.menu"}) then
                HVCclient.notify(v, {"~r~Admin ticket recieved"})
			end
		end
    end})
end)


RegisterCommand("111", function(source, args, raw)
    local source = source
    local UserID = HVC.getUserId({source})
    if Cooldowns.NHS[source] and not (os.time() > Cooldowns.NHS[source]) then
        return HVCclient.notify(source,{"~r~You have recently alerted the NHS."})
    else
        Cooldowns.NHS[source] = nil
    end
    HVC.prompt({source, "What is your emergency?","",function(player, Reason)
        index = #Tickets.NHS + 1
        Tickets.NHS[index] = {GetPlayerName(source),GetEntityCoords(GetPlayerPed(source)), tostring(Reason),source}
        HVCclient.notify(source, {"~g~NHS have been alerted."})
        Cooldowns.NHS[source] = os.time() + tonumber(60)
        local OnlinePlayers = GetPlayers()
		for i,v in pairs(OnlinePlayers) do 
			local name = GetPlayerName(v)
			local user_id = HVC.getUserId({v})   
			if HVC.hasPermission({user_id, "emscheck.revive"}) then
                HVCclient.notify(v, {"~g~NHS call received."})
			end
		end
    end})
end)


RegisterCommand("999", function(source, args, raw)
    local source = source
    local UserID = HVC.getUserId({source})
    if Cooldowns.PD[source] and not (os.time() > Cooldowns.PD[source]) then
        return HVCclient.notify(source,{"~r~You have recently alerted the PD."})
    else
        Cooldowns.PD[source] = nil
    end
    HVC.prompt({source, "What is your emergency?","",function(player, Reason)
        index = #Tickets.PD + 1
        Tickets.PD[index] = {GetPlayerName(source),GetEntityCoords(GetPlayerPed(source)), tostring(Reason),source}
        HVCclient.notify(source, {"~b~The police have been alerted."})
        Cooldowns.PD[source] = os.time() + tonumber(60)
        local OnlinePlayers = GetPlayers()
		for i,v in pairs(OnlinePlayers) do 
			local name = GetPlayerName(v)
			local user_id = HVC.getUserId({v})   
			if HVC.hasPermission({user_id, "police.menu"}) then
                HVCclient.notify(v, {"~b~Police call received."})
			end
		end
    end})
end)


RegisterNetEvent("HVC:TakeCall")
AddEventHandler("HVC:TakeCall",function(Index, Type)
    local source = source
    local UserID = HVC.getUserId({source})
    if Type == "NHS" then
        if HVC.hasPermission({UserID, "emscheck.revive"}) then
            if Tickets.NHS[Index] then
                local TargetSource = Tickets.NHS[Index][4]
                if TargetSource == source then
                    HVCclient.notify(source,{"~r~You cannot accept your own calls."})
                else
                    local TargetPed = GetPlayerPed(TargetSource)
                    local TargetCoords = GetEntityCoords(TargetPed)
                    HVCclient.SetWaypoint(source, {Tickets.NHS[Index][2]})
                    Tickets.NHS[Index] = nil;
                    HVCclient.notify(source,{"~g~Patients location has been set on your GPS"})
                end
            end
        end
    else
        if HVC.hasPermission({UserID, "police.menu"}) then
            if Tickets.PD[Index] then
                local TargetSource = Tickets.PD[Index][4]
                if TargetSource == source then
                    HVCclient.notify(source,{"~r~You cannot accept your own calls."})
                else
                    local TargetPed = GetPlayerPed(TargetSource)
                    local TargetCoords = GetEntityCoords(TargetPed)
                    HVCclient.SetWaypoint(source, {Tickets.PD[Index][2]})
                    Tickets.PD[Index] = nil;
                    HVCclient.notify(source,{"~g~Waypoint to location set."})
                end
            end
        end
    end
end)