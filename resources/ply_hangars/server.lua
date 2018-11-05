--[[Info]]--

require "resources/mysql-async/lib/MySQL"



--[[Register]]--

RegisterServerEvent('ply_hangars:CheckForSpawnPlane')
RegisterServerEvent('ply_hangars:CheckForPlane')
RegisterServerEvent('ply_hangars:SetPlaneOut')
RegisterServerEvent('ply_hangars:CheckHangarForPlane')
RegisterServerEvent('ply_hangars:CheckForSelPlane')
RegisterServerEvent('ply_hangars:Lang')



--[[Function]]--

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

function planePlate(plate)  
  local plate = plate
  local user = getPlayerID(source)
  return MySQL.Sync.fetchScalar("SELECT plane_plate FROM user_plane WHERE identifier=@identifier AND plane_plate=@plate",{['@identifier'] = user, ['@plate'] = plate})
end

function planePrice(plate)  
  local plate = plate
  local user = getPlayerID(source)
  return MySQL.Sync.fetchScalar("SELECT plane_price FROM user_plane WHERE identifier=@identifier AND plane_plate=@plate",{['@identifier'] = user, ['@plate'] = plate})
end



--[[Local/Global]]--

planes = {}



--[[Events]]--


--Langage
AddEventHandler('ply_hangars:Lang', function(lang)
  local lang = lang
  if lang == "FR" then
    state_in = "Rentré"
    state_out = "Sortit"
  elseif lang =="EN" then
    state_in = "In"
    state_out = "Out"
  end
end)


--Hangar

AddEventHandler('ply_hangars:CheckForSpawnPlane', function(plane_id)
    local plane_id = plane_id
    local user = getPlayerID(source)
    MySQL.Async.fetchAll("SELECT * FROM user_plane WHERE identifier = @identifier AND id = @id",{['@identifier'] = user, ['@id'] = plane_id}, function(data)
        TriggerClientEvent('ply_hangars:SpawnPlane', source, data[1].plane_model, data[1].plane_plate, data[1].plane_state, data[1].plane_colorprimary, data[1].plane_colorsecondary, data[1].plane_pearlescentcolor, data[1].plane_wheelcolor)
    end)
end)

AddEventHandler('ply_hangars:CheckForPlane', function(plate)
  local plate = plate
  local state = state_out
  local user = getPlayerID(source)
  local plane_plate = tostring(planePlate(plate))
  if plane_plate == plate then   
    local state = state_in
    MySQL.Sync.execute("UPDATE user_plane SET plane_state=@state WHERE identifier=@identifier AND plane_plate=@plate",{['@identifier'] = user, ['@state'] = state, ['@plate'] = plate})
    TriggerClientEvent('ply_hangars:StorePlaneTrue', source)
  else
    TriggerClientEvent('ply_hangars:StorePlaneFalse', source)
  end
end)

AddEventHandler('ply_hangars:SetPlaneOut', function(plane, plate)
    local user = getPlayerID(source)
    local plane = plane
    local state = state_out
    local plate = plate
    MySQL.Sync.execute("UPDATE user_plane SET plane_state=@state WHERE identifier=@identifier AND plane_plate=@plate AND plane_model=@plane",{['@identifier'] = user, ['@plane'] = plane, ['@state'] = state, ['@plate'] = plate})
end)

AddEventHandler('ply_hangars:CheckForSelPlane', function(plate)
  local plate = plate
  local state = state_out
  local user = getPlayerID(source)
  local plane_plate = tostring(planePlate(plate))
  local plane_price = planePrice(plate)
  if plane_plate == plate then 
    local plane_price = plane_price / 2
    TriggerEvent('es:getPlayerFromId', source, function(user)
      user:addMoney((plane_price))
    end)
    MySQL.Sync.execute("DELETE from user_plane WHERE identifier=@identifier AND plane_plate=@plate", {['@identifier'] = user, ['@plate'] = plate})
    TriggerClientEvent('ply_hangars:SelPlaneTrue', source)
  else
    TriggerClientEvent('ply_hangars:SelPlaneFalse', source)
  end
end)


-- Base

AddEventHandler('ply_hangars:CheckHangarForPlane', function()
    planes = {}
    local user = getPlayerID(source)
    MySQL.Async.fetchAll("SELECT * FROM user_plane WHERE identifier=@identifier",{['@identifier'] = user}, function(data)
      for _, v in ipairs(data) do
          t = { ["id"] = v.id, ["plane_model"] = v.plane_model, ["plane_name"] = v.plane_name, ["plane_state"] = v.plane_state}
          table.insert(planes, tonumber(v.id), t)
      end
      TriggerClientEvent('ply_hangars:getPlane', source, planes)
    end)
end)

AddEventHandler('playerConnecting', function()
  local player_state = 1
  MySQL.Async.fetchAll("SELECT * FROM users WHERE player_state=@player_state",{['@player_state'] = player_state}, function(data)
    for i,v in ipairs(data) do
      sum = sum + v.player_state
    end
    sum = 0
    if (sum < 1) then
      local old_state = state_out
      local state = state_in
      MySQL.Sync.execute("UPDATE user_plane SET plane_state=@state WHERE plane_state=@old_state", {['@old_state'] = old_state, ['@state'] = state})
    end
  end)
end)

AddEventHandler('playerSpawn', function()
    local user = getPlayerID(source)
    local player_state = "1"
    MySQL.Sync.execute("UPDATE users SET player_state=@player_state WHERE identifier=@identifier",{['@identifier'] = user, ['@player_state'] = player_state})
end)

AddEventHandler('playerDropped', function()
    local user = getPlayerID(source)
    local player_state = "0"
    MySQL.Sync.execute("UPDATE users SET player_state=@player_state WHERE identifier=@identifier",{['@identifier'] = user, ['@player_state'] = player_state})
end)