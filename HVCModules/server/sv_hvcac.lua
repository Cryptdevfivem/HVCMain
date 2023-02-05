local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVCModules")


--All these ac events must be used on the server if used on the client and a random finds them they could just trigger you could send tokens back and forward but for now it is what it is

--SetRoutingBucketEntityLockdownMode(0, "strict") 

--Anticheat Tables
ANTICHEAT = {}
ANTICHEAT.Health = {}
ANTICHEAT.Armour = {}
ANTICHEAT.Teleporter = {}
ANTICHEAT.Ammo = {}
ANTICHEAT.Vehicle = {}
ANTICHEAT.Invisible = {}
ANTICHEAT.VehInvisible = {}


RegisterNetEvent("HVC:ACHealthCheck")
AddEventHandler("HVC:ACHealthCheck", function()
    local source = source
    local Name = GetPlayerName(source)
    if ANTICHEAT.Health[tonumber(source)] then
        ANTICHEAT.Health[tonumber(source)] = false;
    else
        HVCclient.isInComa(source, {}, function(in_coma)
            if in_coma then
                local Ped = GetPlayerPed(source)
                local Health = GetEntityHealth(Ped)
                if Health ~= 102 then
                    AnticheatLog(source, "Adding Health")
                end
            else
                if not CheckNhs(source) then
                    AnticheatLog(source, "Adding Health")
                end
            end
        end)
    end
end)

function CheckLSCustoms(source)
    local Ped = GetPlayerPed(source)
    local Coords = GetEntityCoords(Ped)
    if #(Coords - vec3(-337.3863,-136.9247,38.5737)) < 15.0 then
        return true;
    end
    if #(Coords - vec3(733.69,-1088.74,21.733)) < 15.0 then
        return true;
    end
    if #(Coords - vec3(-1155.077,-2006.61,12.465)) < 15.0 then
        return true;
    end
    if #(Coords - vec3(1174.823,2637.807,37.045)) < 15.0 then
        return true;
    end
    if #(Coords - vec3( 108.842,6628.447,31.072)) < 15.0 then
        return true;
    end
    if #(Coords - vec3(-212.368,-1325.486,30.176)) < 15.0 then
        return true;
    end
    return false;
end

function CheaterWarning(source, reason)
    local UserID = HVC.getUserId({source})
    local Name = GetPlayerName(source)
    exports["discord-screenshot"]:requestCustomClientScreenshotUploadToDiscord(source,"https://discord.com/api/webhooks/975475936923353128/ewW2IlRvzFbW31TCveXTAQmOJML8b3B8XKQ3SvrDws3lxRRa9YTjfaLQFmLVC5HUt8eh",
    {
        encoding = "png",
        quality = 1
    },
    {
        username = "HVC Screenshoter",
        avatar_url = "",
        content = "",
        embeds = {
            {
                color = 16384000,
                author = {
                    name = "HVC",
                    icon_url = "https://cdn.discordapp.com/attachments/923683865191661579/972486555971239996/hvc.png"
                },
                title = "User was flagged by Anticheat for ```" ..reason.. "```\n```Name " ..Name.. " / UserID: " ..UserID.. "```"
            }
        },6000,
        function(error)
            if error then
                local Message = {
                    {
                        ["color"] = "16384000",
                        ["title"] = "Cheater Warnings For "..reason.. " Screenshot Failed",
                        ["description"] = "User was flagged by Anticheat \nName: "..Name.." / User Id: " ..UserId.. " \nCoords: " ..GetEntityCoords(GetPlayerPed(source)).. "\nReason: " ..reason,
                    }
                }
                PerformHttpRequest("https://discord.com/api/webhooks/975475936923353128/ewW2IlRvzFbW31TCveXTAQmOJML8b3B8XKQ3SvrDws3lxRRa9YTjfaLQFmLVC5HUt8eh", function(err, text, headers) end, "POST", json.encode({username = "HVC Ban logs", embeds = Message}), { ["Content-Type"] = "application/json" })
            end
     end})
end

function AnticheatLog(source, reason)
    local UserId = HVC.getUserId({source})
    local Name = GetPlayerName(source)
    local Message = {
        {
            ["color"] = "16384000",
            ["title"] = "Player Banned For "..reason,
            ["description"] = "User Banned by Anticheat \nName: "..Name.." / User Id: " ..UserId.. " \nCoords: " ..GetEntityCoords(GetPlayerPed(source)).. "\nReason: " ..reason,
        }
    }
    PerformHttpRequest("https://discord.com/api/webhooks/961242860009717791/ApQrTUJFivtDckdRqDvPNzbI4atiCpkd0P7GS1EcHw5WWXVc2Lctlpa0rKPQywazPhBh", function(err, text, headers) end, "POST", json.encode({username = "HVC Ban logs", embeds = Message}), { ["Content-Type"] = "application/json" })
    BanPlayer(source, reason)
