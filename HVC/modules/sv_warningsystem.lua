AddEventHandler('chatMessage', function(player, color, message)
	user_id = HVC.getUserId(player)
    if message:sub(1, 3) == '/sw' then
		local permID =  tonumber(message:sub(4, 20))
		if permID ~= nil then
			--check if staff
			if HVC.hasPermission(user_id,"admin.showwarn") then
				--print("Getting warnings of ID: " .. tostring(permID))
				HVCwarningstables = getHVCWarnings(permID,player)
				--print("sending to source: " .. tostring(source))
				TriggerClientEvent("HVC:showWarningsOfUser",player,HVCwarningstables)
			end
		else
			--print("Error couldn't get ID: " .. tostring(message:sub(14, 20)))
		end
    end
	CancelEvent()
end)

RegisterServerEvent("hvc_admin:showwarn")
AddEventHandler("hvc_admin:showwarn",function(id)
	local source = source
	HVCwarningstables = getHVCWarnings(id,source)
	TriggerClientEvent("HVC:showWarningsOfUser",source,HVCwarningstables)
end)

RegisterServerEvent("hvc_admin:stopwarn")
AddEventHandler("hvc_admin:stopwarn",function(id)
	local source = source
	HVCwarningstables = getHVCWarnings(id,source)
	TriggerClientEvent("HVC:stopWarningsOfUser",source,HVCwarningstables)
end)


--print("start:"..dump(testdate).."end")
-- testTime = 1561845600000
-- testTime = testTime / 1000
-- print(os.date('%Y-%m-%d', testTime))
	
function getHVCWarnings(user_id,source) 
	local table = nil
	exports['ghmattimysql']:execute("SELECT * FROM hvc_warnings WHERE user_id = @uid", {uid = user_id}, function(result)
		table = result
	end)
	Wait(500)
	for warningID,warningTable in pairs(table) do
		date = warningTable["warning_date"]
		newdate = tonumber(date) / 1000
		newdate = os.date('%Y-%m-%d', newdate)
		warningTable["warning_date"] = newdate
	end
	return table
end

RegisterServerEvent("HVC:refreshWarningSystem")
AddEventHandler("HVC:refreshWarningSystem",function()
	local source = source
	local user_id = HVC.getUserId(source)
	--local user_id = 1
	
	HVCwarningstables = getHVCWarnings(user_id,source)
	TriggerClientEvent("HVC:recievedRefreshedWarningData",source,HVCwarningstables)
end)

RegisterServerEvent("HVC:warnPlayer")
AddEventHandler("HVC:warnPlayer",function(target_id,adminName,warningReason)
	local source = source
	local user_id = HVC.getUserId(source)
	if HVC.hasPermission(user_id,"admin.warn") then
		warning = "Warning"
		warningDate = getCurrentDate()
		exports['ghmattimysql']:execute("INSERT INTO hvc_warnings (`warning_id`, `user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`) VALUES (NULL, @user_id, @warning_type, 0, @admin, @warning_date,@reason);", {user_id = target_id,warning_type = warning, admin = adminName, warning_date = warningDate, reason = warningReason}, function() end)
		HVCclient.notify(source,{"~g~You Warned Perm ID: "..target_id})
	else
		HVCclient.notify(source,{"~r~no perms to warn player"})
	end
end)

RegisterServerEvent("HVC:saveKickLog")
AddEventHandler("HVC:saveKickLog",function(target_id,adminName,warningReason)
	warning = "Kick"
	warningDate = getCurrentDate()
	exports['ghmattimysql']:execute("INSERT INTO hvc_warnings (`warning_id`, `user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`) VALUES (NULL, @user_id, @warning_type, 0, @admin, @warning_date,@reason);", {user_id = target_id,warning_type = warning, admin = adminName, warning_date = warningDate, reason = warningReason}, function() end)
end)

RegisterServerEvent("HVC:saveBanLog")
AddEventHandler("HVC:saveBanLog",function(target_id,adminName,warningReason,warning_duration)
	warning = "Ban"
	warningDate = getCurrentDate()
	exports['ghmattimysql']:execute("INSERT INTO hvc_warnings (`warning_id`, `user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`) VALUES (NULL, @user_id, @warning_type, @duration, @admin, @warning_date,@reason);", {user_id = target_id,warning_type = warning, admin = adminName, duration = warning_duration, warning_date = warningDate, reason = warningReason}, function() end)
end)


function getCurrentDate()
	date = os.date("%Y/%m/%d")

	return date
end

-- HVCWarnings = {
	-- [0] = {"Ban","48","Rolex","10-10-19","You VDM'd x2"},
	-- [1] = {"Warning","24","Rob","1-10-19","You VDM'd x4"},
-- }