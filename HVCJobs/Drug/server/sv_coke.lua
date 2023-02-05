HVCturfs = Proxy.getInterface("dogecoin")
local inventory = exports.inventory

function HVCDrugsServer.CocaineGather()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Cocaine.Gather.x,Drugs.Cocaine.Gather.y,Drugs.Cocaine.Gather.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})
    if user_id ~= nil and HVC.hasPermission({user_id, "cocaine.license"}) then
      local weightCalculation = HVC.getInventoryWeight({user_id}) + (HVC.getItemWeight({"cocaplant"}) * 5)
      if weightCalculation <= HVC.getInventoryMaxWeight({user_id}) then

        HVC.giveInventoryItem({user_id, "cocaplant", 5, true})
        TriggerEvent('HVC:RefreshInventory', source)

      else
        HVCclient.notify(source,{"~r~You do not have enough space"})
      end
    else
      HVCclient.notify(source,{"~r~You do not have the correct license."})
    end
  end
end

function HVCDrugsServer.CocaineCanProcess()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Cocaine.Process.x,Drugs.Cocaine.Process.y,Drugs.Cocaine.Process.z), 45.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "cocaine.license"})
  end
end

function HVCDrugsServer.CocaineDoneProcessing()
    if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Cocaine.Process.x,Drugs.Cocaine.Process.y,Drugs.Cocaine.Process.z), 45.0) then
      local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"cocaplant", 5, true}) then
      HVC.giveInventoryItem({user_id, "cocaine", 1, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Coca Plant"})
    end

  end
end
