local coords = {
    [0] = { 
        ped = {-815.59008789063,-182.16806030273,37.568920135498},
        marker = {-815.59008789063,-182.16806030273,37.568920135498},
    },
    [1] = { 
        ped = {139.21583557129,-1708.9689941406,29.301620483398},
        marker = {139.21583557129,-1708.9689941406,29.301620483398},
    },
    [2] = { 
        ped = {-1281.9802246094,-1119.6861572266,7.0001249313354},
        marker = {-1281.9802246094,-1119.6861572266,7.0001249313354},
    },
    [3] = { 
        ped = {1934.115234375,3730.7399902344,32.854434967041},
        marker = {1934.115234375,3730.7399902344,32.854434967041},
    },
    [4] = { 
        ped = {1211.0759277344,-475.00064086914,66.218032836914},
        marker = {1211.0759277344,-475.00064086914,66.218032836914},
    },
    [5] = { 
        ped = {-34.97777557373,-150.9037322998,57.086517333984},
        marker = {-34.97777557373,-150.9037322998,57.086517333984},
    },
    [6] = { 
        ped = {-280.37301635742,6227.017578125,31.705526351929},
        marker = {-280.37301635742,6227.017578125,31.705526351929},
    },
    [7] = { 
        ped = {1102.08,201.62,-49.44},
        marker = {1102.08,201.62,-49.44},
    },
    [8] = { 
        ped = {-1821.851, -1202.308, 14.30042},
        marker = {-1821.851, -1202.308, 14.30042},
    },
} 


