	require "resources/essentialmode/lib/MySQL"
	MySQL:open(database.host, database.name, database.username, database.password)

	RegisterServerEvent('bucheron:Car')
	AddEventHandler('bucheron:Car', function()
		TriggerClientEvent('bucheron:getCar',source)
	end)

	RegisterServerEvent('bucheron:serverRequest')
	AddEventHandler('bucheron:serverRequest', function (typeRequest)
		TriggerEvent ('es:getPlayerFromId', source, function(user)
			local player = user.identifier
			
				if typeRequest == "GetBois" then
					local query = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=19 AND user_id='@identifier'", {['@identifier'] = player})
					local result = MySQL:getResults(query, { 'quantity' })
					local qte
					for _, v in ipairs(result) do
						qte = v.quantity
					end
					TriggerClientEvent('bucheron:drawGetBois', source, qte)
					
				elseif typeRequest == "GetPlanche" then
					local queryBois = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=19 AND user_id='@identifier'", {['@identifier'] = player})
					local resultBois = MySQL:getResults(queryBois, { 'quantity' })
					local qteBois
					for _, v in ipairs(resultBois) do
						qteBois = v.quantity
					end

					local queryPlanche = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=20 AND user_id='@identifier'", {['@identifier'] = player})
					local resultPlanche = MySQL:getResults(queryPlanche, {'quantity'})
					local qtePlanche
					for _, v in ipairs(resultPlanche) do
						qtePlanche = v.quantity
					end
					TriggerClientEvent('bucheron:drawGetPlanche',source, qteBois, qtePlanche)

				elseif typeRequest == "SellPlanche" then
					local query = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id=20 AND user_id='@identifier'", {['@identifier'] = player})
					local result = MySQL:getResults(query, {'quantity'})
					local qte
					for _, v in ipairs(result) do
						qte = v.quantity
					end
					TriggerClientEvent('bucheron:drawSellPlanche', source, qte)
				else
					print('DEBUG : Une erreur de type de requête à été détecté')
				end
			
		end)
	end)

RegisterServerEvent('bucheron:setService')
AddEventHandler('bucheron:setService', function (inService)
	TriggerEvent('es:getPlayerFromId', source , function (Player)
		Player:setSessionVar('bucheronInService', inService)
	end)
end)