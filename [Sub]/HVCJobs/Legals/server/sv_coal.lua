HVCturfs = Proxy.getInterface("dogecoin")
local inventory = exports.inventory

function HVCDrugsServer.CoalGather()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Coal.Gather.x,Drugs.Coal.Gather.y,Drugs.Coal.Gather.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})
    if user_id ~= nil and HVC.hasPermission({user_id, "coal.license"}) then
      local weightCalculation = HVC.getInventoryWeight({user_id}) + (HVC.getItemWeight({"unprocessedcoal"}) * 5)
      if weightCalculation <= HVC.getInventoryMaxWeight({user_id}) then

        HVC.giveInventoryItem({user_id, "unprocessedcoal", 5, true})
        TriggerEvent('HVC:RefreshInventory', source)

      else
        HVCclient.notify(source,{"~r~You do not have enough space"})
      end
    else
      HVCclient.notify(source,{"~r~You do not have the correct license."})
    end
  end
end

function HVCDrugsServer.CoalCanProcess()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Coal.Process.x,Drugs.Coal.Process.y,Drugs.Coal.Process.z), 45.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "coal.license"})
  end
end

function HVCDrugsServer.CoalDoneProcessing()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Coal.Process.x,Drugs.Coal.Process.y,Drugs.Coal.Process.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"unprocessedcoal", 5, true}) then
      HVC.giveInventoryItem({user_id, "coal", 1, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Unprocessed Coal!"})
    end

  end
end