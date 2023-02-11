
local Config = {} 
Config.Cooldown = 15

Config.BlipTime = 30

Config.DisableAllMessages = false

Config.ChatSuggestions = false

Config.Reminder = false

Config.WhitelistAutoTune = true

Config.VehicleAutoTune = false

Config.Sender = "MET Dispatch"
-- Default message displayed with panic activation
Config.Message = "Attention all Officers, Officer in distress!"



local Panic = {}

Panic.Cooling = 0

Panic.Tuned = false


local Whitelist = {}
-- Boolean for whether the whitelist is enabled
Whitelist.Enabled = Config.WhitelistEnabled


-- /panic command
RegisterCommand("panic", function(source)
	local Officer = {}
	Officer.Ped = PlayerPedId()
	Officer.Name = GetPlayerName(PlayerId())
	Officer.Coords = GetEntityCoords(Officer.Ped)
	Officer.Location = {}
	Officer.Location.Street, Officer.Location.CrossStreet = GetStreetNameAtCoord(Officer.Coords.x, Officer.Coords.y, Officer.Coords.z)
	Officer.Location.Street = GetStreetNameFromHashKey(Officer.Location.Street)
	if Officer.Location.CrossStreet ~= 0 then
		Officer.Location.CrossStreet = GetStreetNameFromHashKey(Officer.Location.CrossStreet)
		Officer.Location = Officer.Location.Street .. " X " .. Officer.Location.CrossStreet
	else
		Officer.Location = Officer.Location.Street
	end
	TriggerServerEvent("Police-Panic:NewPanic", Officer)
end)

-- Plays panic on client
RegisterNetEvent("Pass-Alarm:Return:NewPanic")
AddEventHandler("Pass-Alarm:Return:NewPanic", function(source, Officer)
		if Officer.Ped == PlayerPedId() then
			SendNUIMessage({
				PayloadType	= {"Panic", "LocalPanic"},
				Payload	= source
			})
		else
			SendNUIMessage({
				PayloadType	= {"Panic", "ExternalPanic"},
				Payload	= source
			})
		end

		-- Only people tuned to the panic channel can see the message
		Citizen.CreateThread(function()

			RegisterNetEvent("HVC:DisplayImageNotify")
			AddEventHandler("HVC:DisplayImageNotify", function(title, text)
				ImageNotify(title, text)
			end)
			
			function ImageNotify(title, text)
				SetNotificationTextEntry("STRING")
				AddTextComponentString(text)
				SetNotificationBackgroundColor(140)
				SetNotificationMessage("CHAR_WE", "hvcstaff", false, 1, title, "")
				DrawNotification(false, true)
			end	
			local Blip = AddBlipForRadius(Officer.Coords.x, Officer.Coords.y, Officer.Coords.z, 100.0)

			SetBlipRoute(Blip, true)

			Citizen.CreateThread(function()
				while Blip do
					SetBlipRouteColour(Blip, 1)
					Citizen.Wait(150)
					SetBlipRouteColour(Blip, 6)
					Citizen.Wait(150)
					SetBlipRouteColour(Blip, 35)
					Citizen.Wait(150)
					SetBlipRouteColour(Blip, 6)
				end
			end)

			SetBlipAlpha(Blip, 60)
			SetBlipColour(Blip, 1)
			SetBlipFlashes(Blip, true)
			SetBlipFlashInterval(Blip, 200)

			Citizen.Wait(Config.BlipTime * 1000)

			RemoveBlip(Blip)
			Blip = nil
		end)
end)

-- Draws notification on client's screen
function NewNoti(Text, Flash)
	if not Config.DisableAllMessages then
		SetNotificationTextEntry("STRING")
		AddTextComponentString(Text)
		DrawNotification(Flash, true)
	end
end

-- Cooldown loop
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if Panic.Cooling ~= 0 then
			Citizen.Wait(1000)
			Panic.Cooling = Panic.Cooling - 1
		end
	end
end)
