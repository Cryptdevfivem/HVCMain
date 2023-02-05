
local items = {}

items["medkit"] = {"Medical Kit","Used to reanimate unconscious people.",nil,0.5}
items["dirty_money"] = {"Dirty money","Illegally earned money.",nil,0}
items["parcels"] = {"Parcels","Parcels to deliver",nil,0.10}
items["repairkit"] = {"Repair Kit","Used to repair vehicles.",nil,0.5}

items["greencard"] = {"Green Keycard","Used to open special crates",nil,1.0}
items["bluecard"] = {"Blue Keycard","Used to open special crates",nil,1.0}
items["hackerlaptop"] = {"Hacker Laptop","Used to open special crates",nil,2.0}
items["crateflare"] = {"Crate Flare","Used to create crate spawnpoint",nil,2.5}


-- money
items["money"] = {"Money","Packed money.",function(args)
  local choices = {}
  local idname = args[1]

  choices["Unpack"] = {function(player,choice,mod)
    local user_id = HVC.getUserId(player)
    if user_id ~= nil then
      local amount = HVC.getInventoryItemAmount(user_id, idname)
      HVC.prompt(player, "How much to unpack ? (max "..amount..")", "", function(player,ramount)
        ramount = parseInt(ramount)
        if HVC.tryGetInventoryItem(user_id, idname, ramount, true) then -- unpack the money
          HVC.giveMoney(user_id, ramount)
          HVC.closeMenu(player)
        end
      end)
    end
  end}

  return choices
end,0}

-- money binder
items["money_binder"] = {"Money binder","Used to bind 1000$ of money.",function(args)
  local choices = {}
  local idname = args[1]
  choices["Bind money"] = {function(player,choice,mod) -- bind the money
    local user_id = HVC.getUserId(player)
    if user_id ~= nil then
      local money = HVC.getMoney(user_id)
      if money >= 1000 then
        if HVC.tryGetInventoryItem(user_id, idname, 1, true) and HVC.tryPayment(user_id,1000) then
          HVC.giveInventoryItem(user_id, "money", 1000, true)
          HVC.closeMenu(player)
        end
      else
        HVCclient.notify(player,{HVC.lang.money.not_enough()})
      end
    end
  end}

  return choices
end,0}


items["stimshot"] = {"Stim Shot","Used to heal up a likkle yk!",function(args)
  local choices = {}
  local idname = args[1]
  choices["Equip"] = {function(player,choice)
    local user_id = HVC.getUserId(player)
    if user_id ~= nil then
      Health = GetEntityHealth(GetPlayerPed(player))
      if GetEntityHealth(GetPlayerPed(player)) < 180 then
        if HVC.tryGetInventoryItem(user_id, idname, 1, false) then
          HVCclient.notify(player,{"~g~Injected 1 Stim Shot"}) 
          Heal = true
          HVCclient.setEffectMeds(player)
          TriggerEvent("HVC:ProvideHealth", player, GetEntityHealth(GetPlayerPed(player)) + math.random(35, 55))
        end
      else
        HVCclient.notify(player,{"~g~Your healthy."})
      end
    end
  end}
  return choices
end,1.00}

local armour_seq = {{"oddjobs@basejump@ig_15","puton_parachute", 1}} --Armour Seq
local Cooldown = {}
items["lightarmour"] = {"Light Armour Plate","Armour",function(args)
  local choices = {}
  choices['Equip'] = {function(player,choice)
    local PermID = HVC.getUserId(player)
    local Ped = GetPlayerPed(player)
    local PedArmour = GetPedArmour(Ped)
    if Cooldown[player] then
      return HVCclient.notify(player,{"~r~Server is still proccesing your request, if you see this message within 60s please contact a developer."})
    else
      if PermID ~= nil then
        if PedArmour > 45 then
          HVCclient.notify(player,{"~r~You already have armour."})
        else
          if HVC.hasPermission(PermID, "rebel.license") then
            if HVC.tryGetInventoryItem(PermID, "lightarmour", 1, false) then
              Cooldown[player] = true;
              HVCclient.playAnim(player, {false, armour_seq, false}) -- anim
              Wait(2500)
              TriggerEvent("HVC:ProvideArmour", player, 50)
              HVCclient.notify(player,{"~g~Applied Light Armour"})
              Cooldown[player] = false;
            end
          else
            HVCclient.notify(player,{"~r~Missing Rebel License."})
          end
        end
      end
    end
  end}
  return choices
end,5}

items["heavyarmour"] = {"Heavy Armour Plate","Armour",function(args)
  local choices = {}
  choices['Equip'] = {function(player,choice)
    local PermID = HVC.getUserId(player)
    local Ped = GetPlayerPed(player)
    local PedArmour = GetPedArmour(Ped)
    if Cooldown[player] then
      return HVCclient.notify(player,{"~r~Server is still proccesing your request, if you see this message within 60s please contact a developer."})
    else
      if PermID ~= nil then
        if PedArmour == 100 then
          HVCclient.notify(player,{"~r~You already have a armour plate equipped."})
        else
          if HVC.hasPermission(PermID, "rebel.license") then
            if HVC.tryGetInventoryItem(PermID, "heavyarmour", 1, false) then
              Cooldown[player] = true;
              HVCclient.playAnim(player, {false, armour_seq, false}) -- anim
              Wait(2500)
              TriggerEvent("HVC:ProvideArmour", player, 100)
              HVCclient.notify(player,{"~g~Applied Heavy Armour"})
              Cooldown[player] = false;
            end
          else
            HVCclient.notify(player,{"~r~Missing Rebel License."})
          end
        end
      end
    end
  end}
  return choices
end,10}

