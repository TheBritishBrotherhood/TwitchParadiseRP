--[[Info]]--

require "resources/mysql-async/lib/MySQL"

--[[Register]]--


RegisterServerEvent('ply_entreprises:CheckJobService')
RegisterServerEvent('ply_entreprises:CheckJobVehiclePlate')
RegisterServerEvent('ply_entreprises:SetJobVehiclePlateModel')
RegisterServerEvent('ply_entreprises:BackJobVehicle')
RegisterServerEvent('ply_entreprises:SetNullVehPlate')
RegisterServerEvent('ply_entreprises:quitJob')
RegisterServerEvent('ply_entreprises:updateQuantity')
RegisterServerEvent('ply_entreprises:dellAllFromId')
RegisterServerEvent('ply_entreprises:GetItemLegit')
RegisterServerEvent('ply_entreprises:GetItemLegit2')
RegisterServerEvent('ply_entreprises:GetItemLegit3')



--[[Local/Global]]--



--[[Functions]]--

function getPlayerID(source)
	return getIdentifiant(GetPlayerIdentifiers(source))
end

function getIdentifiant(id)
	for _, v in ipairs(id) do
		return v
	end
end

function getJobId(job_id)
	return MySQL.Sync.fetchScalar("SELECT id FROM jobs WHERE name=@name",
		{['@name'] = job})
end

