--[[Register]]--

RegisterNetEvent('ply_entreprises:getAllJobRessources')
RegisterNetEvent('ply_entreprises:noJob')
RegisterNetEvent('ply_entreprises:serviceOn')
RegisterNetEvent('ply_entreprises:serviceOff')
RegisterNetEvent('ply_entreprises:noService')
RegisterNetEvent('ply_entreprises:SpawnJobVehicle')
RegisterNetEvent('ply_entreprises:goToJob')
RegisterNetEvent('ply_entreprises:alreadyVehicleJob')
RegisterNetEvent('ply_entreprises:noMoney')
RegisterNetEvent('ply_entreprises:DelJobVehicle')
RegisterNetEvent('ply_entreprises:jobVehicleBack')
RegisterNetEvent('ply_entreprises:noJob')
RegisterNetEvent('ply_entreprises:jobQuit')
RegisterNetEvent('ply_entreprises:getVitems')
RegisterNetEvent('ply_entreprises:setJobInfo')
RegisterNetEvent('ply_entreprises:jobItemAdd')
RegisterNetEvent('ply_entreprises:jobItemSold')



--[[Local/Global]]--

Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

jobressourcesLoaded = false
jobitems = false
jobinfos = false
JOBSRESSOURCES = {}
VITEMS = {}
IJOBS = {}
depot = { {x=nil, y=nil, z=nil}, }
recolte = { {x=nil, y=nil, z=nil, name=nil, time=nil}, }
traitement = { {x=nil, y=nil, z=nil, name=nil, time=nil}, }
vente = { {x=nil, y=nil, z=nil, name=nil, time=nil}, }
temp = true


--[[Menu]]--

function MenuJob(job_name,job_id,vehicle_cost,vehicle_model)
	MenuTitle = job_name
	ClearMenu()
	Menu.addButton("Taking / Leaving Service","Service",job_id)
	Menu.addButton("Take a vehicle","PVehicule",{job_id,vehicle_cost,vehicle_model})
	Menu.addButton("Return the vehicle","RVehicule",vehicle_cost)
	Menu.addButton("To resign","Fired",job_id)
	Menu.addButton("Close","CloseMenu",nil)
end

function Service(job_id)
	TriggerServerEvent('ply_entreprises:CheckJobService', job_id)
end

function PVehicule(arg)
	TriggerServerEvent('ply_entreprises:CheckJobVehiclePlate',arg)
	CloseMenu()
end

function RVehicule(arg)
	TriggerServerEvent('ply_entreprises:BackJobVehicle',vehicle_cost)
end

function Fired(job_id)
	TriggerServerEvent('ply_entreprises:quitJob',job_id)
	CloseMenu()
end

function CloseMenu()
	ClearMenu()
	Menu.hidden = true
end

--

function MenuVehicleJob()
	MenuTitle = "Trunk"
	ClearMenu()
	for ind, value in pairs(VITEMS) do
		if (value.quantity > 0) then
			Menu.addButton(tostring(value.name) .. " : " .. tostring(value.quantity), "ItemJobMenu", ind)--value.id)
		end
	end
	Menu.addButton("Close","CloseMenu2",nil)
end

function ItemJobMenu(itemId)
	MenuTitle = "Options :"
	ClearMenu()
	Menu.addButton("Delete 1", "delete", itemId)
	Menu.addButton("Delete All", "deleteAll", itemId)
	Menu.addButton("Return,", "MenuVehicleJob", nil)
end

function delete(itemId)
	TriggerServerEvent("ply_entreprises:updateQuantity", itemId)
	TriggerServerEvent("ply_basemod:getVitems")
	Wait(500)
	MenuVehicleJob()
end

function deleteAll(itemId)
	TriggerServerEvent("ply_entreprises:dellAllFromId", itemId)
	TriggerServerEvent("ply_basemod:getVitems")
	Wait(500)
	MenuVehicleJob()
end

function CloseMenu2()
	ClearMenu()
	Menu.hidden2 = true
end

--[[Functions]]--

