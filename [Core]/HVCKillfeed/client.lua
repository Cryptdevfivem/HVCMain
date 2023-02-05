-- Configuration Options
local config = {
	prox_enabled = false,					-- Proximity Enabled
	prox_range = 100,						-- Distance	-- Toggle Kill Feed Command
}

local toggledkf = true
local toggledkfdistance = true

-- Weapons Table
local weapons = {
	[-1569615261] = 'melee',
	[GetHashKey("WEAPON_SPAR17HVC")] = 'aks',
	[GetHashKey("WEAPON_MXMHVC")] = 'aks',
	[GetHashKey("WEAPON_MK1EMRHVC")] = 'aks',
	[GetHashKey("WEAPON_UMPHVC")] = 'smgs',
	[GetHashKey("WEAPON_MP5HVC")] = 'smgs',
	[GetHashKey("WEAPON_UZIHVC")] = 'smgs',
	[GetHashKey("WEAPON_SPAR16HVC")] = 'aks',
	[GetHashKey("WEAPON_BATONHVC")] = 'melee',
	[GetHashKey("WEAPON_BUTTERFLYHVC")] = 'melee',
	[GetHashKey("WEAPON_SHANKHVC")] = 'melee',
	[GetHashKey("WEAPON_TOILETBRUSHHVC")] = 'melee',
	[GetHashKey("WEAPON_CRUTCHHVC")] = 'melee',
	[GetHashKey("WEAPON_GUITARHVC")] = 'melee',
	[GetHashKey("WEAPON_KITCHENHVC")] = 'melee',
	[GetHashKey("WEAPON_KASHNARHVC")] = 'aks',
	[GetHashKey("WEAPON_AK200HVC")] = 'aks',
	[GetHashKey("WEAPON_AK74HVC")] = 'aks',
	[GetHashKey("WEAPON_PQ15HVC")] = 'aks',
	[GetHashKey("WEAPON_SIGMCXHVC")] = 'aks',
	[GetHashKey("WEAPON_G36KHVC")] = 'aks',
	[GetHashKey("WEAPON_MOSINHVC")] = 'sniperr',
	[GetHashKey("WEAPON_REMINGTON870HVC")] = 'mosin',
	[GetHashKey("WEAPON_WINCHESTER12HVC")] = 'mosin',
	[GetHashKey("WEAPON_GLOCK17HVC")] = 'pistol',
	[GetHashKey("WEAPON_M1911HVC")] = 'pistol',
	[GetHashKey("WEAPON_MAKAROVHVC")] = 'pistol',
	[GetHashKey("WEAPON_BARRETHVC")] = 'sniperr',
	[GetHashKey("WEAPON_SVDHVC")] = 'sniperr',
	[GetHashKey("WEAPON_LR300HVC")] = 'aks',
	[GetHashKey("WEAPON_BARRET50HVC")] = 'sniperr',
	[GetHashKey("WEAPON_MSRHVC")] = 'sniperr',
	[GetHashKey("WEAPON_SV98HVC")] = 'sniperr',
	[GetHashKey("WEAPON_M4A1SDECIMATORHVC")] = 'aks',
	[GetHashKey("WEAPON_M4A1SSAGIRIRHVC")] = 'aks',
	[GetHashKey("WEAPON_CNDYRIFLEHVC")] = 'aks',
	[GetHashKey("WEAPON_AUGHVC")] = 'aks',
	[GetHashKey("WEAPON_GRAUHVC")] = 'aks',
	[GetHashKey("WEAPON_VANDALHVC")] = 'aks',
	[GetHashKey("WEAPON_NV4HVC")] = 'aks',
	[GetHashKey("WEAPON_HONEYBADGERHVC")] = 'aks',
	[GetHashKey("WEAPON_HK418HVC")] = 'aks',
	[GetHashKey("WEAPON_SCORPBLUEHVC")] = 'smgs',
	[GetHashKey("WEAPON_PERFORATORHVC")] = 'melee',
	[GetHashKey("WEAPON_GUNGIRLDEAGLEHVC")] = 'pistol',
	[GetHashKey("WEAPON_SAKURADEAGLEHVC")] = 'pistol',
	[GetHashKey("WEAPON_PRINTSTREAMDEAGLEHVC")] = 'pistol',
	[GetHashKey("WEAPON_KILLCONFIRMEDDEAGLEHVC")] = 'pistol',
	[GetHashKey("WEAPON_TINTHVC")] = 'pistol',
	[GetHashKey("WEAPON_ASIIMOVPISTOLHVC")] = 'pistol',
	[GetHashKey("WEAPON_VOMFEUERHVC")] = 'pistol',
	[GetHashKey("WEAPON_MISTHVC")] = 'melee',
	[GetHashKey("WEAPON_M4A1SSAGIRIHVC")] = 'aks',
	[GetHashKey("WEAPON_FNX45HVC")] = 'pistol',
	[GetHashKey("WEAPON_FINNHVC")] = 'pistol',
	[GetHashKey("WEAPON_CARB2HVC")] = 'aks',
	[GetHashKey("WEAPON_MISTHVC")] = 'melee',
	[GetHashKey("WEAPON_KARAMBITHVC")] = 'melee',
	[GetHashKey("WEAPON_PPSHHVC")] = 'smgs',
	[GetHashKey("WEAPON_HAHAHVC")] = 'smgs',
	[GetHashKey("WEAPON_HOWLHVC")] = 'aks',
	[GetHashKey("WEAPON_GDEAGLEHVC")] = 'pistol',
	[GetHashKey("WEAPON_PICKHVC")] = 'melee',
	[GetHashKey("WEAPON_HOBBYHVC")] = 'melee',
	[GetHashKey("WEAPON_LIGHTSABERHVC")] = 'melee',
	[GetHashKey("WEAPON_KATANAHVC")] = 'melee',
	[GetHashKey("WEAPON_SPHANTOMHVC")] = 'aks',
	[GetHashKey("WEAPON_PAINTBALL1")] = 'pistol',
	[GetHashKey("WEAPON_PAINTBALL2")] = 'pistol',
	[GetHashKey("WEAPON_TIGERHVC")] = 'melee',
	[GetHashKey("WEAPON_LEVIATHANHVC")] = 'melee',
	[GetHashKey("WEAPON_ADAGGERHVC")] = 'melee',
	[GetHashKey("WEAPON_L96HVC")] = 'sniperr',
	[GetHashKey("WEAPON_MP7A2HVC")] = 'smgs',
	[GetHashKey("WEAPON_M107HVC")] = 'sniperr',
	[GetHashKey("WEAPON_M4A1SNIGHTMAREHVC")] = 'aks',
	[GetHashKey("WEAPON_PILUMHVC")] = 'melee',
	[GetHashKey("WEAPON_HAYMAKERHVC")] = 'mosin',
	[GetHashKey("WEAPON_USPSTORQUEHVC")] = 'pistol', 
	[GetHashKey("WEAPON_REAVERVANDALHVC")] = 'aks',
	[GetHashKey("WEAPON_M4A1HVC")] = 'aks',
	[GetHashKey("WEAPON_SCARHVC")] = 'aks',
	[GetHashKey("WEAPON_MP5A2HVC")] = 'smgs',
	[GetHashKey("WEAPON_IRONWOLFHVC")] = 'aks',
	[GetHashKey("WEAPON_LIQUIDCARBINEHVC")] = 'aks',
	[GetHashKey("WEAPON_M82A2HVC")] = 'sniperr',
	[GetHashKey("WEAPON_M82A3HVC")] = 'sniperr',
	[GetHashKey("WEAPON_GUNGNIRHVC")] = 'sniperr',
	[GetHashKey("WEAPON_BORAHVC")] = 'sniperr',
	[GetHashKey("WEAPON_HADDESNIPERHVC")] = 'sniperr',
	[GetHashKey("WEAPON_M98BHVC")] = 'sniperr',
	[GetHashKey("WEAPON_M200HVC")] = 'sniperr',
	[GetHashKey("WEAPON_ORSIST5000HVC")] = 'sniperr',
	[GetHashKey("WEAPON_MSR2HVC")] = 'sniperr',
	[GetHashKey("WEAPON_STACHVC")] = 'sniperr',
	[GetHashKey("WEAPON_RIFLEV2HVC")] = 'aks',
	[GetHashKey("WEAPON_VALHVC")] = 'aks',
	[GetHashKey("WEAPON_M4A4HYBRIDHVC")] = 'aks',
	[GetHashKey("WEAPON_M4A4FIREHVC")] = 'aks',
	[GetHashKey("WEAPON_NERFBLASTERHVC")] = 'aks',
	[GetHashKey("WEAPON_MXHVC")] = 'aks',
	[GetHashKey("WEAPON_M60HVC")] = 'aks',
	[GetHashKey("WEAPON_USAS12HVC")] = 'sniperr',
	[GetHashKey("WEAPON_HKV2HVC")] = 'aks',
	[GetHashKey("WEAPON_HK416HVC")] = 'aks',
	[GetHashKey("WEAPON_FNFALHVC")] = 'aks',
	[GetHashKey("WEAPON_DRAGONAKHVC")] = 'aks',
	[GetHashKey("WEAPON_MK18HVC")] = 'aks', 
	[GetHashKey("WEAPON_M16A4HVC")] = 'aks',
	[GetHashKey("WEAPON_M13HVC")] = 'aks',
	[GetHashKey("WEAPON_RAINBOWLR300HVC")] = 'aks',
	[GetHashKey("WEAPON_ICEDRAKEHVC")] = 'aks',
	[GetHashKey("WEAPON_M203HVC")] = 'aks',
	[GetHashKey("WEAPON_M4FBXHVC")] = 'aks',
	[GetHashKey("WEAPON_M4HVC")] = 'aks',
	[GetHashKey("WEAPON_M4A4NOIRHVC")] = 'aks',
	[GetHashKey("WEAPON_M4A1SNEONOIRHVC")] = 'aks',
	[GetHashKey("WEAPON_M4A1SPURPLEHVC")] = 'aks',
	[GetHashKey("WEAPON_MK18V2HVC")] = 'aks',
	[GetHashKey("WEAPON_PRIMEVANDALHVC")] = 'aks',
	[GetHashKey("WEAPON_ORIGINVANDALHVC")] = 'aks',
	[GetHashKey("WEAPON_REDTIGERHVC")] = 'aks',
	[GetHashKey("WEAPON_SP1HVC")] = 'aks',
	[GetHashKey("WEAPON_M4A4RIOTHVC")] = 'aks',
	[GetHashKey("WEAPON_M4A4RETROHVC")] = 'aks',
	[GetHashKey("WEAPON_XM4TIGERHVC")] = 'aks',
	[GetHashKey("WEAPON_AHVC")] = 'aks',
	[GetHashKey("WEAPON_DIAMONDMP5HVC")] = 'smgs',
	[GetHashKey("WEAPON_MTARGLOWCHVC")] = 'smgs',
	[GetHashKey("WEAPON_MP5GLOWHVC")] = 'smgs',
	[GetHashKey("WEAPON_MP5A3HVC")] = 'smgs',
	[GetHashKey("WEAPON_MPXCHVC")] = 'smgs',
	[GetHashKey("WEAPON_P90HVC")] = 'smgs',
	[GetHashKey("WEAPON_P90V2HVC")] = 'smgs',
	[GetHashKey("WEAPON_PRIMESPECTREHVC")] = 'smgs',
	[GetHashKey("WEAPON_SCORPEVOEHVC")] = 'smgs',
	[GetHashKey("WEAPON_SINGULARITYSPECTREHVC")] = 'smgs',
	[GetHashKey("WEAPON_T5GLOWHVC")] = 'smgs',
	[GetHashKey("WEAPON_VSSHVC")] = 'smgs',
	[GetHashKey("WEAPON_VESPERHVC")] = 'smgs',
	[GetHashKey("WEAPON_VESPERHYBRIDHVC")] = 'smgs',
	[GetHashKey("WEAPON_ARESSHRIKEHVC")] = 'aks',
	[GetHashKey("WEAPON_FNMAGHVC")] = 'aks',
	[GetHashKey("WEAPON_M60V2HVC")] = 'aks',
	[GetHashKey("WEAPON_MK249HVC")] = 'aks',
	[GetHashKey("WEAPON_DEADPOOLSHOTGUNHVC")] = 'sniperr',
	[GetHashKey("WEAPON_HAYMAKERV2HVC")] = 'sniperr',
	[GetHashKey("WEAPON_PUMPSHOTGUNMK2HVC")] = 'sniperr',
	[GetHashKey("WEAPON_SPAS12HVC")] = 'sniperr',
	[GetHashKey("WEAPON_RPK16HVC")] = 'aks',
	[GetHashKey("WEAPON_AK47KITTYREVENGEHVC")] = 'aks',
	[GetHashKey("WEAPON_L118A1HVC")] = 'aks',
	[GetHashKey("WEAPON_MINIMIM249HVC")] = 'sniperr',
	[GetHashKey("WEAPON_SR25HVC")] = 'aks',
	[GetHashKey("WEAPON_ANIMESWORDHVC")] = 'melee',
	[GetHashKey("WEAPON_wuxiafanHVC")] = 'melee',
	[GetHashKey("WEAPON_ANIMEMAC10HVC")] = 'smgs',
	[GetHashKey("WEAPON_DIAMONDSWORDHVC")] = 'melee',
	[GetHashKey("WEAPON_GLITCHPOPOPERATORHVC")] = 'sniperr',
	[GetHashKey("WEAPON_RE6HVC")] = 'aks',
	[GetHashKey("WEAPON_RE6RNHVC")] = 'aks',
	[GetHashKey("WEAPON_RE6SNIPERHVC")] = 'sniperr',
	[GetHashKey("WEAPON_M4A4NEVAHVC")] = 'aks',
	[GetHashKey("WEAPON_AK74UV3HVC")] = 'aks',
	[GetHashKey("WEAPON_SR25HVC")] = 'aks',
	[GetHashKey("WEAPON_ANIMESWORDHVC")] = 'melee',
	[GetHashKey("WEAPON_wuxiafanHVC")] = 'melee',
	[GetHashKey("WEAPON_ANIMEMAC10HVC")] = 'smgs',
	[GetHashKey("WEAPON_DIAMONDSWORDHVC")] = 'melee',
	[GetHashKey("WEAPON_ODINHVC")] = 'aks',
	[GetHashKey("WEAPON_BLASTXPHANTOMHVC")] = 'aks',
	[GetHashKey("WEAPON_M4A4DRAGONKINGHVC")] = 'aks',
	[GetHashKey("WEAPON_BAL27HVC")] = 'aks',
	[GetHashKey("WEAPON_PURPLENIKEGRAUHVC")] = 'aks',
	[GetHashKey("WEAPON_AKCQBHVC")] = 'aks',
	[GetHashKey("WEAPON_HEADSTONEAUGHVC")] = 'aks',
	[GetHashKey("WEAPON_FFARHVC")] = 'aks',
	[GetHashKey("WEAPON_PARAFALSOULREAPERHVC")] = 'aks',
	[GetHashKey("WEAPON_ORIGINVANDALYELLOWHVC")] = 'aks',	
	[GetHashKey("WEAPON_ACRCQBHVC")] = 'smgs',
	[GetHashKey("WEAPON_AK74UGOKU")] = 'smgs',
	[GetHashKey("WEAPON_M249HVC")] = 'aks',
	[GetHashKey("WEAPON_LVOAHVC")] = 'aks',
	[GetHashKey("WEAPON_NERFMOSINHVC")] = 'sniperr',
	[GetHashKey("WEAPON_VITYAZ")] = 'smgs',
	[GetHashKey("WEAPON_VTSGLOWHVC")] = 'pistol',
	[GetHashKey("WEAPON_GLITCHPOPPHANTOMHVC")] = 'aks',
	[GetHashKey("WEAPON_TACGLOCK19")] = 'pistol',
	[GetHashKey("WEAPON_AWPMIKU")] = 'sniperr',
	[GetHashKey("WEAPON_HKMP5K")] = 'smgs',
	[GetHashKey("WEAPON_MODEL680")] = 'sniperr',
	[GetHashKey("WEAPON_SVDK")] = 'sniperr',
	[GetHashKey("WEAPON_G28")] = 'sniperr',
	[GetHashKey("WEAPON_FIVESEVENHVC")] = 'pistol',
	[GetHashKey("WEAPON_SIGSAUERP226R")] = 'pistol',
	[GetHashKey("WEAPON_COLTM16A2HVC")] = 'aks',
	[GetHashKey("WEAPON_MWUZIHVC")] = 'smgs',
	[GetHashKey("WEAPON_FX05HVC")] = 'aks',
	[GetHashKey("WEAPON_TX15")] = 'aks',
	[GetHashKey("WEAPON_M14")] = 'sniperr',
	[GetHashKey("WEAPON_RPD")] = 'aks',
	[GetHashKey("WEAPON_FFARAUTOTOONHVC")] = 'aks',
	[GetHashKey("WEAPON_SIGHVC")] = 'smgs',
	[GetHashKey("WEAPON_GSCYTHE")] = 'melee',
	[GetHashKey("WEAPON_PK470")] = 'aks',
	[GetHashKey("WEAPON_IBAK")] = 'aks',
	[GetHashKey("WEAPON_ODINX")] = 'aks',
	[GetHashKey("WEAPON_HBRA3")] = 'aks',
	[GetHashKey("WEAPON_AN94")] = 'aks',
	[GetHashKey("WEAPON_HKMG4")] = 'aks',
	[GetHashKey("WEAPON_S75")] = 'sniperr',
	[GetHashKey("WEAPON_M77")] = 'sniperr',
	[GetHashKey("WEAPON_AR160")] = 'aks',
	[GetHashKey("WEAPON_M40A3")] = 'sniperr',
	[GetHashKey("WEAPON_ELDERVANDAL")] = 'aks',
	[GetHashKey("WEAPON_RGXVANDAL")] = 'aks',
	[GetHashKey("WEAPON_REAVEROPERATOR")] = 'sniperr',
	[GetHashKey("WEAPON_WARHEAD")] = 'sniperr',
	[GetHashKey("WEAPON_WARHEADAR")] = 'aks',
	[GetHashKey("WEAPON_STAC")] = 'sniperr',
	[GetHashKey("WEAPON_PHAN")] = 'aks',
	[GetHashKey("WEAPON_SOLBLUE")] = 'aks',
	[GetHashKey("WEAPON_HAWKM4")] = 'aks',
	[GetHashKey("WEAPON_REAVERVANDALWHITE")] = 'aks',
	[GetHashKey("WEAPON_M249PLAYMAKER")] = 'aks',
	[GetHashKey("WEAPON_XM177 ")] = 'aks',
	[GetHashKey("WEAPON_MK18CQBR")] = 'aks',
	[GetHashKey("WEAPON_M16A2")] = 'aks',
	[GetHashKey("WEAPON_MK18V2")] = 'aks',
	[GetHashKey("WEAPON_DEAGLE")] = 'pistol',
	[GetHashKey("WEAPON_IMPULSEAK47")] = 'aks',
	[GetHashKey("WEAPON_SAIGRY")] = 'aks',
	[GetHashKey("WEAPON_GLOWAUG")] = 'aks',
}

