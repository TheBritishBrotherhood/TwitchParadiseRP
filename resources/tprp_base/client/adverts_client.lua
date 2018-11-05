TriggerServerEvent("Z:newplayer")

timeLeft = 600

RegisterNetEvent("Z:adverthost") AddEventHandler("Z:adverthost", function()  

	Citizen.CreateThread(function()
		while true do 
			Wait(1000)
			timeLeft = timeLeft - 1
			TriggerServerEvent("Z:timeleftsync", timeLeft) 
				
				if timeLeft < 1 then
							timeLeft = 600
			end 
		end
	end)
end)