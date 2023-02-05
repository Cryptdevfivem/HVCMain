
--Rewrite needed this is very very bad(will rewrite when ever im free)

local namejob = "Royal Mail" 
RegisterServerEvent('Vrxith:CheckJob')
AddEventHandler('Vrxith:CheckJob', function()
  local source = source
  if namejob == "Royal Mail" then --here you change the jobname (from your database)
    TriggerClientEvent('yesdelivery', source)
    print("Triggered")
  else
    TriggerClientEvent('nodelivery', source)
  end
end)

--Essential payment functions 

RegisterServerEvent('Vrxith:PayRoyalMailDriver')
AddEventHandler('Vrxith:PayRoyalMailDriver', function(p1, pricetogive)
  local source = source
  local user_id = HVC.getUserId(source)
  if not pricetogive then
    -- Ban Function Coming Soon...
  end 

  if p1 > 10000 then
    -- Ban Function Coming Soon...
  else
    print("Gave Money")
    HVC.giveMoney(user_id, p1)
    HVCclient.notify(source, "~g~ Recieved £" ..p1.. " For Delivering A Parcel")
  end
end)
