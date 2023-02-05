
local items = {}

local function play_drink(player)
  local seq = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",1},
    {"mp_player_intdrink","outro_bottle",1}
  }

  HVCclient.playAnim(player,{true,seq,false})
end

local pills_choices = {}
pills_choices["Take"] = {function(player,choice)
  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    HVCclient.isInComa(player,{}, function(in_coma)    
        if not in_coma then
          if HVC.tryGetInventoryItem(user_id,"pills",1) then
            HVCclient.varyHealth(player,{25})
            HVCclient.notify(player,{"~g~ Taking pills."})
            play_drink(player)
            HVC.closeMenu(player)
          end
        end    
    end)
  end
end}

local function play_smoke(player)
  local seq2 = {
    {"mp_player_int_uppersmoke","mp_player_int_smoke_enter",1},
    {"mp_player_int_uppersmoke","mp_player_int_smoke",1},
    {"mp_player_int_uppersmoke","mp_player_int_smoke_exit",1}
  }

  HVCclient.playAnim(player,{true,seq2,false})
end

local smoke_choices = {}
smoke_choices["Take"] = {function(player,choice)
  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    if HVC.tryGetInventoryItem(user_id,"weed2",1) then
	  HVC.varyHunger(user_id,(20))
      HVCclient.notify(player,{"~g~ smoking weed."})
      play_smoke(player)
      HVC.closeMenu(player)
    end
  end
end}

local function play_smell(player)
  local seq3 = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",1},
    {"mp_player_intdrink","outro_bottle",1}
  }

  HVCclient.playAnim(player,{true,seq3,false})
end

local smell_choices = {}
smell_choices["Take"] = {function(player,choice)
  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    if HVC.tryGetInventoryItem(user_id,"coke2",1) then
	  HVC.varyThirst(user_id,(20))
      HVCclient.notify(player,{"~g~ smell cocaine."})
      play_smell(player)
      HVC.closeMenu(player)
    end
  end
end}

local function play_lsd(player)
  local seq4 = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",1},
    {"mp_player_intdrink","outro_bottle",1}
  }

  HVCclient.playAnim(player,{true,seq4,false})
end

local lsd_choices = {}
lsd_choices["Take"] = {function(player,choice)
  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    if HVC.tryGetInventoryItem(user_id,"lsd2",1) then
	  HVC.varyThirst(user_id,(20))
      HVCclient.notify(player,{"~g~ Taking lsd."})
      play_lsd(player)
      HVC.closeMenu(player)
    end
  end
end}

return items
