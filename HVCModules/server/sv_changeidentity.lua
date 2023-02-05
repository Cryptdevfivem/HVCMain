local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVC")


RegisterServerEvent("UpdateFirstName")
AddEventHandler("UpdateFirstName", function(NewFirstName)
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryBankPayment({user_id, 5000}) then
        exports['ghmattimysql']:execute("UPDATE hvc_user_identities SET firstname = @firstname WHERE user_id = @targetid", {targetid = user_id, firstname = NewFirstName}, function() 
            HVCclient.notify(source, {"~g~Your First Name Has Been Updated To " .. NewFirstName .. " Paid £5,000"})
        end)
    else
        HVCclient.notify(source, {"~r~Not Enough Money. 💲"})
    end
end)

RegisterServerEvent("UpdateLastName")
AddEventHandler("UpdateLastName", function(NewLastName)
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryBankPayment({user_id, 5000}) then
        exports['ghmattimysql']:execute("UPDATE hvc_user_identities SET name = @firstname WHERE user_id = @targetid", {targetid = user_id, firstname = NewLastName}, function() 
            HVCclient.notify(source, {"~g~Your Last Name Has Been Updated To " .. NewLastName .. " Paid £5,000"})
        end)
    else
        HVCclient.notify(source, {"~r~Not Enough Money. 💲"})
    end
end)

