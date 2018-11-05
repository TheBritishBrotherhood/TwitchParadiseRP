local myVehiculeEntity = nil
local otherVehicle = nil
local inService = false
local alarmValue = 0
local alarmVehicle = 0
local alarmDelay = 500
local ShowLineGrueHelp = true
local VehicleModelKeyTowTruck = GetHashKey('towtruck')
local VehicleModelKeyFlatBed = GetHashKey('flatbed')
local spawnVehicleChoix = {}
local KEY_E = 38
local KEY_UP = 96 -- N+
local KEY_DOWN = 97 -- N-
local KEY_CLOSE = 177
local currentBlip = nil 
local listMissions = {}
local currentMissions = nil
local myCallMission = nil 
local mecano_nbMissionEnAttenteText = '-- Aucune Info --'
local mecano_BlipMecano = {}
local mecano_showHelp = false
local mecano_call_accept = 0
local mecano_nbMecanoInService = 0
local mecano_nbMecanoDispo = 0

isMecano = false

local TEXT = {
    PrendreService = '~INPUT_PICKUP~ Take mechanic service',
    QuitterService = '~INPUT_PICKUP~ Leave mechanic\'s service',
    SpawnVehicle = '~INPUT_PICKUP~ Pick up your service vehicle', --SpawnVehicle = '~INPUT_PICKUP~ Recuprer son véhicule de ~b~service'
    SpawnVehicleImpossible = '~R~ not enough space to spwan the vehicle',
    PasVehicule = "~r~Place yourself in front of a vehicle",
    CapotFerme = '~o~Open the hood of the vehicle so you do look silly', --Ouvrez le capot du véhicule pour ne pas passer pour un guignol...
    VehiculeOK = '~g~No problem',
    VehiculeReparable = '~o~The vehicle is damaged, but can be repaired on site',
    VehiculeKO = "~r~Vehicle can not be repaired at the side of the road, Must be towed to the nearest garage.", --Véhicule HS, il doit être rapatrié dans un garage pour réparation
    VehiculeReparationRapideOk = "~g~Vehicle underwent repair",
    VehiculeReparationRapideKo = "~r~Vehicle can not be repaired on site",
    VehiculeReparationGarage = "~r~This type of repair can only be done here",
    VehiculeReparationOk = '~g~The vehicle is like new',
    VehiculeDeverrouilleOk = '~g~The vehicle is unlocked for all users.',
    VehiculeDeverrouilleKo = '~o~Something went wrong, You done goofed ...',
    InfoGrue = '~g~E~s~ Attach / Detatch the vehicle\n~g~N+~s~ Raise the hook\n~g~N-~s~ Lower the hook',
    InfoRemoqueAttach = '~g~E~s~ Attach the vehicle',
    InfoRemoqueDettach = '~g~E~s~ Detatch the vehicle',
    InfoRemoqueNo = 'No vehicles within reach, Move your truck closer to the vehicle',
    Blip = 'Mission in progress',
    BlipGarage = "Mechanic",
    MissionCancel = 'Your current mission is no longer active',
    MissionClientAccept = 'A mechanic took your call',
    MissionClientCancel = 'Your mechanic has abandoned you',
    InfoMecanoNoAppel = '~g~No calls waiting',
    InfoMecanoNbAppel = '~w~ Call waiting',
    BlipMecanoService = 'Start your shift',
    BlipMecanoVehicle = 'Pick up your work truck',

    CALL_INFO_NO_PERSONNEL = '~r~No mechanic available',
    CALL_INFO_ALL_BUSY = '~o~All the mechanics are ocupied',
    CALL_INFO_WAIT = '~b~Your call is on hold',
    CALL_INFO_OK = '~g~The mechanic is on there way',

    CALL_RECU = 'Your call has been registered',
    CALL_ACCEPT = 'Your call has been accepted, a mechanic is on there way',
    CALL_CANCEL = 'The mechanic has canceled your call',
    CALL_FINI = 'Your call has been resolved',
    CALL_EN_COURS = 'You already have an active request you nub ...',

    MISSION_NEW = 'A new call has been reported, it has been added to your mission list',
    MISSION_ACCEPT = 'Call accepted, get going !',
    MISSION_ANNULE = 'Your caller has canceled',
    MISSION_CONCURENCE = 'There is several mechanics on this job',
    MISSION_INCONNU = 'This call is no longer active',
    MISSION_EN_COURS = 'This call is already underway'
    
}
-- restart depanneur
local coords = {
    {
        ['PriseDeService'] = {x = -1148.4748, y = -2000.0338, z = 13.1803},
        ['ArenaRepair'] = {x = -1144.57,  y = -2005.16,  z = 13.18, r = 50.0},
        ['SpawnVehicleAction'] = { x = -1122.80, y = -2012.5684, z = 13.1887},
        ['SpawnVehicle'] = {
            {x = -1159.3833, y = -1991.1313, z = 13.1363, h = 311.7820, type = VehicleModelKeyTowTruck},
            {x = -1119.97, y = -2022.58, z = 13.1807, h = 314.9234, type = VehicleModelKeyTowTruck},
            {x = -1143.5556, y = -1967.2910, z = 13.2475, h = 179.9410, type = VehicleModelKeyFlatBed},
        },
    },
    {
        ['PriseDeService'] = {x = 548.6361, y = -172.5256, z = 54.4813},
        ['ArenaRepair'] = {x = 542.55,  y = -180.42,  z = 54.08846, r = 28.0},
        ['SpawnVehicleAction'] = { x = 540.0619, y = -196.7581, z = 54.4898},
        ['SpawnVehicle'] = {
            {x = 534.4255, y = -169.6911, z = 54.6268, h = 0.0179, type = VehicleModelKeyTowTruck},
            {x = 530.7656, y = -169.5748, z = 54.8785, h = 0.3389, type = VehicleModelKeyTowTruck},
            {x = 545.5554, y = -210.4010, z = 53.47, h = 147.20, type = VehicleModelKeyFlatBed},
        },
    },
    {
        ['PriseDeService'] = {x = 2004.3656, y = 3790.5842, z = 32.1809},
        ['ArenaRepair'] = {x = 2006.354,  y = 3798.739,  z = 32.1808, r = 15.0},
        ['SpawnVehicleAction'] = { x = 1997.1357, y = 3779.9375, z = 32.1809},
        ['SpawnVehicle'] = {
            {x = 1983.1662, y = 3784.6511, z = 32.1463, h = 29.7412, type = VehicleModelKeyTowTruck},
            {x = 1979.5776, y = 3782.8300, z = 32.1465, h = 29.2248, type = VehicleModelKeyTowTruck},
            {x = 1977.0086, y = 3780.3515, z = 32.2697, h = 29.2043, type = VehicleModelKeyFlatBed},
        },
    },
    {
        ['PriseDeService'] = {x = 99.1272, y = 6620.6496, z = 32.4359},
        ['ArenaRepair'] = {x = 130.16,  y = 6609.85,  z = 31.84, r = 25.0},
        ['SpawnVehicleAction'] = { x = 108.0850, y = 6614.4726, z = 31.9555},
        ['SpawnVehicle'] = {
            {x = 109.5908, y = 6607.0776, z = 31.8156, h = 316.8023, type = VehicleModelKeyTowTruck},
            {x = 112.7592, y = 6603.8974, z = 31.8990, h = 314.7157, type = VehicleModelKeyTowTruck},
            {x = 119.9472, y = 6599.2880, z = 32.06, h = 270.60, type = VehicleModelKeyFlatBed},
        },
    },
    {
        ['PriseDeService'] = {x = 1130.3, y = -776.80, z = 57.6105},
        ['ArenaRepair'] = {x = 1145.31,  y = -777.64,  z = 57.60, r = 20.0},
        ['SpawnVehicleAction'] = { x = 1123.9494, y = -784.7940, z = 57.6278},
        ['SpawnVehicle'] = {
            {x = 1136.1314, y = -793.9711, z = 57.5579, h = 87.9044, type = VehicleModelKeyTowTruck},
            {x = 1121.5769, y = -791.0843, z = 57.6906, h = 359.1412, type = VehicleModelKeyTowTruck},
            {x = 1111.0352, y = -785.2324, z = 58.3496, h = 359.7257, type = VehicleModelKeyFlatBed},
        },
    },
}
--====================================================================================
--  Utils function
--====================================================================================
local function showMessageInformation(message, duree)
    duree = duree or 2000
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(message)
    DrawSubtitleTimed(duree, 1)
