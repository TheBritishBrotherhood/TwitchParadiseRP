--Version 1.4
require "resources/mysql-async/lib/MySQL"

--Déclaration des EventHandler
RegisterServerEvent("projectEZ:savelastpos")
RegisterServerEvent("projectEZ:SpawnPlayer")

--Intégration de la position dans MySQL
AddEventHandler("projectEZ:savelastpos", function( LastPosX , LastPosY , LastPosZ , LastPosH )
	TriggerEvent('es:getPlayerFromId', source, function(user)
		--Récupération du SteamID.
		local player = user.identifier
		--Formatage des données en JSON pour intégration dans MySQL.
		local LastPos = "{" .. LastPosX .. ", " .. LastPosY .. ",  " .. LastPosZ .. ", " .. LastPosH .. "}"
		--Exécution de la requêtes SQL.
		MySQL.Async.execute("UPDATE users SET `lastpos`=@lastpos WHERE identifier = @username", {['@username'] = player, ['@lastpos'] = LastPos})
	end)
end)

--Récupération de la position depuis MySQL
AddEventHandler("projectEZ:SpawnPlayer", function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		--Récupération du SteamID.
		local player = user.identifier
		--Exécution de la requêtes SQL.
		local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @username", {['@username'] = player})
		if(result)then
			for k,v in ipairs(result)do
				if v.lastpos ~= "" then
				local ToSpawnPos = json.decode(v.lastpos)
				TriggerClientEvent("projectEZ:spawnlaspos", source, ToSpawnPos[1], ToSpawnPos[2], ToSpawnPos[3])
				end
			end
		end
	end)
end)
