
-- this module define some police tools and functions
local lang = HVC.lang
local cfg = module("cfg/police")

-- police records

-- insert a police record for a specific user
--- line: text for one line (can be html)
function HVC.insertPoliceRecord(user_id, line)
  if user_id ~= nil then
    HVC.getUData(user_id, "HVC:police_records", function(data)
      local records = data..line.."<br />"
      HVC.setUData(user_id, "HVC:police_records", records)
    end)
  end
end

-- Hotkey Open Police PC 1/2
function HVC.openPolicePC(source)
  HVC.buildMenu("police_pc", {player = source}, function(menudata)
    menudata.name = "Police PC"
    menudata.css = {top="75px",header_color="rgba(0,125,255,0.75)"}
    HVC.openMenu(source,menudata)
  end)
end

-- Hotkey Open Police PC 2/2
function tHVC.openPolicePC()
  HVC.openPolicePC(source)
end

-- Hotkey Open Police Menu 1/2
function HVC.openPoliceMenu(source)
  HVC.buildMenu("police", {player = source}, function(menudata)
    menudata.name = "Police"
    menudata.css = {top="75px",header_color="rgba(0,125,255,0.75)"}
    HVC.openMenu(source,menudata)
  end)
end

-- Hotkey Open Police Menu 2/2
function tHVC.openPoliceMenu()
  HVC.openPoliceMenu(source)
end

-- police PC

local menu_pc = {name=lang.police.pc.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

-- search identity by registration
local function ch_searchreg(player,choice)
  HVC.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    HVC.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        HVC.getUserIdentity(user_id, function(identity)
          if identity then
            -- display identity and business
            local name = identity.name
            local firstname = identity.firstname
            local age = identity.age
            local phone = identity.phone
            local registration = identity.registration
            local bname = ""
            local bcapital = 0
            local home = ""
            local number = ""

            HVC.getUserBusiness(user_id, function(business)
              if business then
                bname = business.name
                bcapital = business.capital
              end

              HVC.getUserAddress(user_id, function(address)
                if address then
                  home = address.home
                  number = address.number
                end

                local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number})
                HVCclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
              end)
            end)
          else
            HVCclient.notify(player,{lang.common.not_found()})
          end
        end)
      else
        HVCclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- show police records by registration
local function ch_show_police_records(player,choice)
  HVC.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    HVC.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        HVC.getUData(user_id, "HVC:police_records", function(content)
          HVCclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
        end)
      else
        HVCclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- delete police records by registration
local function ch_delete_police_records(player,choice)
  HVC.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    HVC.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        HVC.setUData(user_id, "HVC:police_records", "")
        HVCclient.notify(player,{lang.police.pc.records.delete.deleted()})
      else
        HVCclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- close business of an arrested owner
local function ch_closebusiness(player,choice)
  HVCclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = HVC.getUserId(nplayer)
    if nuser_id ~= nil then
      HVC.getUserIdentity(nuser_id, function(identity)
        HVC.getUserBusiness(nuser_id, function(business)
          if identity and business then
            HVC.request(player,lang.police.pc.closebusiness.request({identity.name,identity.firstname,business.name}),15,function(player,ok)
              if ok then
                HVC.closeBusiness(nuser_id)
                HVCclient.notify(player,{lang.police.pc.closebusiness.closed()})
              end
            end)
          else
            HVCclient.notify(player,{lang.common.no_player_near()})
          end
        end)
      end)
    else
      HVCclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end

