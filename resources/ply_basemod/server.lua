--[[Info]]--

require "resources/mysql-async/lib/MySQL"



--[[Register]]--

RegisterServerEvent("ply_basemod:getPlayerBackPackSize")
RegisterServerEvent("ply_basemod:getAllRessources")
RegisterServerEvent("ply_basemod:getAllStuff")
RegisterServerEvent("ply_basemod:getPlayerInventory")
RegisterServerEvent("ply_basemod:getGarages")
RegisterServerEvent("ply_basemod:getPlayerGarage")
RegisterServerEvent("ply_basemod:getPlayerVehicle")
RegisterServerEvent("ply_basemod:getJobInfo")
RegisterServerEvent("ply_basemod:getVitems")
RegisterServerEvent("ply_basemod:getAllJobRessources")
RegisterServerEvent("ply_basemod:getJobs")



--[[Function]]--

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

function resetOnStart()
	local state = "0"
	MySQL.Async.execute("UPDATE users SET player_state=@state", {['@state'] = state}, function(data)
	end)
end
resetOnStart()


--[[Local/Global]]--

backPackSize = nil
ressources = {}
permis = {}
food = {}
drink = {}
stuff = {}
items = {}
garages = {}
playergarage = {}
vehicles = {}
messagelist = {}
numberslist = {}
ijobs = {}
vitems = {}
jobs = {}

--[[Events]]--

--Backpack
AddEventHandler("ply_basemod:getPlayerBackPackSize", function()
	MySQL.Async.fetchAll("SELECT weight FROM backpack JOIN users ON `users`.`backpack_id` = `backpack`.`id` WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)}, function(data)
		for _, v in ipairs(data) do
			backPackSize = v.weight
		end
		TriggerClientEvent("ply_ressources:getPlayerBackPackSize", source, backPackSize)
		TriggerClientEvent("ply_stores:getPlayerBackPackSize", source, backPackSize)
	end)
end)


--All Items
AddEventHandler("ply_basemod:getAllRessources", function()
	MySQL.Async.fetchAll("SELECT * FROM ressources JOIN items ON `ressources`.`item_id` = `items`.`id` WHERE craft=@craft",
		{['@craft'] = 1}, function(data)
		for _, v in pairs(data) do
			t = {
			["id_ressources"] = v.id_ressources,
			["action"] = v.action,
			["bname"] = v.bname,
			["blip_colour"] = v.blip_colour,
			["item_id"] = v.item_id,
			["blip_id"] = v.blip_id,
			["x"] = v.x,
			["y"] = v.y,
			["z"] = v.z,
			["time"] = v.time,
			["hide"] = v.hide,
			["pre_id"] = v.pre_id,
			["name"] = v.name,
			["weight"] = v.weight,
			["ratio"] = v.ratio,
			["need"] = v.need,
			["price"] = v.price,
			["value"] = v.value,
			["type"] = v.type,
			["craft"] = v.craft
			}
			table.insert(ressources, tonumber(v.id_ressources), t)
		end
		TriggerClientEvent("ply_ressources:getAllRessources", source, ressources)
	end)
end)

--Stuff in Stores
AddEventHandler("ply_basemod:getAllStuff", function()
	--food
	MySQL.Async.fetchAll("SELECT * FROM items WHERE type=@type", {['@type'] = 2}, function(data)
		for _, v in ipairs(data) do
			t = { ["id"] = v.id, ["name"] = v.name, ["weight"] = v.weight, ["price"] = v.price}
			table.insert(food, tonumber(v.id), t)
		end
		TriggerClientEvent("ply_stores:getAllFood", source, food)
	end)
	--drink
	MySQL.Async.fetchAll("SELECT * FROM items WHERE type=@type", {['@type'] = 1}, function(data)
		for _, v in ipairs(data) do
			t = { ["id"] = v.id, ["name"] = v.name, ["weight"] = v.weight, ["price"] = v.price}
			table.insert(drink, tonumber(v.id), t)
		end
		TriggerClientEvent("ply_stores:getAllDrink", source, drink)
	end)
	--stuff
	MySQL.Async.fetchAll("SELECT * FROM items WHERE type=@type3 OR type=@type4", {['@type3'] = 3, ['@type4'] = 4}, function(data)
		for _, v in ipairs(data) do
			t = { ["id"] = v.id, ["name"] = v.name, ["weight"] = v.weight, ["price"] = v.price}
			table.insert(stuff, tonumber(v.id), t)
		end
		TriggerClientEvent("ply_stores:getAllStuff", source, stuff)
	end)
end)

