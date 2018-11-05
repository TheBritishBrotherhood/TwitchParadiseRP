require "resources/mysql-async/lib/MySQL"

outfits = {"face","","hair","","pants","","shoes","","shirt","","","torso"}

RegisterServerEvent("skin_customization:ChoosenSkin")
AddEventHandler("skin_customization:ChoosenSkin",function(skin)
TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    MySQL.Async.execute("UPDATE outfits SET skin=@skin WHERE identifier=@user",{['@skin']=skin,['@user']=player})
    local result = MySQL.Sync.fetchAll("SELECT identifier FROM outfits WHERE identifier=@user",{['@user']=player})
    if result[1].identifier ~= nil then
        TriggerClientEvent("skin_customization:Customization",source,skin)
    else
        TriggerClientEvent("skin_customization:Customization",source,skin)
    end
end)
end)

RegisterServerEvent("skin_customization:ChoosenComponents")
AddEventHandler("skin_customization:ChoosenComponents",function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        --Récupération du SteamID.
	    local player = user.identifier
        local result = MySQL.Sync.fetchAll("SELECT face,face_text,hair,hair_text,pants,pants_text,shoes,shoes_text,torso,torso_text,shirt,shirt_text FROM outfits WHERE identifier=@user",{['@user']=player})
        TriggerClientEvent("skin_customization:updateComponents",source,{result[1].face,result[1].face_text,result[1].hair,result[1].hair_text,result[1].pants,result[1].pants_text,result[1].shoes,result[1].shoes_text,result[1].torso,result[1].torso_text,result[1].shirt,result[1].shirt_text})
    end)
end)

--RegisterServerEvent("skin_customization:SpawnPlayer")
--AddEventHandler("skin_customization:SpawnPlayer", function()
--	TriggerEvent('es:getPlayerFromId', source, function(user)
--        --Récupération du SteamID.
--		local player = user.identifier
--		--Exécution de la requêtes SQL.
--		local executed_query = MySQL:executeQuery("SELECT isFirstConnection FROM users WHERE identifier = '@username'", {['@username'] = player})
--		--Récupération des données générée par la requête.
--		local result = MySQL:getResults(executed_query, {'isFirstConnection'}, "identifier")
--		-- Vérification de la présence d'un résultat avant de lancer le traitement.
--        if(result[1].isFirstConnection == 1)then
--            local executed_query3 = MySQL:executeQuery("INSERT INTO outfits(identifier) VALUES ('@identifier')",{['@identifier']=player})
--            local executed_query4 = MySQL:executeQuery("UPDATE users SET isFirstConnection = 0 WHERE identifier = '@username'", {['@username'] = player})
--            TriggerClientEvent("skin_customization:Customization", source, "mp_m_freemode_01")
--		else
--             local executed_query2 = MySQL:executeQuery("SELECT skin FROM outfits WHERE identifier = '@username'", {['@username'] = player})
--		    --Récupération des données générée par la requête.
--		    local result2 = MySQL:getResults(executed_query2, {'skin'}, "identifier")
--			TriggerClientEvent("skin_customization:Customization", source, result2[1].skin)--result2[1].skin)
--        end
--	end)
--end)

RegisterServerEvent("skin_customization:SaveComponents")
AddEventHandler("skin_customization:SaveComponents",function(components)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local component = components[1]+1
        --Récupération du SteamID.
        local draw = ""..outfits[component]
        local drawid = ""..components[3]
        local text = outfits[component].."_text"
        local textid = ""..components[4]
		local player = user.identifier
        MySQL.Async.execute("UPDATE outfits SET @a=@drawid,@b=@textureid WHERE identifier=@user",{['@a']=draw,['@drawid']=drawid,['@b']=text,['@textureid']=textid,['@user']=player})
    end)
end)
