local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVCgang = Proxy.getInterface("gangmanager")
HVC = Proxy.getInterface("HVC")
HVCTurfs = Proxy.getInterface("HVCTurfs")


function HVCDrugsServer.SellHeroin()
    if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Heroin.Sell.x, Drugs.Heroin.Sell.y, Drugs.Heroin.Sell.z), 5.00) then
        local source = source
        local user_id = HVC.getUserId({source})

        if GetPlayerRoutingBucket(source) ~= 0 then
            HVCclient.notify(source, {"~r~You have been returned back to original bucket, do not exploit!"})
            SetPlayerRoutingBucket(source, 0)
            return
        end

        if HVC.tryGetInventoryItem({user_id,"heroin", 1, true}) then
            local GangName, commission = HVCTurfs.GetTurfOwnerCommission({4})
            print("Heroin Commission " ..commission.. "%") 
            if commission ~= 0 then
                local leftover1 = (15000*4) * commission / 100
                local leftover = (15000*4) - leftover1
                local gangamount = leftover * 0.35

                if leftover < 0 then
                    leftover = 15000*4
                end
                HVCTurfs.ModifyGangFundsSV({"Give", GangName, gangamount})
                HVC.giveMoney({user_id, leftover})
                HVCclient.notify(source, {"~g~Sold 1 Heroin For £" ..leftover})
                TriggerEvent('HVC:RefreshInventory', source)
            else
                HVC.giveMoney({user_id, 15000*4})
                HVCclient.notify(source, {"~g~Sold 1 Heroin For £60,000"})
                TriggerEvent('HVC:RefreshInventory', source)
            end
        else
            HVCclient.notify(source,{"~r~You do not have enough Heroin"})
        end
    end
end


function HVCDrugsServer.SellEthereum()
    if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Ethereum.Sell.x, Drugs.Ethereum.Sell.y, Drugs.Ethereum.Sell.z), 45.0) then
        local source = source
        if GetPlayerRoutingBucket(source) ~= 0 then
            HVCclient.notify(source, {"~r~You have been returned back to original bucket, do not exploit!"})
            SetPlayerRoutingBucket(source, 0)
            return
        end
        local user_id = HVC.getUserId({source})
        if HVC.tryGetInventoryItem({user_id,"ethereum", 1, true}) then
            HVCclient.notify(source, {"~g~Sold 1 Ethereum For £52,000"})
            TriggerEvent('HVC:RefreshInventory', source)
            HVC.giveBankMoney({user_id, 13500*4})
        else
            HVCclient.notify(source, {"~r~You do not have enough Ethereum!"})
        end
    end
end

function HVCDrugsServer.SellCocaine()
    if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Cocaine.Sell.x, Drugs.Cocaine.Sell.y, Drugs.Cocaine.Sell.z), 5.00) then
        local source = source
        local user_id = HVC.getUserId({source})
        if GetPlayerRoutingBucket(source) ~= 0 then
            HVCclient.notify(source, {"~r~You have been returned back to original bucket, do not exploit!"})
            SetPlayerRoutingBucket(source, 0)
            return
        end
        if HVC.tryGetInventoryItem({user_id,"cocaine", 1, true}) then
            local GangName, commission = HVCTurfs.GetTurfOwnerCommission({0})
            print("Cocaine Commission " ..commission.. "%") 
            if commission ~= 0 then
                local leftover1 = (2500*4) * commission / 100
                local leftover = (2500*4) - leftover1
                local gangamount = leftover * 0.35

                if leftover < 0 then
                    leftover = 2500*4
                end
                HVCTurfs.ModifyGangFundsSV({"Give", GangName, gangamount})
                HVC.giveMoney({user_id, leftover})
                HVCclient.notify(source, {"~g~Sold 1 Cocaine For £" ..leftover})
                TriggerEvent('HVC:RefreshInventory', source)
            else
                HVC.giveMoney({user_id, 2500*4})
                HVCclient.notify(source, {"~g~Sold 1 Cocaine For £10,000"})
                TriggerEvent('HVC:RefreshInventory', source)
            end
        else
            HVCclient.notify(source, {"~r~You do not have enough Cocaine!"})
        end
    end
end

function HVCDrugsServer.SellMDMA()
    if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.MDMA.Sell.x, Drugs.MDMA.Sell.y, Drugs.MDMA.Sell.z), 5.00) then
        local source = source
        local user_id = HVC.getUserId({source})
        if GetPlayerRoutingBucket(source) ~= 0 then
            HVCclient.notify(source, {"~r~You have been returned back to original bucket, do not exploit!"})
            SetPlayerRoutingBucket(source, 0)
            return
        end
        if HVC.tryGetInventoryItem({user_id,"mdma", 1, true}) then
            local GangName, commission = HVCTurfs.GetTurfOwnerCommission({3})
            print("MDMA Commission " ..commission.. "%") 
            if commission ~= 0 then
                local leftover1 = (8250*4) * commission / 100
                local leftover = (8250*4) - leftover1
                local gangamount = leftover * 0.35

                if leftover < 0 then
                    leftover = 8250*4
                end
                HVCTurfs.ModifyGangFundsSV({"Give", GangName, gangamount})
                HVC.giveMoney({user_id, leftover})
                HVCclient.notify(source, {"~g~Sold 1 MDMA For £" ..leftover})
                TriggerEvent('HVC:RefreshInventory', source)
            else
                HVC.giveMoney({user_id, 8250*4})
                HVCclient.notify(source, {"~g~Sold 1 MDMA For £32,000"})
                TriggerEvent('HVC:RefreshInventory', source)
            end
        else
            HVCclient.notify(source, {"~r~You do not have enough MDMA!"})
        end
    end
