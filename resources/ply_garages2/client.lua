--[[Register]]--


RegisterNetEvent("ply_garages2:setGarages")
RegisterNetEvent("ply_garages2:setPlayerGarages")
RegisterNetEvent("ply_garages2:sellGaragesFalse")
RegisterNetEvent("ply_garages2:sellGaragesTrue")
RegisterNetEvent("ply_garages2:buyGaragesTrue")
RegisterNetEvent("ply_garages2:buyGaragesFalse")
RegisterNetEvent("ply_garages2:buyGaragesFalse2")
RegisterNetEvent("ply_garages2:buyGaragesFalse3")
RegisterNetEvent("ply_garages2:getVehicles")

--[[Local/Global]]--

GARAGES2 = {}
PLAYERGARAGES = {}
VEHICLES = {}
garageSelected = { {x=nil, y=nil, z=nil}, }
garagesloaded = false
playergarageloaded = false
vehicleloaded = false
temp = true
local vente_location = {-45.228, -1083.123, 25.816}

--[[Functions]]--
--menu

function MenuGarages(garage_id,name,price,slot,owned)
	MenuTitle = name
	ClearMenu()
	if garage_id == 22 then
		Menu.addButton("Store a vehicle","RentrerVehicule",{garage_id,slot})
		Menu.addButton("Get a vehicle","ListeVehicule",garage_id)
		Menu.addButton("Close","CloseMenu",nil)
	else
		if owned == "off" then
			Menu.addButton(price.."$ "..slot.." space(s) - Buy","BuyGarages",{garage_id,price})
			Menu.addButton("Close","CloseMenu",nil)
		else
			Menu.addButton("Sell this garage","SellGarages",{garage_id,price})
			Menu.addButton("Store a vehicle","RentrerVehicule",{garage_id,slot})
			Menu.addButton("Get a vehicle","ListeVehicule",garage_id)
			--Menu.addButton("Mettre à jour le véhicule","UpdateVehicule",nil)
			Menu.addButton("Close","CloseMenu",nil)
		end
	end
end

function SellGarages(arg)
	TriggerServerEvent("ply_garages2:sellGarages",arg)
	CloseMenu()
end

function BuyGarages(arg)
	TriggerServerEvent("ply_garages2:buyGarages",arg)
	CloseMenu()
end

