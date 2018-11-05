-- Scripted by X. Cross && Jon P. --
RegisterNetEvent("Handsup")
AddEventHandler("Handsup", function()
	local lPed = GetPlayerPed(-1)
	if DoesEntityExist(lPed) then
		Citizen.CreateThread(function()
			RequestAnimDict("random@mugging3")
			while not HasAnimDictLoaded("random@mugging3") do
				Citizen.Wait(100)
			end
			
			if IsEntityPlayingAnim(lPed, "random@mugging3", "handsup_standing_base", 3) then
				ClearPedSecondaryTask(lPed)
				SetEnableHandcuffs(lPed, false)
				TriggerEvent("chatMessage", "", {255, 0, 0}, "Your have put your hands down.")
			else
				TaskPlayAnim(lPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
				SetEnableHandcuffs(lPed, true)
				TriggerEvent("chatMessage", "", {255, 0, 0}, "Your hands are up.")
			end		
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 73) then -- INPUT_CELLPHONE_DOWN
			local lPed = GetPlayerPed(-1)
			if DoesEntityExist(lPed) then
				Citizen.CreateThread(function()
					RequestAnimDict("random@mugging3")
					while not HasAnimDictLoaded("random@mugging3") do
						Citizen.Wait(100)
					end
					
					if IsEntityPlayingAnim(lPed, "random@mugging3", "handsup_standing_base", 3) then
						ClearPedSecondaryTask(lPed)
						SetEnableHandcuffs(lPed, false)
						TriggerEvent("chatMessage", "", {255, 0, 0}, "Your have put your hands down.")
					else
						TaskPlayAnim(lPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
						SetEnableHandcuffs(lPed, true)
						TriggerEvent("chatMessage", "", {255, 0, 0}, "Your hands are up.")
					end		
				end)
			end  
		end	
	end
end)