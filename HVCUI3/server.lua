local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")

HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC","HVC_fuel")

RegisterServerEvent('update:bank')
AddEventHandler('update:bank', function()
    local user_id = HVC.getUserId({source})
    local bank = HVC.getBankMoney({user_id})
    TriggerClientEvent('bank:setDisplayBankMoney', source, bank)
end)

RegisterServerEvent('update:cash')
AddEventHandler('update:cash', function()
    local user_id = HVC.getUserId({source})
    local wallet = HVC.getMoney({user_id})
    TriggerClientEvent('cash:setDisplayMoney', source, wallet)
end)