-- track vehicle
local function ch_trackveh(player,choice)
  HVC.prompt(player,lang.police.pc.trackveh.prompt_reg(),"",function(player, reg) -- ask reg
    HVC.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        HVC.prompt(player,lang.police.pc.trackveh.prompt_note(),"",function(player, note) -- ask note
          -- begin veh tracking
          HVCclient.notify(player,{lang.police.pc.trackveh.tracking()})
          local seconds = math.random(cfg.trackveh.min_time,cfg.trackveh.max_time)
          SetTimeout(seconds*1000,function()
            local tplayer = HVC.getUserSource(user_id)
            if tplayer ~= nil then
              HVCclient.getAnyOwnedVehiclePosition(tplayer,{},function(ok,x,y,z)
                if ok then -- track success
                  HVC.sendServiceAlert(nil, cfg.trackveh.service,x,y,z,lang.police.pc.trackveh.tracked({reg,note}))
                else
                  HVCclient.notify(player,{lang.police.pc.trackveh.track_failed({reg,note})}) -- failed
                end
              end)
            else
              HVCclient.notify(player,{lang.police.pc.trackveh.track_failed({reg,note})}) -- failed
            end
          end)
        end)
      else
        HVCclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

menu_pc[lang.police.pc.searchreg.title()] = {ch_searchreg,lang.police.pc.searchreg.description()}
menu_pc[lang.police.pc.trackveh.title()] = {ch_trackveh,lang.police.pc.trackveh.description()}
menu_pc[lang.police.pc.records.show.title()] = {ch_show_police_records,lang.police.pc.records.show.description()}
menu_pc[lang.police.pc.records.delete.title()] = {ch_delete_police_records, lang.police.pc.records.delete.description()}
menu_pc[lang.police.pc.closebusiness.title()] = {ch_closebusiness,lang.police.pc.closebusiness.description()}

menu_pc.onclose = function(player) -- close pc gui
  HVCclient.removeDiv(player,{"police_pc"})
end

local function pc_enter(source,area)
  local user_id = HVC.getUserId(source)
  if user_id ~= nil and HVC.hasPermission(user_id,"police.pc") then
    HVC.openMenu(source,menu_pc)
  end
end

local function pc_leave(source,area)
  HVC.closeMenu(source)
end

-- main menu choices

---- handcuff
local choice_handcuff = {function(player,choice)
  HVCclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = HVC.getUserId(nplayer)
    if nuser_id ~= nil then
      HVCclient.toggleHandcuff(nplayer,{})
    else
      HVCclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.handcuff.description()}

---- putinveh
--[[
-- veh at position version
local choice_putinveh = {function(player,choice)
  HVCclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = HVC.getUserId(nplayer)
    if nuser_id ~= nil then
      HVCclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          HVCclient.getNearestOwnedVehicle(player, {10}, function(ok,vtype,name) -- get nearest owned vehicle
            if ok then
              HVCclient.getOwnedVehiclePosition(player, {vtype}, function(x,y,z)
                HVCclient.putInVehiclePositionAsPassenger(nplayer,{x,y,z}) -- put player in vehicle
              end)
            else
              HVCclient.notify(player,{lang.vehicle.no_owned_near()})
            end
          end)
        else
          HVCclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      HVCclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.putinveh.description()}
--]]

local choice_putinveh = {function(player,choice)
  HVCclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = HVC.getUserId(nplayer)
    if nuser_id ~= nil then
      HVCclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          HVCclient.putInNearestVehicleAsPassenger(nplayer, {5})
        else
          HVCclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      HVCclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.putinveh.description()}

local choice_getoutveh = {function(player,choice)
  HVCclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = HVC.getUserId(nplayer)
    if nuser_id ~= nil then
      HVCclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          HVCclient.ejectVehicle(nplayer, {})
        else
          HVCclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      HVCclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.getoutveh.description()}

---- askid
local choice_askid = {function(player,choice)
  HVCclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = HVC.getUserId(nplayer)
    if nuser_id ~= nil then
      HVCclient.notify(player,{lang.police.menu.askid.asked()})
      HVC.request(nplayer,lang.police.menu.askid.request(),15,function(nplayer,ok)
        if ok then
          HVC.getUserIdentity(nuser_id, function(identity)
            if identity then
              -- display identity and business
              local name = identity.name
              local firstname = identity.firstname
              local age = identity.age
              local phone = identity.phone
              local registration = identity.registration
              local bname = ""
              local bcapital = 0
              local home = ""
              local number = ""

              HVC.getUserBusiness(nuser_id, function(business)
                if business then
                  bname = business.name
                  bcapital = business.capital
                end

                HVC.getUserAddress(nuser_id, function(address)
                  if address then
                    home = address.home
                    number = address.number
                  end

                  local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number})
                  HVCclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                  -- request to hide div
                  HVC.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                    HVCclient.removeDiv(player,{"police_identity"})
                  end)
                end)
              end)
            end
          end)
        else
          HVCclient.notify(player,{lang.common.request_refused()})
        end
      end)
    else
      HVCclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, lang.police.menu.askid.description()}