end

RegisterNetEvent("HVC:RespawnMenuAction")
AddEventHandler("HVC:RespawnMenuAction", function(x,y,z)
    local source = source
    local UserID = HVC.getUserId({source})
    HVCclient.isInResp(source, {}, function(Respawnvar) --Weird workaround for vft's work
        if Respawnvar then
            AnticheatTP(source, x,y,z, false, false, false, false)
            HVCAddHealth(source, 200)
            HVC.clearInventory({UserID})
            TriggerClientEvent("HVC:FIXCLIENT", source)
            HVCclient.disableRes(source)
        else
            AnticheatLog(source, "Respawn Trigger")
        end
    end)
end)

function CheckNhs(source)
    local Ped = GetPlayerPed(source)
    local Coords = GetEntityCoords(Ped)
    local UserID = HVC.getUserId({source})
    if #(Coords - vec3(-255.81, 6334.32, 32.43)) < 15.0 then
        return true;
    end
    if #(Coords - vec3(308.17, -592.17, 43.30)) < 15.0 then
        return true;
    end
    if #(Coords - vec3(1836.86, 3679.96, 34.27)) < 15.0 then
        return true;
    end
    return false;
end

RegisterNetEvent("HVC:ProvideHealth")
AddEventHandler("HVC:ProvideHealth", function(source, amount)
    HVCAddHealth(source, amount)
end)

function HVCAddHealth(player, amount)
    local source = tonumber(player)
    local currentHealth = GetEntityHealth(GetPlayerPed(source))
    if amount >= currentHealth then
        ANTICHEAT.Health[source] = true;
        HVCclient.setHealth(source, {amount})
    else
        HVCclient.setHealth(source, {amount})
    end
end

----------Armour--------------

RegisterNetEvent("HVC:ArmourCheck")
AddEventHandler("HVC:ArmourCheck", function(armour, armour2)
    local source = source
    if ANTICHEAT.Armour[source] then
        ANTICHEAT.Armour[source] = false;
    else
        local Message = {
            {
                ["color"] = "16384000",
                ["title"] = "Player Banned For Spawning In Armour",
                ["description"] = "User Banned by Anticheat \nName: "..GetPlayerName(source).." / User Id: " ..HVC.getUserId({source}).. " \nCoords: " ..GetEntityCoords(GetPlayerPed(source)).. "\nReason: Spawning in armour\nArmour before Modification: " ..armour.. " - Armour after Modification: " ..armour2,
            }
        }
        PerformHttpRequest("https://discord.com/api/webhooks/961242860009717791/ApQrTUJFivtDckdRqDvPNzbI4atiCpkd0P7GS1EcHw5WWXVc2Lctlpa0rKPQywazPhBh", function(err, text, headers) end, "POST", json.encode({username = "HVC Ban logs", embeds = Message}), { ["Content-Type"] = "application/json" })
        BanPlayer(source, "Spawning in Armour")
    end
end)

RegisterNetEvent("HVC:ProvideArmour") --Trigger this event always on the server never on the client otherwise they could bypass it/ will be changing soon
AddEventHandler("HVC:ProvideArmour", function(source, amount)
    HVCAddArmour(source, amount)
end)

function HVCAddArmour(player, amount)
    local source = tonumber(player)
    local Ped = GetPlayerPed(source)
    local currentArmour = GetPedArmour(Ped)
    if amount >= currentArmour then
        ANTICHEAT.Armour[source] = true;
        SetPedArmour(Ped, amount)
    else
        SetPedArmour(Ped, amount)
    end
end

RegisterNetEvent("HVC:ACnoClip") --Trigger this event always on the server never on the client otherwise they could bypass it/ will be changing soon
AddEventHandler("HVC:ACnoClip", function(source, bool)
    ANTICHEAT.VehInvisible[source] = bool;
end)


local BlockedExplosions = {1, 2, 4, 5, 25, 32, 33, 35, 36, 37, 38}
AddEventHandler("explosionEvent",function(sender, ev)
    local userid = HVC.getUserId({sender})
    for _, v in ipairs(BlockedExplosions) do
        if ev.explosionType == v then
            BanPlayer(sender, "Blacklisted Explosion")
            CancelEvent()
        end
    end
end)

