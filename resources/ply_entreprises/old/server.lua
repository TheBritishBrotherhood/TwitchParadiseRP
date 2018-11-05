--[[Info]]--

require "resources/mysql-async/lib/MySQL"



--[[Register]]--
--no job
RegisterServerEvent('ply_ressources:getPlayerBackPackSize')
RegisterServerEvent('ply_ressources:addHarvestToPlayer')
RegisterServerEvent('ply_ressources:addTreatToPlayer')
RegisterServerEvent('ply_ressources:sellItemFromPlayer')

--job
RegisterServerEvent('ply_ressources:CheckJobService')
RegisterServerEvent('ply_ressources:CheckJobVehiclePlate')
RegisterServerEvent('ply_ressources:SetJobVehiclePlateModel')
RegisterServerEvent('ply_ressources:quitJob')
RegisterServerEvent('ply_ressources:BackJobVehicle')
RegisterServerEvent('ply_ressources:SetNullVehPlate')
RegisterServerEvent('ply_ressources:getNRessources')
RegisterServerEvent('ply_ressources:getVitems')
RegisterServerEvent('ply_ressources:getJobInfo')
RegisterServerEvent('ply_ressources:updateQuantity')
RegisterServerEvent('ply_ressources:dellAllFromId')
RegisterServerEvent('ply_ressources:GetItemLegit')
RegisterServerEvent('ply_ressources:GetItemLegit2')
RegisterServerEvent('ply_ressources:SelItemLegit')


--[[Local/Global]]--

backPackSize = nil
ressources1 = {}

vitems = {}
ijobs = {}


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
function updateItem(name)
	MySQL.Sync.execute("UPDATE user_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = getItemId(name), ['@quantity'] = getPlayerItemQuantity(name) + getItemRatio(name)})
end

function addItem(name)
	MySQL.Sync.execute("INSERT INTO user_inventory (identifier,item_id,quantity) VALUES (@identifier,@item_id,@quantity)",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = getItemId(name), ['@quantity'] = getItemRatio(name)})
end

function getItemId(name)
	return MySQL.Sync.fetchScalar("SELECT id FROM items WHERE name=@name",
		{['@name'] = name})
end

function getItemRatio(name)
	return MySQL.Sync.fetchScalar("SELECT ratio FROM items WHERE id=@id",
		{['@id'] = getItemId(name)})
end

