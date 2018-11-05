--BackPackstore
AddEventHandler("ply_stores:getAllBackPacks", function()
	backpacks = {}
	local user = getPlayerID(source)
	MySQL.Async.fetchAll("SELECT * FROM backpack WHERE price > @price", {['@price'] = 0}, function(data)
		for _, v in ipairs(data) do
			t = { ["name"] = v.name, ["weight"] = v.weight, ["price"] = v.price}
			table.insert(backpacks, tonumber(v.id), t)
		end
		TriggerClientEvent("ply_stores:getAllBackPacks", source, backpacks)
	end)
end)

AddEventHandler("ply_stores:sellBackPack", function()
	if getBackPackPrice(getPlayerBackPackId()) > 0 then
		TriggerEvent('es:getPlayerFromId', source, function(user)
			user:addMoney((getBackPackPrice(getPlayerBackPackId()) / 2))
		end)
		setBackPackToPlayer(0)
		TriggerClientEvent('ply_stores:sellBackPackTrue', source)
	else
		TriggerClientEvent('ply_stores:sellBackPackFalse', source)
	end
end)

AddEventHandler("ply_stores:buyBackPack", function(backpack_id)
	if getBackPackPrice(backpack_id) > 0 then
		if getPlayerBackPackId() == backpack_id then
			TriggerClientEvent('ply_stores:buyBackPackFalse2', source)
		else
			setBackPackToPlayer(backpack_id)
			TriggerEvent('es:getPlayerFromId', source, function(user)
				user:removeMoney((getBackPackPrice(backpack_id)))
			end)
			TriggerClientEvent('ply_stores:buyBackPackTrue', source)
		end
	else
		TriggerClientEvent('ply_stores:buyBackPackFalse', source)
	end
end)