end

local function SetTimeout(delay, func)
    Citizen.CreateThread(function()
        Citizen.Wait(delay)
        func()
    end)
end

local function setVehicleDoor(vehicle, open)
    open = open or 1
    if open == 1 then 
        SetVehicleDoorOpen(vehicle, 4, 0, 0)
        SetVehicleDoorOpen(vehicle, 0, 0, 0)
        SetVehicleDoorOpen(vehicle, 1, 0, 0)
        SetVehicleDoorOpen(vehicle, 2, 0, 0)
        SetVehicleDoorOpen(vehicle, 3, 0, 0)
        SetVehicleDoorOpen(vehicle, 5, 0, 0)
        SetVehicleDoorOpen(vehicle, 6, 0, 0)
        SetVehicleDoorOpen(vehicle, 7, 0, 0)
    else
        SetVehicleDoorShut(vehicle, 0, 0)
        SetVehicleDoorShut(vehicle, 1, 0)
        SetVehicleDoorShut(vehicle, 2, 0)
        SetVehicleDoorShut(vehicle, 3, 0)
        SetVehicleDoorShut(vehicle, 4, 0)
        SetVehicleDoorShut(vehicle, 5, 0)
        SetVehicleDoorShut(vehicle, 6, 0)
        SetVehicleDoorShut(vehicle, 7, 0)
    end
end

local function alarmState()
    if alarmVehicle ~= 0 and alarmValue ~= 0 then
        alarmValue = alarmValue - 1
        local state = alarmValue % 2
        setVehicleDoor(alarmVehicle, state)
        SetVehicleLights(vehicle, 1 + state)
        -- Citizen.Trace('... ' .. state)
        if alarmValue == 0 then 
            alarmVehicle = 0
            StartVehicleAlarm(alarmVehicle)
            SetVehicleSiren(vehicle, 0)
        else
            SetTimeout(alarmDelay, alarmState)
        end
    end
end

local function startAlarm(vehicle)
    if alarmVehicle == 0 then
        alarmVehicle = vehicle
        alarmValue = 20
        SetVehicleAlarm(alarmVehicle, 1)
        StartVehicleAlarm(alarmVehicle)
        StartVehicleHorn(alarmVehicle, 5000, 0 , 0)
        SetVehicleSiren(vehicle, 1)
        SetTimeout(alarmDelay, function()
            alarmState()
        end)
    end
end

local function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end

local function GetVehicleLookByPlayer(ped, dist)
    local playerPos =GetOffsetFromEntityInWorldCoords( ped, 0.0, 0.0, 0.0 )
    local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, dist, -0.8 )
    return GetVehicleInDirection( playerPos, inFrontOfPlayer )
end

