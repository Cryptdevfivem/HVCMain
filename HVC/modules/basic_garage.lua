-- -- a basic garage implementation
-- -- vehicle db
local cfg = module("cfg/garages")
local inventory = exports.inventory
local cfg_inventory = module("cfg/inventory")
local vehicle_groups = cfg.garage_types
local limit = cfg.limit or 100000000
MySQL.createCommand("HVC/add_vehicle","INSERT IGNORE INTO hvc_user_vehicles(user_id,vehicle,vehicle_plate) VALUES(@user_id,@vehicle,@registration)")
MySQL.createCommand("HVC/remove_vehicle","DELETE FROM hvc_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("HVC/get_vehicles", "SELECT vehicle, rentedtime FROM hvc_user_vehicles WHERE user_id = @user_id AND rented = 0")
MySQL.createCommand("HVC/get_rented_vehicles_in", "SELECT vehicle, rentedtime, user_id FROM hvc_user_vehicles WHERE user_id = @user_id AND rented = 1")
MySQL.createCommand("HVC/get_rented_vehicles_out", "SELECT vehicle, rentedtime, user_id FROM hvc_user_vehicles WHERE rentedid = @user_id AND rented = 1")
MySQL.createCommand("HVC/get_vehicle","SELECT vehicle FROM hvc_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("HVC/check_rented","SELECT * FROM hvc_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle AND rented = 1")
MySQL.createCommand("HVC/sell_vehicle_player","UPDATE hvc_user_vehicles SET user_id = @user_id, vehicle_plate = @registration WHERE user_id = @oldUser AND vehicle = @vehicle")
MySQL.createCommand("HVC/rentedupdate", "UPDATE hvc_user_vehicles SET user_id = @id, rented = @rented, rentedid = @rentedid, rentedtime = @rentedunix WHERE user_id = @user_id AND vehicle = @veh")
MySQL.createCommand("HVC/fetch_rented_vehs", "SELECT * FROM hvc_user_vehicles WHERE rented = 1")

Citizen.CreateThread(function()
    while true do
        Wait(300000)
        MySQL.query('HVC/fetch_rented_vehs', {}, function(pvehicles)
            for i,v in pairs(pvehicles) do 
               if os.time() > tonumber(v.rentedtime) then
                  MySQL.execute('HVC/rentedupdate', {id = v.rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = v.user_id, veh = v.vehicle})
               end
            end
        end)
        --print('[HVC] Vehicle Rent Check | Successful')
    end
end)

RegisterNetEvent('HVC:FetchCars')
AddEventHandler('HVC:FetchCars', function(owned, type)
    local source = source
    local user_id = HVC.getUserId(source)
    local returned_table = {}
    if user_id then
        if not owned then
            for i, v in pairs(vehicle_groups) do
                local noperms = false;
                local config = vehicle_groups[i]._config
                if config.vtype == type then 
                    local perm = config.permissions or nil
                    if perm then
                        for i, v in pairs(perm) do
                            if not HVC.hasPermission(user_id, v) then
                                noperms = true;
                            end
                        end
                    end
                    if not noperms then 
                        returned_table[i] = {
                            ["config"] = config
                        }
                        returned_table[i].vehicles = {}
                        for a, z in pairs(v) do
                            if a ~= "_config" then
                                returned_table[i].vehicles[a] = {z[1], z[2]}
                            end
                        end
                    end
                end 
            end
            TriggerClientEvent('HVC:ReturnFetchedCars', source, returned_table)
        else
            MySQL.query("HVC/get_vehicles", {
                user_id = user_id
            }, function(pvehicles, affected)
                for _, veh in pairs(pvehicles) do
                    for i, v in pairs(vehicle_groups) do
                        local noperms = false;
                        local config = vehicle_groups[i]._config
                        if config.vtype == type then 
                            local perm = config.permissions or nil
                            if perm then
                                for i, v in pairs(perm) do
                                    if not HVC.hasPermission(user_id, v) then
                                        noperms = true;
                                    end
                                end
                            end
                            if not noperms then 
                                for a, z in pairs(v) do
                                    if a ~= "_config" and veh.vehicle == a then
                                        if not returned_table[i] then 
                                            returned_table[i] = {
                                                ["config"] = config
                                            }
                                        end
                                        if not returned_table[i].vehicles then 
                                            returned_table[i].vehicles = {}
                                        end
                                        returned_table[i].vehicles[a] = {z[1]}
                                    end
                                end
                            end
                        end
                    end
                end
                TriggerClientEvent('HVC:ReturnFetchedCars', source, returned_table)
            end)
        end
    end
end)





RegisterServerEvent("HVC:FetchFolders")
AddEventHandler('HVC:FetchFolders', function()
    local source = source
    local PlayerID = HVC.getUserId(source)
    local Folders = {}
    exports["ghmattimysql"]:execute("SELECT * from `vrxith_custom_garages` WHERE UserID = @ID", {ID = PlayerID}, function(Result)
        if #Result > 0 then
            print(Result[1].Folder)
            TriggerClientEvent("HVC:ReturnFolders", source, json.decode(Result[1].Folder))
        end
    end)
end)


RegisterServerEvent("HVC:UpdateFolders")
AddEventHandler('HVC:UpdateFolders', function(FolderUpdated)
    local source = source
    local PlayerID = HVC.getUserId(source)

    exports["ghmattimysql"]:execute("SELECT * from `vrxith_custom_garages` WHERE UserID = @ID", {ID = PlayerID}, function(Result)
        if #Result > 0 then
            -- print(Result[1].Folder)
            exports['ghmattimysql']:execute("UPDATE vrxith_custom_garages SET Folder = @Folder WHERE UserID = @UserID", {Folder = json.encode(FolderUpdated), UserID = PlayerID}, function() end)
        else
            exports['ghmattimysql']:execute("INSERT INTO vrxith_custom_garages (`UserID`, `Folder`) VALUES (@UserID, @Folder);", {UserID = PlayerID, Folder = json.encode(FolderUpdated)}, function() end)
        end
    end)
end)


RegisterNetEvent("HVC:SpawnGarageVehicle")
AddEventHandler("HVC:SpawnGarageVehicle", function(spawn,vtype)
    local source = source
    local user_id = HVC.getUserId(source)
    local name = GetPlayerName(source)
    local ped = GetPlayerPed(source)
    local VehicleHash = GetHashKey(spawn)
    local Location = GetEntityCoords(ped)
    for k,v in pairs(cfg.garages) do
        if #(vec3(Location) - vec3(v[2],v[3],v[4])) < 3.0 then
            MySQL.query("HVC/get_vehicle", {user_id = user_id, vehicle = spawn}, function(pveh)
                if #pveh > 0 then 
                    local nveh = CreateVehicle(VehicleHash, Location + 0.5, 0.0, true, false)
                    while not DoesEntityExist(nveh) do
                        Citizen.Wait(0)
                    end
                    local id = NetworkGetNetworkIdFromEntity(nveh)
                    HVCclient.FinishVehicleSpawning(source,{spawn,id,vtype})
                    exports["ghmattimysql"]:execute("SELECT vehicle_plate FROM hvc_user_vehicles WHERE user_id = @user_id and vehicle = @vehicle", {user_id = user_id, vehicle = spawn}, function(Result)
                        if Result[1].vehicle_plate ~= "" then
                            SetVehicleNumberPlateText(nveh, Result[1].vehicle_plate)
                        else
                            SetVehicleNumberPlateText(nveh, "HVC"..math.random(10009, 10021))
                        end
                     end)
                else
                    MySQL.query("HVC/check_rented", {user_id = user_id, vehicle = name}, function(pvehicles)
                        if #pvehicles > 0 then
                            local nveh = CreateVehicle(mhash, Location + 0.5, 0.0, true, false)
                            while not DoesEntityExist(nveh) do
                                Citizen.Wait(0)
                            end
                            local id = NetworkGetNetworkIdFromEntity(nveh)
                            HVCclient.FinishVehicleSpawning(source,{spawn,id,vtype})
                        else
                            local BanTime = os.time()
                            CurrentTime = BanTime + (60 * 60 * 500000)
                            HVC.BanUser(source, "Type #Garage Trigger", BanTime, "HVC")
                        end
                    end)
                end
            end)
        end
    end
end)


RegisterNetEvent('HVC:BuyVehicle')
AddEventHandler('HVC:BuyVehicle', function(vehicle)
    local source = source
    local user_id = HVC.getUserId(source)
    for i, v in pairs(vehicle_groups) do
        local config = vehicle_groups[i]._config
        local perm = config.permissions or nil
        if perm then
            for i, v in pairs(perm) do
                if not HVC.hasPermission(user_id, v) then
                    break
                end
            end
        end
        for a, z in pairs(v) do
            if a ~= "_config" and a == vehicle then
                if HVC.tryFullPayment(user_id,z[2]) then 
                    HVCclient.notify(source,{'~g~You have purchased: ' .. z[1] .. ' for: £' .. z[2]})
                    HVC.getUserIdentity(user_id, function(identity)					
                        MySQL.execute("HVC/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = "P "..identity.registration})
                    end)
                    return 
                else 
                    HVCclient.notify(source,{'~r~You do not have enough money to purchase this vehicle! It costs: £' .. z[2]})
                    TriggerClientEvent('HVC:CloseGarage', source)
                    return 
                end
            end
        end
    end
    return HVCclient.notify(source,{'~r~An error has occured please try again later.'})
end)


RegisterServerEvent("vehmenu:opentrunk")
AddEventHandler("vehmenu:opentrunk",function()
    local player = source
    local user_id = HVC.getUserId(source)
    HVCclient.getNearestOwnedVehicle(player,{7},function(ok,vtype,name)
        if ok then
          local chestname = "u"..user_id.."veh_"..string.lower(name)
          local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight
          HVCclient.vc_openDoor(player, {vtype,5})
          HVC.openChest(player, chestname, max_weight, function()
            HVCclient.vc_closeDoor(player, {vtype,5})
          end)
        else
            HVCclient.notify(player, {"~r~You don't own this vehicle"})
        end
    end)
end)

RegisterServerEvent("vehmenu:closetrunk")
AddEventHandler("vehmenu:closetrunk",function()
    local player = source
    local user_id = HVC.getUserId(source)
    HVCclient.getNearestOwnedVehicle(player,{7},function(ok,vtype,name)
        if ok then
            HVCclient.vc_closeDoor(player, {vtype,5})
        else
            HVCclient.notify(player, {"~r~You don't own this vehicle"})
        end
    end)
end)

RegisterServerEvent("vehmenu:repair")
AddEventHandler("vehmenu:repair",function()
    local player = source
    local user_id = HVC.getUserId(source)
    HVCclient.getNearestOwnedVehicle(player,{7},function(ok,vtype,name)
        if ok then
            HVCclient.notify(player, {"~r~The vehicle is too badly damaged"})
        else
            HVCclient.notify(player, {"~r~You don't own this vehicle"})
        end
    end)
end)


RegisterNetEvent('HVC:ScrapVehicle')
AddEventHandler('HVC:ScrapVehicle', function(vehicle)
    local source = source
    local user_id = HVC.getUserId(source)
    if user_id then 
        MySQL.query("HVC/check_rented", {user_id = user_id, vehicle = vehicle}, function(pvehicles)
            MySQL.query("HVC/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pveh)
                if #pveh < 0 then 
                    HVCclient.notify(source,{"~r~You cannot destroy a vehicle you do not own!"})
                    return
                end
                if #pvehicles > 0 then 
                    HVCclient.notify(source,{"~r~You cannot destroy a rented vehicle!"})
                    return
                end
                MySQL.execute('HVC/remove_vehicle', {user_id = user_id, vehicle = vehicle})
                TriggerClientEvent('HVC:CloseGarage', source)
            end)
        end)
    end
end)

RegisterNetEvent('HVC:SellVehicle')
AddEventHandler('HVC:SellVehicle', function(veh)
    local name = veh
    local player = source 
    local playerID = HVC.getUserId(source)
    if playerID ~= nil then
		HVCclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. HVC.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
			end
			if usrList ~= "" then
				HVC.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = HVC.getUserSource(tonumber(user_id))
						if target ~= nil then
							HVC.prompt(player,"Price £: ","",function(player,amount)
								if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
									MySQL.query("HVC/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
										if #pvehicle > 0 then
											HVCclient.notify(player,{"~r~The player already has this vehicle."})
										else
											local tmpdata = HVC.getUserTmpTable(playerID)
											MySQL.query("HVC/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                if #pvehicles > 0 then 
                                                    HVCclient.notify(player,{"~r~You cannot sell a rented vehicle!"})
                                                    return
                                                else
                                                    HVC.request(target,GetPlayerName(player).." wants to sell: " ..name.. " price: £"..amount, 10, function(target,ok)
                                                        if ok then
                                                            local pID = HVC.getUserId(target)
                                                            amount = tonumber(amount)
                                                            if HVC.tryFullPayment(pID,amount) then
                                                                HVCclient.despawnGarageVehicle(player,{'car',15}) 
                                                                HVC.getUserIdentity(pID, function(identity)
                                                                    MySQL.execute("HVC/sell_vehicle_player", {user_id = user_id, registration = "P "..identity.registration, oldUser = playerID, vehicle = name}) 
                                                                end)
                                                                HVC.giveBankMoney(playerID, amount)
                                                                HVCclient.notify(player,{"~g~You have successfully sold the vehicle to ".. GetPlayerName(target).." for £"..amount.."!"})
                                                                HVCclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully sold you the car for £"..amount.."!"})
                                                                TriggerClientEvent('HVC:CloseGarage', player)
                                                            else
                                                                HVCclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"})
                                                                HVCclient.notify(target,{"~r~You don't have enough money!"})
                                                            end
                                                        else
                                                            HVCclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to buy the car."})
                                                            HVCclient.notify(target,{"~r~You have refused to buy "..GetPlayerName(player).."'s car."})
                                                        end
                                                    end)
                                                end
                                            end)
										end
									end) 
								else
									HVCclient.notify(player,{"~r~The price of the car has to be a number."})
								end
							end)
						else
							HVCclient.notify(player,{"~r~That ID seems invalid."})
						end
					else
						HVCclient.notify(player,{"~r~No player ID selected."})
					end
				end)
			else
				HVCclient.notify(player,{"~r~No players nearby."})
			end
		end)
    end
end)


RegisterServerEvent("Vrxith:SellProperty")
AddEventHandler("Vrxith:SellProperty", function(homename, homeid)
    local player = source
    local userid = HVC.getUserId(player)
    local table = nil
    local homenamecl = homename
    homenameDB = nil
    owneruid = nil
    homeownername1 = nil

    exports['ghmattimysql']:execute("SELECT * FROM hvc_housing_data WHERE HomeIdentifier = @hmid", {hmid = homeid}, function(result)
        homenameDB = result[1].HomeName
        owneruid = result[1].UserID
        homeownername1 = result[1].HomeOwnerName
	end)

    Wait(299)
    --print(owneruid)

    HVCclient.getNearestPlayers(player,{15},function(nplayers)
		usrList = ""
		for k,v in pairs(nplayers) do
			usrList = usrList .. "[" .. HVC.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
		end
		if usrList ~= "" then
			HVC.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
				user_id = user_id
				if user_id ~= nil and user_id ~= "" then 
					local target = HVC.getUserSource(tonumber(user_id))
					if target ~= nil then
						HVC.prompt(player,"Price £: ","",function(player,amount)
							if tonumber(amount) and tonumber(amount) > 0 then
                                HVC.request(target,GetPlayerName(player).." wants to sell " ..homenamecl.. " Price: £"..amount, 10, function(target,ok)
                                    if ok then
                                        amount = tonumber(amount)
                                        user_id = HVC.getUserId(target)
                                        if userid == owneruid then
                                            if HVC.tryFullPayment(user_id, amount) then
                                                HVC.giveBankMoney(userid, amount)

                                                HVCclient.notify(target,{"~g~You successfully bought ".. homenamecl.." for £"..amount.."!"})
                                                HVCclient.notify(player, {"~g~You sold "..homenamecl.." to "..GetPlayerName(target).. " for £"..amount})

                                                exports['ghmattimysql']:execute("UPDATE hvc_housing_data SET UserID = @user_id, HomeOwnerName = @HomeOwnerName WHERE HomeIdentifier = @HomeIdentifier ", {HomeIdentifier = homeid, user_id = user_id, HomeOwnerName = GetPlayerName(target)}, function() end)
                                            else
                                                HVCclient.notify(target, {"~r~You do not have enough money."})
                                                HVCclient.notify(player, {"~r~"..GetPlayerName(target).. " didn't have enough money."})
                                            end
                                        else 
                                            HVCclient.notify(player, {"~r~You do not own this house"})
                                        end

                                    end
                                end)
                            end
                        end)
                    else
                        HVCclient.notify(player, {"~r~That PermID seems invalid"})
                    end
                else
                    HVCclient.notify(player, {"~r~No PermID entered"})
                end
            end)
        else
            HVCclient.notify(player, {"~r~There is no one near by"})
        end
    end)
end)