--player inventory
AddEventHandler("ply_basemod:getPlayerInventory", function()
	items = {}
	MySQL.Async.fetchAll("SELECT * FROM user_inventory JOIN items ON `user_inventory`.`item_id` = `items`.`id` WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)}, function(data)
		for _, v in ipairs(data) do
			if v.quantity >= 1 then
				t = { ["item_id"] = v.item_id, ["weight"] = v.weight, ["quantity"] = v.quantity, ["name"] = v.name, ["pre_id"] = v.pre_id, ["value"] = v.value , ["type"] = v.type}
				table.insert(items, tonumber(v.item_id), t)
			end
		end
		TriggerClientEvent("ply_menupersonnel:getItems", source, items)
		TriggerClientEvent("ply_ressources:getrItems", source, items)
		TriggerClientEvent("ply_stores:getsItems", source, items)
	end)
end)

--all garages
AddEventHandler("ply_basemod:getGarages", function()
	garages = {}
	MySQL.Async.fetchAll("SELECT * FROM garages",{}, function(data)
		for _, v in ipairs(data) do
			t = { ["id"] = v.id, ["name"] = v.name, ["x"] = v.x, ["y"] = v.y, ["z"] = v.z, ["price"] = v.price, ["blip_colour"] = v.blip_colour, ["blip_id"] = v.blip_id, ["slot"] = v.slot, ["available"] = v.available}
			table.insert(garages, tonumber(v.id), t)
		end
		TriggerClientEvent("ply_garages2:setGarages", source, garages)
	end)
end)

--player garages
AddEventHandler("ply_basemod:getPlayerGarage", function()
	playergarage = {}
	MySQL.Async.fetchAll("SELECT * FROM user_garage WHERE identifier=@identifier ",{['@identifier'] = getPlayerID(source)}, function(data)
		for _, v in ipairs(data) do
			t = { ["id"] = v.id, ["identifier"] = v.identifier, ["garage_id"] = v.garage_id}
			table.insert(playergarage, tonumber(v.id), t)
		end
		TriggerClientEvent("ply_garages2:setPlayerGarages", source, playergarage)
	end)
end)

--player vehicle
AddEventHandler("ply_basemod:getPlayerVehicle", function()
	vehicles = {}
	MySQL.Async.fetchAll("SELECT * FROM user_vehicle WHERE identifier=@identifier",{['@identifier'] = getPlayerID(source)}, function(data)
		for _, v in ipairs(data) do
			t = {
			["id"] = v.id,
			["identifier"] = v.identifier,
			["garage_id"] = v.garage_id,
			["vehicle_name"] = v.vehicle_name,
			["vehicle_model"] = v.vehicle_model,
			["vehicle_price"] = v.vehicle_price,
			["vehicle_plate"] = v.vehicle_plate,
			["vehicle_state"] = v.vehicle_state,
			["vehicle_primarycolor"] = v.vehicle_colorprimary,
			["vehicle_secondarycolor"] = v.vehicle_colorsecondary,
			["vehicle_pearlescentcolor"] = v.vehicle_pearlescentcolor,
			["vehicle_wheelcolor"] = v.vehicle_wheelcolor,
			["vehicle_neoncolor1"] = v.vehicle_neoncolor1,
			["vehicle_neoncolor2"] = v.vehicle_neoncolor2,
			["vehicle_neoncolor3"] = v.vehicle_neoncolor3,
			["vehicle_windowtint"] = v.vehicle_windowtint,
			["vehicle_wheeltype"] = v.vehicle_wheeltype,
			["vehicle_mods0"] = v.vehicle_mods0,
			["vehicle_mods1"] = v.vehicle_mods1,
			["vehicle_mods2"] = v.vehicle_mods2,
			["vehicle_mods3"] = v.vehicle_mods3,
			["vehicle_mods4"] = v.vehicle_mods4,
			["vehicle_mods5"] = v.vehicle_mods5,
			["vehicle_mods6"] = v.vehicle_mods6,
			["vehicle_mods7"] = v.vehicle_mods7,
			["vehicle_mods8"] = v.vehicle_mods8,
			["vehicle_mods9"] = v.vehicle_mods9,
			["vehicle_mods10"] = v.vehicle_mods10,
			["vehicle_mods11"] = v.vehicle_mods11,
			["vehicle_mods12"] = v.vehicle_mods12,
			["vehicle_mods13"] = v.vehicle_mods13,
			["vehicle_mods14"] = v.vehicle_mods14,
			["vehicle_mods15"] = v.vehicle_mods15,
			["vehicle_mods16"] = v.vehicle_mods16,
			["vehicle_turbo"] = v.vehicle_turbo,
			["vehicle_tiresmoke"] = v.vehicle_tiresmoke,
			["vehicle_xenon"] = v.vehicle_xenon,
			["vehicle_mods23"] = v.vehicle_mods23,
			["vehicle_mods24"] = v.vehicle_mods24,
			["vehicle_neon0"] = v.vehicle_neon0,
			["vehicle_neon1"] = v.vehicle_neon1,
			["vehicle_neon2"] = v.vehicle_neon2,
			["vehicle_neon3"] = v.vehicle_neon3,
			["vehicle_bulletproof"] = v.vehicle_bulletproof,
			["vehicle_smokecolor1"] = v.vehicle_smokecolor1,
			["vehicle_smokecolor2"] = v.vehicle_smokecolor2,
			["vehicle_smokecolor3"] = v.vehicle_smokecolor3,
			["vehicle_modvariation"] = v.vehicle_modvariation,
			["insurance"] = v.insurance,
			["instance"] = v.instance
		}

			table.insert(vehicles, tonumber(v.id), t)
		end
		TriggerClientEvent("ply_garages2:getVehicles", source, vehicles)
		TriggerClientEvent("ply_insurance:getCars", source, vehicles)
	end)
end)