--====================================================================================
--  Gestion de prise et d'abandon de service
--====================================================================================
local function showBlipMecano()
    for _ , c in pairs(coords) do
        local currentBlip = AddBlipForCoord(c.PriseDeService.x, c.PriseDeService.y, c.PriseDeService.z)
        SetBlipSprite(currentBlip, 17)
        SetBlipColour(currentBlip, 25)
        SetBlipAsShortRange(currentBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(TEXT.BlipMecanoService)
        EndTextCommandSetBlipName(currentBlip)
        SetBlipAsMissionCreatorBlip(currentBlip, true)
        table.insert(mecano_BlipMecano, currentBlip)

        local currentBlip2 = AddBlipForCoord(c.SpawnVehicleAction.x, c.SpawnVehicleAction.y, c.SpawnVehicleAction.z)
        SetBlipSprite(currentBlip2, 18)
        SetBlipColour(currentBlip2, 64)
        SetBlipAsShortRange(currentBlip2, true)
        --SetBlipFlashes(currentBlip,1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(TEXT.BlipMecanoVehicle)
        EndTextCommandSetBlipName(currentBlip2)
        SetBlipAsMissionCreatorBlip(currentBlip2, true)
        table.insert(mecano_BlipMecano, currentBlip2)
    end
end
local function removeBlipMecano()
    for _ , c in pairs(mecano_BlipMecano) do
        RemoveBlip(c)
    end
    mecano_BlipMecano = {}
end
local function drawHelpJobM()
    local lines = {
        { text = '~o~Mechanical Information', isTitle = true, isCenter = true},
        { text = '~g~You need to help citizens solve their vehicle problems', isCenter = true, addY = 0.04},
        { text = ' - Take your service, Then retrieve a work vehicle from the garage'},
        { text = ' - When a call is recived, acept the job and head towards the client'},
        { text = ' - Once there, analyze the situation and make an on-site repair if possible'},
        { text = ' - If this is not possible, transport the vehicle to the nearest garage for'},
        { text = '    Complete repair'},
        { text = ' - Invoice the client and return his keys'},
        { text = ' - Advise the call center that the mission is complete'},
        { text = ' - Take or wait for the next call', addY = 0.04},
        { text = '~b~ Your skills :', size = 0.4, addY = 0.04 },
        { text = '~g~Quick Repair: ~w~Will fix the engine damage but the chassis damage is'},
        { text = '    still visible'},
        
        { text = '~g~Complete repairs: ~w~Only works at garages located on the map'},
        { text = '~g~Unlocking Vehicles: ~w~Unlock the door of vehicles'},
        { text = '~b~ Your Vehicles :', size = 0.4, addY = 0.04 },
        { text = '~g~Le towtrunk ~w~Fast and handy, Allows use of a crane to tranport vehicles'},
        { text = '~g~Le flatbed ~w~More imposing, it allows transport of all types of vehicles', addY = 0.04},
        { text = '~b~ Tips :', size = 0.4, addY = 0.04 },
        { text = '~g~Show / Hide Help : ~w~Displays or hides the help line behind your vehicle that shows'},
        { text = '   the correct placement of the vehicle that is to be loaded', addY = 0.04},
        { text = '~c~If you can not load the vehicle on the flatbed or the cable jumps for the'},
        { text = '~c~Towtrunk, unlock the vehicle'},
        { text = '~c~If the cable is attached to the other side of the vehicle, detach and reattach the hook', addY = 0.06},
        { text = '~d~If you find problems, use the forum to let us know', isCenter = true, addY = 0.06},
        { text = '~b~Thank You & Stay sexy', isCenter = true},
    }
    DrawRect(0.5, 0.5, 0.48, 0.9, 0,0,0, 225)
    local y = 0.06 - 0.025
    local defaultAddY = 0.025
    local addY = 0.025
    for _, line in pairs(lines) do 
        y = y + addY
        local caddY = defaultAddY
        local x = 0.275
        local defaultSize = 0.32
        local defaultFont = 8
        if line.isTitle == true then
            defaultFont = 1
            defaultSize = 0.8
            caddY = 0.06
        end
        SetTextFont(line.font or defaultFont)
        SetTextScale(0.0,line.size or defaultSize)
        SetTextCentre(line.isCenter == true)
        if line.isCenter == true then
            x = 0.5
        end
        SetTextDropShadow(0, 0, 0, 0, 0)
        SetTextEdge(0, 0, 0, 0, 0)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        AddTextComponentString(line.text)
        DrawText(x, y)
        addY = line.addY or caddY
    end
    --SetTextComponentFormat("STRING")
    --AddTextComponentString('~INPUT_CELLPHONE_CANCEL~ ~g~Ferme l\'aide')
    --DisplayHelpTextFromStringLabel(0, 0, 1, -1)

end

function spawnDepanneuse(coords, type)
    deleteVehicle()
    for _, pos in pairs(coords) do 
        if pos.type == type then
            local vehi = GetClosestVehicle(pos.x, pos.y, pos.z, 2.0, 0, 70)
            -- Citizen.Trace('vehi : ' .. vehi)
            if vehi == 0 then
                RequestModel(type)
                while not HasModelLoaded(type) do
                    Wait(1)
                end
                myVehiculeEntity = CreateVehicle(type, pos.x, pos.y, pos.z, pos.h , true, false)
                SetVehicleNumberPlateText(myVehiculeEntity, "Mech 785")
                local ObjectId = NetworkGetNetworkIdFromEntity(myVehiculeEntity)
                SetNetworkIdExistsOnAllMachines(ObjectId, true)
                
                local p = GetEntityCoords(myVehiculeEntity, 0)
                local h = GetEntityHeading(myVehiculeEntity)
                --showMessageInformation('Pos: ' .. p.x .. ' ' .. p.y .. ' ' .. p.z .. ' ' .. h)
                return
            end
        end
    end
    -- Citizen.Trace('impossible')
    notifIcon("CHAR_BLANK_ENTRY", 1, "Mechanic", false, TEXT.SpawnVehicleImpossible)
    -- local myPed = GetPlayerPed(-1)
    -- local player = PlayerId()
    -- RequestModel(VehicleModelKeyTowTruck)
    -- while not HasModelLoaded(VehicleModelKeyTowTruck) do
    --     Wait(1)
    -- end
    
    -- local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
    -- myVehiculeEntity = CreateVehicle(VehicleModelKeyTowTruck, coords.x, coords.y, coords.z, 0 , true, false)
    -- DecorSetInt(myVehiculeEntity, 'VehicleDepa', 1)
    -- SetVehicleNumberPlateText(myVehiculeEntity, "Depa001")
    -- local ObjectId = NetworkGetNetworkIdFromEntity(myVehiculeEntity)
	-- SetNetworkIdExistsOnAllMachines(ObjectId, true)
end
function invokeVehicle(data)
    if data.type == 1 then
        spawnDepanneuse(spawnVehicleChoix, VehicleModelKeyTowTruck)
    elseif data.type == 2 then
        spawnDepanneuse(spawnVehicleChoix, VehicleModelKeyFlatBed)
    end
end
local function toogleService()
    inService = not inService
    if inService then
        local myPed = GetPlayerPed(-1)
        GiveWeaponToPed(myPed, 'WEAPON_HAMMER', 0, 0, 0)
        GiveWeaponToPed(myPed, 'WEAPON_CROWBAR', 0, 0, 0)
        GiveWeaponToPed(myPed, 'WEAPON_FLASHLIGHT', 0, 0, 0)
        GiveWeaponToPed(myPed, 'WEAPON_PETROLCAN', 1000, 0, 0)
        GiveWeaponToPed(myPed, 'WEAPON_FIREEXTINGUISHER', 1000, 0, 0)
        -- A Configurer
		local hashSkin = GetHashKey("mp_m_freemode_01")
		Citizen.CreateThread(function()
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
			SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2) -- TORSO
			SetPedComponentVariation(GetPlayerPed(-1), 11, 43, 0, 2) -- TORSO2
			SetPedComponentVariation(GetPlayerPed(-1), 4, 41, 0, 2) -- LEGS
			SetPedComponentVariation(GetPlayerPed(-1), 6, 25, 0, 2) -- FEET
			SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) -- ACCESSORIE
		else
			SetPedComponentVariation(GetPlayerPed(-1), 3, 25, 0, 2) -- TORSO
			SetPedComponentVariation(GetPlayerPed(-1), 11, 1, 0, 2) -- TORSO2
			SetPedComponentVariation(GetPlayerPed(-1), 4, 4, 8, 2) -- LEGS
			SetPedComponentVariation(GetPlayerPed(-1), 6, 4, 0, 2) -- FEET
			SetPedComponentVariation(GetPlayerPed(-1), 8, 20, 1, 2) -- ACCESSORIE
		end
		end)
        TriggerServerEvent('mecano:takeService')
        TriggerServerEvent('mecano:requestMission')
        mecano_showHelp = true
    else
        -- Restaure Ped
        TriggerServerEvent('mecano:endService')
        TriggerServerEvent("skin_customization:SpawnPlayer")
    end 
end

