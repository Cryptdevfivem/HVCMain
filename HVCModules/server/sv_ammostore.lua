local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "AmmoStore")
local inventory = exports.inventory



RegisterServerEvent("HVC:PurchaseAmmo")
AddEventHandler('HVC:PurchaseAmmo', function(amount, price, ammoid, ammoname)
    local source = source
    local userid = HVC.getUserId({source})
    local admin_name = "HVC Anticheat"
    local reason1 = "Type#09"
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(3800.76, 4440.54, 4.25)
    local pricemismatch = false 
    local curdate = os.time()
    curdate = curdate + (60 * 60 * 500000)

    if #(coords - comparison) > 5 then
        TriggerClientEvent("chatMessage", -1, "^1^*HVC", {180, 0, 0}, GetPlayerName(source) .. "^7 was banned for Cheating (Type#09)")

        return
    end


    if HVC.hasPermission({userid, "player.phone"}) then
        if HVC.tryPayment({userid, price}) then
            HVC.giveInventoryItem({userid, ammoid, amount, true})
        else 
            HVCclient.notify(source, {"~r~Insufficient funds"})
        end
    else
        HVCclient.notify(source, {"~r~You do not have permission to buy guns"})
    end
end)
