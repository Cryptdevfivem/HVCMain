local Proxy = module("hvc", "lib/Proxy")
local Tunnel = module("hvc","lib/Tunnel")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC","HVC")

RegisterServerEvent("HVC:playerLeave2")
AddEventHandler("HVC:playerLeave2", function(user_id, source, reason)
	local source = source
	local name = GetPlayerName(source)
	local user_id = HVC.getUserId({source})
	local ped = GetPlayerPed(source)

	local steamhex = GetPlayerIdentifier(source)
	local steam64 = GetPlayerGuid(source)
	local steamid  = "No identifier"
	local license  = "No identifier."
	local discord  = "No identifier."
	local xbl      = "No identifier."
	local liveid   = "No identifier." 
	for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
          steamid = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
          license = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
          xbl  = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
          discord = v
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
          liveid = v
        end
	end

	local logs = "https://discord.com/api/webhooks/898892426335375380/_sE7ue3W_HRmHyTkhz5xtvJKorXDiXtSNe35Ke30efXlDlF2sUTtMlaZ-Mj217QH8x5Q"
	local curdate = os.time()
	local banEmbed = {
		{
			["color"] = "15158332",
			["title"] = ""..name.." Left The Server",
			["description"] = "Name: **"..name.."**\nPerm ID: **"..user_id.."\nTemp ID: **"..source.."**\nReason: "..reason.."\nTime: "..os.date("%x %X %p").."\n```\nDiscord: "..discord.."\nSteam License: "..steamid.."\nGame License: "..license.."```",
			["footer"] = {
			["text"] = "HVC Leave Logs - "..os.date("%x %X %p"),
			}
		}
	}
	PerformHttpRequest(logs, function(err, text, headers) end, "POST", json.encode({username = "HVC Leave Logs", embeds = banEmbed}), { ["Content-Type"] = "application/json" })
end)

AddEventHandler('HVC:playerSpawn', function(user_id, source)
	local tempid = source
	local uname = GetPlayerName(source)
	local user_id = HVC.getUserId({source})
	local logs2 = "https://discord.com/api/webhooks/898892343204261908/jGuCxLBO6IxOLFp8wBSi7resgMcLw2FCKW0GfBAQv91pX5dakUJ7DHUA5bZg17_8gF6O"
	local steamhex = GetPlayerIdentifier(source)
	local steam64 = GetPlayerGuid(source)
	local steamid  = "No identifier"
	local license  = "No identifier."
	local discord  = "No identifier."
	local xbl      = "No identifier."
	local liveid   = "No identifier." 
	for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
          steamid = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
          license = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
          xbl  = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
          discord = v
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
          liveid = v
        end
	end

	local JoinEmbed = {
		{
			["color"] = "000250240",
			["title"] = ""..uname.." Connected To The Server",
			["description"] = "Name: **"..uname.."**\nPerm ID: **"..user_id.."**\nTemp ID: "..tempid.."\nTime: "..os.date("%x %X %p").."\n```\nDiscord: "..discord.."\nSteam License: "..steamid.."\nGame License: "..license.."```\n"..uname.." Connected To The Server |",
			["footer"] = {
			  ["text"] = "HVC Leave Logs | HVC Modules - "..os.date("%x %X %p"),
			}
		}
	}

	PerformHttpRequest(logs2, function(err, text, headers) end, "POST", json.encode({username = "HVC Leave Logs", embeds = JoinEmbed}), { ["Content-Type"] = "application/json" })
end)
