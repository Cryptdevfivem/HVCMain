HVCturfs = Proxy.getInterface("dogecoin")
local inventory = exports.inventory

function HVCDrugsServer.MDMAGather()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.MDMA.Gather.x,Drugs.MDMA.Gather.y,Drugs.MDMA.Gather.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})
    if user_id ~= nil and HVC.hasPermission({user_id, "mdma.license"}) then
      local weightCalculation = HVC.getInventoryWeight({user_id}) + (HVC.getItemWeight({"sassafrastreeoil"}) * 5)
      if weightCalculation <= HVC.getInventoryMaxWeight({user_id}) then

        HVC.giveInventoryItem({user_id, "sassafrastreeoil", 5, true})
        TriggerEvent('HVC:RefreshInventory', source)

      else
        HVCclient.notify(source,{"~r~You do not have enough space"})
      end
    else
      HVCclient.notify(source,{"~r~You do not have the correct license."})
    end
  end
end

function HVCDrugsServer.MDMACanProcess()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.MDMA.Process.x,Drugs.MDMA.Process.y,Drugs.MDMA.Process.z), 45.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "mdma.license"})
  end
end

function HVCDrugsServer.MDMADoneProcessing()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.MDMA.Process.x,Drugs.MDMA.Process.y,Drugs.MDMA.Process.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"sassafrastreeoil", 5, true}) then
      HVC.giveInventoryItem({user_id, "mdma", 1, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Sassafras Tree Oil!"})
    end

  end
end