local htmlEntities = module("lib/htmlEntities")

local cfg = module("cfg/identity")
local lang = HVC.lang

local sanitizes = module("cfg/sanitizes")

-- this module describe the identity system

-- init sql


MySQL.createCommand("HVC/get_user_identity","SELECT * FROM hvc_user_identities WHERE user_id = @user_id")
MySQL.createCommand("HVC/init_user_identity","INSERT IGNORE INTO hvc_user_identities(user_id,registration,phone,firstname,name,age) VALUES(@user_id,@registration,@phone,@firstname,@name,@age)")
MySQL.createCommand("HVC/update_user_identity","UPDATE hvc_user_identities SET firstname = @firstname, name = @name, age = @age, registration = @registration, phone = @phone WHERE user_id = @user_id")
MySQL.createCommand("HVC/get_userbyreg","SELECT user_id FROM hvc_user_identities WHERE registration = @registration")
MySQL.createCommand("HVC/get_userbyphone","SELECT user_id FROM hvc_user_identities WHERE phone = @phone")



-- api

-- cbreturn user identity
function HVC.getUserIdentity(user_id, cbr)
  local task = Task(cbr)

  MySQL.query("HVC/get_user_identity", {user_id = user_id}, function(rows, affected)
    task({rows[1]})
  end)
end

-- cbreturn user_id by registration or nil
function HVC.getUserByRegistration(registration, cbr)
  local task = Task(cbr)

  MySQL.query("HVC/get_userbyreg", {registration = registration or ""}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].user_id})
    else
      task()
    end
  end)
end

-- cbreturn user_id by phone or nil
function HVC.getUserByPhone(phone, cbr)
  local task = Task(cbr)

  MySQL.query("HVC/get_userbyphone", {phone = phone or ""}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].user_id})
    else
      task()
    end
  end)
end

function HVC.generateStringNumber(format) -- (ex: DDDLLL, D => digit, L => letter)
  local abyte = string.byte("A")
  local zbyte = string.byte("0")

  local number = ""
  for i=1,#format do
    local char = string.sub(format, i,i)
    if char == "D" then number = number..string.char(zbyte+math.random(0,9))
    elseif char == "L" then number = number..string.char(abyte+math.random(0,25))
    else number = number..char end
  end

  return number
end

-- cbreturn a unique registration number
function HVC.generateRegistrationNumber(cbr)
  local task = Task(cbr)

  local function search()
    -- generate registration number
    local registration = HVC.generateStringNumber("DDDLLL")
    HVC.getUserByRegistration(registration, function(user_id)
      if user_id ~= nil then
        search() -- continue generation
      else
        task({registration})
      end
    end)
  end

  search()
end

-- cbreturn a unique phone number (0DDDDD, D => digit)
function HVC.generatePhoneNumber(cbr)
  local task = Task(cbr)

  local function search()
    -- generate phone number
    local phone = HVC.generateStringNumber(cfg.phone_format)
    HVC.getUserByPhone(phone, function(user_id)
      if user_id ~= nil then
        search() -- continue generation
      else
        task({phone})
      end
    end)
  end

  search()
end

-- events, init user identity at connection
AddEventHandler("HVC:playerJoin",function(user_id,source,name,last_login)
  HVC.getUserIdentity(user_id, function(identity)
    if identity == nil then
      HVC.generateRegistrationNumber(function(registration)
        HVC.generatePhoneNumber(function(phone)
          MySQL.execute("HVC/init_user_identity", {
            user_id = user_id,
            registration = registration,
            phone = phone,
            firstname = cfg.random_first_names[math.random(1,#cfg.random_first_names)],
            name = cfg.random_last_names[math.random(1,#cfg.random_last_names)],
            age = math.random(25,40)
          })
        end)
      end)
    end
  end)
end)

-- city hall menu

local cityhall_menu = {name=lang.cityhall.title(),css={top="75px", header_color="rgba(0,125,255,0.75)"}}

local function ch_identity(player,choice)
  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    HVC.prompt(player,lang.cityhall.identity.prompt_firstname(),"",function(player,firstname)
      if string.len(firstname) >= 2 and string.len(firstname) < 50 then
        firstname = sanitizeString(firstname, sanitizes.name[1], sanitizes.name[2])
        HVC.prompt(player,lang.cityhall.identity.prompt_name(),"",function(player,name)
          if string.len(name) >= 2 and string.len(name) < 50 then
            name = sanitizeString(name, sanitizes.name[1], sanitizes.name[2])
            HVC.prompt(player,lang.cityhall.identity.prompt_age(),"",function(player,age)
              age = parseInt(age)
              if age >= 16 and age <= 150 then
                if HVC.tryPayment(user_id,cfg.new_identity_cost) then
                  HVC.generateRegistrationNumber(function(registration)
                    HVC.generatePhoneNumber(function(phone)

                      MySQL.execute("HVC/update_user_identity", {
                        user_id = user_id,
                        firstname = firstname,
                        name = name,
                        age = age,
                        registration = registration,
                        phone = phone
                      })

                      -- update client registration
                      HVCclient.setRegistrationNumber(player,{registration})
                      HVCclient.notify(player,{lang.money.paid({cfg.new_identity_cost})})
                    end)
                  end)
                else
                  HVCclient.notify(player,{lang.money.not_enough()})
                end
              else
                HVCclient.notify(player,{lang.common.invalid_value()})
              end
            end)
          else
            HVCclient.notify(player,{lang.common.invalid_value()})
          end
        end)
      else
        HVCclient.notify(player,{lang.common.invalid_value()})
      end
    end)
  end
end

cityhall_menu[lang.cityhall.identity.title()] = {ch_identity,lang.cityhall.identity.description({cfg.new_identity_cost})}

local function cityhall_enter()
  local user_id = HVC.getUserId(source)
  if user_id ~= nil then
    HVC.openMenu(source,cityhall_menu)
  end
end

local function cityhall_leave()
  HVC.closeMenu(source)
end

local function build_client_cityhall(source) -- build the city hall area/marker/blip
  local user_id = HVC.getUserId(source)
  if user_id ~= nil then
    local x,y,z = table.unpack(cfg.city_hall)

    -- HVCclient.addBlip(source,{x,y,z,cfg.blip[1],cfg.blip[2],lang.cityhall.title()})
    -- HVCclient.addMarker(source,{x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})

    -- HVC.setArea(source,"HVC:cityhall",x,y,z,1,1.5,cityhall_enter,cityhall_leave)
  end
end

AddEventHandler("HVC:playerSpawn",function(user_id, source, first_spawn)
  -- send registration number to client at spawn
  HVC.getUserIdentity(user_id, function(identity)
    if identity then
      HVCclient.setRegistrationNumber(source,{identity.registration or "000AAA"})
    end
  end)

  -- first spawn, build city hall
  if first_spawn then
    build_client_cityhall(source)
  end
end)

-- player identity menu

-- add identity to main menu
HVC.registerMenuBuilder("main", function(add, data)
  local player = data.player

  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    HVC.getUserIdentity(user_id, function(identity)

      if identity then
        -- generate identity content
        -- get address
        HVC.getUserAddress(user_id, function(address)
          local home = ""
          local number = ""
          if address then
            home = address.home
            number = address.number
          end

          local content = lang.cityhall.menu.info({htmlEntities.encode(identity.name),htmlEntities.encode(identity.firstname),identity.age,identity.registration,identity.phone,home,number})
          local choices = {}
          choices[lang.cityhall.menu.title()] = {function()end, content}

          add(choices)
        end)
      end
    end)
  end
end)
