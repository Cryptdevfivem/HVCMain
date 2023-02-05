-- HVC TUNNEL/PROXY
Tunnel = module("hvc", "lib/Tunnel")
Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC","HVC_Drugs")

-- RESOURCE TUNNEL/PROXY
HVCDrugsServer = {}
Tunnel.bindInterface("HVC_Drugs",HVCDrugsServer)
Proxy.addInterface("HVC_Drugs",HVCDrugsServer)
HVCDrugsClient = Tunnel.getInterface("HVC_Drugs","HVC_Drugs")

function HVCDrugsServer.IsPlayerNearCoords(source, coords, radius)
  local distance = #(GetEntityCoords(GetPlayerPed(source)) - coords)
  if distance < (radius + 0.00001) then
    return true
  end
  return false
end
