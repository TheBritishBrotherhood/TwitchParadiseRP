--[[Register]]--

RegisterNetEvent("ply_ressources:getPlayerBackPackSize")
RegisterNetEvent("ply_ressources:getrItems")
RegisterNetEvent("ply_ressources:itemAdded")
RegisterNetEvent("ply_ressources:noItemtoTreat")
RegisterNetEvent("ply_ressources:noItemtoSell")
RegisterNetEvent("ply_ressources:itemSold")
RegisterNetEvent("ply_ressources:notEnoughItemtoTreat")
RegisterNetEvent("ply_ressources:getAllRessources")


--[[Local/Global]]--
ressourcesLoaded = false
itemloaded = false
backpackloaded = false
tempblipe = true

BACKPACKSIZE = nil
RITEMS = {}
RESSOURCES = {}

harvestSelected = {{x=nil, y=nil, z=nil}}
treatmentSelected = {{x=nil, y=nil, z=nil}}
sellSelected = {{x=nil, y=nil, z=nil}}



--[[Functions]]--

function ShowInfo(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function harvestItem(playerBackPackWeight,name,weight,time,item_id,ratio)
	TriggerServerEvent("ply_ressources:addHarvestToPlayer",item_id,name,ratio,time)

	local playerBackPackWeightLeft = playerBackPackWeight - getPlayerBackPackWeightTotal()
	if ((playerBackPackWeightLeft - weight)>= weight) then
		Wait(time)
		if harvestState then
			harvestItem(playerBackPackWeight,name,weight,time,item_id,ratio)
		end
	else
		Wait(time)
		exports.pNotify:SendNotification({text = "There is no room left", type = "warning", queue = "left", timeout = time, layout = "centerLeft"})
		harvestState = false
	end
end

function treatmentItem(name,time,pre_id,item_id,ratio,need)
	TriggerServerEvent("ply_ressources:addTreatToPlayer",name,pre_id,time,item_id,ratio,need)
	Wait(time)
	if treatmentState then
		treatmentItem(name,time,pre_id,item_id,ratio,need)
	end
end

function sellItem(item_id,name,time,ratio,price,item_type)
	TriggerServerEvent("ply_ressources:sellItemFromPlayer",item_id,name,time,ratio,price,item_type)
	Wait(time)
	if sellState then
		sellItem(item_id,name,time,ratio,price,item_type)
	end
end

function getPlayerBackPackWeightTotal()
	local sum = 0
	if RITEMS ~= nil then
		for _, v in pairs(RITEMS) do
			sum = sum + (v.weight * v.quantity)
		end
	end
	return sum
end

function getItemtoTreat(id)
	local sum = 0
	if RITEMS then
		for _, v in pairs(RITEMS) do
			local op1 = (id + v.item_id)
			local op2 = (id*2)
			local test = op1 / op2
			if test == 1 then
				if v.quantity > 0 then
					sum = sum + 1
				end
			end
		end
		if sum == 1 then
			return true
		else
			return false
		end
	else
		return false
	end
end

function getItemtoSell(id)
	local sum = 0
	if RITEMS then
		for _, v in pairs(RITEMS) do
			local op1 = (id + v.item_id)
			local op2 = (id*2)
			local test = op1 / op2
			if test == 1 then
				if v.quantity > 0 then
					sum = sum + 1
				end
			end
		end
		if sum == 1 then
			return true
		else
			return false
		end
	else
		return false
	end
end

--[[Citizen]]--



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ressourcesLoaded and itemloaded and backpackloaded then
			for _, v in pairs(RESSOURCES) do
				if v.action == "harvest" then
					if GetDistanceBetweenCoords(v.x, v.y, v.z, GetEntityCoords(GetPlayerPed(-1))) < 2 and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
						ShowInfo("~INPUT_VEH_HORN~ to harverst", 0)
						if IsControlJustPressed(1, 86) then
							name = v.name
							time = v.time
							weight = v.weight
							harvestSelected.x = v.x
							harvestSelected.y = v.y
							harvestSelected.z = v.z
							item_id = v.item_id
							ratio = v.ratio
							local playerBackPackWeightLeft = BACKPACKSIZE - getPlayerBackPackWeightTotal()
							if (playerBackPackWeightLeft >= weight) then
								harvestState = true
								exports.pNotify:SendNotification({text = "Harvesting: "..name, type = "info", queue = "left", timeout = time, layout = "centerLeft"})
								Wait(time)
								if harvestState then
									harvestItem(BACKPACKSIZE,name,weight,time,item_id,ratio)
								end
							else
								exports.pNotify:SendNotification({text = "There is no room left", type = "warning", queue = "left", timeout = 3000, layout = "centerLeft"})
							end
						end
					end
				elseif v.action == "treatment" then
					if v.hide == "on" then
					end
					if GetDistanceBetweenCoords(v.x, v.y, v.z, GetEntityCoords(GetPlayerPed(-1))) < 1 and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
						ShowInfo("~INPUT_VEH_HORN~ to treat", 0)
						if IsControlJustPressed(1, 86) then
							treatmentState = true
							name = v.name
							time = v.time
							treatmentSelected.x = v.x
							treatmentSelected.y = v.y
							treatmentSelected.z = v.z
							pre_id = v.pre_id
							item_id = v.item_id
							ratio = v.ratio
							need = v.need
							if getItemtoTreat(pre_id) then
								exports.pNotify:SendNotification({text = "Treatment: "..name, type = "info", queue = "left", timeout = time, layout = "centerLeft"})
								Wait(time)
								if treatmentState then
									treatmentItem(name,time,pre_id,item_id,ratio,need)
								end
							else
								exports.pNotify:SendNotification({text = "There is nothing to treat", type = "warning", queue = "left", timeout = 3000, layout = "centerLeft"})
								TriggerServerEvent("ply_menupersonnel:getItems")
								treatmentState = false
							end
						end
					end
				elseif v.action == "sell" then
					if v.hide == "on" then
					end
					if GetDistanceBetweenCoords(v.x, v.y, v.z, GetEntityCoords(GetPlayerPed(-1))) < 1 and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
						ShowInfo("~INPUT_VEH_HORN~ to sell", 0)
						if IsControlJustPressed(1, 86) then
							sellState = true
							name = v.name
							time = v.time
							sellSelected.x = v.x
							sellSelected.y = v.y
							sellSelected.z = v.z
							item_id = v.item_id
							ratio = v.ratio
							price = v.price
							item_type = v.type
							if getItemtoSell(item_id) then
								exports.pNotify:SendNotification({text = "Selling: "..name, type = "info", queue = "left", timeout = time, layout = "centerLeft"})
								Wait(time)
								if sellState then
									sellItem(item_id,name,time,ratio,price,item_type)
								end
							else
								exports.pNotify:SendNotification({text = "There is nothing to sell", type = "warning", queue = "left", timeout = 3000, layout = "centerLeft"})
								TriggerServerEvent("ply_menupersonnel:getItems")
								sellState = false
							end
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ressourcesLoaded then
			if GetDistanceBetweenCoords(harvestSelected.x, harvestSelected.y, harvestSelected.z, GetEntityCoords(GetPlayerPed(-1))) > 2 then
				if harvestState then
					harvestState = false
					exports.pNotify:SendNotification({text = "Harvest canceled", type = "error", queue = "left", timeout = 2000, layout = "centerLeft"})
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ressourcesLoaded then
			if GetDistanceBetweenCoords(treatmentSelected.x, treatmentSelected.y, treatmentSelected.z, GetEntityCoords(GetPlayerPed(-1))) > 2 then
				if treatmentState then
					treatmentState = false
					exports.pNotify:SendNotification({text = "Treatment canceled", type = "error", queue = "left", timeout = 2000, layout = "centerLeft"})
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ressourcesLoaded then
			if GetDistanceBetweenCoords(sellSelected.x, sellSelected.y, sellSelected.z, GetEntityCoords(GetPlayerPed(-1))) > 2 then
				if sellState then
					sellState = false
					exports.pNotify:SendNotification({text = "Sale canceled", type = "error", queue = "left", timeout = 2000, layout = "centerLeft"})
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ressourcesLoaded then
			if temp then
				for _, v in pairs(RESSOURCES) do
					if v.action == "harvest" and v.hide == "on" then
						v.blip = AddBlipForCoord(v.x, v.y, v.z)
						SetBlipSprite(v.blip, v.blip_id)
						SetBlipAsShortRange(v.blip, true)
						SetBlipColour(v.blip, v.blip_colour)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(v.bname)
						EndTextCommandSetBlipName(v.blip)
					elseif v.action == "treatment" and v.hide == "on" then
						v.blip = AddBlipForCoord(v.x, v.y, v.z)
						SetBlipSprite(v.blip, v.blip_id)
						SetBlipAsShortRange(v.blip, true)
						SetBlipColour(v.blip, v.blip_colour)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(v.bname)
						EndTextCommandSetBlipName(v.blip)
					elseif v.action == "sell" and v.hide == "on" then
						v.blip = AddBlipForCoord(v.x, v.y, v.z)
						SetBlipSprite(v.blip, v.blip_id)
						SetBlipAsShortRange(v.blip, true)
						SetBlipColour(v.blip, v.blip_colour)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(v.bname)
						EndTextCommandSetBlipName(v.blip)
					end
				end
				temp = false
			end
		end
	end
end)



