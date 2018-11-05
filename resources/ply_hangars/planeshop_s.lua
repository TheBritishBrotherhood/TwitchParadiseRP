--[[Info]]--

require "resources/mysql-async/lib/MySQL"



--[[Register]]--

RegisterServerEvent('ply_hangars:CheckMoneyForPlane')
RegisterServerEvent('ply_hangars:BuyForPlane')
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


--Shop

AddEventHandler('ply_hangars:CheckMoneyForPlane', function(name, plane, price)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local price = price
    if (tonumber(user.money) >= tonumber(price)) then
      local player = user.identifier
      local plane = plane
      local name = name
        user:removeMoney((price))
      TriggerClientEvent('ply_hangars:FinishMoneyCheckForPlane',source, name, plane, price)
      TriggerClientEvent('ply_hangars:BuyTrue', source)
    else
      TriggerClientEvent('ply_hangars:BuyFalseTrue', source)
    end
  end)
end)

AddEventHandler('ply_hangars:BuyForPlane', function(name, plane, price, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
    local user = getPlayerID(source)
    local name = name
    local price = price
    local plane = plane
    local plate = plate
    --local state = state_out
    local state = "Sortit"
    local primarycolor = primarycolor
    local secondarycolor = secondarycolor
    local pearlescentcolor = pearlescentcolor
    local wheelcolor = wheelcolor

    MySQL.Async.execute("INSERT INTO user_plane (identifier,plane_name,plane_model,plane_price,plane_plate,plane_state,plane_colorprimary,plane_colorsecondary,plane_pearlescentcolor,plane_wheelcolor) VALUES (@username,@name,@plane,@price,@plate,@state,@primarycolor,@secondarycolor,@pearlescentcolor,@wheelcolor)",
    {['@username'] = user, ['@name'] = name, ['@plane'] = plane, ['@price'] = price, ['@plate'] = plate, ['@state'] = state, ['@primarycolor'] = primarycolor, ['@secondarycolor'] = secondarycolor, ['@pearlescentcolor'] = pearlescentcolor, ['@wheelcolor'] = wheelcolor}, function(data)
    end)
end)