-----------Player Thread--------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(6000)
        for i,v in ipairs(GetPlayers()) do
            local v = tonumber(v)
            local Ped = GetPlayerPed(v)
            local Weapon = GetSelectedPedWeapon(Ped)
            local Visible = IsEntityVisible(Ped)
            if not Visible and not ANTICHEAT.Invisible[v] then
                CheaterWarning(v, "Player Invisible")
                ANTICHEAT.Invisible[v] = os.time() + tonumber(60) --60 timeout just for discord's rate limit
            else
                if ANTICHEAT.Invisible[v] and (ANTICHEAT.Invisible[v] < os.time()) then
                    ANTICHEAT.Invisible[v] = nil;
                end
            end
            local SuperJump = IsPlayerUsingSuperJump(v)
            local Vehicle = GetVehiclePedIsIn(Ped, false)
            if Vehicle ~= 0 then
                if not IsEntityVisible(Vehicle) and not ANTICHEAT.VehInvisible[v] then
                    BanPlayer(v, "Vehicle Invisible")
                end
                if ANTICHEAT.Vehicle[Vehicle] and (ANTICHEAT.Vehicle[Vehicle] < GetVehicleEngineHealth(Vehicle)) and GetVehiclePedIsIn(Ped, false) == Vehicle then
                    VehicleDataMissMatch(v,ANTICHEAT.Vehicle[Vehicle], GetVehicleEngineHealth(Vehicle))
                else
                    ANTICHEAT.Vehicle[Vehicle] = GetVehicleEngineHealth(Vehicle)
                end
            end
            if SuperJump then
                AnticheatLog(v, "Super Jump")
            end
            if Weapon ~= -1569615261 then 
                local Damage = GetPlayerWeaponDamageModifier(v)
                local Damage1 = GetPlayerMeleeWeaponDamageModifier(v)
                if Damage > 1.0 then
                    BanPlayer(v, "Damage Multipler")
                end
                if Damage1 > 1.0 then
                    BanPlayer(v, "Damage Multipler")
                end
            end
        end
    end
end)


--You must add add all ban reasons that will be used within BanEvent below
local Reasons = {
    ["Modified Speed Value"] = {};
}

RegisterServerEvent("HVC:BanEvent")
AddEventHandler("HVC:BanEvent", function(Flag, Extra)
    local source = source
    if not Reasons[Flag] then
        AnticheatLog(source, "Executor(Ban Event)")
    else
        BanPlayer(source, Flag)
    end
end)

function VehicleDataMissMatch(source, InitH,AfterH)
    local Ped = GetPlayerPed(source)
    local UserID = HVC.getUserId({source})
    local Vehicle = GetVehiclePedIsIn(Ped, false)
    if HVC.hasPermission({UserID, "group.remove.founder"}) then
        ANTICHEAT.Vehicle[Vehicle] = GetVehicleEngineHealth(Vehicle)
    else
        if HVC.hasPermission({UserID, "cardev.acess"}) and GetEntityRoutingBucket(Ped) == UserID then
            ANTICHEAT.Vehicle[Vehicle] = GetVehicleEngineHealth(Vehicle)
        else
            if not CheckLSCustoms(source) then
                CheaterWarning(source, "Repairing Vehicle ╽ Initial vehicle health: " ..InitH.. " Last recorded health: " ..AfterH)
                ANTICHEAT.Vehicle[Vehicle] = GetVehicleEngineHealth(Vehicle)
            end
        end
    end
end

-------Checks--------
local BlackListTable = {
    "WEAPON_KNIFE",
    "WEAPON_KNUCKLE",
    "WEAPON_NIGHTSTICK",
    "WEAPON_HAMMER",
    "WEAPON_BAT",
    "WEAPON_GOLFCLUB",
    "WEAPON_CROWBAR",
    "WEAPON_BOTTLE",
    "WEAPON_DAGGER",
    "WEAPON_HATCHET",
    "WEAPON_MACHETE",
    "WEAPON_FLASHLIGHT",
    "WEAPON_SWITCHBLADE",
    "WEAPON_PISTOL",
    "WEAPON_PISTOL_MK2",
    "WEAPON_COMBATPISTOL",
    "WEAPON_APPISTOL",
    "WEAPON_PISTOL50",
    "WEAPON_SNSPISTOL",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_MARKSMANPISTOL",
    "WEAPON_REVOLVER",
    "WEAPON_MICROSMG",
    "WEAPON_SMG",
    "WEAPON_SMG_MK2",
    "WEAPON_ASSAULTSMG",
    "WEAPON_MG",
    "WEAPON_COMBATMG",
    "WEAPON_COMBATMG_MK2",
    "WEAPON_COMBATPDW",
    "WEAPON_GUSENBERG",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_ASSAULTRIFLE_MK2",
    "WEAPON_CARBINERIFLE",
    "WEAPON_CARBINERIFLE_MK2",
    "WEAPON_ADVANCEDRIFLE",
    "WEAPON_SPECIALCARBINE",
    "WEAPON_BULLPUPRIFLE",
    "WEAPON_COMPACTRIFLE",
    "WEAPON_PUMPSHOTGUN",
    "WEAPON_SAWNOFFSHOTGUN",
    "WEAPON_BULLPUPSHOTGUN",
    "WEAPON_ASSAULTSHOTGUN",
    "WEAPON_MUSKET",
    "WEAPON_HEAVYSHOTGUN",
    "WEAPON_DBSHOTGUN",
    "WEAPON_SNIPERRIFLE",
    "WEAPON_HEAVYSNIPER",
    "WEAPON_HEAVYSNIPER_MK2",
    "WEAPON_MARKSMANRIFLE",
    "WEAPON_GRENADELAUNCHER",
    "WEAPON_GRENADELAUNCHER_SMOKE",
    "WEAPON_RPG",
    "WEAPON_STINGER",
    "WEAPON_FIREWORK",
    "WEAPON_HOMINGLAUNCHER",
    "WEAPON_GRENADE",
    "WEAPON_STICKYBOMB",
    "WEAPON_PROXMINE",
    "WEAPON_BZGAS",
    "WEAPON_SMOKEGRENADE",
    "WEAPON_MOLOTOV",
    "WEAPON_FIREEXTINGUISHER",
    "WEAPON_PETROLCAN",
    "WEAPON_SNOWBALL",
    "WEAPON_FLARE",
    "WEAPON_BALL",
    "weapon_wrench",
    "weapon_autoshotgun",
    "weapon_battleaxe",
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(250)
        for i,v in ipairs(GetPlayers()) do
            local v = tonumber(v)
            local Ped = GetPlayerPed(v)
            local Weapon = GetSelectedPedWeapon(Ped, true)
             if isWeaponBlacklisted(Weapon) then
                RemoveWeaponFromPed(Ped, Weapon)
             end
        end
    end
end)

