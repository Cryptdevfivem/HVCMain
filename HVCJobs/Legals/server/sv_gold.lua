HVCturfs = Proxy.getInterface("dogecoin")
local inventory = exports.inventory

function HVCDrugsServer.GoldGather()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Gold.Gather.x,Drugs.Gold.Gather.y,Drugs.Gold.Gather.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})
    if user_id ~= nil and HVC.hasPermission({user_id, "gold.license"}) then
      local weightCalculation = HVC.getInventoryWeight({user_id}) + (HVC.getItemWeight({"unprocessedgold"}) * 5)
      if weightCalculation <= HVC.getInventoryMaxWeight({user_id}) then

        HVC.giveInventoryItem({user_id, "unprocessedgold", 5, true})
        TriggerEvent('HVC:RefreshInventory', source)

      else
        HVCclient.notify(source,{"~r~You do not have enough space"})
      end
    else
      HVCclient.notify(source,{"~r~You do not have the correct license."})
    end
  end
end


function HVCDrugsServer.GoldCanProcess()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Gold.Process.x,Drugs.Gold.Process.y,Drugs.Gold.Process.z), 45.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "gold.license"})
  end
end

function HVCDrugsServer.GoldDoneProcessing()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Gold.Process.x,Drugs.Gold.Process.y,Drugs.Gold.Process.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"unprocessedgold", 5, true}) then
      HVC.giveInventoryItem({user_id, "gold", 1, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Unprocessed Ethereum!"})
    end

  end
end