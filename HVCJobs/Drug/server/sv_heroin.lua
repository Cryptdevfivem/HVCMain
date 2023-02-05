HVCturfs = Proxy.getInterface("dogecoin")
local inventory = exports.inventory

function HVCDrugsServer.HeroinGather()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Heroin.Gather.x,Drugs.Heroin.Gather.y,Drugs.Heroin.Gather.z), 65.0) then
    local source = source
    local user_id = HVC.getUserId({source})
    if user_id ~= nil and HVC.hasPermission({user_id, "heroin.license"}) then
      local weightCalculation = HVC.getInventoryWeight({user_id}) + (HVC.getItemWeight({"opiumpoppy"}) * 5)
      if weightCalculation <= HVC.getInventoryMaxWeight({user_id}) then

        HVC.giveInventoryItem({user_id, "opiumpoppy", 5, true})
        TriggerEvent('HVC:RefreshInventory', source)

      else
        HVCclient.notify(source,{"~r~You do not have enough space"})
      end
    else
      HVCclient.notify(source,{"~r~You do not have the correct license."})
    end
  end
end

function HVCDrugsServer.HeroinCanProcess()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Heroin.Process.x,Drugs.Heroin.Process.y,Drugs.Heroin.Process.z), 65.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "heroin.license"})
  end
end

function HVCDrugsServer.HeroinDoneProcessing()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Heroin.Process.x,Drugs.Heroin.Process.y,Drugs.Heroin.Process.z), 65.0) then
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"opiumpoppy", 5, true}) then
      HVC.giveInventoryItem({user_id, "heroin", 1, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Opium Poppies!"})
    end

  end
end

