-- FiveM Heli Cam by mraes
-- Version 1.3 2017-06-12
-- Modified version incorporating spotlight and other tweaks by Loque and by rjross2013. Credits for tips gleaned from these mods: Guadmaz's Simple Police Searchlight, devilkkw's Speed Camera and nynjardin's Simple Outlaw Alert.

-- config
local brightness = 1.0
local fov_max = 80.0
local fov_min = 10.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 3.0 -- camera zoom speed
local speed_lr = 4.0 -- speed by which the camera pans left-right 
local speed_ud = 4.0 -- speed by which the camera pans up-down
local toggle_helicam = 51 -- control id of the button by which to toggle the helicam mode. Default: INPUT_CONTEXT (E)
local toggle_vision = 25 -- control id to toggle vision mode. Default: INPUT_AIM (Right mouse btn)
local toggle_rappel = 154 -- control id to rappel out of the heli. Default: INPUT_DUCK (X)
local toggle_spotlight = 183 -- control id to toggle the various spotlight states Default: INPUT_PhoneCameraGrid (G)
local toggle_lock_on = 22 -- control id to lock onto a vehicle with the camera or unlock from vehicle (with or without camera). Default is INPUT_SPRINT (spacebar)
local toggle_display = 44 -- control id to toggle vehicle info display. Default: INPUT_COVER (Q)
local maxtargetdistance = 700 -- max distance at which target lock is maintained

-- Script starts here
local target_vehicle = nil
local new_target = nil
local manual_spotlight = false
local vehicle_display = 0 -- 0 is default full vehicle info display with speed/model/plate, 1 is model/plate, 2 turns off display
local helicam = false
local polmav_hash = GetHashKey("polmav")
local fov = (fov_max+fov_min)*0.5
local vision_state = 0 -- 0 is normal, 1 is nightmode, 2 is thermal vision