end


function HVCDrugsServer.SellMeth()
    if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Meth.Sell.x, Drugs.Meth.Sell.y, Drugs.Meth.Sell.z), 5.00) then
        local source = source
        local user_id = HVC.getUserId({source})
        if GetPlayerRoutingBucket(source) ~= 0 then
            HVCclient.notify(source, {"~r~You have been returned back to original bucket, do not exploit!"})
            SetPlayerRoutingBucket(source, 0)
            return
        end
        if HVC.tryGetInventoryItem({user_id,"meth", 1, true}) then
            local GangName, commission = HVCTurfs.GetTurfOwnerCommission({2})
            print("Meth Commission " ..commission.. "%") 
            if commission ~= 0 then
                local leftover1 = (5500*4) * commission / 100
                local leftover = (5500*4) - leftover1
                local gangamount = leftover * 0.35

                if leftover < 0 then
                    leftover = 5500*4
                end
                HVCTurfs.ModifyGangFundsSV({"Give", GangName, gangamount})
                HVC.giveMoney({user_id, leftover})
                HVCclient.notify(source, {"~g~Sold 1 Meth For £" ..leftover})
                TriggerEvent('HVC:RefreshInventory', source)
            else
                HVC.giveMoney({user_id, 5500*4})
                HVCclient.notify(source, {"~g~Sold 1 Meth For £22,000"})
                TriggerEvent('HVC:RefreshInventory', source)
            end
        else
            HVCclient.notify(source, {"~r~You do not have enough Meth!"})
        end        
    end
end



function HVCDrugsServer.SellDMT()
    if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.DMT.Sell.x, Drugs.DMT.Sell.y, Drugs.DMT.Sell.z), 5.00) then
        local source = source
        local user_id = HVC.getUserId({source})
        if GetPlayerRoutingBucket(source) ~= 0 then
            HVCclient.notify(source, {"~r~You have been returned back to original bucket, do not exploit!"})
            SetPlayerRoutingBucket(source, 0)
            return
        end
        if HVC.tryGetInventoryItem({user_id,"dmt", 1, true}) then
            local GangName, commission = HVCTurfs.GetTurfOwnerCommission({5})
            print("DMT Commission " ..commission.. "%") 
            if commission ~= 0 then
                local leftover1 = (30000*4) * commission / 100
                local leftover = (30000*4) - leftover1
                local gangamount = leftover * 0.35

                if leftover < 0 then
                    leftover = 30000*4
                end
                HVCTurfs.ModifyGangFundsSV({"Give", GangName, gangamount})
                HVC.giveMoney({user_id, leftover})
                HVCclient.notify(source, {"~g~Sold 1 DMT For £" ..leftover})
                TriggerEvent('HVC:RefreshInventory', source)
            else
                HVC.giveMoney({user_id, 30000*4})
                HVCclient.notify(source, {"~g~Sold 1 DMT For £120,000"})
                TriggerEvent('HVC:RefreshInventory', source)
            end
        else
            HVCclient.notify(source, {"~r~You do not have enough DMT!"})
        end
    end
end
  
function HVCDrugsServer.SellLSD()
    if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.LSD.Sell.x, Drugs.LSD.Sell.y, Drugs.LSD.Sell.z), 5.00) then
        local source = source
        local user_id = HVC.getUserId({source})
        if GetPlayerRoutingBucket(source) ~= 0 then
            HVCclient.notify(source, {"~r~You have been returned back to original bucket, do not exploit!"})
            SetPlayerRoutingBucket(source, 0)
            return
        end
        if HVC.tryGetInventoryItem({user_id,"lsd", 1, true}) then
            local GangName, commission = HVCTurfs.GetTurfOwnerCommission({1})
            print("LSD Commission " ..commission.. "%") 
            if commission ~= 0 then
                local leftover1 = (20000*4) * commission / 100
                local leftover = (20000*4) - leftover1
                local gangamount = leftover * 0.35

                if leftover < 0 then
                    leftover = 20000*4
                end
                HVCTurfs.ModifyGangFundsSV({"Give", GangName, gangamount})
                HVC.giveMoney({user_id, leftover})
                HVCclient.notify(source, {"~g~Sold 1 LSD For £" ..leftover})
                TriggerEvent('HVC:RefreshInventory', source)
            else
                HVC.giveMoney({user_id, 20000*4})
                HVCclient.notify(source, {"~g~Sold 1 LSD For £80,000"})
                TriggerEvent('HVC:RefreshInventory', source)
            end
        else
            HVCclient.notify(source, {"~r~You do not have enough LSD!"})
        end
    end