local function gestionService()
    local myPed = GetPlayerPed(-1)
    local myPos = GetEntityCoords(myPed)
    for _, coordData in pairs(coords) do 
        local pos = coordData.PriseDeService
        local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, myPos.x, myPos.y, myPos.z, false)
        if dist <= 20 then
            DrawMarker(1, pos.x, pos.y, pos.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 0, 0, 255, 200, 0, 0, 0, 0)
        end
        if dist <= 1 then 
            if inService then
                --showMessageInformation(TEXT.QuitterService, 60)
                SetTextComponentFormat("STRING")
                AddTextComponentString(TEXT.QuitterService)
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            else
                SetTextComponentFormat("STRING")
                AddTextComponentString(TEXT.PrendreService)
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                --showMessageInformation(TEXT.PrendreService, 60)
            end
            if IsControlJustPressed(0, KEY_E) then
                toogleService()
            end
        end

        if inService then 
            local pos = coordData.SpawnVehicleAction
            local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, myPos.x, myPos.y, myPos.z, false)
            if dist <= 20 then
                DrawMarker(1, pos.x, pos.y, pos.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 0, 128, 0, 200, 0, 0, 0, 0)
            end
            if dist <= 1 then 
                -- showMessageInformation(TEXT.SpawnVehicle, 60)
                SetTextComponentFormat("STRING")
                AddTextComponentString(TEXT.SpawnVehicle)
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustPressed(0, KEY_E) then
                    spawnVehicleChoix = coordData.SpawnVehicle
                    openMenuChoixVehicle()
                end

            end

            local posArenaRepair = coordData.ArenaRepair
            local dist2 = GetDistanceBetweenCoords(posArenaRepair.x, posArenaRepair.y, posArenaRepair.z, myPos.x, myPos.y, myPos.z, false)
            if dist2 <= 60 then
                DrawMarker(1, posArenaRepair.x, posArenaRepair.y, posArenaRepair.z - 1.0, 0, 0, 0, 0, 0, 0, posArenaRepair.r, posArenaRepair.r, 1.0, 128, 0, 255, 128, 0, 0, 0, 0)
            end

        end
    end
end

--====================================================================================
-- Dommage Véhicule  restart depanneur
--====================================================================================

local function CustomVehicleDommage()
    local myPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(myPed, 0)
    if vehicle ~= 0 then 
        local engineHealth = GetVehicleEngineHealth(vehicle)
        local vehicleHealth = GetEntityHealth(vehicle)
        local petrolTankeHealth = GetVehiclePetrolTankHealth(vehicle)
        local vehicleHealth2 = GetVehicleBodyHealth_2(vehicle)
--Remove This part of the code to remove the Debug info displayed in the screen.    
        --ClearPrints()
        --SetTextEntry_2("STRING")
        --AddTextComponentString('~r~' .. math.floor(engineHealth) .. ' ~g~ ' .. vehicleHealth .. ' ~b~ ' .. math.floor(petrolTankeHealth) .. '\n~y~' .. vehicleHealth2 .. '\n~o~')
        --DrawSubtitleTimed(200, 1)
--------------------------------------------------------------------------------
        if engineHealth <= 400 then
            SetVehicleEngineTorqueMultiplier(vehicle,0.4)
            SetVehicleIndicatorLights(vehicle, 0, true)
            SetVehicleIndicatorLights(vehicle, 1, true)
        end

        if engineHealth <= 300 then
            SetVehicleEngineTorqueMultiplier(vehicle,0.09)
            SetVehicleEngineHealth(vehicle, 150.0)
            SetVehicleBodyHealth(0.0)
            SetVehicleUndriveable(vehicle, true)
            SetVehicleDoorOpen(vehicle, 4, 0, 0)
            SetVehicleIndicatorLights(vehicle, 0, true)
            SetVehicleIndicatorLights(vehicle, 1, true)
        end

        if vehicleHealth <= 700 then
            SetVehicleEngineTorqueMultiplier(vehicle,0.09)
            SetVehicleEngineHealth(vehicle, 150.0)
            SetVehicleBodyHealth(0.0)
            SetVehicleUndriveable(vehicle, true)
            SetVehicleDoorOpen(vehicle, 4, 0, 0)
            SetVehicleIndicatorLights(vehicle, 0, true)
            SetVehicleIndicatorLights(vehicle, 1, true)
        end

        if petrolTankeHealth <= 700 then
            SetVehicleEngineTorqueMultiplier(vehicle,0.09)
            SetVehicleEngineHealth(vehicle, 150.0)
            SetVehicleBodyHealth(0.0)
            SetVehicleUndriveable(vehicle, true)
            SetVehicleDoorOpen(vehicle, 4, 0, 0)
            SetVehicleIndicatorLights(vehicle, 0, true)
            SetVehicleIndicatorLights(vehicle, 1, true)
        end
    end
end

--====================================================================================
-- UserAction restart depanneur
--====================================================================================

function getStatusVehicle()
    local myPed = GetPlayerPed(-1)
    local vehicle = GetVehicleLookByPlayer(myPed, 3.0)
    local p = GetEntityCoords(vehicle, 0)
    local h = GetEntityHeading(vehicle)
    -- Citizen.Trace('Pos: ' .. p.x .. ' ' .. p.y .. ' ' .. p.z .. ' ' .. h)
    if vehicle ~= 0 then 
        -- local capotOpen = GetVehicleDoorAngleRatio(vehicle, 4) > 0.5
        -- if not capotOpen then 
        --     showMessageInformation(TEXT.CapotFerme)
        -- else
            local scenario = 'PROP_HUMAN_BUM_SHOPPING_CART'
            local pos = GetOffsetFromEntityInWorldCoords(myPed, 0.0, 0.2, 0.0)
        
            --TaskStartScenarioAtPosition(myPed, scenario, pos.x, pos.y, pos.z, 0.0, 8000, 1, 0)
            TaskStartScenarioInPlace(myPed, scenario, 8000, 1)
            Citizen.Wait(8000)
            ClearPedTasks(myPed)
            local vehicleHealth = GetVehicleEngineHealth(vehicle)
            if vehicleHealth > 900 then
                showMessageInformation(TEXT.VehiculeOK,8000)
            elseif vehicleHealth >= 150 then
                showMessageInformation(TEXT.VehiculeReparable,8000)
            else
                showMessageInformation(TEXT.VehiculeKO,8000)
            end
        -- end
    else
        showMessageInformation(TEXT.PasVehicule)
    end
end