function RentrerVehicule(arg)
	local garage_id = arg[1]
	local slot = arg[2]
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		if vehicleloaded then
			local veh = GetClosestVehicle(garageSelected.x, garageSelected.y, garageSelected.z, 3.000, 0, 70)
			SetEntityAsMissionEntity(veh, true, true)
			local plate = GetVehicleNumberPlateText(veh)
			if DoesEntityExist(veh) then
				sum = 0
				for _, v in pairs(VEHICLES) do
					if plate == v.vehicle_plate then
						sum = sum + 1
					end
				end
				if sum == 1 then
					sum = 0
					for _, v in pairs(VEHICLES) do
						if garage_id == v.garage_id then
							sum = sum + 1
						end
					end
					if sum < slot then
						local colors = table.pack(GetVehicleColours(veh))
						local extra_colors = table.pack(GetVehicleExtraColours(veh))
						local neoncolor = table.pack(GetVehicleNeonLightsColour(veh))
						local mods = table.pack(GetVehicleMod(veh))
						local smokecolor = table.pack(GetVehicleTyreSmokeColor(veh))
						local plate = GetVehicleNumberPlateText(veh)
						local plateindex = GetVehicleNumberPlateTextIndex(veh)
						local primarycolor = colors[1]
						print(primarycolor)
						local secondarycolor = colors[2]
						print(secondarycolor)
						local pearlescentcolor = extra_colors[1]
						local wheelcolor = extra_colors[2]
						local neoncolor1 = neoncolor[1]
						local neoncolor2 = neoncolor[2]
						local neoncolor3 = neoncolor[3]
						local windowtint = GetVehicleWindowTint(veh)
						local wheeltype = GetVehicleWheelType(veh)
						local smokecolor1 = smokecolor[1]
						local smokecolor2 = smokecolor[2]
						local smokecolor3 = smokecolor[3]
						local mods0 = GetVehicleMod(veh, 0)
						local mods1 = GetVehicleMod(veh, 1)
						local mods2 = GetVehicleMod(veh, 2)
						local mods3 = GetVehicleMod(veh, 3)
						local mods4 = GetVehicleMod(veh, 4)
						local mods5 = GetVehicleMod(veh, 5)
						local mods6 = GetVehicleMod(veh, 6)
						local mods7 = GetVehicleMod(veh, 7)
						local mods8 = GetVehicleMod(veh, 8)
						local mods9 = GetVehicleMod(veh, 9)
						local mods10 = GetVehicleMod(veh, 10)
						local mods11 = GetVehicleMod(veh, 11)
						local mods12 = GetVehicleMod(veh, 12)
						local mods13 = GetVehicleMod(veh, 13)
						local mods14 = GetVehicleMod(veh, 14)
						local mods15 = GetVehicleMod(veh, 15)
						local mods16 = GetVehicleMod(veh, 16)
						local mods23 = GetVehicleMod(veh, 23)
						local mods24 = GetVehicleMod(veh, 24)
						if IsToggleModOn(veh,18) then
							turbo = "on"
						else
							turbo = "off"
						end
						if IsToggleModOn(veh,20) then
							tiresmoke = "on"
						else
							tiresmoke = "off"
						end
						if IsToggleModOn(veh,22) then
							xenon = "on"
						else
							xenon = "off"
						end
						if IsVehicleNeonLightEnabled(veh,0) then
							neon0 = "on"
						else
							neon0 = "off"
						end
						if IsVehicleNeonLightEnabled(veh,1) then
							neon1 = "on"
						else
							neon1 = "off"
						end
						if IsVehicleNeonLightEnabled(veh,2) then
							neon2 = "on"
						else
							neon2 = "off"
						end
						if IsVehicleNeonLightEnabled(veh,3) then
							neon3 = "on"
						else
							neon3 = "off"
						end
						if GetVehicleTyresCanBurst(veh) then
							bulletproof = "off"
						else
							bulletproof = "on"
						end
						if GetVehicleModVariation(veh,23) then
							variation = "on"
						else
							variation = "off"
						end
						Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
						exports.pNotify:SendNotification({text = "Vehicle stored", type = "success", queue = "left", timeout = 3000, layout = "centerRight"})
						TriggerServerEvent('ply_garages2:UpdateVeh', plate, plateindex,primarycolor,secondarycolor,pearlescentcolor,wheelcolor,neoncolor1,neoncolor2,neoncolor3,windowtint,wheeltype,mods0,mods1,mods2,mods3,mods4,mods5,mods6,mods7,mods8,mods9,mods10,mods11,mods12,mods13,mods14,mods15,mods16,turbo,tiresmoke,xenon,mods23,mods24,neon0,neon1,neon2,neon3,bulletproof,smokecolor1,smokecolor2,smokecolor3,variation)
						TriggerServerEvent("ply_garages2:SetVehInGarage", garage_id, plate)
						TriggerServerEvent("ply_basemod:getPlayerVehicle")
						CloseMenu()
					else
						exports.pNotify:SendNotification({text = "This garage is full", type = "error", queue = "left", timeout = 3000, layout = "centerRight"})
					end
				else
					exports.pNotify:SendNotification({text = "It's not your vehicle", type = "error", queue = "left", timeout = 3000, layout = "centerRight"})
					CloseMenu()
				end
			else
				exports.pNotify:SendNotification({text = "No vehicles present", type = "error", queue = "left", timeout = 3000, layout = "centerRight"})
				CloseMenu()
			end
		end
	end)
	CloseMenu()
end

function ListeVehicule(garage_id)
	MenuTitle = "Vehicles"
	ClearMenu()
	for i, v in pairs(VEHICLES) do
		if garage_id == v.garage_id then
			Menu.addButton(tostring(v.vehicle_name) .. " : " .. tostring(v.vehicle_state), "OptionVehicle", v.id)
		end
	end
	Menu.addButton("Close","CloseMenu",nil)
end

function OptionVehicle(vehID)
	local vehID = vehID
	MenuTitle = "Options"
	ClearMenu()
	Menu.addButton("Get", "SortirVehicule", vehID)
	Menu.addButton("Close","CloseMenu",nil)
end

