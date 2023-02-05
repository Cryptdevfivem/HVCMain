local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "Vrxith Administration")

local adminlevel = 0
local PlayerSavedLocations = {}
local FrozenPlayerList = {}


RegisterServerEvent('Vrxith:Adminsitration:GetAllPlayerData')
AddEventHandler('Vrxith:Adminsitration:GetAllPlayerData', function()
    local user_id = HVC.getUserId({source})
    if HVC.hasGroup({user_id, "founder"}) then
        adminlevel = 12
    elseif HVC.hasGroup({user_id, "ldev"}) then
        adminlevel = 11
    elseif HVC.hasGroup({user_id, "operationsmanager"}) then
        adminlevel = 10
    elseif HVC.hasGroup({user_id, "staffmanager"}) then
        adminlevel = 10
    elseif HVC.hasGroup({user_id, "commanager"}) then
        adminlevel = 9
    elseif HVC.hasGroup({user_id, "headadmin"}) then
        adminlevel = 7
    elseif HVC.hasGroup({user_id, "senioradmin"}) then
        adminlevel = 6
    elseif HVC.hasGroup({user_id, "administrator"}) then
        adminlevel = 5
    elseif HVC.hasGroup({user_id, "smoderator"}) then
        adminlevel = 4
    elseif HVC.hasGroup({user_id, "moderator"}) then
        adminlevel = 4
    elseif HVC.hasGroup({user_id, "dev"}) then
        adminlevel = 3
    elseif HVC.hasGroup({user_id, "support"}) then
        adminlevel = 2
    elseif HVC.hasGroup({user_id, "trialstaff"}) then
        adminlevel = 1
    end

    if adminlevel > 0 then
        players = GetPlayers()
        players_table = {}
        for _,ActivePlayers in pairs(players) do
            name = GetPlayerName(ActivePlayers)
            user_id = HVC.getUserId({ActivePlayers})
            data = HVC.getUserDataTable({user_id})
            TimePlayed = (data.timePlayed/3600) + 0.5
            players_table[user_id] = {name, ActivePlayers, user_id, math.floor(TimePlayed)}
        end
        TriggerClientEvent("Vrxith:Adminsitration:SendAllPlayerData", source, players_table, adminlevel)
    end
end)

RegisterServerEvent('Vrxith:Adminsitration:PermissionCheck')
AddEventHandler('Vrxith:Adminsitration:PermissionCheck', function()
    local source = source
    local user_id = HVC.getUserId({source})
    if HVC.hasPermission({user_id, "admin.menu"}) then  
        TriggerClientEvent("Vrxith:Adminsitration:OpenAdministrationMenu", source)
    end
end)


RegisterServerEvent('Vrxith:Adminsitration:GetPlayerGroups')
AddEventHandler('Vrxith:Adminsitration:GetPlayerGroups', function(PlayerPermID)
    local source = source
    local user_id = HVC.getUserId({source})
    if HVC.hasPermission({user_id, "admin.menu"}) then  
        local PlayerGroups = HVC.getUserGroups({PlayerPermID})
        TriggerClientEvent("Vrxith:Adminsitration:RecievePlayerGroups", source, PlayerGroups)
    end
end)

RegisterServerEvent('Vrxith:Adminsitration:KickPlayer')
AddEventHandler('Vrxith:Adminsitration:KickPlayer', function(PlayerSource)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    local PlayerID = HVC.getUserId({PlayerSource})
    local LogChannel = "webhookhere"
    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        HVC.prompt({source, "Reason for kick","",function(player, Reason)
            local Reason = Reason or ""
            if Reason ~= nil and Reason ~= "" then
                local communityname = "HVC Staff Logs"
                local communtiylogo = "" --Must end with .png or .jpg
        
                local command = {
                    {
                        ["color"] = "15536128",
                        ["fields"] = {
                            {
                                ["name"] = "**Admin Name**",
                                ["value"] = "" ..AdminName,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Admin TempID**",
                                ["value"] = "" ..AdminTemp,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Admin PermID**",
                                ["value"] = "" ..AdminPermID,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player Name**",
                                ["value"] = "" .. GetPlayerName(PlayerSource),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player TempID**",
                                ["value"] = "" ..PlayerSource,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player PermID**",
                                ["value"] = ""..PlayerID,
                                ["inline"] = true
                            },
                        },
                        ["title"] = GetPlayerName(PlayerSource).." Was Kicked",
                        ["description"] = "**Kick Reason**\n```\n"..Reason.."```",
                        ["footer"] = {
                        ["text"] = communityname,
                        ["icon_url"] = communtiylogo,
                        },
                    }
                }

                HVCclient.notify(AdminTemp, {"~g~Kicked UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..")"})
                PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
                HVC.kick({PlayerSource, "[HVC] You were kicked from the server\nYour ID is: "..PlayerID.."\nReason: "..Reason.."\nKicked by "..AdminName})
                TriggerEvent("HVC:saveKickLog", PlayerID, AdminName, Reason)
            else
                HVCclient.notify(AdminTemp, {"~r~You need a reason to kick the player."})
            end
        end})
    end
end)

RegisterServerEvent('Vrxith:Adminsitration:Revive')
AddEventHandler('Vrxith:Adminsitration:Revive', function(PlayerSource)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    local PlayerID = HVC.getUserId({PlayerSource})
    local LogChannel = "webhookhere"
    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "15536128",
                ["title"] = GetPlayerName(PlayerSource).. " was revived",
                ["fields"] = {
                    {
                        ["name"] = "**Admin Name**",
                        ["value"] = "" ..AdminName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin TempID**",
                        ["value"] = "" ..AdminTemp,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin PermID**",
                        ["value"] = "" ..AdminPermID,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Name**",
                        ["value"] = "" .. GetPlayerName(PlayerSource),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player TempID**",
                        ["value"] = "" ..PlayerSource,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player PermID**",
                        ["value"] = ""..PlayerID,
                        ["inline"] = true
                    },
                },
                ["description"] = "",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent("HVC:AC:BanCheat", PlayerSource, true)
        Wait(300)
        HVCclient.ScreenFade(PlayerSource)
        Wait(760)
        TriggerEvent("HVC:ProvideHealth",PlayerSource, 200)
        TriggerClientEvent("HVC:FIXCLIENT", PlayerSource)
        HVCclient.notify(PlayerSource, {"~g~A staff member has revived you!"})
        HVCclient.notify(AdminTemp, {"~g~You revived UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..")"})
        TriggerClientEvent("HVC:AC:BanCheat", PlayerSource, false)
    else
        print(AdminName.. " Maybe cheating, they tried reviving someone")
    end
end)


RegisterServerEvent("Vrxith:Adminsitration:TeleportToPlayer")
AddEventHandler("Vrxith:Adminsitration:TeleportToPlayer", function(PlayerSource)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    local PlayerID = HVC.getUserId({PlayerSource})
    local LogChannel = "webhookhere"
    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "15536128",
                ["title"] = AdminName.. " Teleported To A Player",
                ["fields"] = {
                    {
                        ["name"] = "**Admin Name**",
                        ["value"] = "" ..AdminName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin TempID**",
                        ["value"] = "" ..AdminTemp,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin PermID**",
                        ["value"] = "" ..AdminPermID,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Name**",
                        ["value"] = "" .. GetPlayerName(PlayerSource),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player TempID**",
                        ["value"] = "" ..PlayerSource,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player PermID**",
                        ["value"] = ""..PlayerID,
                        ["inline"] = true
                    },
                },
                ["description"] = "",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        local AdminPed = GetPlayerPed(source)
        local PlayerPed = GetPlayerPed(PlayerSource)
        HVCclient.ScreenFade(AdminTemp)
        Wait(730)
        SetEntityCoords(AdminPed, GetEntityCoords(PlayerPed))
        HVCclient.notify(AdminTemp, {"~g~Teleported to UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..")"})
    end
end)

RegisterNetEvent("HVC:TakeScreenShot")
AddEventHandler("HVC:TakeScreenShot", function(PlayerSource)
    local source = source
    local UserID = HVC.getUserId({source})
    if HVC.hasPermission({UserID, "admin.menu"}) then
        if PlayerSource == "-1" then
            local BanTime = os.time() + (60 * 60 * 500000)
            HVC.BanUser({source, "Executor(Client Protection)", BanTime, "HVC"})
        else
            exports["discord-screenshot"]:requestCustomClientScreenshotUploadToDiscord(PlayerSource,
             "webhookhere",
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
                            title = "-Screenshoted- \n ```" ..GetPlayerName(PlayerSource).. " / UserID: " ..HVC.getUserId({PlayerSource}).. "``` \n-Screenshot Requested by- \n```" ..GetPlayerName(source).. " /UserId: " ..UserID.. "```"
                        }
                    }
                },10000,
                function(error)
                    if error then
                        print(error)
                        return HVCclient.notify(source,{"~r~Action failed. Player has most likely left the server."})
                    end
                end)
            end
        else
            local BanTime = os.time() + (60 * 60 * 500000)
            HVC.BanUser({source, "Executor(Client Protection)", BanTime, "HVC"})
        end
    end)

