local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local notificationParam = 1 -- 1 = LockSystem notification | 2 = chatMessage notification | 3 = nothing
local keyParam = Keys["L"] -- e.g : Keys["H"] will be change the U key to the H key for lock/unlock a vehicle
local soundEnable = true -- Set to false for disable sounds

Citizen.CreateThread(function()
	while true do
		Wait(0)

		local vehicle = GetVehiclePedIsIn(player, false)

		if IsControlJustPressed(1, keyParam) then

			player = GetPlayerPed(-1)
			lastVehicle = GetPlayersLastVehicle()

			playerCoords = GetEntityCoords(player, true)
			px, py, pz = playerCoords.x, playerCoords.y, playerCoords.z

			isPlayerInside = IsPedInAnyVehicle(player, true)

			coordA = GetEntityCoords(player, true)
			
			for i = 1, 32 do
				coordB = GetOffsetFromEntityInWorldCoords(player, 0.0, (6.281)/i, 0.0)	
				targetVehicle = GetVehicleInDirection(coordA, coordB)
				if targetVehicle ~= nil and targetVehicle ~= 0 then
					vx, vy, vz = table.unpack(GetEntityCoords(targetVehicle, false))
						if GetDistanceBetweenCoords(px, py, pz, vx, vy, vz, false) then
							distance = GetDistanceBetweenCoords(px, py, pz, vx, vy, vz, false)
							break
						end
				end
			end

			if distance ~= nil and distance <= 5 and targetVehicle ~= 0 or vehicle ~= 0 then

				if vehicle ~= 0 then
					plate = GetVehicleNumberPlateText(vehicle)
				else
					vehicle = targetVehicle
					plate = GetVehicleNumberPlateText(vehicle)
				end

				TriggerServerEvent("ls:check", plate, vehicle, isPlayerInside, notificationParam)

			end
		end
	end
end)

RegisterNetEvent("ls:lock")
AddEventHandler("ls:lock", function(lockStatus, vehicle)

	isPlayerInside = IsPedInAnyVehicle(player, true)

	if lockStatus == 1 or lockStatus == 0 then

		SetVehicleDoorsLocked(vehicle, 2)
		SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), false)

		TriggerEvent("pNotify:SendNotification",{
            text = "Notification: <br /> Vehicle Locked.",
            type = "success",
            timeout = (1000),
            layout = "centerRight",
            queue = "global"
        })

		if soundEnable then
			TriggerEvent('InteractSound_CL:PlayOnOne', 'lock', 1.0)
		end

		TriggerServerEvent("ls:changeLockStatus", 2, plate)
		
		if not isPlayerInside then
			engineStatus = SetVehicleEngineOn(vehicle, false, true, true)
		end
	else

		SetVehicleDoorsLocked(vehicle, 1)

		TriggerEvent("pNotify:SendNotification",{
            text = "Notification: <br /> Vehicle Unlocked.",
            type = "success",
            timeout = (1000),
            layout = "centerRight",
            queue = "global"
        })

		if soundEnable then
			TriggerEvent('InteractSound_CL:PlayOnOne', 'unlock', 1.0)
		end

		TriggerServerEvent("ls:changeLockStatus", 1, plate)
	end
end)

RegisterNetEvent("ls:notify")
AddEventHandler("ls:notify", function(text, time)

	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_LIFEINVADER", "CHAR_LIFEINVADER", true, 1, "LockSystem", "Version 2.0", time)
	DrawNotification_4(false, true)
end)

function GetVehicleInDirection(coordFrom, coordTo)

	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

RegisterNetEvent("ls:sendNotification")
AddEventHandler("ls:sendNotification", function(param, message, duration)
	if param == 1 then
		TriggerEvent("ls:notify", message, duration)
	elseif param == 2 then
		TriggerEvent('chatMessage', 'LockSystem', { 255, 128, 0 }, message)
	end
end)
