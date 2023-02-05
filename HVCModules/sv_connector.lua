Tunnel = module("hvc", "lib/Tunnel")
Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVC")

HVCModule = {}
Tunnel.bindInterface("HVC_Modules", HVCModule)
Proxy.addInterface("HVC_Modules", HVCModule)
HVCModuleC = Tunnel.getInterface("HVC_Modules","HVC_Modules")




function HVCModule.NHSPack(rad)
	local source = source
	HVCclient.getNearestPlayer(source,{rad},function(nplayer)
	

		if nplayer == nil then
			HVCclient.notify(source, {"~r~No players nearby!"})
			return
		end

		local PermID = HVC.getUserId({nplayer})
		local Name = GetPlayerName(nplayer)

		HeartRate = math.round(((GetEntityHealth(GetPlayerPed(nplayer)) / 4) + math.random(15,49)))
		BloodPressure = math.round(HeartRate*math.random(2, 3)/1.65).. " / " .. math.round(HeartRate*math.random(3, 4)/1.25)
		Temperature = math.random(34, 38)
		SpO2 = math.random(80, 100)

		if GetEntityHealth(GetPlayerPed(nplayer)) < 102 then
			HeartRate = 0
			BloodPressure = 0
			Temperature = math.random(2, 6)
			SpO2 = 0
		end
		if nplayer ~= nil then
			TriggerClientEvent("HVC:Recieve:NearestPlayer", source, PermID, Name, nplayer, HeartRate, BloodPressure, Temperature, SpO2, GetEntityCoords(GetPlayerPed(nplayer)), GetEntityHealth(GetPlayerPed(nplayer)))
		end
	end)
end

function HVCModule.NHSRevive(tempid)
	local source = source
    local UserID = HVC.getUserId({source})

	if HVC.hasPermission({UserID, "emscheck.revive"}) then
		Wait(300)
		HVCclient.ScreenFade(tempid)
		Wait(760)
		TriggerEvent("HVC:ProvideHealth",tempid, 200)
		TriggerClientEvent("HVC:FIXCLIENT", tempid)
		HVCclient.notify(source, {"~g~You have received a payment of £5,000 for your medical services."})
		HVC.giveBankMoney({UserID, 5000})
	else
		--print(GetPlayerName(source).. " Maybe cheating, they tried reviving someone")
	end
end

function math.round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function HVCModule.GetUserID()
    local source = source
    local UserID = HVC.getUserId({source})

    if UserID ~= nil then
        --print(UserID)
        return UserID
    -- elseif UserID == nil then
    --     DropPlayer(source, "[HVC] You were kicked from the server\nYour ID is: "..UserID.."\nReason: Nil PermID\nKicked by HVC")
    end
end

function HVCModule.PurchaseNHS(amount, price, itemid, ammoname)
	local source = source
    local userid = HVC.getUserId({source})

    if HVC.hasPermission({userid, "emscheck.revive"}) then
        if HVC.tryPayment({userid, price}) then
            HVC.giveInventoryItem({userid, itemid, amount, true})
        else 
            HVCclient.notify(source, {"~r~Insufficient funds"})
        end
    else

    end
end

-- Permission Checks


function HVCModule.GlobalHasNHS()
    local source = source
    local UserID = HVC.getUserId({source})

    if UserID ~= nil then
        if HVC.hasPermission({UserID, "emscheck.revive"}) then
            return true
        else
            return false
        end
    end
end


function HVCModule.GlobalHasPD()
    local source = source
    local UserID = HVC.getUserId({source})

    if UserID ~= nil then
        if HVC.hasPermission({UserID, "police.menu"}) then
            return true
        else
            return false
        end
    end
end


function HVCModule.GlobalHasRebel()
    local source = source
    local UserID = HVC.getUserId({source})

    if UserID ~= nil then
        if HVC.hasGroup({UserID, "rebel"}) then
            return true
        else
            return false
        end
    end
end


function HVCModule.GlobalHasAdmin()
    local source = source
    local UserID = HVC.getUserId({source})

    if UserID ~= nil then
        if HVC.hasPermission({UserID, "admin.menu"}) then
            return true
        else
            return false
        end
    end
end

function HVCModule.GetAdminLevel()
    local source = source
    local UserID = HVC.getUserId({source})

    if UserID ~= nil then
        if HVC.hasGroup({UserID, "founder"}) then
            return 12
        elseif HVC.hasGroup({UserID, "ldev"}) then
            return 11
		elseif HVC.hasGroup({UserID, "operationsmanager"}) then
			return 10
        elseif HVC.hasGroup({UserID, "staffmanager"}) then
            return 10
        elseif HVC.hasGroup({UserID, "commanager"}) then
            return 9
        elseif HVC.hasGroup({UserID, "headadmin"}) then
            return 7
        elseif HVC.hasGroup({UserID, "senioradmin"}) then
            return 6
        elseif HVC.hasGroup({UserID, "administrator"}) then
            return 5
        elseif HVC.hasGroup({UserID, "smoderator"}) then
            return 4
        elseif HVC.hasGroup({UserID, "moderator"}) then
            return 4
        elseif HVC.hasGroup({UserID, "dev"}) then
            return 3
        elseif HVC.hasGroup({UserID, "support"}) then
            return 2
        elseif HVC.hasGroup({UserID, "trialstaff"}) then
            return 1
        end
    end