RegisterNetEvent('HVC:RentVehicle')
AddEventHandler('HVC:RentVehicle', function(veh)
    local name = veh
    local player = source 
    local playerID = HVC.getUserId(source)
    if playerID ~= nil then
		HVCclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. HVC.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
			end
			if usrList ~= "" then
				HVC.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = HVC.getUserSource(tonumber(user_id))
						if target ~= nil then
							HVC.prompt(player,"Price £: ","",function(player,amount)
                                HVC.prompt(player,"Rent time (in hours): ","",function(player,rent)
                                    if tonumber(rent) and tonumber(rent) >  0 then 
                                        if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
                                            MySQL.query("HVC/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
                                                if #pvehicle > 0 then
                                                    HVCclient.notify(player,{"~r~The player already has this vehicle."})
                                                else
                                                    local tmpdata = HVC.getUserTmpTable(playerID)
                                                    MySQL.query("HVC/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                        if #pvehicles > 0 then 
                                                            HVCclient.notify(player,{"~r~You cannot rent a rented vehicle!"})
                                                            return
                                                        else
                                                            HVC.request(target,GetPlayerName(player).." wants to rent the vehicle: " ..name.. " for a price: £"..amount .. ' | for: ' .. rent .. 'hours', 10, function(target,ok)
                                                                if ok then
                                                                    local pID = HVC.getUserId(target)
                                                                    amount = tonumber(amount)
                                                                    if HVC.tryFullPayment(pID,amount) then
                                                                        HVCclient.despawnGarageVehicle(player,{'car',15}) 
                                                                        HVC.getUserIdentity(pID, function(identity)
                                                                            local rentedTime = os.time()
                                                                            rentedTime = rentedTime  + (60 * 60 * tonumber(rent)) 
                                                                            MySQL.execute("HVC/rentedupdate", {user_id = playerID, veh = name, id = pID, rented = 1, rentedid = playerID, rentedunix =  rentedTime }) 
                                                                        end)
                                                                        HVC.giveBankMoney(playerID, amount)
                                                                        HVCclient.notify(player,{"~g~You have successfully rented the vehicle to ".. GetPlayerName(target).." for £"..amount.."!" .. ' | for: ' .. rent .. 'hours'})
                                                                        HVCclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully rented you the vehicle for £"..amount.."!" .. ' | for: ' .. rent .. 'hours'})
                                                                        TriggerClientEvent('HVC:CloseGarage', player)
                                                                    else
                                                                        HVCclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"})
                                                                        HVCclient.notify(target,{"~r~You don't have enough money!"})
                                                                    end
                                                                else
                                                                    HVCclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to rent the car."})
                                                                    HVCclient.notify(target,{"~r~You have refused to rent "..GetPlayerName(player).."'s car."})
                                                                end
                                                            end)
                                                        end
                                                    end)
                                                end
                                            end) 
                                        else
                                            HVCclient.notify(player,{"~r~The price of the car has to be a number."})
                                        end
                                    else 
                                        HVCclient.notify(player,{"~r~The rent time of the car has to be in hours and a number."})
                                    end
                                end)
							end)
						else
							HVCclient.notify(player,{"~r~That ID seems invalid."})
						end
					else
						HVCclient.notify(player,{"~r~No player ID selected."})
					end
				end)
			else
				HVCclient.notify(player,{"~r~No players nearby."})
			end
		end)
    end
