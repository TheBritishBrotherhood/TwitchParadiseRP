require "resources/mysql-async/lib/MySQL"

RegisterServerEvent('CheckMoneyForVeh')

function getPlayerID(source)
	return getIdentifiant(GetPlayerIdentifiers(source))
end

function getIdentifiant(id)
	for _, v in ipairs(id) do
		return v
	end
end

function updateVeh(vehicle)
	MySQL.Async.execute("UPDATE users SET personalvehicle=@vehicle WHERE identifier=@identifier ", 
		{['@identifier'] = getPlayerID(source),['@vehicle'] = vehicle}, function(data)
	end)
end


AddEventHandler('CheckMoneyForVeh', function(vehicle, price)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if user.money >= price then
			user:removeMoney((price))
			updateVeh(vehicle)
			TriggerClientEvent('FinishMoneyCheckForVeh',source)
			exports.pNotify:SendNotification({text = "Great choice, Now go register your vehicle at the big red P!", type = "success", queue = "left", timeout = 4000, layout = "centerRight"})
			--TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Great choice, Now go register your vehicle at the big red P!\n")
		else 
			exports.pNotify:SendNotification({text = "Cars aren't free...!", type = "error", queue = "left", timeout = 3000, layout = "centerRight"})
			--TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Car's arn't free...!\n")
		end
	end)
end)