end


-- Chat Stuff


function HVCModule.OOC(text)
	local source = source
	local name = GetPlayerName(source)
    local message = table.concat(text, " ")
    local user_id = HVC.getUserId({source})
    Log2Discord("ooc", message, source)
    if HVC.hasGroup({user_id, "founder"}) then
		TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^8 Founder ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
	elseif HVC.hasGroup({user_id, "ldev"}) then
		TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^8 Lead Developer ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
	elseif HVC.hasGroup({user_id, "operationsmanager"}) then
		TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^5 Operations Manager ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
	else
		if HVC.hasGroup({user_id, "dev"}) then
			TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^1 Developer ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
		else
			if HVC.hasGroup({user_id, "commanager"}) then
				TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^1 Community Manager ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			else
				if HVC.hasGroup({user_id, "staffmanager"}) then
					TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^6 Staff Manager ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				else
					if HVC.hasGroup({user_id, "headadmin"}) then
						TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^0 Head Administrator ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
					else
						if HVC.hasGroup({user_id, "senioradmin"}) then
							TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^9 Senior Administrator ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
						else
							if HVC.hasGroup({user_id, "administrator"}) then
								TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^3 Administrator ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
							elseif HVC.hasGroup({user_id, "smoderator"}) then
								TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^2 Senior Moderator ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
							else
								if HVC.hasGroup({user_id, "moderator"}) then
									TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^2 Moderator ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
								else
									if HVC.hasGroup({user_id, "support"}) then
										TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^2 Support Team ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
									else
										if HVC.hasGroup({user_id, "trialstaff"}) then
											TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^5 Trial Staff ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
										else
											if HVC.hasGroup({user_id, "champion"}) then
												TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^0 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc") 
											else
												if HVC.hasGroup({user_id, "legend"}) then
													TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^5 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc") 
												else
													if HVC.hasGroup({user_id, "chief"}) then
														TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^2 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
													else
														if HVC.hasGroup({user_id, "elite"}) then
															TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^3 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
														else
															if HVC.hasGroup({user_id, "prime"}) then
																TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^9 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
															else
																TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r | " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end




function HVCModule.twt(type, text)
	local source = source
	local author = GetPlayerName(source)
    local user_id = HVC.getUserId({source})

    if user_id ~= nil then
		if type == "twt" then
			TriggerClientEvent('chatMessage', -1, "@"..author..":",  { 255, 255, 255 }, text, "twt")
			Log2Discord("twt", text, source)
		else
			if type == "anon" then
				local message = table.concat(text, " ")
				Log2Discord("anon", message, source)
				TriggerClientEvent('chatMessage', -1, "^4Twitter @^1Anonymous^7^r ",  { 255, 255, 255 }, message, "ooc")
			end
		end
    end
end








function HVCModule.Announce(text)
	local source = source
	local author = GetPlayerName(source)
    local user_id = HVC.getUserId({source})
	local message = table.concat(text, " ")

    if user_id ~= nil then
		if HVC.hasPermission({user_id,"dev.announce"}) then
			TriggerClientEvent('chatMessage', -1, "^1^*[HVC] ^7^r" , { 128, 128, 128 }, message, "alert")
		end
	end
end

function Log2Discord(type, message, source)
	local source = source
	local author = GetPlayerName(source)
    local user_id = HVC.getUserId({source})
	local LogChannel = ""
	local ChatName = "N/A"
	local Color = "15536128"
	if type == "twt" then
		LogChannel = "https://discord.com/api/webhooks/893185314171011082/qfyzalA_aMKodc6LgbjZX8tMW756SNIjk5vQzdxjEBKUlHgkfnIqmjZzLrCJymLK0IpC"
		Color = "4362485"
		ChatName = "Twitter"
	elseif type == "anon" then
		LogChannel = "https://canary.discord.com/api/webhooks/893183432367149076/ku0W77wcShqsZPwgHWUwf_VqymKR6yDOE5EyKvxW5b77xDfAU49DJWgf3spD6ow0QavF"
		Color = "15537678"
		ChatName = "Anonymous"
	elseif type == "ooc" then
		LogChannel = "https://canary.discord.com/api/webhooks/893183269628149761/rdCqJS-V2x7qr5NaW4NPBAXgCm4u_ufsaQSBtfAdqsueiq7GjXzomjYfa4sWZ8TPwtdD"
		Color = "7304561"
		ChatName = "OOC"
	elseif type == "announce" then
		LogChannel = "https://canary.discord.com/api/webhooks/893183460997492797/xppv_ck1DnHIFzrWDi-gCeHSJdohtMa4hcY69Q_lteU68jFxn5Y4MfSHjYX62IWF9Q03"
		Color = "15537678"
		ChatName = "Announce"
	end
	local ChatEmbed = {
        {
            ["color"] = Color,
            ["title"] = ""..author.." | "..ChatName.." Logs",
            ["fields"] = {
                {
                    ["name"] = "**Author**",
                    ["value"] = "" ..author,
                    ["inline"] = true
                },
                {
                    ["name"] = "**User TempID**",
                    ["value"] = "" ..source,
                    ["inline"] = true
                },
                {
                    ["name"] = "**User PermID**",
                    ["value"] = "" ..HVC.getUserId({source}),
                    ["inline"] = true
                },
            },
			["description"] = "```\n"..message.."```",
            ["footer"] = {
            	["text"] = "HVC " ..ChatName.. " Logs",
            }
        }
    }
	PerformHttpRequest(LogChannel, function(err, text, headers) end, "POST", json.encode({username = "HVC Staff Logs", embeds = ChatEmbed}), { ["Content-Type"] = "application/json" })
