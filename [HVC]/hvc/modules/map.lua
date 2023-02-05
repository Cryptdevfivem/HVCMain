
local client_areas = {}

-- free client areas when leaving
AddEventHandler("HVC:playerLeave",function(user_id,source)
  client_areas[source] = nil 
end)

-- create/update a player area
function HVC.setArea(source,name,x,y,z,radius,height,cb_enter,cb_leave)
  local areas = client_areas[source] or {}
  client_areas[source] = areas

  areas[name] = {enter=cb_enter,leave=cb_leave}
  HVCclient.setArea(source,{name,x,y,z,radius,height})
end

-- delete a player area
function HVC.removeArea(source,name)
  -- delete remote area
  HVCclient.removeArea(source,{name})

  -- delete local area
  local areas = client_areas[source]
  if areas then
    areas[name] = nil
  end
end

-- TUNNER SERVER API

function tHVC.enterArea(name)
  local areas = client_areas[source]
  if areas then
    local area = areas[name] 
    if area and area.enter then -- trigger enter callback
      area.enter(source,name)
    end
  end
end

function tHVC.leaveArea(name)
  local areas = client_areas[source]

  if areas then
    local area = areas[name] 
    if area and area.leave then -- trigger leave callback
      area.leave(source,name)
    end
  end
end


local cfg = module("cfg/blips_markers")

-- add additional static blips/markers
AddEventHandler("HVC:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    for k,v in pairs(cfg.blips) do
      HVCclient.addBlip(source,{v[1],v[2],v[3],v[4],v[5],v[6]})
    end

    for k,v in pairs(cfg.markers) do
      -- HVCclient.addMarker(source,{v[1],v[2],v[3],v[4],v[5],v[6],v[7],v[8],v[9],v[10],v[11]})
    end
  end
end)
