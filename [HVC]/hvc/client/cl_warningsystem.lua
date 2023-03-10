--type,duration(hours),admin_name,date,reason
HVCWarnings = {
	--[0] = {"Ban","48","Trev","10-10-19","You VDM'd x2"},
	--[1] = {"Warning","24","Vraith","1-10-19","You VDM'd x4"},
}

showWarningSystem = false

xoffset = 0.031
rowcounter = 0
warningColourR = 0
warningColourG = 0
warningColourB = 0

-- RegisterCommand("tempwarn",function()
	-- showWarningSystem = not showWarningSystem
-- end)

RegisterNetEvent("HVC:showWarningsOfUser")
AddEventHandler("HVC:showWarningsOfUser",function(HVCwarningstables)
	print("got to showWarningsOfUser")
	showWarningSystem = true
	HVCWarnings = HVCwarningstables
end)

RegisterNetEvent("HVC:stopWarningsOfUser")
AddEventHandler("HVC:stopWarningsOfUser",function(HVCwarningstables)
	print("got to showWarningsOfUser")
	showWarningSystem = false
end)

RegisterNetEvent("HVC:recievedRefreshedWarningData")
AddEventHandler("HVC:recievedRefreshedWarningData",function(HVCwarningstables)
	print("got to recievedRefreshedWarningData")
	HVCWarnings = HVCwarningstables
end)

function removeWarningLog(id)
	exports['ghmattimysql']:execute("DELETE FROM hvc_warnings WHERE warning_id = @warningid ", {warningid = id}, function() end)
end

Citizen.CreateThread(function()
	while true do
		if IsControlJustPressed(0,57) then
			--print("toggling warning system")
			showWarningSystem = not showWarningSystem
			if showWarningSystem then
				TriggerServerEvent("HVC:refreshWarningSystem")
			end
			Wait(250)
		end
		Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		if showWarningSystem then
			DrawRect(0.498, 0.482, 0.615, 0.636, 0, 0, 0, 150, 0)
			DrawRect(0.498, 0.197, 0.615, 0.066, 0, 0, 0, 135, 0)
			DrawAdvancedText(0.59, 0.198, 0.005, 0.0028, 0.619, "HVC Warning System", 255, 255, 255, 255, 7, 0)
			DrawRect(0.498, 0.232, 0.615, -0.0040000000000001, 6, 0, 0, 0, 0)
			DrawRect(0.498, 0.285, 0.535, -0.0040000000000001, 244, 11, 28, 204, 0)
			DrawAdvancedText(0.344, 0.27, 0.005, 0.0028, 0.4, "ID", 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.379, 0.27, 0.005, 0.0028, 0.4, "Type", 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.414, 0.271, 0.005, 0.0028, 0.4, "Duration", 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.452, 0.271, 0.005, 0.0028, 0.4, "Admin", 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.498, 0.271, 0.005, 0.0028, 0.4, "Date", 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.707, 0.271, 0.005, 0.0028, 0.4, "Reason", 255, 255, 255, 255, 6, 0)
			for warningID,warningTable in pairs(HVCWarnings) do
				--type,duration,admin,date,reason = table.unpack(warningTable)
				local warning_id, warning_type,duration,admin,date,reason = warningTable["warning_id"], warningTable["warning_type"],warningTable["duration"],warningTable["admin"],warningTable["warning_date"],warningTable["reason"]
				--print("warning_type showing: " .. tostring(warning_type))
				--print("duration showing: " .. tostring(duration))
				if warning_type == "Warning" then
					warningColourR = 255
					warningColourG = 255
					warningColourB = 102
				elseif warning_type == "Kick" then
					warningColourR = 255
					warningColourG = 123
					warningColourB = 0
				elseif warning_type == "Ban" then
					warningColourR = 255
					warningColourG = 44
					warningColourB = 44
				end
				DrawAdvancedText(0.344, 0.309+(rowcounter*xoffset), 0.005, 0.0028, 0.4, warning_id, 255, 255, 255, 255, 6, 0)
				DrawAdvancedText(0.379, 0.309+(rowcounter*xoffset), 0.005, 0.0028, 0.4, warning_type, warningColourR, warningColourG, warningColourB, 255, 6, 0)
				DrawAdvancedText(0.414, 0.309+(rowcounter*xoffset), 0.005, 0.0028, 0.4, tostring(duration) .. "hrs",  255, 255, 255, 255, 6, 0)
				DrawAdvancedText(0.452, 0.309+(rowcounter*xoffset), 0.005, 0.0028, 0.4, admin,  255, 255, 255, 255, 6, 0)
				DrawAdvancedText(0.498, 0.309+(rowcounter*xoffset), 0.005, 0.0028, 0.4, date,  255, 255, 255, 255, 6, 0)
				DrawAdvancedText(0.707, 0.309+(rowcounter*xoffset), 0.005, 0.0028, 0.4, reason,  255, 255, 255, 255, 6, 0)
				rowcounter = rowcounter + 1
			end
			rowcounter = 0
		end
		Wait(0)
	end	
end)

RegisterCommand("warn",function()
	--get a dialog box open
	--get ID
	--get warning msg
	--send to server to update the database
	userIDtoWarn = getWarningUserID()
	userWarningMessage = getWarningUserMsg()
	
	TriggerServerEvent("HVC:warnPlayer",tonumber(userIDtoWarn),GetPlayerName(PlayerId()),userWarningMessage)
end)

function getWarningUserID()
	AddTextEntry('FMMC_MPM_NA', "Enter Perm ID of the player you want to warn?")
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter Perm ID of the player you want to warn?", "1", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
		if result then
			return result
		end
    end
	return false
end

function getWarningUserMsg()
	AddTextEntry('FMMC_MPM_NA', "Enter warning message")
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter warning message", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
		if result then
			return result
		end
    end
	return false
end

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
   -- SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end