end)





RegisterNetEvent('HVC:FetchVehiclesIn')
AddEventHandler('HVC:FetchVehiclesIn', function()
    local returned_table = {}
    local source = source
    local user_id = HVC.getUserId(source)
    MySQL.query("HVC/get_rented_vehicles_in", {
        user_id = user_id
    }, function(pvehicles, affected)
        for _, veh in pairs(pvehicles) do
            for i, v in pairs(vehicle_groups) do
                local config = vehicle_groups[i]._config
                local perm = config.permissions or nil
                if perm then
                    for i, v in pairs(perm) do
                        if not HVC.hasPermission(user_id, v) then
                            break
                        end
                    end
                end
                for a, z in pairs(v) do
                    if a ~= "_config" and veh.vehicle == a then
                        if not returned_table[i] then 
                            returned_table[i] = {
                                ["config"] = config
                            }
                        end
                        if not returned_table[i].vehicles then 
                            returned_table[i].vehicles = {}
                        end
                        local time = tonumber(veh.rentedtime) - os.time()
                        local datetime = ""
                        local date = os.date("!*t", time)
                        if date.hour >= 1 and date.min >= 1 then 
                            datetime = date.hour .. " hours and " .. date.min .. " minutes left"
                        elseif date.hour <= 1 and date.min >= 1 then 
                            datetime = date.min .. " minutes left"
                        elseif date.hour >= 1 and date.min <= 1 then 
                            datetime = date.hour .. " hours left"
                        end
                        returned_table[i].vehicles[a] = {z[1], datetime}
                    end
                end
            end
        end
        TriggerClientEvent('HVC:ReturnFetchedCars', source, returned_table)
    end)
end)