function ShowInfo(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function getJobPlayerVehicleWeightTotal()
	local sum = 0
	if VITEMS then
		for _, v in pairs(VITEMS) do
			sum = sum + (v.weight * v.quantity)
		end
	end
	return sum
end

function checkIfSomethingToUse(item_id)
	local sum = 0
	if VITEMS then
		for _, v in pairs(VITEMS) do
			local op1 = (item_id + v.item_id)
			local op2 = (item_id*2)
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
	end
end


--[[Citizen]]--



--Blips

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if jobressourcesLoaded and temp then
			for _, v in pairs(JOBSRESSOURCES) do
				if v.action == "warehouse" and v.hide == "on" then
					v.blip = AddBlipForCoord(v.x, v.y, v.z)
					SetBlipSprite(v.blip, v.blip_id)
					SetBlipAsShortRange(v.blip, true)
					SetBlipColour(v.blip, v.blip_colour)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(v.bname)
					EndTextCommandSetBlipName(v.blip)
				elseif v.action == "harvest" and v.hide == "on" then
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
end)

--Menu Prise de service/vehicule
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if jobressourcesLoaded then
			for _, v in pairs(JOBSRESSOURCES) do
				if v.action == "warehouse" then
					DrawMarker(1, v.x, v.y, v.z,0,0,0,0,0,0,10.001,10.0001,0.5001,255,220,60,255,0,0,0,0)
					if GetDistanceBetweenCoords(v.x, v.y, v.z,GetEntityCoords(GetPlayerPed(-1))) < 5 and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
						ShowInfo("~INPUT_VEH_HORN~ to open ~g~menu~s~", 0)
						if IsControlJustPressed(1, 86) then
							depot.x = v.x
							depot.y = v.y
							depot.z = v.z
							job_name = v.job_name
							job_id = v.job_id
							vehicle_cost = v.vehicle_cost
							vehicle_model = v.vehicle_model

							MenuJob(job_name,job_id,vehicle_cost,vehicle_model)
							Menu.hidden = not Menu.hidden
						end
						Menu.renderGUI()
					end
				end
			end
		end
	end
