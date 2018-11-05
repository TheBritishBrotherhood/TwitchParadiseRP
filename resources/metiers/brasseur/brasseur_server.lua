	require "resources/essentialmode/lib/MySQL"
	MySQL:open(database.host, database.name, database.username, database.password)
	
	RegisterServerEvent('brasseur:Car')
	AddEventHandler('brasseur:Car', function()
		TriggerClientEvent('brasseur:getCar',source)
	end)

	RegisterServerEvent('brasseur:serverRequest')
	AddEventHandler('brasseur:serverRequest', function (typeRequest)
		TriggerEvent ('es:getPlayerFromId', source, function(user)
			local player = user.identifier
			
				if typeRequest == "GetOrge" then
					--print("SELECT quantity FROM user_inventory WHERE item_id="..brasseur_ressourceBase.." AND user_id='@identifier'")
					local query = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id="..brasseur_ressourceBase.." AND user_id='@identifier'", {['@identifier'] = player})
					local result = MySQL:getResults(query, { 'quantity' })
					local qte
					for _, v in ipairs(result) do
						qte = v.quantity
					end
					TriggerClientEvent('brasseur:drawGetOrge', source, qte)
					
				elseif typeRequest == "GetBiere" then
					local queryBase = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id="..brasseur_ressourceBase.." AND user_id='@identifier'", {['@identifier'] = player})
					local resultBois = MySQL:getResults(queryBase, { 'quantity' })
					local qteBase
					for _, v in ipairs(resultBois) do
						qteBase = v.quantity
					end

					local queryTraite = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id="..brasseur_ressourceTraite.." AND user_id='@identifier'", {['@identifier'] = player})
					local resultPlanche = MySQL:getResults(queryTraite, {'quantity'})
					local qteTraite
					for _, v in ipairs(resultPlanche) do
						qteTraite = v.quantity
					end
					TriggerClientEvent('brasseur:drawGetBiere',source, qteBase, qteTraite)

				elseif typeRequest == "SellBiere" then
					local query = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id="..brasseur_ressourceTraite.." AND user_id='@identifier'", {['@identifier'] = player})
					local result = MySQL:getResults(query, {'quantity'})
					local qte
					for _, v in ipairs(result) do
						qte = v.quantity
					end
					TriggerClientEvent('brasseur:drawSellBiere', source, qte)
				else
					print('DEBUG : Une erreur de type de requête à été détecté')
				end
			
		end)
	end)

RegisterServerEvent('brasseur:setService')
AddEventHandler('brasseur:setService', function (inService)
	TriggerEvent('es:getPlayerFromId', source , function (Player)
		Player:setSessionVar('brasseurInService', inService)
	end)
end)