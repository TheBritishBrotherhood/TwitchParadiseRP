require "resources/mysql-async/lib/MySQL"

RegisterServerEvent('playerDropped')
AddEventHandler("cp:spawnplayer", function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
	local player = user.identifier
	local executed_query = MySQL.Async.execute("UPDATE user_vehicle SET `vehicle_state` = @state WHERE identifier = @username",
							{['@state'] = "In", ['@username'] = player})
	end)
 end)