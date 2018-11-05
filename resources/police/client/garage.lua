local buttons = {}
buttons[#buttons+1] = {name = "Police's car", func = "Spawnpolice3"}
buttons[#buttons+1] = {name = "Insignia", func = "Spawnfbi"}
buttons[#buttons+1] = {name = "Police's Motorcycle", func = "Spawnpoliceb"}
buttons[#buttons+1] = {name = "Ford Crown Vic", func = "Spawnpolice"}
buttons[#buttons+1] = {name = "Charger", func = "Spawnpolice2"}
buttons[#buttons+1] = {name = "Police's Sherriff", func = "Spawnsheriff"}
buttons[#buttons+1] = {name = "Police's ranger", func = "Spawnppranger"}
buttons[#buttons+1] = {name = "Police's riot", func = "Spawnriot"}
buttons[#buttons+1] = {name = "Police's undercover", func = "Spawnfbi2"}

function Spawnpolice3()
	SpawnerVeh("police3")
	CloseMenu()
end

function Spawnfbi()
	SpawnerVeh("fbi")
	CloseMenu()
end

function Spawnpoliceb()
	SpawnerVeh("policeb")
	CloseMenu()
end

function Spawnpolice()
	SpawnerVeh("police")
	CloseMenu()
end

function Spawnpolice2()
	SpawnerVeh("police2")
	CloseMenu()
end

function Spawnsheriff()
	SpawnerVeh("sheriff")
	CloseMenu()
end

function Spawnppranger()
	SpawnerVeh("pranger")
	CloseMenu()
end

function Spawnriot()
	SpawnerVeh("riot")
	CloseMenu()
end

function Spawnfbi2()
	SpawnerVeh("fbi2")
	CloseMenu()
end

function SpawnerVeh(hash)
	local car = GetHashKey(hash)
	local playerPed = GetPlayerPed(-1)
	RequestModel(car)
	while not HasModelLoaded(car) do
			Citizen.Wait(0)
	end
	local playerCoords = GetEntityCoords(playerPed)
	policevehicle = CreateVehicle(car, playerCoords, 90.0, true, false)
	SetVehicleMod(policevehicle, 11, 2)
	SetVehicleMod(policevehicle, 12, 2)
	SetVehicleMod(policevehicle, 13, 2)
	SetVehicleEnginePowerMultiplier(policevehicle, 35.0)
	SetVehicleOnGroundProperly(policevehicle)
	SetVehicleHasBeenOwnedByPlayer(policevehicle,true)
	local netid = NetworkGetNetworkIdFromEntity(policevehicle)
	SetNetworkIdCanMigrate(netid, true)
	NetworkRegisterEntityAsNetworked(VehToNet(policevehicle))
	TaskWarpPedIntoVehicle(playerPed, policevehicle, -1)
	SetEntityInvincible(policevehicle, false)
	SetEntityAsMissionEntity(policevehicle, true, true)
end

function OpenGarage()
	SendNUIMessage({
		title = txt[config.lang]["garage_global_title"],
		buttons = buttons,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "garage"
	anyMenuOpen.isActive = true
end