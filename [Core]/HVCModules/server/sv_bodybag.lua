RegisterServerEvent('HVC:Trigger')
AddEventHandler('HVC:Trigger', function(target)
    TriggerClientEvent('HVC:PutInBag', target)
end)