function getPlayerJobId()
	return MySQL.Sync.fetchScalar("SELECT job_id FROM users WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)})
end

function getPlayerJobService()
	return MySQL.Sync.fetchScalar("SELECT job_service FROM users WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)})
end

function setJobService(service)
	MySQL.Async.execute("UPDATE users SET job_service=@job_service WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source), ['@job_service'] = service}, function(data)
	end)
end

function getPlayerJobVehiclePlate()
	return MySQL.Sync.fetchScalar("SELECT job_vehicle_plate FROM users WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)})
end

function getJobVehicleModel(job_id)
	return MySQL.Sync.fetchScalar("SELECT vehicle_model FROM jobs_ressources WHERE job_id=@job_id AND action=@action",
		{['@job_id'] = job_id, ['@action'] = "warehouse" })
end

function getJobVehicleCost(job_id)
	return MySQL.Sync.fetchScalar("SELECT vehicle_cost FROM jobs_ressources WHERE job_id=@job_id AND action=@action",
		{['@job_id'] = job_id, ['@action'] = "warehouse" })
end

function setJobVehiclePlateAndModel(plate, model)
	MySQL.Async.execute("UPDATE users SET job_vehicle_plate=@job_vehicle_plate, job_vehicle_model=@job_vehicle_model WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source), ['@job_vehicle_plate'] = plate, ['@job_vehicle_model'] = model}, function(data)
	end)
end

function removeJobItem()
	MySQL.Async.execute("DELETE FROM user_job_inventory WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)}, function(data)
	end)
end

function quitJob()
	MySQL.Async.execute("UPDATE users SET job_id=@job_id, job_vehicle_plate=@job_vehicle_plate, job_vehicle_model=@job_vehicle_model, job_service=@job_service WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source), ['@job_id'] = 3, ['@job_vehicle_plate'] = "vierge", ['@job_vehicle_model'] = "vierge", ['@job_service'] = "off" }, function(data)
	end)
end

function getJobPlayerItemQuantityId(id)
	return MySQL.Sync.fetchScalar("SELECT quantity FROM user_job_inventory WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id})
end

function updateQuantity(itemID)
	MySQL.Async.execute("UPDATE user_job_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = itemID, ['@quantity'] = getJobPlayerItemQuantityId(itemID) - 1}, function(data)
	end)
end

function dellAllFromId(itemID)
	MySQL.Async.execute("UPDATE user_job_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = itemID, ['@quantity'] = 0}, function(data)
	end)
end

function getItemWeight(name)
	return MySQL.Sync.fetchScalar("SELECT weight FROM items WHERE id=@id",
		{['@id'] = getItemId(name)})
end

function getItemRatio(name)
	return MySQL.Sync.fetchScalar("SELECT ratio FROM items WHERE id=@id",
		{['@id'] = getItemId(name)})
end

function getItemId(name)
	return MySQL.Sync.fetchScalar("SELECT id FROM items WHERE name=@name",
		{['@name'] = name})
end

function getJobPlayerItemId(id)
	return MySQL.Sync.fetchScalar("SELECT item_id FROM user_job_inventory JOIN items ON `user_job_inventory`.`item_id` = `items`.`id` WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id})
end

function updateJobRessource(id,item_quantity)
	MySQL.Async.execute("UPDATE user_job_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id, ['@quantity'] = item_quantity}, function(data)
	end)
end

function getJobPlayerItemQuantity(id)
	return MySQL.Sync.fetchScalar("SELECT quantity FROM user_job_inventory WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id})
end

function addJobRessource(id,item_quantity)
	MySQL.Async.execute("INSERT INTO user_job_inventory (identifier,item_id,quantity) VALUES (@identifier,@item_id,@quantity)",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id, ['@quantity'] = item_quantity}, function(data)
	end)
end

function updateJobRessourceAtOnce(id, item_quantity)
	MySQL.Async.execute("UPDATE user_job_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id, ['@quantity'] = item_quantity}, function(data)
	end)
end

function removeJobRessource(id)
	MySQL.Async.execute("DELETE from user_job_inventory WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id}, function(data)
	end)
end

function addJobRessourceAtOnce(id, item_quantity)
	MySQL.Async.execute("INSERT INTO user_job_inventory (identifier,item_id,quantity) VALUES (@identifier,@item_id,@quantity)",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = id, ['@quantity'] = item_quantity}, function(data)
	end)
end

function getItemPrice(name)
	return MySQL.Sync.fetchScalar("SELECT price FROM items WHERE id=@id",
		{['@id'] = getItemId(name)})
end

--[[Events]]--

--Prise/fin de Service
AddEventHandler('ply_entreprises:CheckJobService', function(job_id)
	local playerJobId = getPlayerJobId()
	if playerJobId ~= job_id then
		TriggerClientEvent("ply_entreprises:noJob", source)
	else
		if getPlayerJobService() == "off" then
			setJobService("on")
			TriggerClientEvent("ply_entreprises:serviceOn", source)
		else
			setJobService("off")
			TriggerClientEvent("ply_entreprises:serviceOff", source)
		end
	end
end)

--Prise du vehicule
AddEventHandler('ply_entreprises:CheckJobVehiclePlate', function(arg)
	if getPlayerJobService() == "off" then
		TriggerClientEvent("ply_entreprises:noService", source)
	else
		if getPlayerJobVehiclePlate() == "vierge" then
			TriggerEvent('es:getPlayerFromId', source, function(user)
				if user.money >= arg[2] then
					user:removeMoney(arg[2])
					TriggerClientEvent('ply_entreprises:SpawnJobVehicle', source, arg[3])
				else
					TriggerClientEvent("ply_entreprises:noMoney", source)
				end
			end)
		else
			TriggerClientEvent("ply_entreprises:alreadyVehicleJob", source)
		end
	end
end)

--Assignement de la plaque et du model au joueur
AddEventHandler('ply_entreprises:SetJobVehiclePlateModel', function(plate, model)
	setJobVehiclePlateAndModel(plate, model)
	TriggerClientEvent("ply_entreprises:goToJob", source)
end)

--Début de la remise du vehicule
AddEventHandler('ply_entreprises:BackJobVehicle', function(vehicle_cost)
	TriggerClientEvent('ply_entreprises:DelJobVehicle', source, getPlayerJobVehiclePlate(),vehicle_cost)
	--
end)

-- Fin de la remise du vehicule
AddEventHandler('ply_entreprises:SetNullVehPlate', function(vehicle_cost)
	setJobVehiclePlateAndModel("vierge", "vierge")
	TriggerClientEvent("ply_entreprises:jobVehicleBack", source)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local player = user.identifier
		user:addMoney(vehicle_cost)
	end)
	--removeJobItem()
end)

--demissionner
AddEventHandler('ply_entreprises:quitJob', function(job_id)
	if job_id ~= getPlayerJobId() then
		TriggerClientEvent("ply_entreprises:noJob", source)
	else
		quitJob()
		TriggerClientEvent("ply_entreprises:jobQuit", source)
	end
end)

--inventaire du véhicule

AddEventHandler("ply_entreprises:updateQuantity", function(itemId)
	if getJobPlayerItemQuantityId(itemId) > 0 then
		updateQuantity(itemId)
	end
end)

AddEventHandler("ply_entreprises:dellAllFromId", function(itemId)
	if getJobPlayerItemQuantityId(itemId) > 0 then
		dellAllFromId(itemId)
	end
end)

--Recolte
AddEventHandler('ply_entreprises:GetItemLegit', function(name,id,JobPlayerVehicleWeightLeft,time,weight,ratio)
	local item_quantity = getJobPlayerItemQuantity(id)
	local quantitytrunk = JobPlayerVehicleWeightLeft / (weight*ratio)
	local quantitytrunk = math.floor(quantitytrunk)
	if item_quantity then
		local item_quantity = quantitytrunk + item_quantity
		updateJobRessource(id,item_quantity)
		TriggerClientEvent("ply_entreprises:jobItemAdd", source, name,item_quantity,time)
	else
		local item_quantity = quantitytrunk
		addJobRessource(id,item_quantity)
		TriggerClientEvent("ply_entreprises:jobItemAdd", source, name,item_quantity,time)
	end
end)

--Traitement
AddEventHandler('ply_entreprises:GetItemLegit2', function(name,id,pre_id,time,weight,ratio)
	local item_quantity = getJobPlayerItemQuantity(id)
	local item_quantity2 = getJobPlayerItemQuantity(pre_id)
	if item_quantity then
		local calc = ratio*item_quantity2
		local item_quantity = item_quantity + calc
		updateJobRessourceAtOnce(id, item_quantity)
		removeJobRessource(pre_id)
		TriggerClientEvent("ply_entreprises:jobItemAdd", source, name,item_quantity,time)
	else
		local item_quantity = ratio*item_quantity2
		addJobRessourceAtOnce(id, item_quantity)
		removeJobRessource(pre_id)
		TriggerClientEvent("ply_entreprises:jobItemAdd", source, name,item_quantity,time)
	end
end)

--Vente
AddEventHandler('ply_entreprises:GetItemLegit3', function(name,time,id,price)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local item_quantity = getJobPlayerItemQuantity(id)
		user:addMoney(price*item_quantity)
	end)
	removeJobRessource(id)
	TriggerClientEvent("ply_entreprises:jobItemSold", source,name,time)
end)