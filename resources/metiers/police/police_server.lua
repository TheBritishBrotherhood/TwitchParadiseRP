require "resources/essentialmode/lib/MySQL"
MySQL:open(database.host, database.name, database.username, database.password)

local inServiceCops = {}

function addCop(identifier)
	MySQL:executeQuery("INSERT INTO police (`identifier`) VALUES ('@identifier')", { ['@identifier'] = identifier})
end

function remCop(identifier)
	MySQL:executeQuery("DELETE FROM police WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
end

RegisterServerEvent('police:removeCop')
AddEventHandler('police:removeCop', function()
	--print(source)
	TriggerEvent("es:getPlayerFromId", source, function(user)
		local identifier = user.identifier
		--print(identifier)
		MySQL:executeQuery("DELETE FROM police WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
	end)
end)

function checkIsCop(identifier, source)
	local query = MySQL:executeQuery("SELECT * FROM police WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
	local result = MySQL:getResults(query, {'rank'}, "identifier")
	--print("TOTO")
	--print('----Result' .. result[1].rank .. '----')
	if(not result[1]) then
		TriggerClientEvent('police:receiveIsCop', source, "inconnu")
	else
		TriggerClientEvent('police:receiveIsCop', source, result[1].rank)
	end
end

function s_checkIsCop(identifier)
	local query = MySQL:executeQuery("SELECT * FROM police WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
	local result = MySQL:getResults(query, {'rank'}, "identifier")
	
	if(not result[1]) then
		return "nil"
	else
		return result[1].rank
	end
end

function checkInventory(target)
	local strResult = GetPlayerName(target).." possede : "
	local identifier = ""
    TriggerEvent("es:getPlayerFromId", target, function(player)
		local money = player:dirty_money
		strResult = strResult .. money .. " d'argent sale , "
		player:setDirty_Money(0)
		identifier = player.identifier
		local executed_query = MySQL:executeQuery("SELECT * FROM `user_inventory` JOIN items ON items.id = user_inventory.item_id WHERE user_id = '@username'", { ['@username'] = identifier })
		local result = MySQL:getResults(executed_query, { 'quantity', 'libelle', 'item_id', 'isIllegal' }, "item_id")
		if (result) then
			for _, v in ipairs(result) do
				if(v.quantity ~= 0) then
					strResult = strResult .. v.quantity .. " de " .. v.libelle .. ", "
				end
				if(v.isIllegal == "True") then
					TriggerClientEvent('police:dropIllegalItem', target, v.item_id)
				end
			end
		end
		
		strResult = strResult .. " / "
		
		local executed_query = MySQL:executeQuery("SELECT * FROM user_weapons WHERE identifier = '@username'", { ['@username'] = identifier })
		local result = MySQL:getResults(executed_query, { 'weapon_model' }, 'identifier' )
		if (result) then
			for _, v in ipairs(result) do
					strResult = strResult .. "possession de " .. v.weapon_model .. ", "
			end
			TriggerEvent("weaponshop:RemoveWeaponsToPlayer",target)
		end
	end)
	
    return strResult
end

AddEventHandler('playerDropped', function()
	if(inServiceCops[source]) then
		inServiceCops[source] = nil
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

AddEventHandler('es:playerDropped', function(player)
		local isCop = s_checkIsCop(player.identifier)
		if(isCop ~= "nil") then
			--TriggerEvent("jobssystem:disconnectReset", player, 7)
		end
end)

RegisterServerEvent('police:checkIsCop')
AddEventHandler('police:checkIsCop', function()
	--print(source)
	TriggerEvent("es:getPlayerFromId", source, function(user)
		local identifier = user.identifier
		--print(identifier)
		checkIsCop(identifier, source)
	end)
end)

RegisterServerEvent('police:takeService')
AddEventHandler('police:takeService', function()
	if(not inServiceCops[source]) then
		inServiceCops[source] = GetPlayerName(source)
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('police:breakService')
AddEventHandler('police:breakService', function()
	if(inServiceCops[source]) then
		inServiceCops[source] = nil
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('police:getAllCopsInService')
AddEventHandler('police:getAllCopsInService', function()
	TriggerClientEvent("police:resultAllCopsInService", source, inServiceCops)
end)

RegisterServerEvent('police:checkingPlate')
AddEventHandler('police:checkingPlate', function(plate)
	local executed_query = MySQL:executeQuery("SELECT Nom FROM user_vehicle JOIN users ON user_vehicle.identifier = users.identifier WHERE vehicle_plate = '@plate'", { ['@plate'] = plate })
	local result = MySQL:getResults(executed_query, { 'Nom' }, "identifier")
	if (result[1]) then
		for _, v in ipairs(result) do
			TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, "Le vehicule #"..plate.." appartient a " .. v.Nom)
		end
	else
		TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, "Le vehicule #"..plate.." n'est pas enregistré !")
	end
end)

RegisterServerEvent('police:confirmUnseat')
AddEventHandler('police:confirmUnseat', function(t)
	TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, GetPlayerName(t).. " est sortit !")
	TriggerClientEvent('police:unseatme', t)
end)

RegisterServerEvent('police:targetCheckInventory')
AddEventHandler('police:targetCheckInventory', function(t)
	TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, checkInventory(t))
end)

RegisterServerEvent('police:finesGranted')
AddEventHandler('police:finesGranted', function(t, amount, reason)
	TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, GetPlayerName(t).. " à payé $"..amount.." d'amende pour" .. reason)
	TriggerClientEvent('police:payFines', t, amount, reason)
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(t)
	TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, GetPlayerName(t).. " menotes enlevées !")
	TriggerClientEvent('police:getArrested', t)
end)

RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(t, v)
	TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, GetPlayerName(t).. " entre dans la voiture)")
	TriggerClientEvent('police:forcedEnteringVeh', t, v)
