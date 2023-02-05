local turfcooldown = false
local turfcash = 0
local turftaken = false
local playersinside = {}
local turfname = "MDMA Turf"
local taketurfpoint = vector3(-554.29, 286.24, 82.18)
local chng = vector3(-554.4, 283.08,82.18)
local beingtaken = false
local enemy = false
local enemies = 0
local gang = 0
local cooldowntimer = 0
local turfdefaulttime = 250
local takengang = 0
local turftakerid = 0
local turftimer = 0
local turfcom = 0
local turfcomsetcooldown = -1
local turftakinggangid = 0
local turftakinggangname = 0
local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVCcc = {}
HVC = Proxy.getInterface("HVC")
--------------------------------
HVCserver = {}
Proxy.addInterface("mdma",HVCserver)

function HVCserver.getMDMACom()
    return tonumber(turfcom)
end

function HVCserver.getMDMAOwnerN()
    return tostring(takengang)
end

function HVCserver.getMDMAOwner()
    return tonumber(turftakerid)
end

Citizen.CreateThread(function()
    while true do 
        Wait(1000)
        if turfcomsetcooldown >= 0 then
            turfcomsetcooldown = turfcomsetcooldown - 1
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Wait(1000)
        if cooldowntimer >= 0 then
            cooldowntimer = cooldowntimer - 1
        end
    end
end)


local function getGangOwner(source)
    local user_id = HVC.getUserId({source})
    local gangperm = nil
    local loopdone = false
    local gangname = nil
    exports["ghmattimysql"]:execute(
        "SELECT userid, gangname, gangmembers FROM ganginfo",
        {},
        function(callback)
            if #callback > 0 then
                for i = 1, #callback do
                    if loopdone ~= true then
                        local resmon = json.decode(callback[i].gangmembers)
                        for c, v in pairs(resmon.members) do
                            if v.permid == user_id then
                                gangperm = callback[i].userid
                                gangname = tostring(callback[i].gangname)
                                repeat
                                    Wait(100)
                                until gangperm ~= nil and gangname ~= nil
                                loopdone = true
                                return gangperm, gangname
                            end
                        end
                    end
                end
            end
        end
    )
    repeat
        Wait(100)
    until loopdone ~= false
    return gangperm, gangname, user_id
  end

--[[

local function getGangOwner(source)
    local user_id = HVC.getUserId({source})
    local gangperm = nil
    local loopdone = false
    local gangname = nil
    exports["ghmattimysql"]:execute("SELECT userid, gangname, gangmembers FROM ganginfo",{},function(callback)
        if #callback > 0 then
            for i = 1, #callback do
                if loopdone ~= true then 
                    local resmon = json.decode(callback[i].gangmembers)
                    for c, v in pairs(resmon.members) do
                        if v.permid == user_id then
                            gangperm = callback[i].userid
                            gangname = tostring(callback[i].gangname)
                            repeat
                                Wait(100)
                            until gangperm ~= nil and gangname ~= nil
                            loopdone = true
                            return
                        end
                    end
                end
            end
        end
    end)
    repeat
        Wait(100)
    until loopdone ~= false
    return gangperm, gangname, userid
end
]]

RegisterServerEvent("HVC:SetMDMACommission")
AddEventHandler("HVC:SetMDMACommission", function(com1)
    local source = source 
    local Player = GetEntityCoords(GetPlayerPed(source)) 
    local com = tonumber(com1)
    if #(Player - chng) < 2 then 
        local GangOwnerID, GangName, turftaker = getGangOwner(source)
        if GangOwnerID ~= nil then
            if GangOwnerID == turftakinggangid then
                HVCclient.notify(source, {"~r~You Are Still Taking Turf!"})
                return
            end
            if tostring(GangName) == takengang then 
                if turfcomsetcooldown < 0 then
                    if tonumber(com) > 15 then
                        TriggerClientEvent("chatMessage", source, "^1^*HVC", {180, 0, 0},  "The turf commission cannot be set above 15%", "alert")
                        return
                    end 
                    if tonumber(com) < 0 then
                        TriggerClientEvent("chatMessage", source, "^1^*HVC", {180, 0, 0},  "The turf commission cannot be set below 1%", "alert")
                        return
                    end 
                    turfcomsetcooldown = 10
                    turfcom = tonumber(com)  
                    TriggerClientEvent("chatMessage", -1, "", {180, 0, 0}, "^7 MDMA Commission has been set to " .. tostring(turfcom) .. "% by " ..takengang, "alert")
                else 
                    TriggerClientEvent("chatMessage", source, "^1^*HVC", {180, 0, 0},  "The turf commission setting is on a cooldown.", "alert")
                end 
            end 
        end 
    else
        TriggerClientEvent("chatMessage", source, "^1^*HVC", {180, 0, 0},  "You need to be near the " .. turfname, "alert")
    end 
end)



