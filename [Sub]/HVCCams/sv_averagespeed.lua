local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVCSpeeeding")

local mph = true
local units = "mph"
if main.useKmh ~= nil then
    mph = not main.useKmh
    if not mph then units = "km/h" end
end

RegisterServerEvent("Server:AverageSpeedDetection")
AddEventHandler("Server:AverageSpeedDetection",function(cameraId, speed, roadName, numberplate)
    local source = source
    local user_id = HVC.getUserId({source})
    if main.enableDiscordLogs then
        logToDiscord(source, cameraId, speed, roadName, numberplate)
    end

    local oldmoney = HVC.getBankMoney({user_id})
    print(user_id)
    local newmoney = oldmoney - 5000
    HVC.setBankMoney({user_id, newmoney})
    HVCclient.notify(source, {"~r~You Were Fined £10,000 For Speeding"})
end)

function mathRound(value, numDecimalPlaces)
    if numDecimalPlaces then
        local power = 10^numDecimalPlaces
        return math.floor((value * power) + 0.5) / (power)
    else
        return math.floor(value + 0.5)
    end
end

function logToDiscord(source, cameraId, speed, roadName, numberplate)
    local webhookId = main.webhook
    local name = GetPlayerName(source)
    local date = os.date('*t')
    local time = os.date("*t")  
    local embed = {
        {
            ["fields"] = {
                {
                    ["name"] = "**"..translations.name.."**",
                    ["value"] = name,
                    ["inline"] = true
                },
                {
                    ["name"] = "**"..translations.cameraId.."**",
                    ["value"] = cameraId * 12,
                    ["inline"] = true
                },
                {
                    ["name"] = "**"..translations.speedLimit.."**",
                    ["value"] = config[cameraId].limit.." "..units,
                    ["inline"] = true
                },
                {
                    ["name"] = "**"..translations.speedDetected.."**",
                    ["value"] = mathRound(speed, 1).." "..units,
                    ["inline"] = true
                },
                {
                    ["name"] = "**"..translations.roadName.."**",
                    ["value"] = roadName,
                    ["inline"] = true
                },
                {
                    ["name"] = "**"..translations.numberPlate.."**",
                    ["value"] = numberplate,
                    ["inline"] = true
                },
            },
            ["color"] = 16767002,
            ["title"] = "**"..translations.cameraActivation.."**",
            ["description"] = "",
            ["footer"] = {
                ["text"] = translations.timestamp..os.date("%A, %m %B %Y | "), ("%02d:%02d:%02d"):format(time.hour, time.min, time.sec),
            },
            ["thumbnail"] = {
                ["url"] = main.webhookImage,
            },
        }
    }
    PerformHttpRequest(webhookId, function(err, text, headers) end, 'POST', json.encode({username = main.webhookName, embeds = embed}), { ['Content-Type'] = 'application/json' })
end