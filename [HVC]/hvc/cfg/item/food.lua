-- define some basic inventory items

local items = {}

local function play_eat(player)
  local seq = {
    {"mp_player_inteat@burger", "mp_player_int_eat_burger_enter",1},
    {"mp_player_inteat@burger", "mp_player_int_eat_burger",1},
    {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp",1},
    {"mp_player_inteat@burger", "mp_player_int_eat_exit_burger",1}
  }

  HVCclient.playAnim(player,{true,seq,false})
end

local function play_drink(player)
  local seq = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",1},
    {"mp_player_intdrink","outro_bottle",1}
  }

  HVCclient.playAnim(player,{true,seq,false})
end

-- gen food choices as genfunc
-- idname
-- ftype: eat or drink
-- vary_hunger
-- vary_thirst
local function gen(ftype, vary_hunger, vary_thirst)
  local fgen = function(args)
    local idname = args[1]
    local choices = {}
    local act = "Unknown"
    if ftype == "eat" then act = "Eat" elseif ftype == "drink" then act = "Drink" end
    local name = HVC.getItemName(idname)

    choices[act] = {function(player,choice)
      local user_id = HVC.getUserId(player)
      if user_id ~= nil then
        if HVC.tryGetInventoryItem(user_id,idname,1,false) then
          if vary_hunger ~= 0 then HVC.varyHunger(user_id,vary_hunger) end
          if vary_thirst ~= 0 then HVC.varyThirst(user_id,vary_thirst) end

          if ftype == "drink" then
            HVCclient.notify(player,{"~b~ Drinking "..name.."."})
            play_drink(player)
          elseif ftype == "eat" then
            HVCclient.notify(player,{"~o~ Eating "..name.."."})
            play_eat(player)
          end

          HVC.closeMenu(player)
        end
      end
    end}

    return choices
  end

  return fgen
end

-- DRINKS --

items["water"] = {"Water","", gen("drink",0,-25),0.5}
items["milk"] = {"Milk","", gen("drink",0,-5),0.5}
items["coffee"] = {"Coffee","", gen("drink",0,-10),0.2}
items["tea"] = {"Tea","", gen("drink",0,-15),0.2}
items["icetea"] = {"Ice-Tea","", gen("drink",0,-20), 0.5}
items["orangejuice"] = {"Orange Juice","", gen("drink",0,-25),0.5}
items["cocacola"] = {"Coca Cola","", gen("drink",0,-35),0.3}
items["redbull"] = {"Red Bull","", gen("drink",0,-40),0.3}
items["lemonade"] = {"Lemonade","", gen("drink",0,-45),0.3}
items["vodka"] = {"Vodka","", gen("drink",15,-65),0.5}

--FOOD

-- create Breed item
items["bread"] = {"Bread","", gen("eat",-10,0),0.5}
items["donut"] = {"Donut","", gen("eat",-15,0),0.2}
items["tacos"] = {"Tacos","", gen("eat",-20,0),0.2}
items["sandwich"] = {"Sandwich","A tasty snack.", gen("eat",-25,0),0.5}
items["kebab"] = {"Kebab","", gen("eat",-45,0),0.85}
items["pdonut"] = {"Premium Donut","", gen("eat",-25,0),0.5}
items["catfish"] = {"Catfish","", gen("eat",10,15),0.3}
items["bass"] = {"Bass","", gen("eat",10,15),0.3}

return items
