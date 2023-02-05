HVCturfs = Proxy.getInterface("dogecoin")
local inventory = exports.inventory

function HVCDrugsServer.IronGather()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Iron.Gather.x,Drugs.Iron.Gather.y,Drugs.Iron.Gather.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})
    if user_id ~= nil and HVC.hasPermission({user_id, "iron.license"}) then
      local weightCalculation = HVC.getInventoryWeight({user_id}) + (HVC.getItemWeight({"unprocessediron"}) * 5)
      if weightCalculation <= HVC.getInventoryMaxWeight({user_id}) then

        HVC.giveInventoryItem({user_id, "unprocessediron", 5, true})
        TriggerEvent('HVC:RefreshInventory', source)

      else
        HVCclient.notify(source,{"~r~You do not have enough space"})
      end
    else
      HVCclient.notify(source,{"~r~You do not have the correct license."})
    end
  end
end


function HVCDrugsServer.IronCanProcess()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Iron.Process.x,Drugs.Iron.Process.y,Drugs.Iron.Process.z), 45.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "iron.license"})
  end
end

function HVCDrugsServer.IronDoneProcessing()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Iron.Process.x,Drugs.Iron.Process.y,Drugs.Iron.Process.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"unprocessediron", 5, true}) then
      HVC.giveInventoryItem({user_id, "iron", 1, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Unprocessed Iron!"})
    end

  end
end