RegisterNetEvent('HVC:CancelRent')
AddEventHandler('HVC:CancelRent', function(spawncode, permid, VehicleName)
    local source = source
    local userid = HVC.getUserId(source)
    exports['ghmattimysql']:execute("SELECT * FROM hvc_user_vehicles WHERE user_id = @user_id", {user_id = permid}, function(result)
        if #result > 0 then 
            for i = 1, #result do 
                if result[i].vehicle == spawncode and result[i].rented == true then
                    local target = HVC.getUserSource(result[i].user_id)
                    if target ~= nil then
                        HVC.request(target,GetPlayerName(source).." would like to cancel the rent on the vehicle: ", 10, function(target,ok)
                            if ok then
                                MySQL.execute('HVC/rentedupdate', {id = userid, rented = 0, rentedid = "", rentedunix = "", user_id = result[i].user_id, veh = spawncode})
                                HVCclient.notify(target, {"~r~" ..VehicleName.." has been returned to the vehicle owner."})
                                HVCclient.notify(source, {"~r~" ..VehicleName.." has been returned to your garage."})
                            else
                                HVCclient.notify(source, {"~r~User has declined the request to cancel the rental of vehicle: " ..VehicleName})
                            end
                        end)
                    else
                        HVCclient.notify(source, {"~r~The player is not online."})
                    end
                end
            end
        end
    end)
end)





