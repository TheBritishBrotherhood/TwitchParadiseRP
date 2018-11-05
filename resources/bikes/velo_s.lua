RegisterServerEvent('velo:CheckMoneyForVel')

AddEventHandler('velo:CheckMoneyForVel', function(name, vehicle, price)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local vehicle = vehicle
    local name = name
    local price = tonumber(price)

        if (tonumber(user.money) >= tonumber(price)) then
          user:removeMoney((price))
          TriggerClientEvent('velo:FinishMoneyCheckForVel', source, name, vehicle, price)
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Ride safe, Dont forget your helmet!\n")
        else
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Not enough cash!\n")
       end
    end)
end)