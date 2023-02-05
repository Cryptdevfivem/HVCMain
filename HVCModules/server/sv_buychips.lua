local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVC")

function HVC.addChips(source, value)

end

RegisterServerEvent("buychips:GetAmountofchips")
AddEventHandler(
    "buychips:GetAmountofchips",
    function()
        local player = source
        local user_id = HVC.getUserId({player})
        local amt = 0
        exports['ghmattimysql']:execute("SELECT * FROM hvc_casino_tokens WHERE userid = @uid", {uid = user_id}, function(callback) 
            if #callback > 0 then 
                for i = 1, #callback do 
                    amt = callback[1].token
                    TriggerClientEvent("buychips:GotAmountOfChips", player, amt)
                end
            else
                exports["ghmattimysql"]:executeSync("INSERT INTO hvc_casino_tokens(userid,token) VALUES(@userid, @token)", {userid = user_id, token = 0})
            end
        end)
    end
)
RegisterServerEvent("buychips:TryChipPayment")
AddEventHandler(
    "buychips:TryChipPayment",
    function(amount)
        local player = source
        local user_id = HVC.getUserId({player}) 
        local amt = 0

        exports['ghmattimysql']:execute("SELECT * FROM hvc_casino_tokens WHERE userid = @uid", {uid = user_id}, function(callback) 
            if #callback > 0 then 
                for i = 1, #callback do 
                    print("USER: " ..user_id) 
                    print("CHIPS: " ..callback[i].token)
                    print("NEW CHIPS: " ..callback[i].token + amount)
                    amt = callback[i].token

                    if tonumber(amount) > 0 then
                        if HVC.tryPayment({user_id, tonumber(amount)}) then 
                            exports['ghmattimysql']:execute("UPDATE hvc_casino_tokens SET token = @balance WHERE userid = @owner", {balance = amt + tonumber(amount) , owner = user_id }, function() end)
                            HVCclient.notify(player, {"~g~Bought " .. amount .. " chips"})
                            TriggerClientEvent("buychips:updatehud+", player, amount)
                        else
                            HVCclient.notify(player, {"~r~Not enough cash"})
                        end
                    else
                        HVCclient.notify(player, {"~r~Amount Can't Be Under 0 You Mong!"})
                    end

                end
            end
        end)

    end
)
RegisterServerEvent("buychips:PerformTradeIn")
AddEventHandler(
    "buychips:PerformTradeIn",
    function(amount)
        local player = source
        local user_id = HVC.getUserId({player})

        local amt = 0
        exports['ghmattimysql']:execute("SELECT * FROM hvc_casino_tokens WHERE userid = @uid", {uid = user_id}, function(callback) 
            if #callback > 0 then 
                for i = 1, #callback do 
                    amt = callback[i].token
                    if tonumber(amount) > 0 then
                        if tonumber(amount) > tonumber(amt) then
                            HVCclient.notify(player, {"~r~Not enough chips"})
                        else
                            HVCclient.notify(player, {"~g~Recieved £" .. amount})
                            local newamt = 0
                            newamt = amt - tonumber(amount)
                            exports['ghmattimysql']:execute("UPDATE hvc_casino_tokens SET token = @balance WHERE userid = @owner", {balance = newamt, owner = user_id }, function() end)
                            HVC.giveMoney({user_id, tonumber(amount)})
                            TriggerClientEvent("buychips:updatehud-", player, tonumber(newamt))
                        end
                    else
                        HVCclient.notify(player, {"~r~Amount Can't Be Under 0 You Mong!"})
                    end
                end
            end
        end)
    end
)


RegisterCommand("getchips", function(source, args, rawcommand)
    local player = source
    local user_id = HVC.getUserId({player})
    local amt = 0

    print("Start Debug")
    print("USERID: " ..args[1])
    exports['ghmattimysql']:execute("SELECT * FROM hvc_casino_tokens WHERE userid = @userid", {userid = args[1]}, function(result)
        print(#result)
        if #result > 0 then
            local UUID = result[1].userid
            local Chips = result[1].token
            print(UUID)
            print(Chips)
        end
    end)
end)


Citizen.CreateThread(function()
    Wait(2500)
    exports['ghmattimysql']:execute([[
            CREATE TABLE IF NOT EXISTS `hvc_casino_tokens` (
                `userid` INT(11) NOT NULL,
                `token` INT(11) NOT NULL,
                PRIMARY KEY (`userid`) USING BTREE
              );
        ]])
    print("[HVC] Casino Tables Iniatlised")
end)