---- police check
local choice_check = {function(player,choice)
  HVCclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = HVC.getUserId(nplayer)
    if nuser_id ~= nil then
      HVCclient.notify(nplayer,{lang.police.menu.check.checked()})
      HVCclient.getWeapons(nplayer,{},function(weapons)
        -- prepare display data (money, items, weapons)
        local money = HVC.getMoney(nuser_id)
        local items = ""
        local data = HVC.getUserDataTable(nuser_id)
        if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item = HVC.items[k]
            if item then
              items = items.."<br />"..item.name.." ("..v.amount..")"
            end
          end
        end

        local weapons_info = ""
        for k,v in pairs(weapons) do
          weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
        end

        HVCclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
        -- request to hide div
        HVC.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
          HVCclient.removeDiv(player,{"police_check"})
        end)
      end)
    else
      HVCclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, lang.police.menu.check.description()}

local choice_seize_weapons = {function(player, choice)
  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    HVCclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = HVC.getUserId(nplayer)
      if nuser_id ~= nil and HVC.hasPermission(nuser_id, "police.seizable") then
        HVCclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            HVCclient.getWeapons(nplayer,{},function(weapons)
              for k,v in pairs(weapons) do -- display seized weapons
                -- HVCclient.notify(player,{lang.police.menu.seize.seized({k,v.ammo})})
                -- convert weapons to parametric weapon items
                HVC.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                if v.ammo > 0 then
                  local ammo222 = v.ammo
                  for i,v in pairs(HVCAmmoTypes) do
                    for a,d in pairs(v) do
                        if d == k then  
                            HVC.giveInventoryItem(user_id, i, ammo222, true)
                        end
                    end   
                  end
                end
              end

              -- clear all weapons
              HVCclient.giveWeapons(nplayer,{{},true})
              HVCclient.notify(nplayer,{lang.police.menu.seize.weapons.seized()})
            end)
          else
            HVCclient.notify(player,{lang.police.not_handcuffed()})
          end
        end)
      else
        HVCclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize.weapons.description()}

local choice_seize_items = {function(player, choice)
  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    HVCclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = HVC.getUserId(nplayer)
      if nuser_id ~= nil and HVC.hasPermission(nuser_id, "police.seizable") then
        HVCclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            for k,v in pairs(cfg.seizable_items) do -- transfer seizable items
              local amount = HVC.getInventoryItemAmount(nuser_id,v)
              if amount > 0 then
                local item = HVC.items[v]
                if item then -- do transfer
                  if HVC.tryGetInventoryItem(nuser_id,v,amount,true) then
                    HVC.giveInventoryItem(user_id,v,amount,false)
                    HVCclient.notify(player,{lang.police.menu.seize.seized({item.name,amount})})
                  end
                end
              end
            end

            HVCclient.notify(nplayer,{lang.police.menu.seize.items.seized()})
          else
            HVCclient.notify(player,{lang.police.not_handcuffed()})
          end
        end)
      else
        HVCclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize.items.description()}

-- toggle jail nearest player
local choice_jail = {function(player, choice)
  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    HVCclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = HVC.getUserId(nplayer)
      if nuser_id ~= nil then
        HVCclient.isJailed(nplayer, {}, function(jailed)
          if jailed then -- unjail
            HVCclient.unjail(nplayer, {})
            HVCclient.notify(nplayer,{lang.police.menu.jail.notify_unjailed()})
            HVCclient.notify(player,{lang.police.menu.jail.unjailed()})
          else -- find the nearest jail
            HVCclient.getPosition(nplayer,{},function(x,y,z)
              local d_min = 1000
              local v_min = nil
              for k,v in pairs(cfg.jails) do
                local dx,dy,dz = x-v[1],y-v[2],z-v[3]
                local dist = math.sqrt(dx*dx+dy*dy+dz*dz)

                if dist <= d_min and dist <= 15 then -- limit the research to 15 meters
                  d_min = dist
                  v_min = v
                end

                -- jail
                if v_min then
                  HVCclient.jail(nplayer,{v_min[1],v_min[2],v_min[3],v_min[4]})
                  HVCclient.notify(nplayer,{lang.police.menu.jail.notify_jailed()})
                  HVCclient.notify(player,{lang.police.menu.jail.jailed()})
                else
                  HVCclient.notify(player,{lang.police.menu.jail.not_found()})
                end
              end
            end)
          end
        end)
      else
        HVCclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.jail.description()}

