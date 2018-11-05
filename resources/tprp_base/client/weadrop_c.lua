-- Script édité par [GDN]Ashgal le 13.06.2017 - inspired by HBK


local key = 56 -- Key pressed for drop! [56] is default Drop weapon key in GTA:O


--Drop your weapon fonction
RegisterNetEvent("dropweapon")
AddEventHandler('dropweapon', function()
	
	local ped = GetPlayerPed(-1)
	local wep = GetSelectedPedWeapon(ped)

	if DoesEntityExist(ped) and not IsEntityDead(ped) then
		SetPedDropsInventoryWeapon(GetPlayerPed(-1), wep, 0, 2.0, 0, -1) --drop weapon on the ground
		GiveWeaponToPed(ped, 0xA2719263, 0, 0, 1) --set unarmed
		ShowNotification("~w~You dropped your ~r~weapon ~w~on the ground.") -- EN: ~w~You dropped your ~r~weapon ~w~on the ground
	end
end)

--Notification fonction
function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

--Keybinding fonction
Citizen.CreateThread(function()
	while true do
		Wait(0)
			if IsControlJustPressed(1, key) then
				TriggerServerEvent("drops")
			end
		end 
end)
