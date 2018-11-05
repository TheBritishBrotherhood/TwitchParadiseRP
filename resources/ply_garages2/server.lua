--[[Info]]--

require "resources/mysql-async/lib/MySQL"



--[[Register]]--

RegisterServerEvent("ply_garages2:sellGarages")
RegisterServerEvent("ply_garages2:buyGarages")
RegisterServerEvent('ply_garages2:SetVehInGarage')
RegisterServerEvent('ply_garages2:UpdateVeh')
RegisterServerEvent('ply_garages2:SetVehOut')
RegisterServerEvent('ply_garages2:SellVehicle')



--[[Function]]--

function getPlayerID(source)
  return getIdentifiant(GetPlayerIdentifiers(source))
end

function getIdentifiant(id)
  for _, v in ipairs(id) do
    return v
  end
end

function checkIfThereIsAnyVehicleInTheGarage(id)
	return MySQL.Sync.fetchScalar("SELECT garage_id FROM user_vehicle WHERE identifier=@identifier AND garage_id=@id",	{['@id'] = id, ['@identifier'] = getPlayerID(source)})
end

function addGarageToPlayer(id)
	MySQL.Async.execute("INSERT INTO user_garage (identifier,garage_id) VALUES (@identifier,@garage_id)", {['@identifier'] = getPlayerID(source), ['@garage_id'] = id}, function(data)
	end)
end

function updateSateOfGarate(id,state)
	MySQL.Async.execute("UPDATE garages SET available=@state WHERE id=@id", {['@state'] = state, ['@id'] = id}, function(data)
	end)
end

function deleteGarageFromPlayer(id)
	MySQL.Async.execute("DELETE from user_garage WHERE garage_id=@garage_id", {['@garage_id'] = id}, function(data)
	end)
end

function updateSateOfPlayerVehicle(garage_id,plate,state,instance)
	MySQL.Async.execute("UPDATE user_vehicle SET garage_id=@garage_id, vehicle_state=@state, instance=@instance WHERE vehicle_plate=@plate", {['@instance'] = instance, ['@state'] = state, ['@garage_id'] = garage_id, ['@plate'] = plate}, function(data)
	end)
end

function checkIFPlayerHasAlreadyBoughtThisGarage(id)
	return MySQL.Sync.fetchScalar("SELECT garage_id FROM user_garage WHERE identifier=@identifier AND garage_id=@id", {['@id'] = id, ['@identifier'] = getPlayerID(source)})
end

function sellVehicle(plate)
	MySQL.Async.execute("DELETE from user_vehicle WHERE identifier=@identifier AND vehicle_plate=@plate", {['@identifier'] = getPlayerID(source), ['@plate'] = plate}, function(data)
	end)
end

--[[Local/Global]]--



--[[Events]]--



AddEventHandler("ply_garages2:sellGarages", function(arg)
	if checkIfThereIsAnyVehicleInTheGarage(arg[1]) then
		TriggerClientEvent("ply_garages2:sellGaragesFalse", source)
	else
		TriggerEvent('es:getPlayerFromId', source, function(user)
			user:addMoney(arg[2])
			deleteGarageFromPlayer(arg[1])
		end)
		TriggerClientEvent("ply_garages2:sellGaragesTrue", source)
	end
end)

AddEventHandler("ply_garages2:buyGarages", function(arg)
	if checkIFPlayerHasAlreadyBoughtThisGarage(arg[1]) then
		TriggerClientEvent("ply_garages2:buyGaragesFalse2", source)
	else
		MySQL.Async.fetchAll("SELECT id FROM user_garage WHERE identifier=@identifier ",{['@identifier'] = getPlayerID(source)}, function(data)
			totalgarage = 0
			for _, v in ipairs(data) do
				if v.identifier == getPlayerID(source) then
					totalgarage = totalgarage + 1
				end
			end
			if totalgarage == 3 then
				TriggerClientEvent("ply_garages2:buyGaragesFalse3", source)
			else
				TriggerEvent('es:getPlayerFromId', source, function(user)
					if user.money >= arg[2] then
						user:removeMoney(arg[2])
						addGarageToPlayer(arg[1])
						TriggerClientEvent('ply_garages2:buyGaragesTrue', source)
					else
						TriggerClientEvent("ply_garages2:buyGaragesFalse", source)
					end
				end)
			end
		end)
	end
end)

