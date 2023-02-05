local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "BlackMarket")


RegisterServerEvent("HVC:PurchaseBlackMarket")
AddEventHandler('HVC:PurchaseBlackMarket', function(amount, price, itemid, itemName)
    local source = source
    local userid = HVC.getUserId({source})
    local admin_name = "HVC Anticheat"
    local reason1 = "Type #10"
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(121.0418, -3103.24, 6.010254)
    local pricemismatch = false 
    local curdate = os.time()
    curdate = curdate + (60 * 60 * 500000)

    if #(coords - comparison) > 5 then
        TriggerClientEvent("chatMessage", -1, "^1^*HVC", {180, 0, 0}, GetPlayerName(source) .. "^7 Was Banned For Cheating (Type #10)")
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
