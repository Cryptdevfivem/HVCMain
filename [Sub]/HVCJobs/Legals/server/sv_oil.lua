HVCturfs = Proxy.getInterface("dogecoin")
local inventory = exports.inventory

function HVCDrugsServer.OilGather()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Oil.Gather.x,Drugs.Oil.Gather.y,Drugs.Oil.Gather.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})
    if user_id ~= nil and HVC.hasPermission({user_id, "oil.license"}) then
      local weightCalculation = HVC.getInventoryWeight({user_id}) + (HVC.getItemWeight({"crudeoil"}) * 5)
      if weightCalculation <= HVC.getInventoryMaxWeight({user_id}) then

        HVC.giveInventoryItem({user_id, "crudeoil", 5, true})
        TriggerEvent('HVC:RefreshInventory', source)

      else
        HVCclient.notify(source,{"~r~You do not have enough space"})
      end
    else
      HVCclient.notify(source,{"~r~You do not have the correct license."})
    end
  end
end

function HVCDrugsServer.OilCanProcess()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Oil.Process.x,Drugs.Oil.Process.y,Drugs.Oil.Process.z), 45.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "oil.license"})
  end
end

function HVCDrugsServer.OilDoneProcessing()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Oil.Process.x,Drugs.Oil.Process.y,Drugs.Oil.Process.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"crudeoil", 5, true}) then
      HVC.giveInventoryItem({user_id, "oil", 1, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Crude Oil!"})
    end

  end
end