end





RegisterServerEvent("HVC:ClockingOff")
AddEventHandler("HVC:ClockingOff", function()
	print("Clocking off triggered")
	TriggerClientEvent("HVC:ClockingOffC", source)
end)














function HVCModule.TakeAdminTicket(targetSource, index)
	local src = source
	local PlrID = HVC.getUserId({src})
	
	if HVC.hasPermission({PlrID, "admin.menu"}) then
		local TargetSrc = targetSource
		local TargetID = HVC.getUserId({TargetSrc})
		if TargetID ~= nil then
			HVCclient.ScreenFade(src)
			Wait(730)
			HVCStaffClient.StaffOn(src)
			SetEntityCoords(GetPlayerPed(src), GetEntityCoords(GetPlayerPed(TargetSrc)))
			HVCclient.notify(src, {"~g~You have received a payment of £5,000 for taking an admin ticket."})
			HVC.giveBankMoney({PlrID, 5000})
			exports['ghmattimysql']:execute("SELECT * FROM HVC_admintickets WHERE UserID = @user_id", {user_id = PlrID}, function(result)
				if #result > 0 then
					local tTickets = result[1].Tickets
					local wTickets = result[1].weeklyTickets
					local newtTickets = tonumber(tTickets) + 1
					local newwTickets = tonumber(wTickets) + 1
					exports['ghmattimysql']:execute("UPDATE HVC_admintickets SET weeklyTickets = @weeklyTickets, Tickets = @Tickets WHERE UserID = @user_id", {weeklyTickets = tonumber(newwTickets), Tickets = tonumber(newtTickets), user_id = PlrID}, function() end)
				else
					exports['ghmattimysql']:execute("INSERT INTO HVC_admintickets (UserID, Name, weeklyTickets, Tickets) VALUES( @user_id, @Name, @weeklyTickets, @Tickets) ON DUPLICATE KEY UPDATE `Tickets` = @Tickets, `weeklyTickets` = @weeklyTickets", {user_id = PlrID, Name = GetPlayerName(src), weeklyTickets = 1, Tickets = 1}, function() end)        
				end
			end)
		else
			HVCclient.notify(src, {"~r~Player unavailable, ticket failed"})
		end
	end
end


function HVCModule.Staffoff()
	local src = source
	local PlrID = HVC.getUserId({src})
	
	if HVC.hasPermission({PlrID, "admin.menu"}) then
		HVCStaffClient.StaffOff(src)
	end
end


function HVCModule.TakePoliceCall(TargetSource)
	local src = source
	local PlrID = HVC.getUserId({src})
	if PlrID ~= nil  then
		if HVC.hasPermission({PlrID, "police.menu"}) then
			HVCModuleC.ClientPoliceCall(src, {GetEntityCoords(GetPlayerPed(TargetSource))})
		else
			return
		end
	else
		return
	end
end

function HVCModule.TakeNHSCall(TargetSource)
	local src = source
	local PlrID = HVC.getUserId({src})
	if PlrID ~= nil  then
		if HVC.hasPermission({PlrID, "emscheck.revive"}) then
			HVCModuleC.ClientPoliceCall(src, {GetEntityCoords(GetPlayerPed(TargetSource))})
		else
			return
		end
	else
		return
	end
end

































