--[[Info]]--

require "resources/mysql-async/lib/MySQL"



--[[Register]]--

RegisterServerEvent('ply_stores:getAllBackPacks')
RegisterServerEvent('ply_stores:buyBackPack')
RegisterServerEvent('ply_stores:sellBackPack')
RegisterServerEvent('ply_stores:buyBackPack')
RegisterServerEvent('ply_stores:buyStuff')
RegisterServerEvent('ply_stores:getAllStuff')



--[[Local/Global]]--

backpacks = {}
food = {}
drink = {}
stuff = {}



--[[Function]]--

function getPlayerID(source)
	return getIdentifiant(GetPlayerIdentifiers(source))
end

function getIdentifiant(id)
	for _, v in ipairs(id) do
		return v
	end
end

function getPlayerItemQuantity(id)
	return MySQL.Sync.fetchScalar("SELECT quantity FROM user_inventory WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id})
end

function updateRessource(id,quantity)
	MySQL.Sync.execute("UPDATE user_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id, ['@quantity'] = quantity})
end

function addRessource(id,quantity)
	MySQL.Sync.execute("INSERT INTO user_inventory (identifier,item_id,quantity) VALUES (@identifier,@item_id,@quantity)",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id, ['@quantity'] = quantity})
end

--[[Events]]--

--Foodstore

AddEventHandler("ply_stores:buyStuff", function(id,name,weight,price)
	local item_quantity = getPlayerItemQuantity(id)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if (user.money >= price) then
			user:removeMoney(price)
			if item_quantity >= 1 then
				local item_quantity = item_quantity + 1
				updateRessource(id,item_quantity)
				TriggerClientEvent("ply_stores:buyTrue", source, name,item_quantity)
			else
				local item_quantity = 1
				addRessource(id,item_quantity)
				TriggerClientEvent("ply_stores:buyTrue", source, name,item_quantity)
			end
		else
			TriggerClientEvent("ply_stores:buyFalseNoMoney", source)
		end
	end)
end)