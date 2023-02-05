local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
cop = {}
nhs = {}

RegisterServerEvent("HVC:ENABLEBLIPS")
AddEventHandler("HVC:ENABLEBLIPS", function()
  local user_id = HVC.getUserId({source})
  if HVC.hasPermission({user_id, "police.menu"}) or HVC.hasPermission({user_id, "emergency.vehicle"}) then
    TriggerClientEvent("HVC:BLIPS",source,cop,nhs)
  end
end)

Citizen.CreateThread(function()
  while true do
    Wait(10000)
    cop = {}
    nhs = {}
    local players = GetPlayers()
    for i,v in pairs(players) do
      name = GetPlayerName(v)
      local  user_id = HVC.getUserId({v})
      if user_id ~= nil then
        local coords = GetPlayerPed(v)

        if HVC.hasPermission({user_id, "police.menu"}) then
          cop[user_id] = {coords,v}
        end

        if HVC.hasPermission({user_id, "emergency.vehicle"}) then
          nhs[user_id] = {coords,v}
        end
      end
    end
  end
end)