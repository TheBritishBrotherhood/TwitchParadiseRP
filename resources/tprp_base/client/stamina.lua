--ENLEVER LA STAMINA
Citizen.CreateThread(function()
	while true do
		RestorePlayerStamina(PlayerId(), 1.0)
		Citizen.Wait(0)
	end
end)
