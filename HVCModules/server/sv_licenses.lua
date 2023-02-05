local Tunnel = module('hvc', 'lib/Tunnel')
local Proxy = module('hvc', 'lib/Proxy')
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "GroupMenu")


RegisterServerEvent('HVC:GetGroups')
AddEventHandler('HVC:GetGroups',function()
    local source = source
    local user_id = HVC.getUserId({source})
    local GroupsL = {}
 
    if HVC.hasGroup({user_id, "mdma"}) then
        GroupsL["MDMA"] = true;
    end
    if HVC.hasGroup({user_id, "gold"}) then
        GroupsL["Gold"] = true;
    end
    if HVC.hasGroup({user_id, "gang"}) then
        GroupsL["Gang"] = true;
    end
    if HVC.hasGroup({user_id, "coke"}) then
         GroupsL["Coke"] = true;
    end
    if HVC.hasGroup({user_id, "Iron"}) then
        GroupsL["Iron"] = true;
    end
    if HVC.hasGroup({user_id, "weed"}) then
        GroupsL["Weed"] = true;
    end
    if HVC.hasGroup({user_id, "coal"}) then
        GroupsL["Coal"] = true;
    end
    if HVC.hasGroup({user_id, "diamond"}) then
        GroupsL["Diamond"] = true;
    end
    if HVC.hasGroup({user_id, "heroin"}) then
        GroupsL["Heroin"] = true;
    end
    if HVC.hasGroup({user_id, "ethereum"}) then
        GroupsL["Ethereum"] = true;
    end
    if HVC.hasGroup({user_id, "rebel"}) then
         GroupsL["Rebel"] = true;
    end
    if HVC.hasGroup({user_id, "lsd"}) then
        GroupsL["LSD"] = true;
     end
    if HVC.hasGroup({user_id, "oil"}) then
        GroupsL["Oil"] = true;
    end
    if HVC.hasGroup({user_id, "dmt"}) then
        GroupsL["DMT"] = true;
    end
    TriggerClientEvent('GroupMenu:ReturnGroups', source, GroupsL)
end)