RegisterServerEvent("HVC:EnterMDMATurf")
AddEventHandler("HVC:EnterMDMATurf", function()
    local source = source
    if playersinside[source] == nil then
        local id = HVC.getUserId({source})
        local GangOwnerID, GangName, turftaker = getGangOwner(source)
        if beingtaken == true then
            if GangOwnerID ~= turftakerid and turftakerid ~= 0 then
                enemy = true
            end
        end

        if turftakinggangname ~= 0 then
            if tostring(GangName) == tostring(turftakinggangname) then
                gang = gang + 1
              -- print("[HVC] Gang Member Entered MDMA Turf " ..GetPlayerName(source))
                --print(GangOwnerID, GangName, turftaker)
            end
            if tostring(GangName) ~= tostring(turftakinggangname)  then
                --print(GangOwnerID, GangName, turftaker)
              -- print("[HVC] Enemy Entered MDMA Turf "  ..GetPlayerName(source))
                enemy = true
                enemies = enemies + 1
            end
        end

      -- print("Gang Members: " ..gang)
      -- print("Enemies: " ..tostring(enemy), enemies)
        --print(GangOwnerID, GangName, turftaker)
        --print(source.. " Entered The Zone : " .. GangName)
    playersinside[source] = {id,true,tonumber(GangOwnerID)}
    end
    --print(json.encode(playersinside))
end)




RegisterServerEvent("HVC:LeaveMDMATurf")
AddEventHandler("HVC:LeaveMDMATurf", function()
    local source = source
    if playersinside[source] ~= nil then
        local id = HVC.getUserId({source})
        local zz = 0 
        for i,v in pairs(playersinside) do
             
        end

        local GangOwnerID, GangName, turftaker = getGangOwner(source)
        --print(GangOwnerID, GangName, turftaker)

        --print(GangName, turftakinggangname, GangOwnerID, source)
        if turftakinggangname ~= 0 then
            if tostring(GangName) == tostring(turftakinggangname) then
                gang = gang - 1
              -- print("[HVC] Gang Member Left MDMA Turf " ..GetPlayerName(source))
                --print(GangOwnerID, GangName, turftaker)
            end
            if tostring(GangName) ~= tostring(turftakinggangname)  then
                --print(GangOwnerID, GangName, turftaker)
              -- print("[HVC] Enemy Left MDMA Turf "  ..GetPlayerName(source))
                enemy = true
                enemies = enemies - 1
            end
        end

        if enemies <= 0 then
            enemy = false
        end

      -- print("Gang Members: " ..gang)
      -- print("Enemies: " ..tostring(enemy), enemies)
        playersinside[source] = nil

        if gang <= 0 and beingtaken == true then
          -- print(gang)
          -- print(enemy, enemies)
            TriggerClientEvent("chatMessage", -1, "^1^*HVC", {180, 0, 0}, turftakinggangname .. " has failed to take the " .. turfname, "alert")
            TriggerClientEvent("HVC:SetOuterZoneMDMA", -1, 0)
            turftakerid = 0
            beingtaken = false
            turftakinggangid = 0
            turftakinggangname = 0
            for i,v in pairs(playersinside) do
                local GangOwnerID, GangName, turftaker = getGangOwner(i)
                if turftakerid == GangOwnerID then
                    turftimer = turftimer - 1
                    HVCclient.notify(source, {"~Fail Truf Capture~"})
                end
            end
        end
    end
end)





