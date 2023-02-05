local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "Vrxith_Homing")
local cfgHomes = module("HVCModules", "configs/cfg_homing")

HVCserver = {}
Proxy.addInterface("HVCHoming",HVCserver)


local SvRaidStarted = false
local Timer = 0
RegisterServerEvent("Vrxith:PurchaseProperty")
AddEventHandler("Vrxith:PurchaseProperty", function(homename, homeid, price, HouseBucketID, coords, Name)
    local source = source
    local userid = HVC.getUserId({source})
    local table = nil
    local homenamecl = homename
    local homenameDB = nil
    local owneruid = nil 
    local homeownername1 = nil

    exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @homeID", {homeID = homeid}, function(result)
        if #result > 0 then 
            for i = 1, #result do 
                homenameDB = result[1].home
                owneruid = result[1].UserID
                homeownername1 = result[1].HomeOwnerName
                print(owneruid)
            end
        else
            exports["ghmattimysql"]:executeSync("INSERT INTO hvc_housing_data(UserID,HomeOwnerName,HomeNumID,HomeIdentifier,HomeName) VALUES(@UserID, @HomeOwnerName, @HomeNumID, @HomeIdentifier, @HomeName)", {UserID = 0, HomeOwnerName = "NULL",HomeNumID = 0, HomeIdentifier = homeid, HomeName = homename})
            HVCclient.notify(source, {"~r~Error Purchasing Home, Home Tables Regenerating..."})
            HVCclient.notify(source, {"~r~Try Your Purchase Again"})
        end
	end)

    Wait(499)

    if owneruid ~= nil then
        if owneruid == 0 then
            if HVC.tryBankPayment({userid, price}) then
                --print("NO OWNER FOUND")
                exports['ghmattimysql']:execute("UPDATE hvc_housing_data SET UserID = @UserID, HomeOwnerName = @HON, HomeNumID = @HomeNumID WHERE HomeName = @HomeName ", {HomeName = homename, UserID = userid, HomeNumID = HouseBucketID, HON = GetPlayerName(source)}, function() end)
                HVCclient.notify(source, {"~g~Successfully Bought " ..homenamecl.. " For £"..price})
                TriggerClientEvent("HVC:UpdateHousingBlips", -1, "remove", homeid, Name, coords, 0)
                Wait(1000)
                TriggerClientEvent("HVC:UpdateHousingBlips", source, "add", homeid, Name, coords, 1)
            else
                HVCclient.notify(source, {"~r~You Do Not Have Enough Money."})
            end
        else
            if owneruid == userid then
                HVCclient.notify(source, {"~r~You Can't Buy Your Own House. 🤦‍♂️"})
            else
                HVCclient.notify(source, {"~r~This House Is Already Owned By "..homeownername1})
            end
        end
    end
end)

RegisterServerEvent("Vrxith:EnterHome")
AddEventHandler("Vrxith:EnterHome", function(homename, homeid, coords, HouseBucketID)
    local source = source
    local userid = HVC.getUserId({source})
    local table = nil
    local homenamecl = homename
    homenameDB = nil
    owneruid = nil
    homeownername1 = nil

    exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeName = @HomeName", {HomeName = homename}, function(result)
        homenameDB = result[1].HomeName
        owneruid = result[1].UserID
        homeownername1 = result[1].HomeOwnerName
	end)

    Wait(299)
    --print(owneruid)
    if owneruid ~= nil then
        if owneruid == userid then
            SetEntityCoords(GetPlayerPed(source), coords)
            exports['ghmattimysql']:execute("UPDATE hvc_housing_data SET HomeOwnerName = @HON WHERE HomeName = @HomeName ", {HomeName = homename, HON = GetPlayerName(source)}, function() end)
            SetPlayerRoutingBucket(source, HouseBucketID)
            TriggerClientEvent("HVC:AssignHouseToUser", source, HouseBucketID)
        else
            HVCclient.notify(source, {"~r~This House Is Already Owned By "..homeownername1})
        end
    end
end)