function repareVehicle()
    local myPed = GetPlayerPed(-1)
    local vehicle = GetVehicleLookByPlayer(myPed, 3.0)
    if vehicle ~= 0 then 
        -- local capotOpen = GetVehicleDoorAngleRatio(vehicle, 4) > 0.5
        -- if not capotOpen then 
        --     showMessageInformation(TEXT.CapotFerme)
        -- else
            local scenario = 'WORLD_HUMAN_VEHICLE_MECHANIC'
            local pos = GetOffsetFromEntityInWorldCoords(myPed, 0.0, 0.02, 0.0)
            local h = GetEntityHeading(myPed)
            TaskStartScenarioAtPosition(myPed, scenario, pos.x, pos.y, pos.z, h + 180 , 8000, 1, 0)
            --TaskStartScenarioAtPosition(myPed, scenario,8000,1)
            Citizen.Wait(8000)
            ClearPedTasks(myPed)
            local vehicleHealth = GetEntityHealth(vehicle)
            if vehicleHealth >= 0 then
                SetVehicleEngineHealth(vehicle, 960.0)
                SetVehicleEngineOn(vehicle, 0, 0, 0)
                SetVehicleUndriveable(vehicle, false)
                SetVehicleEngineTorqueMultiplier(vehicle, 1.0)
                showMessageInformation(TEXT.VehiculeReparationRapideOk)
            else
                showMessageInformation(TEXT.VehiculeReparationRapideKo)
            end
        -- end
    else
        showMessageInformation(TEXT.PasVehicule)
    end
end

function fullRepareVehcile()
    local myPed = GetPlayerPed(-1)
    local myPos = GetEntityCoords(myPed)
    local inArena = false
    for _, coordData in pairs(coords) do
        local pos = coordData.ArenaRepair
        -- Citizen.Trace('pos ' .. pos.x .. ' ' .. pos.y .. ' ' .. pos.z .. '    ' .. GetDistanceBetweenCoords(pos.x, pos.y, pos.y, myPos.x, myPos.y, myPos.z, false))
        if GetDistanceBetweenCoords(pos.x, pos.y, pos.y, myPos.x, myPos.y, myPos.z, false) <= coordData.ArenaRepair.r then
            inArena = true
            break
        end
    end
    if not inArena then
         showMessageInformation(TEXT.VehiculeReparationGarage)
        return
    end
    local vehicle = GetVehicleLookByPlayer(myPed, 3.0)
    if vehicle ~= 0 then 
        local scenario = 'WORLD_HUMAN_VEHICLE_MECHANIC'
        local pos = GetOffsetFromEntityInWorldCoords(myPed, 0.0, 0.02, 0.0)
        local h = GetEntityHeading(myPed)
        TaskStartScenarioAtPosition(myPed, scenario, pos.x, pos.y, pos.z, h + 180 , 8000, 1, 0)
        local value = GetVehicleBodyHealth(vehicle)
        
        while( value < 999.9 ) do
            value = GetVehicleBodyHealth(vehicle)
            SetVehicleBodyHealth(vehicle, value + 1.0)
            showMessageInformation('Repairs in progress ~b~' .. math.floor(value) .. '/1000')
            Citizen.Wait(125)     
        end
        Citizen.Wait(250)
        ClearPedTasks(myPed)
        SetVehicleBodyHealth(vehicle, 1000.0)
        SetVehicleEngineHealth(vehicle, 1000.0)
        SetEntityHealth(vehicle,1000)
        SetVehiclePetrolTankHealth(vehicle,1000.0)
        SetVehicleEngineOn(vehicle, 0, 0, 0)
        SetVehicleBodyHealth(vehicle, 1000.0)
        SetVehicleFixed(vehicle)
        SetVehicleEngineTorqueMultiplier(vehicle,1.0)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        showMessageInformation(TEXT.VehiculeReparationOk)
    else
        showMessageInformation(TEXT.PasVehicule)
    end
end
-- restart depanneur
function openVehicleDoorData(data)
    local myPed = GetPlayerPed(-1)
    local myCoord = GetEntityCoords(myPed)
    local vehicle = GetVehicleLookByPlayer(myPed, 3.0)
    if vehicle ~= 0 then
        local porte = data.Porte or -1 
        if porte == -1 then 
            SetVehicleDoorOpen(vehicle, 0, 0, 0)
            SetVehicleDoorOpen(vehicle, 1, 0, 0)
            SetVehicleDoorOpen(vehicle, 2, 0, 0)
            SetVehicleDoorOpen(vehicle, 3, 0, 0)
            SetVehicleDoorOpen(vehicle, 4, 0, 0)
            SetVehicleDoorOpen(vehicle, 5, 0, 0)
            SetVehicleDoorOpen(vehicle, 6, 0, 0)
            SetVehicleDoorOpen(vehicle, 7, 0, 0)
        else
            SetVehicleDoorOpen(vehicle, porte, 0, 0)
        end
    else
        showMessageInformation(TEXT.PasVehicule)
    end
end

function closeVehicleDoorData(data)
    local myPed = GetPlayerPed(-1)
    local myCoord = GetEntityCoords(myPed)
    local vehicle = GetVehicleLookByPlayer(myPed, 3.0)
    if vehicle ~= 0 then
        local porte = data.Porte or -1 
        if porte == -1 then 
            SetVehicleDoorShut(vehicle, 0, 0)
            SetVehicleDoorShut(vehicle, 1, 0)
            SetVehicleDoorShut(vehicle, 2, 0)
            SetVehicleDoorShut(vehicle, 3, 0)
            SetVehicleDoorShut(vehicle, 4, 0)
            SetVehicleDoorShut(vehicle, 5, 0)
            SetVehicleDoorShut(vehicle, 6, 0)
            SetVehicleDoorShut(vehicle, 7, 0)
        else
            SetVehicleDoorShut(vehicle, porte, 0, 0)
        end
    else
        showMessageInformation(TEXT.PasVehicule)
    end
end

function unlockVehiculeForAll()
    local myPed = GetPlayerPed(-1)
    local vehicle = GetVehicleLookByPlayer(myPed, 3.0)
    if vehicle ~= 0 then 
        if math.random() > -0.25 then
            TaskWarpPedIntoVehicle(myPed, vehicle, -1)
            SetVehicleDoorsLocked(vehicle, 1)
            showMessageInformation(TEXT.VehiculeDeverrouilleOk)
        else   
            startAlarm(vehicle)
            showMessageInformation(TEXT.VehiculeDeverrouilleKo) 
        end
    else
        showMessageInformation(TEXT.PasVehicule)
    end
end

--====================================================================================
-- Vehicule gestion
--====================================================================================