Citizen.CreateThread(function() -- Register ped decorators used to pass some variables from heli pilot to other players (variable settings: 1=false, 2=true)
	while true do
	Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			DecorRegister("EnableTrackingSpotlight", 3)
			DecorRegister("EnableManualSpotlight", 3)
			DecorRegister("DeleteTarget", 3)
			DecorRegister("PauseTrackingSpotlight", 3)
			DecorRegister("xSpotvector", 3)
			DecorRegister("ySpotvector", 3)
			DecorRegister("zSpotvector", 3)
			return
		end
	end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
		if IsPlayerInPolmav() then
			local lPed = GetPlayerPed(-1)
			local heli = GetVehiclePedIsIn(lPed)
			
			if IsHeliHighEnough(heli) then
				if IsControlJustPressed(0, toggle_helicam) then -- Toggle Helicam
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					helicam = true
				end
				
				if IsControlJustPressed(0, toggle_rappel) then -- Initiate rappel
					Citizen.Trace("try to rappel")
					if GetPedInVehicleSeat(heli, 1) == lPed or GetPedInVehicleSeat(heli, 2) == lPed then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						TaskRappelFromHeli(GetPlayerPed(-1), 1)
					else
						SetNotificationTextEntry( "STRING" )
						AddTextComponentString("~r~Can't rappel from this seat")
						DrawNotification(false, false )
						PlaySoundFrontend(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false) 
					end
				end
			end
			
			if IsControlJustPressed(0, toggle_spotlight) and GetPedInVehicleSeat(heli, -1) == lPed and not helicam then -- Toggle forward and tracking spotlight states
				if target_vehicle then
					if DecorGetInt(lPed, "EnableTrackingSpotlight") == 2 then
						if DecorGetInt(lPed, "PauseTrackingSpotlight") == 1 then
							DecorSetInt(lPed, "PauseTrackingSpotlight", 2) 
						else
							DecorSetInt(lPed, "PauseTrackingSpotlight", 1)
						end
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					else
						spotlight_state = false	
						TriggerServerEvent("heli:forward.spotlight", spotlight_state)
						DecorSetInt(lPed, "EnableTrackingSpotlight", 2)
						DecorSetInt(lPed, "PauseTrackingSpotlight", 1)
						TriggerServerEvent("heli:tracking.spotlight", target_vehicle)
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					end				
				else
					DecorSetInt(lPed, "EnableTrackingSpotlight", 1)
					DecorSetInt(lPed, "PauseTrackingSpotlight", 1)
					spotlight_state = not spotlight_state
					TriggerServerEvent("heli:forward.spotlight", spotlight_state)
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
				end
			end

			if IsControlJustPressed(0, toggle_lock_on) and GetPedInVehicleSeat(heli, -1) == lPed then -- Delete target
				DecorSetInt(lPed, "DeleteTarget", 2)
				DecorSetInt(lPed, "EnableTrackingSpotlight", 1)
				DecorSetInt(lPed, "PauseTrackingSpotlight", 1) 
				target_vehicle = nil
				new_target = nil
				PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
			end

			if DecorGetInt(lPed, "DeleteTarget") == 2 then
				target_vehicle = nil
				new_target = nil
				Citizen.Wait(5)
				DecorSetInt(lPed, "DeleteTarget", 1)
			end

			if IsControlJustPressed(0, toggle_display) and GetPedInVehicleSeat(heli, -1) == lPed then 
				ChangeDisplay()
			end
		end
		
		if helicam then
			SetTimecycleModifier("heliGunCam")
			SetTimecycleModifierStrength(0.3)
			local scaleform = RequestScaleformMovie("HELI_CAM")
			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(0)
			end
			local lPed = GetPlayerPed(-1)
			local heli = GetVehiclePedIsIn(lPed)
			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
			AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(heli))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(1) -- 0 for nothing, 1 for LSPD logo
			PopScaleformMovieFunctionVoid()
			local locked_on_vehicle = nil
			while helicam and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == heli) and IsHeliHighEnough(heli) do
				if IsControlJustPressed(0, toggle_helicam) then -- Toggle Helicam
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					if manual_spotlight and target_vehicle then
						DecorSetInt(lPed, "EnableTrackingSpotlight", 2)
						DecorSetInt(lPed, "PauseTrackingSpotlight", 1)
						TriggerServerEvent("heli:tracking.spotlight", target_vehicle)
					end
					manual_spotlight = false
					DecorSetInt(lPed, "EnableManualSpotlight", 1)
					helicam = false
					--brightness = 2
				end

				if IsControlJustPressed(0, toggle_vision) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					ChangeVision()
				end

				if IsControlJustPressed(0, toggle_spotlight) then
					if DecorGetInt(lPed, "EnableTrackingSpotlight") == 2 then -- Pause tracking spotlight 
						DecorSetInt(lPed, "PauseTrackingSpotlight", 2)
						manual_spotlight = not manual_spotlight
						if manual_spotlight then
							DecorSetInt(lPed, "EnableManualSpotlight", 2)
							DecorSetInt(lPed, "xSpotvector", xSpotvector)
							DecorSetInt(lPed, "ySpotvector", ySpotvector)
							DecorSetInt(lPed, "zSpotvector", zSpotvector)
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							TriggerServerEvent("heli:manual.spotlight")
						else
							DecorSetInt(lPed, "EnableManualSpotlight", 1)
						end
					elseif spotlight_state then -- Turn off forward spotlight
						spotlight_state = false
						TriggerServerEvent("heli:forward.spotlight", spotlight_state)
						manual_spotlight = not manual_spotlight
						if manual_spotlight then
							DecorSetInt(lPed, "EnableManualSpotlight", 2)
							DecorSetInt(lPed, "xSpotvector", xSpotvector)
							DecorSetInt(lPed, "ySpotvector", ySpotvector)
							DecorSetInt(lPed, "zSpotvector", zSpotvector)
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							TriggerServerEvent("heli:manual.spotlight")
						else
							DecorSetInt(lPed, "EnableManualSpotlight", 1)
						end
					else
						manual_spotlight = not manual_spotlight
						if manual_spotlight then
							DecorSetInt(lPed, "EnableManualSpotlight", 2)
							DecorSetInt(lPed, "xSpotvector", xSpotvector)
							DecorSetInt(lPed, "ySpotvector", ySpotvector)
							DecorSetInt(lPed, "zSpotvector", zSpotvector)
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							TriggerServerEvent("heli:manual.spotlight")
						else
							DecorSetInt(lPed, "EnableManualSpotlight", 1)
						end
					end
				end

				if IsControlJustPressed(0, 246) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					if manual_spotlight then
						lightUp()
					end
				end

				if IsControlJustPressed(0, 173) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					if manual_spotlight then
						lightDown()
					end
				end

				if IsControlJustPressed(0, toggle_display) then 
					ChangeDisplay()
				end

				if locked_on_vehicle then
					if DoesEntityExist(locked_on_vehicle) then
						PointCamAtEntity(cam, locked_on_vehicle, 0.0, 0.0, 0.0, true)
						RenderVehicleInfo(locked_on_vehicle)
						local coords1 = GetEntityCoords(heli)
						local coords2 = GetEntityCoords(locked_on_vehicle)
						local target_distance = GetDistanceBetweenCoords(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z, false)
						if IsControlJustPressed(0, toggle_lock_on) or target_distance > maxtargetdistance then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							locked_on_vehicle = nil
							target_vehicle = nil
							local rot = GetCamRot(cam, 2) -- All this because I can't seem to get the camera unlocked from the entity
							local fov = GetCamFov(cam)
							local old cam = cam
							DestroyCam(old_cam, false)
							cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
							AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
							SetCamRot(cam, rot, 2)
							SetCamFov(cam, fov)
							RenderScriptCams(true, false, 0, 1, 0)
						end
					else
						locked_on_vehicle = nil -- Cam will auto unlock when entity doesn't exist anyway
						target_vehicle = nil
					end
				else
					local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
					CheckInputRotation(cam, zoomvalue)
					local vehicle_detected = GetVehicleInView(cam)
					if DoesEntityExist(vehicle_detected) then
						RenderVehicleInfo(vehicle_detected)
						if IsControlJustPressed(0, toggle_lock_on) then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							DecorSetInt(lPed, "DeleteTarget", 1)
							locked_on_vehicle = vehicle_detected
							if target_vehicle then
								new_target = vehicle_detected
								target_vehicle = nil
								toggle = false
								TriggerServerEvent("heli:target.change", new_target) 
							else
								target_vehicle = vehicle_detected
							end
						end
					end
				end

				HandleZoom(cam)
				HideHUDThisFrame()
				PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
				PushScaleformMovieFunctionParameterFloat(GetEntityCoords(heli).z)
				PushScaleformMovieFunctionParameterFloat(zoomvalue)
				PushScaleformMovieFunctionParameterFloat(GetCamRot(cam, 2).z)
				PopScaleformMovieFunctionVoid()
				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				Citizen.Wait(0)

				if manual_spotlight then
					local helicoords = GetEntityCoords(heli)
					local rotation = GetCamRot(cam, 2)
					local forward_vector = RotAnglesToVec(rotation)
					local xSpotvector, ySpotvector, zSpotvector = table.unpack(forward_vector)
					local camcoords = GetCamCoord(cam)
					DecorSetInt(lPed, "EnableManualSpotlight", 2)
					DecorSetInt(lPed, "xSpotvector", xSpotvector)
					DecorSetInt(lPed, "ySpotvector", ySpotvector)
					DecorSetInt(lPed, "zSpotvector", zSpotvector)
				else
					DecorSetInt(lPed, "EnableManualSpotlight", 1)
				end

			end
			DecorSetInt(lPed, "EnableManualSpotlight", 1)
			helicam = false
			ClearTimecycleModifier()
			fov = (fov_max+fov_min)*0.5 -- reset to starting zoom level
			RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
			SetScaleformMovieAsNoLongerNeeded(scaleform) -- Cleanly release the scaleform
			DestroyCam(cam, false)
			SetNightvision(false)
			SetSeethrough(false)
		end

		if target_vehicle and not helicam and vehicle_display ~=2 then
			RenderVehicleInfo(target_vehicle)
		end
	end