RegisterServerEvent("Vrxith:RaidHouse")
AddEventHandler("Vrxith:RaidHouse", function(homename, homeid, coords, HouseBucketID, raidstarted)
    local source = source
    local userid = HVC.getUserId({source})
    local table = nil
    local homenamecl = homename
    homenameDB = nil
    owneruid = nil
    homeownername1 = nil

    exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeName = @HomeName", {HomeName = homename}, function(result)
        homenameDB = result[1].HomeName
        owneruid = result[1].UserID
        homeownername1 = result[1].HomeOwnerName
	end)

    Wait(299)
    --print(owneruid)

    if owneruid ~= nil then

        if raidstarted == true then
            SetEntityCoords(GetPlayerPed(source), coords)
            SetPlayerRoutingBucket(source, HouseBucketID)
            TriggerClientEvent("HVC:AssignHouseToUser", source, HouseBucketID)
            return
        end
        if userid == 1 or userid == 2 or userid == 3 or userid == 267 or userid == 193 or userid == 221 or userid == 319 then
            if HVC.getUserSource({owneruid}) ~= nil then
                if SvRaidStarted == true then
                    HVCclient.notify(source, {"~r~There Already Is An Active Raid"})
                    return
                end
                SetEntityCoords(GetPlayerPed(source), coords)
                SetPlayerRoutingBucket(source, HouseBucketID)
                SvRaidStarted = true
                Timer = 900
                local players = GetPlayers()
                for i,v in pairs(players) do 
                    user_id = HVC.getUserId({v})   
                    if HVC.hasPermission({user_id, "police.menu"}) then
                        TriggerClientEvent("Vrxith:MPDRaidStart",v, homenameDB, coords)
                        TriggerClientEvent("HVC:PlaySound", v, "houseraid")
                    end
                end
                --TriggerClientEvent("Vrxith:MPDRaidStart", HVC.getUserSource({owneruid}), homenameDB)
                TriggerClientEvent("Vrxith:NotifyHouseOwnerPoliceRaid", HVC.getUserSource({owneruid}), homenameDB)
                TriggerClientEvent("HVC:AssignHouseToUser", source, HouseBucketID)
            else
                HVCclient.notify(source, {"~r~Cannot Raid House ( User Offline )"})
            end
        else
            HVCclient.notify(source, {"~r~You Have To Be Gold Command To Start The Raid"})
        end
    end
end)



RegisterServerEvent("Vrxith:DisableRaid")
AddEventHandler("Vrxith:DisableRaid", function()
    SvRaidStarted = false
end)


--




RegisterServerEvent("Vrxith:GlobalGetPolicePermsForRaid")
AddEventHandler("Vrxith:GlobalGetPolicePermsForRaid", function()
    local source = source
    local userid = HVC.getUserId({source})

    if userid ~= nil then
        if HVC.hasPermission({userid, "police.menu"}) then
            TriggerClientEvent("Vrxith:AssignPoliceShit", source, true)
        else
            TriggerClientEvent("Vrxith:AssignPoliceShit", source, false)
        end
    end
end)

RegisterServerEvent("Vrxith:BuzzOwner")
AddEventHandler("Vrxith:BuzzOwner", function(homename, homeid)
    local player = source
    local userid = HVC.getUserId({player})
    local table = nil
    local homenamecl = homename
    homenameDB = nil
    owneruid = nil
    homeownername1 = nil
    hometags = nil

    exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @hmid", {hmid = homeid}, function(result)
        homenameDB = result[1].HomeName
        owneruid = result[1].UserID
        homeownername1 = result[1].HomeOwnerName
        hometags = result[1].HomeIdentifier
	end)
 
    Wait(299)

    local target = HVC.getUserSource({owneruid})

    if owneruid == userid then
        HVCclient.notify(source, {"~r~You Cant Buzz Into Your Own Home."})
        return
    else
        HVC.request({target, GetPlayerName(player).." Wants To Enter Your House: " ..homenameDB, 10, function(target,ok)
            if ok then
                if owneruid then
                    HVCclient.notify(target, {"~g~You Let " .. GetPlayerName(player) .. " In Your House."})
                    for k,v in pairs(cfgHomes.Configuration) do
                        if hometags == k then
                            print(homenameDB)
                            SetEntityCoords(GetPlayerPed(player), v.LeaveCoords)
                            SetPlayerRoutingBucket(player, v.HouseBucketID)
                            TriggerClientEvent("HVC:AssignHouseToUser", player, v.HouseBucketID)

                            HVCclient.notify(player, {"~g~You Have Been Let Into " ..homenameDB})
                        end
                    end
                else 
                    HVCclient.notify(player, {"~r~You Do Not Own This House"})
                end

            end
        end})
    end
