RegisterServerEvent('Roda_AntiNoProps:Kick')
AddEventHandler('Roda_AntiNoProps:Kick', function (type, item)
    local src = source 
    local log = messageIdentifiers(src, item)
    if type == 'prop' then 
        ScreenForUser(src, 'No Props', ConfigSv.Webhook, ConfigSv.PictureWebhook, ConfigSv.NameWebhook, item, '[HVC] Please turn off your external modifications to be able to play! ')
    elseif type == 'water' then 
        ScreenForUser(src, 'No Water', ConfigSv.Webhook, ConfigSv.PictureWebhook, ConfigSv.NameWebhook, item, '[HVC] Please turn off your external modifications to be able to play! ')
    end
end)

function SendRodaLog(title, color, message, webHook)
    local embedData = {
        {
            ["title"] = title,
            ["color"] = ConfigSv.Colors[color] ~= nil and ConfigSv.Colors[color] or ConfigSv.Colors["default"],
            ["footer"] = {
                ["text"] = os.date("%c"),
            },
            ["description"] = message,
        }
    }
    PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = ConfigSv.NameWebhook,embeds = embedData}), { ['Content-Type'] = 'application/json' })
end