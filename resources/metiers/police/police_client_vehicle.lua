local policeveh = {
	opened = false,
	title = "Cop Garage",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 }, -- ???
	menu = {
		x = 0.11,
		y = 0.25,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				--{name = "Police Stanier", costs = 0, description = {}, model = "police"},
				--{name = "Police Buffalo", costs = 0, description = {}, model = "police2"},
				--{name = "Police Interceptor", costs = 0, description = {}, model = "police3"},
				{name = "Cop Car", costs = 0, description = {}, model = "police4"},
				--{name = "Police Rancher", costs = 0, description = {}, model = "policeold1"},
				--{name = "Police Esperanto", costs = 0, description = {}, model = "policeold2"},
				--{name = "Police Transport Van", costs = 0, description = {}, model = "policet"},
				--{name = "FBI", costs = 0, description = {}, model = "fbi"},
				--{name = "FBI2", costs = 0, description = {}, model = "fbi2"},
				{name = "Cop Motorcycle", costs = 0, description = {}, model = "policeb"},
			
			}
		},
	},
	police3 = { x = 463.3115, y = -1019.43, z = 27.84 , h = 90.02},
	policeb = { x = 463.5075, y = -1014.99, z = 27.5485, h = 90.23},
	policet = { x = 436.1801, y = -996.90, z = 25.74, h = 182,05},
	police4 = { x = 431.47, y = -997.245, z = 25.36, h = 178.83},
}



local fakecar = {model = '', car = nil}
local boughtcar = false
local vehicle_price = 0

function LocalPed()
    return GetPlayerPed(-1)
end




function POLICE_SpanwVehicleCar(data)
    Citizen.Trace('POLICE_SpanwVehicleCar' .. data.model)
    --if fakecar.model ~= data.model then
        if DoesEntityExist(fakecar.car) then
            Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
        end
        local ped = LocalPed()
        local plyCoords = GetEntityCoords(ped, 0)
        local hash = GetHashKey(data.model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end
		local pos = policeveh[data.model]
		Citizen.Trace('P' .. pos.x .. '  '.. pos.y .. '  '.. pos.z .. '  '.. pos.h)
        local veh = CreateVehicle(hash,pos.x,pos.y,pos.z,pos.h,true,false)
		local plate = math.random(100, 900)
		SetVehicleNumberPlateText(veh, "LSPD"..plate.." ")
		SetVehicleMod(veh, 11, 2)
		SetVehicleMod(veh, 12, 2)
		SetVehicleMod(veh, 13, 2)
		SetVehicleEnginePowerMultiplier(veh, 20.0)

        --FreezeEntityPosition(veh,true)
        --SetEntityInvincible(veh,true)
        --SetVehicleDoorsLocked(veh,4)
        --SetEntityCollision(veh,false,false)
        --TaskWarpPedIntoVehicle(LocalPed(),veh,-1)
        -- for i = 0,24 do
        --     SetVehicleModKit(veh,0)
        --     RemoveVehicleMod(veh,i)
        -- end
        fakecar = { model = data.model, car = veh}
--    -- end

end



RegisterNetEvent('policeveh:spawnVehicle')
AddEventHandler('policeveh:spawnVehicle', function(v)
	-- local car = GetHashKey(v)
	-- local playerPed = GetPlayerPed(-1)
	-- if playerPed and playerPed ~= -1 then
	-- 	RequestModel(car)
	-- 	while not HasModelLoaded(car) do
	-- 			Citizen.Wait(0)
	-- 	end
	-- 	local playerCoords = GetEntityCoords(playerPed)

	-- 	veh = CreateVehicle(car, playerCoords, 0.0, true, false)
	-- 	TaskWarpPedIntoVehicle(playerPed, veh, -1)
	-- 	SetEntityInvincible(veh, false)
	-- end
end)