RegisterServerEvent("Vrxith:Adminsitration:TeleportPlayerToMe")
AddEventHandler("Vrxith:Adminsitration:TeleportPlayerToMe", function(PlayerSource)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    local PlayerID = HVC.getUserId({PlayerSource})
    local LogChannel = "webhookhere"
    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "15536128",
                ["title"] = AdminName.. " Teleported A Player To Them",
                ["fields"] = {
                    {
                        ["name"] = "**Admin Name**",
                        ["value"] = "" ..AdminName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin TempID**",
                        ["value"] = "" ..AdminTemp,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin PermID**",
                        ["value"] = "" ..AdminPermID,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Name**",
                        ["value"] = "" .. GetPlayerName(PlayerSource),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player TempID**",
                        ["value"] = "" ..PlayerSource,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player PermID**",
                        ["value"] = ""..PlayerID,
                        ["inline"] = true
                    },
                },
                ["description"] = "",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        local AdminPed = GetPlayerPed(source)
        local PlayerPed = GetPlayerPed(PlayerSource)
        HVCclient.ScreenFade(PlayerSource)
        Wait(730)
        HVCclient.notify(AdminTemp, {"~g~Teleported UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..") to you."})
        SetEntityCoords(PlayerPed, GetEntityCoords(AdminPed))
    end
end)

RegisterServerEvent("Vrxith:Adminsitration:TeleportPlayerToAdminZone")
AddEventHandler("Vrxith:Adminsitration:TeleportPlayerToAdminZone", function(PlayerSource)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    local PlayerID = HVC.getUserId({PlayerSource})
    local LogChannel = "webhookhere"
    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "15536128",
                ["title"] = AdminName.. " Teleported a player to admin zone",
                ["fields"] = {
                    {
                        ["name"] = "**Admin Name**",
                        ["value"] = "" ..AdminName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin TempID**",
                        ["value"] = "" ..AdminTemp,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin PermID**",
                        ["value"] = "" ..AdminPermID,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Name**",
                        ["value"] = "" .. GetPlayerName(PlayerSource),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player TempID**",
                        ["value"] = "" ..PlayerSource,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player PermID**",
                        ["value"] = ""..PlayerID,
                        ["inline"] = true
                    },
                },
                ["description"] = "",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        local PlayerPed = GetPlayerPed(PlayerSource)
        PlayerSavedLocations[PlayerID] = GetEntityCoords(PlayerPed);
        HVCclient.ScreenFade(PlayerSource)
        Wait(730)
        HVCclient.notify(AdminTemp, {"~g~Teleported UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..") to admin zone."})
        SetEntityCoords(PlayerPed, 3486.2351074218,2583.4965820312,14.230317115784)
    end
end)

RegisterServerEvent("Vrxith:Adminsitration:TeleportPlayerBackFromAdminZone")
AddEventHandler("Vrxith:Adminsitration:TeleportPlayerBackFromAdminZone", function(PlayerSource)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    local PlayerID = HVC.getUserId({PlayerSource})
    local LogChannel = "webhookhere"

    if PlayerSavedLocations[PlayerID] == nil then
        HVCclient.notify(AdminTemp, {"~r~Unable to teleport UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..") back from admin zone."})
        return
    end

    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "15536128",
                ["title"] = AdminName.. " Teleported A Player Back From Admin Zone",
                ["fields"] = {
                    {
                        ["name"] = "**Admin Name**",
                        ["value"] = "" ..AdminName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin TempID**",
                        ["value"] = "" ..AdminTemp,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin PermID**",
                        ["value"] = "" ..AdminPermID,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Name**",
                        ["value"] = "" .. GetPlayerName(PlayerSource),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player TempID**",
                        ["value"] = "" ..PlayerSource,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player PermID**",
                        ["value"] = ""..PlayerID,
                        ["inline"] = true
                    },
                },
                ["description"] = "",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        local PlayerPed = GetPlayerPed(PlayerSource)
        HVCclient.ScreenFade(PlayerSource)
        Wait(730)
        HVCclient.notify(AdminTemp, {"~g~Teleported UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..") to admin zone."})
        SetEntityCoords(PlayerPed, PlayerSavedLocations[PlayerID])
        Wait(100)
        PlayerSavedLocations[PlayerID] = nil;
    end
end)

RegisterServerEvent("Vrxith:Adminsitration:TeleportPlayerToLegion")
AddEventHandler("Vrxith:Adminsitration:TeleportPlayerToLegion", function(PlayerSource)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    local PlayerID = HVC.getUserId({PlayerSource})
    local LogChannel = "webhookhere"
    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "15536128",
                ["title"] = AdminName.. " Teleported A Player To Admin Zone",
                ["fields"] = {
                    {
                        ["name"] = "**Admin Name**",
                        ["value"] = "" ..AdminName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin TempID**",
                        ["value"] = "" ..AdminTemp,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin PermID**",
                        ["value"] = "" ..AdminPermID,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Name**",
                        ["value"] = "" .. GetPlayerName(PlayerSource),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player TempID**",
                        ["value"] = "" ..PlayerSource,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player PermID**",
                        ["value"] = ""..PlayerID,
                        ["inline"] = true
                    },
                },
                ["description"] = "",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        local PlayerPed = GetPlayerPed(PlayerSource)
        HVCclient.ScreenFade(PlayerSource)
        Wait(730)
        HVCclient.notify(AdminTemp, {"~g~Teleported UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..") to legion."})
        SetEntityCoords(PlayerPed, 157.43502807618,-1040.0378417968,29.260438919068)
    end
end)

RegisterServerEvent('Vrxith:Adminsitration:ToggleFreeze')
AddEventHandler('Vrxith:Adminsitration:ToggleFreeze', function(PlayerSource, Freeze)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    local PlayerID = HVC.getUserId({PlayerSource})
    local LogChannel = "webhookhere"

    if FrozenPlayerList[PlayerID] == nil then
        FrozenPlayerList[PlayerID] = "Unfrozen";
        HVCclient.notify(AdminTemp, {"~r~Unable to freeze User ID "..PlayerID.."("..GetPlayerName(PlayerSource)..") Try again"})
        TriggerClientEvent("Vrxith:Adminsitration:FailedFroze", AdminTemp)
        return
    end

    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "15536128",
                ["title"] = GetPlayerName(PlayerSource).. " Was " ..FrozenPlayerList[PlayerID],
                ["fields"] = {
                    {
                        ["name"] = "**Admin Name**",
                        ["value"] = "" ..AdminName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin TempID**",
                        ["value"] = "" ..AdminTemp,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin PermID**",
                        ["value"] = "" ..AdminPermID,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Name**",
                        ["value"] = "" .. GetPlayerName(PlayerSource),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player TempID**",
                        ["value"] = "" ..PlayerSource,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player PermID**",
                        ["value"] = ""..PlayerID,
                        ["inline"] = true
                    },
                },
                ["description"] = "",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })

        if Freeze and FrozenPlayerList[PlayerID] == "Unfrozen" then
            FrozenPlayerList[PlayerID] = "Frozen";
            HVCclient.notify(AdminTemp, {"~g~You froze UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..")"})
            TriggerClientEvent("Vrxith:Adminsitration:Freeze", PlayerSource, true)

        elseif not Freeze and FrozenPlayerList[PlayerID] == "Frozen" then
            FrozenPlayerList[PlayerID] = "Unfrozen";
            HVCclient.notify(AdminTemp, {"~g~You unfroze UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..")"})
            TriggerClientEvent("Vrxith:Adminsitration:Freeze", PlayerSource, false)
        else
            HVCclient.notify(AdminTemp, {"~r~Unable to freeze User ID "..PlayerID.."("..GetPlayerName(PlayerSource)..")"})
            TriggerClientEvent("Vrxith:Adminsitration:FailedFroze", AdminTemp)
        end
        
    end
end)

RegisterServerEvent('Vrxith:Adminsitration:SlapPlayer')
AddEventHandler('Vrxith:Adminsitration:SlapPlayer', function(PlayerSource)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    local PlayerID = HVC.getUserId({PlayerSource})
    local LogChannel = "webhookhere"
    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "15536128",
                ["title"] = GetPlayerName(PlayerSource).. " Was Slapped",
                ["fields"] = {
                    {
                        ["name"] = "**Admin Name**",
                        ["value"] = "" ..AdminName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin TempID**",
                        ["value"] = "" ..AdminTemp,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin PermID**",
                        ["value"] = "" ..AdminPermID,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Name**",
                        ["value"] = "" .. GetPlayerName(PlayerSource),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player TempID**",
                        ["value"] = "" ..PlayerSource,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player PermID**",
                        ["value"] = ""..PlayerID,
                        ["inline"] = true
                    },
                },
                ["description"] = "",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
        HVCclient.SetEntityHealth(PlayerSource, {0})
        HVCclient.notify(AdminTemp, {"~g~You slapped UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..")"})
    else
        print(AdminName.. " Maybe cheating, they tried slapping someone")
    end
end)


RegisterServerEvent('Vrxith:Adminsitration:ForceClockOff')
AddEventHandler('Vrxith:Adminsitration:ForceClockOff', function(PlayerSource)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    local PlayerID = HVC.getUserId({PlayerSource})
    local CurrentJob = "N/A"
    local LogChannel = "webhookhere"

    if HVC.hasPermission({AdminPermID, "police.menu"}) then
        CurrentJob = "MPD"
    elseif HVC.hasPermission({AdminPermID, "emscheck.revive"}) then
        CurrentJob = "NHS"
    else
        HVCclient.notify(AdminTemp, {"~r~Unable to force UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..") to clock off as they are a civilian"})
        return
    end


    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "15536128",
                ["title"] = GetPlayerName(PlayerSource).. " Was Forced Off Their Job",
                ["fields"] = {
                    {
                        ["name"] = "**Admin Name**",
                        ["value"] = "" ..AdminName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin TempID**",
                        ["value"] = "" ..AdminTemp,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin PermID**",
                        ["value"] = "" ..AdminPermID,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Name**",
                        ["value"] = "" .. GetPlayerName(PlayerSource),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player TempID**",
                        ["value"] = "" ..PlayerSource,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player PermID**",
                        ["value"] = ""..PlayerID,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Job**",
                        ["value"] = ""..CurrentJob,
                        ["inline"] = true
                    },
                },
                ["description"] = "",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent("Vrxith:Adminsitration:ClockForce", PlayerSource, group)
        HVC.addUserGroup({PlayerID, "Unemployed"})
        HVCclient.notify(AdminTemp, {"~g~You forced UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..") off their current job"})
    else
        print(AdminName.. " Maybe cheating, they tried forcing someone to clock off")
    end
end)


RegisterServerEvent("Vrxith:Adminsitration:GetNearest")
AddEventHandler("Vrxith:Adminsitration:GetNearest",function(distance)
    
    local admin = source
    local admin_id = HVC.getUserId({admin})
    local admin_coords = GetEntityCoords(GetPlayerPed(source))

    if HVC.hasPermission({admin_id, "admin.menu"}) then

        players = GetPlayers()
        players_table = {}

        for k, v in pairs(players) do
            local ped = GetPlayerPed(v)
            local pedcoords = GetEntityCoords(ped)
            local compare = #(admin_coords - pedcoords)
            name = GetPlayerName(v)
            user_id = HVC.getUserId({v})
            data = HVC.getUserDataTable({user_id})
            TimePlayed = (data.timePlayed/3600) + 0.5
            if compare < distance*100 then
                players_table[v] = {name, v, user_id, math.floor(TimePlayed)}
            end

        end   
        
        TriggerClientEvent("Vrxith:Adminsitration:RecieveNearbyPlayers", source, players_table)
    end
end)

RegisterServerEvent('Vrxith:Adminsitration:GetCoords')
AddEventHandler('Vrxith:Adminsitration:GetCoords', function()
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        HVC.prompt({AdminTemp, "Got Coords", GetEntityCoords(GetPlayerPed(AdminTemp)),function(player, Reason)
        end})
    end
end)


RegisterServerEvent('Vrxith:Adminsitration:F10Kick')
AddEventHandler('Vrxith:Adminsitration:F10Kick', function()
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    local LogChannel = "webhookhere"
    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        HVC.prompt({AdminTemp, "Enter Player's TempID", "",function(player, tempid)
            local tempid = tempid or ""
            if tempid ~= nil and tempid ~= "" then
                HVC.prompt({AdminTemp, "Enter reason", "",function(player, Reason)
                    local Reason = Reason or ""
                    if Reason ~= nil and Reason ~= "" then
                        local PlayerSource = tonumber(tempid)
                        local PlayerID = HVC.getUserId({PlayerSource})
                        local communityname = "HVC Staff Logs"
                        local communtiylogo = "" --Must end with .png or .jpg
                
                        local command = {
                            {
                                ["color"] = "15536128",
                                ["fields"] = {
                                    {
                                        ["name"] = "**Admin Name**",
                                        ["value"] = "" ..AdminName,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "**Admin TempID**",
                                        ["value"] = "" ..AdminTemp,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "**Admin PermID**",
                                        ["value"] = "" ..AdminPermID,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "**Player Name**",
                                        ["value"] = "" .. GetPlayerName(PlayerSource),
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "**Player TempID**",
                                        ["value"] = "" ..PlayerSource,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "**Player PermID**",
                                        ["value"] = ""..PlayerID,
                                        ["inline"] = true
                                    },
                                },
                                ["title"] = GetPlayerName(PlayerSource).." Was Kicked (No F10)",
                                ["description"] = "**Kick Reason**\n```\n"..Reason.."```",
                                ["footer"] = {
                                ["text"] = communityname,
                                ["icon_url"] = communtiylogo,
                                },
                            }
                        }
        
                        HVCclient.notify(AdminTemp, {"~g~Kicked UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..")"})
                        PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
                        HVC.kick({PlayerSource, "[HVC] You were kicked from the server\nYour ID is: "..PlayerID.."\nReason: "..Reason.."\nKicked by "..AdminName})
                    end
                end})
            end
        end})
    end
end)


RegisterServerEvent('Vrxith:Adminsitration:TeleportToCoords')
AddEventHandler('Vrxith:Adminsitration:TeleportToCoords', function()
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    local LogChannel = "webhookhere"
    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        HVC.prompt({AdminTemp, "Enter the coords", "",function(player, Coords)
            local Coords = Coords or ""
            if Coords ~= nil and Coords ~= "" then
                local communityname = "HVC Staff Logs"
                local communtiylogo = "" --Must end with .png or .jpg
        
                local command = {
                    {
                        ["color"] = "15536128",
                        ["fields"] = {
                            {
                                ["name"] = "**Admin Name**",
                                ["value"] = "" ..AdminName,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Admin TempID**",
                                ["value"] = "" ..AdminTemp,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Admin PermID**",
                                ["value"] = "" ..AdminPermID,
                                ["inline"] = true
                            },
                        },
                        ["title"] = AdminName.." Teleport To Coords",
                        ["description"] = "**Coords**\n```\n"..Coords.."```",
                        ["footer"] = {
                        ["text"] = communityname,
                        ["icon_url"] = communtiylogo,
                        },
                    }
                }

                HVCclient.notify(AdminTemp, {"~g~Successfully teleported to coords"})
                PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
                HVCclient.ScreenFade(AdminTemp)
                Wait(730)
                SetEntityCoords(GetPlayerPed(AdminTemp), Coords)
            else
                HVCclient.notify(AdminTemp, {"~r~You need to enter coords. you can't leave this field empty."})
            end
        end})
    end
end)

-- webhookhere


RegisterServerEvent("Vrxith:Adminsitration:OfflineBan")
AddEventHandler("Vrxith:Adminsitration:OfflineBan",function()
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({source})
    local AdminName = GetPlayerName(AdminTemp)
    local LogChannel = "webhookhere"
    local PlayerDiscordID = 0
    local CurrentTime = os.time()

    if HVC.hasPermission({AdminPermID, "admin.ban"}) then
        HVC.prompt({AdminTemp, "Enter the PermID", "",function(player, PlayerID)
            local PlayerID = tonumber(PlayerID) or ""
            if PlayerID ~= nil and PlayerID ~= "" then
                exports["ghmattimysql"]:execute("SELECT * FROM verification WHERE user_id = @user_id", {user_id = PlayerID}, function(result) 
                    if #result > 0 then
                        PlayerDiscordID = result[1].discord_id
                    else
                        PlayerDiscordID = "none"
                    end
                end)
                HVC.prompt({AdminTemp, "Enter the reason", "",function(player, Reason)
                    local Reason = Reason or ""
                    if Reason ~= nil and Reason ~= "" then
                        HVC.prompt({AdminTemp, "Enter the duration", "",function(player, Duration)
                            local Duration = Duration or ""

                            HVC.prompt({AdminTemp, "Extra Information", "",function(player, Extrainfo)
                                local Extrainfo = Extrainfo or ""
                                
                                exports['ghmattimysql']:execute("SELECT * FROM hvc_users WHERE id = @BA", {BA = PlayerID}, function(result)
                                    if result[1].banadmin == "HVC" then
                                        HVCclient.notify(AdminTemp, {"~r~Cannot ban user. Reason: user is banned by HVC"})
                                        HVCclient.notify(AdminTemp, {"~r~Do not try to unban user using this exploit"})
                                        return
                                    else
                                        if Duration ~= nil and Duration ~= "" then
                                            if tostring(Duration) == "-1" then
                                                CurrentTime = CurrentTime + (60 * 60 * 500000)
                                            else
                                                CurrentTime = CurrentTime + (60 * 60 * tonumber(Duration))
                                            end
                                            HVC.offlineban({PlayerID, Reason, CurrentTime, AdminName})
                                            TriggerEvent("HVC:saveBanLog",PlayerID, AdminName, Reason, Duration)
                                            local communityname = "HVC Ban Log"
                                            local communtiylogo = "" --Must end with .png or .jpg

                                            local command = {
                                                {
                                                    ["color"] = "15536128",
                                                    ["title"] = PlayerID.. " Was Offline Banned",
                                                    ["description"] = "**PermID:** "..PlayerID.."\n**Duration: **" ..Duration.." Hours\n**Discord:** <@"..PlayerDiscordID..">\n**Reason:** "..Reason.."\n**Extra Info: **"..Extrainfo.."\n**Time:** "..os.date("%A, %m %B %Y"),
                                                    ["footer"] = {
                                                    ["text"] = communityname,
                                                    ["icon_url"] = communtiylogo,
                                                    },
                                                }
                                            }
                                            
                                            PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Ban Log", embeds = command}), { ['Content-Type'] = 'application/json' })
                                        else
                                            HVCclient.notify(AdminTemp, {"~r~Duration was left empty."})
                                        end
                                    end
                                end)
                            end})
                        end})
                    else
                        HVCclient.notify(AdminTemp, {"~r~Reason was left empty."})
                    end
                end})
            else
                HVCclient.notify(AdminTemp, {"~r~PlayerID was left empty."})
            end
        end})
    end
end)

RegisterServerEvent("Vrxith:Administration:TeleportToWaypoint")
AddEventHandler("Vrxith:Administration:TeleportToWaypoint",function()
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({AdminTemp})
    local AdminName = GetPlayerName(AdminTemp)
    local LogChannel = "webhookhere"
    local CurrentTime = os.time()
    CurrentTime = CurrentTime + (60 * 60 * 500000)
    
    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg
        local command = {
            {
                ["color"] = "15536128",
                ["title"] = AdminName.. " Teleported to waypoint",
                ["fields"] = {
                    {
                        ["name"] = "**Admin Name**",
                        ["value"] = "" ..AdminName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin TempID**",
                        ["value"] = "" ..AdminTemp,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin PermID**",
                        ["value"] = "" ..AdminPermID,
                        ["inline"] = true
                    },
                },
                ["description"] = "",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
        HVCclient.ScreenFade(source)
        Wait(670)
        HVCclient.notify(AdminTemp, {"~g~Teleported to waypoint!"})
        TriggerClientEvent("Vrxith:Administration:TpToWaypoint", AdminTemp)
    else
        HVC.BanUser({AdminTemp, "Type #13", CurrentTime, "HVC"})
    end
end)

RegisterServerEvent("Vrxith:Administration:Unban")
AddEventHandler("Vrxith:Administration:Unban",function()
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({AdminTemp})
    local AdminName = GetPlayerName(AdminTemp)
    local LogChannel = "webhookhere"

    if HVC.hasPermission({AdminPermID, "admin.ban"}) then
        HVC.prompt({AdminTemp, "Enter the PermID", "",function(player, PlayerID)
            local PlayerID = tonumber(PlayerID) or ""
            if PlayerID ~= nil and PlayerID ~= "" then
                exports['ghmattimysql']:execute("SELECT * FROM hvc_users WHERE id = @BA", {BA = PlayerID}, function(result)
                    if result[1].banadmin == "HVC" then
                        HVCclient.notify(source, {"~r~Cannot unban user. reason: " ..result[1].banreason})
                        HVCclient.notify(source, {"~r~Only founders can unban this user!"})
                        return
                    else
                        HVC.setBanned({PlayerID,false,'','',''})
                        local communityname = "HVC Staff Logs"
                        local communtiylogo = "" --Must end with .png or .jpg
                    
                        local command = {
                            {
                                ["color"] = "15536128",
                                ["title"] = PlayerID.. " Was Unbanned",
                                ["fields"] = {
                                    {
                                        ["name"] = "**Admin Name**",
                                        ["value"] = "" ..AdminName,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "**Admin TempID**",
                                        ["value"] = "" ..AdminTemp,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "**Admin PermID**",
                                        ["value"] = "" ..AdminPermID,
                                        ["inline"] = true
                                    },
                                },
                                ["description"] = "",
                                ["footer"] = {
                                ["text"] = communityname,
                                ["icon_url"] = communtiylogo,
                                },
                            }
                        }
                        
                        HVCclient.notify(AdminTemp, {"Successfully unbanned user ~g~"..PlayerID})
                        PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
                    end
                end)
            end
        end})
    else
        
    end
end)

RegisterServerEvent("Vrxith:Administration:Teleport")
AddEventHandler("Vrxith:Administration:Teleport",function(PlayerSelectedLocation, Coords)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({AdminTemp})
    local AdminName = GetPlayerName(AdminTemp)
    local LogChannel = "webhookhere"

    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "15536128",
                ["title"] = AdminName.. " Just Teleported",
                ["fields"] = {
                    {
                        ["name"] = "**Admin Name**",
                        ["value"] = "" ..AdminName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin TempID**",
                        ["value"] = "" ..AdminTemp,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin PermID**",
                        ["value"] = "" ..AdminPermID,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Location**",
                        ["value"] = "" ..PlayerSelectedLocation,
                        ["inline"] = true
                    },
                },
                ["description"] = "",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })

        local AdminPed = GetPlayerPed(source)
        HVCclient.ScreenFade(source)
        Wait(730)
        HVCclient.notify(AdminTemp, {"~g~Teleported to ".. PlayerSelectedLocation.. "."})
        SetEntityCoords(AdminPed, Coords)
    end
end)


RegisterNetEvent('Vrxith:Administration:RemoveWarning')
AddEventHandler('Vrxith:Administration:RemoveWarning', function()
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({AdminTemp})
    local AdminName = GetPlayerName(AdminTemp)
    local LogChannel = "webhookhere"

    if AdminPermID ~= nil then
        if HVC.hasPermission({AdminPermID, "admin.menu"}) then 
            HVC.prompt({AdminTemp, "Enter the warning ID", "",function(player, WarningID)
                local WarningID = tonumber(WarningID) or ""
                if WarningID ~= nil and WarningID ~= "" then
                    exports['ghmattimysql']:execute("DELETE FROM hvc_warnings WHERE warning_id = @uid", {uid = WarningID})
                    HVCclient.notify(AdminTemp,{"~g~Removed warning " ..WarningID})
                    local communityname = "HVC Staff Logs"
                    local communtiylogo = "" --Must end with .png or .jpg

                    local command = {
                        {
                            ["color"] = "15536128",
                            ["title"] = AdminName.. " Removed A Warning",
                            ["fields"] = {
                                {
                                    ["name"] = "**Admin Name**",
                                    ["value"] = "" ..AdminName,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Admin TempID**",
                                    ["value"] = "" ..AdminTemp,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Admin PermID**",
                                    ["value"] = "" ..AdminPermID,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "**Warning ID**",
                                    ["value"] = "" ..WarningID,
                                    ["inline"] = true
                                },
                            },
                            ["description"] = "",
                            ["footer"] = {
                            ["text"] = communityname,
                            ["icon_url"] = communtiylogo,
                            },
                        }
                    }
                    
                    PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
                end
            end})
        end
    end
end)

local PlayerBan = {
    ["rdm"] = 0,
    ["vdm"] = 0,
    ["massrdm"] = 0,
    ["massvdm"] = 0,
    ["metagaming"] = 0,
    ["powergaming"] = 0,
    ["combatlogging"] = 0,
    ["combatstoring"] = 0,
    ["badrp"] = 0,
    ["failrp"] = 0,
    ["invalidinitiation"] = 0,
    ["nlr"] = 0,
    ["trolling"] = 0,
    ["exploiting"] = 0,
    ["talkingwhiledead"] = 0,
    ["copbaiting"] = 0,
    ["gtadriving"] = 0,
    ["breakingchar"] = 0,
    ["offensivelang"] = 0,
    ["toxicity"] = 0,
    ["racism"] = 0,
    ["whitelistabuse"] = 0,
    ["toev"] = 0,
    ["oogt"] = 0,
    ["scamming"] = 0,
    ["excessivef10"] = 0,
    ["cheating"] = 0,
    ["banevading"] = 0,

    --- New Bans

    ["homophobia"] = 0,
    ["doxing"] = 0,
    ["pii"] = 0,
    ["externalmodifications"] = 0,
    ["affiliationcheaters"] = 0,
    ["withholdingfivemcheats"] = 0,
    ["nrti"] = 0,
    ["spitereporting"] = 0,
    ["wastingadmintime"] = 0,
    ["maliciousactivity"] = 0,
    ["terroristrp"] = 0,
    ["impersonationofwhitelistedfaction"] = 0,
    ["copbaiting"] = 0,
    ["gangimpersonation"] = 0,
    ["gangalliance"] = 0,
    ["staffdiscretion"] = 0, 
    ["ftvl"] = 0,
}

local DefaultBanDurations = {
    ["rdm"] = {24, 48, 72, -1},
    ["vdm"] = {24, 48, 72, -1},
    ["massrdm"] = {-1, -1, -1, -1},
    ["massvdm"] = {-1, -1, -1, -1},
    ["metagaming"] = {24, 48, 72, -1},
    ["powergaming"] = {24, 48, 72, -1},
    ["combatlogging"] = {24, 48, 72, -1},
    ["combatstoring"] = {24, 48, 72, -1},
    ["badrp"] = {24, 48, 72, -1},
    ["failrp"] = {24, 48, 72, -1},
    ["invalidinitiation"] = {24, 48, 72, -1},
    ["nlr"] = {24, 48, 72, -1},
    ["trolling"] = {48, 168, -1},
    ["exploiting"] = {24, 48, 72, -1},
    ["talkingwhiledead"] = {24, 48, 72, -1},
    ["copbaiting"] = {24, 48, 72, -1},
    ["gtadriving"] = {24, 48, 72, -1},
    ["breakingchar"] = {24, 48, 72, -1},
    ["offensivelang"] = {24, 48, 72, -1},
    ["toxicity"] = {24, 48, 72, -1},
    ["racism"] = {168, -1, -1, -1},
    ["whitelistabuse"] = {168, -1, -1, -1},
    ["toev"] = {24, 48, 72, -1},
    ["oogt"] = {-1, -1, -1, -1},
    ["scamming"] = {-1, -1, -1, -1},
    ["excessivef10"] = {-1, -1, -1, -1},
    ["cheating"] = {-1, -1, -1, -1},
    ["banevading"] = {-1, -1, -1, -1},

    --- New Bans

    ["homophobia"] = {168, -1, -1, -1},
    ["doxing"] = {-1, -1, -1, -1},
    ["pii"] = {-1, -1, -1, -1},
    ["externalmodifications"] = {168, -1, -1, -1},
    ["affiliationcheaters"] = {-1, -1, -1, -1},
    ["withholdingfivemcheats"] = {-1, -1, -1, -1},
    ["nrti"] = {24, 48, 72, -1},
    ["spitereporting"] = {24, 48, 72, -1},
    ["wastingadmintime"] = {24, 48, 72, -1},
    ["maliciousactivity"] = {168, -1, -1, -1},
    ["terroristrp"] = {168, -1, -1, -1},
    ["impersonationofwhitelistedfaction"] = {48, 72, 168, -1},
    ["copbaiting"] = {24, 48, 72, -1},
    ["gangimpersonation"] = {48, 72, 168, -1},
    ["gangalliance"] = {48, 72, 168, -1},
    ["staffdiscretion"] = {-1, -1, -1, -1},
    ["ftvl"] = {24, 48, 72, -1}
}


local IndexBanName = {
    ["rdm"] = "RDM",
    ["vdm"] = "VDM",
    ["massrdm"] = "Mass RDM",
    ["massvdm"] = "Mass VDM",
    ["metagaming"] = "Metagaming",
    ["powergaming"] = "Powergaming",
    ["combatlogging"] = "Combat Logging",
    ["combatstoring"] = "Combat Storing",
    ["badrp"] = "Bad-RP",
    ["failrp"] = "Fail-RP",
    ["invalidinitiation"] = "Invalid-Initiation",
    ["nlr"] = "NLR",
    ["trolling"] = "Trolling",
    ["exploiting"] = "Exploiting",
    ["talkingwhiledead"] = "Talking While Dead",
    ["copbaiting"] = "Cop Baiting",
    ["gtadriving"] = "GTA Driving",
    ["breakingchar"] = "Breaking Character",
    ["offensivelang"] = "Offensive Language",
    ["toxicity"] = "Toxicity",
    ["racism"] = "Racism",
    ["whitelistabuse"] = "Whitelist Abuse",
    ["toev"] = "Theft Of An Emergancy Vehicle",
    ["oogt"] = "OOGT",
    ["scamming"] = "Scamming",
    ["excessivef10"] = "Excessive F10",
    ["cheating"] = "Cheating",
    ["banevading"] = "Ban Evading",
    
    -- New Bans

    ["homophobia"] = "Homophobia",
    ["doxing"] = "Doxing",
    ["pii"] = "Personal Identification Information",
    ["externalmodifications"] = "External Modifications",
    ["affiliationcheaters"] = "Affiliation With Cheats",
    ["withholdingfivemcheats"] = "With-Holding/Storing FiveM Cheats",
    ["nrti"] = "No Reason To Initiate",
    ["spitereporting"] = "Spite Reporting",
    ["wastingadmintime"] = "Wasting Admin Time",
    ["maliciousactivity"] = "Malicious Activity",
    ["terroristrp"] = "Terrorist RP",
    ["impersonationofwhitelistedfaction"] = "Impersonation Of A Whitelisted Faction",
    ["copbaiting"] = "Cop Baiting",
    ["gangimpersonation"] = "Gang Impersonation",
    ["gangalliance"] = "Gang Alliance",
    ["staffdiscretion"] = "Staff Discretion",
    ["ftvl"] = "Failure To Value Life",
}


local PlayerOffenses = {}
local PotentialRules = {}
local PlayerBanCachedDuration = {}

RegisterServerEvent("Vrxith:Administration:GenerateBan")
AddEventHandler("Vrxith:Administration:GenerateBan", function(PlayerSource, RulesBroken)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({AdminTemp})
    local AdminName = GetPlayerName(AdminTemp)
    local PlayerID = HVC.getUserId({PlayerSource})
    local PlayerName = GetPlayerName(PlayerSource)
    local PlayerChacheBanMessage = {}
    local PermOffense = false
    HVCclient.notify(source, {"~g~Generating Ban..."})
    PlayerBanCachedDuration[PlayerID] = 0
    PlayerOffenses[PlayerID] = {}
    PotentialRules = {}

    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        exports['ghmattimysql']:execute("SELECT * FROM hvc_bans_offenses WHERE UserID = @UserID", {UserID = PlayerID}, function(result)
            if #result > 0 then
                PlayerOffenses[PlayerID] = json.decode(result[1].Rules)
                for k,v in pairs(RulesBroken) do
                    if PlayerOffenses[PlayerID][k] == 0 then
                        PlayerOffenses[PlayerID][k] = PlayerOffenses[PlayerID][k] + 1
                        PlayerBanCachedDuration[PlayerID] = PlayerBanCachedDuration[PlayerID] + DefaultBanDurations[k][PlayerOffenses[PlayerID][k]]
                        table.insert(PlayerChacheBanMessage, IndexBanName[k])

                    elseif PlayerOffenses[PlayerID][k] > 0 and PlayerOffenses[PlayerID][k] < 4 then
                        PlayerOffenses[PlayerID][k] = PlayerOffenses[PlayerID][k] + 1
                        PlayerBanCachedDuration[PlayerID] = PlayerBanCachedDuration[PlayerID] + DefaultBanDurations[k][PlayerOffenses[PlayerID][k]]
                        table.insert(PlayerChacheBanMessage, IndexBanName[k])
                    end
                    if DefaultBanDurations[k][PlayerOffenses[PlayerID][k]] == -1 or PlayerOffenses[PlayerID][k] > 3     then
                        PlayerBanCachedDuration[PlayerID] = -1
                        PermOffense = true
                    end
                end
                if PermOffense then 
                    PlayerBanCachedDuration[PlayerID] = -1
                end
                Wait(1500) -- This wait really needed?
                TriggerClientEvent("Vrxith:Adminsitration:RecieveBanPlayerData", AdminTemp, AdminName, PlayerBanCachedDuration[PlayerID], table.concat(PlayerChacheBanMessage, " + "))
            else
                exports["ghmattimysql"]:executeSync("INSERT INTO hvc_bans_offenses(UserID,Rules) VALUES(@UserID, @Rules)", {UserID = PlayerID, Rules = json.encode(PlayerBan)})
                HVCclient.notify(AdminTemp, {"~r~Regenerating player offenses, database row was not found."})
                HVCclient.notify(AdminTemp, {"~r~Regenerate players ban!"})
            end
        end)
    end
end)


RegisterServerEvent("Vrxith:Administration:BanPlayer")
AddEventHandler("Vrxith:Administration:BanPlayer", function(PlayerSource, Duration, BanMessage)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({AdminTemp})
    local AdminName = GetPlayerName(AdminTemp)
    local PlayerID = HVC.getUserId({PlayerSource})
    local PlayerName = GetPlayerName(PlayerSource)
    local CurrentTime = os.time()
    local PlayerDiscordID = 0
    local LogChannel = "webhookhere"
    local StaffBanLogs = "webhookhere"

    exports["ghmattimysql"]:execute("SELECT * FROM verification WHERE user_id = @user_id", {user_id = PlayerID}, function(result) 
        if #result > 0 then
            PlayerDiscordID = result[1].discord_id
        else
            PlayerDiscordID = "none"
        end
    end)


    -- webhookhere ---- Log to add external contrib
    HVC.prompt({source, "Ban Evidence","",function(player, Evidence)
        local Evidence = Evidence or ""
        if Evidence ~= nil and Evidence ~= "" then
            if HVC.hasPermission({AdminPermID, "admin.menu"}) then
                if tostring(Duration) == "-1" then
                    CurrentTime = CurrentTime + (60 * 60 * 500000)
                else
                    CurrentTime = CurrentTime + (60 * 60 * tonumber(Duration))
                end

                local communityname = "HVC Staff Logs"
                local communtiylogo = "" --Must end with .png or .jpg
                local command = {
                    {
                        ["color"] = "15536128",
                        ["title"] = PlayerName.. " Was Banned",
                        ["fields"] = {
                            {
                                ["name"] = "**Admin Name**",
                                ["value"] = "" ..AdminName,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Admin TempID**",
                                ["value"] = "" ..AdminTemp,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Admin PermID**",
                                ["value"] = "" ..AdminPermID,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player Name**",
                                ["value"] = "" .. GetPlayerName(PlayerSource),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player TempID**",
                                ["value"] = "" ..PlayerSource,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player PermID**",
                                ["value"] = ""..PlayerID,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player Discord**",
                                ["value"] = "<@"..PlayerDiscordID..">",
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Ban Duration**",
                                ["value"] = "" ..Duration,
                                ["inline"] = true
                            },
                        },
                        ["description"] = "**Ban Evidence**\n```\n"..Evidence.."\n"..BanMessage.."```",
                        ["footer"] = {
                        ["text"] = communityname,
                        ["icon_url"] = communtiylogo,
                        },
                    }
                }
                PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
                PerformHttpRequest(StaffBanLogs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
                HVCclient.notify(AdminTemp, {"Banned UserID "..PlayerID.."("..PlayerName..")"})
                HVC.BanUser({PlayerSource, BanMessage, CurrentTime, AdminName})
                TriggerEvent("HVC:saveBanLog", PlayerID, AdminName, BanMessage, Duration)
                exports['ghmattimysql']:execute("UPDATE hvc_bans_offenses SET Rules = @Rules WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID}, function() end)
            end
        else
            HVCclient.notify(AdminTemp, {"~r~Evidence field was left empty!"})
        end
    end})
end)

RegisterNetEvent("Vrxith:Administration:SpawnBMX")
AddEventHandler("Vrxith:Administration:SpawnBMX", function()
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({AdminTemp})
    local AdminName = GetPlayerName(AdminTemp)
    local AdminPed = GetPlayerPed(source)
    local Coords = GetEntityCoords(AdminPed)
    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        local BmxHash = GetHashKey("bmx")
        local Vehicle = CreateVehicle(BmxHash, Coords, GetEntityHeading(Ped), true, false)
        while not DoesEntityExist(Vehicle) do
            Wait(100)
        end
        SetPedIntoVehicle(AdminPed, Vehicle, -1)
        local logs = "webhookhere"
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg
        local command = {
            {
                ["color"] = "15536128",
                ["title"] = AdminName.. " Spawned A BMX",
                ["fields"] = {
                    {
                        ["name"] = "**Admin Name**",
                        ["value"] = "" ..AdminName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin TempID**",
                        ["value"] = "" ..AdminTemp,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin PermID**",
                        ["value"] = "" ..AdminPermID,
                        ["inline"] = true
                    },
                },
                ["description"] = "",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
    else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
    end
end)

RegisterServerEvent("Vrxith:Administration:SpawnVehicle")
AddEventHandler("Vrxith:Administration:SpawnVehicle",function()
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({AdminTemp})
    local AdminName = GetPlayerName(AdminTemp)
    local AdminPed = GetPlayerPed(source)
    local Coords = GetEntityCoords(AdminPed)
    if HVC.hasPermission({AdminPermID, "admin.menu"}) then
        HVC.prompt({source, "Spawn Code","",function(player, spawn)
            local spawn = spawn or ""
            if spawn ~= nil and spawn ~= "" then
                local Time = 0
                local VehicleHash = GetHashKey(spawn)
                local Vehicle = CreateVehicle(VehicleHash, Coords, GetEntityHeading(Ped), true, false)
                while not DoesEntityExist(Vehicle) and Time > 25 do
                    Time = Time + 1
                    Wait(100)
                end
                SetPedIntoVehicle(AdminPed, Vehicle, -1)
                local logs = "webhookhere"
                local communityname = "HVC Staff Logs"
                local communtiylogo = "" --Must end with .png or .jpg
            
                local command = {
                    {
                        ["color"] = "15536128",
                        ["title"] = AdminName.. " Spawned A Vehicle",
                        ["fields"] = {
                            {
                                ["name"] = "**Admin Name**",
                                ["value"] = "" ..AdminName,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Admin TempID**",
                                ["value"] = "" ..AdminTemp,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Admin PermID**",
                                ["value"] = "" ..AdminPermID,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Spawn Code**",
                                ["value"] = "" ..spawn,
                                ["inline"] = true
                            },
                        },
                        ["description"] = "",
                        ["footer"] = {
                        ["text"] = communityname,
                        ["icon_url"] = communtiylogo,
                        },
                    }
                }
                
                PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
            else 
                print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
            end
        end})
    end
end)

RegisterNetEvent("HVC:noClip")
AddEventHandler("HVC:noClip", function(bool)
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({AdminTemp})
    local AdminName = GetPlayerName(AdminTemp)
    if HVC.hasPermission({AdminPermID, "admin.noclip"}) then
        TriggerEvent("HVC:ACnoClip", AdminTemp, bool)
    else
        print("NoClip Cheater")
    end
end)


RegisterNetEvent('Vrxith:Administration:SpawnWeapon')
AddEventHandler('Vrxith:Administration:SpawnWeapon', function()
    local AdminTemp = source
    local AdminPermID = HVC.getUserId({AdminTemp})
    local AdminName = GetPlayerName(AdminTemp)
    if HVC.hasPermission({AdminPermID, "dev.announce"}) then
        HVC.prompt({source, "Spawn Code","MOSINHVC",function(player, spawn)
            local spawn = spawn or ""
            if spawn ~= nil and spawn ~= "" then
                TriggerClientEvent("Vrxith:Administration:SpawnWeaponC", AdminTemp, "WEAPON_"..spawn)
            end
        end})
    else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
    end
end)

RegisterCommand("addcar", function(source, args, rawCommand)
    local admin = source
    local car = args[2]
    local admin_id = HVC.getUserId({admin})
    local admin_name = GetPlayerName(admin)
    local player_id = tonumber(args[1])
    local id = HVC.getUserSource({player_id})
    local player_name = GetPlayerName(id)

    if HVC.hasPermission({admin_id, "add.car"}) then
        local logs = "webhookhere" -- Main Discord | HVC
        --local logs2 = "webhookhere" -- Donation Discord | HVC Tickets
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "1170250",
                ["title"] = "Donation Support (Add Car) (Command)",
                ["description"] = "Admin Name: **" ..admin_name.. "**\nAdmin Perm ID:  **" ..admin_id.. "**\nAdmin Temp ID:  **" ..admin.. "**\n\nPlayer Perm ID: **".. player_id.."**\nCar Add: **"..car.."**",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json'})
        --PerformHttpRequest(logs2, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json'})

        exports['ghmattimysql']:execute("INSERT INTO hvc_user_vehicles (user_id, vehicle) VALUES(@user_id, @vehicle)", {user_id = player_id, vehicle = car}, function() end)
        HVCclient.notify(source, {"~g~Added car "..car.." to " ..player_id.."'s garage"})
    else
        HVCclient.notify(source, {"~r~You do not have permission to add cars!"})
    end
end)




RegisterCommand("a", function(source,args, rawCommand)
    user_id2 = HVC.getUserId({source})   
    if HVC.hasPermission({user_id2, "admin.menu"}) then
    else 
        return 
    end
    local msg = rawCommand:sub(2)
    local playerName =  "^7[Staff Chat] " .. GetPlayerName(source)..": "
    local players = GetPlayers()
    local logs = "webhookhere"
    local communityname = "HVC Staff Logs"
    local communtiylogo = "" --Must end with .png or .jpg

    local command = {
        {
            ["color"] = "15536128",
            ["title"] = "Admin Menu (Admin Chat)",
            ["description"] = "** Admin Name: **" ..GetPlayerName(source).. "** Admin ID:  **" ..user_id2.. "** Said: **" ..msg.. "",
            ["footer"] = {
            ["text"] = communityname,
            ["icon_url"] = communtiylogo,
            },
        }
    }
    
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
    for i,v in pairs(players) do 
        name = GetPlayerName(v)
        user_id = HVC.getUserId({v})   
        if HVC.hasPermission({user_id, "admin.menu"}) then
            TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, msg, "staff")
        end
    end
end)

RegisterCommand("pd", function(source,args, rawCommand)
    local user_id2 = HVC.getUserId({source})
    if HVC.hasPermission({user_id2, "police.menu"}) then
    else 
        return 
    end
    local msg = rawCommand:sub(2)
    local playerName =  "^7[Police Chat] " .. GetPlayerName(source)..": "
    local players = GetPlayers()
    local logs = "webhookhere"
    local communityname = "HVC Staff Logs"
    local communtiylogo = "" --Must end with .png or .jpg

    local command = {
        {
            ["color"] = "15536128",
            ["title"] = "Police (/pd chat)",
            ["description"] = "** Police Name: **" ..GetPlayerName(source).. "** Police ID:  **" ..user_id2.. "** Said: **" ..msg.. "",
            ["footer"] = {
            ["text"] = communityname,
            ["icon_url"] = communtiylogo,
            },
        }
    }
    
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
    for i,v in pairs(players) do 
        name = GetPlayerName(v)
        user_id = HVC.getUserId({v})   
        if HVC.hasPermission({user_id, "police.menu"}) then
            TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, msg, "pd")
        end
    end
end)




-- TO BE CHANGED

RegisterNetEvent('HVC:SpecateLog')
AddEventHandler('HVC:SpecateLog', function(id)
    local admin = source
    local admin_id = HVC.getUserId({admin})
    local admin_name = GetPlayerName(admin)
    local player_id = HVC.getUserId({id})
    local player_name = GetPlayerName(id)
    if HVC.hasPermission({admin_id, "admin.menu"}) then
        local logs = "webhookhere"
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "15536128",
                ["title"] = "Admin Menu (Spectate)",
                ["description"] = "** Admin Name: **" ..admin_name.. "** Admin ID:  **" ..admin_id.. "** Started Spectated: **" ..player_name.. "** Player Perm ID: **" ..player_id.. "",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
    else
        TriggerEvent("HVC:BANTYPE6",source,"No perms to revive")
    end
end)

RegisterServerEvent("HVC:Spectate")
AddEventHandler("HVC:Spectate", function(TargetSource)
    local source = source;
    local user_id = HVC.getUserId({source})
    local user_id2 = HVC.getUserId({TargetSource})
    if user_id2 == nil then 
        return HVCclient.notify(source, {"[Spectate] Player not found"})
    end
    if HVC.hasPermission({user_id, "admin.menu"}) then
        local tgtCoords = GetEntityCoords(GetPlayerPed(TargetSource))
        TriggerClientEvent("HVC:requestSpectate", source, TargetSource, tgtCoords)
        HVCclient.notify(source, {"~r~Spectating player!"})
        TriggerClientEvent("HVC:AC:BanCheat:EulenCheck", source, true)
    else
        print("Cheating spectate")
    end
end)




RegisterServerEvent("HVC:addGroup")
AddEventHandler("HVC:addGroup",function(perm, selgroup)
    local admin_temp = source
    local admin_name = GetPlayerName(admin_temp)
    local admin_perm = HVC.getUserId({admin_temp})
    local user_id = HVC.getUserId({source})
    local curdate = os.time()
    curdate = curdate + (60 * 60 * 500000)

    if HVC.hasPermission({user_id, "admin.menu"}) then

        if selgroup == "ldev" and not HVC.hasPermission({admin_perm, "group.add.ldev"}) then
            HVCclient.notify(admin_temp, {"~r~You don't have permission to do that"})
            return 
        end
        if selgroup == "founder" and not HVC.hasPermission({admin_perm, "group.add.founder"}) then
            HVCclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        else
            HVC.addUserGroup({perm, selgroup})   
            local logs = "webhookhere"
            local communityname = "HVC Staff Logs"
            local communtiylogo = "" --Must end with .png or .jpg
        
            local command = {
                {
                    ["color"] = "15536128",
                    ["title"] = "Admin Menu (Add Group)",
                    ["description"] = "**Admin Name: **" ..admin_name.. "\n**Admin ID:  **" ..admin_perm.. "\n**Player Perm ID: **" ..perm.. "\n**Group Given**" ..selgroup,
                    ["footer"] = {
                    ["text"] = communityname,
                    ["icon_url"] = communtiylogo,
                    },
                }
            }
            
            PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })    
        end
    end
end)


RegisterServerEvent("HVC:removeGroup")
AddEventHandler("HVC:removeGroup",function(perm, selgroup)
    local user_id = HVC.getUserId({source})
    local admin_name = GetPlayerName(source)
    local curdate = os.time()
    curdate = curdate + (60 * 60 * 500000)
    if HVC.hasPermission({user_id, "admin.menu"}) then
        HVC.removeUserGroup({perm, selgroup})

        local logs = "webhookhere"
        local communityname = "HVC Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg
    
        local command = {
            {
                ["color"] = "15536128",
                ["title"] = "Admin Menu (Remove Group)",
                ["description"] = "**Admin Name: **" ..admin_name.. "\n**Admin ID:  **" ..user_id.. "\n**Player Perm ID: **" ..perm.. "\n**Group Given**" ..selgroup,
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "HVC Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })    
    else 
        HVC.BanUser({source, "Type #12", curdate, "HVC"})
    end
end)
