--[[Info]]--

require "resources/mysql-async/lib/MySQL"



--[[Register]]--

RegisterServerEvent('ply_ressources:getPlayerBackPackSize')
RegisterServerEvent('ply_ressources:addHarvestToPlayer')
RegisterServerEvent('ply_ressources:addTreatToPlayer')
RegisterServerEvent('ply_ressources:sellItemFromPlayer')
RegisterServerEvent('ply_ressources:getAllRessources')



--[[Local/Global]]--

backPackSize = nil
ressources = {}


--[[Function]]--

--base
function getPlayerID(source)
	return getIdentifiant(GetPlayerIdentifiers(source))
end

function getIdentifiant(id)
	for _, v in ipairs(id) do
		return v
	end
end

--nojob
function updateItem(item_id,quantity)
	MySQL.Sync.execute("UPDATE user_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = item_id, ['@quantity'] = quantity})
end

function addItem(item_id,quantity)
	MySQL.Sync.execute("INSERT INTO user_inventory (identifier,item_id,quantity) VALUES (@identifier,@item_id,@quantity)",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = item_id, ['@quantity'] = quantity})
end

function getPlayerItemQuantity(id)
	return MySQL.Sync.fetchScalar("SELECT quantity FROM user_inventory WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id})
end

function removeItem(id,quantity,need)
	MySQL.Sync.execute("UPDATE user_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id, ['@quantity'] = quantity - need})
end

function removeItemSold(id,quantity)
	MySQL.Sync.execute("UPDATE user_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id, ['@quantity'] = quantity})
end

function removeItemByOneSold(id,quantity)
	MySQL.Sync.execute("UPDATE user_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id, ['@quantity'] = quantity})
end

--[[Events]]--

AddEventHandler("ply_ressources:addHarvestToPlayer", function(item_id,name,quantity,time)
	local item_quantity = getPlayerItemQuantity(item_id)
	if item_quantity then
		local item_quantity = item_quantity + quantity
		updateItem(item_id,item_quantity)
		TriggerClientEvent("ply_ressources:itemAdded", source, name, item_quantity,time)
	else
		addItem(item_id,quantity)
		TriggerClientEvent("ply_ressources:itemAdded", source, name, quantity,time)
	end
end)

AddEventHandler("ply_ressources:addTreatToPlayer", function(name,pre_id,time,item_id,quantity,need)
	local item_quantity = getPlayerItemQuantity(pre_id)
	local item_quantity2 = getPlayerItemQuantity(item_id)
	if item_quantity >= 1 then
		if item_quantity >= need then
			if item_quantity2 then
				local item_quantity2 = item_quantity2 + quantity
				updateItem(item_id,item_quantity2)
				TriggerClientEvent("ply_ressources:itemAdded",source,name,item_quantity2,time)
				removeItem(pre_id,item_quantity,need)
			else
				addItem(item_id,quantity)
				TriggerClientEvent("ply_ressources:itemAdded",source,name,item_quantity2,time)
				removeItem(pre_id,item_quantity,need)
			end
		else
			TriggerClientEvent("ply_ressources:notEnoughItemtoTreat", source,name,pre_id,need,quantity,item_quantity)
		end
	else
		TriggerClientEvent("ply_ressources:noItemtoTreat", source)
	end
end)

AddEventHandler("ply_ressources:sellItemFromPlayer", function(item_id,name,time,ratio,price,îtem_type)
	local item_quantity = getPlayerItemQuantity(item_id)
	if item_quantity >= 1 then
		if item_quantity >= ratio then
			TriggerEvent('es:getPlayerFromId', source, function(user)
				if îtem_type == 5 then
					user:addDirty_Money(price * ratio)
				else
					user:addMoney(price * ratio)
				end
			end)
			local item_quantity = item_quantity - ratio
			TriggerClientEvent("ply_ressources:itemSold", source, name, item_quantity,time)
			removeItemSold(item_id,item_quantity)
		else
			TriggerEvent('es:getPlayerFromId', source, function(user)
				if îtem_type == 5 then
					user:addDirty_Money(price)
				else
					user:addMoney(price)
				end
			end)
			local item_quantity = item_quantity - 1
			TriggerClientEvent("ply_ressources:itemSold", source, name, item_quantity,time)
			removeItemByOneSold(item_id,item_quantity)
		end
	else
		TriggerClientEvent("ply_ressources:noItemtoSell", source)
	end
end)