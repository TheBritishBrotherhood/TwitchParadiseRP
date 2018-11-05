function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

local directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N', } 

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())

		for k,v in pairs(directions)do
			direction = GetEntityHeading(GetPlayerPed())
			if(math.abs(direction - k) < 22.5)then
				direction = v
				break;
			end
		end

		if(var2 ~= 0)then
			drawTxt(0.675, 1.42, 1.0,1.0,0.4, "~w~[~y~" .. tostring(GetStreetNameFromHashKey(var2)) .. "~w~]", 255, 255, 255, 255)
		end

		if(GetStreetNameFromHashKey(var1) and GetNameOfZone(pos.x, pos.y, pos.z))then
			if(zones[GetNameOfZone(pos.x, pos.y, pos.z)] and tostring(GetStreetNameFromHashKey(var1)))then
				drawTxt(0.675, 1.45, 1.0,1.0,0.4, direction .. "~b~ | ~y~" .. tostring(GetStreetNameFromHashKey(var1)) .. " ~w~/ ~y~" .. zones[GetNameOfZone(pos.x, pos.y, pos.z)], 255, 255, 255, 255)
			end
		end

		local t = 0
			for i = 0,32 do
				if(GetPlayerName(i))then
					if(NetworkIsPlayerTalking(i))then
						t = t + 1
--
						if(t == 1)then
								drawTxt(0.515, 0.95, 1.0,1.0,0.4, "~y~Talking", 255, 255, 255, 255)
						end
--
						drawTxt(0.520, 0.95 + (t * 0.023), 1.0,1.0,0.4, "" .. GetPlayerName(i), 255, 255, 255, 255)
				end
			end
		end

		--if(IsPedInAnyVehicle(GetPlayerPed(-1), false))then
		--	local speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 2.236936

		--	drawTxt(1.422, 1.40, 1.0,1.0,0.5, "~y~" .. math.ceil(speed) .. "", 255, 255, 255, 255)
		--	drawTxt(1.437, 1.40, 1.0,1.0,0.5, "~b~ mph", 255, 255, 255, 255)
		--end
	end
end)

local showPlayerBlips = false
local ignorePlayerNameDistance = false
local disPlayerNames = 15
local playerSource = 0
 --[[
 function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
--    local fov = (1/GetGameplayCamFov())*100
--    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 0.95*scale)
        SetTextFont(0)
        SetTextProportional(1)
       -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
       SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
    while true do
        for i=0,99 do
            N_0x31698aa80e0223f8(i)
        end
        for id = 0, 31 do
            if  ((NetworkIsPlayerActive( id )) and GetPlayerPed( id ) ~= GetPlayerPed( -1 )) then
                ped = GetPlayerPed( id )
                blip = GetBlipFromEntity( ped )
 
               x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
                x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
              distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
 
                if(ignorePlayerNameDistance) then
                    DrawText3D(x2, y2, z2+1, string.sub(GetPlayerServerId(id), 1, 15))
               end
 
                if ((distance < disPlayerNames)) then
                   if not (ignorePlayerNameDistance) then
                        DrawText3D(x2, y2, z2+1, string.sub(GetPlayerServerId(id), 1, 15))
                    end
                end  
            end
        end
        Citizen.Wait(0)
    end
end)
--]]

local isRadarExtended = false
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0) 
        for i = 0, 100 do
            if NetworkIsPlayerActive(i) and GetPlayerPed(i) ~= GetPlayerPed(-1) then
                local target = GetEntityCoords(GetPlayerPed(i), true)
                local me = GetEntityCoords(GetPlayerPed(-1), true)
                local heading = GetEntityHeading(GetPlayerPed(i))
                local ped = GetPlayerPed( i )
                local blip = GetBlipFromEntity( ped )
                    if(Vdist(me.x, me.y, me.z, target.x, target.y, target.z) <= 10)then
                        if NetworkIsPlayerTalking(i) then
                            DrawMarker(2, target.x, target.y, target.z + 1.0, 0, 0, 0, 0, 0, heading, 0.25, -0.1, -0.25, 150, 0, 0, 100, 0, 0, 2, 0, 0, 0, 0)
							--DrawMarker(27, target.x, target.y, target.z + 1.3, 0, 0, 0, 0, 0, heading, 0.2, 0.1, -0.2, 150, 0, 0, 100, 0, 0, 2, 0, 0, 0, 0)
							--DrawMarker(28, target.x, target.y, target.z + 1.6, 0, 0, 0, 0, 0, heading, 0.2, 0.1, -0.2, 150, 0, 0, 100, 0, 0, 2, 0, 0, 0, 0)

                        else
                            DrawMarker(2, target.x, target.y, target.z + 1.0, 0, 0, 0, 0, 0, heading, 0.25, -0.1, -0.25, 0, 150, 0, 100, 0, 0, 2, 0, 0, 0, 0)
							--DrawMarker(29, target.x, target.y, target.z + 1.3, 0, 0, 0, 0, 0, heading, 0.2, 0.1, -0.2, 0, 150, 0, 100, 0, 0, 2, 0, 0, 0, 0)
							--DrawMarker(31, target.x, target.y, target.z + 1.6, 0, 0, 0, 0, 0, heading, 0.2, 0.1, -0.2, 0, 150, 0, 100, 0, 0, 2, 0, 0, 0, 0)
                        end 
                    end
            end
        end
    end
end)


local showPlayerBlips = false
local ignorePlayerNameDistance = false
local disPlayerNames = 15
local playerSource = 0

function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
    while true do
        for i=0,99 do
            N_0x31698aa80e0223f8(i)
        end
        for id = 0, 31 do
            if  ((NetworkIsPlayerActive( id )) and GetPlayerPed( id ) ~= GetPlayerPed( -1 )) then
                ped = GetPlayerPed( id )
 
                x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
                x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
                distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))

                if(ignorePlayerNameDistance) then
                    DrawText3D(x2, y2, z2+1.25, GetPlayerServerId(id))
                    -- For just the player's source id use this or use the line above for name and source id | DrawText3D(x2, y2, z2+1, GetPlayerServerId(id))
                end

                if ((distance < disPlayerNames)) then
                    if not (ignorePlayerNameDistance) then
                        DrawText3D(x2, y2, z2+1.25, GetPlayerServerId(id))
                        -- For just the player's source id use this or use the line above for name and source id | DrawText3D(x2, y2, z2+1, GetPlayerServerId(id))
                    end
                end  
            end
        end
        Citizen.Wait(0)
    end
end)