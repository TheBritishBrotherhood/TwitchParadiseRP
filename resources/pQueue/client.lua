Citizen.CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			TriggerServerEvent("pQueue:playerActivated")
		end
	end
end)