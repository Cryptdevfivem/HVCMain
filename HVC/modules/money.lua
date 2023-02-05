local lang = HVC.lang

-- Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)



MySQL.createCommand("HVC/money_init_user","INSERT IGNORE INTO hvc_user_moneys(user_id,wallet,bank) VALUES(@user_id,@wallet,@bank)")
MySQL.createCommand("HVC/get_money","SELECT wallet,bank FROM hvc_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("HVC/set_money","UPDATE hvc_user_moneys SET wallet = @wallet, bank = @bank WHERE user_id = @user_id")


-- load config
local cfg = module("cfg/money")

-- API

-- get money
-- cbreturn nil if error
function HVC.getMoney(user_id)
  local tmp = HVC.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- set money
function HVC.setMoney(user_id,value)
  local tmp = HVC.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  -- update client display
  local source = HVC.getUserSource(user_id)
  if source ~= nil then
    HVCclient.setDivContent(source,{"money",lang.money.display({value})})
  end
end

-- try a payment
-- return true or false (debited if true)
function HVC.tryPayment(user_id,amount)
  local money = HVC.getMoney(user_id)
  if amount >= 0 and money >= amount then
    HVC.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

function HVC.tryBankPayment(user_id,amount)
  local money = HVC.getBankMoney(user_id)
  if amount >= 0 and money >= amount then
    HVC.setBankMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

-- give money
function HVC.giveMoney(user_id,amount)
  local money = HVC.getMoney(user_id)
  HVC.setMoney(user_id,money+amount)
end

-- get bank money
function HVC.getBankMoney(user_id)
  local tmp = HVC.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function HVC.setBankMoney(user_id,value)
  local tmp = HVC.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
  local source = HVC.getUserSource(user_id)
  if source ~= nil then
    HVCclient.setDivContent(source,{"bmoney",lang.money.bdisplay({value})})
  end
end

-- give bank money
function HVC.giveBankMoney(user_id,amount)
  if amount > 0 then
    local money = HVC.getBankMoney(user_id)
    HVC.setBankMoney(user_id,money+amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function HVC.tryWithdraw(user_id,amount)
  local money = HVC.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    HVC.setBankMoney(user_id,money-amount)
    HVC.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function HVC.tryDeposit(user_id,amount)
  if amount > 0 and HVC.tryPayment(user_id,amount) then
    HVC.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function HVC.tryFullPayment(user_id,amount)
  local money = HVC.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return HVC.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if HVC.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return HVC.tryPayment(user_id, amount)
    end
  end

  return false
end

-- events, init user account if doesn't exist at connection
AddEventHandler("HVC:playerJoin",function(user_id,source,name,last_login)
  MySQL.query("HVC/money_init_user", {user_id = user_id, wallet = cfg.open_wallet, bank = cfg.open_bank}, function(affected)
    local tmp = HVC.getUserTmpTable(user_id)
    if tmp then
      MySQL.query("HVC/get_money", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
          tmp.bank = rows[1].bank
          tmp.wallet = rows[1].wallet
        end
      end)
    end
  end)
end)

-- save money on leave
AddEventHandler("HVC:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = HVC.getUserTmpTable(user_id)
  if tmp and tmp.wallet ~= nil and tmp.bank ~= nil then
    MySQL.execute("HVC/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank})
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("HVC:save", function()
  for k,v in pairs(HVC.user_tmp_tables) do
    if v.wallet ~= nil and v.bank ~= nil then
      MySQL.execute("HVC/set_money", {user_id = k, wallet = v.wallet, bank = v.bank})
    end
  end
end)

-- money hud
AddEventHandler("HVC:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn and HVCConfig.MoneyUiEnabled then
    -- add money display
    HVCclient.setDiv(source,{"money",cfg.display_css,lang.money.display({HVC.getMoney(user_id)})})
	HVCclient.setDiv(source,{"bmoney",cfg.display_css,lang.money.bdisplay({HVC.getBankMoney(user_id)})})
  end
end)

--local function ch_give(player,choice)
  -- get nearest player
RegisterServerEvent("HVC:GiveMoney")
AddEventHandler("HVC:GiveMoney", function()
  local player = source
  local user_id = HVC.getUserId(player)
  if user_id ~= nil then
    HVCclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = HVC.getUserId(nplayer)
        if nuser_id ~= nil then
          -- prompt number
          HVC.prompt(player,lang.money.give.prompt(),"",function(player,amount)
            local amount = parseInt(amount)
            if amount > 0 and HVC.tryPayment(user_id,amount) then
              HVC.giveMoney(nuser_id,amount)
              HVCclient.notify(player,{lang.money.given({amount})})
              HVCclient.notify(nplayer,{lang.money.received({amount})})
            else
              HVCclient.notify(player,{lang.money.not_enough()})
            end
          end)
        else
          HVCclient.notify(player,{lang.common.no_player_near()})
        end
      else
        HVCclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end)

-- add player give money to main menu
HVC.registerMenuBuilder("main", function(add, data)
  local user_id = HVC.getUserId(data.player)
  if user_id ~= nil then
    local choices = {}
    choices[lang.money.give.title()] = {ch_give, lang.money.give.description()}

    add(choices)
  end
end)