local feedActive = true

local isDead = false
Citizen.CreateThread(function()
    while true do
		local killed = GetPlayerPed(PlayerId())
		local killedCoords = GetEntityCoords(killed)
		if IsEntityDead(killed) and not isDead then
            local killer = GetPedKiller(killed)
            if killer ~= 0 then
                if killer == killed then
					TriggerServerEvent('KillFeed:Died', killedCoords)
				else
					local KillerNetwork = NetworkGetPlayerIndexFromPed(killer)
					if KillerNetwork == "**Invalid**" or KillerNetwork == -1 then
						TriggerServerEvent('KillFeed:Died', killedCoords)
					else
						TriggerServerEvent('KillFeed:Killed', GetPlayerServerId(KillerNetwork), hashToWeapon(GetPedCauseOfDeath(killed)), killedCoords)
					end
                end
            else
				TriggerServerEvent('KillFeed:Died', killedCoords)
            end
            isDead = true
        end
		if not IsEntityDead(killed) then
			isDead = false
		end
        Citizen.Wait(50)
    end
end)

RegisterNetEvent('KillFeed:AnnounceKill')
AddEventHandler('KillFeed:AnnounceKill', function(killed, killer, weapon, coords, killergroup, killedgroup, Distance)
	if feedActive then
		if coords ~= nil and config.prox_enabled then
			local myLocation = GetEntityCoords(GetPlayerPed(PlayerId()))
			if #(myLocation - coords) < config.prox_range then
				if not toggledfk then
					SendNUIMessage({
						type = 'newKill',
						killer = killer,
						killed = killed,
						weapon = weapon,
						killergroup = killergroup,
						killedgroup = killedgroup,
						container = "killContainer",
						distance = "", 
					})
				end
			end
		else
			--if killed == GetPlayerName(GetPlayerFromServerId(PlayerId())) or killer == GetPlayerName(GetPlayerFromServerId(PlayerId())) then
			if killed == GetPlayerName(PlayerId()) or killer == GetPlayerName(PlayerId()) then
				container = "selfkillcontainer"
			else
				container = "killContainer"
			end
			--print(Distance)
			local Distance1 = ""
			if toggledkfdistance then
				Distance1 = " ["..round(Distance).. "m]"
			else
				Distance1 = ""
			end

			if not toggledfk then
				SendNUIMessage({
					type = 'newKill',
					killer = killer,
					killed = killed,
					weapon = weapon,
					killergroup = killergroup,
					killedgroup = killedgroup,
					container = container,
					distance = Distance1, 
				})
			end
		end
	end
end)