end)
-- Harvest
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if jobressourcesLoaded then
			for _, v in pairs(JOBSRESSOURCES) do
				if v.action == "harvest" then
					--DrawMarker(1,ressource_location[1],ressource_location[2],ressource_location[3],0,0,0,0,0,0,10.001,10.0001,0.5001,255,220,60,255,0,0,0,0)
					if GetDistanceBetweenCoords(v.x, v.y, v.z,GetEntityCoords(GetPlayerPed(-1))) < 20 and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
						ShowInfo("~INPUT_VEH_HORN~ to ~g~harvest~s~", 0)
						if IsControlJustPressed(1, 86) then
							recolte.x = v.x
							recolte.y = v.y
							recolte.z = v.z
							recolte.name = v.name
							recolte.time = v.time
							weight = v.weight
							ratio = v.ratio
							id = v.item_id
							for i, v in pairs(IJOBS) do
								jobId = v.job_id
								jobPlate = v.job_vehicle_plate
							end
							local pos = GetEntityCoords(GetPlayerPed(-1))
							local veh = GetClosestVehicle(pos, 5.000, 0, 70)
							SetEntityAsMissionEntity(veh, true, true)
							if DoesEntityExist(veh) then
								local plate = GetVehicleNumberPlateText(veh)
								if jobPlate == plate then
									local weight = v.weight
									local vehicle_capacity = v.vehicle_capacity
									local JobPlayerVehicleWeightLeft = vehicle_capacity - getJobPlayerVehicleWeightTotal()
									if (JobPlayerVehicleWeightLeft - weight) >= weight then
										jobHarvestState = true
										exports.pNotify:SendNotification({text = "Harvesting... Please wait 5 mins !",type = "success",queue = "left",timeout = recolte.time,layout = "centerRight"})
										Wait(recolte.time)
										if jobHarvestState then
											TriggerServerEvent("ply_entreprises:GetItemLegit", recolte.name,id,JobPlayerVehicleWeightLeft,recolte.time,weight,ratio)
										end
									else
										exports.pNotify:SendNotification({text = "There is no room left", type = "warning", queue = "left", timeout = 3000, layout = "centerRight"})
										jobHarvestState = false
									end
								else
									exports.pNotify:SendNotification({text = "You are not near your service vehicle", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
								end
							else
								exports.pNotify:SendNotification({text = "You are not near your service vehicle", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
							end
						end
					end
				end
			end
		end
	end
end)



--cancel harvest
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if jobHarvestState then
			if GetDistanceBetweenCoords(recolte.x, recolte.y, recolte.z, GetEntityCoords(GetPlayerPed(-1))) < 20 then
				for i, v in pairs(IJOBS) do
					jobId = v.job_id
					jobPlate = v.job_vehicle_plate
				end
				local pos = GetEntityCoords(GetPlayerPed(-1))
				local veh = GetClosestVehicle(pos, 5.000, 0, 70)
				SetEntityAsMissionEntity(veh, true, true)
				if DoesEntityExist(veh) then
					local plate = GetVehicleNumberPlateText(veh)
					if jobPlate ~= plate then
						exports.pNotify:SendNotification({text = "Harvest canceled", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
						jobHarvestState = false
					end
				else
				exports.pNotify:SendNotification({text = "Harvest canceled", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
				jobHarvestState = false
				end
			else
				exports.pNotify:SendNotification({text = "Harvest canceled", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
				jobHarvestState = false
			end
		end
	end
end)


-- Treatment
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if jobressourcesLoaded then
			for _, v in pairs(JOBSRESSOURCES) do
				if v.action == "treatment" then
					--DrawMarker(1,ressource_location[1],ressource_location[2],ressource_location[3],0,0,0,0,0,0,10.001,10.0001,0.5001,255,220,60,255,0,0,0,0)
					if GetDistanceBetweenCoords(v.x, v.y, v.z,GetEntityCoords(GetPlayerPed(-1))) < 20 and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
						ShowInfo("~INPUT_VEH_HORN~ to ~g~treat~s~", 0)
						if IsControlJustPressed(1, 86) then
							traitement.x = v.x
							traitement.y = v.y
							traitement.z = v.z
							traitement.name = v.name
							traitement.time = v.time
							weight = v.weight
							ratio = v.ratio
							pre_id = v.pre_id
							id = v.item_id
							for i, v in pairs(IJOBS) do
								jobId = v.job_id
								jobPlate = v.job_vehicle_plate
							end
							local pos = GetEntityCoords(GetPlayerPed(-1))
							local veh = GetClosestVehicle(pos, 5.000, 0, 70)
							SetEntityAsMissionEntity(veh, true, true)
							if DoesEntityExist(veh) then
								local plate = GetVehicleNumberPlateText(veh)
								if jobPlate == plate then
									if checkIfSomethingToUse(pre_id) then
										jobTreatState = true
										exports.pNotify:SendNotification({text = "Treatment... Please wait 5 mins !",type = "success",queue = "left",timeout = 3000,layout = "centerRight"})
										Wait(traitement.time)
										if jobTreatState then
											TriggerServerEvent("ply_entreprises:GetItemLegit2", traitement.name,id,pre_id,traitement.time,weight,ratio)
										end
									else
										exports.pNotify:SendNotification({text = "There is nothing to treat", type = "warning", queue = "left", timeout = 3000, layout = "centerRight"})
										jobTreatState = false
									end
								else
									exports.pNotify:SendNotification({text = "You are not near your service vehicle", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
								end
							else
								exports.pNotify:SendNotification({text = "You are not near your service vehicle", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
							end
						end
					end
				end
			end
		end
	end
end)

--cancel Treatment
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if jobTreatState then
			if GetDistanceBetweenCoords(traitement.x, traitement.y, traitement.z, GetEntityCoords(GetPlayerPed(-1))) < 20 then
				for i, v in pairs(IJOBS) do
					jobId = v.job_id
					jobPlate = v.job_vehicle_plate
				end
				local pos = GetEntityCoords(GetPlayerPed(-1))
				local veh = GetClosestVehicle(pos, 5.000, 0, 70)
				SetEntityAsMissionEntity(veh, true, true)
				if DoesEntityExist(veh) then
					local plate = GetVehicleNumberPlateText(veh)
					if jobPlate ~= plate then
						exports.pNotify:SendNotification({text = "Treatment canceled", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
						jobTreatState = false
					end
				else
				exports.pNotify:SendNotification({text = "Treatment canceled", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
				jobTreatState = false
				end
			else
				exports.pNotify:SendNotification({text = "Treatment canceled", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
				jobTreatState = false
			end
		end
	end
end)

-- Treatment
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if jobressourcesLoaded then
			for _, v in pairs(JOBSRESSOURCES) do
				if v.action == "sell" then
					--DrawMarker(1,ressource_location[1],ressource_location[2],ressource_location[3],0,0,0,0,0,0,10.001,10.0001,0.5001,255,220,60,255,0,0,0,0)
					if GetDistanceBetweenCoords(v.x, v.y, v.z,GetEntityCoords(GetPlayerPed(-1))) < 20 and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
						ShowInfo("~INPUT_VEH_HORN~ to ~g~sell~s~", 0)
						if IsControlJustPressed(1, 86) then
							vente.x = v.x
							vente.y = v.y
							vente.z = v.z
							vente.name = v.name
							vente.time = v.time
							id = v.item_id
							price = v.price
							for i, v in pairs(IJOBS) do
								jobId = v.job_id
								jobPlate = v.job_vehicle_plate
							end
							local pos = GetEntityCoords(GetPlayerPed(-1))
							local veh = GetClosestVehicle(pos, 5.000, 0, 70)
							SetEntityAsMissionEntity(veh, true, true)
							if DoesEntityExist(veh) then
								local plate = GetVehicleNumberPlateText(veh)
								if jobPlate == plate then
									if checkIfSomethingToUse(id) then
										jobSellState = true
										exports.pNotify:SendNotification({text = "Selling... Please wait 5 mins !",type = "success",queue = "left",timeout = 3000,layout = "centerRight"})
										Wait(vente.time)
										if jobSellState then
											TriggerServerEvent("ply_entreprises:GetItemLegit3", vente.name,vente.time,id,price)
										end
									else
										exports.pNotify:SendNotification({text = "There is nothing to sell", type = "warning", queue = "left", timeout = 3000, layout = "centerRight"})
										jobSellState = false
									end
								else
									exports.pNotify:SendNotification({text = "You are not near your service vehicle", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
								end
							else
								exports.pNotify:SendNotification({text = "You are not near your service vehicle", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
							end
						end
					end
				end
			end
		end
	end
end)

--cancel sell
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if jobSellState then
			if GetDistanceBetweenCoords(vente.x, vente.y, vente.z, GetEntityCoords(GetPlayerPed(-1))) < 20 then
				for i, v in pairs(IJOBS) do
					jobId = v.job_id
					jobPlate = v.job_vehicle_plate
				end
				local pos = GetEntityCoords(GetPlayerPed(-1))
				local veh = GetClosestVehicle(pos, 5.000, 0, 70)
				SetEntityAsMissionEntity(veh, true, true)
				if DoesEntityExist(veh) then
					local plate = GetVehicleNumberPlateText(veh)
					if jobPlate ~= plate then
						exports.pNotify:SendNotification({text = "Sale canceled", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
						jobSellState = false
					end
				else
				exports.pNotify:SendNotification({text = "Sale canceled", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
				jobSellState = false
				end
			else
				exports.pNotify:SendNotification({text = "Sale canceled", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
				jobSellState = false
			end
		end
	end
end)

--menu du vehicule
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for i, v in pairs(IJOBS) do
			local jobId = v.job_id
			local jobPlate = v.job_vehicle_plate
			if IsPedInAnyVehicle(GetPlayerPed(-1), true) == false and IsControlJustPressed(1, Keys["F6"]) then
				if jobId ~= 3 then
					local pos = GetEntityCoords(GetPlayerPed(-1))
					local veh = GetClosestVehicle(pos, 3.000, 0, 70)
					SetEntityAsMissionEntity(veh, true, true)
					if DoesEntityExist(veh) then
						local plate = GetVehicleNumberPlateText(veh)
						if jobPlate == plate then
							MenuVehicleJob()
							Menu.hidden2 = not Menu.hidden2
						else
							exports.pNotify:SendNotification({text = "You are not near your service vehicle", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
						end
					else
						exports.pNotify:SendNotification({text = "You are not near your service vehicle", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
					end
				end
			end
			Menu.renderGUI2()
		end
	end
end)



--[[Events]]--

AddEventHandler('ply_entreprises:noJob', function()
	exports.pNotify:SendNotification({text = "You are not hired for this job", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})

end)

AddEventHandler('ply_entreprises:serviceOn', function()
	exports.pNotify:SendNotification({text = "Beginning of service, do not forget to take a vehicle", type = "success", queue = "left", timeout = 2000, layout = "centerRight"})

end)

AddEventHandler('ply_entreprises:serviceOff', function()
	exports.pNotify:SendNotification({text = "End of service, do not forget to return the vehicle", type = "success", queue = "left", timeout = 2000, layout = "centerRight"})
end)

AddEventHandler('ply_entreprises:noService', function()
	exports.pNotify:SendNotification({text = "You have not started your service", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
end)

AddEventHandler('ply_entreprises:SpawnJobVehicle', function(veh)
	local veh = veh
	local brutmodel = veh
	local model = GetHashKey(veh)
	local playerPed = GetPlayerPed(-1)
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		local veh = GetClosestVehicle(depot.x, depot.y, depot.z, 5.000, 0, 70)
		if DoesEntityExist(caisseo) then
			exports.pNotify:SendNotification({text = "The area is crowded", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
		else
			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(0)
			end
			camion = CreateVehicle(model, depot.x, depot.y, depot.z, 0.0, true, false)
			SetVehicleOnGroundProperly(camion)
			TaskWarpPedIntoVehicle(playerPed, camion, -1)
			local plate = GetVehicleNumberPlateText(camion)
			TriggerServerEvent('ply_entreprises:SetJobVehiclePlateModel', plate, brutmodel)
		end
	end)
end)

AddEventHandler('ply_entreprises:goToJob', function()
	exports.pNotify:SendNotification({text = "Security deposit taken. Please return the truck once you have finished the job to get back your deposit", type = "info", queue = "left", timeout = 5000, layout = "centerRight"})
	TriggerServerEvent("ply_basemod:getJobInfo")
	TriggerServerEvent("ply_basemod:getVitems")
end)

AddEventHandler('ply_entreprises:alreadyVehicleJob', function()
	exports.pNotify:SendNotification({text = "You already have a vehicle", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
end)

AddEventHandler('ply_entreprises:noMoney', function()
	exports.pNotify:SendNotification({text = "You do not have enough money", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
end)

AddEventHandler('ply_entreprises:DelJobVehicle', function(plate,vehicle_cost)
	local vehicle_cost = vehicle_cost
	local plate = plate
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		local veh = GetClosestVehicle(depot.x, depot.y,depot.z, 5.000, 0, 70)
		SetEntityAsMissionEntity(veh, true, true)
		local plateveh = GetVehicleNumberPlateText(veh)
		if DoesEntityExist(veh) then
			if plate ~= plateveh then
				exports.pNotify:SendNotification({text = "It's not the right vehicle", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
			else
				Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
				TriggerServerEvent("ply_entreprises:SetNullVehPlate",vehicle_cost)
			end
		else
			exports.pNotify:SendNotification({text = "No vehicles present", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
		end
	end)
end)

AddEventHandler('ply_entreprises:jobVehicleBack', function()
	exports.pNotify:SendNotification({text = "Vehicle returned, here is your deposit", type = "success", queue = "left", timeout = 2000, layout = "centerRight"})
end)

AddEventHandler('ply_entreprises:noJob', function()
	exports.pNotify:SendNotification({text = "You are not hired for this job", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
end)

AddEventHandler('ply_entreprises:jobQuit', function()
	exports.pNotify:SendNotification({text = "You left this job", type = "success", queue = "left", timeout = 2000, layout = "centerRight"})
end)

AddEventHandler('ply_entreprises:getAllJobRessources', function(NJOBSRESSOURCES)
	JOBSRESSOURCES = {}
	JOBSRESSOURCES = NJOBSRESSOURCES
	jobressourcesLoaded = true
end)

AddEventHandler('ply_entreprises:getVitems', function(VTHEITEMS)
	VITEMS = {}
	VITEMS = VTHEITEMS
	jobitems = true
end)

AddEventHandler('ply_entreprises:setJobInfo', function(THEIJOBS)
	IJOBS = {}
	IJOBS = THEIJOBS
	jobinfos = true
end)

AddEventHandler('ply_entreprises:jobItemAdd', function(ressource,total,time)
	exports.pNotify:SendNotification({text = ressource.." has been added\nTotal: "..total, type = "info", queue = "left", timeout = time, layout = "centerRight"})
	TriggerServerEvent("ply_basemod:getVitems")
end)

AddEventHandler('ply_entreprises:jobItemSold', function(ressource,time)
	exports.pNotify:SendNotification({text = ressource.." has been Sold", type = "info", queue = "left", timeout = time, layout = "centerRight"})
	TriggerServerEvent("ply_basemod:getVitems")
end)