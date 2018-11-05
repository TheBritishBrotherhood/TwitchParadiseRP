	local pecheur_blipsTemp
	local pecheur_markerBool = false
	local existingVeh = nil
	local isInServicePecheur = false

	function pecheur_callSE(evt)
		Menu.hidden = not Menu.hidden
		Menu.renderGUI()
		TriggerServerEvent(evt)
	end

	function pecheur_InitMenuVehicules()
		MenuTitle = "SpawnJobs"
		ClearMenu()
		Menu.addButton("Bateau", "pecheur_callSE", 'pecheur:Car')
		Menu.addButton("Camionnette", "pecheur_callSE", 'pecheur:Car2')	
	end


	RegisterNetEvent('pecheur:drawBlips')
	AddEventHandler('pecheur:drawBlips', function () 
		for key, item in pairs(pecheur_blips) do
			item.blip = AddBlipForCoord(item.x, item.y, item.z)
			SetBlipSprite(item.blip, item.id)
			SetBlipAsShortRange(item.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(key)
			EndTextCommandSetBlipName(item.blip)
		end
		pecheur_blipsTemp = pecheur_blips

	end)

	RegisterNetEvent('pecheur:deleteBlips')
	AddEventHandler('pecheur:deleteBlips', function ()
		pecheur_markerBool = false
		for _, item in pairs(pecheur_blipsTemp) do
			RemoveBlip(item.blip)
		end
	end)

	RegisterNetEvent('pecheur:drawMarker')
	AddEventHandler('pecheur:drawMarker', function (boolean) 
		pecheur_markerBool = boolean
		Citizen.CreateThread(function()
			while pecheur_markerBool == true do
				Wait(0)
				
				if isInServicePecheur and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pecheur_blips["Peche"].x,pecheur_blips["Peche"].y,pecheur_blips["Peche"].z, true) <= pecheur_blips["Peche"].distanceBetweenCoords then
					TriggerServerEvent('pecheur:serverRequest', "GetPoisson")
					Citizen.Wait(pecheur_blips["Peche"].defaultTime)
				end	
			
				if isInServicePecheur and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pecheur_blips["Poissonerie"].x,pecheur_blips["Poissonerie"].y,pecheur_blips["Poissonerie"].z, true) <= pecheur_blips["Poissonerie"].distanceBetweenCoords then
					TriggerServerEvent('pecheur:serverRequest', "GetFilet")
					Citizen.Wait(pecheur_blips["Poissonerie"].defaultTime)
				end
			
				if isInServicePecheur and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pecheur_blips["Point de vente"].x,pecheur_blips["Point de vente"].y,pecheur_blips["Point de vente"].z, true) <= pecheur_blips["Point de vente"].distanceBetweenCoords then
					TriggerServerEvent('pecheur:serverRequest', "SellFilet")
					Citizen.Wait(pecheur_blips["Point de vente"].defaultTime)
				end

			end
		end)
	end)

	RegisterNetEvent('pecheur:marker')
	AddEventHandler('pecheur:marker', function ()
		Citizen.CreateThread(function () 
			while pecheur_markerBool == true do
				Citizen.Wait(1)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pecheur_blips["Entreprise"].x, pecheur_blips["Entreprise"].y, pecheur_blips["Entreprise"].z, true) <= pecheur_blips["Entreprise"].distanceMarker then
					DrawMarker(1, pecheur_blips["Entreprise"].x, pecheur_blips["Entreprise"].y, pecheur_blips["Entreprise"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					ClearPrints()
					SetTextEntry_2("STRING")
					if isInServicePecheur then
						AddTextComponentString("Appuyez sur ~g~E~s~ pour quitter le ~b~service actif")
					else
						AddTextComponentString("Appuyez sur ~g~E~s~ pour rentrer en ~b~service actif")
					end
					DrawSubtitleTimed(2000, 1)
					if IsControlJustPressed(1, Keys["E"]) then
						GetServicePecheur()
					end
				end
				if isInServicePecheur then
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pecheur_blips["Garage"].x, pecheur_blips["Garage"].y, pecheur_blips["Garage"].z, true) <= pecheur_blips["Garage"].distanceMarker then
						DrawMarker(1, pecheur_blips["Garage"].x, pecheur_blips["Garage"].y, pecheur_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
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
								pecheur_InitMenuVehicules()
								Menu.hidden = not Menu.hidden
							end
						end
					end
					Menu.renderGUI()

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pecheur_blips["Peche"].x, pecheur_blips["Peche"].y, pecheur_blips["Peche"].z, true) <= pecheur_blips["Peche"].distanceMarker then
						DrawMarker(1, pecheur_blips["Peche"].x, pecheur_blips["Peche"].y, pecheur_blips["Peche"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pecheur_blips["Poissonerie"].x,pecheur_blips["Poissonerie"].y,pecheur_blips["Poissonerie"].z, true) <= pecheur_blips["Poissonerie"].distanceMarker then
						DrawMarker(1,pecheur_blips["Poissonerie"].x,pecheur_blips["Poissonerie"].y,pecheur_blips["Poissonerie"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pecheur_blips["Point de vente"].x,pecheur_blips["Point de vente"].y,pecheur_blips["Point de vente"].z, true) <= pecheur_blips["Point de vente"].distanceMarker then
						DrawMarker(1,pecheur_blips["Point de vente"].x,pecheur_blips["Point de vente"].y,pecheur_blips["Point de vente"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
				end
			end
		end)
	end)

function GetServicePecheur()
	local playerPed = GetPlayerPed(-1)
	if isInServicePecheur then
		notif("Vous n\'êtes plus en service")
		TriggerServerEvent("skin_customization:SpawnPlayer")
	else
		notif("Début du service")
		TriggerEvent("pecheur:getSkin")
	end
	isInServicePecheur = not isInServicePecheur
	TriggerServerEvent('pecheur:setService', isInServicePecheur)
end
	RegisterNetEvent('pecheur:getSkin')
	AddEventHandler('pecheur:getSkin', function (source)
	local hashSkin = GetHashKey("mp_m_freemode_01")
	Citizen.CreateThread(function()
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
			SetPedComponentVariation(GetPlayerPed(-1), 11, 124, 0, 2)  -- Top
			SetPedComponentVariation(GetPlayerPed(-1), 8, 24, 1, 2)   -- under coat
			SetPedComponentVariation(GetPlayerPed(-1), 4, 47, 1, 2)   -- Pants
			SetPedComponentVariation(GetPlayerPed(-1), 6, 25, 0, 2)   -- shoes
			SetPedComponentVariation(GetPlayerPed(-1), 3, 108, 0, 2)   -- under skin
		else
			SetPedComponentVariation(GetPlayerPed(-1), 11, 63, 3, 2)  -- Top
			SetPedComponentVariation(GetPlayerPed(-1), 8, 44, 1, 2)   -- under coat
			SetPedComponentVariation(GetPlayerPed(-1), 4, 11, 14, 2)   -- Pants
			SetPedComponentVariation(GetPlayerPed(-1), 6, 36, 0, 2)   -- shoes
			SetPedComponentVariation(GetPlayerPed(-1), 3, 78, 0, 2)   -- under skin
		end
	end)
	end)
	
RegisterNetEvent('pecheur:getCar')
AddEventHandler('pecheur:getCar', function (source)
	local vehiculeDetected = GetClosestVehicle(pecheur_car.x, pecheur_car.y, pecheur_car.z, 6.0, 0, 70)
	if not DoesEntityExist(vehiculeDetected) then
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local vehicle = GetHashKey('tug')
		RequestModel(vehicle)
		while not HasModelLoaded(vehicle) do
			Wait(1)
		end
		local plate = math.random(100, 900)
		existingVeh = CreateVehicle(vehicle,pecheur_car.x, pecheur_car.y, pecheur_car.z,-90.0, true, false)
		SetVehicleHasBeenOwnedByPlayer(existingVeh,true)
		local id = NetworkGetNetworkIdFromEntity(existingVeh)
		SetNetworkIdCanMigrate(id, true)
		SetEntityInvincible(existingVeh, false)
		SetVehicleOnGroundProperly(existingVeh)
		SetVehicleNumberPlateText(existingVeh, pecheur_platesuffix.." "..plate.." ")
		SetModelAsNoLongerNeeded(vehicle)
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(existingVeh))
	else
		notif("Zone encombrée.")
	end
	
end)

RegisterNetEvent('pecheur:getCar2')
AddEventHandler('pecheur:getCar2', function (source)
	local vehiculeDetected = GetClosestVehicle(pecheur_car2.x, pecheur_car2.y, pecheur_car2.z, 6.0, 0, 70)
	if not DoesEntityExist(vehiculeDetected) then
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local vehicle = GetHashKey('paradise')
		RequestModel(vehicle)
		while not HasModelLoaded(vehicle) do
			Wait(1)
		end
		local plate = math.random(100, 900)
		existingVeh = CreateVehicle(vehicle,pecheur_car2.x, pecheur_car2.y, pecheur_car2.z,110.5, true, false)
		SetVehicleHasBeenOwnedByPlayer(existingVeh,true)
		local id = NetworkGetNetworkIdFromEntity(existingVeh)
		SetNetworkIdCanMigrate(id, true)
		SetEntityInvincible(existingVeh, false)
		SetVehicleOnGroundProperly(existingVeh)
		SetVehicleNumberPlateText(existingVeh, pecheur_platesuffix.." "..plate.." ")
		SetModelAsNoLongerNeeded(vehicle)
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(existingVeh))
	else
		notif("Zone encombrée.")
	end
	
end)

	RegisterNetEvent('pecheur:drawGetPoisson')
	AddEventHandler('pecheur:drawGetPoisson', function (qtePoisson)
		if(qtePoisson == nil) then
			qtePoisson = 0
		end

		if qtePoisson < 30 then
			TriggerEvent('player:receiveItem',21, 1)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Vous avez reçu un poisson")
			DrawSubtitleTimed(4500, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous ne pouvez plus pêcher")
			DrawSubtitleTimed(2000, 1)
		end
	end)

	RegisterNetEvent('pecheur:drawGetFilet')
	AddEventHandler('pecheur:drawGetFilet', function(qtePoisson, qteFilet)
		if(qtePoisson == nil) then
			qtePoisson = 0
		end
		
		if(qteFilet == nil) then
			qteFilet = 0
		end

		if qteFilet < 30 and qtePoisson > 0 then
			TriggerEvent('player:looseItem',21, 1)
			TriggerEvent('player:receiveItem',22, 1)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Poisson decoupé en Filet")
			DrawSubtitleTimed(4500, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous ne pouvez plus decouper de poisson")
			DrawSubtitleTimed(2000, 1)
		end
	end)

	RegisterNetEvent('pecheur:drawSellFilet')
	AddEventHandler('pecheur:drawSellFilet', function (qte)
		if(qte == nil) then
			qte = 0
		end

		if qte > 0 then
			TriggerEvent('player:looseItem',22, 1)
			local salaire = math.random(pecheur_pay.minimum, pecheur_pay.maximum)
			TriggerServerEvent('mission:completed', salaire)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Vous avez vendu des Filet")
			DrawSubtitleTimed(2000, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous n'avez plus de Filet")
			DrawSubtitleTimed(2000, 1)
		end
	end)
		