function HVCModule.RequestGangInfo()
	local src = source
	local PlayerID = HVC.getUserId({src})
	local IsInGang = false
	local GangIndexing = 1
	exports['ghmattimysql']:execute("SELECT * FROM vrxith_gangs", {}, function(GangIndex)
		if #GangIndex > 0 then
			for i = 1, #GangIndex do
				GangTable = json.decode(GangIndex[i].GangMembers)
				for k,v in pairs(GangTable) do
					if not IsInGang then
						if tonumber(k) == PlayerID then
							IsInGang = true 
							GangIndexing = i
							HVCModuleC.ClientReturnGangIndex(src, {IsInGang, GangIndex[GangIndexing].GangName, GangIndex[GangIndexing].GangFunds, GangIndex[GangIndexing].GangMembers})
						else
							HVCModuleC.ClientReturnGangIndex(src, {false})
						end
					end
				end
			end
			--print("[^1HVC Modules^7] [^4Gang Menu^7] finished table search ^2Gang index: ^7" ..GangIndexing.." UserID, InGang?: " ..PlayerID.. ", " ..tostring(IsInGang))
		end
	end)
end


function HVCModule.RequestInviteInfo()
	local src = source
	local PlayerID = HVC.getUserId({src})
	local IsInGang = false
	local Invitations = {}
	exports['ghmattimysql']:execute("SELECT * FROM vrxith_ganginvites WHERE InvitedPermID = @PermID", {PermID = PlayerID}, function(InviteIndex)
		if #InviteIndex > 0 then
			for i = 1, #InviteIndex do
				Invitations[tostring(InviteIndex[i].GangName)] = {InviteIndex[i].GangName, InviteIndex[i].InvitedPermID}
			end
			--print("[^1HVC Modules^7] [^4Gang Menu^7] Gang invites search finished for UserID: " ..PlayerID.." ^2Table search result^7: " ..tostring(#InviteIndex))
			HVCModuleC.ClientReturnGangInviteIndex(src, {Invitations})
		else
			local Invites = {}
			HVCModuleC.ClientReturnGangInviteIndex(src, {Invites})
			--print("[^1HVC Modules^7] [^4Gang Menu^7] couldn't fetch invites for UserID: " ..PlayerID.." ^2Table search result^7: " ..tostring(#InviteIndex))
		end
	end)
end

function HVCModule.JoinGang(GangName)
	local src = source
	local PlayerID = HVC.getUserId({src})

	exports['ghmattimysql']:execute("SELECT * FROM vrxith_ganginvites WHERE InvitedPermID = @PermID AND GangName = @GName", {PermID = PlayerID, GName = GangName}, function(InviteIndex)

		exports['ghmattimysql']:execute("SELECT * FROM vrxith_gangs WHERE GangName = @GangName", {GangName = GangName}, function(GangIndex)
			if #GangIndex == 0 or #GangIndex == nil then
				HVCclient.notify(src, {"~r~Error Joining "..GangName})
			else
				GangMembers = json.decode(GangIndex[1].GangMembers)
				GangMembers[tostring(PlayerID)] = {GetPlayerName(src), "Recruit", PlayerID}
				exports['ghmattimysql']:execute("UPDATE vrxith_gangs SET GangMembers = @GangMembers WHERE GangName = @GangName", {GangMembers = json.encode(GangMembers), GangName = GangName}, function() end)
			end
		end)

		exports['ghmattimysql']:execute("DELETE FROM vrxith_ganginvites WHERE InvitedPermID = @PermID AND GangName = @GName", {PermID = PlayerID, GName = GangName}, function()end)		
	end)	
end

function HVCModule.CreateGang(GangName)
    local source = source
    local PlayerID = HVC.getUserId({source})
    GangMembers = {}
    GangMembers[tostring(PlayerID)] = {GetPlayerName(source), "Owner", PlayerID}

    if not HVC.hasPermission({PlayerID, "large.license"}) then
        HVCclient.notify(source,{"~r~You do not have gang license!"})
        return
    end

    exports['ghmattimysql']:execute("SELECT * FROM vrxith_gangs WHERE GangName = @GangName", {GangName = GangName}, function(GangIndex)
        if #GangIndex == 0 or #GangIndex == nil then
            exports['ghmattimysql']:execute("INSERT INTO vrxith_gangs (`GangName`, `GangFunds`, `GangMembers`) VALUES (@GangName, @GangFunds, @GangMembers);", {GangName = GangName, GangFunds = 0, GangMembers = json.encode(GangMembers)}, function() end) 
            HVCclient.notify(source, {"~g~Gang created"})
            return true
        else
            HVCclient.notify(source, {"~r~"..GangName.." already exists!"})
            return
        end
    end)
end

function HVCModule.ModifyGangFunds(Type, GangName, Amount)
    local source = source
    local PlayerID = HVC.getUserId({source})
	local PlayerRank = 0
    exports['ghmattimysql']:execute("SELECT * FROM vrxith_gangs WHERE GangName = @GangName", {GangName = GangName}, function(GangIndex)
		GangFunds = tonumber(GangIndex[1].GangFunds)
		GangMembers = json.decode(GangIndex[1].GangMembers)

		for k,v in pairs(GangMembers) do
			if tonumber(k) == PlayerID then
				if tostring(v[2]) == "Owner" then
					PlayerRank = 5
				elseif tostring(v[2]) == "Leader" then
					PlayerRank = 4
				elseif tostring(v[2]) == "Lieutenant" then
					PlayerRank = 3
				elseif tostring(v[2]) == "Member" then
					PlayerRank = 2
				elseif tostring(v[2]) == "Recruit" then
					PlayerRank = 1
				else
					PlayerRank = 0
				end
			end
		end

		if Type == "Withdraw" then
			if PlayerRank >= 3 then
				if tonumber(GangFunds) >= tonumber(Amount) then
					NewFunds = GangFunds - Amount
					exports['ghmattimysql']:execute("UPDATE vrxith_gangs SET GangFunds = @GangFunds WHERE GangName = @GangName", {GangFunds = tonumber(NewFunds), GangName = GangName}, function() end)
					HVCclient.notify(source, {"Withdrew £" ..Comma(tonumber(Amount))})
					HVC.giveBankMoney({PlayerID, tonumber(Amount)})
					HVCModuleC.ClientUpdateGangInfoByType(source, {"Funds", NewFunds})
				else
					HVCclient.notify(source, {"~r~Your gang does not have enough money."})
				end
			else
				HVCclient.notify(source, {"~r~You are not high enough to withdraw."})
			end
		elseif Type == "Deposit" then
			if PlayerRank >= 1 then
				if tonumber(Amount) <= (HVC.getMoney({PlayerID})+HVC.getBankMoney({PlayerID})) then
					NewFunds = GangFunds + Amount
					if HVC.tryFullPayment({PlayerID, tonumber(Amount)}) then
						exports['ghmattimysql']:execute("UPDATE vrxith_gangs SET GangFunds = @GangFunds WHERE GangName = @GangName", {GangFunds = tonumber(NewFunds), GangName = GangName}, function() end)
						HVCclient.notify(source, {"Deposited £" ..Comma(tonumber(Amount))})
						HVCModuleC.ClientUpdateGangInfoByType(source, {"Funds", NewFunds})
					else
						HVCclient.notify(source, {"~r~You do not have enough money."})
					end
				else
					HVCclient.notify(source, {"~r~You do not have enough money."})
				end
			else
				HVCclient.notify(source, {"~r~You are not high enough to withdraw."})
			end
		end
    end)
end



RegisterCommand("giveitem", function(source, args)
    local userid = HVC.getUserId({source})
    if userid == 1 then 
        HVC.giveInventoryItem({userid, tostring(args[1]), tonumber(args[2]), true})
    end
end)




local RankByNumber = {
	[1] = "Recruit",
	[2] = "Member",
	[3] = "Lieutenant",
	[4] = "Leader",
	[5] = "Owner",
}

function HVCModule.ModifyGangRanks(Type, GangName, SelectedPerm)
    local source = source
    local PlayerID = HVC.getUserId({source})
	local PlayerRank = 0
	local SelectedPlayerRank = 0
    exports['ghmattimysql']:execute("SELECT * FROM vrxith_gangs WHERE GangName = @GangName", {GangName = GangName}, function(GangIndex)
		GangMembers = json.decode(GangIndex[1].GangMembers)

		for k,v in pairs(GangMembers) do
			if tonumber(k) == PlayerID then
				if tostring(v[2]) == "Owner" then
					PlayerRank = 5
				elseif tostring(v[2]) == "Leader" then
					PlayerRank = 4
				elseif tostring(v[2]) == "Lieutenant" then
					PlayerRank = 3
				elseif tostring(v[2]) == "Member" then
					PlayerRank = 2
				elseif tostring(v[2]) == "Recruit" then
					PlayerRank = 1
				else
					PlayerRank = 0
				end
			elseif tonumber(k) == SelectedPerm then
				if tostring(v[2]) == "Owner" then
					SelectedPlayerRank = 5
				elseif tostring(v[2]) == "Leader" then
					SelectedPlayerRank = 4
				elseif tostring(v[2]) == "Lieutenant" then
					SelectedPlayerRank = 3
				elseif tostring(v[2]) == "Member" then
					SelectedPlayerRank = 2
				elseif tostring(v[2]) == "Recruit" then
					SelectedPlayerRank = 1
				else
					SelectedPlayerRank = 0
				end
			end
		end

		if PlayerID == SelectedPerm then
			HVCclient.notify(source, {"~r~You can't " ..Type.. " yourself."})
			return
		end

		if Type == "Promote" then
			if PlayerRank >= 3 then
				if SelectedPlayerRank < PlayerRank-1 then
					GangMembers[tostring(SelectedPerm)][2] = RankByNumber[SelectedPlayerRank+1]
					HVCModuleC.ClientUpdateGangInfoByType(source, {"Members", GangMembers})
					HVCclient.notify(source, {"~g~Successfully Promoted "..GangMembers[tostring(SelectedPerm)][1].. " to " ..RankByNumber[SelectedPlayerRank+1]})
					exports['ghmattimysql']:execute("UPDATE vrxith_gangs SET GangMembers = @GangMembers WHERE GangName = @GangName", {GangMembers = json.encode(GangMembers), GangName = GangName}, function() end)
				else
					HVCclient.notify(source, {"~r~You can't promote someone higher than yourself."})
				end
			else
				HVCclient.notify(source, {"~r~You are not high enough to promote."})
			end
		elseif Type == "Demote" then
			if PlayerRank >= 3 then
				if SelectedPlayerRank >= PlayerRank then
					HVCclient.notify(source, {"~r~You can't demote someone higher than yourself."})
					return
				end
				if SelectedPlayerRank < PlayerRank then
					GangMembers[tostring(SelectedPerm)][2] = RankByNumber[SelectedPlayerRank-1]
					HVCclient.notify(source, {"~g~Successfully Demoted "..GangMembers[tostring(SelectedPerm)][1].. " to " ..RankByNumber[SelectedPlayerRank-1]})
					exports['ghmattimysql']:execute("UPDATE vrxith_gangs SET GangMembers = @GangMembers WHERE GangName = @GangName", {GangMembers = json.encode(GangMembers), GangName = GangName}, function() end)
				end

			else
				HVCclient.notify(source, {"~r~You are not high enough to demote."})
			end
		elseif Type == "Kick" then
			if PlayerRank >= 3 then
				if SelectedPlayerRank >= PlayerRank then
					HVCclient.notify(source, {"~r~You can't demote someone higher than yourself."})
					return
				end
				HVCclient.notify(source, {"~g~Successfully Kicked "..GangMembers[tostring(SelectedPerm)][1]})
				GangMembers[tostring(SelectedPerm)] = nil
				exports['ghmattimysql']:execute("UPDATE vrxith_gangs SET GangMembers = @GangMembers WHERE GangName = @GangName", {GangMembers = json.encode(GangMembers), GangName = GangName}, function() end)
				HVCModuleC.ClientUpdateGangInfoByType(source, {"Members", GangMembers})
			end
		end
    end)
end


function HVCModule.InvitePlayerWithPermID(GangName, SelectedPerm)
    local source = source
    local PlayerID = HVC.getUserId({source})
	local PlayerRank = 0
	--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " Sent A Invite Request To TargetID: " ..SelectedPerm)
    exports['ghmattimysql']:execute("SELECT * FROM vrxith_gangs WHERE GangName = @GangName", {GangName = GangName}, function(GangIndex)
		GangMembers = json.decode(GangIndex[1].GangMembers)

		for k,v in pairs(GangMembers) do
			if tonumber(k) == PlayerID then
				if tostring(v[2]) == "Owner" then
					PlayerRank = 5
				elseif tostring(v[2]) == "Leader" then
					PlayerRank = 4
				elseif tostring(v[2]) == "Lieutenant" then
					PlayerRank = 3
				elseif tostring(v[2]) == "Member" then
					PlayerRank = 2
				elseif tostring(v[2]) == "Recruit" then
					PlayerRank = 1
				else
					PlayerRank = 0
				end
			end
		end

		--print("[^1HVC Modules^7] [^4Gang Menu^7] Processing UserID, GangRank: " ..PlayerID, PlayerRank.. "\'s invite request to TargetID: " ..SelectedPerm)
		
		if PlayerRank >= 2 then
			exports['ghmattimysql']:execute("INSERT INTO vrxith_ganginvites (GangName, InvitedPermID) VALUES(@GangName, @InvitedPermID);", {GangName = GangName, InvitedPermID = SelectedPerm}, function() end)        
			if HVC.getUserSource({tonumber(SelectedPerm)}) then
				--("[^1HVC Modules^7] [^4Gang Menu^7] TargetID: " ..SelectedPerm.." successfully recieved invite to gang: " ..GangName)
				HVCclient.notify(HVC.getUserSource({tonumber(SelectedPerm)}), {"You were invited to " ..GangName})
				HVCclient.notify(source, {"You invited " ..GetPlayerName(HVC.getUserSource({tonumber(SelectedPerm)})).. "("..SelectedPerm..") to " ..GangName})
			else
				HVCclient.notify(source, {"You invited " ..SelectedPerm.. " to " ..GangName})
			end
		else
			HVCclient.notify(source, {"~r~You are not high enough to invite."})
			--print("[^1HVC Modules^7] [^4Gang Menu^7] failed to invite user, UserID: " ..PlayerID.. " didn't have enough permissions!")
		end
    end)
end




function HVCModule.LeaveGang(GangName)
    local source = source
    local PlayerID = HVC.getUserId({source})
	local PlayerRank = 0
	--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " sent a leave gang request [^4Server^7]")
    exports['ghmattimysql']:execute("SELECT * FROM vrxith_gangs WHERE GangName = @GangName", {GangName = GangName}, function(GangIndex)
		GangMembers = json.decode(GangIndex[1].GangMembers)

		for k,v in pairs(GangMembers) do
			if tonumber(k) == PlayerID then
				if tostring(v[2]) == "Owner" then
					PlayerRank = 5
				elseif tostring(v[2]) == "Leader" then
					PlayerRank = 4
				elseif tostring(v[2]) == "Lieutenant" then
					PlayerRank = 3
				elseif tostring(v[2]) == "Member" then
					PlayerRank = 2
				elseif tostring(v[2]) == "Recruit" then
					PlayerRank = 1
				else
					PlayerRank = 0
				end
			end
		end

		--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " leave gang request is being processed [^4Server^7]")

		if PlayerRank == 5 then
			HVCclient.notify(source, {"~r~You can't leave the gang as you are the owner!"})
			--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " Leave Gang Request Has Been Denied [^1Reason:^2 Player Owns Gang [Owner]^7][^4Server^7]")
			return
		end

		if GangMembers[tostring(PlayerID)] then
			GangMembers[tostring(PlayerID)] = nil
			HVCclient.notify(source, {"~g~You left " ..GangName})
			--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " Leave Gang Request Has Been Accepted [^4Server^7]")
			exports['ghmattimysql']:execute("UPDATE vrxith_gangs SET GangMembers = @GangMembers WHERE GangName = @GangName", {GangMembers = json.encode(GangMembers), GangName = GangName}, function() end)
			HVCModuleC.PlayerLeftGang(source)
		end
	end)
