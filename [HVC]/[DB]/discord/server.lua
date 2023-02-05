local FormattedToken = "Bot " .. cfgdiscordperm.Bot_Token

local error_codes_defined = {
	[200] = 'OK - The request was completed successfully..!',
	[400] = "Error - The request was improperly formatted, or the server couldn't understand it..!",
	[401] = 'Error - The Authorization header was missing or invalid..! Your Discord Token is probably wrong or does not have correct permissions attributed to it.',
	[403] = 'Error - The Authorization token you passed did not have permission to the resource..! Your Discord Token is probably wrong or does not have correct permissions attributed to it.',
	[404] = "Error - The resource at the location specified doesn't exist.",
	[429] = 'Error - Too many requests, you hit the Discord rate limit. https://discord.com/developers/docs/topics/rate-limits',
	[502] = 'Error - Discord API may be down?...'
};

Citizen.CreateThread(function()
	if (GetCurrentResourceName() ~= "Badger_Discord_API") then 
		--StopResource(GetCurrentResourceName());
		
	end
	
end)

tracked = {}

RegisterNetEvent('Badger_Discord_API:PlayerLoaded')
AddEventHandler('Badger_Discord_API:PlayerLoaded', function()
	local license = ExtractIdentifiers(source).license;
	if (tracked[license] == nil) then 
		tracked[license] = true;	
	end
end)

if cfgdiscordperm.Splash.Enabled then 
	AddEventHandler('playerConnecting', function(name, setKickReason, deferrals) 
		-- Player is connecting
		deferrals.defer();
		local src = source;
		local toEnd = false;
		local count = 0;
		while not toEnd do 
			deferrals.presentCard(card,
			function(data, rawData)
			end)
			Wait((1000))
			count = count + 1;
			if count == cfgdiscordperm.Splash.Wait then 
				toEnd = true;
			end
		end
		deferrals.done();
	end)
end 

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end
function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end

function GetRoleIdFromRoleName(name)
	if (Caches.RoleList ~= nil) then 
		return tonumber(Caches.RoleList[name]);
	else 
		local roles = GetGuildRoleList();
		return tonumber(roles[name]);
	end
end

function CheckEqual(role1, role2)
	local checkStr1 = false;
	local checkStr2 = false;
	local roleID1 = role1;
	local roleID2 = role2;
	local searchGuild1 = true;
	local searchGuild2 = true;
	if type(role1) == "string" then checkStr1 = true end;
	if type(role2) == "string" then checkStr2 = true end; 
	if checkStr1 then 
		local roles2 = cfgdiscordperm.RoleList;
		for roleRef, roleID in pairs(roles2) do 
			if roleRef == role1 then 
				roleID1 = roleID;
				searchGuild1 = false;
			end
		end
		if searchGuild1 then 
			local roles = GetGuildRoleList();
			for roleName, roleID in pairs(roles) do 
				if roleName == role1 then 
					roleID1 = roleID;
				end
			end
		end
	end
	if checkStr2 then
		local roles2 = cfgdiscordperm.RoleList;
		for roleRef, roleID in pairs(roles2) do 
			if roleRef == role2 then 
				roleID2 = roleID;
				searchGuild2 = false;
			end
		end 
		if searchGuild2 then 
			local roles = GetGuildRoleList();
			for roleName, roleID in pairs(roles) do 
				if roleName == role2 then 
					roleID2 = roleID;
				end
			end
		end
	end
	if tonumber(roleID1) == tonumber(roleID2) then 
		return true;
	end
	return false;
end