end)

RegisterNetEvent('heli:forward.spotlight')
AddEventHandler('heli:forward.spotlight', function(serverID, state)
	local heli = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverID)), false)
	SetVehicleSearchlight(heli, state, false)
end)

RegisterNetEvent('heli:tracking.spotlight')
AddEventHandler('heli:tracking.spotlight', function(serverID, target_vehicle)
	local heli = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverID)), false)
	heliPed = GetPlayerPed(GetPlayerFromServerId(serverID))
	while not IsEntityDead(heliPed) and (GetVehiclePedIsIn(heliPed) == heli) and target_vehicle and (DecorGetInt(heliPed, "EnableTrackingSpotlight") == 2) do
		Citizen.Wait(1)
		if new_target then -- Target change
			target_vehicle = new_target
			new_target = nil
		end
		local helicoords = GetEntityCoords(heli)
		local targetcoords = GetEntityCoords(target_vehicle)
		local spotVector = targetcoords - helicoords
		local target_distance = (Vdist(targetcoords, helicoords) + 20)
		if DecorGetInt(heliPed, "DeleteTarget") == 2 or target_distance > maxtargetdistance then -- Target loss or deletion
			DecorSetInt(heliPed, "DeleteTarget", 2)
			new_target = nil
			target_vehicle = nil
			Citizen.Wait(10)
			DecorSetInt(heliPed, "DeleteTarget", 1)
			DecorSetInt(heliPed, "PauseTrackingSpotlight", 1)
			DecorSetInt(heliPed, "EnableTrackingSpotlight", 1)
			break
		end
		if DecorGetInt(heliPed, "PauseTrackingSpotlight") ~= 2 then
			DrawSpotLight(helicoords['x'], helicoords['y'], helicoords['z'], spotVector['x'], spotVector['y'], spotVector['z'], 255, 255, 255, target_distance, 10.0, brightness, 4.0, 1.0, 0.0)
		end
	end
	Citizen.Wait(5)
	new_target = nil
	target_vehicle = nil 
	DecorSetInt(heliPed, "EnableTrackingSpotlight", 1)
	DecorSetInt(heliPed, "DeleteTarget", 1)
	DecorSetInt(heliPed, "PauseTrackingSpotlight", 1)
