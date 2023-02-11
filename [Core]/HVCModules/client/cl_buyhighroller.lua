vftcfgcasino = {}
vftcfgcasino.blip = false

vftcfgcasino.coords= {
    [0] = { -- Paleto Bay
        ped = {1088.35, 219.51, -49.2},
        marker = {1088.35, 219.51, -49.2},
    },
}

RMenu.Add('highroller', 'main', RageUI.CreateMenu("", "~b~Buy VIP Diamond Casino & Resort", 1300, 100, "shopui_title_casino", "shopui_title_casino"))
RMenu:Get('highroller', 'main'):SetPosition(1350, 10)

-- RageUI.CreateWhile(wait, menu, key, closure)
RageUI.CreateWhile(1.0, RMenu:Get('highroller', 'main'), nil, function()

    RageUI.IsVisible(RMenu:Get('highroller', 'main'), true, false, true, function()
        RageUI.ButtonWithStyle("Purchase Highroller" , nil, {RightLabel = "£10,000,000"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('HVCServer:DiamondCasinoBuyHighroller', 10000000)
            end
        end)
    end, function()
        ---Panels
    end)
end)




isInhighrollerMenu = false
currentAmmunitionhighroller = nil
Citizen.CreateThread(function() 
    while true do
        for k, v in pairs(vftcfgcasino.coords) do
            local v1 = vector3(1088.35, 219.51, -49.2)
            if isInArea(v1, 100.0) then 
                DrawMarker(25, v1.x,v1.y,v1.z - 0.888888, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 255, 0, 0, 150, 0, 0, 2, 0, 0, 0, false)
            end
            if isInhighrollerMenu == false then
            if isInArea(v1, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ To Purchase Highrollers ')
                if IsControlJustPressed(0, 51) then 
                    currentAmmunitionhighroller = k
                    RageUI.Visible(RMenu:Get("highroller", "main"), true)
                    isInhighrollerlMenu = true
                    currentAmmunitionhighroller = k 
                end
            end
            end
            if isInArea(v1, 1.4) == false and isInhighrollerMenu and k == currentAmmunitionhighroller then
                RageUI.Visible(RMenu:Get("highroller", "main"), false)
                isInhighrollerMenu = false
                currentAmmunitionhighroller = nil
            end
        end
        Citizen.Wait(0)
    end
end)



function isInArea(v, dis) 
    
    if #(GetEntityCoords(PlayerPedId(-1)) - v) <= dis then  
        return true
    else 
        return false
    end
end

function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end