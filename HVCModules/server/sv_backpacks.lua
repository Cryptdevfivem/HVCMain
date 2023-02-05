local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "Backpacks")


RegisterServerEvent("HVC:PurchaseBackpack")
AddEventHandler('HVC:PurchaseBackpack', function(name, price, capacity)
    local source = source
    local userid = HVC.getUserId({source})
    local admin_name = "HVC Anticheat"
    local reason1 = "Type#09"
    local coords = GetEntityCoords(GetPlayerPed(source))
    local pricemismatch = false 
    local curdate = os.time()
    local data = HVC.getUserDataTable({userid})
    curdate = curdate + (60 * 60 * 500000)

    if capacity > 71 then 

        return
    end

    if data.invcap > 30 then
        HVCclient.notify(source, {"~r~Please Remove Your Backpack To Purchase Another One."})
        return
    end

    if HVC.hasPermission({userid, "player.phone"}) then
        if HVC.tryPayment({userid, price}) then
            HVCclient.notify(source, {"~g~Successfully Purchased " ..name.. " For £"  ..price})
            HVC.updateInvCap({userid, capacity})
        else 
            HVCclient.notify(source, {"~r~Insufficient funds"})
        end
    else
        HVCclient.notify(source, {"~r~You do not have permission to buy guns"})
    end
end)

