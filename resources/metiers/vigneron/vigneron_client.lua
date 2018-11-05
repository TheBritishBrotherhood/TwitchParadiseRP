	local Vigneron_blipsTemp
	local Vigneron_markerBool = false
	local existingVeh = nil
	local isInServiceVigneron = false
	
	function Vigneron_callSE(evt)
		Menu.hidden = not Menu.hidden
		Menu.renderGUI()
		TriggerServerEvent(evt)
	end

	function Vigneron_InitMenuVehicules()
		MenuTitle = "SpawnJobs"
		ClearMenu()
		Menu.addButton("Vehicule", "Vigneron_callSE", 'vigneron:Car')
	end

	RegisterNetEvent('vigneron:drawBlips')
	AddEventHandler('vigneron:drawBlips', function () 
		for key, item in pairs(vigneron_blips) do
			item.blip = AddBlipForCoord(item.x, item.y, item.z)
			SetBlipSprite(item.blip, item.id)
			SetBlipAsShortRange(item.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(key)
			EndTextCommandSetBlipName(item.blip)
		end
		Vigneron_blipsTemp = vigneron_blips
	end)
	
	RegisterNetEvent('vigneron:deleteBlips')
	AddEventHandler('vigneron:deleteBlips', function ()
		Vigneron_markerBool = false
		for _, item in pairs(Vigneron_blipsTemp) do
			RemoveBlip(item.blip)
		end
	end)

	RegisterNetEvent('vigneron:drawMarker')
	AddEventHandler('vigneron:drawMarker', function (boolean) 
		Vigneron_markerBool = boolean
		Citizen.CreateThread(function()
			while Vigneron_markerBool == true do
				Wait(0)
				if isInServiceVigneron and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Vigne"].x,vigneron_blips["Vigne"].y,vigneron_blips["Vigne"].z, true) <= vigneron_blips["Vigne"].distanceBetweenCoords then
					TriggerServerEvent('vigneron:serverRequest', "GetRaisin")
					Citizen.Wait(vigneron_blips["Vigne"].defaultTime)
				end	
				if isInServiceVigneron and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Cave"].x,vigneron_blips["Cave"].y,vigneron_blips["Cave"].z, true) <= vigneron_blips["Cave"].distanceBetweenCoords then
					TriggerServerEvent('vigneron:serverRequest', "GetVin")
					Citizen.Wait(vigneron_blips["Cave"].defaultTime)
				end
			
				if isInServiceVigneron and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Point de vente"].x,vigneron_blips["Point de vente"].y,vigneron_blips["Point de vente"].z, true) <= vigneron_blips["Point de vente"].distanceBetweenCoords then
					TriggerServerEvent('vigneron:serverRequest', "SellVin")
					Citizen.Wait(vigneron_blips["Point de vente"].defaultTime)
				end
			end
		end)
	end)
	
	RegisterNetEvent('vigneron:marker')
	AddEventHandler('vigneron:marker', function ()
		Citizen.CreateThread(function () 
			while Vigneron_markerBool == true do
				Citizen.Wait(1)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Entreprise"].x, vigneron_blips["Entreprise"].y, vigneron_blips["Entreprise"].z, true) <= vigneron_blips["Entreprise"].distanceMarker then
					DrawMarker(1, vigneron_blips["Entreprise"].x, vigneron_blips["Entreprise"].y, vigneron_blips["Entreprise"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					ClearPrints()
					SetTextEntry_2("STRING")
					if isInServiceVigneron then
						AddTextComponentString("Appuyez sur ~g~E~s~ pour quitter le ~b~service actif")
					else
						AddTextComponentString("Appuyez sur ~g~E~s~ pour rentrer en ~b~service actif")
					end
					DrawSubtitleTimed(2000, 1)
					if IsControlJustPressed(1, Keys["E"]) then
						GetServiceVigneron()
					end
				end
				if isInServiceVigneron then
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Garage"].x, vigneron_blips["Garage"].y, vigneron_blips["Garage"].z, true) <= vigneron_blips["Garage"].distanceMarker then
						DrawMarker(1, vigneron_blips["Garage"].x, vigneron_blips["Garage"].y, vigneron_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
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
								Vigneron_InitMenuVehicules()
								Menu.hidden = not Menu.hidden
							end
						end
					end
					Menu.renderGUI()
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Vigne"].x,vigneron_blips["Vigne"].y,vigneron_blips["Vigne"].z, true) <= vigneron_blips["Vigne"].distanceMarker then
						DrawMarker(1,vigneron_blips["Vigne"].x,vigneron_blips["Vigne"].y,vigneron_blips["Vigne"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
		
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Cave"].x,vigneron_blips["Cave"].y,vigneron_blips["Cave"].z, true) <= vigneron_blips["Cave"].distanceMarker then
						DrawMarker(1,vigneron_blips["Cave"].x,vigneron_blips["Cave"].y,vigneron_blips["Cave"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vigneron_blips["Point de vente"].x,vigneron_blips["Point de vente"].y,vigneron_blips["Point de vente"].z, true) <= vigneron_blips["Point de vente"].distanceMarker then
						DrawMarker(1,vigneron_blips["Point de vente"].x,vigneron_blips["Point de vente"].y,vigneron_blips["Point de vente"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
				end
			end
		end)
	end)

function GetServiceVigneron()
	local playerPed = GetPlayerPed(-1)
	if isInServiceVigneron then
		notif("Vous n\'êtes plus en service")
		TriggerServerEvent("skin_customization:SpawnPlayer")
	else
		notif("Début du service")
		TriggerEvent("vigneron:getSkin")
	end
	isInServiceVigneron = not isInServiceVigneron
	TriggerServerEvent('vigneron:setService', isInServiceVigneron)
end
-- 	https://marekkraus.sk/gtav/skins/ et https://wiki.gtanet.work/index.php?title=Character_Components
	RegisterNetEvent('vigneron:getSkin')
	AddEventHandler('vigneron:getSkin', function (source)
	local hashSkin = GetHashKey("mp_m_freemode_01")
	Citizen.CreateThread(function()
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
			SetPedComponentVariation(GetPlayerPed(-1), 11, 41, 1, 2)  -- Top
			SetPedComponentVariation(GetPlayerPed(-1), 8, 59, 0, 2)   -- under coat 73 ?
			SetPedComponentVariation(GetPlayerPed(-1), 4, 9, 6, 2)   -- Pantalon
			SetPedComponentVariation(GetPlayerPed(-1), 6, 12, 6, 2)   -- chaussures
			--SetPedComponentVariation(GetPlayerPed(-1), 3, 67, 0, 2)   -- mains/gants/bras etc. ... (shirt)
			SetPedComponentVariation(GetPlayerPed(-1), 3, 64, 0, 2)
		else
			SetPedComponentVariation(GetPlayerPed(-1), 11, 86, 0, 2)  -- Top
			SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2)   -- under coat 73 ?
			SetPedComponentVariation(GetPlayerPed(-1), 4, 25, 1, 2)   -- Pantalon
			SetPedComponentVariation(GetPlayerPed(-1), 6, 10, 3, 2)   -- chaussures
			SetPedComponentVariation(GetPlayerPed(-1), 3, 114, 0, 2)   -- mains/gants/bras etc. ... (shirt)
		end
	end)
	end)
	
RegisterNetEvent('vigneron:getCar')
AddEventHandler('vigneron:getCar', function (source)
	local vehiculeDetected = GetClosestVehicle(vigneron_car.x, vigneron_car.y, vigneron_car.z, 6.0, 0, 70)
	if not DoesEntityExist(vehiculeDetected) then
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local vehicle = GetHashKey('sadler')
		RequestModel(vehicle)
		while not HasModelLoaded(vehicle) do
			Wait(1)
		end
		local plate = math.random(100, 900)
		existingVeh = CreateVehicle(vehicle,vigneron_car.x, vigneron_car.y, vigneron_car.z,90.0, true, false)
		SetVehicleHasBeenOwnedByPlayer(existingVeh,true)
		local id = NetworkGetNetworkIdFromEntity(existingVeh)
		SetNetworkIdCanMigrate(id, true)
		SetEntityInvincible(existingVeh, false)
		SetVehicleOnGroundProperly(existingVeh)
		SetVehicleNumberPlateText(existingVeh, vigneron_platesuffix.." "..plate.." ")
		SetModelAsNoLongerNeeded(vehicle)
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(existingVeh))
	else
		notif("Zone encombrée.")
	end
end)

	RegisterNetEvent('vigneron:drawGetRaisin')
	AddEventHandler('vigneron:drawGetRaisin', function (qteVign)
		if(qteVign == nil) then
			qteVign = 0
		end

		if qteVign < 30 then
			TriggerEvent('player:receiveItem',vigneron_ressourceBase, 1)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Chargement de raisin en cours")
			DrawSubtitleTimed(4500, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous ne pouvez plus charger")
			DrawSubtitleTimed(2000, 1)
		end
	end)
	
	RegisterNetEvent('vigneron:drawGetVin')
	AddEventHandler('vigneron:drawGetVin', function(qteVign, qteTraite)
		if(qteVign == nil) then
			qteVign = 0
		end
		
		if(qteTraite == nil) then
			qteTraite = 0
		end

		if qteTraite < 30 and qteVign > 0 then
			TriggerEvent('player:looseItem',vigneron_ressourceBase, 1)
			TriggerEvent('player:receiveItem',vigneron_ressourceTraite, 1)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Récupération des bouteilles de vin")
			DrawSubtitleTimed(4500, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous ne possedez plus de raisin")
			DrawSubtitleTimed(2000, 1)
		end
	end)
	
	RegisterNetEvent('vigneron:drawSellVin')
	AddEventHandler('vigneron:drawSellVin', function (qte)
		if(qte == nil) then
			qte = 0
		end

		if qte > 0 then
			TriggerEvent('player:looseItem',vigneron_ressourceTraite, 1)
			local salaire = math.random(vigneron_pay.minimum, vigneron_pay.maximum)
			TriggerServerEvent('mission:completed', salaire)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Vous avez vendu une bouteille de vin")
			DrawSubtitleTimed(2000, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous n'avez plus de bouteille de vin")
			DrawSubtitleTimed(2000, 1)
		end
	end)
	
