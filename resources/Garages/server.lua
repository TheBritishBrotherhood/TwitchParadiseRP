--[[Info]]--

require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "tprp")



--[[Register]]--

RegisterServerEvent('garages:CheckForSpawnVeh')
RegisterServerEvent('garages:CheckForVeh')
RegisterServerEvent('garages:SetVehOut')
RegisterServerEvent('garages:SetVehIn')
RegisterServerEvent('garages:PutVehInGarages')
RegisterServerEvent('garages:CheckGarageForVeh')
RegisterServerEvent('garages:CheckForSelVeh')
RegisterServerEvent('garages:SelVeh')
RegisterServerEvent('UpdateVeh')
RegisterServerEvent('VehUpdateTyreSmoke')



--[[Local/Global]]--

local vehicles = {}



--[[Events]]--

AddEventHandler('garages:CheckForSpawnVeh', function(veh_id)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local veh_id = veh_id
    local player = user.identifier
    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehicle WHERE identifier = '@username' AND ID = '@ID'",{['@username'] = player, ['@ID'] = veh_id})
    local result = MySQL:getResults(executed_query, {'vehicle_model', 'vehicle_plate', 'vehicle_state', 'vehicle_colorprimary', 'vehicle_colorsecondary', 'vehicle_pearlescentcolor', 'vehicle_wheelcolor' }, "identifier")
    if(result)then
      for k,v in ipairs(result)do
        vehicle = v.vehicle_model
        plate = v.vehicle_plate
        state = v.vehicle_state
        primarycolor = v.vehicle_colorprimary
        secondarycolor = v.vehicle_colorsecondary
        pearlescentcolor = v.vehicle_pearlescentcolor
        wheelcolor = v.vehicle_wheelcolor

      local vehicle = vehicle
      local plate = plate
      local state = state      
      local primarycolor = primarycolor
      local secondarycolor = secondarycolor
      local pearlescentcolor = pearlescentcolor
      local wheelcolor = wheelcolor
      end
    end
    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehmods WHERE plate = '"..plate.."'")
    local result = MySQL:getResults(executed_query, {'plate', 'tyresmoke','mod0', 'mod1','mod2','mod3','mod4','mod5','mod6','mod7','mod8','mod9','mod10','mod11','mod12','mod13','mod14','mod15','mod16','mod17','mod18','mod19','mod20','mod21','mod22','mod23','mod24' }, "ID")
    local tyrecolor = nil
    print("FINDING SMOKE RESULT")
    print (result)
    local mods = {}
    if(result)then
        print("HAVE RESULT")
        for k,v in ipairs(result)do
            print("RESULT#: "..k.." VALUE: "..v)
            tyre = v.tyresmoke
            table.insert(mods, v.mod0)
            table.insert(mods, v.mod1)
            table.insert(mods, v.mod2)
            table.insert(mods, v.mod3)
            table.insert(mods, v.mod4)
            table.insert(mods, v.mod5)
            table.insert(mods, v.mod6)
            table.insert(mods, v.mod7)
            table.insert(mods, v.mod8)
            table.insert(mods, v.mod9)
            table.insert(mods, v.mod10)
            table.insert(mods, v.mod11)
            table.insert(mods, v.mod12)
            table.insert(mods, v.mod13)
            table.insert(mods, v.mod14)
            table.insert(mods, v.mod15)
            table.insert(mods, v.mod16)
            table.insert(mods, v.mod17)
            table.insert(mods, v.mod18)
            table.insert(mods, v.mod19)
            table.insert(mods, v.mod20)
            table.insert(mods, v.mod21)
            table.insert(mods, v.mod22)
            table.insert(mods, v.mod23)
            table.insert(mods, v.mod24)
            tyrecolor = tyre
        end
    end
    TriggerClientEvent('garages:SpawnVehicle', source, vehicle, plate, state, primarycolor, secondarycolor, pearlescentcolor, wheelcolor, tyrecolor, mods)
  end)
end)

AddEventHandler('garages:CheckForVeh', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local state = "Out"
    local player = user.identifier
    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehicle WHERE identifier = '@username' AND vehicle_state ='@state'",{['@username'] = player, ['@vehicle'] = vehicle, ['@state'] = state})
    local result = MySQL:getResults(executed_query, {'vehicle_model', 'vehicle_plate'}, "identifier")
    if(result)then
      for k,v in ipairs(result)do
        vehicle = v.vehicle_model
        plate = v.vehicle_plate
      local vehicle = vehicle
      local plate = plate
      end
    end
    TriggerClientEvent('garages:StoreVehicle', source, vehicle, plate)
  end)
end)

AddEventHandler('garages:SetVehOut', function(vehicle, plate)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local vehicle = vehicle
    local state = "Out"
    local plate = plate

    local executed_query = MySQL:executeQuery("UPDATE user_vehicle SET vehicle_state='@state' WHERE identifier = '@username' AND vehicle_plate = '@plate' AND vehicle_model = '@vehicle'",
      {['@username'] = player, ['@vehicle'] = vehicle, ['@state'] = state, ['@plate'] = plate})
  end)
end)