RegisterNetEvent('HVC:FetchVehiclesOut')
AddEventHandler('HVC:FetchVehiclesOut', function()
    local returned_table = {}
    local source = source
    local user_id = HVC.getUserId(source)
    MySQL.query("HVC/get_rented_vehicles_out", {
        user_id = user_id
    }, function(pvehicles, affected)
        for _, veh in pairs(pvehicles) do
            for i, v in pairs(vehicle_groups) do
                local config = vehicle_groups[i]._config
                local perm = config.permissions or nil
                if perm then
                    for i, v in pairs(perm) do
                        if not HVC.hasPermission(user_id, v) then
                            break
                        end
                    end
                end
                for a, z in pairs(v) do
                    if a ~= "_config" and veh.vehicle == a then
                        if not returned_table[i] then 
                            returned_table[i] = {
                                ["config"] = config
                            }
                        end
                        if not returned_table[i].vehicles then 
                            returned_table[i].vehicles = {}
                        end
                        local time = tonumber(veh.rentedtime) - os.time()
                        local datetime = ""
                        local date = os.date("!*t", time)
                        if date.hour >= 1 and date.min >= 1 then 
                            datetime = date.hour .. " hours and " .. date.min .. " minutes left."
                        elseif date.hour <= 1 and date.min >= 1 then 
                            datetime = date.min .. " minutes left"
                        elseif date.hour >= 1 and date.min <= 1 then 
                            datetime = date.hour .. " hours left"
                        end
                        returned_table[i].vehicles[a .. ':' .. veh.user_id] = {z[1], datetime, veh.user_id, a}
                    end
                end
            end
        end
        TriggerClientEvent('HVC:ReturnFetchedCars', source, returned_table)
    end)
end)


-- -- load config

-- local cfg = module("cfg/garages")
-- local cfg_inventory = module("cfg/inventory")
-- local vehicle_groups = cfg.garage_types
local lang = HVC.lang

-- local garages = cfg.garages
-- --defined the limit here as well if you dont put it in the config file
-- local limit = cfg.limit or 100000000
-- -- garage menus

-- local garage_menus = {}

-- for group,vehicles in pairs(vehicle_groups) do
--   local veh_type = vehicles._config.vtype or "default"

--   local menu = {
--     name=lang.garage.title({group}),
--     css={top = "75px", header_color="rgba(255,125,0,0.75)"}
--   }
--   garage_menus[group] = menu

