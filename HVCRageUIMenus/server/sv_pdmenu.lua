local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVCRageUIMenus")

RegisterServerCallback("HVC:FetchPolicePermission", function(source)
    local UserID = HVC.getUserId({source})
    if HVC.hasPermission({UserID, "police.menu"}) then
        return true;
    else
        return false;
    end
end)