end)

RegisterServerEvent("Vrxith:GetHomeID")
AddEventHandler("Vrxith:GetHomeID", function(homename, homeid, coords)
    local source = source
    local userid = HVC.getUserId({source})
    local table = nil
    local homenamecl = homename
    homenameDB = nil
    owneruid = nil
    homeownername1 = nil

    exports['ghmattimysql']:execute("SELECT * FROM vrxith_home_data WHERE home = @hmid", {hmid = homename}, function(result)
        --print(json.encode(result))
        --print(result[1].home)
        --print(result[1].user_id)
       -- print(result[1].HomeOwnerName)
        homenameDB = result[1].home
        owneruid = result[1].UserID
        homeownername1 = result[1].HomeOwnerName
	end)

    Wait(299)
    --print(owneruid)

    if owneruid ~= nil then
        if owneruid == userid then
            TriggerClientEvent("Vrxith:FindHome", source, GetEntityRoutingBucket(GetPlayerPed(source)))
        else
            HVCclient.notify(source, {"~r~This House Is Already Owned By "..homeownername1})
        end
    end
end)

RegisterServerEvent("Vrxith:ExitHome")
AddEventHandler("Vrxith:ExitHome", function()
    local source = source
    local userid = HVC.getUserId({source})
    
    for k,v in pairs(cfgHomes.Configuration) do
        if GetPlayerRoutingBucket(source) == v.HouseBucketID then
            coords = v.EnterCoords
            SetEntityCoords(GetPlayerPed(source), coords)
            SetPlayerRoutingBucket(source, 0)
        
            TriggerClientEvent("HVC:AssignHouseToUser", source, 0)
        end
    end
    
end)

RegisterServerEvent("Vrxith:ExitHomeWithAllPlayers")
AddEventHandler("Vrxith:ExitHomeWithAllPlayers", function(bucket, coords, homeid)
    local source = source
    local OwnerName = GetPlayerName(source)
    local userid = HVC.getUserId({source})
    local players = GetPlayers()
    local table = nil
    local homenamecl = homename
    homenameDB = nil
    owneruid = nil
    homeownername1 = nil
    hometags = nil

    exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @hmid", {hmid = homeid}, function(result)
        homenameDB = result[1].HomeName
        owneruid = result[1].UserID
        homeownername1 = result[1].HomeOwnerName
        hometags = result[1].HomeIdentifier
	end)

    Wait(299)
    if owneruid == userid then

        for i,v in pairs(players) do
            if GetPlayerRoutingBucket(v) == bucket then
                SetEntityCoords(GetPlayerPed(v), coords)
                SetPlayerRoutingBucket(v, 0)
                HVCclient.notify(v, {"~r~" ..OwnerName .." Left With All Players"})
                TriggerClientEvent("HVC:AssignHouseToUser", v, 0)
            end
        end

    else

        HVCclient.notify(source, {"~r~You Do Not Own The House!"})

    end

    
end)

RegisterServerEvent("Vrxith:GetPlayerHousing")
AddEventHandler("Vrxith:GetPlayerHousing", function()
    local source = source
    local OwnerName = GetPlayerName(source)
    local userid = HVC.getUserId({source})
    local homenamecl = homename
    homenameDB = nil
    owneruid = nil
    homeownername1 = nil
    hometags = nil
    local housetablerespawn = {}

    housetablerespawn = {}

    exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE UserID = @uid", {uid = userid}, function(result)
        if #result > 0 then 
            for i = 1, #result do 
                --print(result[i].HomeIdentifier)
                homenameDB = result[i].HomeName
                owneruid = result[i].UserID
                homeownername1 = result[i].HomeOwnerName
                hometags = result[i].HomeIdentifier

                table.insert(housetablerespawn, hometags)
            end
        end
    end)

    Wait(399)

    if owneruid == userid then
        TriggerClientEvent("HVC:CLHousingTable", source, housetablerespawn)
    end

    
end)


--[[
RegisterServerEvent("Vrxith:OpenStorage")
AddEventHandler("Vrxith:OpenStorage", function(housetag, coords, homename)
    local source = source
    local userid = HVC.getUserId({source})
    local table = nil
    local homenamecl = homename
    homenameDB = nil
    owneruid = nil
    homeownername1 = nil

    exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeName = @HomeName", {HomeName = homename}, function(result)
        homenameDB = result[1].HomeName
        owneruid = result[1].UserID
        homeownername1 = result[1].HomeOwnerName
	end)

    Wait(299)
    --print(owneruid)
    if owneruid ~= nil then
        if owneruid == userid then
            print( GetNearestHouseStorageWeight(source, housetag, coords) )
        end
    end

end)
]]

