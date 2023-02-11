Citizen.CreateThread(function()
	RequestIpl("k4mb1_ornate_bank_milo_")
	
-- Pacific
	local interiorid = GetInteriorAtCoords(247.9133, 218.0428, 105.2830)

	RefreshInterior(interiorid)
	
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1)
	  local myCoords = GetEntityCoords(GetPlayerPed(-1))
	  if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 417.5313, 6487.051, 28.11554, true ) < 100 then
		ClearAreaOfPeds(417.5313, 6487.051, 28.11554, 100.0, 0)
	  end
	end
  end)
  

local int_id = GetInteriorAtCoords(345.4899597168,294.95315551758,98.191421508789)

Citizen.CreateThread(function()
	RequestIpl("lafa2k_bkr_biker_dlc_int_02")
	local interiorID = GetInteriorAtCoords(889.67889404297,-2102.9304199219,30.761777877808)
	if IsValidInterior(interiorID) then
		EnableInteriorProp(interiorID, "walls_01")
		EnableInteriorProp(interiorID, "lower_walls_default")
		EnableInteriorProp(interiorID, "furnishings_02")
		EnableInteriorProp(interiorID, "mural_03")
		EnableInteriorProp(interiorID, "decorative_02")
		EnableInteriorProp(interiorID, "gun_locker")
		EnableInteriorProp(interiorID, "mod_booth")
		--Objetos ilegais espalhados pelo motoclube (meta, dinheiro, maconha, coca, documentos ilegais)
		EnableInteriorProp(interiorID, "meth_small")
		EnableInteriorProp(interiorID, "meth_medium")
		EnableInteriorProp(interiorID, "meth_large")
		EnableInteriorProp(interiorID, "cash_small")
		EnableInteriorProp(interiorID, "cash_medium")
		EnableInteriorProp(interiorID, "cash_large")
		EnableInteriorProp(interiorID, "weed_small")
		EnableInteriorProp(interiorID, "weed_medium")
		EnableInteriorProp(interiorID, "weed_large")
		EnableInteriorProp(interiorID, "coke_small")
		EnableInteriorProp(interiorID, "coke_medium")
		EnableInteriorProp(interiorID, "coke_large")
		EnableInteriorProp(interiorID, "counterfeit_small")
		EnableInteriorProp(interiorID, "counterfeit_medium")
		EnableInteriorProp(interiorID, "counterfeit_large")
		EnableInteriorProp(interiorID, "id_small")
		EnableInteriorProp(interiorID, "id_medium")
		EnableInteriorProp(interiorID, "id_large")
		-- Opções de cores para as paredes (mudar o numero no final)
		-- Verde e cinza = 1,
		-- multicolor = 2,
		-- Laranja e Cinza = 3,
		-- Azul = 4,
		-- Azul claro = 5,
		-- Verde e vermelho = 6,
		-- Amarelo e Cinza = 7,
		-- Vermelho = 8,
		-- Rosa e cinza = 9
		SetInteriorPropColor(interiorID, "walls_01", 8)
		SetInteriorPropColor(interiorID, "lower_walls_default", 8)
		RefreshInterior(interiorID)
	end
end)


	 -- House ipls
	-- function RequestHouseIpls()
		-- Trapstar
	--	RequestIpl("ex_dt1_11_office_01a")
	--	RequestIpl("ex_dt1_11_office_01b")
	--	RequestIpl("ex_dt1_11_office_01c")
	--	RequestIpl("ex_dt1_11_office_02a")
	--	RequestIpl("ex_dt1_11_office_02b")
	--	RequestIpl("ex_dt1_11_office_02c")
	--	RequestIpl("ex_dt1_11_office_03a")
--		RequestIpl("ex_dt1_11_office_03b")
--		RequestIpl("ex_dt1_11_office_03c")

	--end


