--}				 {--
-- HVC HotKeys V1 --
--   Dunko HVC	  --
--}				 {--


HVC = Proxy.getInterface("HVC")

-- Change your controls if you wish: https://wiki.fivem.net/wiki/Controls

-- Drag Hot Key (To be Added)
-- Citizen.CreateThread(function()
  -- while true do
  -- Citizen.Wait(0)
	  -- if IsControlPressed(1, 19) and IsControlJustPressed(1,90) then -- LEFTALT + D
		-- HVCserver.dragPlayer({})
		-- end
	-- end
-- end)

-- Teleport to Waypoint Hot Key (To be Added)
-- Citizen.CreateThread(function()
  -- while true do
  -- Citizen.Wait(0)
	  -- if IsControlPressed(1, 19) and IsControlJustPressed(1,245) then -- LEFTALT + T
		-- HVCserver.TpToWaypoint({})
		-- end
	-- end
-- end)

-- Admin Menu Hot Key (WIP)
Citizen.CreateThread(function()
  while true do
  Citizen.Wait(0)
	  if IsControlPressed(1, 288) then -- F1
		HVCserver.openAdminMenu({})
		end
	end
end)

-- Police Menu Hot Key
Citizen.CreateThread(function()
  while true do
  Citizen.Wait(0)
	  if IsControlPressed(1, 289) then -- F2
		HVCserver.openPoliceMenu({})
		end
	end
end)

-- Police PC Menu Hot Key (To be Added)
-- Citizen.CreateThread(function()
  -- while true do
  -- Citizen.Wait(0)
	  -- if IsControlPressed(1, 19) and IsControlJustPressed(1,29) then -- LEFTALT + B
		-- HVCserver.openPolicePC({})
		-- end
	-- end
-- end)

-- Phone Menu Hot Key (To be Added)
-- Citizen.CreateThread(function()
  -- while true do
  -- Citizen.Wait(0)
	  -- if IsControlPressed(1, 19) and IsControlJustPressed(1,0) then -- LEFTALT + V
		-- HVCserver.openPhoneMenu({})
		-- end
	-- end
-- end)