AddEventHandler('garages:SetVehIn', function(plate)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local plate = plate
    local state = "In"
    local executed_query = MySQL:executeQuery("UPDATE user_vehicle SET vehicle_state='@state' WHERE identifier = '@username' AND vehicle_plate = '@plate'",
      {['@username'] = player, ['@plate'] = plate, ['@state'] = state})
  end)
end)

AddEventHandler('garages:PutVehInGarages', function(vehicle)
  TriggerEvent('es:getPlayerFromId', source, function(user)

    local player = user.identifier
    local state ="In"

    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehicle WHERE identifier = '@username'",{['@username'] = player})
    local result = MySQL:getResults(executed_query, {'identifier'})

    if(result)then
      for k,v in ipairs(result)do
        joueur = v.identifier
        local joueur = joueur
       end
    end

    if joueur ~= nil then

      local executed_query = MySQL:executeQuery("UPDATE user_vehicle SET `vehicle_state`='@state' WHERE identifier = '@username'",
      {['@username'] = player, ['@state'] = state})

    end
  end)
end)

AddEventHandler('garages:CheckGarageForVeh', function()
  vehicles = {}
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier  
    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehicle WHERE identifier = '@username'",{['@username'] = player})
    local result = MySQL:getResults(executed_query, {'id','vehicle_model', 'vehicle_name', 'vehicle_state'}, "id")
    if (result) then
        for _, v in ipairs(result) do
                --print(v.vehicle_model)
                --print(v.vehicle_plate)
                --print(v.vehicle_state)
                --print(v.id)
            t = { ["id"] = v.id, ["vehicle_model"] = v.vehicle_model, ["vehicle_name"] = v.vehicle_name, ["vehicle_state"] = v.vehicle_state}
            table.insert(vehicles, tonumber(v.id), t)
        end
    end
  end)  
    --print(vehicles[1].id)
    --print(vehicles[2].vehicle_model)
    TriggerClientEvent('garages:getVehicles', source, vehicles)
end)

AddEventHandler('garages:CheckForSelVeh', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local state = "Out"
    local player = user.identifier
    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehicle WHERE identifier = '@username' AND vehicle_state ='@state'",{['@username'] = player, ['@vehicle'] = vehicle, ['@state'] = state})
    local result = MySQL:getResults(executed_query, {'vehicle_model', 'vehicle_plate'}, "identifier")
    if(result)then
      for k,v in ipairs(result)do
        vehicle = v.vehicle_model
        plate = v.vehicle_plate
      local vehicle = vehicle
      local plate = plate
      end
    end
    TriggerClientEvent('garages:SelVehicle', source, vehicle, plate)
  end)
end)

AddEventHandler('garages:SelVeh', function(plate)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local plate = plate

    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehicle WHERE identifier = '@username' AND vehicle_plate ='@plate'",{['@username'] = player, ['@vehicle'] = vehicle, ['@plate'] = plate})
    local result = MySQL:getResults(executed_query, {'vehicle_price'}, "identifier")
    if(result)then
      for k,v in ipairs(result)do
        price = v.vehicle_price
      local price = price / 2      
      user:addMoney((price))
      end
    end
    local executed_query = MySQL:executeQuery("DELETE from user_vehicle WHERE identifier = '@username' AND vehicle_plate = '@plate'",
      {['@username'] = player, ['@plate'] = plate})
    TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Vehicle sold!\n")
  end)
end)

AddEventHandler('VehUpdateTyreSmoke', function(plate, colorR, colorG, colorB)
    local cr =  colorR
    local cg = colorG
    local cb = colorB
    local plate = plate
    local executed_query = MySQL:executeQuery("update user_vehmods set tyresmoke='"..cr..","..cg..","..cb.."' where plate='"..plate.."'" )
end)

AddEventHandler('UpdateVeh', function(plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor, mods)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local mods = mods
    local player = user.identifier
    local name = name
    local price = price
    local vehicle = vehicle
    local plate = plate
    local state = "Out"
    local primarycolor = primarycolor
    local secondarycolor = secondarycolor
    local pearlescentcolor = pearlescentcolor
    local wheelcolor = wheelcolor
    local executed_query = MySQL:executeQuery("Update user_vehicle Set vehicle_colorprimary='@primarycolor', vehicle_colorsecondary='@secondarycolor', vehicle_pearlescentcolor='@pearlescentcolor', vehicle_wheelcolor='@wheelcolor' where vehicle_plate='@plate'",
    {['@username'] = player, ['@name'] = name, ['@vehicle'] = vehicle, ['@price'] = price, ['@plate'] = plate, ['@state'] = state, ['@primarycolor'] = primarycolor, ['@secondarycolor'] = secondarycolor, ['@pearlescentcolor'] = pearlescentcolor, ['@wheelcolor'] = wheelcolor})
    for i,t in pairs(mods) do
        print('Attempting to update mods')
        if t.mod ~= nil then
           print("Mod#: "..i.." Value: " .. t.mod)
           local executed_query = MySQL:executeQuery("update user_vehmods set mod"..i.."='"..t.mod.."' where plate='"..plate.."'" )
        end
  end
  end)
end)