CreateThread(function()
	--?Reduces waves in far ocean.
	SetDeepOceanScaler(0.0)

	--Diamond Casino
	RequestIpl("vw_casino_penthouse")
	RequestIpl("vw_casino_main")
	RequestIpl("vw_casino_garage")
	RequestIpl("vw_casino_carpark")
	RequestIpl("vw_casino_billboard")
	RequestIpl("hei_dlc_casino_door")
	RequestIpl("vw_dlc_casino_door")
	RequestIpl("hei_dlc_windows_casino")
	local interiorID = GetInteriorAtCoords(1100.00000000,220.00000000,-50.00000000)
	if IsValidInterior(interiorID) then
		EnableInteriorProp(interiorID, "0x30240D11")
		EnableInteriorProp(interiorID, "0xA3C89BB2")
		RefreshInterior(interiorID)
	end

	--?Casino Pent House
	local interiorID = GetInteriorAtCoords(947.88037109375,19.306285858154,116.16418457031)
	if IsValidInterior(interiorID) then
		EnableInteriorProp(interiorID, "Set_Pent_Tint_Shell")
		EnableInteriorProp(interiorID, "Set_Pent_Media_Bar_Open")
		EnableInteriorProp(interiorID, "Set_Pent_Arcade_Retro")
		EnableInteriorProp(interiorID, "set_pent_bar_party_2")
		EnableInteriorProp(interiorID, "set_pent_bar_light_0")
		EnableInteriorProp(interiorID, "set_pent_bar_party_0")
		SetInteriorPropColor(interiorID,"Set_Pent_Tint_Shell",4)
		RefreshInterior(interiorID)
	end

		--?Paleto Base/Garage (the old HS one)
		RequestIpl("paleto_garage_milo_")
		local interiorID = GetInteriorAtCoords(79.208, 6525.550, 30.227)
		if IsValidInterior(interiorID) then
			EnableInteriorProp(interiorID, "walls_02")
			SetInteriorPropColor(interiorID, "walls_02", 8)
			EnableInteriorProp(interiorID, "Furnishings_02")
			SetInteriorPropColor(interiorID, "Furnishings_02", 8)
			EnableInteriorProp(interiorID, "decorative_02")
			EnableInteriorProp(interiorID, "mural_03")
			EnableInteriorProp(interiorID, "lower_walls_default")
			SetInteriorPropColor(interiorID, "lower_walls_default", 8)
			EnableInteriorProp(interiorID, "mod_booth")
			EnableInteriorProp(interiorID, "gun_locker")
			EnableInteriorProp(interiorID, "cash_small")
			EnableInteriorProp(interiorID, "id_small")
			EnableInteriorProp(interiorID, "weed_small")
			RefreshInterior(interiorID)
		end

	--Casino Heist -- houses
	RequestIpl("ch_int_placement_ch_interior_0_dlc_casino_heist_milo_")
	RequestIpl("ch_int_placement_ch_interior_1_dlc_arcade_milo_")
	RequestIpl("ch_int_placement_ch_interior_2_dlc_plan_milo_")
	RequestIpl("ch_int_placement_ch_interior_3_dlc_casino_back_milo_")
	RequestIpl("ch_int_placement_ch_interior_4_dlc_casino_hotel_milo_")
	RequestIpl("ch_int_placement_ch_interior_5_dlc_casino_loading_milo_")
	RequestIpl("ch_int_placement_ch_interior_6_dlc_casino_vault_milo_")
	RequestIpl("ch_int_placement_ch_interior_7_dlc_casino_utility_milo_")
	RequestIpl("ch_int_placement_ch_interior_8_dlc_tunnel_milo_")
	RequestIpl("ch_int_placement_ch_interior_9_dlc_casino_shaft_milo_")
	-- Vault
	local interiorid = GetInteriorAtCoords(2488.348, -267.3637, -71.64563)
	-- Interior props / entitysets
	-- EnableInteriorProp(interiorid, "set_vault_door") -- Open vault
	-- EnableInteriorProp(interiorid, "set_vault_door_lockedxd") -- Locked vault door
	EnableInteriorProp(interiorid, "set_vault_door_broken") -- Vault door exloded/broken
	EnableInteriorProp(interiorid, "set_vault_wall_damagedxd") -- Vault wall damaged
	-- always refresh the interior or they won't appear
	RefreshInterior(interiorid)

	--?Galaxy Nightclub
	local int_id = GetInteriorAtCoords(345.4899597168,294.95315551758,98.191421508789)

	if IsValidInterior(interiorID) then
		EnableInteriorProp(int_id , "Int01_ba_security_upgrade")
		EnableInteriorProp(int_id , "Int01_ba_equipment_setup")
		DisableInteriorProp(int_id , "Int01_ba_Style01") -- дешовый
		DisableInteriorProp(int_id , "Int01_ba_Style02") -- средний
		EnableInteriorProp(int_id , "Int01_ba_Style03") -- дорогой
		DisableInteriorProp(int_id , "Int01_ba_style01_podium") -- дешовый
		DisableInteriorProp(int_id , "Int01_ba_style02_podium") -- средний
		EnableInteriorProp(int_id , "Int01_ba_style03_podium") -- дорогой
		EnableInteriorProp(int_id , "int01_ba_lights_screen")
		EnableInteriorProp(int_id , "Int01_ba_Screen")
		EnableInteriorProp(int_id , "Int01_ba_bar_content")
		DisableInteriorProp(int_id , "Int01_ba_booze_01") --мусор после вечеринки
		DisableInteriorProp(int_id , "Int01_ba_booze_02") --мусор после вечеринки
		DisableInteriorProp(int_id , "Int01_ba_booze_03") --мусор после вечеринки
		DisableInteriorProp(int_id , "Int01_ba_dj01")
		DisableInteriorProp(int_id , "Int01_ba_dj02")
		EnableInteriorProp(int_id , "Int01_ba_dj03")
		DisableInteriorProp(int_id , "Int01_ba_dj04")

		EnableInteriorProp(int_id , "DJ_01_Lights_01")
		DisableInteriorProp(int_id , "DJ_01_Lights_02")
		DisableInteriorProp(int_id , "DJ_01_Lights_03")
		DisableInteriorProp(int_id , "DJ_01_Lights_04")

		DisableInteriorProp(int_id , "DJ_02_Lights_01")
		EnableInteriorProp(int_id , "DJ_02_Lights_02")
		DisableInteriorProp(int_id , "DJ_02_Lights_03")
		DisableInteriorProp(int_id , "DJ_02_Lights_04")

		DisableInteriorProp(int_id , "DJ_03_Lights_01")
		DisableInteriorProp(int_id , "DJ_03_Lights_02")
		EnableInteriorProp(int_id , "DJ_03_Lights_03")
		DisableInteriorProp(int_id , "DJ_03_Lights_04")

		DisableInteriorProp(int_id , "DJ_04_Lights_01")
		DisableInteriorProp(int_id , "DJ_04_Lights_02")
		DisableInteriorProp(int_id , "DJ_04_Lights_03")
		EnableInteriorProp(int_id , "DJ_04_Lights_04")

		DisableInteriorProp(int_id , "light_rigs_off")
		EnableInteriorProp(int_id , "Int01_ba_lightgrid_01")
		DisableInteriorProp(int_id , "Int01_ba_Clutter")
		EnableInteriorProp(int_id , "Int01_ba_equipment_upgrade")
		EnableInteriorProp(int_id , "Int01_ba_clubname_01") -- galaxy
		DisableInteriorProp(int_id , "Int01_ba_clubname_02") --studio
		DisableInteriorProp(int_id , "Int01_ba_clubname_03") --omega
		DisableInteriorProp(int_id , "Int01_ba_clubname_04") --tehnology
		DisableInteriorProp(int_id , "Int01_ba_clubname_05") --gefangnis
		DisableInteriorProp(int_id , "Int01_ba_clubname_06") --maisonnette
		DisableInteriorProp(int_id , "Int01_ba_clubname_07") -- tony 
		DisableInteriorProp(int_id , "Int01_ba_clubname_08") -- the palace
		DisableInteriorProp(int_id , "Int01_ba_clubname_09") -- paradise

		EnableInteriorProp(int_id , "Int01_ba_dry_ice")
		DisableInteriorProp(int_id , "Int01_ba_deliverytruck")
		DisableInteriorProp(int_id , "Int01_ba_trophy04")
		DisableInteriorProp(int_id , "Int01_ba_trophy05")
		DisableInteriorProp(int_id , "Int01_ba_trophy07")
		DisableInteriorProp(int_id , "Int01_ba_trophy09")
		DisableInteriorProp(int_id , "Int01_ba_trophy08")
		DisableInteriorProp(int_id , "Int01_ba_trophy11")
		DisableInteriorProp(int_id , "Int01_ba_trophy10")
		DisableInteriorProp(int_id , "Int01_ba_trophy03")
		DisableInteriorProp(int_id , "Int01_ba_trophy01")
		DisableInteriorProp(int_id , "Int01_ba_trophy02")
		DisableInteriorProp(int_id , "Int01_ba_trad_lights")
		DisableInteriorProp(int_id , "Int01_ba_Worklamps") -- работа
		RefreshInterior(int_id)
	end
end)

