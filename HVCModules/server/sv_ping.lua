RegisterServerEvent("checkMyPingBro")
AddEventHandler("checkMyPingBro", function()
    local ping = GetPlayerPing(source)
    if ping >= 250 then
        DropPlayer(source, "Ping is too high (Limit: " .. pingLimit .. " Your Ping: " .. ping .. ")")
    end
end)