function SortirVehicule(vehID)
	for _, v in pairs(VEHICLES) do
		if vehID == v.id then
			local car = GetHashKey(v.vehicle_model)
			local plate = v.vehicle_plate
			local state = v.vehicle_state
			local primarycolor = tonumber(v.vehicle_primarycolor)
			print(primarycolor)
			local secondarycolor = tonumber(v.vehicle_secondarycolor)
			print(secondarycolor)
			local pearlescentcolor = tonumber(v.vehicle_pearlescentcolor)
			local wheelcolor = tonumber(v.vehicle_wheelcolor)

			local plateindex = tonumber(v.vehicle_plateindex)
			local neoncolor = {v.vehicle_neoncolor1,v.vehicle_neoncolor2,v.vehicle_neoncolor3}
			local windowtint = tonumber(v.vehicle_windowtint)
			local wheeltype = tonumber(v.vehicle_wheeltype)
			local mods0 = tonumber(v.vehicle_mods0)
			local mods1 = tonumber(v.vehicle_mods1)
			local mods2 = tonumber(v.vehicle_mods2)
			local mods3 = tonumber(v.vehicle_mods3)
			local mods4 = tonumber(v.vehicle_mods4)
			local mods5 = tonumber(v.vehicle_mods5)
			local mods6 = tonumber(v.vehicle_mods6)
			local mods7 = tonumber(v.vehicle_mods7)
			local mods8 = tonumber(v.vehicle_mods8)
			local mods9 = tonumber(v.vehicle_mods9)
			local mods10 = tonumber(v.vehicle_mods10)
			local mods11 = tonumber(v.vehicle_mods11)
			local mods12 = tonumber(v.vehicle_mods12)
			local mods13 = tonumber(v.vehicle_mods13)
			local mods14 = tonumber(v.vehicle_mods14)
			local mods15 = tonumber(v.vehicle_mods15)
			local mods16 = tonumber(v.vehicle_mods16)
			local turbo = v.vehicle_turbo
			local tiresmoke = v.vehicle_tiresmoke
			local xenon = v.vehicle_xenon
			local mods23 = tonumber(v.vehicle_mods23)
			local mods24 = tonumber(v.vehicle_mods24)
			local neon0 = v.vehicle_neon0
			local neon1 = v.vehicle_neon1
			local neon2 = v.vehicle_neon2
			local neon3 = v.vehicle_neon3
			local bulletproof = v.vehicle_bulletproof
			local smokecolor1 = v.vehicle_smokecolor1
			local smokecolor2 = v.vehicle_smokecolor2
			local smokecolor3 = v.vehicle_smokecolor3
			local variation = v.vehicle_variation
			Citizen.CreateThread(function()
				Citizen.Wait(0)
				local caisseo = GetClosestVehicle(garageSelected.x, garageSelected.y, garageSelected.z, 3.000, 0, 70)
				if DoesEntityExist(caisseo) then
					exports.pNotify:SendNotification({text = "The area is crowded", type = "error", queue = "left", timeout = 3000, layout = "centerRight"})
				else
				if state == "Out" then
				exports.pNotify:SendNotification({text = "This vehicle is not in the garage", type = "error", queue = "left", timeout = 3000, layout = "centerRight"})
				else
					local mods = {}
					for i = 0,24 do
						mods[i] = GetVehicleMod(veh,i)
					end
					RequestModel(car)
					while not HasModelLoaded(car) do
						Citizen.Wait(0)
					end
					veh = CreateVehicle(car, garageSelected.x, garageSelected.y, garageSelected.z, 0.0, true, false)
					SetVehicleNumberPlateText(veh, plate)
					SetVehicleOnGroundProperly(veh)
					SetVehicleHasBeenOwnedByPlayer(veh,true)
					local id = NetworkGetNetworkIdFromEntity(veh)
					SetNetworkIdCanMigrate(id, true)
					SetVehicleColours(veh, primarycolor, secondarycolor)
					SetVehicleExtraColours(veh, tonumber(pearlescentcolor), tonumber(wheelcolor))
					SetVehicleNumberPlateTextIndex(veh,plateindex)
					SetVehicleNeonLightsColour(veh,tonumber(neoncolor[1]),tonumber(neoncolor[2]),tonumber(neoncolor[3]))
					SetVehicleTyreSmokeColor(veh,tonumber(smokecolor1),tonumber(smokecolor2),tonumber(smokecolor3))
					SetVehicleModKit(veh,0)
					SetVehicleMod(veh, 0, mods0)
					SetVehicleMod(veh, 1, mods1)
					SetVehicleMod(veh, 2, mods2)
					SetVehicleMod(veh, 3, mods3)
					SetVehicleMod(veh, 4, mods4)
					SetVehicleMod(veh, 5, mods5)
					SetVehicleMod(veh, 6, mods6)
					SetVehicleMod(veh, 7, mods7)
					SetVehicleMod(veh, 8, mods8)
					SetVehicleMod(veh, 9, mods9)
					SetVehicleMod(veh, 10, mods10)
					SetVehicleMod(veh, 11, mods11)
					SetVehicleMod(veh, 12, mods12)
					SetVehicleMod(veh, 13, mods13)
					SetVehicleMod(veh, 14, mods14)
					SetVehicleMod(veh, 15, mods15)
					SetVehicleMod(veh, 16, mods16)
					if turbo == "on" then
						ToggleVehicleMod(veh, 18, true)
					else
						ToggleVehicleMod(veh, 18, false)
					end
					if tiresmoke == "on" then
						ToggleVehicleMod(veh, 20, true)
					else
						ToggleVehicleMod(veh, 20, false)
					end
					if xenon == "on" then
						ToggleVehicleMod(veh, 22, true)
					else
						ToggleVehicleMod(veh, 22, false)
					end
						SetVehicleWheelType(veh, tonumber(wheeltype))
						SetVehicleMod(veh, 23, mods23)
						SetVehicleMod(veh, 24, mods24)
					if neon0 == "on" then
						SetVehicleNeonLightEnabled(veh,0, true)
					else
						SetVehicleNeonLightEnabled(veh,0, false)
					end
					if neon1 == "on" then
						SetVehicleNeonLightEnabled(veh,1, true)
					else
						SetVehicleNeonLightEnabled(veh,1, false)
					end
					if neon2 == "on" then
						SetVehicleNeonLightEnabled(veh,2, true)
					else
						SetVehicleNeonLightEnabled(veh,2, false)
					end
					if neon3 == "on" then
						SetVehicleNeonLightEnabled(veh,3, true)
					else
						SetVehicleNeonLightEnabled(veh,3, false)
					end
					if bulletproof == "on" then
						SetVehicleTyresCanBurst(veh, false)
					else
						SetVehicleTyresCanBurst(veh, true)
					end
					SetVehicleWindowTint(veh,tonumber(windowtint))
					TaskWarpPedIntoVehicle(GetPlayerPed(-1),veh,-1)
					SetEntityInvincible(veh, false)
					exports.pNotify:SendNotification({text = "Vehicle out", type = "success", queue = "left", timeout = 3000, layout = "centerRight"})

					local instance = GetClosestVehicle(garageSelected.x, garageSelected.y, garageSelected.z, 2.000, 0, 70)
					SetEntityAsMissionEntity(instance, true, true)

					TriggerServerEvent('ply_garages2:SetVehOut', plate,instance)
					TriggerServerEvent("ply_basemod:getPlayerVehicle")
					CloseMenu()
					end
				end
			end)
		end
	end
