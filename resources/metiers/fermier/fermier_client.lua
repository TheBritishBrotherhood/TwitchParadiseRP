	local fermier_blipsTemp
	local fermier_markerBool = false
	local existingVeh = nil
	local isInServiceFermier = false

	function fermier_callSE(evt)
		Menu.hidden = not Menu.hidden
		Menu.renderGUI()
		TriggerServerEvent(evt)
	end

	function fermier_InitMenuVehicules()
		MenuTitle = "SpawnJobs"
		ClearMenu()
		Menu.addButton("Vehicule", "fermier_callSE", 'fermier:Car')
	end

	RegisterNetEvent('fermier:drawBlips')
	AddEventHandler('fermier:drawBlips', function () 
		for key, item in pairs(fermier_blips) do
			item.blip = AddBlipForCoord(item.x, item.y, item.z)
			SetBlipSprite(item.blip, item.id)
			SetBlipAsShortRange(item.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(key)
			EndTextCommandSetBlipName(item.blip)
		end
		fermier_blipsTemp = fermier_blips
	end)

	RegisterNetEvent('fermier:deleteBlips')			
	AddEventHandler('fermier:deleteBlips', function ()
		fermier_markerBool = false
		for _, item in pairs(fermier_blipsTemp) do
			RemoveBlip(item.blip)
		end
	end)

	RegisterNetEvent('fermier:drawMarker')	
	AddEventHandler('fermier:drawMarker', function (boolean)
		fermier_markerBool = boolean
		Citizen.CreateThread(function()
			while fermier_markerBool == true do
				Wait(0)
				if isInServiceFermier and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), fermier_blips["Champ"].x,fermier_blips["Champ"].y,fermier_blips["Champ"].z, true) <= fermier_blips["Champ"].distanceBetweenCoords then
					TriggerServerEvent('fermier:serverRequest', "GetBle")
					Citizen.Wait(fermier_blips["Champ"].defaultTime)
				end	

				if isInServiceFermier and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), fermier_blips["Moulin"].x,fermier_blips["Moulin"].y,fermier_blips["Moulin"].z, true) <= fermier_blips["Moulin"].distanceBetweenCoords then
					TriggerServerEvent('fermier:serverRequest', "GetFarine")
					Citizen.Wait(fermier_blips["Moulin"].defaultTime)
				end

				if isInServiceFermier and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), fermier_blips["Point de vente"].x,fermier_blips["Point de vente"].y,fermier_blips["Point de vente"].z, true) <= fermier_blips["Point de vente"].distanceBetweenCoords then
					TriggerServerEvent('fermier:serverRequest', "SellFarine")
					Citizen.Wait(fermier_blips["Point de vente"].defaultTime)
				end
			end
		end)
	end)

	RegisterNetEvent('fermier:marker')
	AddEventHandler('fermier:marker', function ()
		Citizen.CreateThread(function () 
			while fermier_markerBool == true do
				Citizen.Wait(1)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), fermier_blips["Entreprise"].x, fermier_blips["Entreprise"].y, fermier_blips["Entreprise"].z, true) <= fermier_blips["Entreprise"].distanceMarker then
					DrawMarker(1, fermier_blips["Entreprise"].x, fermier_blips["Entreprise"].y, fermier_blips["Entreprise"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					ClearPrints()
					SetTextEntry_2("STRING")
					if isInServiceFermier then
						AddTextComponentString("Appuyez sur ~g~E~s~ pour quitter le ~b~service actif")
					else
						AddTextComponentString("Appuyez sur ~g~E~s~ pour rentrer en ~b~service actif")
					end
					DrawSubtitleTimed(2000, 1)
					if IsControlJustPressed(1, Keys["E"]) then
						GetServiceFermier()
					end
				end
				if isInServiceFermier then
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), fermier_blips["Garage"].x, fermier_blips["Garage"].y, fermier_blips["Garage"].z, true) <= fermier_blips["Garage"].distanceMarker+5 then
						DrawMarker(1, fermier_blips["Garage"].x, fermier_blips["Garage"].y, fermier_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
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
								fermier_InitMenuVehicules()
								Menu.hidden = not Menu.hidden
							end
						end
					end

					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), fermier_blips["Champ"].x,fermier_blips["Champ"].y,fermier_blips["Champ"].z, true) <= fermier_blips["Champ"].distanceMarker then
						DrawMarker(1, fermier_blips["Champ"].x, fermier_blips["Champ"].y, fermier_blips["Champ"].z, 0, 0, 0, 0, 0, 0, 20.001, 20.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), fermier_blips["Moulin"].x,fermier_blips["Moulin"].y,fermier_blips["Moulin"].z, true) <= fermier_blips["Moulin"].distanceMarker then
						DrawMarker(1,fermier_blips["Moulin"].x,fermier_blips["Moulin"].y,fermier_blips["Moulin"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), fermier_blips["Point de vente"].x,fermier_blips["Point de vente"].y,fermier_blips["Point de vente"].z, true) <= fermier_blips["Point de vente"].distanceMarker then
						DrawMarker(1,fermier_blips["Point de vente"].x,fermier_blips["Point de vente"].y,fermier_blips["Point de vente"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
					end
					Menu.renderGUI()
				end
			end
		end)
	end)

