local bucheron_blipsTemp
local bucheron_markerBool = false
local existingVeh = nil
local isInServiceBucheron = false

function bucheron_callSE(evt)
	Menu.hidden = not Menu.hidden
	Menu.renderGUI()
	TriggerServerEvent(evt)
end

function bucheron_InitMenuVehicules()
	MenuTitle = "SpawnJobs"
	ClearMenu()
	Menu.addButton("Vehicule", "bucheron_callSE", 'bucheron:Car')
end

RegisterNetEvent('bucheron:drawBlips')
AddEventHandler('bucheron:drawBlips', function () 
	for key, item in pairs(bucheron_blips) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipAsShortRange(item.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(key)
		EndTextCommandSetBlipName(item.blip)
	end
	bucheron_blipsTemp = bucheron_blips
end)

RegisterNetEvent('bucheron:deleteBlips')
AddEventHandler('bucheron:deleteBlips', function ()
	bucheron_markerBool = false
	for _, item in pairs(bucheron_blipsTemp) do
		RemoveBlip(item.blip)
	end
end)

RegisterNetEvent('bucheron:drawMarker')
AddEventHandler('bucheron:drawMarker', function (boolean) 
	bucheron_markerBool = boolean
	Citizen.CreateThread(function()
		while bucheron_markerBool == true do
			Wait(0)
			if isInServiceBucheron and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), bucheron_blips["Decoupe"].x,bucheron_blips["Decoupe"].y,bucheron_blips["Decoupe"].z, true) <= bucheron_blips["Decoupe"].distanceBetweenCoords then
				TriggerServerEvent('bucheron:serverRequest', "GetBois")
				Citizen.Wait(bucheron_blips["Decoupe"].defaultTime)
			end	
			if isInServiceBucheron and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), bucheron_blips["Scierie"].x,bucheron_blips["Scierie"].y,bucheron_blips["Scierie"].z, true) <= bucheron_blips["Scierie"].distanceBetweenCoords then
				TriggerServerEvent('bucheron:serverRequest', "GetPlanche")
				Citizen.Wait(bucheron_blips["Scierie"].defaultTime)
			end
		
			if isInServiceBucheron and  GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), bucheron_blips["Point de vente"].x,bucheron_blips["Point de vente"].y,bucheron_blips["Point de vente"].z, true) <= bucheron_blips["Point de vente"].distanceBetweenCoords then
				TriggerServerEvent('bucheron:serverRequest', "SellPlanche")
				Citizen.Wait(bucheron_blips["Point de vente"].defaultTime)
			end
		end
	end)
end)
	
RegisterNetEvent('bucheron:marker')
AddEventHandler('bucheron:marker', function ()
	Citizen.CreateThread(function () 
		while bucheron_markerBool == true do
			Citizen.Wait(1)
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), bucheron_blips["Entreprise"].x, bucheron_blips["Entreprise"].y, bucheron_blips["Entreprise"].z, true) <= bucheron_blips["Entreprise"].distanceMarker then
				DrawMarker(1, bucheron_blips["Entreprise"].x, bucheron_blips["Entreprise"].y, bucheron_blips["Entreprise"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
				ClearPrints()
				SetTextEntry_2("STRING")
				if isInServiceBrasseur then
					AddTextComponentString("Appuyez sur ~g~E~s~ pour quitter le ~b~service actif")
				else
					AddTextComponentString("Appuyez sur ~g~E~s~ pour rentrer en ~b~service actif")
				end
				DrawSubtitleTimed(2000, 1)
				if IsControlJustPressed(1, Keys["E"]) then
					GetServiceBucheron()
				end
			end

			if isInServiceBucheron then
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), bucheron_blips["Garage"].x, bucheron_blips["Garage"].y, bucheron_blips["Garage"].z, true) <= bucheron_blips["Garage"].distanceMarker+5 then
						DrawMarker(1, bucheron_blips["Garage"].x, bucheron_blips["Garage"].y, bucheron_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
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
								bucheron_InitMenuVehicules()
								Menu.hidden = not Menu.hidden
							end
						end
					end
					
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), bucheron_blips["Decoupe"].x,bucheron_blips["Decoupe"].y,bucheron_blips["Decoupe"].z, true) <= bucheron_blips["Decoupe"].distanceMarker then
					DrawMarker(1,bucheron_blips["Decoupe"].x,bucheron_blips["Decoupe"].y,bucheron_blips["Decoupe"].z, 0, 0, 0, 0, 0, 0, 10.001, 10.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
				end
	
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), bucheron_blips["Scierie"].x,bucheron_blips["Scierie"].y,bucheron_blips["Scierie"].z, true) <= bucheron_blips["Scierie"].distanceMarker then
					DrawMarker(1,bucheron_blips["Scierie"].x,bucheron_blips["Scierie"].y,bucheron_blips["Scierie"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
				end

				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), bucheron_blips["Point de vente"].x,bucheron_blips["Point de vente"].y,bucheron_blips["Point de vente"].z, true) <= bucheron_blips["Point de vente"].distanceMarker then
					DrawMarker(1,bucheron_blips["Point de vente"].x,bucheron_blips["Point de vente"].y,bucheron_blips["Point de vente"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
				end
				Menu.renderGUI()
			end
		end
	end)
end)

