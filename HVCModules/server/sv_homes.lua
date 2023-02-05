--[[local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "Vrxith_Homing")
local inventory = exports.inventory

RegisterServerEvent("Vrxith:PurchaseProperty")
AddEventHandler("Vrxith:PurchaseProperty", function(homename, homeid, price)
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
       -- print(result[1].homeownername)
        homenameDB = result[1].home
        owneruid = result[1].user_id
        homeownername1 = result[1].homeownername
	end)

    Wait(299)
    print(owneruid)

    if owneruid == 0 then
        if HVC.tryBankPayment({userid, 15000000}) then
            --print("NO OWNER FOUND")
            exports['ghmattimysql']:execute("INSERT INTO tbl_user_storages(user_id, storage_id, is_primary) VALUES(@user_id, @sid, @primary)", {user_id = userid, sid = homeid, primary = false}, function() end)
            exports['ghmattimysql']:execute("UPDATE vrxith_home_data SET user_id = @user_id, homeownername = @HON WHERE home = @hn ", {hn = homename, user_id = userid, HON = GetPlayerName(source)}, function() end)

            HVCclient.notify(source, {"~g~Successfully Bought " ..homenamecl.. " For £"..price})
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
end)


RegisterServerEvent("Vrxith:OpenHouseStorage")
AddEventHandler("Vrxith:OpenHouseStorage", function(homename, homeid)
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
       -- print(result[1].homeownername)
        homenameDB = result[1].home
        owneruid = result[1].user_id
        homeownername1 = result[1].homeownername
	end)

    Wait(299)
    --print(owneruid)

    if owneruid == userid then
        TriggerClientEvent("Vrxith:OpenBootCL", source, homeid)
    else
        HVCclient.notify(source, {"~r~This House Is Already Owned By "..homeownername1})
    end
end)
--


RegisterServerEvent("Vrxith:EnterHome")
AddEventHandler("Vrxith:EnterHome", function(homename, homeid, coords)
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
       -- print(result[1].homeownername)
        homenameDB = result[1].home
        owneruid = result[1].user_id
        homeownername1 = result[1].homeownername
	end)

    Wait(299)
    --print(owneruid)

    if owneruid == userid then
        SetEntityCoords(GetPlayerPed(source), coords)
        --print("Home HASHED: "..GetHashKey(homename))
        SetPlayerRoutingBucket(source, homeid)
    else
        HVCclient.notify(source, {"~r~This House Is Already Owned By "..homeownername1})
    end
end)
--

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
       -- print(result[1].homeownername)
        homenameDB = result[1].home
        owneruid = result[1].user_id
        homeownername1 = result[1].homeownername
	end)

    Wait(299)
    --print(owneruid)

    if owneruid == userid then
        TriggerClientEvent("Vrxith:FindHome", source, GetEntityRoutingBucket(GetPlayerPed(source)))
    else
        HVCclient.notify(source, {"~r~This House Is Already Owned By "..homeownername1})
    end
end)

RegisterServerEvent("Vrxith:ExitHome")
AddEventHandler("Vrxith:ExitHome", function(homename, homeid, coords)
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
       -- print(result[1].homeownername)
        homenameDB = result[1].home
        owneruid = result[1].user_id
        homeownername1 = result[1].homeownername
	end)



    SetEntityCoords(GetPlayerPed(source), coords)
    SetPlayerRoutingBucket(source, 0)
end)
--

]]