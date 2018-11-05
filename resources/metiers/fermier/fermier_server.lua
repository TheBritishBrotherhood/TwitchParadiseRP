	require "resources/essentialmode/lib/MySQL"
	MySQL:open(database.host, database.name, database.username, database.password)

	RegisterServerEvent('fermier:Car')
	AddEventHandler('fermier:Car', function()
		TriggerClientEvent('fermier:getCar',source)
	end)

	RegisterServerEvent('fermier:serverRequest')
	AddEventHandler('fermier:serverRequest', function (typeRequest)
		TriggerEvent ('es:getPlayerFromId', source, function(user)
			local player = user.identifier
			
			if typeRequest == "GetBle" then
				local query = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=10 AND user_id='@identifier'", {['@identifier'] = player})
				local result = MySQL:getResults(query, { 'quantity' })
				local qte
				for _, v in ipairs(result) do
					qte = v.quantity
				end
				TriggerClientEvent('fermier:drawGetBle',source,qte)
				
			elseif typeRequest == "GetFarine" then
			
				local queryBle = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=10 AND user_id='@identifier'", {['@identifier'] = player})
				local resultBle = MySQL:getResults(queryBle, { 'quantity' })
				local qteBle
				for _, v in ipairs(resultBle) do
					qteBle = v.quantity
				end
				local queryFarine = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=5 AND user_id='@identifier'", {['@identifier'] = player})
				local resultFarine = MySQL:getResults(queryFarine, { 'quantity' })
				local qteFarine
				for _, v in ipairs(resultFarine) do
					qteFarine = v.quantity
				end
				TriggerClientEvent('fermier:drawGetFarine',source,qteBle,qteFarine)
				
			elseif typeRequest == "SellFarine" then
			
				local query = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=5 AND user_id='@identifier'", {['@identifier'] = player})
				local result = MySQL:getResults(query, { 'quantity' })
				local qte
				for _, v in ipairs(result) do
					qte = v.quantity
				end
				TriggerClientEvent('fermier:drawSellFarine',source,qte)
				
			else
				print('DEBUG : Une erreur de type de requête à été détecté')
			end
		end)
	end)
	
RegisterServerEvent('fermier:setService')
AddEventHandler('fermier:setService', function (inService)
	TriggerEvent('es:getPlayerFromId', source , function (Player)
		Player:setSessionVar('fermierInService', inService)
	end)
end)