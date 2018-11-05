	local mineur_blipsTemp
	local mineur_markerBool = false
	local existingVeh = nil
	local isInServiceMineur = false

	function mineur_callSE(evt)
		Menu.hidden = not Menu.hidden
		Menu.renderGUI()
		TriggerServerEvent(evt)
	end

	function mineur_InitMenuVehicules()
		MenuTitle = "SpawnJobs"
		ClearMenu()
		Menu.addButton("Vehicule 1", "mineur_callSE", 'mineur:Car1')
		Menu.addButton("Vehicule 2", "mineur_callSE", 'mineur:Car2')
		Menu.addButton("Vehicule 3", "mineur_callSE", 'mineur:Car3')
	end

	RegisterNetEvent('mineur:drawBlips')
	AddEventHandler('mineur:drawBlips', function () 
		for key, item in pairs(mineur_blips) do
			item.blip = AddBlipForCoord(item.x, item.y, item.z)
			SetBlipSprite(item.blip, item.id)
			SetBlipAsShortRange(item.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(key)
			EndTextCommandSetBlipName(item.blip)
		end
		mineur_blipsTemp = mineur_blips
	end)

	RegisterNetEvent('mineur:deleteBlips')
	AddEventHandler('mineur:deleteBlips', function ()
		mineur_markerBool = false
		for _, item in pairs(mineur_blipsTemp) do
			RemoveBlip(item.blip)
		end
	end)

	RegisterNetEvent('mineur:drawMarker')
	AddEventHandler('mineur:drawMarker', function (boolean) 
		mineur_markerBool = boolean
		Citizen.CreateThread(function()
			while mineur_markerBool == true do
				Wait(0)
				if isInServiceMineur and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), mineur_blips["Mine"].x,mineur_blips["Mine"].y,mineur_blips["Mine"].z, true) <= mineur_blips["Mine"].distanceBetweenCoords then
					TriggerServerEvent('mineur:serverRequest', "GetMinerai")
					Citizen.Wait(mineur_blips["Mine"].defaultTime)
				end	
				if isInServiceMineur and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), mineur_blips["Fonderie"].x,mineur_blips["Fonderie"].y,mineur_blips["Fonderie"].z, true) <= mineur_blips["Fonderie"].distanceBetweenCoords then
					TriggerServerEvent('mineur:serverRequest', "GetMetal")
					Citizen.Wait(mineur_blips["Fonderie"].defaultTime)
				end
				if isInServiceMineur and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), mineur_blips["Point de vente"].x,mineur_blips["Point de vente"].y,mineur_blips["Point de vente"].z, true) <= mineur_blips["Point de vente"].distanceBetweenCoords then
					TriggerServerEvent('mineur:serverRequest', "SellMetal")
					Citizen.Wait(mineur_blips["Point de vente"].defaultTime)
				end
			end
		end)
	end)

	RegisterNetEvent('mineur:marker')
	AddEventHandler('mineur:marker', function ()
		Citizen.CreateThread(function () 
			while mineur_markerBool == true do
				Citizen.Wait(1)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), mineur_blips["Entreprise"].x, mineur_blips["Entreprise"].y, mineur_blips["Entreprise"].z, true) <= mineur_blips["Entreprise"].distanceMarker then
					DrawMarker(1, mineur_blips["Entreprise"].x, mineur_blips["Entreprise"].y, mineur_blips["Entreprise"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					ClearPrints()
					SetTextEntry_2("STRING")
					if isInServiceMineur then
						AddTextComponentString("Appuyez sur ~g~E~s~ pour quitter le ~b~service actif")
					else
						AddTextComponentString("Appuyez sur ~g~E~s~ pour rentrer en ~b~service actif")
					end
					DrawSubtitleTimed(2000, 1)
					if IsControlJustPressed(1, Keys["E"]) then
						GetServiceMineur()
					end
				end	
				if isInServiceMineur then
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), mineur_blips["Garage"].x, mineur_blips["Garage"].y, mineur_blips["Garage"].z, true) <= mineur_blips["Garage"].distanceMarker+5 then
						DrawMarker(1, mineur_blips["Garage"].x, mineur_blips["Garage"].y, mineur_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString("Appuyez sur ~g~E~s~ pour faire apparaître/ranger votre ~b~vehicule")
						DrawSubtitleTimed(2000, 1)
						if IsControlJustPressed(1, Keys["E"]) then
							if(existingVeh ~= nil) then
								SetEntityAsMissionEntity(existingVeh, true, true)
								Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
								existingVeh = nil
							else
								mineur_InitMenuVehicules()
								Menu.hidden = not Menu.hidden
							end
						end
					end	
				
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), mineur_blips["Mine"].x,mineur_blips["Mine"].y,mineur_blips["Mine"].z, true) <= mineur_blips["Mine"].distanceMarker then
						DrawMarker(1,mineur_blips["Mine"].x,mineur_blips["Mine"].y,mineur_blips["Mine"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), mineur_blips["Fonderie"].x,mineur_blips["Fonderie"].y,mineur_blips["Fonderie"].z, true) <= mineur_blips["Fonderie"].distanceMarker then
						DrawMarker(1,mineur_blips["Fonderie"].x,mineur_blips["Fonderie"].y,mineur_blips["Fonderie"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), mineur_blips["Point de vente"].x,mineur_blips["Point de vente"].y,mineur_blips["Point de vente"].z, true) <= mineur_blips["Point de vente"].distanceMarker then
						DrawMarker(1,mineur_blips["Point de vente"].x,mineur_blips["Point de vente"].y,mineur_blips["Point de vente"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
					Menu.renderGUI()
				end
			end
		end)
	end)

