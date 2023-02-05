HVCturfs = Proxy.getInterface("dogecoin")
local inventory = exports.inventory

function HVCDrugsServer.DiamondGather()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Diamond.Gather.x,Drugs.Diamond.Gather.y,Drugs.Diamond.Gather.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})
    if user_id ~= nil and HVC.hasPermission({user_id, "diamond.license"}) then
      local weightCalculation = HVC.getInventoryWeight({user_id}) + (HVC.getItemWeight({"uncutdiamonds"}) * 5)
      if weightCalculation <= HVC.getInventoryMaxWeight({user_id}) then

        HVC.giveInventoryItem({user_id, "uncutdiamonds", 5, true})
        TriggerEvent('HVC:RefreshInventory', source)

      else
        HVCclient.notify(source,{"~r~You do not have enough space"})
      end
    else
      HVCclient.notify(source,{"~r~You do not have the correct license."})
    end
  end
end
function HVCDrugsServer.DiamondCanProcess()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Diamond.Process.x,Drugs.Diamond.Process.y,Drugs.Diamond.Process.z), 45.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "diamond.license"})
  end
end

function HVCDrugsServer.DiamondDoneProcessing()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Diamond.Process.x,Drugs.Diamond.Process.y,Drugs.Diamond.Process.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"uncutdiamonds", 5, true}) then
      HVC.giveInventoryItem({user_id, "diamonds", 1, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Uncut Diamonds!"})
    end

  end
end