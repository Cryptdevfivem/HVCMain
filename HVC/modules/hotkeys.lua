-- Hot Key TP to WP
function HVC.TpToWaypoint()
	local user_id = HVC.getUserId({source})
	local player = HVC.getUserSource({user_id})
	local tptowaypoint = HVC.getUsersByPermission({"player.tptowaypoint"})
	Citizen.Trace("Send Nudes")
		if HVC.hasPermission({user_id,"player.tptowaypoint"}) then
		Citizen.Trace("Send Nudes2")
		TriggerClientEvent("TpToWaypoint", player)
		Citizen.Trace("Send Nudes3")
	end
end

function tHVC.TpToWaypoint()
  HVC.TpToWaypoint(source)
end