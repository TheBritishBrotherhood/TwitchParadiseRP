--[[Info]]--

require "resources/mysql-async/lib/MySQL"



--[[Register]]--

RegisterServerEvent("ply_insurance:addInsurance")
RegisterServerEvent("ply_insurance:recoverCars")


--[[Local/Global]]--

--[[Functions]]--

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

function addInsurance(id)
	MySQL.Async.execute("UPDATE user_vehicle SET insurance=@insurance WHERE id=@id",
		{['@id'] = id, ['@insurance'] = "on"}, function(data)
	end)
end

function recoverCar(id)
	MySQL.Async.execute("UPDATE user_vehicle SET garage_id=@garage_id, vehicle_state=@vehicle_state WHERE id=@id",
		{['@id'] = id, ['@garage_id'] = 22, ['@vehicle_state'] = "In"}, function(data)
	end)
end


--[[Events]]--

AddEventHandler("ply_insurance:addInsurance", function(id,name,price)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if user.money >= price then
			user:removeMoney(price)
			addInsurance(id)
			TriggerClientEvent("ply_insurance:addedInsurance", source, name)
		else
			TriggerClientEvent("ply_insurance:notEnoughMoney", source)
		end
	end)
end)

AddEventHandler("ply_insurance:recoverCars", function(id,name)
	recoverCar(id)
	TriggerClientEvent("ply_insurance:backInGarage", source, name)
end)