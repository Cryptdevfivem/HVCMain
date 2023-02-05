
local casinoBuyChipsVector = vector3(1115.82,222.05,-49.44)
local buychips = {
    {1115.82, 222.05, -49.44},
    {-1819.767, -1192.207, 14.30042},
}
RMenu.Add('casino_buychips', 'casino', RageUI.CreateMenu("", "~g~Cashier Services",0,100,"shopui_title_casino", "shopui_title_casino"))
playerAmountOfChips = 0


areYouSureText = nil
areYouSureTextTradeIn = nil
isInCasino = false
RageUI.CreateWhile(1.0, RMenu:Get('casino_buychips', 'casino'), nil, function()
    RageUI.IsVisible(RMenu:Get('casino_buychips', 'casino'), true, false, true, function()
        RageUI.ButtonWithStyle("Purchase Chips", "",{ RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
            if (Selected) then
                PurchaseChips()   
            end
        end)
        RageUI.ButtonWithStyle("Sell Chips", "",{ RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
            if (Selected) then
                SellChips()
            end
        end)
        -- RageUI.ButtonWithStyle("Chips Balance: " .. Comma(playerAmountOfChips),"" , { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
        --     if (Active) then
        --         TriggerServerEvent('buychips:GetAmountofchips')
        --     end
        -- end)
    end, function()
        ---Panels
    end)
end)


Citizen.CreateThread(function()
    while true do 
        for k,v in pairs(buychips) do
            local v1 = vector3(v[1], v[2], v[3])
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            if #(Coords - vec3(v1.x, v1.y, v1.z)) < 1.0 then
                RageUI.Visible(RMenu:Get('casino_buychips', 'casino'), true)
            elseif #(Coords - vec3(v1.x, v1.y, v1.z)) < 1.5 then
                RageUI.Visible(RMenu:Get('casino_buychips', 'casino'), false)
            end
            DrawMarker(2, v1.x,v1.y,v1.z - 0.0999999, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 47, 240, 47, 50, true, false, 2, true, nil, nil, false)
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('buychips:isInCasino')
AddEventHandler('buychips:isInCasino', function(bool) 
    TriggerServerEvent('buychips:GetAmountofchips')
    isInCasino = bool
end)
RegisterNetEvent('buychips:GotAmountOfChips')
AddEventHandler('buychips:GotAmountOfChips', function(amount) 
    playerAmountOfChips = amount
end)
RegisterNetEvent('buychips:updatehud+')
AddEventHandler('buychips:updatehud+', function(amount) 
    local newAmount = playerAmountOfChips + amount
    playerAmountOfChips = newAmount
end)
RegisterNetEvent('buychips:updatehud-')
AddEventHandler('buychips:updatehud-', function(amount) 
    if amount <= playerAmountOfChips then 
        local newAmount = playerAmountOfChips - amount
        playerAmountOfChips = newAmount
    end

end)

RegisterNetEvent("Blackjack:GetChipsClient")
AddEventHandler("Blackjack:GetChipsClient", function(Data)
    chipsamount = Data
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(0)
        if isInCasino or isInArea(vector3(-1830.079, -1193.67, 15.42932), 30.0) then 
            drawTxt("Your Chips: "..Comma(tonumber(math.round(playerAmountOfChips))) , 255,255,255,255, 0.01,0.7599, 0.5,0.5, 7)
        end
    end
end)


function isInArea(v, dis) 
    
    if #(GetEntityCoords(PlayerPedId(-1)) - v) <= dis then  
        return true
    else 
        return false
    end
end

--[[Random Functions]]
function drawTxt(txt,r,g,b,a,x,y,s1,s2,f) 
    SetTextFont(f) -- 0-4
    SetTextScale(s1, s2) -- Size of text
    SetTextColour(r, g, b, a) -- RGBA
    SetTextEntry("STRING")
    AddTextComponentString(txt) -- casino Text string
    DrawText( x,y) -- x,y of the screen
end





function PurchaseChips()
	AddTextEntry('FMMC_MPM_NA', "Enter The Amount Of Chips To Purchase")
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter The Amount Of Chips To Purchase", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        TriggerServerEvent('buychips:TryChipPayment', result)
		if result then
			return result
		end
    end
	return false
end

function SellChips()
	AddTextEntry('FMMC_MPM_NA', "Enter The Amount Of Chips To Sell")
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter The Amount Of Chips To Sell", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        TriggerServerEvent('buychips:PerformTradeIn', result)
		if result then
			return result
		end
    end
	return false
end


function Comma(amount)
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
  end

RegisterNetEvent("HVC:isInCasino")
AddEventHandler("HVC:isInCasino", function(bool)
    isInCasino = bool
end)