--restart metiers
function jobsSystem()
    if inService == false then
        return 
    end
    
    local myPed = GetPlayerPed(-1)
    local myCoord = GetEntityCoords(myPed)
    local currentVehicle = GetVehiclePedIsIn(myPed, 0)

    if currentVehicle == 0 then -- a pied
        local towtruck = GetClosestVehicle(myCoord.x, myCoord.y, myCoord.z, 10.0, VehicleModelKeyTowTruck, 70)
        if towtruck ~= 0 then
            local coords = GetOffsetFromEntityInWorldCoords(towtruck, -1.5, -3.2, 0)
            local dist = GetDistanceBetweenCoords(myCoord.x, myCoord.y, myCoord.z, coords.x, coords.y, coords.z, true)
            if dist < 10 then
                DrawMarker(1, coords.x, coords.y, coords.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, 0, 0, 0, 0)
            end
            if dist < 1.5 then 
                -- showMessageInformation(TEXT.InfoGrue)
                SetTextComponentFormat("STRING")
                AddTextComponentString(TEXT.InfoGrue)
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                local c1 = GetOffsetFromEntityInWorldCoords(towtruck, 0.0, -4.3, 1.8)
                local c2 = GetOffsetFromEntityInWorldCoords(towtruck, 0.0, -4.3, -1.2)
                local vehicleAttach = GetEntityAttachedToTowTruck(towtruck)
                local vehicleGrap = GetVehicleInDirection(c1,c2)
                if ShowLineGrueHelp == true then 
                    if vehicleAttach ~= 0 then 
                        DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 0, 255, 0, 255)
                    elseif vehicleGrap ~= 0 then
                        DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 0, 0, 255, 255)
                    else
                        DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 255, 0, 0, 255)
                    end
                end
                if IsControlJustPressed(1, KEY_UP) then
                    -- Citizen.Trace('up')
                    Citizen.InvokeNative(0xFE54B92A344583CA, towtruck, 1.0)
                elseif IsControlJustPressed(1, KEY_DOWN) then
                    -- Citizen.Trace('down')
                    Citizen.InvokeNative(0xFE54B92A344583CA, towtruck, 0.0)
                elseif IsControlJustPressed(1, KEY_E) then
                    -- Citizen.Trace('attack')
                    if vehicleAttach ~= 0 then
                        DetachVehicleFromTowTruck(towtruck, vehicleAttach)
                    elseif vehicleGrap ~= 0 then
                        AttachVehicleToTowTruck(towtruck, vehicleGrap, true, 0.0,0.0,0.0)
                    end
                end
            end
 
        else
            local flatbed= GetClosestVehicle(myCoord.x, myCoord.y, myCoord.z, 10.0, VehicleModelKeyFlatBed, 70)
            if flatbed ~= 0 then
                local coords = GetOffsetFromEntityInWorldCoords(flatbed, -1.5, -5.2, 0)
                local dist = GetDistanceBetweenCoords(myCoord.x, myCoord.y, myCoord.z, coords.x, coords.y, coords.z, true)
                if dist < 10 then
                    DrawMarker(1, coords.x, coords.y, coords.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, 0, 0, 0, 0)
                end
                if dist < 1.5 then 

                    -- local c1 = GetOffsetFromEntityInWorldCoords(flatbed, -1.0, -1.4, 1.2)
                    -- local c2 = GetOffsetFromEntityInWorldCoords(flatbed, 1.0, -1.4, 1.2)

                    local c1 = GetOffsetFromEntityInWorldCoords(flatbed, -2.0, -1.2, 1.2)
                    local c2 = GetOffsetFromEntityInWorldCoords(flatbed, 2.0, -1.2, 1.2)
                    -- DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 0, 255, 0, 255)
                    local cvg = GetVehicleInDirection(c1,c2)
                    --local cvg = GetEntityAttachedTo(flatbed)
                    -- restart depanneur
                    if cvg ~= 0 and GetEntityAttachedTo(cvg) == flatbed then
                        SetTextComponentFormat("STRING")
                        AddTextComponentString(TEXT.InfoRemoqueDettach)
                        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                        if IsControlJustPressed(1, KEY_E) then
                            DetachEntity(cvg, true,true)
                            local c = GetOffsetFromEntityInWorldCoords(flatbed, 0.0, -10.0, 0)
                            SetEntityCoords(cvg,c.x, c.y, c.z)
                            SetVehicleOnGroundProperly(cvg)
                        end
                    else
                        local c1 = GetOffsetFromEntityInWorldCoords(flatbed, 0.0, -7.3, 1.8)
                        local c2 = GetOffsetFromEntityInWorldCoords(flatbed, 0.0, -7.3, -1.2)
                        local vehicleGrap = GetVehicleInDirection(c1,c2)
                        if ShowLineGrueHelp == true then 
                            if vehicleGrap ~= 0 then 
                                DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 0, 255, 0, 255)
                            else
                                DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 255, 0, 0, 255)
                            end
                        end
                        
                        if vehicleGrap ~= 0 then 
                            SetTextComponentFormat("STRING")
                            AddTextComponentString(TEXT.InfoRemoqueAttach)
                            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                            if IsControlJustPressed(1, KEY_E) then
                                Citizen.InvokeNative(0x870DDFD5A4A796E4,vehicleGrap)
                                AttachEntityToEntity(vehicleGrap, flatbed, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, true, false, 20, true)
                            end
                        else 
                            SetTextComponentFormat("STRING")
                            AddTextComponentString(TEXT.InfoRemoqueNo)
                            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                            if IsControlJustPressed(1, KEY_E) then
                                DetachEntity(flatbed, true,true)
                            end
                        end
                    end
                end
            end
        end
    else
        if ShowLineGrueHelp == true then 
            local inTowtruck = IsVehicleModel(currentVehicle, VehicleModelKeyTowTruck)
            if inTowtruck then
                local c1 = GetOffsetFromEntityInWorldCoords(currentVehicle, 0.0, -4.3, 1.8)
                local c2 = GetOffsetFromEntityInWorldCoords(currentVehicle, 0.0, -4.3, -0.8)
                local vehicle = GetVehicleInDirection(c1,c2)
                if vehicle ~= 0 then
                        DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 0, 0, 255, 255)
                else
                        DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 255, 0, 0, 255)
                end
            else 
                local inFlatBed = IsVehicleModel(currentVehicle, VehicleModelKeyFlatBed)
                if inFlatBed then
                    local c1 = GetOffsetFromEntityInWorldCoords(currentVehicle, 0.0, -7.3, 1.8)
                    local c2 = GetOffsetFromEntityInWorldCoords(currentVehicle, 0.0, -7.3, -1.2)
                    local vehicleGrap = GetVehicleInDirection(c1,c2)
                    if vehicleGrap ~= 0 then 
                        DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 0, 255, 0, 255)
                    else
                        DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 255, 0, 0, 255)
                    end
                end
            end
        end
    end
