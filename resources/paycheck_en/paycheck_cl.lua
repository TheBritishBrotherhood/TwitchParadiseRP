Citizen.CreateThread(function ()
	while true do
	Citizen.Wait(900000) -- 900000 Change this value for the frequency of paycheck (600000 = 10 minutes) 468000
		TriggerServerEvent('paycheck:welfare')
	end
end)
