RegisterServerEvent("HVC:CheckPermission")
AddEventHandler("HVC:CheckPermission", function()
    local src = source;
    local userRoles = {}
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end


    if identifierDiscord then
        local roleIDs = exports.discord:GetDiscordRoles(src)
        if not (roleIDs == false) then
            for i = 1, #roleIDs do
                for role, vehicles in pairs(cfgvehiclewhitelist.VehicleRestrictions) do
                    if exports.discord:CheckEqual(role, roleIDs[i]) then
                        userRoles[role] = true;
                        if cfgvehiclewhitelist.InheritanceEnabled then 
                            local inheritedRoles = cfgvehiclewhitelist.Inheritances[role];
                            if inheritedRoles ~= nil then 
                                for j = 1, #inheritedRoles do 
                                    userRoles[ inheritedRoles[j] ] = true;
                                end
                            end
                        end
                    end
                end
            end
        else
        end
    elseif identifierDiscord == nil then
    end
    TriggerClientEvent("HVC:CheckPermission:Return", src, userRoles);
end)