end
	



function HVCModule.DisbandGang(GangName)
    local source = source
    local PlayerID = HVC.getUserId({source})
	local PlayerRank = 0
	local PlayerRankString = "N/A"
	--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " Sent A Gang Disband Request [^4Server^7]")
    exports['ghmattimysql']:execute("SELECT * FROM vrxith_gangs WHERE GangName = @GangName", {GangName = GangName}, function(GangIndex)
		GangMembers = json.decode(GangIndex[1].GangMembers)

		for k,v in pairs(GangMembers) do
			if tonumber(k) == PlayerID then
				if tostring(v[2]) == "Owner" then
					PlayerRank = 5
					PlayerRankString = "Owner"
				elseif tostring(v[2]) == "Leader" then
					PlayerRank = 4
					PlayerRankString = "Leader"
				elseif tostring(v[2]) == "Lieutenant" then
					PlayerRank = 3
					PlayerRankString = "Leader"
				elseif tostring(v[2]) == "Member" then
					PlayerRank = 2
					PlayerRankString = "Member"
				elseif tostring(v[2]) == "Recruit" then
					PlayerRank = 1
					PlayerRankString = "Recruit"
				else
					PlayerRank = 0
					PlayerRankString = "N/A"
				end
			end
		end

		if PlayerRank ~= 5 then
			--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " Gang Disband Request Was Denied [^1Reason:^2 Player Isn't Owner ["..PlayerRank.."]^7][^4Server^7]")
			HVCclient.notify(source, {"~r~You cannot disband as a " ..PlayerRankString})
			return
		elseif PlayerRank == 5 then
			exports['ghmattimysql']:execute("DELETE FROM vrxith_gangs WHERE GangName = @GangName", {GangName = GangName}, function()end)
			--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " Gang Disband Request Was Accepted [^1HVC Gangs^7: "..GangName.." Was Disbanded.][^4Server^7]")
			HVCclient.notify(source, {"~g~You disbanded " ..GangName})
			HVCModuleC.PlayerLeftGang(source)
		end
	end)