local choice_fine = {function(player, choice)
  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    HVCclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = HVC.getUserId(nplayer)
      if nuser_id ~= nil then
        local money = HVC.getMoney(nuser_id)+HVC.getBankMoney(nuser_id)

        -- build fine menu
        local menu = {name=lang.police.menu.fine.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

        local choose = function(player,choice) -- fine action
          local amount = cfg.fines[choice]
          if amount ~= nil then
            if HVC.tryFullPayment(nuser_id, amount) then
              HVC.insertPoliceRecord(nuser_id, lang.police.menu.fine.record({choice,amount}))
              HVCclient.notify(player,{lang.police.menu.fine.fined({choice,amount})})
              HVCclient.notify(nplayer,{lang.police.menu.fine.notify_fined({choice,amount})})
              HVC.closeMenu(player)
            else
              HVCclient.notify(player,{lang.money.not_enough()})
            end
          end
        end

        for k,v in pairs(cfg.fines) do -- add fines in function of money available
          if v <= money then
            menu[k] = {choose,v}
          end
        end

        -- open menu
        HVC.openMenu(player, menu)
      else
        HVCclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.fine.description()}

local isStoring = {}
local choice_store_weapons = function(player, choice)
  local user_id = HVC.getUserId(player)
	HVCclient.getWeapons(player,{},function(weapons)
    if not isStoring[player] then
      isStoring[player] = true
      HVCclient.giveWeapons(player,{{},true}, function(removedwep)
        HVCclient.SaveWeapons(player, {}, function(saved)
          if removedwep and saved then
            for k,v in pairs(weapons) do
              HVC.giveInventoryItem(user_id, "wbody|"..k, 1, true)
              HVCclient.ClearWeapons(player)
              if v.ammo > 0 then
                local ammo222 = v.ammo
                for i,v in pairs(HVCAmmoTypes) do
                  for a,d in pairs(v) do
                    if d == k then  
                      HVC.giveInventoryItem(user_id, i, ammo222, true)
                    end
                  end   
                end
              end
            end
            HVCclient.notify(player,{"~g~Weapons stored!"})
            SetTimeout(10000,function()
            isStoring[player] = nil 
            end)
          end
        end)
      end)
    else
      HVCclient.notify(player,{"~o~You are already storing the weapons!"})
    end
	end)
end

-- add choices to the menu
HVC.registerMenuBuilder("main", function(add, data)
  local player = data.player

  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    local choices = {}

    if HVC.hasPermission(user_id,"police.menu") then
      -- build police menu
      choices[lang.police.title()] = {function(player,choice)
        HVC.buildMenu("police", {player = player}, function(menu)
          menu.name = lang.police.title()
          menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}

          if HVC.hasPermission(user_id,"police.handcuff") then
            menu[lang.police.menu.handcuff.title()] = choice_handcuff
          end

          if HVC.hasPermission(user_id,"police.putinveh") then
            menu[lang.police.menu.putinveh.title()] = choice_putinveh
          end

          if HVC.hasPermission(user_id,"police.getoutveh") then
            menu[lang.police.menu.getoutveh.title()] = choice_getoutveh
          end

          if HVC.hasPermission(user_id,"police.check") then
            menu[lang.police.menu.check.title()] = choice_check
          end

          if HVC.hasPermission(user_id,"police.seize.weapons") then
            menu[lang.police.menu.seize.weapons.title()] = choice_seize_weapons
          end

          if HVC.hasPermission(user_id,"police.seize.items") then
            menu[lang.police.menu.seize.items.title()] = choice_seize_items
          end

          if HVC.hasPermission(user_id,"police.jail") then
            menu[lang.police.menu.jail.title()] = choice_jail
          end

          if HVC.hasPermission(user_id,"police.fine") then
            menu[lang.police.menu.fine.title()] = choice_fine
          end

          HVC.openMenu(player,menu)
        end)
      end}
    end

    if HVC.hasPermission(user_id,"police.askid") then
      choices[lang.police.menu.askid.title()] = choice_askid
    end

    if HVC.hasPermission(user_id, "police.store_weapons") then
      choices[lang.police.menu.store_weapons.title()] = choice_store_weapons
    end

    add(choices)
  end
end)

local function build_client_points(source)
  -- PC
  for k,v in pairs(cfg.pcs) do
    local x,y,z = table.unpack(v)
    HVCclient.addMarker(source,{x,y,z-1,0.7,0.7,0.5,0,125,255,125,150})
    HVC.setArea(source,"HVC:police:pc"..k,x,y,z,1,1.5,pc_enter,pc_leave)
  end
end

-- build police points
AddEventHandler("HVC:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    build_client_points(source)
  end
end)

-- WANTED SYNC

