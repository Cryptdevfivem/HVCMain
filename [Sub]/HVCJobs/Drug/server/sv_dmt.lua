HVCturfs = Proxy.getInterface("dogecoin")
local inventory = exports.inventory

function HVCDrugsServer.DMTGather()
  print("Starting Coord Check")
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.DMT.Gather.x,Drugs.DMT.Gather.y,Drugs.DMT.Gather.z), 45.0) then
    print("Coords Check Completed")
    local source = source
    local user_id = HVC.getUserId({source})
    if user_id ~= nil and HVC.hasPermission({user_id, "dmt.license"}) then
      print("Permission Check Completed")
      local weightCalculation = HVC.getInventoryWeight({user_id}) + (HVC.getItemWeight({"virolabarkresin"}) * 5)
      if weightCalculation <= HVC.getInventoryMaxWeight({user_id}) then
        print("Weight Calculation Completed")
        HVC.giveInventoryItem({user_id, "virolabarkresin", 5, true})
        TriggerEvent('HVC:RefreshInventory', source)
      else
        HVCclient.notify(source,{"~r~You do not have enough space"})
      end
    else
      HVCclient.notify(source,{"~r~You do not have the correct license."})
    end
  end
end


function HVCDrugsServer.DMTCanProcess1()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.DMT.Process1.x,Drugs.DMT.Process1.y,Drugs.DMT.Process1.z), 45.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "dmt.license"})
  end
end

function HVCDrugsServer.DMTDoneProcessing1()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.DMT.Process1.x,Drugs.DMT.Process1.y,Drugs.DMT.Process1.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"virolabarkresin", 5, true}) then
      HVC.giveInventoryItem({user_id, "bottlesofdistilledwater", 5, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Virola Bark Resin!"})
    end

  end
end




function HVCDrugsServer.DMTCanProcess2()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.DMT.Process2.x,Drugs.DMT.Process2.y,Drugs.DMT.Process2.z), 45.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "dmt.license"})
  end
end

function HVCDrugsServer.DMTDoneProcessing2()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.DMT.Process2.x,Drugs.DMT.Process2.y,Drugs.DMT.Process2.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"bottlesofdistilledwater", 5, true}) then
      HVC.giveInventoryItem({user_id, "dmt", 1, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Bottles of Distilled Water!"})
    end

  end
end