AddEventHandler("ply_garages2:SetVehInGarage", function(garage_id,plate)
	local state = "In"
	local instance = 0
	updateSateOfPlayerVehicle(garage_id,plate,state,instance)
end)

AddEventHandler("ply_garages2:SetVehOut", function(plate,instance)
	local state = "Out"
	local garage_id = 0
	updateSateOfPlayerVehicle(garage_id,plate,state,instance)
end)

AddEventHandler('ply_garages2:UpdateVeh', function(plate, plateindex, primarycolor, secondarycolor, pearlescentcolor, wheelcolor, neoncolor1, neoncolor2, neoncolor3, windowtint, wheeltype, mods0, mods1, mods2, mods3, mods4, mods5, mods6, mods7, mods8, mods9, mods10, mods11, mods12, mods13, mods14, mods15, mods16, turbo, tiresmoke, xenon, mods23, mods24, neon0, neon1, neon2, neon3, bulletproof, smokecolor1, smokecolor2, smokecolor3, variation)
	MySQL.Async.execute("UPDATE user_vehicle SET vehicle_plateindex=@plateindex, vehicle_colorprimary=@primarycolor, vehicle_colorsecondary=@secondarycolor, vehicle_pearlescentcolor=@pearlescentcolor, vehicle_wheelcolor=@wheelcolor, vehicle_neoncolor1=@neoncolor1, vehicle_neoncolor2=@neoncolor2, vehicle_neoncolor3=@neoncolor3, vehicle_windowtint=@windowtint, vehicle_wheeltype=@wheeltype, vehicle_mods0=@mods0, vehicle_mods1=@mods1, vehicle_mods2=@mods2, vehicle_mods3=@mods3, vehicle_mods4=@mods4, vehicle_mods5=@mods5, vehicle_mods6=@mods6, vehicle_mods7=@mods7, vehicle_mods8=@mods8, vehicle_mods9=@mods9, vehicle_mods10=@mods10, vehicle_mods11=@mods11, vehicle_mods12=@mods12, vehicle_mods13=@mods13, vehicle_mods14=@mods14, vehicle_mods15=@mods15, vehicle_mods16=@mods16, vehicle_turbo=@turbo, vehicle_tiresmoke=@tiresmoke, vehicle_xenon=@xenon, vehicle_mods23=@mods23, vehicle_mods24=@mods24, vehicle_neon0=@neon0, vehicle_neon1=@neon1, vehicle_neon2=@neon2, vehicle_neon3=@neon3, vehicle_bulletproof=@bulletproof, vehicle_smokecolor1=@smokecolor1, vehicle_smokecolor2=@smokecolor2, vehicle_smokecolor3=@smokecolor3, vehicle_modvariation=@variation WHERE identifier=@identifier AND vehicle_plate=@plate",
		{['@identifier'] = getPlayerID(source), ['@plateindex'] = plateindex, ['@primarycolor'] = primarycolor, ['@secondarycolor'] = secondarycolor, ['@pearlescentcolor'] = pearlescentcolor, ['@wheelcolor'] = wheelcolor, ['@neoncolor1'] = neoncolor1 , ['@neoncolor2'] = neoncolor2, ['@neoncolor3'] = neoncolor3, ['@windowtint'] = windowtint, ['@wheeltype'] = wheeltype, ['@mods0'] = mods0, ['@mods1'] = mods1, ['@mods2'] = mods2, ['@mods3'] = mods3, ['@mods4'] = mods4, ['@mods5'] = mods5, ['@mods6'] = mods6, ['@mods7'] = mods7, ['@mods8'] = mods8, ['@mods9'] = mods9, ['@mods10'] = mods10, ['@mods11'] = mods11, ['@mods12'] = mods12, ['@mods13'] = mods13, ['@mods14'] = mods14, ['@mods15'] = mods15, ['@mods16'] = mods16, ['@turbo'] = turbo, ['@tiresmoke'] = tiresmoke, ['@xenon'] = xenon, ['@mods23'] = mods23, ['@mods24'] = mods24, ['@neon0'] = neon0, ['@neon1'] = neon1, ['@neon2'] = neon2, ['@neon3'] = neon3, ['@bulletproof'] = bulletproof, ['@plate'] = plate, ['@smokecolor1'] = smokecolor1, ['@smokecolor2'] = smokecolor2, ['@smokecolor3'] = smokecolor3, ['@variation'] = variation}, function(data)
	end)
end)

AddEventHandler("ply_garages2:SellVehicle", function(plate)
	sellVehicle(plate)
end)