function GetServiceMineur()
	local playerPed = GetPlayerPed(-1)
	if isInServiceMineur then
		notif("Vous n\'êtes plus en service")
		TriggerServerEvent("skin_customization:SpawnPlayer")
	else
		notif("Début du service")
		TriggerEvent("mineur:getSkin")
	end
	isInServiceMineur = not isInServiceMineur
	TriggerServerEvent('mineur:setService', isInServiceMineur)
end
	
	RegisterNetEvent('mineur:getSkin')
	AddEventHandler('mineur:getSkin', function (source)
	local hashSkin = GetHashKey("mp_m_freemode_01")
	Citizen.CreateThread(function()
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
			SetPedComponentVariation(GetPlayerPed(-1), 11, 5, 0, 2)  -- Top
			SetPedComponentVariation(GetPlayerPed(-1), 8, 59, 0, 2)   -- under coat
			SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 12, 2)   -- Pants
			SetPedComponentVariation(GetPlayerPed(-1), 6, 25, 0, 2)   -- shoes
			SetPedComponentVariation(GetPlayerPed(-1), 3, 34, 0, 2)   -- under skin
		else
			SetPedComponentVariation(GetPlayerPed(-1), 11, 11, 2, 2)  -- Top
			SetPedComponentVariation(GetPlayerPed(-1), 8, 36, 0, 2)   -- under coat
			SetPedComponentVariation(GetPlayerPed(-1), 4, 35, 0, 2)   -- Pants
			SetPedComponentVariation(GetPlayerPed(-1), 6, 26, 0, 2)   -- shoes
			SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)   -- under skin
		end
	end)
	end)
	
RegisterNetEvent('mineur:getCar1')
AddEventHandler('mineur:getCar1', function (source)
	local vehiculeDetected = GetClosestVehicle(mineur_car.x, mineur_car.y, mineur_car.z, 6.0, 0, 70)
	if not DoesEntityExist(vehiculeDetected) then
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local vehicle = GetHashKey('tiptruck')
		RequestModel(vehicle)
		while not HasModelLoaded(vehicle) do
			Wait(1)
		end
		local plate = math.random(100, 900)
		existingVeh = CreateVehicle(vehicle,mineur_car.x, mineur_car.y, mineur_car.z,90.0, true, false)
		SetVehicleHasBeenOwnedByPlayer(existingVeh,true)
		local id = NetworkGetNetworkIdFromEntity(existingVeh)
		SetNetworkIdCanMigrate(id, true)
		SetEntityInvincible(existingVeh, false)
		SetVehicleOnGroundProperly(existingVeh)
		SetVehicleNumberPlateText(existingVeh, mineur_platesuffix.." "..plate.." ")
		SetModelAsNoLongerNeeded(vehicle)
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(existingVeh))
	else
		notif("Zone encombrée.")
	end
