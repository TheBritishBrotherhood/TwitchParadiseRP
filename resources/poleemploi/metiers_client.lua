	
	function metier_callSE(id)
		Menu.hidden = not Menu.hidden
		TriggerServerEvent("metiers:jobs", id)
	end
	
	function menuJobsChomeur()
		local MenujobsList = {
			{name="Fermier", id=6},
			{name="Bucheron", id=7},
			{name="Mineur", id=9},
			{name="Pecheur", id=10},
			{name="Brasseur", id=12},
			{name="Vigneron", id=13},
			--{name="Ambulancier", id=15},
			--{name="Mecano", id=16},
			--{name="Taxi", id=17}
		}
		MenuTitle = "Jobs"
		ClearMenu()
		for _, item in pairs(MenujobsList) do
			Menu.addButton(item.name, "metier_callSE", item.id)
		end
	end

	function menuJobs()
		local MenujobsList = {
			{name="Démissionner", id=1}
		}
		MenuTitle = "Jobs"
		ClearMenu()
		for _, item in pairs(MenujobsList) do
			Menu.addButton(item.name, "metier_callSE", item.id)
		end
	end
	
	function IsNearPlaces()
		local playerCoords = GetEntityCoords(GetPlayerPed(-1), 0)
		for _, item in pairs(metiers_blips) do
			if(GetDistanceBetweenCoords(item.x, item.y, item.z, playerCoords["x"], playerCoords["y"], playerCoords["z"], true) <= item.distanceBetweenCoords) then
				DrawMarker(1, item.x, item.y, item.z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
				return true
			end
		end
	end
	
	RegisterNetEvent('metiers:defineJobMenu')
	AddEventHandler('metiers:defineJobMenu', function(jobId)
		if jobId == 1 then
			menuJobsChomeur()
		else  	
			menuJobs()
		end
	end)
	
	RegisterNetEvent('metiers:getmyjob')
	AddEventHandler('metiers:getmyjob', function(id)
		TriggerServerEvent("metiers:jobs", id)
	end)
	
	RegisterNetEvent('metiers:updateJob')
	AddEventHandler('metiers:updateJob', function(nameJob)
		local id = PlayerId()
		local playerName = GetPlayerName(id)
		
		SendNUIMessage({
			updateJob = true,
			job = nameJob,
			player = playerName
		})
	end)
	
	Citizen.CreateThread( function()	
		for key, item in pairs(metiers_blips) do
			local blip = AddBlipForCoord(item.x, item.y, item.z)
			SetBlipSprite(blip, item.id)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(key)
			EndTextCommandSetBlipName(blip)
		end
		while true do
			Citizen.Wait(2)	
			if (IsNearPlaces() == true) then				
				ClearPrints()
				SetTextEntry_2("STRING")
				AddTextComponentString("Appuyez sur 'Utiliser / E' pour selectionner un ~b~job")
				DrawSubtitleTimed(2000, 1)
				if IsControlJustPressed(1, 51) then
					Menu.hidden = not Menu.hidden 
					TriggerServerEvent('metiers:isChomeur')
				end
				Menu.renderGUI()
			end
		end
	end)
	
	