--------------------------Ammo Tracking-----------------------------------------
RegisterNetEvent("HVC:RegularAmmoCheck")
AddEventHandler("HVC:RegularAmmoCheck", function(ammo,ammo1,hash)
    local source = source
    local UserID = HVC.getUserId({source})
    if ANTICHEAT.Ammo[source] then
        ANTICHEAT.Ammo[source] = false
    else
        if not HVC.hasPermission({UserID, "group.add.founder"}) then
            local Message = {
                {
                    ["color"] = "16384000",
                    ["title"] = "Spawning in Ammo.",
                    ["description"] = "Name: "..GetPlayerName(source).." User Id: " ..HVC.getUserId({source}).. "\nCoords: " ..GetEntityCoords(GetPlayerPed(source)).. " \nAmmo after Modification: " ..ammo.. " \nammo before Modification: " ..ammo1.. " \nWeapon hash: " ..hash,
                }
            }
            PerformHttpRequest("https://discord.com/api/webhooks/961242860009717791/ApQrTUJFivtDckdRqDvPNzbI4atiCpkd0P7GS1EcHw5WWXVc2Lctlpa0rKPQywazPhBh", function(err, text, headers) end, "POST", json.encode({username = "HVC Ban logs", embeds = Message}), { ["Content-Type"] = "application/json" })
            BanPlayer(source, "Spawning in Ammo")
        end
    end
end)

RegisterNetEvent("HVC:ProvideLegitAmmo")
AddEventHandler("HVC:ProvideLegitAmmo", function(source)
    ANTICHEAT.Ammo[source] = true;
end)

function isWeaponBlacklisted(model)
	for _, blacklistedWeapon in pairs(BlackListTable) do
		if model == GetHashKey(blacklistedWeapon) then
			return true
		end
	end
	return false
end

function BanPlayer(source, reason)
    local UserID = HVC.getUserId({source})
    local Name = GetPlayerName(source)
    local Coords = GetEntityCoords(GetPlayerPed(source))
    local CurrentTime = os.time()
    CurrentTime = CurrentTime + (60 * 60 * 500000)
    HVC.BanUser({source, reason, CurrentTime, "HVC"})
end

RegisterNetEvent("HVC:TeleportPlayer") --ignore for now
AddEventHandler("HVC:TeleportPlayer", function(source, xPos, yPos, zPos, xAxis, yAxis, zAxis, clearArea)
    AnticheatTP(source, xPos, yPos, zPos, xAxis, yAxis, zAxis, clearArea)
end)

function AnticheatTP(source, xPos, yPos, zPos, xAxis, yAxis, zAxis, clearArea)
    local source = tonumber(source)
    local ped = GetPlayerPed(source)
    ANTICHEAT.Teleporter[source] = true;
    SetEntityCoords(ped, xPos, yPos, zPos, xAxis, yAxis, zAxis, clearArea)
    Citizen.Wait(1000)
    ANTICHEAT.Teleporter[source] = false;
end

RegisterNetEvent("HVC:TPToWaypointCheck")
AddEventHandler("HVC:TPToWaypointCheck", function() --future update.
    local source = source
    if ANTICHEAT.Teleporter[source] then

    else
        BanPlayer(source, "Teleport To Waypoint")
    end
end)