--==============================================================
--НАСТРОЙКИ НАХОДЯТ В САМОМ НИЗУ СКРИПТА / SETTINGS ARE LOWEST SCRIPT
--==============================================================

--============================ НЕ ТРОГАТЬ / DO NOT TOUCH ==================================
-- upgrade
EnableInteriorProp(int_id , "Int01_ba_security_upgrade")
EnableInteriorProp(int_id , "Int01_ba_equipment_setup")
DisableInteriorProp(int_id , "Int01_ba_Style01") -- дешовый
DisableInteriorProp(int_id , "Int01_ba_Style02") -- средний
EnableInteriorProp(int_id , "Int01_ba_Style03") -- дорогой
DisableInteriorProp(int_id , "Int01_ba_style01_podium") -- дешовый
DisableInteriorProp(int_id , "Int01_ba_style02_podium") -- средний
EnableInteriorProp(int_id , "Int01_ba_style03_podium") -- дорогой
EnableInteriorProp(int_id , "int01_ba_lights_screen")
EnableInteriorProp(int_id , "Int01_ba_Screen")
EnableInteriorProp(int_id , "Int01_ba_bar_content")
DisableInteriorProp(int_id , "Int01_ba_booze_01") --мусор после вечеринки
DisableInteriorProp(int_id , "Int01_ba_booze_02") --мусор после вечеринки
DisableInteriorProp(int_id , "Int01_ba_booze_03") --мусор после вечеринки
DisableInteriorProp(int_id , "Int01_ba_dj01")
DisableInteriorProp(int_id , "Int01_ba_dj02")
EnableInteriorProp(int_id , "Int01_ba_dj03")
DisableInteriorProp(int_id , "Int01_ba_dj04")

