HVCturfs = Proxy.getInterface("dogecoin")
local inventory = exports.inventory

function HVCDrugsServer.MethGather()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Meth.Gather.x,Drugs.Meth.Gather.y,Drugs.Meth.Gather.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})
    if user_id ~= nil and HVC.hasPermission({user_id, "meth.license"}) then
      local weightCalculation = HVC.getInventoryWeight({user_id}) + (HVC.getItemWeight({"crystalmeth"}) * 5)
      if weightCalculation <= HVC.getInventoryMaxWeight({user_id}) then

        HVC.giveInventoryItem({user_id, "crystalmeth", 5, true})
        TriggerEvent('HVC:RefreshInventory', source)

      else
        HVCclient.notify(source,{"~r~You do not have enough space"})
      end
    else
      HVCclient.notify(source,{"~r~You do not have the correct license."})
    end
  end
end

function HVCDrugsServer.MethCanProcess()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Meth.Process.x,Drugs.Meth.Process.y,Drugs.Meth.Process.z), 45.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "meth.license"})
  end
end

function HVCDrugsServer.MethDoneProcessing()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Meth.Process.x,Drugs.Meth.Process.y,Drugs.Meth.Process.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"crystalmeth", 5, true}) then
      HVC.giveInventoryItem({user_id, "meth", 1, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Crystal Meth!"})
    end

  end
end