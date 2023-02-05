local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVCRageUIMenus")


RegisterNetEvent("HVC:FetchVehicles")
AddEventHandler("HVC:FetchVehicles", function()
    local source = source
    local UserId = HVC.getUserId({source})
    exports["ghmattimysql"]:execute("SELECT vehicle, vehicle_plate FROM hvc_user_vehicles WHERE user_id = @user_id", {user_id = UserId}, function(Result)
        if #Result > 0 then
           TriggerClientEvent("HVC:ReturnVehicles", source, Result)
        end
    end)
end)

local BlackList = {
    ["nigga"] = {},
    ["paki"] = {},
    ["nigger"] = {},
    ['KKK'] = {},
    ['ape'] = {},
    ['4p3'] = {},
    ['ap3'] = {},
    ['4pe'] = {},
    ['apes'] = {},
    ['n1gg3r'] = {},
    ['n1gger'] = {},
    ['nigg3r'] = {},
    ['nigga'] = {},
    ['n1gga'] = {},
    ['nigg4'] = {},
    ['n1gg4'] = {},
    ['paki'] = {},
    ['pak1'] = {},
    ['p4k1'] = {},
    ['p4ki'] = {},
    ['coon'] = {},
    ['c0on'] = {},
    ['faggot'] = {},
    ['f4gg0t'] = {},
    ['fagg0t'] = {},
    ['f4ggot'] = {},
    ['fag'] = {},
    ['f4g'] = {},
    ['coonie'] = {},
    ['c0onie'] = {},
    ['co0nie'] = {},
    ['c00nie'] = {},
    ['c0on1e'] = {},
    ['co0n1e'] = {},
    ['c0on13'] = {},
    ['co0n13'] = {},
    ['c00n13'] = {},
    ['coony'] = {},
    ['c0ony'] = {},
    ['co0ny'] = {},
    ['c00ny'] = {},
    ['wog'] = {},
    ['c00n'] = {},
    ['co0n'] = {},
    ['c0on'] = {},
    ['wogchamp'] = {},
    ['woggers'] = {},
    ['chink'] = {},
    ['gay'] = {},
    ['g4y'] = {},
    ['s4ndcoon'] = {},
    ['s4ndc0on'] = {},
    ['s4ndco0n'] = {},
    ['s4ndc00n'] = {},
    ['sandc0on'] = {},
    ['sandco0n'] = {},
    ['sandcoon'] = {},
    ['niggas'] = {},
    ['niggass'] = {},
    ['niggass'] = {},
    ['nigas'] = {},
    ['nigass'] = {},
    ['nigasss'] = {},
    ['nigassss'] = {},
    ['nigaa'] = {},
    ['nigaaa'] = {},
    ['nigaaaa'] = {},
    ['nigaaaaa'] = {},
    ['niggaa'] = {},
    ['niggaaa'] = {},
    ['niggaaaa'] = {}, --can init bans in table if needed
}

RegisterNetEvent("HVC:LicensePlateChange")
AddEventHandler("HVC:LicensePlateChange", function(spawn)
    local source = source
    local UserId = HVC.getUserId({source})
    HVC.prompt({source, "What would you like to change your license plate to.","",function(player, license)
        local Lower = string.lower(license)
        local Check = BlackList[Lower]
        local Table = {}
        if Check then
            HVCclient.notify(source,{'~r~Blacklisted word found.'})
        else
            exports["ghmattimysql"]:execute("SELECT vehicle_plate FROM hvc_user_vehicles", function(Result)
                for k,v in pairs(Result) do
                    Table[v.vehicle_plate] = {}
                end
                if Table[license] then
                    HVCclient.notify(source,{'~r~This license is already owned.'})
                else
                    if #license < 8 then
                        if HVC.tryBankPayment({UserId,50000}) then
                            exports['ghmattimysql']:execute("update hvc_user_vehicles set vehicle_plate = @result where user_id = @user_id and vehicle = @vehicle" , {result = license, user_id = UserId, vehicle = spawn}, function()
                                HVCclient.notify(source,{'~g~You have successfully bought a customised license plate for £50K!'})
                            end)
                        else
                            HVCclient.notify(source,{'~r~License plate changes cost £50,000'})
                        end
                    else
                        HVCclient.notify(source,{'~r~License plates must be 8 characters'})
                    end
                end
            end)
        end
    end})
end)
