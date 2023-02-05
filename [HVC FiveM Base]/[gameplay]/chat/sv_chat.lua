RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

-- AddEventHandler('_chat:messageEntered', function(author, color, message)
--     if not message or not author then
--         return
--     end
--     TriggerEvent('TwitterLogs', source, author, message)
--     -- TriggerClientEvent('chatMessage', -1, author,  { 255, 255, 255 }, message, "twt")

--     if not WasEventCanceled() then
--         TriggerClientEvent('chatMessage', -1, "@"..author..":",  { 255, 255, 255 }, message)
--     end

--     --print(author .. '^7: ' .. message .. '^7')
-- end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command) 
    end

    CancelEvent()
end)


RegisterServerEvent("ManShutYoBitchAssUp")
AddEventHandler("ManShutYoBitchAssUp", function(command)

    local anonembeds = {
        {
            ["color"] = "15536128",
            ["title"] = ""..GetPlayerName(source).." | Command Chat Logs",
            ["description"] = "**Name: **"..GetPlayerName(source).."\n**Command: **"..command,
            ["footer"] = {
            ["text"] = "HVC Anonymous Logs",
            }
        }
    }

    PerformHttpRequest("https://discord.com/api/webhooks/941122484500054099/YhVNoXocv_g7C9ZRNzPl7bBV9bkfcCZn0SMJYCz7WY1jY4tDed1weYa5MQKS7_uxZ89O", function(err, text, headers) end, "POST", json.encode({username = "HVC RP", embeds = anonembeds}), { ["Content-Type"] = "application/json" })
end)
local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('chat:init', function()
    refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)