end




function HVCModule.ClearGang(GangName)
    local source = source
    local PlayerID = HVC.getUserId({source})
	local PlayerRank = 0
	--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " Sent A Clear Gang Request [^4Server^7]")
    exports['ghmattimysql']:execute("SELECT * FROM vrxith_gangs WHERE GangName = @GangName", {GangName = GangName}, function(GangIndex)
		GangMembers = json.decode(GangIndex[1].GangMembers)

		for k,v in pairs(GangMembers) do
			if tonumber(k) == PlayerID then
				if tostring(v[2]) == "Owner" then
					PlayerRank = 5
				elseif tostring(v[2]) == "Leader" then
					PlayerRank = 4
				elseif tostring(v[2]) == "Lieutenant" then
					PlayerRank = 3
				elseif tostring(v[2]) == "Member" then
					PlayerRank = 2
				elseif tostring(v[2]) == "Recruit" then
					PlayerRank = 1
				else
					PlayerRank = 0
				end
			end
		end

		--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " Clear Gang Request Is Being Processed [^4Server^7]")

		if PlayerRank == 5 then
			for k,v in pairs(GangMembers) do
				if tonumber(k) ~= PlayerID then
					GangMembers[tostring(k)] = nil
				end
			end

			HVCclient.notify(source, {"~g~You cleared your gang!"})
			exports['ghmattimysql']:execute("UPDATE vrxith_gangs SET GangMembers = @GangMembers WHERE GangName = @GangName", {GangMembers = json.encode(GangMembers), GangName = GangName}, function() end)
			--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " Clear Gang Request Has Been Accepted [^4Server^7]")
		else
			HVCclient.notify(source, {"~r~You can't clear the gang"})
			--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " Clear Gang Request Has Been Denied [^1Reason:^2 Player Doesn't Owns Gang [Owner]^7][^4Server^7]")
			return
		end
	end)
