HVCturfs = Proxy.getInterface("dogecoin")
local inventory = exports.inventory

function HVCDrugsServer.EthereumGather()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Ethereum.Gather.x,Drugs.Ethereum.Gather.y,Drugs.Ethereum.Gather.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})
    if user_id ~= nil and HVC.hasPermission({user_id, "ethereum.license"}) then
      local weightCalculation = HVC.getInventoryWeight({user_id}) + (HVC.getItemWeight({"unprocessedethereum"}) * 5)
      if weightCalculation <= HVC.getInventoryMaxWeight({user_id}) then

        HVC.giveInventoryItem({user_id, "unprocessedethereum", 5, true})
        TriggerEvent('HVC:RefreshInventory', source)

      else
        HVCclient.notify(source,{"~r~You do not have enough space"})
      end
    else
      HVCclient.notify(source,{"~r~You do not have the correct license."})
    end
  end
end


function HVCDrugsServer.EthereumCanProcess()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Ethereum.Process.x,Drugs.Ethereum.Process.y,Drugs.Ethereum.Process.z), 45.0) then
    local user_id = HVC.getUserId({source})
    return HVC.hasPermission({user_id, "ethereum.license"})
  end
end

function HVCDrugsServer.EthereumDoneProcessing()
  if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Ethereum.Process.x,Drugs.Ethereum.Process.y,Drugs.Ethereum.Process.z), 45.0) then
    local source = source
    local user_id = HVC.getUserId({source})

    if HVC.tryGetInventoryItem({user_id,"unprocessedethereum", 5, true}) then
      HVC.giveInventoryItem({user_id, "ethereum", 1, true})
      TriggerEvent('HVC:RefreshInventory', source)
    else
      HVCclient.notify(source,{"~r~You do not have enough Unprocessed Ethereum!"})
    end

  end
end