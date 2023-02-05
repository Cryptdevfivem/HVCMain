local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "BlackMarket")


RegisterServerEvent("HVC:PurchaseShop")
AddEventHandler('HVC:PurchaseShop', function(amount, price, itemid, itemName)
    local source = source
    local userid = HVC.getUserId({source})
    local admin_name = "HVC Anticheat"
    local reason1 = "Type #10"
    local curdate = os.time()
    curdate = curdate + (60 * 60 * 500000)

    if price < 1000 then
        TriggerClientEvent("chatMessage", -1, "^1^*HVC", {180, 0, 0}, GetPlayerName(source) .. "^7 was banned for cheating (Type #10)")
        return
    end


    if HVC.hasPermission({userid, "player.phone"}) then
        if HVC.tryPayment({userid, price}) then
            HVC.giveInventoryItem({userid, itemid, amount, true})
        else 
            HVCclient.notify(source, {"~r~Insufficient funds"})
        end
    else
        HVCclient.notify(source, {"~r~You do not have permission to buy guns"})
    end
end)
