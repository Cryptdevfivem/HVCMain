local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVCRageUIMenus")

local PayPerRev = 10000;

RegisterServerCallback("HVC:FetchNHSPermission", function(source)
    local UserID = HVC.getUserId({source})
    if HVC.hasPermission({UserID, "emscheck.revive"}) then
        return true;
    else
        return false;
    end
end)

RegisterServerCallback("HVC:CPRPlayer", function(source)
    local UserID = HVC.getUserId({source})
    if HVC.hasPermission({UserID, "emscheck.revive"}) then
        HVCclient.getNearestPlayer(source, {10}, function(nplayer)
            if nplayer ~= nil then
                HVCclient.isInComa(nplayer,{}, function(in_coma)
                    if in_coma then
                        local MainPed = GetPlayerPed(source)
                        local TargetPed = GetPlayerPed(nplayer)
                        TaskPlayAnim(MainPed, "mini@cpr@char_a@cpr_str" ,"cpr_pumpchest" ,8.0, -8.0, -1, 1, 0, false, false, false)
                        Wait(7000) -- 7 seconds wait
                        TriggerEvent("HVC:ProvideHealth", nplayer, 200)
                        HVCclient.setEffectMeds(nplayer)
                        ClearPedTasks(TargetPed)
                        ClearPedTasks(MainPed)
                        HVC.giveBankMoney({UserID,PayPerRev})
                        HVCclient.notify(source,{"~g~You have saved " ..GetPlayerName(nplayer).. "'s life."})
                        return true;
                    else
                        HVCclient.notify(source,{"~r~Player is not in a coma."})
                        return false;
                    end
                end)
            else
                HVCclient.notify(source,{"~r~No Player nearby"})
                return false;
            end
        end)
    else
        local CurrentTime = os.time() + (60 * 60 * 500000)
        HVC.BanUser({source, "Executor(NHS Event)", CurrentTime, "HVC"})
    end
end)





