	require "resources/essentialmode/lib/MySQL"
	MySQL:open(database.host, database.name, database.username, database.password)

	RegisterServerEvent('pecheur:Car')
	AddEventHandler('pecheur:Car', function()
		TriggerClientEvent('pecheur:getCar',source)
	end)
	
		RegisterServerEvent('pecheur:Car2')
	AddEventHandler('pecheur:Car2', function()
		TriggerClientEvent('pecheur:getCar2',source)
	end)

	RegisterServerEvent('pecheur:serverRequest')
	AddEventHandler('pecheur:serverRequest', function (typeRequest)
		TriggerEvent ('es:getPlayerFromId', source, function(user)
			local player = user.identifier
			
			if typeRequest == "GetPoisson" then
			
				local query = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=21 AND user_id='@identifier'", {['@identifier'] = player})
				local result = MySQL:getResults(query, { 'quantity' })
				local qte
				for _, v in ipairs(result) do
					qte = v.quantity
				end
				TriggerClientEvent('pecheur:drawGetPoisson',source,qte)

			elseif typeRequest == "GetFilet" then
			
				local queryBois = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=21 AND user_id='@identifier'", {['@identifier'] = player})
				local resultBois = MySQL:getResults(queryBois, { 'quantity' })
				local qteBois
				for _, v in ipairs(resultBois) do
					qteBois = v.quantity
				end

				local queryPlanche = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=22 AND user_id='@identifier'", {['@identifier'] = player})
				local resultPlanche = MySQL:getResults(queryPlanche, { 'quantity' })
				local qtePlanche
				for _, v in ipairs(resultPlanche) do
					qtePlanche = v.quantity
				end
				TriggerClientEvent('pecheur:drawGetFilet',source,qteBois, qtePlanche)

			elseif typeRequest == "SellFilet" then
			
				local query = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=22 AND user_id='@identifier'", {['@identifier'] = player})
				local result = MySQL:getResults(query, { 'quantity' })
				local qte
				for _, v in ipairs(result) do
					qte = v.quantity
				end
				TriggerClientEvent('pecheur:drawSellFilet',source,qte)
			else
				print('DEBUG : Une erreur de type de requête à été détecté')
			end
			
		end)
	end)
	
		
RegisterServerEvent('pecheur:setService')
AddEventHandler('pecheur:setService', function (inService)
	TriggerEvent('es:getPlayerFromId', source , function (Player)
		Player:setSessionVar('pecheurInService', inService)
	end)
end)