items["paracetamol"] = {"Paracetamol","human",function(args)
  local choices = {}
  local idname = args[1]
  choices["Equip"] = {function(player,choice)
    local user_id = HVC.getUserId(player)
    if user_id ~= nil then
      Health = GetEntityHealth(GetPlayerPed(player))
      if GetEntityHealth(GetPlayerPed(player)) < 175 then
        if HVC.tryGetInventoryItem(user_id, idname, 1, false) then
          HVCclient.notify(player,{"~g~Taken 1 Paracetamol"}) 
          Heal = true
          HVCclient.setEffectMeds(player)
          TriggerEvent("HVC:ProvideHealth", player, GetEntityHealth(GetPlayerPed(player)) + math.random(25, 45))
        end
      else
        HVCclient.notify(player,{"~r~Cannot Take Paracetamol At This Moment."})
      end
    end
  end}
  return choices
end,1.00}


items["repairkit"] = {"Repair Kit","Used to repair a vehicle",function(args)
  local choices = {}
  local idname = args[1]

  choices["Equip"] = {function(player,choice) -- bind the money
    local user_id = HVC.getUserId(player)
    if user_id ~= nil then
      if HVC.tryGetInventoryItem(user_id,"repairkit",1,true) then
        HVCclient.playAnim(player,{false,{task="WORLD_HUMAN_WELDING"},false})
        SetTimeout(15000, function()
          HVCclient.fixeNearestVehicle(player,{7})
          HVCclient.stopAnim(player,{false})
        end)
      end
    end
  end}

  return choices
end,2.50}


--------------------------------------------------------------------------- Weapon Body Required ---------------------------------------------------------------------------


 
-- parametric weapon items
-- give "wbody|WEAPON_PISTOL" and "wammo|WEAPON_PISTOL" to have pistol body and pistol bullets


local get_wname = function(weapon_id)
  local name = string.gsub(weapon_id,"WEAPON_","")
  name = string.upper(string.sub(name,1,1))..string.lower(string.sub(name,2))
  return name
end

--- weapon body

local items_cfg = module("cfg/items")

local wbody_name = function(args)
  if items_cfg.items[args[1] .. "|" .. args[2]] then
    return items_cfg.items[args[1] .. "|" .. args[2]][1]
  else
    return get_wname(args[2]).." body"
  end
end



local wbody_desc = function(args)
  return ""
end

local wbody_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")

  choices["Equip"] = {function(player,choice)
    local user_id = HVC.getUserId(player)
    if user_id ~= nil then
      HVCclient.WeaponType(player, {args[2]}, function(var)
      HVCclient.GetWeaponTypes(player, {}, function(types)
        if types[var] then
          HVCclient.notify(player,{'~r~You can only equip one of this weapon type at a time!'})
        else
          if HVC.tryGetInventoryItem(user_id, fullidname, 1, true) then -- give weapon body
            local weapons = {}
            weapons[args[2]] = {ammo = 0}
            HVCclient.giveWeapons(player, {weapons})
            TriggerEvent('HVC:RefreshInventory', player)
           end
          end
        end)
      end)
    end
  end}
  return choices
end

local wbody_weight = function(args)
  if items_cfg.items[args[1] .. "|" .. args[2]] then
    return items_cfg.items[args[1] .. "|" .. args[2]][4]
  else
    return 0.75
  end
end

items["wbody"] = {wbody_name,wbody_desc,wbody_choices,wbody_weight}






--------------------------------------------------------------------------- Weapon Ammo Required ---------------------------------------------------------------------------








local wammo_name = function(args)
  return args[1]
end

local wammo_desc = function(args)
  return ""
end

local wammo_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")
  local ammotype = nil;
  ammotype = args[1]

  choices["Load"] = {function(player,choice)
    local user_id = HVC.getUserId(player)
    if user_id ~= nil then
      local amount = HVC.getInventoryItemAmount(user_id, fullidname)
      HVC.prompt(player, "Amount to load ? (max "..amount..")", "", function(player,ramount)
        ramount = parseInt(ramount)

        HVCclient.getWeapons(player, {}, function(uweapons)
            for i,v in pairs(HVCAmmoTypes[ammotype]) do
                if uweapons[v] ~= nil then -- check if the weapon is equiped
                    if HVC.tryGetInventoryItem(user_id, fullidname, ramount, true) then -- give weapon ammo
                      local weapons = {}
                      weapons[v] = {ammo = ramount}
                      HVCclient.giveWeapons(player, {weapons, false})
                      TriggerEvent("HVC:ProvideLegitAmmo", player)
                      HVC.closeMenu(player)
                      TriggerEvent('HVC:RefreshInventory', player)
                      return
                    end
                end
            end
            HVCclient.notify(player,{'~r~You do not have any guns that fit this ammo type.'})
        end)
      end)
    end
  end}

  return choices
end

local wammo_weight = function(args)
  return 0.01
end


for i,v in pairs(HVCAmmoTypes) do
  items[i] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}
end

items["wammo"] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}

return items
