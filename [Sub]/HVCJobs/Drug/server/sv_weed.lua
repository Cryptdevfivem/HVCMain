HVCturfs = Proxy.getInterface("dogecoin")
local inventory = exports.inventory

function HVCDrugsServer.WeedGather()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Weed.Gather.x,Drugs.Weed.Gather.y,Drugs.Weed.Gather.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})
    if user_id ~= nil and HVC.hasPermission({user_id, "weed.license"}) then
      local weightCalculation = HVC.getInventoryWeight({user_id}) + (HVC.getItemWeight({"weedleaves"}) * 5)
      if weightCalculation <= HVC.getInventoryMaxWeight({user_id}) then

        HVC.giveInventoryItem({user_id, "weedleaves", 5, true})
        TriggerEvent('HVC:RefreshInventory', source)

      else
        HVCclient.notify(source,{"~r~You do not have enough space"})
      end
    else
      HVCclient.notify(source,{"~r~You do not have the correct license."})
    end
  end
end


function HVCDrugsServer.WeedCanProcess()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Weed.Process.x,Drugs.Weed.Process.y,Drugs.Weed.Process.z), 45.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "weed.license"})
  end
end

function HVCDrugsServer.WeedDoneProcessing()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Weed.Process.x,Drugs.Weed.Process.y,Drugs.Weed.Process.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"weedleaves", 5, true}) then
      HVC.giveInventoryItem({user_id, "weed", 1, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Weed Leaves!"})
    end

  end
end