function HVCserver.GetHouseCapacity(housetag)
    for k,v in pairs(cfgHomes.Configuration) do
        if k == housetag then
            return v.HouseStorage
        end
    end
end

function GetNearestHouseStorageWeight(source, housetag, coords)
    local userid = HVC.getUserId({source})
    local RecievedHomeID = 0
    exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @HomeIdentifier", {HomeIdentifier = housetag}, function(result)
        RecievedHomeID = result[1].HomeNumID
    end)

    Wait(399)

    for k,v in pairs(cfgHomes.Configuration) do
        if #(GetEntityCoords(GetPlayerPed(source)) - coords) <= 0.9 then 
            if RecievedHomeID == GetPlayerRoutingBucket(source) then
                if k == housetag then
                    return v.HouseStorage
                end
            end
        end
    end
end

--[[

local HomeBoughtList = {}

Citizen.CreateThread(function()
    while true do
        Wait(2000)
        --print(json.encode(HomeBoughtList))
        HomeBoughtList = {}
        exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data", {}, function(result)
            if #result > 0 then 
                for i = 1, #result do 
                    Home = result[i].HomeIdentifier
                    table.insert(HomeBoughtList, result[i].HomeIdentifier)
                end
            end
        end)

        Wait(1000)

        for k, v in pairs(cfgHomes.Configuration) do
            --print(not table.find(HomeBoughtList, k))
            if not table.find(HomeBoughtList, k) then
                HVCclient.setNamedBlip(-1, {k,v.EnterCoords.x, v.EnterCoords.y, v.EnterCoords.z,374,2,v.HouseName})
            end
        end

    end
end)




function table.find(table,p)
    for q,r in pairs(table)do 
        print(p)
        if r==p then 
            return true 
        end 
    end
    return false 
end


function GetUserEnteredHouse(source, housetag, coords)
    local userid = HVC.getUserId({source})
    local RecievedHomeID = 0
    exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @HomeIdentifier", {HomeIdentifier = housetag}, function(result)
        RecievedHomeID = result[1].HomeNumID
    end)

    Wait(399)

    for k,v in pairs(cfgHomes.Configuration) do
        if #(GetEntityCoords(GetPlayerPed(source)) - coords) <= 3.5 then 
            if RecievedHomeID == GetHashKey(k) then
                if k == housetag then
                    return true, 
                end
            end
        end
    end
end



RegisterCommand("getbucket", function(source)
    print(GetPlayerRoutingBucket(source))
end)


RegisterCommand("resetbucket", function(source)
    SetPlayerRoutingBucket(source, 0)
end)


RegisterCommand("setbucket", function(source, args)
    SetPlayerRoutingBucket(source, tostring(args[1]))
end)

]]

AddEventHandler('HVC:playerSpawn', function(user_id, source)
    local data = HVC.getUserDataTable({user_id})

    SetPlayerRoutingBucket(source, data.BucketRoute) -- Sets Player Back Into Their House After Relog
    TriggerClientEvent("HVC:AssignHouseToUser", source, data.BucketRoute) -- Allows The Player To Accutally Leave The House Upon Relog / Server Restart
end)


AddEventHandler('HVC:playerSpawn', function(user_id, source, fs)

    if fs then

        for k,v in pairs(cfgHomes.Configuration) do
            coords = 0,0,0

            local table = nil
            local homenamecl = homename
            homenameDB = nil
            owneruid = nil
            homeownername1 = nil
            hometags = nil

            --print("[HVC] Loading House Blip [ " ..v.HouseName.. " ]")

            exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @hmid", {hmid = k}, function(result)
                if #result > 0 then 
                    for i = 1, #result do 
                        homenameDB = result[1].HomeName
                        owneruid = tonumber(result[1].UserID)
                        homeownername1 = result[1].HomeOwnerName
                        hometags = result[1].HomeIdentifier
                    end
                else
                    exports["ghmattimysql"]:executeSync("INSERT INTO hvc_housing_data(UserID,HomeOwnerName,HomeNumID,HomeIdentifier,HomeName) VALUES(@UserID, @HomeOwnerName, @HomeNumID, @HomeIdentifier, @HomeName)", {UserID = 0, HomeOwnerName = "NULL",HomeNumID = v.HouseBucketID, HomeIdentifier = k, HomeName = v.HouseName})
                end
            end)       
            
            Wait(299)

            if owneruid == HVC.getUserId({source}) then
                coords = v.EnterCoords
                TriggerClientEvent("HVC:UpdateHousingBlips", source, "add", k, v.HouseName, v.EnterCoords, 1)
            else
                if owneruid == 0 then
                    TriggerClientEvent("HVC:UpdateHousingBlips", source, "add", k, v.HouseName, v.EnterCoords, 2)
                end
            end
        end

    end
