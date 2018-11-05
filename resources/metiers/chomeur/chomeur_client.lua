	local chomeur_markerBool = false
	local existingVeh = nil

	RegisterNetEvent('chomeur:drawBlips')
	AddEventHandler('chomeur:drawBlips', function () 

	end)

	RegisterNetEvent('chomeur:deleteBlips')
	AddEventHandler('chomeur:deleteBlips', function ()
		chomeur_markerBool = false
	end)
	
	RegisterNetEvent('chomeur:drawMarker')
	AddEventHandler('chomeur:drawMarker', function (boolean) 
		chomeur_markerBool = boolean
	end)

	RegisterNetEvent('chomeur:marker')
	AddEventHandler('chomeur:marker', function ()
	TriggerServerEvent("skin_customization:SpawnPlayer")
		
	end)

	RegisterNetEvent('chomeur:getSkin')
	AddEventHandler('chomeur:getSkin', function (source)
		-- local playerPed = GetPlayerPed(-1)
			
		-- SetPedComponentVariation(playerPed, 11, 5, 0, 2)  -- Top
		-- SetPedComponentVariation(playerPed, 8, 59, 0, 2)   -- under coat
		-- SetPedComponentVariation(playerPed, 4, 0, 12, 2)   -- Pants
		-- SetPedComponentVariation(playerPed, 6, 25, 0, 2)   -- shoes
		-- SetPedComponentVariation(playerPed, 3, 34, 0, 2)   -- under skin
		TriggerServerEvent("skin_customization:SpawnPlayer")
		--RemoveAllPedWeapons(GetPlayerPed(-1), true)
		existingVeh = nil
	end)
	
