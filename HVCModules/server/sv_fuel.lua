local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
	

RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price)
	local user_id = HVC.getUserId({source})
	local fuelAmount = math.floor(price)
		
        
	if HVC.tryFullPayment({user_id ,fuelAmount})then
			
	end
end)