end

function CloseMenu()
	ClearMenu()
	Menu.hidden = true
end

--base
function ShowInfo(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function getPlayerGarage(id)
	if PLAYERGARAGES then
		sum = 0
		for _, v in pairs(PLAYERGARAGES) do
			if id == v.garage_id then
				sum = sum + 1
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

--[[Citiren]]--

Citizen.CreateThread(function()
  while true do
    local near = false
    Citizen.Wait(0)
    for _, v in pairs(GARAGES2) do
      if (GetDistanceBetweenCoords(v.x, v.y, v.z, GetEntityCoords(GetPlayerPed(-1))) < 2 and near == false) then
        near = true
      end
    end
    if near == false then
      Menu.hidden = true;
    end
  end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if garagesloaded then
			if temp then
				for _, v in pairs(GARAGES2) do
					if v.available == "on" then
						v.blip = AddBlipForCoord(v.x, v.y, v.z)
						SetBlipSprite(v.blip, v.blip_id)
						SetBlipAsShortRange(v.blip, true)
						SetBlipColour(v.blip, v.blip_colour)
						SetBlipScale(v.blip, 0.9)
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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if garagesloaded and playergarageloaded then
			for _, v in pairs(GARAGES2) do
				if v.available == "on" then
					DrawMarker(1, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 3.001, 3.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					if GetDistanceBetweenCoords(v.x, v.y, v.z, GetEntityCoords(GetPlayerPed(-1))) < 2 and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
						ShowInfo("~INPUT_VEH_HORN~ to open ~g~Menu~s~", 0)
						if IsControlJustPressed(1, 86) then
							id = v.id
							name = v.name
							price = v.price
							slot = v.slot
							garageSelected.x = v.x
							garageSelected.y = v.y
							garageSelected.z = v.z
							if getPlayerGarage(id) then
								owned = "on"
							else
								owned = "off"
							end
							MenuGarages(id,name,price,slot,owned)
							Menu.hidden = not Menu.hidden
						end
						Menu.renderGUI()
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	local loc = vente_location
	pos = vente_location
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,207)
	SetBlipColour(blip, 3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Sell My Car")
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
	while true do
		Citizen.Wait(0)
		if vehicleloaded then
			DrawMarker(1,vente_location[1],vente_location[2],vente_location[3],0,0,0,0,0,0,3.001,3.0001,0.5001,0,155,255,200,0,0,0,0)
			if GetDistanceBetweenCoords(vente_location[1],vente_location[2],vente_location[3],GetEntityCoords(GetPlayerPed(-1))) < 3 and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
				ShowInfo("~INPUT_VEH_HORN~ to sell the vehicle at 50% of the purchase price", 0)
				if IsControlJustPressed(1, 86) then
					local veh = GetClosestVehicle(vente_location[1],vente_location[2],vente_location[3], 3.000, 0, 70)
					SetEntityAsMissionEntity(veh, true, true)
					local plate = GetVehicleNumberPlateText(veh)
					if DoesEntityExist(veh) then
						sum = 0
						for _, v in pairs(VEHICLES) do
							if plate == v.vehicle_plate then
								sum = sum + 1
							end
						end
						if sum == 1 then

	   						Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
							exports.pNotify:SendNotification({text = "Vehicle sold", type = "success", queue = "left", timeout = 3000, layout = "centerRight"})
							TriggerServerEvent('ply_garages2:SellVehicle', plate)
						else
							exports.pNotify:SendNotification({text = "It's not your vehicle", type = "error", queue = "left", timeout = 3000, layout = "centerRight"})
						end
					else
						exports.pNotify:SendNotification({text = "No vehicles present", type = "error", queue = "left", timeout = 3000, layout = "centerRight"})
					end
				end
			end
		end
	end
end)


--[[Events]]--

AddEventHandler("ply_garages2:setGarages", function(THEGARAGES2)
	GARAGES2 = {}
	GARAGES2 = THEGARAGES2
	garagesloaded = true
end)

AddEventHandler("ply_garages2:setPlayerGarages", function(THEPLAYERGARAGES)
	PLAYERGARAGES = {}
	PLAYERGARAGES = THEPLAYERGARAGES
	playergarageloaded = true
end)

AddEventHandler("ply_garages2:getVehicles", function(THEVEHICLES)
	vehicleloaded = false
	VEHICLES = {}
	VEHICLES = THEVEHICLES
	vehicleloaded = true
end)

AddEventHandler('ply_garages2:sellGaragesFalse', function()
	exports.pNotify:SendNotification({text = "The garage can not be sold as long as there are still vehicles", type = "error", queue = "left", timeout = 5000, layout = "centerRight"})
end)

AddEventHandler('ply_garages2:sellGaragesTrue', function()
	exports.pNotify:SendNotification({text = "The garage has been sold", type = "success", queue = "left", timeout = 3000, layout = "centerRight"})
	playergarageloaded = false
	TriggerServerEvent("ply_basemod:getPlayerGarage")

end)

AddEventHandler('ply_garages2:buyGaragesFalse', function()
	exports.pNotify:SendNotification({text = "You do not have enough money", type = "error", queue = "left", timeout = 5000, layout = "centerRight"})
end)

AddEventHandler('ply_garages2:buyGaragesTrue', function()
	exports.pNotify:SendNotification({text = "Garage purchased", type = "success", queue = "left", timeout = 3000, layout = "centerRight"})
	playergarageloaded = false
	TriggerServerEvent("ply_basemod:getPlayerGarage")
end)

AddEventHandler('ply_garages2:buyGaragesFalse2', function()
	exports.pNotify:SendNotification({text = "You have already bought a garage", type = "error", queue = "left", timeout = 3000, layout = "centerRight"})
end)

AddEventHandler('ply_garages2:buyGaragesFalse3', function()
	exports.pNotify:SendNotification({text = "You bought too much garage", type = "error", queue = "left", timeout = 3000, layout = "centerRight"})
end)