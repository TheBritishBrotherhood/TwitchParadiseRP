	require "resources/essentialmode/lib/MySQL"
	MySQL:open(database.host, database.name, database.username, database.password)

	RegisterServerEvent('mineur:Car1')
	AddEventHandler('mineur:Car1', function()
		TriggerClientEvent('mineur:getCar1',source)
	end)

	RegisterServerEvent('mineur:Car2')
	AddEventHandler('mineur:Car2', function()
		TriggerClientEvent('mineur:getCar2',source)
	end)

	RegisterServerEvent('mineur:Car3')
	AddEventHandler('mineur:Car3', function()
		TriggerClientEvent('mineur:getCar3',source)
	end)

	RegisterServerEvent('mineur:serverRequest')
	AddEventHandler('mineur:serverRequest', function (typeRequest)
		TriggerEvent ('es:getPlayerFromId', source, function(user)
			local player = user.identifier
			
			if typeRequest == "GetMinerai" then
			
				local query = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=1 AND user_id='@identifier'", {['@identifier'] = player})
				local result = MySQL:getResults(query, { 'quantity' })
				local qte
				for _, v in ipairs(result) do
					qte = v.quantity
				end
				TriggerClientEvent('mineur:drawGetMinerai', source, qte)
				
			elseif typeRequest == "GetMetal" then
			
				local queryMinerai = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=1 AND user_id='@identifier'", {['@identifier'] = player})
				local resultMinerai = MySQL:getResults(queryMinerai, { 'quantity' })
				local qteMinerai
				for _, v in ipairs(resultMinerai) do
					qteMinerai = v.quantity
				end
				local queryMetal = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=2 AND user_id='@identifier'", {['@identifier'] = player})
				local resultMetal = MySQL:getResults(queryMetal, { 'quantity' })
				local qteMetal
				for _, v in ipairs(resultMetal) do
					qteMetal = v.quantity
				end
				TriggerClientEvent('mineur:drawGetMetal', source, qteMinerai, qteMetal)
				
			elseif typeRequest == "SellMetal" then
			
				local query = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=2 AND user_id='@identifier'", {['@identifier'] = player})
				local result = MySQL:getResults(query, { 'quantity' })
				local qte
				for _, v in ipairs(result) do
					qte = v.quantity
				end
				TriggerClientEvent('mineur:drawSellMetal', source, qte)
				
			else
				print('DEBUG : Une erreur de type de requête à été détecté')
			end
		end)
	end)
	
RegisterServerEvent('mineur:setService')
AddEventHandler('mineur:setService', function (inService)
	TriggerEvent('es:getPlayerFromId', source , function (Player)
		Player:setSessionVar('mineurInService', inService)
	end)
end)