end)

RegisterNetEvent('heli:manual.spotlight')
AddEventHandler('heli:manual.spotlight', function(serverID)
    --if GetPlayerServerId(PlayerId()) ~= serverID then -- If working, this could skip event for the source, allowing an improved client-side spotlight for heli pilot

	local heli = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverID)), false)
	heliPed = GetPlayerPed(GetPlayerFromServerId(serverID))
	while not IsEntityDead(heliPed) and (GetVehiclePedIsIn(heliPed) == heli) and (DecorGetInt(heliPed, "EnableManualSpotlight") == 2) do
		Citizen.Wait(0)
		local helicoords = GetEntityCoords(heli)
		spotoffset = helicoords + vector3(0.0, 0.0, -1.5)
		xSpotvector = DecorGetInt(heliPed, "xSpotvector")
		ySpotvector = DecorGetInt(heliPed, "ySpotvector")
		zSpotvector = DecorGetInt(heliPed, "zSpotvector")
		DrawSpotLight(spotoffset['x'], spotoffset['y'], spotoffset['z'], xSpotvector, ySpotvector, zSpotvector, 255, 255, 255, 800.0, 4.0, brightness, 6.0, 1.0, 1.0)
	end
	DecorSetInt(heliPed, "EnableManualSpotlight", 1)
    --end
end)

RegisterNetEvent('heli:target.change')
AddEventHandler('heli:target.change', function(serverID, new_target)
	if new_target then
		target_vehicle = new_target
		new_target = nil
	end
end)

function lightUp()
	brightness = brightness + 1.0
end

function lightDown()
	brightness = brightness - 1.0
end

function IsPlayerInPolmav()
	local lPed = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(lPed)
	return IsVehicleModel(vehicle, polmav_hash)
end

function IsHeliHighEnough(heli)
	return GetEntityHeightAboveGround(heli) > 1.5
end

function ChangeVision()
	if vision_state == 0 then
		SetNightvision(true)
		vision_state = 1
	elseif vision_state == 1 then
		SetNightvision(false)
		SetSeethrough(true)
		vision_state = 2
	else
		SetSeethrough(false)
		vision_state = 0
	end
end

function ChangeDisplay()
	if vehicle_display == 0 then
		vehicle_display = 1
	elseif vehicle_display == 1 then
		vehicle_display = 2
	else
		vehicle_display = 0
	end
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(19) -- weapon wheel
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5) -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	if IsControlJustPressed(0,241) then -- Scrollup
		fov = math.max(fov - zoomspeed, fov_min)
	end
	if IsControlJustPressed(0,242) then
		fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown		
	end
	local current_fov = GetCamFov(cam)
	if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
		fov = current_fov
	end
	SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
end

function GetVehicleInView(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
	--DrawLine(coords, coords+(forward_vector*100.0), 255,0,0,255) -- debug line to show LOS of cam
	local rayhandle = CastRayPointToPoint(coords, coords+(forward_vector*200.0), 10, GetVehiclePedIsIn(GetPlayerPed(-1)), 0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit>0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

function RenderVehicleInfo(vehicle)
	if DoesEntityExist(vehicle) then
		local model = GetEntityModel(vehicle)
		local vehname = GetLabelText(GetDisplayNameFromVehicleModel(model))
		local licenseplate = GetVehicleNumberPlateText(vehicle)
		local vehspeed = GetEntitySpeed(vehicle)*3.6
		--local vehspeed = GetEntitySpeed(vehicle)*2.236936 -- to change to Mph, use this line instead of previous, and update relevant text in AddTextComponentString line below
		SetTextFont(0)
		SetTextProportional(1)
		if vehicle_display == 0 then
			SetTextScale(0.0, 0.49)
		elseif vehicle_display == 1 then
			SetTextScale(0.0, 0.55)
		end
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		if vehicle_display == 0 then
			AddTextComponentString("Speed: "..math.ceil(vehspeed).." Km/h\nModel: "..vehname.."\nPlate: "..licenseplate)
		elseif vehicle_display == 1 then
			AddTextComponentString("Model: "..vehname.."\nPlate: "..licenseplate)
		end
		DrawText(0.45, 0.9)
	end
end

function RotAnglesToVec(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end