end
function showInfoClient() 
    if mecano_call_accept ~= 0 then

        local offsetX = 0.87
        local offsetY = 0.785
        DrawRect(offsetX, offsetY, 0.23, 0.035, 0, 0, 0, 215)

        SetTextFont(1)
        SetTextScale(0.0,0.5)
        SetTextCentre(true)
        SetTextDropShadow(0, 0, 0, 0, 0)
        SetTextEdge(0, 0, 0, 0, 0)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        if mecano_call_accept == 1 then
            AddTextComponentString(TEXT.CALL_INFO_OK)
        else 
            if mecano_nbMecanoInService == 0 then
                AddTextComponentString(TEXT.CALL_INFO_NO_PERSONNEL)
            elseif mecano_nbMecanoDispo == 0 then
                AddTextComponentString(TEXT.CALL_INFO_ALL_BUSY)
            else
                AddTextComponentString(TEXT.CALL_INFO_WAIT)
            end
        end  
        DrawText(offsetX, offsetY - 0.015 )
    end
end

function showInfoJobs()
    local offsetX = 0.9
    local offsetY = 0.845
    DrawRect(offsetX, offsetY, 0.15, 0.07, 0, 0, 0, 215)

    SetTextFont(1)
    SetTextScale(0.0,0.5)
    SetTextCentre(true)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString('~o~Mechanic info')
    DrawText(offsetX, offsetY - 0.03)

    SetTextFont(1)
    SetTextScale(0.0,0.5)
    SetTextCentre(false)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")

    AddTextComponentString(mecano_nbMissionEnAttenteText)
    DrawText(offsetX - 0.065, offsetY -0.002)
end

function deleteVehicle()
    if myVehiculeEntity ~= nil then
        DeleteVehicle(myVehiculeEntity)
        myVehiculeEntity = nil
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        CustomVehicleDommage()
        if isMecano then
            gestionService()
            jobsSystem()
            if inService then
                showInfoJobs()
            end
        end
        if mecano_showHelp == true then
            drawHelpJobM()
            if IsControlJustPressed(0, KEY_CLOSE) then
                mecano_showHelp = false
            end
        end
        if mecano_call_accept ~= 0 then
            showInfoClient()
        end
    end
end)

--
RegisterNetEvent('mecano:drawMarker')	
AddEventHandler('mecano:drawMarker', function (boolean)
	isMecano = boolean
    if isMecano then
        showBlipMecano()
    else
        removeBlipMecano()
    end
end)
RegisterNetEvent('mecano:drawBlips')	
AddEventHandler('mecano:drawBlips', function ()
end)
RegisterNetEvent('mecano:marker')	
AddEventHandler('mecano:marker', function ()
end)

RegisterNetEvent('mecano:deleteBlips')
AddEventHandler('mecano:deleteBlips', function ()
    isMecano = false
    removeBlipMecano()
end)

--====================================================================================
-- Serveur - Client Trigger
-- restart depanneur
--====================================================================================

function notifIcon(icon, type, sender, title, text)
	Citizen.CreateThread(function()
        Wait(1)
        SetNotificationTextEntry("STRING");
        if TEXT[text] ~= nil then
            text = TEXT[text]
        end
        AddTextComponentString(text);
        SetNotificationMessage(icon, icon, true, type, sender, title, text);
        DrawNotification(false, true);
	end)
end

RegisterNetEvent("mecano:PersonnelMessage")
AddEventHandler("mecano:PersonnelMessage",function(message)
    if inService then
        notifIcon("CHAR_BLANK_ENTRY", 1, "Mechanic Info", false, message)
    end
end)

RegisterNetEvent("mecano:ClientMessage")
AddEventHandler("mecano:ClientMessage",function(message)
    notifIcon("CHAR_BLANK_ENTRY", 1, "Mechanic", false, message)
end)


--=== restart depanneur
function acceptMission(data) 
    local mission = data.mission 

    -- currentMissions = mission
    TriggerServerEvent('mecano:AcceptMission', mission.id)
    -- SetNewWaypoint(mission.pos[1], mission.pos[2])
    -- currentBlip= AddBlipForCoord(mission.pos[1], mission.pos[2], mission.pos[3])
    -- SetBlipSprite(currentBlip, 446)
    -- SetBlipColour(currentBlip, 5)
    -- SetBlipAsShortRange(currentBlip, true)
    -- --SetBlipFlashes(currentBlip,1)
    -- BeginTextCommandSetBlipName("STRING")
    -- AddTextComponentString(TEXT.Blip)
	-- EndTextCommandSetBlipName(currentBlip)
    -- SetBlipAsMissionCreatorBlip(currentBlip, true)
end

function finishCurrentMission()
    -- Citizen.Trace(currentMissions.id)
    TriggerServerEvent('mecano:FinishMission', currentMissions.id)
    currentMissions = nil
    if currentBlip ~= nil then
        RemoveBlip(currentBlip)
    end
end

function updateMenuMission() 
    local items = {{['Title'] = 'Return', ['ReturnBtn'] = true }}
    for _,m in pairs(listMissions) do 
        -- Citizen.Trace('item mission')
        local item = {
            Title = 'Mission ' .. m.id .. ' [' .. m.type .. ']',
            mission = m,
            Function = acceptMission
        }
        if #m.acceptBy ~= 0 then
            item.Title = item.Title .. ' (On route)'
            item.TextColor = {39, 174, 96, 255}
        end
        table.insert(items, item)
    end
    if currentMissions ~= nil then
        table.insert(items, {['Title'] = 'Finish the mission', ['Function'] = finishCurrentMission})
    end
    table.insert(items, {['Title'] = 'Close'})

    menu = {['Title'] = 'Current missions',  ['SubMenu'] = {
        ['Title'] = 'Current missions', ['Items'] = items
    }}
    updateMenu(menu)
end