function GetServiceFermier()
	local playerPed = GetPlayerPed(-1)
	if isInServiceFermier then
		notif("Vous n\'êtes plus en service")
		TriggerServerEvent("skin_customization:SpawnPlayer")
	else
		notif("Début du service")
		TriggerEvent("fermier:getSkin")
	end
	isInServiceFermier = not isInServiceFermier
	TriggerServerEvent('fermier:setService', isInServiceFermier)
end

	RegisterNetEvent('fermier:getSkin')	
	AddEventHandler('fermier:getSkin', function (source)
		local hashSkin = GetHashKey("mp_m_freemode_01")
		Citizen.CreateThread(function()
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
			SetPedComponentVariation(GetPlayerPed(-1), 11, 97, 0, 2)  -- Top
			SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2)   -- under coat
			SetPedComponentVariation(GetPlayerPed(-1), 4, 62, 1, 2)   -- Pants
			SetPedComponentVariation(GetPlayerPed(-1), 6, 12, 6, 2)   -- shoes
			SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)   -- under skin
		else	
			SetPedComponentVariation(GetPlayerPed(-1), 11, 37, 4, 2)  -- Top
			SetPedComponentVariation(GetPlayerPed(-1), 8, 6, 0, 2)   -- under coat
			SetPedComponentVariation(GetPlayerPed(-1), 4, 62, 0, 2)   -- Pants
			SetPedComponentVariation(GetPlayerPed(-1), 6, 38, 1, 2)   -- shoes
			SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)   -- under skin
		end
		end)
		--TriggerServerEvent("skin_customization:SpawnPlayer")
		--RemoveAllPedWeapons(GetPlayerPed(-1), true)
	end)

	RegisterNetEvent('fermier:getCar')	
	AddEventHandler('fermier:getCar', function (source)
		local vehiculeDetected = GetClosestVehicle(fermier_car.x, fermier_car.y, fermier_car.z, 6.0, 0, 70)
		if not DoesEntityExist(vehiculeDetected) then
			local myPed = GetPlayerPed(-1)
			local player = PlayerId()
			local vehicle = GetHashKey('benson')
			RequestModel(vehicle)
			while not HasModelLoaded(vehicle) do
				Wait(1)
			end
			local plate = math.random(100, 900)
			existingVeh = CreateVehicle(vehicle,fermier_car.x, fermier_car.y, fermier_car.z,120.0, true, false)
			SetVehicleHasBeenOwnedByPlayer(existingVeh,true)
			local id = NetworkGetNetworkIdFromEntity(existingVeh)
			SetNetworkIdCanMigrate(id, true)
			SetEntityInvincible(existingVeh, false)
			SetVehicleOnGroundProperly(existingVeh)
			SetVehicleNumberPlateText(existingVeh, "FERM"..plate.." ")
			SetModelAsNoLongerNeeded(vehicle)
			Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(existingVeh))
		else
			notif("Zone encombrée.")
		end
	end)

	RegisterNetEvent('fermier:drawGetBle')
	AddEventHandler('fermier:drawGetBle', function (qteBle)
		if(qteBle == nil) then
			qteBle = 0
		end
		if qteBle < 30 then
			TriggerEvent('player:receiveItem',10, 1)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Vous avez recolté du blé")
			DrawSubtitleTimed(4500, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Inventaire plein.")
			DrawSubtitleTimed(2000, 1)
		end
	end)

	RegisterNetEvent('fermier:drawGetFarine')
	AddEventHandler('fermier:drawGetFarine', function(qteBle, qteFarine)
		if (qteBle == nil) then
			qteBle = 0
		end
		if (qteFarine == nil) then
			qteFarine = 0
		end
		if qteFarine < 30 and qteBle > 0 then
			TriggerEvent('player:looseItem',10, 1)
			TriggerEvent('player:receiveItem',5, 1)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Vous tranformez votre blé en farine.")
			DrawSubtitleTimed(4500, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous n'avez plus de blé")
			DrawSubtitleTimed(2000, 1)
		end
	end)

	RegisterNetEvent('fermier:drawSellFarine')
	AddEventHandler('fermier:drawSellFarine', function (qte)
		if(qte == nil) then
			qte = 0
		end
		if qte > 0 then
			TriggerEvent('player:looseItem',5, 1)
			local salaire = math.random(fermier_pay.minimum, fermier_pay.maximum)
			TriggerServerEvent('mission:completed', salaire)
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Vous avez vendu de la farine")
			DrawSubtitleTimed(2000, 1)
		else
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~r~Vous n'avez plus de farine")
			DrawSubtitleTimed(2000, 1)
		end
	end)
	