end)

-----------------------------------------------------------------------
----------------------EVENT SPAWN POLICE VEH---------------------------
-----------------------------------------------------------------------
RegisterServerEvent('CheckPoliceVeh')
AddEventHandler('CheckPoliceVeh', function(vehicle)
	TriggerEvent('es:getPlayerFromId', source, function(user)

			TriggerClientEvent('FinishPoliceCheckForVeh',source)
			-- Spawn police vehicle
			TriggerClientEvent('policeveh:spawnVehicle', source, vehicle)
	end)
end)

-----------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP COP-------------------
-----------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'copadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, "Usage : /copadd [ID]")	
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				addCop(target.identifier)
				TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, "bien compris !")
				TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "Gouvernment", false, "felicitation vous etes maintenant Policier~w~.")
				TriggerClientEvent('police:nowCop', player)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, "Pas de joueur avec cette ID")
		end
	end
end, function(source, args, user) 
	TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, "Permissions refusees")
end)

TriggerEvent('es:addGroupCommand', 'coprem', "admin", function(source, args, user) 
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, "Usage : /coprem [ID]")	
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				remCop(target.identifier)
				TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "Gouvernment", false, "Vous n'etes plus Policier~w~.")
				TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, "Roger that !")
				--TriggerClientEvent('chatMessage', player, 'GOUVERNMENT', {255, 0, 0}, "You're no longer a cop !")
				TriggerClientEvent('police:noLongerCop', player)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, "Pas de joueur avec cette ID")
		end
	end
end, function(source, args, user) 
	TriggerClientEvent('chatMessage', source, 'GOUVERNMENT', {255, 0, 0}, "Permissions refusees")
end)

	RegisterServerEvent('police:setService')
	AddEventHandler('police:setService', function (inService)
		TriggerEvent('es:getPlayerFromId', source , function (Player)
			Player:setSessionVar('policeInService', inService)
		end)
	end)