end)

RegisterNetEvent('mineur:getCar2')
AddEventHandler('mineur:getCar2', function (source)
	local vehiculeDetected = GetClosestVehicle(mineur_car.x, mineur_car.y, mineur_car.z, 6.0, 0, 70)
	if not DoesEntityExist(vehiculeDetected) then
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local vehicle = GetHashKey('tiptruck2')
		RequestModel(vehicle)
		while not HasModelLoaded(vehicle) do
			Wait(1)
		end
		local plate = math.random(100, 900)
		existingVeh = CreateVehicle(vehicle,mineur_car.x, mineur_car.y, mineur_car.z,90.0, true, false)
		SetVehicleHasBeenOwnedByPlayer(existingVeh,true)
		local id = NetworkGetNetworkIdFromEntity(existingVeh)
		SetNetworkIdCanMigrate(id, true)
		SetEntityInvincible(existingVeh, false)
		SetVehicleOnGroundProperly(existingVeh)
		SetVehicleNumberPlateText(existingVeh, mineur_platesuffix.." "..plate.." ")
		SetModelAsNoLongerNeeded(vehicle)
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(existingVeh))
	else
		notif("Zone encombrée.")
	end
end)

	RegisterNetEvent('mineur:getCar3')
	AddEventHandler('mineur:getCar3', function (source)
		local vehiculeDetected = GetClosestVehicle(mineur_car.x, mineur_car.y, mineur_car.z, 6.0, 0, 70)
	if not DoesEntityExist(vehiculeDetected) then
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local vehicle = GetHashKey('rubble')
		RequestModel(vehicle)
		while not HasModelLoaded(vehicle) do
			Wait(1)
		end
		local plate = math.random(100, 900)
		existingVeh = CreateVehicle(vehicle,mineur_car.x, mineur_car.y, mineur_car.z,90.0, true, false)
		SetVehicleHasBeenOwnedByPlayer(existingVeh,true)
		local id = NetworkGetNetworkIdFromEntity(existingVeh)
		SetNetworkIdCanMigrate(id, true)
		SetEntityInvincible(existingVeh, false)
		SetVehicleOnGroundProperly(existingVeh)
		SetVehicleNumberPlateText(existingVeh, mineur_platesuffix.." "..plate.." ")
		SetModelAsNoLongerNeeded(vehicle)
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(existingVeh))
	else
		notif("Zone encombrée.")
	end
end)

	RegisterNetEvent('mineur:drawGetMinerai')
	AddEventHandler('mineur:drawGetMinerai', function (qteMinerai)
		if(qteMinerai == nil) then
			qteMinerai = 0
		end

		if qteMinerai < 30 then
			TriggerEvent('player:receiveItem',1, 1)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Chargement de minerai")
			DrawSubtitleTimed(4500, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous ne pouvez plus charger")
			DrawSubtitleTimed(2000, 1)
		end
	end)

	RegisterNetEvent('mineur:drawGetMetal')
	AddEventHandler('mineur:drawGetMetal', function(qteMinerai, qteMetal)
		if(qteMinerai == nil) then
			qteMinerai = 0
		end
		
		if(qteMetal == nil) then
			qteMetal = 0
		end

		if qteMetal < 30 and qteMinerai > 0 then
			TriggerEvent('player:looseItem',1, 1)
			TriggerEvent('player:receiveItem',2, 1)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Minerai déchargé et chargement de métal.")
			DrawSubtitleTimed(4500, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous ne pouvez plus charger de métal")
			DrawSubtitleTimed(2000, 1)
		end
	end)

	RegisterNetEvent('mineur:drawSellMetal')
	AddEventHandler('mineur:drawSellMetal', function (qte)
		if(qte == nil) then
			qte = 0
		end

		if qte > 0 then
			TriggerEvent('player:looseItem',2, 1)
			local salaire = math.random(mineur_pay.minimum, mineur_pay.maximum)
			TriggerServerEvent('mission:completed', salaire)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Vous avez vendu du métal")
			DrawSubtitleTimed(2000, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~plus de métal, plus d'argent !")
			DrawSubtitleTimed(2000, 1)
		end
	end)