RegisterNetEvent('mecano:MissionAccept')
AddEventHandler('mecano:MissionAccept', function (mission)
    currentMissions = mission
    SetNewWaypoint(mission.pos[1], mission.pos[2])
    currentBlip= AddBlipForCoord(mission.pos[1], mission.pos[2], mission.pos[3])
    SetBlipSprite(currentBlip, 446)
    SetBlipColour(currentBlip, 5)
    SetBlipAsShortRange(currentBlip, true)
    --SetBlipFlashes(currentBlip,1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(TEXT.Blip)
	EndTextCommandSetBlipName(currentBlip)
    SetBlipAsMissionCreatorBlip(currentBlip, true)

end)


RegisterNetEvent('mecano:MissionCancel')
AddEventHandler('mecano:MissionCancel', function ()
    currentMissions = nil
    if currentBlip ~= nil then
        RemoveBlip(currentBlip)
    end
end)

RegisterNetEvent('mecano:MissionChange')
AddEventHandler('mecano:MissionChange', function (missions)
    if not inService then
        return
    end
    listMissions = missions
    -- if currentMissions ~= nil then
         local nbMissionEnAttente = 0
    --     local find = false 
         for _,m in pairs(listMissions) do
      --       if m.id == currentMissions.id then
      --           find = true
       --      end
             if #m.acceptBy == 0 then
               nbMissionEnAttente = nbMissionEnAttente + 1
             end
        end
        if nbMissionEnAttente == 0 then 
             mecano_nbMissionEnAttenteText = TEXT.InfoMecanoNoAppel
         else
            mecano_nbMissionEnAttenteText = '~g~ ' .. nbMissionEnAttente .. ' ' .. TEXT.InfoMecanoNbAppel
         end
    --     Citizen.Trace('ok')
    --     if not find then
    --         currentMissions = nil
    --         notifIcon("CHAR_BLANK_ENTRY", 1, "Mecano", false, TEXT.MissionCancel)
    --         if currentBlip ~= nil then
    --             RemoveBlip(currentBlip)
    --         end
    --     end
    -- end
    updateMenuMission()
end)


function needMecano(type)
    local myPed = GetPlayerPed(-1)
    local myCoord = GetEntityCoords(myPed)
    TriggerServerEvent('mecano:Call', myCoord.x, myCoord.y, myCoord.z, type)
end

function toogleHelperLine()
    ShowLineGrueHelp = not ShowLineGrueHelp
end

function MECANO_wash()
	SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
	SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
end

RegisterNetEvent('mecano:openMenu')
AddEventHandler('mecano:openMenu', function()
    -- Citizen.Trace('open menu mecano')
    if inService then
        TriggerServerEvent('mecano:requestMission')
        openMenuGeneral()
    else
        showMessageInformation("~r~You have to be in service to access the menu")
    end
end)

RegisterNetEvent('mecano:callMecano')
AddEventHandler('mecano:callMecano',function(data)
    needMecano(data.type)
end)

RegisterNetEvent('mecano:callStatus')
AddEventHandler('mecano:callStatus',function(status)
    mecano_call_accept = status
end)

RegisterNetEvent('mecano:personnelChange')
AddEventHandler('mecano:personnelChange',function(nbPersonnel, nbDispo)
    mecano_nbMecanoInService = nbPersonnel
    mecano_nbMecanoDispo = nbDispo
end)

RegisterNetEvent('mecano:cancelCall')
AddEventHandler('mecano:cancelCall',function(data)
    TriggerServerEvent('mecano:cancelCall')
end)

--====================================================================================
-- ADD Blip for All Player
--====================================================================================
-- Delay sinon sa ne s'affiche pas
SetTimeout(2500, function() 
    for _, c in pairs(coords) do 
        local currentBlip = AddBlipForCoord(c.ArenaRepair.x, c.ArenaRepair.y, c.ArenaRepair.z)
        SetBlipSprite(currentBlip, 446)
        SetBlipAsShortRange(currentBlip, true)
        SetBlipColour(currentBlip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(TEXT.BlipGarage)
        EndTextCommandSetBlipName(currentBlip)
        SetBlipAsMissionCreatorBlip(currentBlip, true)
    end
    
end)
--Citizen.Trace("Mecano load")
TriggerServerEvent('mecano:requestPersonnel')

-- Register a network event 
RegisterNetEvent( 'deleteVehicle' )

-- The distance to check in front of the player for a vehicle
-- Distance is in GTA units, which are quite big  
local distanceToCheck = 5.0

-- Add an event handler for the deleteVehicle event. 
-- Gets called when a user types in /dv in chat (see server.lua)
function MECANO_deleteVehicle()
    local ped = GetPlayerPed( -1 )

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
        local pos = GetEntityCoords( ped )
        -- log( "Player is at:\nX: " .. pos.x .. " Y: " .. pos.y .. " Z: " .. pos.z )
        -- log( "Found vehicle?: " .. tostring( DoesEntityExist( vehicle ) ) )

        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then 
                ShowNotification( "Vehicle deleted." )
                SetEntityAsMissionEntity( vehicle, true, true )
                deleteCar( vehicle )
            else 
                ShowNotification( "You must be on the driver's seat!" )
            end 
        else
            local playerPos = GetEntityCoords( ped, 1 )
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
            local vehicle = GetVehicleInDirection( playerPos, inFrontOfPlayer )

            if ( DoesEntityExist( vehicle ) ) then 
                -- log( "Distance between ped and vehicle: " .. tostring( GetDistanceBetween( ped, vehicle ) ) )
                ShowNotification( "Vehicle deleted." )
                SetEntityAsMissionEntity( vehicle, true, true )
                deleteCar( vehicle )
            else 
                ShowNotification( "You need to be closer to the vehcile to delete it!!" )
            end 
        end 
    end 
end

-- Delete car function borrowed frtom Mr.Scammer's model blacklist, thanks to him!
function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

-- Gets a vehicle in a certain direction
-- Credit to Konijima
function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end

-- Shows a notification on the player's screen 
function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end


-- isMecano = true
-- toogleService()


-- ----[[ DEBUG
-- local myPed = GetPlayerPed(-1)
-- local myCoord = GetEntityCoords(myPed)
-- -- toogleService()
-- Citizen.Trace('Pos init: ' .. myCoord.x .. ', ' .. myCoord.y .. ', ' .. myCoord.z)

-- local l = math.floor(math.random() * #coords) + 1 
-- -- Citizen.Trace('Tp at ' .. l )
-- local pos = coords[l].SpawnVehicleAction
-- --SetEntityCoords(myPed, pos.x, pos.y, pos.z)

-- --]]
-- toogleService()
-- isMecano = true
-- local myPed = GetPlayerPed(-1)
-- local myCoord = GetEntityCoords(myPed)
-- local any = nil
-- AddRope(
-- myCoord.x, myCoord.y, myCoord.z, 
-- 0.0, 0.0, 0.0,
-- 5.0, 1, 4.5, 5.5, 
-- 0,0,0,
-- 0,0,0,Citizen.ReturnResultAnyway())

-- local my= GetPlayerPed(-1)
-- local vi = GetVehicleLookByPlayer(my, 3.0)
-- if vi ~= nil then
--     local myCoord = GetEntityCoords(vi)
--     local h = GetEntityHeading(vi)
--     Citizen.Trace('Car init: ' .. myCoord.x .. ', ' .. myCoord.y .. ', ' .. myCoord.z ..  ', h :  ' .. h)
-- end

-- Citizen.CreateThread(function()
--     while true do 
--     Citizen.Wait(1)
--     local ped = GetPlayerPed(-1)
--            local playerPos = GetEntityCoords( ped, 1 )
--            local p = GetOffsetFromEntityInWorldCoords( ped, 0.0, 0.0, 0.0 )
--         local p1 = GetOffsetFromEntityInWorldCoords( ped, 0.0, 3.0, -0.8)
--         DrawLine(p.x, p.y, p.z, p1.x, p1.y, p1.z, 255,0,0,255)
--     end
-- end)