function getPlayerItemQuantity(name)
	return MySQL.Sync.fetchScalar("SELECT quantity FROM user_inventory JOIN items ON `user_inventory`.`item_id` = `items`.`id` WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = getItemId(name)})	
end

function getPlayerItemId(name)
	return MySQL.Sync.fetchScalar("SELECT item_id FROM user_inventory JOIN items ON `user_inventory`.`item_id` = `items`.`id` WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = getItemId(name)})	
end

function removeItem(name)
	MySQL.Sync.execute("UPDATE user_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = getPlayerItemId(name), ['@quantity'] = getPlayerItemQuantity(name) - getItemRatio(name)})
end

function removeItemByOne(name)
	MySQL.Sync.execute("UPDATE user_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = getPlayerItemId(name), ['@quantity'] = getPlayerItemQuantity(name) - 1})
end

function getItemPrice(name)
	return MySQL.Sync.fetchScalar("SELECT price FROM items WHERE id=@id",
		{['@id'] = getItemId(name)})
end

--job

function getItemWeitgh(name)
	return MySQL.Sync.fetchScalar("SELECT price FROM items WHERE id=@id",
		{['@id'] = getItemId(name)})
end

function getJobId(job)
	return MySQL.Sync.fetchScalar("SELECT id FROM jobs WHERE name=@name",
		{['@name'] = job})
end

function getPlayerJobId()
	return MySQL.Sync.fetchScalar("SELECT job_id FROM users JOIN jobs ON `users`.`job_id` = `jobs`.`id` WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)})	
end

function getPlayerJobService()
	return MySQL.Sync.fetchScalar("SELECT job_service FROM users WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)})	
end

function setJobService(service)
	MySQL.Sync.execute("UPDATE users SET job_service=@job_service WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source), ['@job_service'] = service})
end

function getPlayerJobVehiclePlate()
	return MySQL.Sync.fetchScalar("SELECT job_vehicle_plate FROM users WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)})	
end

function getJobVehicleModel()
	return MySQL.Sync.fetchScalar("SELECT vehicle_model FROM jobs JOIN users ON `users`.`job_id` = `jobs`.`id` WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)})
end

function getPlayerJobVehicleModel()
	return MySQL.Sync.fetchScalar("SELECT job_vehicle_model FROM users JOIN jobs ON `users`.`job_id` = `jobs`.`id` WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)})	
end

function getJobVehicleCost()
	return MySQL.Sync.fetchScalar("SELECT vehicle_cost FROM users JOIN jobs ON `users`.`job_id` = `jobs`.`id` WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)})	
end

function setJobVehiclePlateAndModel(plate, model)
	MySQL.Sync.execute("UPDATE users SET job_vehicle_plate=@job_vehicle_plate, job_vehicle_model=@job_vehicle_model WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source), ['@job_vehicle_plate'] = plate, ['@job_vehicle_model'] = model})
end

function removeJobItem()
	MySQL.Sync.execute("DELETE FROM user_job_inventory WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)})
end

function getJobVehicleCapacity()
	return MySQL.Sync.fetchScalar("SELECT vehicle_capacity FROM jobs WHERE id=@id",
		{['@id'] = getPlayerJobId()})	
end

function getJobPlayerItemId(ressource)
	return MySQL.Sync.fetchScalar("SELECT item_id FROM user_job_inventory JOIN items ON `user_job_inventory`.`item_id` = `items`.`id` WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = getItemId(ressource)})	
end

function getJobPlayerItemQuantity(ressource)
	return MySQL.Sync.fetchScalar("SELECT quantity FROM user_job_inventory JOIN items ON `user_job_inventory`.`item_id` = `items`.`id` WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = getItemId(ressource)})	
end

function updateJobRessource(ressource)
	MySQL.Sync.execute("UPDATE user_job_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = getItemId(ressource), ['@quantity'] = getJobPlayerItemQuantity(ressource) + getItemRatio(ressource)})
end

function addJobRessource(ressource)
	MySQL.Sync.execute("INSERT INTO user_job_inventory (identifier,item_id,quantity) VALUES (@identifier,@item_id,@quantity)",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = getItemId(ressource), ['@quantity'] = getItemRatio(ressource)})
end

function removeJobRessource(ressource)
	MySQL.Sync.execute("UPDATE user_job_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = getJobPlayerItemId(ressource), ['@quantity'] = getJobPlayerItemQuantity(ressource) - getItemRatio(ressource)})
end

function sellJobRessource(ressource)
	MySQL.Sync.execute("UPDATE user_job_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = getJobPlayerItemId(ressource), ['@quantity'] = getJobPlayerItemQuantity(ressource) - 1})
end

function updateQuantity(itemID)
	MySQL.Sync.execute("UPDATE user_job_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = itemID, ['@quantity'] = getJobPlayerItemQuantityId(itemID) - 1})
end

function dellAllFromId(itemID)
	MySQL.Sync.execute("UPDATE user_job_inventory SET quantity=@quantity WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = itemID, ['@quantity'] = 0})
end

function getJobPlayerItemQuantityId(itemID)
	return MySQL.Sync.fetchScalar("SELECT quantity FROM user_job_inventory WHERE identifier=@identifier AND item_id=@item_id",
		{['@identifier'] = getPlayerID(source), ['@item_id'] = itemID})	
end

function quitJob()
	MySQL.Sync.execute("UPDATE users SET job_id=@job_id, job_vehicle_plate=@job_vehicle_plate, job_vehicle_model=@job_vehicle_model WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source), ['@job_id'] = 3, ['@job_vehicle_plate'] = "vierge", ['@job_vehicle_model'] = "vierge"})
end

--[[Events No jpb]]--

AddEventHandler("ply_ressources:getPlayerBackPackSize", function()
	backPackSize = nil
	MySQL.Async.fetchAll("SELECT weight FROM backpack JOIN users ON `users`.`backpack_id` = `backpack`.`id` WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)}, function(data)
		for _, v in ipairs(data) do
			backPackSize = v.weight
		end
		TriggerClientEvent("ply_ressources:getPlayerBackPackSize", source, backPackSize)
	end)
end)

AddEventHandler("ply_ressources:addHarvestToPlayer", function(name)
	if getPlayerItemId(name) then
		updateItem(name)
		TriggerClientEvent("ply_ressources:itemAdded", source, name, getPlayerItemQuantity(name))	
	else
		addItem(name)
		TriggerClientEvent("ply_ressources:itemAdded", source, name, getPlayerItemQuantity(name))
	end
end)

AddEventHandler("ply_ressources:addTreatToPlayer", function(name, previousName)
	if getPlayerItemQuantity(previousName) >= getItemRatio(name) then
		if getPlayerItemId(name) then
			updateItem(name)
			removeItem(previousName)
			TriggerClientEvent("ply_ressources:itemAdded", source, name, getPlayerItemQuantity(name))	
		else
			addItem(name)
			removeItem(previousName)
			TriggerClientEvent("ply_ressources:itemAdded", source, name, getPlayerItemQuantity(name))
		end
	else
		TriggerClientEvent("ply_ressources:noItemtoTreat", source)
	end
end)

AddEventHandler("ply_ressources:sellItemFromPlayer", function(name)
	if getPlayerItemQuantity(name) >= 1 then
		if getPlayerItemQuantity(name) >= getItemRatio(name) then
			removeItem(name)
			TriggerEvent('es:getPlayerFromId', source, function(user)
				user:addDirty_Money((getItemPrice(name) * getItemRatio(name)))
			end)			
			TriggerClientEvent("ply_ressources:itemSold", source, name, getPlayerItemQuantity(name))
		else
			removeItemByOne(name)
			TriggerEvent('es:getPlayerFromId', source, function(user)
				user:addDirty_Money((getItemPrice(name)))
			end)			
			TriggerClientEvent("ply_ressources:itemSold", source, name, getPlayerItemQuantity(name))
		end
	else
		TriggerClientEvent("ply_ressources:noItemtoSell", source)
	end
end)


--[[Event-job]]--


--Base
AddEventHandler("ply_ressources:getJobInfo", function()
    ijobs = {}
    local user = getPlayerID(source)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier=@identifier",
        {['@identifier'] = user}, function(data)
        for _, v in ipairs(data) do
            t = { ["job_id"] = v.job_id, ["job_vehicle_plate"] = v.job_vehicle_plate }
            table.insert(ijobs, tonumber(v.id), t)
        end
        TriggerClientEvent("ply_ressources:setJobInfo", source, ijobs)
    end)
end)


AddEventHandler("ply_ressources:getVitems", function()
    vitems = {}
    local user = getPlayerID(source)
    MySQL.Async.fetchAll("SELECT * FROM user_job_inventory JOIN items ON `user_job_inventory`.`item_id` = `items`.`id` WHERE identifier=@identifier",
        {['@identifier'] = user}, function(data)
        for _, v in ipairs(data) do
            t = { ["quantity"] = v.quantity, ["name"] = v.name }
            table.insert(vitems, tonumber(v.item_id), t)
        end
        TriggerClientEvent("ply_ressources:getVitems", source, vitems)
    end)
end)

AddEventHandler("ply_ressources:updateQuantity", function(itemId)
	if getJobPlayerItemQuantityId(itemId) > 0 then
		updateQuantity(itemId)
	end
end)

AddEventHandler("ply_ressources:dellAllFromId", function(itemId)
	if getJobPlayerItemQuantityId(itemId) > 0 then
		dellAllFromId(itemId)
	end
end)

--Prise/fin de Service
AddEventHandler('ply_ressources:CheckJobService', function(job)
    if getJobId(job) then
		if getJobId(job) ~= getPlayerJobId() then
			TriggerClientEvent("ply_ressources:noJob", source)
		else
			if getPlayerJobService() == "off" then
				setJobService("on")
				TriggerClientEvent("ply_ressources:serviceOn", source)
			else
				setJobService("off")
				TriggerClientEvent("ply_ressources:serviceOff", source)
			end
		end
	end
end)

--demissionner
AddEventHandler('ply_ressources:quitJob', function(job)
	if getJobId(job) ~= getPlayerJobId() then
		TriggerClientEvent("ply_ressources:noJob", source)		
	else
	    quitJob()
		TriggerClientEvent("ply_ressources:jobQuit", source)
	end
end)

--Prise du vehicule
AddEventHandler('ply_ressources:CheckJobVehiclePlate', function()
	if getPlayerJobService() == "off" then
		TriggerClientEvent("ply_ressources:noService", source)
	else
		if getPlayerJobVehiclePlate() == "vierge" then
			TriggerClientEvent('ply_ressources:SpawnJobVehicle', source, getJobVehicleModel())
			TriggerEvent('es:getPlayerFromId', source, function(user)
				local player = user.identifier
				user:removeMoney((getJobVehicleCost()))
			end)
		else
			TriggerClientEvent("ply_ressources:alreadyVehicleJob", source)
		end
	end
end)

--Remise du vehicule
AddEventHandler('ply_ressources:BackJobVehicle', function()
	TriggerClientEvent('ply_ressources:DelJobVehicle', source, getPlayerJobVehiclePlate())
	--
end)

--Assignement de la plaque et du model au joueur
AddEventHandler('ply_ressources:SetJobVehiclePlateModel', function(plate, model)
	print(plate)
	setJobVehiclePlateAndModel(plate, model)
	TriggerClientEvent("ply_ressources:goToJob", source)
end)

-- Fin de la remise du vehicule
AddEventHandler('ply_ressources:SetNullVehPlate', function()
	setJobVehiclePlateAndModel("vierge", "vierge")
	TriggerClientEvent("ply_ressources:jobVehicleBack", source)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local player = user.identifier
		user:addMoney((getJobVehicleCost()))
	end)
	removeJobItem()
end)


--recolte
AddEventHandler('ply_ressources:GetItemLegit', function(ressource1)
	MySQL.Async.fetchAll("SELECT * FROM user_job_inventory JOIN items ON `user_job_inventory`.`item_id` = `items`.`id` WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)}, function(data)
		sum = 0
		temp = {}
		if data then
			for i, v in ipairs(data) do
				table.insert(temp, data[1].quantity * data[1].weight)
			end
			for i, v in ipairs(temp) do
			end
			for i,row in ipairs(temp) do
				sum = sum + row
			end
		else
			sum = 0
		end
	end)
	local difference_weight = getJobVehicleCapacity() - sum
	if difference_weight >= getItemWeitgh(ressource1) then
		if getJobPlayerItemId(ressource1) then
			updateJobRessource(ressource1)
			TriggerClientEvent("ply_ressources:JobItemAdd", source, ressource1,getJobPlayerItemQuantity(ressource1))	
		else
			addJobRessource(ressource1)
			TriggerClientEvent("ply_ressources:JobItemAdd", source, ressource1,getJobPlayerItemQuantity(ressource1))	
		end
	else
		TriggerClientEvent("ply_ressources:JobItemMoreSpace", source)	
	end
end)


--traitement

AddEventHandler('ply_ressources:GetItemLegit2', function(ressource1, ressource2)
	if getJobPlayerItemId(ressource1) then
		if getJobPlayerItemQuantity(ressource1) >= 1 then
			removeJobRessource(ressource1)
			if getJobPlayerItemId(ressource2) then
				updateJobRessource(ressource2)
				TriggerClientEvent("ply_ressources:JobItemAdd", source, ressource2,getJobPlayerItemQuantity(ressource2))
			else
				addJobRessource(ressource2)
				TriggerClientEvent("ply_ressources:JobItemAdd", source, ressource2,getJobPlayerItemQuantity(ressource2))
			end
		else
			TriggerClientEvent("ply_ressources:noJobItemToTraitement", source)
		end
	else
		TriggerClientEvent("ply_ressources:noJobItemToTraitement", source)
	end
end)


--vente

AddEventHandler('ply_ressources:SelItemLegit', function(ressource2)
	if getJobPlayerItemId(ressource2) then
		if getJobPlayerItemQuantity(ressource2) >= 1 then
			sellJobRessource(ressource2)
			TriggerEvent('es:getPlayerFromId', source, function(user)
				player = user.identifier
				user:addMoney((getItemPrice(ressource2)))	
			end)			
			TriggerClientEvent("ply_ressources:JobItemSold", source, ressource2,getJobPlayerItemQuantity(ressource2))
		else
			TriggerClientEvent("ply_ressources:noJobItemToSell", source)
		end
	else
		TriggerClientEvent("ply_ressources:noJobItemToSell", source)
	end
end)