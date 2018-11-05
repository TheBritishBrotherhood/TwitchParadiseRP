function GetVehHealthPercent()
	local ped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsUsing(ped)
	local vehiclehealth = GetEntityHealth(vehicle) - 100
	local maxhealth = GetEntityMaxHealth(vehicle) - 100
	local procentage = (vehiclehealth / maxhealth) * 100
	return procentage
end




function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end


Citizen.CreateThread(function()
	while true do

		
		Citizen.Wait(0)

		playerPed = GetPlayerPed(-1)
		if playerPed then
			playerCar = GetVehiclePedIsIn(playerPed, false)
			if playerCar and GetPedInVehicleSeat(playerCar, -1) == playerPed then
				Citizen.Wait(200)
		
				if GetVehicleEngineHealth(playerCar) < 500 then --max 1000 min 0
				   SetVehicleUndriveable(playerCar, 1)
				   -- tester si je tire dessus voir le resultat
				end
			end
		end

	end
end)
