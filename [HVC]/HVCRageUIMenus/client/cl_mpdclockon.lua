local PoliceClockOn = RageUI.CreateMenu("", "~b~Metropolitan Police", 1400, 59,"banners", "policeclock")

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1.0)
        RageUI.IsVisible(PoliceClockOn, function()
            for _ ,v in pairs(Config.PoliceGroups) do
                RageUI.Button(v.name, "", {RightLabel = '→→→',}, true, {
                    onSelected = function()
                        TriggerServerEvent("HVC:StartShift", v.group)
                    end,
                });
            end
        end)
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.CreateThread(function() 
            while true do
                for k, v in pairs(cfgChngeIdentity.coords) do 
                    local x,y,z = table.unpack(v.marker)
                    local v1 = vector3(x,y,z)
                    if isInArea(v1, 100.0) then 
                        DrawMarker(25, v1.x,v1.y,v1.z - 0.888888, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 255, 0, 0, 150, 0, 0, 2, 0, 0, 0, false)
                    end
                end)
            end
            
local MenuOpen = false;
local inMarker = false;
Citizen.CreateThread(function()
    while true do 
        Wait(250)
        inMarker = false
        local PlayerPed = PlayerPedId()
        local PedCoords = GetEntityCoords(PlayerPed)
        for i,v in pairs(Config.PoliceClock) do
            local x,y,z = v[1], v[2], v[3]
            if #(PedCoords - vec3(x,y,z)) <= 1.0 then
                inMarker = true 
                break
            end    
        end
        if not MenuOpen and inMarker then 
            MenuOpen = true 
            RageUI.Visible(PoliceClockOn, true)
        end
        if MenuOpen and not inMarker then 
            MenuOpen = false 
            RageUI.Visible(PoliceClockOn, false)
        end
    end
end)




