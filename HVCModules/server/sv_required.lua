local Tunnel = module("hvc", "lib/Tunnel")
local Proxy = module("hvc", "lib/Proxy")
HVC = Proxy.getInterface("HVC")
HVCclient = Tunnel.getInterface("HVC", "HVCModules")
local Lang = module("hvc", "lib/Lang")
local cfg = module("hvc", "cfg/base")
local lang = Lang.new(module("hvc", "cfg/lang/"..cfg.lang) or {})




RegisterServerEvent("HVC:SearchNearest")
AddEventHandler("HVC:SearchNearest", function()
  local player = source
  HVCclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = HVC.getUserId({nplayer})
    if nuser_id ~= nil then
      HVCclient.notify(nplayer,{"~b~You are being searched!"})
      HVCclient.getWeapons(nplayer,{},function(weapons)
        -- prepare display data (money, items, weapons)
        local money = HVC.getMoney({nuser_id})
        local items = ""
        local data = HVC.getUserDataTable({nuser_id})
        if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item_name = HVC.getItemName({k})
            if item_name then
              items = items.."<br />"..item_name.." ("..v.amount..")"
            end
          end
        end

        local weapons_info = ""
        for k,v in pairs(weapons) do
          weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
        end

        HVCclient.setDiv2(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
        -- request to hide div
        HVC.request({player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
          HVCclient.removeDiv(player,{"police_check"})
        end})
      end)
    else
      HVCclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end)