function notif(message)
	Citizen.CreateThread(function()
		Wait(10)
		SetNotificationTextEntry("STRING")
		AddTextComponentString(message)
		DrawNotification(false, false)
	end)
end

function GetServiceBucheron()
	local playerPed = GetPlayerPed(-1)
	if isInServiceBucheron then
		notif("Vous n\'êtes plus en service")
		TriggerServerEvent("skin_customization:SpawnPlayer")
	else
		notif("Début du service")
		TriggerEvent("bucheron:getSkin")
	end
	isInServiceBucheron = not isInServiceBucheron
	TriggerServerEvent('bucheron:setService', isInServiceBucheron)
end
	
	RegisterNetEvent('bucheron:getSkin')
	AddEventHandler('bucheron:getSkin', function (source)
		local hashSkin = GetHashKey("mp_m_freemode_01")
		Citizen.CreateThread(function()
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
			SetPedComponentVariation(GetPlayerPed(-1), 11, 41, 0, 2)  -- Top
			SetPedComponentVariation(GetPlayerPed(-1), 8, 59, 0, 2)   -- under coat
			SetPedComponentVariation(GetPlayerPed(-1), 4, 7, 0, 2)   -- Pants
			SetPedComponentVariation(GetPlayerPed(-1), 6, 25, 0, 2)   -- shoes
			SetPedComponentVariation(GetPlayerPed(-1), 3, 66, 0, 2)   -- under skin
		else
			SetPedComponentVariation(GetPlayerPed(-1), 11, 109, 0, 2)  -- Top
			SetPedComponentVariation(GetPlayerPed(-1), 8, 1, 0, 2)   -- under coat
			SetPedComponentVariation(GetPlayerPed(-1), 4, 45, 2, 2)   -- Pants
			SetPedComponentVariation(GetPlayerPed(-1), 6, 36, 0, 2)   -- shoes
			SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)   -- under skin
		end
		end)
	end)
	
RegisterNetEvent('bucheron:getCar')
AddEventHandler('bucheron:getCar', function (source)
	local vehiculeDetected = GetClosestVehicle(bucheron_car.x, bucheron_car.y, bucheron_car.z, 6.0, 0, 70)
	if not DoesEntityExist(vehiculeDetected) then
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local vehicle = GetHashKey('hauler')
		RequestModel(vehicle)
		while not HasModelLoaded(vehicle) do
			Wait(1)
		end
		local plate = math.random(100, 900)
		existingVeh = CreateVehicle(vehicle,bucheron_car.x, bucheron_car.y, bucheron_car.z,0.0, true, false)
		SetVehicleHasBeenOwnedByPlayer(existingVeh,true)
		local id = NetworkGetNetworkIdFromEntity(existingVeh)
		SetNetworkIdCanMigrate(id, true)
		SetEntityInvincible(existingVeh, false)
		SetVehicleOnGroundProperly(existingVeh)
		SetVehicleNumberPlateText(existingVeh, bucheron_platesuffix.." "..plate.." ")
		SetModelAsNoLongerNeeded(vehicle)
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(existingVeh))
	else
		notif("Zone encombrée.")
	end
end)


RegisterNetEvent('bucheron:drawGetBois')
AddEventHandler('bucheron:drawGetBois', function (qteBois)
	if(qteBois == nil) then
		qteBois = 0
	end

	if qteBois < 30 then
		TriggerEvent('player:receiveItem',19, 1)
		ClearPrints()
		SetTextEntry_2("STRING")
		AddTextComponentString("~g~Bois chargé sur la remorque")
		DrawSubtitleTimed(4500, 1)
	else
		ClearPrints()
		SetTextEntry_2("STRING")
		AddTextComponentString("~r~Vous ne pouvez plus prendre de bois")
		DrawSubtitleTimed(2000, 1)
	end
end)

RegisterNetEvent('bucheron:drawGetPlanche')
AddEventHandler('bucheron:drawGetPlanche', function(qteBois, qtePlanche)
	if(qteBois == nil) then
		qteBois = 0
	end
	
	if(qtePlanche == nil) then
		qtePlanche = 0
	end

	if qtePlanche < 30 and qteBois > 0 then
		TriggerEvent('player:looseItem',19, 1)
		TriggerEvent('player:receiveItem',20, 1)
		ClearPrints()
		SetTextEntry_2("STRING")
		AddTextComponentString("~g~ Déchargement du bois et chargement de planches")
		DrawSubtitleTimed(4500, 1)
	else
		ClearPrints()
		SetTextEntry_2("STRING")
		AddTextComponentString("~r~Vous ne pouvez plus Charger de bois")
		DrawSubtitleTimed(2000, 1)
	end
end)

RegisterNetEvent('bucheron:drawSellPlanche')
AddEventHandler('bucheron:drawSellPlanche', function (qte)
	if(qte == nil) then
		qte = 0
	end

	if qte > 0 then
		TriggerEvent('player:looseItem',20, 1)
		local salaire = math.random(bucheron_pay.minimum, bucheron_pay.maximum)
		TriggerServerEvent('mission:completed', salaire)
		ClearPrints()
		SetTextEntry_2("STRING")
		AddTextComponentString("~g~Vous avez vendu des planches")
		DrawSubtitleTimed(2000, 1)
	else
		ClearPrints()
		SetTextEntry_2("STRING")
		AddTextComponentString("~r~Vous n'avez plus de planche")
		DrawSubtitleTimed(2000, 1)
	end
end)