--[[Events]]--

AddEventHandler("ply_ressources:getAllRessources", function(NRESSOURCES)
	ressourcesLoaded = false
	RESSOURCES = NRESSOURCES
	ressourcesLoaded = true
end)

AddEventHandler("ply_ressources:getPlayerBackPackSize", function(THEBACKPACKSIZE)
	backpackloaded = false
	BACKPACKSIZE = THEBACKPACKSIZE
	backpackloaded = true
end)

AddEventHandler("ply_ressources:getrItems", function(PITEMS)
	itemloaded = false
	RITEMS = PITEMS
	itemloaded = true
end)

AddEventHandler('ply_ressources:itemAdded', function(ressource,total,time)
	exports.pNotify:SendNotification({text = ressource.." has been added\nTotal: "..total, type = "info", queue = "left", timeout = time, layout = "centerLeft"})
	TriggerServerEvent("ply_menupersonnel:getItems")
end)

AddEventHandler('ply_ressources:noItemtoTreat', function()
	exports.pNotify:SendNotification({text = "There is nothing to treat", type = "warning", queue = "left", timeout = 3000, layout = "centerLeft"})
	TriggerServerEvent("ply_menupersonnel:getItems")
	treatmentState = false
end)

AddEventHandler('ply_ressources:noItemtoSell', function()
	exports.pNotify:SendNotification({text = "There is nothing to sell", type = "warning", queue = "left", timeout = 3000, layout = "centerLeft"})
	TriggerServerEvent("ply_menupersonnel:getItems")
	sellState = false
end)

AddEventHandler('ply_ressources:itemSold', function(ressource,total,time)
	exports.pNotify:SendNotification({text = ressource.." has been sold\nRemains: "..total, type = "info", queue = "left", timeout = time, layout = "centerLeft"})
	TriggerServerEvent("ply_menupersonnel:getItems")
end)

AddEventHandler('ply_ressources:notEnoughItemtoTreat', function(name,pre_id,need,quantity,item_quantity)
	exports.pNotify:SendNotification({text = "You do not have enough\nIt takes "..need.." for "..ratio.." "..name.."\nand you have only "..item_quantity, type = "error", queue = "left", timeout = time, layout = "centerLeft"})
	treatmentState = false
	TriggerServerEvent("ply_menupersonnel:getItems")
end)

AddEventHandler('ply_ressources:stopAction1', function()
	exports.pNotify:SendNotification({text = "There is nothing to treat", type = "warning", queue = "left", timeout = 3000, layout = "centerLeft"})	treatmentState = false
	treatmentState = false
end)

AddEventHandler('ply_ressources:stopAction2', function()
	exports.pNotify:SendNotification({text = "There is nothing to sell", type = "warning", queue = "left", timeout = 3000, layout = "centerLeft"})	treatmentState = false
	sellState = false
end)