--   menu[lang.garage.owned.title()] = {function(player,choice)
--     local user_id = HVC.getUserId(player)
--     if user_id ~= nil then
--       -- init tmpdata for rents
--       local tmpdata = HVC.getUserTmpTable(user_id)
--       if tmpdata.rent_vehicles == nil then
--         tmpdata.rent_vehicles = {}
--       end

--       -- build nested menu
--       local kitems = {}
--       local submenu = {name=lang.garage.title({lang.garage.owned.title()}), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
--       submenu.onclose = function()
--         HVC.openMenu(player,menu)
--       end

--       local choose = function(player, choice)
--         local vname = kitems[choice]
--         if vname then
--           -- spawn vehicle
--           local vehicle = vehicles[vname]
--           if vehicle then
--             HVC.closeMenu(player)
--             HVCclient.spawnGarageVehicle(player,{veh_type,vname})
--           end
--         end
--       end

--       -- get player owned vehicles
--       MySQL.query("HVC/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
--         -- add rents to whitelist
--         for k,v in pairs(tmpdata.rent_vehicles) do
--           if v then -- check true, prevent future neolua issues
--             table.insert(pvehicles,{vehicle = k})
--           end
--         end

--         for k,v in pairs(pvehicles) do
--           local vehicle = vehicles[v.vehicle]
--           if vehicle then
--             submenu[vehicle[1]] = {choose,vehicle[3]}
--             kitems[vehicle[1]] = v.vehicle
--           end
--         end

--         HVC.openMenu(player,submenu)
--       end)
--     end
--   end,lang.garage.owned.description()}

--   menu[lang.garage.buy.title()] = {function(player,choice)
--     local user_id = HVC.getUserId(player)
--     if user_id ~= nil then

--       -- build nested menu
--       local kitems = {}
--       local submenu = {name=lang.garage.title({lang.garage.buy.title()}), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
--       submenu.onclose = function()
--         HVC.openMenu(player,menu)
--       end

--       local choose = function(player, choice)
--         local vname = kitems[choice]
--         if vname then
--           -- buy vehicle
--           local vehicle = vehicles[vname]
--           if vehicle and HVC.tryPayment(user_id,vehicle[2]) then
-- 	    HVC.getUserIdentity(user_id, function(identity)					
--             	MySQL.execute("HVC/add_vehicle", {user_id = user_id, vehicle = vname, registration = "P "..identity.registration})
-- 	    end)

--             HVCclient.notify(player,{lang.money.paid({vehicle[2]})})
--             HVC.closeMenu(player)
--           else
--             HVCclient.notify(player,{lang.money.not_enough()})
--           end
--         end
--       end

--       -- get player owned vehicles (indexed by vehicle type name in lower case)
--       MySQL.query("HVC/get_vehicles", {user_id = user_id}, function(_pvehicles, affected)
--         local pvehicles = {}
--         for k,v in pairs(_pvehicles) do
--           pvehicles[string.lower(v.vehicle)] = true
--         end

--         -- for each existing vehicle in the garage group
--         for k,v in pairs(vehicles) do
--           if k ~= "_config" and pvehicles[string.lower(k)] == nil then -- not already owned
--             submenu[v[1]] = {choose,lang.garage.buy.info({v[2],v[3]})}
--             kitems[v[1]] = k
--           end
--         end

--         HVC.openMenu(player,submenu)
--       end)
--     end
--   end,lang.garage.buy.description()}

--   menu[lang.garage.sell.title()] = {function(player,choice)
--     local user_id = HVC.getUserId(player)
--     if user_id ~= nil then

--       -- build nested menu
--       local kitems = {}
--       local submenu = {name=lang.garage.title({lang.garage.sell.title()}), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
--       submenu.onclose = function()
--         HVC.openMenu(player,menu)
--       end

--       local choose = function(player, choice)
-- 		HVC.request(player,"Are you sure that you want to sell this vehicle?",30,function(player,ok)
--         if ok then
-- 		local vname = kitems[choice]
--         if vname then
--           -- sell vehicle
--           local vehicle = vehicles[vname]
--           if vehicle then
--             local price = math.ceil((vehicle[2]*cfg.sell_factor)*1)

--             MySQL.query("HVC/get_vehicle", {user_id = user_id, vehicle = vname}, function(rows, affected)
--               if #rows > 0 then -- has vehicle
--                 HVC.giveMoney(user_id,price)
--                 MySQL.execute("HVC/remove_vehicle", {user_id = user_id, vehicle = vname})
-- 		HVCclient.notify(player,{lang.money.received({price})})
--                 HVC.closeMenu(player)
--               else
--                 HVCclient.notify(player,{lang.common.not_found()})
--               end
--             end)
--           end
--         end
--        end
--       end)
--      end

--       -- get player owned vehicles (indexed by vehicle type name in lower case)
--       MySQL.query("HVC/get_vehicles", {user_id = user_id}, function(_pvehicles, affected)
--         local pvehicles = {}
--         for k,v in pairs(_pvehicles) do
--           pvehicles[string.lower(v.vehicle)] = true
--         end

--         -- for each existing vehicle in the garage group
--         for k,v in pairs(pvehicles) do
--           local vehicle = vehicles[k]
--           if vehicle then -- not already owned
--             local price = math.ceil((vehicle[2]*cfg.sell_factor)*1)
--             submenu[vehicle[1]] = {choose,lang.garage.buy.info({price,vehicle[3]})}
--             kitems[vehicle[1]] = k
--           end
--         end

--         HVC.openMenu(player,submenu)
--       end)
--     end
--   end,lang.garage.sell.description()}

--   menu[lang.garage.rent.title()] = {function(player,choice)
--     local user_id = HVC.getUserId(player)
--     if user_id ~= nil then
--       -- init tmpdata for rents
--       local tmpdata = HVC.getUserTmpTable(user_id)
--       if tmpdata.rent_vehicles == nil then
--         tmpdata.rent_vehicles = {}
--       end

--       -- build nested menu
--       local kitems = {}
--       local submenu = {name=lang.garage.title({lang.garage.rent.title()}), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
--       submenu.onclose = function()
--         HVC.openMenu(player,menu)
--       end

--       local choose = function(player, choice)
--         local vname = kitems[choice]
--         if vname then
--           -- rent vehicle
--           local vehicle = vehicles[vname]
--           if vehicle then
--             local price = math.ceil((vehicle[2]*cfg.rent_factor)*1)
--             if HVC.tryPayment(user_id,price) then
--               -- add vehicle to rent tmp data
--               tmpdata.rent_vehicles[vname] = true

--               HVCclient.notify(player,{lang.money.paid({price})})
--               HVC.closeMenu(player)
--             else
--               HVCclient.notify(player,{lang.money.not_enough()})
--             end
--           end
--         end
--       end

--       -- get player owned vehicles (indexed by vehicle type name in lower case)
--       MySQL.query("HVC/get_vehicles", {user_id = user_id}, function(_pvehicles, affected)
--         local pvehicles = {}
--         for k,v in pairs(_pvehicles) do
--           pvehicles[string.lower(v.vehicle)] = true
--         end

--         -- add rents to blacklist
--         for k,v in pairs(tmpdata.rent_vehicles) do
--           pvehicles[string.lower(k)] = true
--         end

--         -- for each existing vehicle in the garage group
--         for k,v in pairs(vehicles) do
--           if k ~= "_config" and pvehicles[string.lower(k)] == nil then -- not already owned
--             local price = math.ceil((v[2]*cfg.rent_factor)*1)
--             submenu[v[1]] = {choose,lang.garage.buy.info({price,v[3]})}
--             kitems[v[1]] = k
--           end
--         end

--         HVC.openMenu(player,submenu)
--       end)
--     end
--   end,lang.garage.rent.description()}

--   menu[lang.garage.store.title()] = {function(player,choice)
--     HVCclient.despawnGarageVehicle(player,{veh_type,15}) 
--   end, lang.garage.store.description()}
-- end

-- local function build_client_garages(source)
--   local user_id = HVC.getUserId(source)
--   if user_id ~= nil then
--     for k,v in pairs(garages) do
--       local gtype,x,y,z = table.unpack(v)

--       local group = vehicle_groups[gtype]
--       if group then
--         local gcfg = group._config

--         -- enter
--         local garage_enter = function(player,area)
--           local user_id = HVC.getUserId(source)
--           if user_id ~= nil and HVC.hasPermissions(user_id,gcfg.permissions or {}) then
--             local menu = garage_menus[gtype]
--             if menu then
--               HVC.openMenu(player,menu)
--             end
--           end
--         end

--         -- leave
--         local garage_leave = function(player,area)
--           HVC.closeMenu(player)
--         end

--         HVCclient.addBlip(source,{x,y,z,gcfg.blipid,gcfg.blipcolor,lang.garage.title({gtype})})
--         -- HVCclient.addMarker(source,{x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})

--         HVC.setArea(source,"HVC:garage"..k,x,y,z,1,1.5,garage_enter,garage_leave)
--       end
--     end
--   end
-- end

-- AddEventHandler("HVC:playerSpawn",function(user_id,source,first_spawn)
--   if first_spawn then
--     build_client_garages(source)
--   end
-- end)

-- -- VEHICLE MENU

-- -- define vehicle actions
-- -- action => {cb(user_id,player,veh_group,veh_name),desc}
local veh_actions = {}

-- open trunk
veh_actions[lang.vehicle.trunk.title()] = {function(user_id,player,vtype,name)
  local chestname = "u"..user_id.."veh_"..string.lower(name)
  local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

  -- open chest
  HVCclient.vc_openDoor(player, {vtype,5})
  HVC.openChest(player, chestname, max_weight, function()
    HVCclient.vc_closeDoor(player, {vtype,5})
  end)
end, lang.vehicle.trunk.description()}


-- lock/unlock
veh_actions[lang.vehicle.lock.title()] = {function(user_id,player,vtype,name)
  HVCclient.vc_toggleLock(player, {vtype})
end, lang.vehicle.lock.description()}

-- --sell2
-- MySQL.createCommand("HVC/sell_vehicle_player","UPDATE hvc_user_vehicles SET user_id = @user_id, vehicle_plate = @registration WHERE user_id = @oldUser AND vehicle = @vehicle")

-- -- sell vehicle
-- veh_actions[lang.vehicle.sellTP.title()] = {function(playerID,player,vtype,name)
-- 	if playerID ~= nil then
-- 		HVCclient.getNearestPlayers(player,{15},function(nplayers)
-- 			usrList = ""
-- 			for k,v in pairs(nplayers) do
-- 				usrList = usrList .. "[" .. HVC.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
-- 			end
-- 			if usrList ~= "" then
-- 				HVC.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
-- 					user_id = user_id
-- 					if user_id ~= nil and user_id ~= "" then 
-- 						local target = HVC.getUserSource(tonumber(user_id))
-- 						if target ~= nil then
-- 							HVC.prompt(player,"Price £: ","",function(player,amount)
-- 								if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
-- 									MySQL.query("HVC/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
-- 										if #pvehicle > 0 then
-- 											HVCclient.notify(player,{"~r~The player already has this vehicle type."})
-- 										else
-- 											local tmpdata = HVC.getUserTmpTable(playerID)
-- 											if tmpdata.rent_vehicles[name] == true then
-- 												HVCclient.notify(player,{"~r~You cannot sell a rented vehicle!"})
-- 												return
-- 											else
-- 												HVC.request(target,GetPlayerName(player).." wants to sell: " ..name.. " Price: £"..amount, 10, function(target,ok)
-- 													if ok then
-- 														local pID = HVC.getUserId(target)
-- 														local money = HVC.getMoney(pID)
-- 														if (tonumber(money) >= tonumber(amount)) then
-- 															HVCclient.despawnGarageVehicle(player,{vtype,15}) 
-- 															HVC.getUserIdentity(pID, function(identity)
-- 																MySQL.execute("HVC/sell_vehicle_player", {user_id = user_id, registration = "P "..identity.registration, oldUser = playerID, vehicle = name}) 
-- 															end)
-- 															HVC.giveMoney(playerID, amount)
-- 															HVC.setMoney(pID,money-amount)
-- 															HVCclient.notify(player,{"~g~You have successfully sold the vehicle to ".. GetPlayerName(target).." for £"..amount.."!"})
-- 															HVCclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully sold you the car for £"..amount.."!"})
-- 														else
-- 															HVCclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"})
-- 															HVCclient.notify(target,{"~r~You don't have enough money!"})
-- 														end
-- 													else
-- 														HVCclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to buy the car."})
-- 														HVCclient.notify(target,{"~r~You have refused to buy "..GetPlayerName(player).."'s car."})
-- 													end
-- 												end)
-- 											end
-- 											HVC.closeMenu(player)
-- 										end
-- 									end) 
-- 								else
-- 									HVCclient.notify(player,{"~r~The price of the car has to be a number."})
-- 								end
-- 							end)
-- 						else
-- 							HVCclient.notify(player,{"~r~That ID seems invalid."})
-- 						end
-- 					else
-- 						HVCclient.notify(player,{"~r~No player ID selected."})
-- 					end
-- 				end)
-- 			else
-- 				HVCclient.notify(player,{"~r~No player nearby."})
-- 			end
-- 		end)
-- 	end
-- end, lang.vehicle.sellTP.description()}

local function ch_vehicle(player,choice)
  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    -- check vehicle
    HVCclient.getNearestOwnedVehicle(player,{7},function(ok,vtype,name)
      if ok then
        -- build vehicle menu
        HVC.buildMenu("vehicle", {user_id = user_id, player = player, vtype = vtype, vname = name}, function(menu)
          menu.name=lang.vehicle.title()
          menu.css={top="75px",header_color="rgba(255,125,0,0.75)"}

          for k,v in pairs(veh_actions) do
            menu[k] = {function(player,choice) v[1](user_id,player,vtype,name) end, v[2]}
          end

          HVC.openMenu(player,menu)
        end)
      else
        HVCclient.notify(player,{lang.vehicle.no_owned_near()})
      end
    end)
  end
end

-- ask trunk (open other user car chest)
local function ch_asktrunk(player,choice)
  HVCclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = HVC.getUserId(nplayer)
    if nuser_id ~= nil then
      HVCclient.notify(player,{lang.vehicle.asktrunk.asked()})
      HVC.request(nplayer,lang.vehicle.asktrunk.request(),15,function(nplayer,ok)
        if ok then -- request accepted, open trunk
          HVCclient.getNearestOwnedVehicle(nplayer,{7},function(ok,vtype,name)
            if ok then
              local chestname = "u"..nuser_id.."veh_"..string.lower(name)
              local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

              -- open chest
              local cb_out = function(idname,amount)
                HVCclient.notify(nplayer,{lang.inventory.give.given({HVC.getItemName(idname),amount})})
              end

              local cb_in = function(idname,amount)
                HVCclient.notify(nplayer,{lang.inventory.give.received({HVC.getItemName(idname),amount})})
              end

              HVCclient.vc_openDoor(nplayer, {vtype,5})
              HVC.openChest(player, chestname, max_weight, function()
                HVCclient.vc_closeDoor(nplayer, {vtype,5})
              end,cb_in,cb_out)
            else
              HVCclient.notify(player,{lang.vehicle.no_owned_near()})
              HVCclient.notify(nplayer,{lang.vehicle.no_owned_near()})
            end
          end)
        else
          HVCclient.notify(player,{lang.common.request_refused()})
        end
      end)
    else
      HVCclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end

-- repair nearest vehicle
local function ch_repair(player,choice)
  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    -- anim and repair
    if HVC.tryGetInventoryItem(user_id,"repairkit",1,true) then
      HVCclient.playAnim(player,{false,{task="WORLD_HUMAN_WELDING"},false})
      SetTimeout(15000, function()
        HVCclient.fixeNearestVehicle(player,{7})
        HVCclient.stopAnim(player,{false})
      end)
    end
  end
end

-- replace nearest vehicle
local function ch_replace(player,choice)
  HVCclient.replaceNearestVehicle(player,{7})
end

HVC.registerMenuBuilder("main", function(add, data)
    local user_id = HVC.getUserId(data.player)
    if user_id ~= nil then
      -- add vehicle entry
      local choices = {}
      choices[lang.vehicle.title()] = {ch_vehicle}
  
      -- add ask trunk
      choices[lang.vehicle.asktrunk.title()] = {ch_asktrunk}
  
      -- add repair functions
      if HVC.hasPermission(user_id, "vehicle.repair") then
        choices[lang.vehicle.repair.title()] = {ch_repair, lang.vehicle.repair.description()}
      end
  
      if HVC.hasPermission(user_id, "vehicle.replace") then
        choices[lang.vehicle.replace.title()] = {ch_replace, lang.vehicle.replace.description()}
      end
  
      add(choices)
    end
  end)
  




  
Citizen.CreateThread(function()
    Wait(1500)
    exports['ghmattimysql']:execute([[
        CREATE TABLE IF NOT EXISTS `vrxith_custom_garages` (
            `UserID` INT(11) NOT NULL AUTO_INCREMENT,
            `Folder` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            PRIMARY KEY (`UserID`) USING BTREE
        );
    ]])
    print("[Vrxith] Weapon Whitelists Datatables Initialised!")
end)
