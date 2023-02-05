HVCturfs = Proxy.getInterface("dogecoin")
local inventory = exports.inventory

function HVCDrugsServer.LSDGather()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.LSD.Gather.x,Drugs.LSD.Gather.y,Drugs.LSD.Gather.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})
    if user_id ~= nil and HVC.hasPermission({user_id, "lsd.license"}) then
      local weightCalculation = HVC.getInventoryWeight({user_id}) + (HVC.getItemWeight({"froglegs"}) * 5)
      if weightCalculation <= HVC.getInventoryMaxWeight({user_id}) then

        HVC.giveInventoryItem({user_id, "froglegs", 5, true})
        TriggerEvent('HVC:RefreshInventory', source)

      else
        HVCclient.notify(source,{"~r~You do not have enough space"})
      end
    else
      HVCclient.notify(source,{"~r~You do not have the correct license."})
    end
  end
end














function HVCDrugsServer.LSDCanProcess1()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.LSD.Process1.x,Drugs.LSD.Process1.y,Drugs.LSD.Process1.z), 45.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "lsd.license"})
  end
end

function HVCDrugsServer.LSDDoneProcessing1()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.LSD.Process1.x,Drugs.LSD.Process1.y,Drugs.LSD.Process1.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"froglegs", 5, true}) then
      HVC.giveInventoryItem({user_id, "lysergicacidamid", 5, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Frog Legs!"})
    end

  end
end



function HVCDrugsServer.LSDCanProcess2()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.LSD.Process2.x,Drugs.LSD.Process2.y,Drugs.LSD.Process2.z), 45.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "lsd.license"})
  end
end

function HVCDrugsServer.LSDDoneProcessing2()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.LSD.Process2.x,Drugs.LSD.Process2.y,Drugs.LSD.Process2.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"lysergicacidamid", 5, true}) then
      HVC.giveInventoryItem({user_id, "lsd", 1, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Lysergic Acid Amid!"})
    end

  end
end
