	require "resources/essentialmode/lib/MySQL"
	MySQL:open(database.host, database.name, database.username, database.password)

	RegisterServerEvent('chomeur:serverRequest')
	AddEventHandler('chomeur:serverRequest', function (typeRequest)
		TriggerEvent ('es:getPlayerFromId', source, function(user)
			local player = user.identifier

		end)
	end)
	
	