function IsDiscordEmailVerified(user) 
    local discordId = nil
    local isVerified = false;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    if discordId then 
        local endpoint = ("users/%s"):format(discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            local data = json.decode(member.data)
            if data ~= nil then 
                -- It is valid data 
                --print("The data for User " .. GetPlayerName(user) .. " is: ");
                --print(data.avatar);
                isVerified = data.verified;
                --print("---")
            end
        else 
        	
        end
    end
    return isVerified;
end

function GetDiscordEmail(user) 
    local discordId = nil
    local emailData = nil;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    if discordId then 
        local endpoint = ("users/%s"):format(discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            local data = json.decode(member.data)
            if data ~= nil then 
                -- It is valid data 
                --print("The data for User " .. GetPlayerName(user) .. " is: ");
                --print(data.avatar);
                emailData = data.email;
                --print("---")
            end
        else 
        	
        end
    end
    return emailData;
end

function GetDiscordName(user) 
    local discordId = nil
    local nameData = nil;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    if discordId then 
        local endpoint = ("users/%s"):format(discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            local data = json.decode(member.data)
            if data ~= nil then 
                -- It is valid data 
                --print("The data for User " .. GetPlayerName(user) .. " is: ");
                --print(data.avatar);
                nameData = data.username .. "#" .. data.discriminator;
                --print("---")
            end
        else 
        	
        end
    end
    return nameData;
end

function GetGuildIcon()
	local guild = DiscordRequest("GET", "guilds/"..cfgdiscordperm.Guild_ID, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		if (data.icon:sub(1, 1) and data.icon:sub(2, 2) == "_") then 
			-- It's a gif 
			return 'https://cdn.discordapp.com/icons/' .. cfgdiscordperm.Guild_ID .. "/" .. data.icon .. ".gif";
		else 
			-- Image 
			return 'https://cdn.discordapp.com/icons/' .. cfgdiscordperm.Guild_ID .. "/" .. data.icon .. ".png";
		end 
	else
		 
	end
	return nil;
end

function GetGuildSplash()
	local guild = DiscordRequest("GET", "guilds/"..cfgdiscordperm.Guild_ID, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return 'https://cdn.discordapp.com/splashes/' .. cfgdiscordperm.Guild_ID .. "/" .. data.icon .. ".png";
	else
		
	end
	return nil;
end 

function GetGuildName()
	local guild = DiscordRequest("GET", "guilds/"..cfgdiscordperm.Guild_ID, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return data.name;
	else
		 
	end
	return nil;
end

function GetGuildDescription()
	local guild = DiscordRequest("GET", "guilds/"..cfgdiscordperm.Guild_ID, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return data.description;
	else
		
	end
	return nil;
end

function GetGuildMemberCount()
	local guild = DiscordRequest("GET", "guilds/"..cfgdiscordperm.Guild_ID.."?with_counts=true", {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return data.approximate_member_count;
	else
		 
	end
	return nil;
end

function GetGuildOnlineMemberCount()
	local guild = DiscordRequest("GET", "guilds/"..cfgdiscordperm.Guild_ID.."?with_counts=true", {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		return data.approximate_presence_count;
	else
		
	end
	return nil;
end

function GetDiscordAvatar(user) 
    local discordId = nil
    local imgURL = nil;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
	end
	if discordId then 
		if Caches.Avatars[discordId] == nil then 
			local endpoint = ("users/%s"):format(discordId)
			local member = DiscordRequest("GET", endpoint, {})
			if member.code == 200 then
				local data = json.decode(member.data)
				if data ~= nil and data.avatar ~= nil then 
					-- It is valid data 
					--print("The data for User " .. GetPlayerName(user) .. " is: ");
					--print(data.avatar);
					if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then 
						--print("IMG URL: " .. "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".gif")
						imgURL = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".gif";
					else 
						--print("IMG URL: " .. "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".png")
						imgURL = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".png"
					end
					--print("---")
				end
			else 
				
			end
			Caches.Avatars[discordId] = imgURL;
		else 
			imgURL = Caches.Avatars[discordId];
		end 
	else 
		
	end
    return imgURL;
end

Caches = {
	Avatars = {}
}
function ResetCaches()
	Caches = {};
end

function GetGuildRoleList()
	if (Caches.RoleList == nil) then 
		local guild = DiscordRequest("GET", "guilds/"..cfgdiscordperm.Guild_ID, {})
		if guild.code == 200 then
			local data = json.decode(guild.data)
			-- Image 
			local roles = data.roles;
			local roleList = {};
			for i = 1, #roles do 
				roleList[roles[i].name] = roles[i].id;
			end
			Caches.RoleList = roleList;
		else
			
			Caches.RoleList = nil;
		end
	end
	return Caches.RoleList;
end

local recent_role_cache = {}

function GetDiscordRoles(user)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break;
		end
	end

	if discordId then
		if cfgdiscordperm.CacheDiscordRoles and recent_role_cache[discordId] then
			return recent_role_cache[discordId]
		end
		local endpoint = ("guilds/%s/members/%s"):format(cfgdiscordperm.Guild_ID, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			local found = true
			if cfgdiscordperm.CacheDiscordRoles then
				recent_role_cache[discordId] = roles
				Citizen.SetTimeout(((cfgdiscordperm.CacheDiscordRolesTime or 60)*1000), function() recent_role_cache[discordId] = nil end)
			end
			return roles
		else
			
			return false
		end
	else
		
		return false
	end
	return false
end

function GetDiscordNickname(user)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break
		end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(cfgdiscordperm.Guild_ID, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local nickname = data.nick
			return nickname;
		else
			
			return nil;
		end
	else
		
		return nil;
	end
	return nil;
end

Citizen.CreateThread(function()
	local guild = DiscordRequest("GET", "guilds/"..cfgdiscordperm.Guild_ID, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		
	else
		
	end
end)
