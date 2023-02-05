


RegisterCommand("getmyid", function(source)
    TriggerClientEvent("chatMessage", source, "[HVC]", {240, 47, 47}, "Your PermID: " ..HVC.getUserId(source), "ooc")
end)

RegisterCommand("getmytempid", function(source)
    TriggerClientEvent("chatMessage", source, "[HVC]", {240, 47, 47}, "Your TempID: " ..source, "ooc")
end)

RegisterCommand("getid", function(source, args, rawcommand)
    if args[1] then
        TriggerClientEvent("chatMessage", source, "[HVC]", {240, 47, 47}, "PermID: " ..HVC.getUserId(args[1]), "ooc")
    end
end)