require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "tprp")


function nameJob(player)
  local executed_query = MySQL:executeQuery("SELECT identifier, job_id, job FROM users LEFT JOIN jobs ON jobs.job_id = users.job WHERE users.identifier = '@identifier'", {['@identifier'] = player})
  local result = MySQL:getResults(executed_query, {'job'}, "identifier")
  return tostring(result[1].job)
end



RegisterServerEvent('delivery:checkjob')
AddEventHandler('delivery:checkjob', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier

    if user.job >= 1 then --here you change the jobname (from your database)
      TriggerClientEvent('yesdelivery', source)
    else
      TriggerClientEvent('nodelivery', source)
    end
  end)
end)

RegisterServerEvent('delivery:checkjob2')
AddEventHandler('delivery:checkjob2', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier

    if user.job >= 1 then --here you change the jobname (from your database)
      TriggerClientEvent('yesdelivery2', source)
    else
      TriggerClientEvent('nodelivery2', source)
    end
  end)
end)

RegisterServerEvent('delivery:checkjob3')
AddEventHandler('delivery:checkjob3', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier

    if user.job >= 1 then --here you change the jobname (from your database)
      TriggerClientEvent('yesdelivery3', source)
    else
      TriggerClientEvent('nodelivery3', source)
    end
  end)
end)

RegisterServerEvent('delivery:checkjob4')
AddEventHandler('delivery:checkjob4', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier

    if user.job >= 1 then --here you change the jobname (from your database)
      TriggerClientEvent('yesdelivery4', source)
    else
      TriggerClientEvent('nodelivery4', source)
    end
  end)
end)

RegisterServerEvent('delivery:checkjob5')
AddEventHandler('delivery:checkjob5', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier

    if user.job >= 1 then --here you change the jobname (from your database)
      TriggerClientEvent('yesdelivery5', source)
    else
      TriggerClientEvent('nodelivery5', source)
    end
  end)
end)

--Essential payment functions 

RegisterServerEvent('delivery:success')
AddEventHandler('delivery:success', function(price)
 print("Player ID " ..source)
	-- Get the players money amount
TriggerEvent('es:getPlayerFromId', source, function(user)
 total = price;
 -- update player money amount
 user:addMoney((total))
 end)
end)

RegisterServerEvent("delivery:rmoney")
AddEventHandler("delivery:rmoney", function(money)
   TriggerEvent('es:getPlayerFromId', source, function(user)
        user:removeMoney(money)
    end)
end)