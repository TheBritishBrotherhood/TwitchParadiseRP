local myVehiculeEntity = nil
local inService = false
local spawnVehicleChoix = {}
local VehicleModelKeyTaxi = GetHashKey('taxi')
local KEY_E = 38
local KEY_UP = 96 -- N+
local KEY_DOWN = 97 -- N-
local KEY_CLOSE = 177
local currentBlip = nil 
local listMissions = {}
local currentMissions = nil
local myCallMission = nil 
local taxi_nbMissionEnAttenteText = '-- Aucune Info --'
local taxi_Bliptaxi = {}
local taxi_call_accept = 0
local taxi_nbtaxiInService = 0
local taxi_nbtaxiDispo = 0

isTaxi = false

local TEXT = {
    PrendreService = '~INPUT_PICKUP~ Take your taxi service my friend',
    QuitterService = '~INPUT_PICKUP~ Leaving service as taxi driver my friend',
    SpawnVehicle = '~INPUT_PICKUP~ Retrieve your vehicle from ~b~service my friend',
    SpawnVehicleImpossible = '~R~ Impossible, no place available my friend',
   
    Blip = 'Curent Route',
    BlipGarage = "Taxi",
    MissionCancel = 'Fair canceled my friend',
    MissionClientAccept = 'A Taxi is on the way my friend',
    MissionClientCancel = 'Your Taxi has buggered off my friend',
    InfotaxiNoAppel = '~g~No calls waiting my friend',
    InfotaxiNbAppel = '~w~ Call waiting my friend',
    BliptaxiService = 'Start work my friend',
    BliptaxiVehicle = 'Pick up your Cab my friend',

    CALL_INFO_NO_PERSONNEL = '~r~No taxis are active my friend',
    CALL_INFO_ALL_BUSY = '~o~All the Taxis are busy my friend',
    CALL_INFO_WAIT = '~b~Your call is on hold my friend',
    CALL_INFO_OK = '~g~A taxi is on the way to your location my friend',

    CALL_RECU = 'Your call has been recieved my friend',
    CALL_ACCEPT = 'Your call has been accepted, a taxi is on route my friend',
    CALL_CANCEL = 'Your call has been canceled my friend',
    CALL_FINI = 'Your call has been resolved my friend',
    CALL_EN_COURS = 'You already have an active call my friend ...',

    MISSION_NEW = 'A new call is available my friend',
    MISSION_ACCEPT = 'Call accepted, get going my friend!',
    MISSION_ANNULE = 'The client has canceled the call my friend, What a jerk',
    MISSION_CONCURENCE = 'There is several taxis on this job my friend',
    MISSION_INCONNU = 'This call is no longer available my friend',
    MISSION_EN_COURS = 'One of your colleagues is already on the job my friend!'
    
}
-- restart depanneur
local coords = {
    {
        ['PriseDeService'] = {x = 895.18, y = -179.19, z = 74.70},
        ['SpawnVehicleAction'] = { x = 900.08, y = -171.57, z = 74.07},
        ['SpawnVehicle'] = {
            {x = 920.15, y = -163.88, z = 74.40, h = 281.23, type = VehicleModelKeyTaxi},
            {x = 913.68, y = -159.34, z = 74.42, h = 13.135, type = VehicleModelKeyTaxi},
            {x = 911.46, y = -163.10, z = 73.99, h = 14.988, type = VehicleModelKeyTaxi},
            {x = 918.00, y = -167.15, z = 74.19, h = 280.71, type = VehicleModelKeyTaxi},
            {x = 916.37, y = -170.75, z = 74.04, h = 281.02, type = VehicleModelKeyTaxi},
        },
    }
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


--====================================================================================
--  Gestion de prise et d'abandon de service
--====================================================================================
local function showBliptaxi()
    for _ , c in pairs(coords) do
        local currentBlip = AddBlipForCoord(c.PriseDeService.x, c.PriseDeService.y, c.PriseDeService.z)
        SetBlipSprite(currentBlip, 17)
        SetBlipColour(currentBlip, 25)
        SetBlipAsShortRange(currentBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(TEXT.BliptaxiService)
        EndTextCommandSetBlipName(currentBlip)
        SetBlipAsMissionCreatorBlip(currentBlip, true)
        table.insert(taxi_Bliptaxi, currentBlip)

        local currentBlip2 = AddBlipForCoord(c.SpawnVehicleAction.x, c.SpawnVehicleAction.y, c.SpawnVehicleAction.z)
        SetBlipSprite(currentBlip2, 18)
        SetBlipColour(currentBlip2, 64)
        SetBlipAsShortRange(currentBlip2, true)
        --SetBlipFlashes(currentBlip,1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(TEXT.BliptaxiVehicle)
        EndTextCommandSetBlipName(currentBlip2)
        SetBlipAsMissionCreatorBlip(currentBlip2, true)
        table.insert(taxi_Bliptaxi, currentBlip2)
    end
end

local function removeBliptaxi()
    for _ , c in pairs(taxi_Bliptaxi) do
        RemoveBlip(c)
    end
    taxi_Bliptaxi = {}
end

function spawnVehicle(coords, type)
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
                SetVehicleNumberPlateText(myVehiculeEntity, "Taxi-" .. math.random(100,999))
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
    notifIcon("CHAR_BLANK_ENTRY", 1, "taxi", false, TEXT.SpawnVehicleImpossible)
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


local function toogleService()
    inService = not inService
    if inService then
        local myPed = GetPlayerPed(-1)
        TriggerServerEvent('taxi:takeService')
        TriggerServerEvent('taxi:requestMission')
    else
        -- Restaure Ped
        TriggerServerEvent('taxi:endService')
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
                    spawnVehicle(coordData.SpawnVehicle, VehicleModelKeyTaxi)
                end
            end
        end
    end
end

--====================================================================================
-- 
--====================================================================================

function showInfoClient() 
    if taxi_call_accept ~= 0 then

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
        if taxi_call_accept == 1 then
            AddTextComponentString(TEXT.CALL_INFO_OK)
        else 
            if taxi_nbtaxiInService == 0 then
                AddTextComponentString(TEXT.CALL_INFO_NO_PERSONNEL)
            elseif taxi_nbtaxiDispo == 0 then
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
    AddTextComponentString('~o~Taxi Info')
    DrawText(offsetX, offsetY - 0.03)

    SetTextFont(1)
    SetTextScale(0.0,0.5)
    SetTextCentre(false)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")

    AddTextComponentString(taxi_nbMissionEnAttenteText)
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

        if isTaxi then
            gestionService()
            if inService then
                showInfoJobs()
            end
        end

        if taxi_call_accept ~= 0 then
            showInfoClient()
        end
    end
end)

--
RegisterNetEvent('taxi:drawMarker')	
AddEventHandler('taxi:drawMarker', function (boolean)
	isTaxi = boolean
    if isTaxi then
        showBliptaxi()
    else
        removeBliptaxi()
    end
end)
RegisterNetEvent('taxi:drawBlips')	
AddEventHandler('taxi:drawBlips', function ()
end)
RegisterNetEvent('taxi:marker')	
AddEventHandler('taxi:marker', function ()
end)

RegisterNetEvent('taxi:deleteBlips')
AddEventHandler('taxi:deleteBlips', function ()
    isTaxi = false
    removeBliptaxi()
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

RegisterNetEvent("taxi:PersonnelMessage")
AddEventHandler("taxi:PersonnelMessage",function(message)
    if inService then
        notifIcon("CHAR_BLANK_ENTRY", 1, "Taxi Info", false, message)
    end
end)

RegisterNetEvent("taxi:ClientMessage")
AddEventHandler("taxi:ClientMessage",function(message)
    notifIcon("CHAR_BLANK_ENTRY", 1, "Taxi", false, message)
end)


--=== restart depanneur
function acceptMission(data) 
    local mission = data.mission 
    TriggerServerEvent('taxi:AcceptMission', mission.id)
end

function finishCurrentMission()
    TriggerServerEvent('taxi:FinishMission', currentMissions.id)
    currentMissions = nil
    if currentBlip ~= nil then
        RemoveBlip(currentBlip)
    end
end

function updateMenuMission() 
    local items = {}
    for _,m in pairs(listMissions) do 
        -- Citizen.Trace('item mission')
        local item = {
            Title = 'Mission ' .. m.id .. ' [' .. m.type .. ']',
            mission = m,
            Function = acceptMission
        }
        if #m.acceptBy ~= 0 then
            item.Title = item.Title .. ' (Active)'
            item.TextColor = {39, 174, 96, 255}
        end
        table.insert(items, item)
    end
    if currentMissions ~= nil then
        table.insert(items, {['Title'] = 'Finish mission', ['Function'] = finishCurrentMission})
    end
    table.insert(items, {['Title'] = 'Close'})

    menu = items
    updateMenu(menu)
end

RegisterNetEvent('taxi:MissionAccept')
AddEventHandler('taxi:MissionAccept', function (mission)
    currentMissions = mission
    SetNewWaypoint(mission.pos[1], mission.pos[2])
    currentBlip= AddBlipForCoord(mission.pos[1], mission.pos[2], mission.pos[3])
    SetBlipSprite(currentBlip, 309)
    SetBlipColour(currentBlip, 5)
    SetBlipAsShortRange(currentBlip, true)
    --SetBlipFlashes(currentBlip,1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(TEXT.Blip)
	EndTextCommandSetBlipName(currentBlip)
    SetBlipAsMissionCreatorBlip(currentBlip, true)

end)


RegisterNetEvent('taxi:MissionCancel')
AddEventHandler('taxi:MissionCancel', function ()
    currentMissions = nil
    if currentBlip ~= nil then
        RemoveBlip(currentBlip)
    end
end)

RegisterNetEvent('taxi:MissionChange')
AddEventHandler('taxi:MissionChange', function (missions)
    if not inService then
        return
    end
    listMissions = missions

    local nbMissionEnAttente = 0

    for _,m in pairs(listMissions) do

        if #m.acceptBy == 0 then
        nbMissionEnAttente = nbMissionEnAttente + 1
        end
    end
    if nbMissionEnAttente == 0 then 
        taxi_nbMissionEnAttenteText = TEXT.InfotaxiNoAppel
    else
        taxi_nbMissionEnAttenteText = '~g~ ' .. nbMissionEnAttente .. ' ' .. TEXT.InfotaxiNbAppel
    end

    updateMenuMission()
end)


function callService(type)
    local myPed = GetPlayerPed(-1)
    local myCoord = GetEntityCoords(myPed)
    TriggerServerEvent('taxi:Call', myCoord.x, myCoord.y, myCoord.z, type)
end

function toogleHelperLine()
    ShowLineGrueHelp = not ShowLineGrueHelp
end
RegisterNetEvent('taxi:openMenu')
AddEventHandler('taxi:openMenu', function()
    -- Citizen.Trace('open menu taxi')
    if inService then
        TriggerServerEvent('taxi:requestMission')
        openMenuGeneral()
    else
        showMessageInformation("~r~You must be in service to access the menu")
    end
end)

RegisterNetEvent('taxi:callService')
AddEventHandler('taxi:callService',function(data)
    callService(data.type)
end)

RegisterNetEvent('taxi:callServiceCustom')
AddEventHandler('taxi:callServiceCustom',function(data)
    local info = openTextInput('', '', 128)
    if info ~= nil and info ~= '' then
         callService(info)
    end
end)

RegisterNetEvent('taxi:callStatus')
AddEventHandler('taxi:callStatus',function(status)
    taxi_call_accept = status
end)

RegisterNetEvent('taxi:personnelChange')
AddEventHandler('taxi:personnelChange',function(nbPersonnel, nbDispo)
    taxi_nbtaxiInService = nbPersonnel
    taxi_nbtaxiDispo = nbDispo
end)

RegisterNetEvent('taxi:cancelCall')
AddEventHandler('taxi:cancelCall',function(data)
    TriggerServerEvent('taxi:cancelCall')
end)



function openTextInput(title, defaultText, maxlength)
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", defaultText or "", "", "", "", maxlength or 180)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        return GetOnscreenKeyboardResult()
    end
	return nil
end


--Citizen.Trace("taxi load")
TriggerServerEvent('taxi:requestPersonnel')



-- isTaxi = true
-- toogleService()


-- ----[[ DEBUG
-- local myPed = GetPlayerPed(-1)
-- local myCoord = GetEntityCoords(myPed)
-- -- toogleService()
-- Citizen.Trace('Pos init: ' .. myCoord.x .. ', ' .. myCoord.y .. ', ' .. myCoord.z)

-- -- local l = math.floor(math.random() * #coords) + 1 
-- -- -- Citizen.Trace('Tp at ' .. l )
-- -- local pos = coords[l].SpawnVehicleAction
-- -- --SetEntityCoords(myPed, pos.x, pos.y, pos.z)

-- -- --]]
-- toogleService()
-- isTaxi = true
-- -- local myPed = GetPlayerPed(-1)
-- -- local myCoord = GetEntityCoords(myPed)
-- -- local any = nil
-- -- AddRope(
-- -- myCoord.x, myCoord.y, myCoord.z, 
-- -- 0.0, 0.0, 0.0,
-- -- 5.0, 1, 4.5, 5.5, 
-- -- 0,0,0,
-- -- 0,0,0,Citizen.ReturnResultAnyway())
-- local function GetVehicleInDirection( coordFrom, coordTo )
--     local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
--     local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
--     return vehicle
-- end

-- local function GetVehicleLookByPlayer(ped, dist)
--     local playerPos =GetOffsetFromEntityInWorldCoords( ped, 0.0, 0.0, 0.0 )
--     local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, dist, -0.8 )
--     return GetVehicleInDirection( playerPos, inFrontOfPlayer )
-- end
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