RegisterServerEvent("HVC:TakeMDMATurf")
AddEventHandler("HVC:TakeMDMATurf", function()
    local source = source 
    if beingtaken ~= true then
        local GangOwnerID, GangName, turftaker = getGangOwner(source)

        if GangName == nil or GangName == "" then
            HVCclient.notify(source, {"~r~Not In Gang"})
            return
        end

        if GangOwnerID ~= nil or GangOwnerID ~= "" then
            if tostring(GangName) == takengang then 
                HVCclient.notify(source, {"You already own the turf"})
                return 
            end 
            if cooldowntimer > 0 then 
                HVCclient.notify(source, {"Turf is on a cooldown. Time left: " .. cooldowntimer})
                return 
            end
            Wait(100)
            TriggerClientEvent("chatMessage", -1, "^1^*HVC", {180, 0, 0}, "The " .. turfname .. " is being taken by " .. GangName .. " !", "alert")
            TriggerClientEvent("HVC:SetOuterZoneMDMA", -1, turfdefaulttime)
            --print("The gang is: " .. GangOwnerID)
            turftakinggangid = GangOwnerID
            turftakinggangname = GangName
            beingtaken = true
            gang = 1
            turftimer = turfdefaulttime
            cooldowntimer = 1800
        else
            HVCclient.notify(source, {"~r~Not In Gang"})
        end
    else
        HVCclient.notify(source, {"~r~Turf Being Taken"})
    end
end)

local function Update(source)
    local source =  source
    local enemies = 0
    local gang2 = 0
    local loopfinished = false
    Wait(2500)
  -- print("Updating Turf")

    for i,v in pairs(playersinside) do
        local GangOwnerID, GangName, turftaker = getGangOwner(i)
      -- print(GangName, turftakinggangname, GetPlayerName(i))
        if tostring(GangName) == tostring(turftakinggangname) then
          -- print("Gang Member Added " ..GangName, GetPlayerName(i))
            gang2 = gang2 + 1
          -- print(gang)
        end
    end

    if gang2 <= 0 and beingtaken == true then
        TriggerClientEvent("chatMessage", -1, "^1^*HVC", {180, 0, 0}, turftakinggangname .. " has failed to take the " .. turfname, "alert")
        TriggerClientEvent("HVC:SetOuterZoneMDMA", -1, 0)
        turftakerid = 0
        beingtaken = false
        for i,v in pairs(playersinside) do
            local GangOwnerID, GangName, turftaker = getGangOwner(i)
            if turftakerid == GangOwnerID then
            turftimer = turftimer - 1
            HVCclient.notify(i, {"Gang Failed To Take Turf"})
            end
        end
    end
end




RegisterServerEvent("HVC:RefreshMDMATurf")
AddEventHandler("HVC:RefreshMDMATurf", function()
    Update(source)
end)





Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if enemy == true then
            for i,v in pairs(playersinside) do
                local GangOwnerID, GangName, turftaker = getGangOwner(i)
                if turftakerid == GangOwnerID and tonumber(turftakerid) ~= 0 then
                    --HVCclient.notify(i, {"~r~Enemies In Turf"})
                end
                if tonumber(turftakerid) ~= tonumber(GangOwnerID) and tonumber(turftakerid) ~= 0 then
            
                else
                    enemy = false
                end
            end
        end

        for i,v in pairs(playersinside) do
            local GangOwnerID, GangName, turftaker = getGangOwner(i)
            if tonumber(turftakerid) ~= tonumber(GangOwnerID) and tonumber(turftakerid) ~= 0 then
                enemy = true
            end
        end

        if beingtaken == true and enemy ~= true  then
            turftimer = turftimer - 1
            for i,v in pairs(playersinside) do
        
            end

            if turftimer == 0 then
                beingtaken = false
                TriggerClientEvent("chatMessage", -1, "^1^*HVC", {180, 0, 0}, "The " .. turfname .. " has been taken by " .. turftakinggangname .. " !", "alert")
                turftakerid = turftakinggangid
                takengang = turftakinggangname

                turftakinggangid = 0
                turftakinggangname = 0
                
                TriggerClientEvent("HVC:SetOuterZoneMDMA", -1, 0)
                turfcooldown = true 
                turftaken = true
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do 
        Wait(1000)
        if turfcooldown == true then 
            cooldowntimer = cooldowntimer - 1
            if cooldowntimer < 0 then 
                turfcooldown = false
                cooldowntimer = 1800
            end
        end
    end
end)