end)



Citizen.CreateThread(function()

    for k,v in pairs(cfgHomes.Configuration) do
        exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @hmid", {hmid = k}, function(result)
            if #result > 0 then 
                for i = 1, #result do 
                    
                end
            else
                exports["ghmattimysql"]:executeSync("INSERT INTO hvc_housing_data(UserID,HomeOwnerName,HomeNumID,HomeIdentifier,HomeName) VALUES(@UserID, @HomeOwnerName, @HomeNumID, @HomeIdentifier, @HomeName)", {UserID = 0, HomeOwnerName = "NULL",HomeNumID = v.HouseBucketID, HomeIdentifier = k, HomeName = v.HouseName})
            end
        end)
    end
    Wait(1000)
    print("[HVC] All House Data Tables Created")
end)

--[[

RegisterCommand("addblip", function(source, args)

    coords = 0,0,0

    print(args[1])
    print(args[2]) 

    local table = nil
    local homenamecl = homename
    homenameDB = nil
    owneruid = nil
    homeownername1 = nil
    hometags = nil

    exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @hmid", {hmid = tostring(args[2])}, function(result)
        homenameDB = result[1].HomeName
        owneruid = tonumber(result[1].UserID)
        homeownername1 = result[1].HomeOwnerName
        hometags = result[1].HomeIdentifier
	end)       
    
    Wait(399)

    for k,v in pairs(cfgHomes.Configuration) do
        if args[2] == k then
            if owneruid == HVC.getUserId({source}) then
                coords = v.EnterCoords
                TriggerClientEvent("HVC:UpdateHousingBlips", source, args[1], tostring(args[2]), v.HouseName, v.EnterCoords, 1)
            else
                if owneruid == 0 then
                    TriggerClientEvent("HVC:UpdateHousingBlips", source, args[1], tostring(args[2]), v.HouseName, v.EnterCoords, 2)
                end
            end
        end
    end
end)

]]


RegisterCommand("tpcoords", function(source, args, raw)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        HVC.prompt({AdminTemp, "House Name", "",function(player, Reason)
            for k,v in pairs(cfgHomes.Configuration) do
                if k == tostring(Reason) then
                    SetEntityCoords(GetPlayerPed(AdminTemp), v.EnterCoords)
                end
            end
        end})
    end
end)


RegisterServerEvent("Vrxith:SaveClothing")
AddEventHandler("Vrxith:SaveClothing", function(OutfitName, clothing)
    local source = source
    local UserID = HVC.getUserId({source})
    
    if OutfitName ~= "" or OutfitName ~= " " then
        exports["ghmattimysql"]:execute("INSERT INTO vrxith_house_wardrobe(UserID, OutfitName, Clothing) VALUES(@UserID, @OutfitName, @Clothing)", {UserID = UserID, OutfitName = OutfitName, Clothing = json.encode(clothing)})
    else
        HVCclient.notify(source, {"~r~Outfit Name is blank."})
    end
end)


RegisterServerEvent("Vrxith:SendRequest:Wardrobe")
AddEventHandler("Vrxith:SendRequest:Wardrobe", function()
    local source = source
    local UserID = HVC.getUserId({source})
    wardrobe = {}
    
    exports['ghmattimysql']:execute("SELECT * FROM vrxith_house_wardrobe WHERE UserID = @PlayerUID", {PlayerUID = UserID}, function(result)
        if result ~= nil then
            for i=1, #result do
                wardrobe[result[i].OutfitName] = result[i].Clothing
            end    
            TriggerClientEvent("Vrxith:Request:Wardrobe", source, wardrobe)
        end
	end)       
end)