--jobinfo
AddEventHandler("ply_basemod:getJobInfo", function()
	ijobs = {}
	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)}, function(data)
		for _, v in ipairs(data) do
			t = { ["job_id"] = v.job_id, ["job_vehicle_plate"] = v.job_vehicle_plate }
			table.insert(ijobs, tonumber(v.job_id), t)
		end
		TriggerClientEvent("ply_entreprises:setJobInfo", source, ijobs)
	end)
end)

--job inventory
AddEventHandler("ply_basemod:getVitems", function()
	vitems = {}
	MySQL.Async.fetchAll("SELECT * FROM user_job_inventory JOIN items ON `user_job_inventory`.`item_id` = `items`.`id` WHERE identifier=@identifier",
		{['@identifier'] = getPlayerID(source)}, function(data)
		for _, v in ipairs(data) do
			t = { ["item_id"] = v.item_id,["quantity"] = v.quantity, ["name"] = v.name, ["weight"] = v.weight }
			table.insert(vitems, tonumber(v.item_id), t)
		end
		TriggerClientEvent("ply_entreprises:getVitems", source, vitems)
	end)
end)

--job ressources
AddEventHandler("ply_basemod:getAllJobRessources", function()
	jobressources = {}
	MySQL.Async.fetchAll("SELECT * FROM items JOIN jobs_ressources ON `items`.`id` = `jobs_ressources`.`item_id` WHERE craft=@craft",
		{['@craft'] = 2}, function(data)
		for _, v in pairs(data) do
			t = { ["id_ressources"] = v.id_ressources, ["item_id"] = v.item_id, ["price"] = v.price, ["job_id"] = v.job_id, ["job_name"] = v.job_name, ["action"] = v.action, ["bname"] = v.bname, ["blip_colour"] = v.blip_colour, ["blip_id"] = v.blip_id, ["x"] = v.x, ["y"] = v.y, ["z"] = v.z, ["time"] = v.time, ["hide"] = v.hide, ["pre_id"] = v.pre_id, ["name"] = v.name, ["weight"] = v.weight, ["ratio"] = v.ratio, ["vehicle_model"] = v.vehicle_model, ["vehicle_cost"] = v.vehicle_cost, ["vehicle_capacity"] = v.vehicle_capacity}
			table.insert(jobressources, tonumber(v.id_ressources), t)
		end
		TriggerClientEvent("ply_entreprises:getAllJobRessources", source, jobressources)
	end)
end)

--poleemploi
AddEventHandler('ply_basemod:getJobs', function()
	jobs = {}
	MySQL.Async.fetchAll("SELECT * FROM jobs",{}, function(data)
		for _, v in ipairs(data) do
			t = { ["name"] = v.job_name, ["id"] = v.id }
			table.insert(jobs, tonumber(v.id), t)
		end
		TriggerClientEvent('ply_poleemploi:getJobs', source, jobs)
	end)
end)