IsInBarberShop = false
CurrentlyInShop = nil
Citizen.CreateThread(function() 
    while true do
        for k, v in pairs(coords) do 
            local x,y,z = table.unpack(v.marker)
            local v1 = vector3(x,y,z)
            if isInArea(v1, 100.0) then 
                DrawMarker(2, v1.x,v1.y,v1.z - 0.0999999, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 47, 240, 47, 50, true, false, 2, true, nil, nil, false)
            end
            if IsInBarberShop == false then
            if isInArea(v1, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to get a haircut')
                if IsControlJustPressed(0, 51) then 
                    if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                        CurrentlyInShop = k
                        TriggerEvent("HVC:openBarbershop")
                        IsInBarberShop = true
                        CurrentlyInShop = k 
                    else
                        notify("~r~Error: ~w~You cannot be in a car!")
                    end
                end
            end
            end
            if isInArea(v1, 1.4) == false and IsInBarberShop and k == CurrentlyInShop then
                IsInBarberShop = false
                CurrentlyInShop = nil
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

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end


local barberblips = {
    {title="Barber Shop", colour=62, id=71, x = -815.59008789063, y = -182.16806030273, z = 37.568920135498},
    {title="Barber Shop", colour=62, id=71, x = 139.21583557129, y = -1708.9689941406, z = 29.301620483398},
    {title="Barber Shop", colour=62, id=71, x = -1281.9802246094, y = -1119.6861572266, z = 7.0001249313354},
    {title="Barber Shop", colour=62, id=71, x = 1934.115234375, y = 3730.7399902344, z = 32.854434967041},
    {title="Barber Shop", colour=62, id=71, x = 1211.0759277344, y = -475.00064086914, z = 66.218032836914},
    {title="Barber Shop", colour=62, id=71, x = -34.97777557373, y = -150.9037322998, z = 57.086517333984},
    {title="Barber Shop", colour=62, id=71, x = -280.37301635742, y = 6227.017578125, z = 31.705526351929},
    {title="Barber Shop", colour=62, id=71, x = -1821.851, y = -1202.308, z = 14.30042},


    {title="Barber Shop", colour=62, id=71, x = 1102.08, y = 201.62, z = -49.44},

    {title="Cashier", colour=0, id=683, x = 1115.67, y = 222.13, z = -49.44},
}
     
Citizen.CreateThread(function()

   for _, info in pairs(barberblips) do
     info.barberblips = AddBlipForCoord(info.x, info.y, info.z)
     SetBlipSprite(info.barberblips, info.id)
     SetBlipDisplay(info.barberblips, 4)
     SetBlipScale(info.barberblips, 0.7)
     SetBlipColour(info.barberblips, info.colour)
     SetBlipAsShortRange(info.barberblips, true)
     BeginTextCommandSetBlipName("STRING")
     AddTextComponentString(info.title)
     EndTextCommandSetBlipName(info.barberblips)
   end
end)


RegisterNetEvent("HVC:setOverlay")
AddEventHandler("HVC:setOverlay",function(l)
    print(l)
    if l then
        dad = l["dad"] or 0
        mum = l["mum"] or 0
        skin = l["skin"] or 0
        dadmumpercent = l["dadmumpercent"] or 0
        eyecolor = l["eyecolor"] or 0
        acne = l["acne"] or 0
        skinproblem = l["skinproblem"] or 0
        freckle = l["freckle"] or 0
        wrinkle = l["wrinkle"] or 0
        wrinkleopacity = l["wrinkleopacity"] or 0
        hair = l["hair"] or 0
        haircolor = l["haircolor"] or 0
        eyebrow = l["eyebrow"] or 0
        eyebrowopacity = l["eyebrowopacity"] or 0
        beard = l["beard"] or 0
        beardopacity = l["beardopacity"] or 0
        beardcolor = l["beardcolor"] or 0
        eyeshadow = l["eyeshadow"] or 0
        lipstick = l["lipstick"] or 0
        eyeshadowcolour = l["eyeshadowcolour"] or 0
        lipstickcolour = l["lipstickcolour"] or 0
        SetPedHeadBlendData(
            PlayerPedId(),
            dad,
            mum,
            0,
            skin,
            skin,
            skin,
            dadmumpercent,
            dadmumpercent,
            0.0,
            false
        )
        SetPedEyeColor(PlayerPedId(), eyecolor)
        if acne == 0 then
            SetPedHeadOverlay(PlayerPedId(), 0, acne, 0.0)
        else
            SetPedHeadOverlay(PlayerPedId(), 0, acne, 1.0)
        end
        SetPedHeadOverlay(PlayerPedId(), 6, skinproblem, 1.0)
        if freckle == 0 then
            SetPedHeadOverlay(PlayerPedId(), 9, freckle, 0.0)
        else
            SetPedHeadOverlay(PlayerPedId(), 9, freckle, 1.0)
        end
        SetPedHeadOverlay(PlayerPedId(), 3, wrinkle, wrinkleopacity * 0.1)
        SetPedComponentVariation(PlayerPedId(), 2, hair, 0, 2)
        SetPedHairColor(PlayerPedId(), haircolor, haircolor)
        SetPedHeadOverlay(PlayerPedId(), 2, eyebrow, eyebrowopacity * 0.1)
        SetPedHeadOverlay(PlayerPedId(), 1, beard, beardopacity * 0.1)
        SetPedHeadOverlayColor(PlayerPedId(), 1, 1, beardcolor, beardcolor)
        SetPedHeadOverlayColor(PlayerPedId(), 2, 1, beardcolor, beardcolor)
        eyeShadowOpacity = 1.0
        if eyeshadow == 0 then
            eyeShadowOpacity = 0.0
        end
        lipstickOpacity = 1.0
        if lipstick == 0 then
            lipstickOpacity = 0.0
        end
        SetPedHeadOverlay(PlayerPedId(), 4, eyeshadow, eyeShadowOpacity)
        SetPedHeadOverlay(PlayerPedId(), 8, lipstick, lipstickOpacity)
        SetPedHeadOverlayColor(PlayerPedId(), 4, 1, eyeshadowcolour, eyeshadowcolour)
        SetPedHeadOverlayColor(PlayerPedId(), 8, 1, lipstickcolour, lipstickcolour)
    end
end)