function round(number)
    local _, decimals = math.modf(number)
    if decimals < 0.5 then return math.floor(number) end
    return math.ceil(number)
end

RegisterNetEvent('KillFeed:AnnounceDeath')
AddEventHandler('KillFeed:AnnounceDeath', function(killed, coords, group)
	if feedActive then
		local container = "killContainer"
		if coords ~= nil and config.prox_enabled then
			local myLocation = GetEntityCoords(GetPlayerPed(PlayerId()))
			if #(myLocation - coords) < config.prox_range then
				if not toggledfk then
					SendNUIMessage({
						type = 'newDeath',
						killed = killed,
						group = group,
						container = "killContainer",
					})
				end
			end
		else
			--if killed == GetPlayerName(GetPlayerFromServerId(PlayerId())) then
			if killed == GetPlayerName(PlayerId()) then
				container = "selfkillcontainer"
			else
				container = "killContainer"
			end
			if not toggledfk then
				SendNUIMessage({
					type = 'newDeath',
					killed = killed,
					group = group,
					container = container,
				})
			end
		end
	end
end)

RegisterNetEvent('Vrxith:Settings:Killfeed')
AddEventHandler('Vrxith:Settings:Killfeed', function(bool)
	toggledfk = bool

	if toggledfk then
    	--HVCNotify("~y~Killfeed is now hidden.")
		TriggerEvent("Vrxith:Settings:Reset", "Killfeed", toggledfk)
	else
		--HVCNotify("~y~Killfeed is now visible.")
		TriggerEvent("Vrxith:Settings:Reset", "Killfeed", toggledfk)
	end
end)

RegisterNetEvent('Vrxith:Settings:KillfeedDistance')
AddEventHandler('Vrxith:Settings:KillfeedDistance', function(bool)
	toggledkfdistance = bool
	if toggledkfdistance then
    	--HVCNotify("~y~Killfeed Distance is now hidden.")
		TriggerEvent("Vrxith:Settings:Reset", "KillfeedDistance", toggledkfdistance)
	else
		--HVCNotify("~y~Killfeed Distance is now visible.")
		TriggerEvent("Vrxith:Settings:Reset", "KillfeedDistance", toggledkfdistance)
	end
end)


function hashToWeapon(hash)
	if weapons[hash] ~= nil then
		return weapons[hash]
	else
		return 'weapon_unarmed'
	end
end

function HVCNotify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end