end
	


function HVCModule.TransferGangOwnership(GangName, SelectedPerm)
    local source = source
    local PlayerID = HVC.getUserId({source})
	local PlayerRank = 0
	--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " Sent an ownership transfer request [^4Server^7]")
    exports['ghmattimysql']:execute("SELECT * FROM vrxith_gangs WHERE GangName = @GangName", {GangName = GangName}, function(GangIndex)
		GangMembers = json.decode(GangIndex[1].GangMembers)

		for k,v in pairs(GangMembers) do
			if tonumber(k) == PlayerID then
				if tostring(v[2]) == "Owner" then
					PlayerRank = 5
				elseif tostring(v[2]) == "Leader" then
					PlayerRank = 4
				elseif tostring(v[2]) == "Lieutenant" then
					PlayerRank = 3
				elseif tostring(v[2]) == "Member" then
					PlayerRank = 2
				elseif tostring(v[2]) == "Recruit" then
					PlayerRank = 1
				else
					PlayerRank = 0
				end
			end
		end
 
		--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " Ownership transfer request is being processed [^4Server^7]")

		if PlayerRank == 5 then
			if HVC.getPlayerSource({tonumber(SelectedPerm)}) then
				GangMembers[tostring(SelectedPerm)][2] = "Owner"
				GangMembers[tostring(PlayerID)][2] = "Leader"
				HVCclient.notify(source, {"~g~Transfered ownership to " ..GetPlayerName(HVC.getPlayerSource({tonumber(SelectedPerm)}))})
				exports['ghmattimysql']:execute("UPDATE vrxith_gangs SET GangMembers = @GangMembers WHERE GangName = @GangName", {GangMembers = json.encode(GangMembers), GangName = GangName}, function() end)
				--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " Ownership transfer request has been accepted [^4Server^7]")
			else
				HVCclient.notify(source, {"~r~Player is not online!"})
			end
		else
			HVCclient.notify(source, {"~r~You are not the gang owner"})
			--print("[^1HVC Modules^7] [^4Gang Menu^7] UserID: " ..PlayerID.. " Ownership transfer request has been denied [^1Reason:^2 player doesn't owns gang [Owner]^7][^4Server^7]")
			return
		end
	end)
