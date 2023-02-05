RegisterNetEvent("goIntoBucket")
AddEventHandler("goIntoBucket", function(bkt)
  local source = source
  if bkt == "source" then
	  SetPlayerRoutingBucket(source, source)
  else
    SetPlayerRoutingBucket(source, 0)
  end
	-- vRPclient.notify(source,{"You are in a bucket!"})
end)