local wantedlvl_players = {}

function HVC.getUserWantedLevel(user_id)
  return wantedlvl_players[user_id] or 0
end

-- receive wanted level
function tHVC.updateWantedLevel(level)
  local player = source
  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    local was_wanted = (HVC.getUserWantedLevel(user_id) > 0)
    wantedlvl_players[user_id] = level
    local is_wanted = (level > 0)

    -- send wanted to listening service
    if not was_wanted and is_wanted then
      HVCclient.getPosition(player, {}, function(x,y,z)
        HVC.sendServiceAlert(nil, cfg.wanted.service,x,y,z,lang.police.wanted({level}))
      end)
    end

    if was_wanted and not is_wanted then
      HVCclient.removeNamedBlip(-1, {"HVC:wanted:"..user_id}) -- remove wanted blip (all to prevent phantom blip)
    end
  end
end

-- delete wanted entry on leave
AddEventHandler("HVC:playerLeave", function(user_id, player)
  wantedlvl_players[user_id] = nil
  HVCclient.removeNamedBlip(-1, {"HVC:wanted:"..user_id})  -- remove wanted blip (all to prevent phantom blip)
end)

-- display wanted positions
local function task_wanted_positions()
  local listeners = HVC.getUsersByPermission("police.wanted")
  for k,v in pairs(wantedlvl_players) do -- each wanted player
    local player = HVC.getUserSource(tonumber(k))
    if player ~= nil and v ~= nil and v > 0 then
      HVCclient.getPosition(player, {}, function(x,y,z)
        for l,w in pairs(listeners) do -- each listening player
          local lplayer = HVC.getUserSource(w)
          if lplayer ~= nil then
            HVCclient.setNamedBlip(lplayer, {"HVC:wanted:"..k,x,y,z,cfg.wanted.blipid,cfg.wanted.blipcolor,lang.police.wanted({v})})
          end
        end
      end)
    end
  end

  SetTimeout(5000, task_wanted_positions)
end
task_wanted_positions()




RegisterServerEvent("HVC:AskID")
AddEventHandler("HVC:AskID", function()
  --choice_askid()
  local player = source
  HVCclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = HVC.getUserId(nplayer)
    if nuser_id ~= nil then
      HVCclient.notify(player,{lang.police.menu.askid.asked()})
      HVC.request(nplayer,lang.police.menu.askid.request(),15,function(nplayer,ok)
        if ok then
          HVC.getUserIdentity(nuser_id, function(identity)
            if identity then
              -- display identity and business
              local name = identity.name
              local firstname = identity.firstname
              local age = identity.age
              local phone = identity.phone
              local registration = identity.registration
              local bname = ""
              local bcapital = 0
              local home = ""
              local number = ""

              HVC.getUserBusiness(nuser_id, function(business)
                if business then
                  bname = business.name
                  bcapital = business.capital
                end

                HVC.getUserAddress(nuser_id, function(address)
                  if address then
                    home = address.home
                    number = address.number
                  end

                  local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number})
                  HVCclient.setDiv2(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                  -- request to hide div
                  HVC.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                    HVCclient.removeDiv(player,{"police_identity"})
                  end)
                end)
              end)
            end
          end)
        else
          HVCclient.notify(player,{lang.common.request_refused()})
        end
      end)
    else
      HVCclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end)


RegisterServerEvent('HVC:SeizeItems')
AddEventHandler('HVC:SeizeItems', function()
  local player = source
  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    HVCclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = HVC.getUserId(nplayer)
      if nuser_id ~= nil and HVC.hasPermission(nuser_id, "police.seizable") then
        HVCclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            for k,v in pairs(cfg.seizable_items) do -- transfer seizable items
              local amount = HVC.getInventoryItemAmount(nuser_id,v)
              HVC.clearInventory(nuser_id) 
              if amount > 0 then
                local item = HVC.items[v]
                if item then -- do transfer
                  if HVC.tryGetInventoryItem(nuser_id,v,amount,true) then
                    HVC.giveInventoryItem(user_id,v,amount,false)
                    HVCclient.notify(player,{"~b~Seized Players Weapons"})
                    HVCclient.notify(nplayer,{"~b~Your Items Have Been Seized"})
                  end
                end
              end
            end

            HVCclient.notify(nplayer,{lang.police.menu.seize.items.seized()})
          else
            HVCclient.notify(player,{lang.police.not_handcuffed()})
          end
        end)
      else
        HVCclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end)