end



Citizen.CreateThread(function()
    Wait(2500)
    exports['ghmattimysql']:execute([[
        CREATE TABLE IF NOT EXISTS `vrxith_gangs` (
            `GangID` INT(11) NOT NULL AUTO_INCREMENT,
            `GangName` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            `GangFunds` BIGINT(20) NULL DEFAULT NULL,
            `GangMembers` TINYTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            PRIMARY KEY (`GangID`) USING BTREE
        );
    ]])
	exports['ghmattimysql']:execute([[
		CREATE TABLE IF NOT EXISTS `vrxith_ganginvites` (
			`GangName` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
			`InvitedPermID` INT(11) NULL DEFAULT NULL
		)
    ]])
end)




RegisterCommand("staffon", function(source, args, raw)
	local src = source
	local PlrID = HVC.getUserId({src})
    if not HVC.hasPermission({PlrID, "admin.menu"}) then
		HVCclient.notify(src, {"~r~You aren't staff"})
    else
		HVCclient.notify(src, {"~g~Staff mode activated!"})
		local Health = GetEntityHealth(GetPlayerPed(src))
		if Health < 200 then
			TriggerEvent("HVC:ProvideHealth", src, 200)
		end
		HVCModuleC.ClientStaffOnDuty(src, {"Staffon"})
    end
end)


RegisterCommand("staffoff", function(source, args, raw)
	local src = source
	local PlrID = HVC.getUserId({src})
    if not HVC.hasPermission({PlrID, "admin.menu"}) then
        HVCclient.notify(src, {"~r~You aren't staff"})
    else
		HVCclient.notify(src, {"~g~Staff mode deactivated!"})
        HVCModuleC.ClientStaffOnDuty(src, {"Staffoff"})
    end
end)


function HVCModule.CreateObj(modelHash, x, y, z, isNetwork, thisScriptCheck, dynamic) 
	return CreateObject(modelHash, x, y, z, isNetwork, thisScriptCheck, dynamic)
end


function HVCModule.CreateVehicle(modelHash, x, y, z, heading, isNetwork, thisScriptCheck)
	return CreateVehicle(modelHash, x, y, z, heading, isNetwork, thisScriptCheck)
end