end

  
function HVCDrugsServer.SellWeed()
    if HVCDrugsServer.IsPlayerNearCoords(source, vector3(Drugs.Weed.Sell.x, Drugs.Weed.Sell.y, Drugs.Weed.Sell.z), 5.00) then
        local source = source
        local user_id = HVC.getUserId({source})
        if GetPlayerRoutingBucket(source) ~= 0 then
            HVCclient.notify(source, {"~r~You have been returned back to original bucket, do not exploit!"})
            SetPlayerRoutingBucket(source, 0)
            return
        end
        if HVC.tryGetInventoryItem({user_id,"weed", 1, true}) then
            local GangName, commission = HVCTurfs.GetTurfOwnerCommission({6})
            -- print(commission)
            if commission ~= 0 then
                local leftover1 = (1750*4) * commission / 100
                local leftover = (1750*4) - leftover1
                local gangamount = leftover * 0.35

                if leftover < 0 then
                    leftover = 1750*4
                end
                HVCTurfs.ModifyGangFundsSV({"Give", GangName, gangamount})
                HVC.giveMoney({user_id, leftover})
                HVCclient.notify(source, {"~g~Sold 1 Weed For £" ..leftover})
                TriggerEvent('HVC:RefreshInventory', source)
            else
                HVC.giveMoney({user_id, 1750*4})
                HVCclient.notify(source, {"~g~Sold 1 Weed For £7,000"})
                TriggerEvent('HVC:RefreshInventory', source)
            end
        else
            HVCclient.notify(source, {"~r~You do not have enough Weed!"})
        end
    end
end
  

Legals = {
    {"Gold", 24000, "gold"},
    {"Iron", 6000, "iron"},
    {"Coal", 4000, "coal"},
    {"Diamond", 40000, "diamonds"},
    {"Oil", 74000, "oil"},
}

RegisterServerEvent("HVC:SellLegals")
AddEventHandler("HVC:SellLegals", function(Name)
    for k,v in pairs(Legals) do
        if Name == v[1] then
            if HVCDrugsServer.IsPlayerNearCoords(source,vector3(Drugs.LegalTrader.Sell.x,Drugs.LegalTrader.Sell.y, Drugs.LegalTrader.Sell.z),5.00)  then
                local source = source
                local user_id = HVC.getUserId({source})
                if GetPlayerRoutingBucket(source) ~= 0 then
                    HVCclient.notify(source, {"~r~You have been returned back to original bucket, do not exploit!"})
                    SetPlayerRoutingBucket(source, 0)
                    return
                end
                if HVC.tryGetInventoryItem({user_id, v[3], 1, true}) then
                    HVCclient.notify(source, {"~g~Sold 1 "..v[1].." For £" ..v[2]})
                    TriggerEvent('HVC:RefreshInventory', source)
                    HVC.giveBankMoney({user_id, tonumber(v[2])})
                else
                    HVCclient.notify(source, {"~r~You do not have enough "..v[1]" !"})
                end
            end
        end
    end
end)







ItemsBMs = {
    {"Gold Bar", 75000, "goldbar"},
    {"Diamond Bar", 200000, "diamondbar"},
    {"Cocaine Pouch", 150000, "coke_pooch"},
    {"Shiny Pogo Statue", 250000, "vanPogo"},
    {"Shiny Diamond", 200000, "vanDiamond"},
    {"Shiny Panther Statue", 250000, "vanPanther"},
    {"Shiny Necklace", 200000, "vanNecklace"},
    {"Shiny Bottle", 225000, "vanBottle"},
    {"Precious Painting 1", 125000, "paintingf"},
    {"Precious Painting 2", 125000, "paintingg"},
}

RegisterServerEvent("HVC:SellBlackMarketItems")
AddEventHandler("HVC:SellBlackMarketItems", function(Name)
    print()
    for k,v in pairs(ItemsBMs) do
        if tostring(Name) == tostring(v[1]) then
            if HVCDrugsServer.IsPlayerNearCoords(source,vector3(Drugs.BMsTrader.Sell.x,Drugs.BMsTrader.Sell.y, Drugs.BMsTrader.Sell.z),5.00)  then
                local source = source
                local user_id = HVC.getUserId({source})

                if GetPlayerRoutingBucket(source) ~= 0 then
                    HVCclient.notify(source, {"~r~You have been returned back to original bucket, do not exploit!"})
                    SetPlayerRoutingBucket(source, 0)
                    return
                end

                if HVC.tryGetInventoryItem({user_id, v[3], 1, true}) then
                    HVCclient.notify(source, {"~g~Sold 1 "..v[1].." For £" ..v[2]})
                    TriggerEvent('HVC:RefreshInventory', source)
                    HVC.giveMoney({user_id, tonumber(v[2])})
                else
                    HVCclient.notify(source, {"~r~You do not have enough "..v[1]" !"})
                end
            end
        end
    end
end)
