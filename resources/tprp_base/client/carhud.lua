function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

Citizen.CreateThread(function()
	while true do
	
		Citizen.Wait(1)
		local get_ped = GetPlayerPed(-1) -- current ped
		local get_ped_veh = GetVehiclePedIsIn(GetPlayerPed(-1),false) -- Current Vehicle ped is in
		local plate_veh = GetVehicleNumberPlateText(get_ped_veh) -- Vehicle Plate
		local veh_stop = IsVehicleStopped(get_ped_veh) -- Parked or not
		local veh_engine_health = GetVehicleEngineHealth(get_ped_veh) -- Vehicle Engine Damage 
		local veh_body_health = GetVehicleBodyHealth(get_ped_veh)
		local veh_burnout = IsVehicleInBurnout(get_ped_veh) -- Vehicle Burnout


		if(IsPedInAnyVehicle(GetPlayerPed(-1), false))then
			local mph = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 2.236936
			
			drawRct(0.11, 0.932, 0.046,0.03,0,0,0,100) 	-- UI:panel kmh	

			drawRct(0.159, 0.760, 0.005,0.208,0,0,0,100)  -- UI:engine_damage
			drawRct(0.1661, 0.760, 0.005,0.208,0,0,0,100)  -- UI:body_damage
			drawRct(0.1661, 0.760, 0.005,veh_body_health/4800,0,0,0,100)  -- UI:body_damage
			drawRct(0.159, 0.718, 0.0122, 0.038, 0,0,0,150)        -- UI: 1
			drawRct(0.028, 0.727, 0.029, 0.02, 0,0,0,150)          -- UI: 2
			drawRct(0.1131, 0.727, 0.031, 0.02, 0,0,0,150)         -- UI: 3
			drawRct(0.1445, 0.727, 0.0129, 0.028, 0,0,0,150)       -- UI: 4------
			drawRct(0.0148, 0.727, 0.013, 0.028, 0,0,0,150)         -- UI: 5
			drawRct(0.0625, 0.718, 0.045, 0.037, 0,0,0,150)        -- UI: 6 --here
			drawRct(0.01445, 0.718, 0.043, 0.007, 0,0,0,150)         -- UI: 7
			drawRct(0.0279, 0.748, 0.0293, 0.007, 0,0,0,150)       -- UI: 8 --here
			drawRct(0.0575, 0.718, 0.004, 0.037, 0,0,0,150)        -- UI: 9
			drawRct(0.1131, 0.718, 0.044, 0.007, 0,0,0,150)        -- UI: 10
			drawRct(0.1131, 0.748, 0.031, 0.007, 0,0,0,150)        -- UI: 11
			drawRct(0.1085, 0.718, 0.004, 0.037, 0,0,0,150)        -- UI: 12
			
			drawTxt(0.61, 1.42, 1.0,1.0,0.64 , "~w~" .. math.ceil(mph), 255, 255, 255, 255)  -- INT: kmh
			drawTxt(0.633, 1.432, 1.0,1.0,0.4, "~w~ mph", 255, 255, 255, 255)	-- TXT: kmh
			drawTxt(0.563, 1.213, 1.0,1.0,0.55, "~w~" .. plate_veh, 255, 255, 255, 255) -- TXT: Plate	

			if veh_burnout then
			drawTxt(0.535, 1.216, 1.0,1.0,0.44, "~r~DSC", 255, 255, 255, 200) -- TXT: DSC {veh_burnout}
			else
			drawTxt(0.535, 1.216, 1.0,1.0,0.44, "DSC", 255, 255, 255, 150)
			end		
			
			if (veh_engine_health > 0) and (veh_engine_health < 300) then
				drawTxt(0.619, 1.216, 1.0,1.0,0.45, "~y~Fuel", 255, 255, 255, 200) -- TXT: Fluid
				drawTxt(0.514, 1.216, 1.0,1.0,0.45, "~w~~y~E", 255, 255, 255, 200) -- TXT: Oil
				drawTxt(0.645, 1.216, 1.0,1.0,0.45, "~y~F", 255, 255, 255, 200)
			elseif veh_engine_health < 1 then 
				drawRct(0.159, 0.809, 0.005, 0,0,0,0,100)  -- panel damage
				drawTxt(0.645, 1.270, 1.0,1.0,0.45, "~r~F", 255, 255, 255, 200)
				drawTxt(0.619, 1.216, 1.0,1.0,0.45, "~r~Fuel", 255, 255, 255, 200) -- TXT: Fluid
				drawTxt(0.514, 1.216, 1.0,1.0,0.45, "~w~~r~E", 255, 255, 255, 200) -- TXT: Oil
				drawTxt(0.645, 1.216, 1.0,1.0,0.45, "~r~F", 255, 255, 255, 200)
			else
				drawTxt(0.619, 1.216, 1.0,1.0,0.45, "Fuel", 255, 255, 255, 150) -- TXT: Fluid
				drawTxt(0.514, 1.216, 1.0,1.0,0.45, "E", 255, 255, 255, 150) -- TXT: Oil
				drawRct(0.159, 0.760, 0.005, veh_engine_health / 4800,0,0,0,100)  -- panel damage
				drawTxt(0.645, 1.216, 1.0,1.0,0.45, "~w~F", 255, 255, 255, 150)
			end	
			--
			if enableCruise == true then
				drawRct(0.11, 0.895, 0.046,0.03,0,0,0,100)
                drawTxt(0.615, 1.391, 1.0,1.0,0.4, "~g~ Cruise On", 255, 255, 255, 255)
            else
            	drawRct(0.11, 0.895, 0.046,0.03,0,0,0,100)
                drawTxt(0.615, 1.391, 1.0,1.0,0.4, "~r~ Cruise Off", 255, 255, 255, 255)
            end
            --
			if veh_stop then
				drawTxt(0.6605, 1.213, 1.0,1.0,0.6, "~r~P", 255, 255, 255, 200)
			else
				drawTxt(0.6605, 1.213, 1.0,1.0,0.6, "P", 255, 255, 255, 150)
			end
		end		
	end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait( 0 )   
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local vehicleModel = GetEntityModel(vehicle)
        local speed = GetEntitySpeed(vehicle)
        local float Max = GetVehicleMaxSpeed(vehicleModel)
        
        if ( ped ) then
            if IsControlJustPressed(1, 20) then -- Z [CONTROL_KEY: multiplayer info]
                local inVehicle = IsPedSittingInAnyVehicle(ped)
                if (inVehicle) then
                    if (GetPedInVehicleSeat(vehicle, -1) == ped) then
                        if enableCruise == false then
                            SetEntityMaxSpeed(vehicle, speed)
                            enableCruise = true
                        else
                            SetEntityMaxSpeed(vehicle, Max)
                            enableCruise = false
                        end
                    else
                    end
                end
            end
        end
    end
end)