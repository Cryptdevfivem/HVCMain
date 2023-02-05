HVCModuleC = {}
Tunnel.bindInterface("HVC_Modules",HVCModuleC)
Proxy.addInterface("HVC_Modules",HVCModuleC)
HVCModule = Tunnel.getInterface("HVC_Modules","HVC_Modules")
HVC = Proxy.getInterface("HVC")


function HVCModuleC.ClientPoliceCall(PoliceOfficerCoords)
    local player = PlayerPedId()
    local coords = PoliceOfficerCoords
    SetNewWaypoint(coords.x, coords.y)
end


local StaffedOn = false
local Clothing = {}
function HVCModuleC.ClientStaffOnDuty(bool)
    local PlayerPed = PlayerPedId();
    TriggerEvent("HVC:AC:BanCheat", true)
    if bool == "Staffon" and not StaffedOn then
        TriggerServerEvent("HVC:carryForce", true)
        StaffedOn = true
        Clothing = {
            ["arms"]                            = {GetPedDrawableVariation(PlayerPed, 3), GetPedTextureVariation(PlayerPed, 3), GetPedPaletteVariation(PlayerPed, 3)},
            ["pants"]                           = {GetPedDrawableVariation(PlayerPed, 4), GetPedTextureVariation(PlayerPed, 4), GetPedPaletteVariation(PlayerPed, 4)},
            ["shoes"]                           = {GetPedDrawableVariation(PlayerPed, 6), GetPedTextureVariation(PlayerPed, 6), GetPedPaletteVariation(PlayerPed, 6)},
            ["shirt"]                           = {GetPedDrawableVariation(PlayerPed, 8), GetPedTextureVariation(PlayerPed, 8), GetPedPaletteVariation(PlayerPed, 8)},
            ["vests"]                           = {GetPedDrawableVariation(PlayerPed, 9), GetPedTextureVariation(PlayerPed, 9), GetPedPaletteVariation(PlayerPed, 9)},
            ["torso"]                           = {GetPedDrawableVariation(PlayerPed, 11), GetPedTextureVariation(PlayerPed, 11), GetPedPaletteVariation(PlayerPed, 11)}
        }

        if GetEntityHealth(PlayerPedId()) <= 100 then
            TriggerEvent("HVC:FIXCLIENT", source, "1")
        end

        local hash = GetEntityModel(PlayerPedId())
        if hash == 1885233650 then
          SetPedComponentVariation(PlayerPed, 3, 30, 0 , 0)
          SetPedComponentVariation(PlayerPed, 4, 133, 0, 0)
          SetPedComponentVariation(PlayerPed, 6, 124, 0 , 0)
          SetPedComponentVariation(PlayerPed, 8, 15, 0, 0)
          SetPedComponentVariation(PlayerPed, 11, 429, 0, 0)
        else
          SetPedComponentVariation(PlayerPed, 11, 38, 0, 0)
          SetPedComponentVariation(PlayerPed, 4, 62, 2, 0)
          SetPedComponentVariation(PlayerPed, 6, 51, 0, 0)
          SetPedComponentVariation(PlayerPed, 8, 15, 0, 0)
          SetPedComponentVariation(PlayerPed, 3, 18, 0, 0)
        end


        Citizen.CreateThread(function()
            while true do
                Wait(0)
                if StaffedOn then 
                    TriggerEvent("HVC:AC:BanCheat", true)
                    SetEntityProofs(PlayerPed, true, true, true, true, true, true, 1, true)
                    BeginTextCommandPrint("STRING");
                    AddTextComponentString("You are staff\'d on, Make sure you /return or /staffoff");
                    EndTextCommandPrint(1, true);
                else
                    break;
                end 
            end
        end)

    elseif bool == "Staffoff"  then
        StaffedOn = false
        TriggerServerEvent("HVC:carryForce", false)
        SetEntityInvincible(PlayerPed, false)
        TriggerEvent("HVC:AC:BanCheat", false)
        for k,v in pairs(Clothing) do
            if k == "arms" then
                SetPedComponentVariation(PlayerPedId(), 3, v[1], v[2], v[3])
            elseif k == "pants" then
                SetPedComponentVariation(PlayerPedId(), 4, v[1], v[2], v[3])
            elseif k == "shoes" then
                SetPedComponentVariation(PlayerPedId(), 6, v[1], v[2], v[3])
            elseif k == "shirt" then
                SetPedComponentVariation(PlayerPedId(), 8, v[1], v[2], v[3])
            elseif k == "vests" then
                SetPedComponentVariation(PlayerPedId(), 9, v[1], v[2], v[3])
            elseif k == "torso" then
                SetPedComponentVariation(PlayerPedId(), 11, v[1], v[2], v[3])
            end
        end

    end
end

function HVCModuleC.ClientDisableReturn()
    DisableReturn()
end

function HVCModuleC.ClientReturnGangIndex(Gang, Name, Funds, Members)
    ReturnGang(Gang, Name, Funds, Members)
end

function HVCModuleC.ClientUpdateGangInfoByType(Type, Updated)
    UpdateGangInfoByType(Type, Updated)
end


function HVCModuleC.ClientReturnGangInviteIndex(Invites)
    ReturnInvites(Invites)
end



function HVCModuleC.PlayerLeftGang()
    LeftGang()
end