EnableInteriorProp(int_id , "DJ_01_Lights_01")
DisableInteriorProp(int_id , "DJ_01_Lights_02")
DisableInteriorProp(int_id , "DJ_01_Lights_03")
DisableInteriorProp(int_id , "DJ_01_Lights_04")

DisableInteriorProp(int_id , "DJ_02_Lights_01")
EnableInteriorProp(int_id , "DJ_02_Lights_02")
DisableInteriorProp(int_id , "DJ_02_Lights_03")
DisableInteriorProp(int_id , "DJ_02_Lights_04")

DisableInteriorProp(int_id , "DJ_03_Lights_01")
DisableInteriorProp(int_id , "DJ_03_Lights_02")
EnableInteriorProp(int_id , "DJ_03_Lights_03")
DisableInteriorProp(int_id , "DJ_03_Lights_04")

DisableInteriorProp(int_id , "DJ_04_Lights_01")
DisableInteriorProp(int_id , "DJ_04_Lights_02")
DisableInteriorProp(int_id , "DJ_04_Lights_03")
EnableInteriorProp(int_id , "DJ_04_Lights_04")

DisableInteriorProp(int_id , "light_rigs_off")
EnableInteriorProp(int_id , "Int01_ba_lightgrid_01")
DisableInteriorProp(int_id , "Int01_ba_Clutter")
EnableInteriorProp(int_id , "Int01_ba_equipment_upgrade")
EnableInteriorProp(int_id , "Int01_ba_clubname_01") -- galaxy
DisableInteriorProp(int_id , "Int01_ba_clubname_02") --studio
DisableInteriorProp(int_id , "Int01_ba_clubname_03") --omega
DisableInteriorProp(int_id , "Int01_ba_clubname_04") --tehnology
DisableInteriorProp(int_id , "Int01_ba_clubname_05") --gefangnis
DisableInteriorProp(int_id , "Int01_ba_clubname_06") --maisonnette
DisableInteriorProp(int_id , "Int01_ba_clubname_07") -- tony 
DisableInteriorProp(int_id , "Int01_ba_clubname_08") -- the palace
DisableInteriorProp(int_id , "Int01_ba_clubname_09") -- paradise

EnableInteriorProp(int_id , "Int01_ba_dry_ice")
DisableInteriorProp(int_id , "Int01_ba_deliverytruck")
DisableInteriorProp(int_id , "Int01_ba_trophy04")
DisableInteriorProp(int_id , "Int01_ba_trophy05")
DisableInteriorProp(int_id , "Int01_ba_trophy07")
DisableInteriorProp(int_id , "Int01_ba_trophy09")
DisableInteriorProp(int_id , "Int01_ba_trophy08")
DisableInteriorProp(int_id , "Int01_ba_trophy11")
DisableInteriorProp(int_id , "Int01_ba_trophy10")
DisableInteriorProp(int_id , "Int01_ba_trophy03")
DisableInteriorProp(int_id , "Int01_ba_trophy01")
DisableInteriorProp(int_id , "Int01_ba_trophy02")
DisableInteriorProp(int_id , "Int01_ba_trad_lights")
DisableInteriorProp(int_id , "Int01_ba_Worklamps") -- работа
RefreshInterior(int_id )
