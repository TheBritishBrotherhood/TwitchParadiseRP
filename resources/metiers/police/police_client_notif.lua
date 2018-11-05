local KEY_E = 38
local KEY_CLOSE = 177
local POLICE_currentBlip = nil 
local POLICE_listMissions = {}
local POLICE_currentMissions = nil
local POLICE_nbMissionEnAttenteText = '-- Aucune Info --'
local POLICE_BlipMecano = {}
local POLICE_showHelp = false
local POLICE_CALL_ACCEPT_P = 0
local POLICE_nbMecanoisInService = 0
local POLICE_nbMecanoDispo = 0


-- local isCop = false
-- local isCopInService = false
-- local rank = "inconnu"
-- local checkpoints = {}
-- local existingVeh = nil
-- local handCuffed = false

-- isCop = true -- famse
-- isisInService = false
-- blipsCops = {}


local POLICE_TEXT = {
    PrendreService = '~INPUT_PICKUP~ Prendre son service de policier',
    QuitterService = '~INPUT_PICKUP~ Quitter son service de policier',
    SpawnVehicle = '~INPUT_PICKUP~ Recuprer son véhicule de ~b~service',
    SpawnVehicleImpossible = '~R~ Impossible, aucune place disponible',

    Blip = 'Mission en cours',


    MissionCancel = 'Votre mission en cours n\'est plus d\'actualité',
    MissionClientAccept = 'Un policier a prit votre appel',
    MissionClientCancel = 'Votre policier vous a abandonné',
    InfoPoliceNoAppel = '~g~Aucun appel en attente',
    InfoPoliceNbAppel = '~w~ Appel en attente',
    BlipMecanoService = 'Prise de service',
    BlipMecanoVehicle = 'Prise du véhicule de service',

    CALL_INFO_NO_PERSONNEL = '~r~Aucun policier en service',
    CALL_INFO_ALL_BUSY = '~o~Toutes nos unité sont occupés',
    CALL_INFO_WAIT = '~b~Votre appel est sur attente',
    CALL_INFO_OK = '~g~Une unité va arriver sur les lieux de l\'appel',

    CALL_RECU = 'Confirmation\nVotre appel a été enregistré',
    CALL_ACCEPT_P_P = 'Votre appel a été accepté, un Policier est en route',
    CALL_CANCEL = 'Le policer vient d\'abandonner votre appel',
    CALL_FINI = 'Votre appel a été résolu',
    CALL_EN_COURS = 'Vous avez déjà une demande en cours ...',

    MISSION_NEW = 'Une nouvelle alerte a été signalée, elle a été ajoutée dans votre liste de missions',
    MISSION_ACCEPT = 'Mission acceptée, mettez vous en route',
    MISSION_ANNULE = 'Votre client s\'est décommandé',
    MISSION_CONCURENCE = 'Vous êtes plusieurs sur le coup',
    MISSION_INCONNU = 'Cette mission n\'est plus d\'actualité',
    MISSION_EN_COURS = 'Cette mission est déjà en cours de traitement'
    
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


-- local function --onServiceChangePolice()
--     if isCopInService then
--         TriggerServerEvent('police:takeService')
--         TriggerServerEvent('police:requestMission')
--     else
--         -- Restaure Ped
--         TriggerServerEvent('police:endService')
--         TriggerServerEvent("skin_customization:SpawnPlayer")
--     end 
-- end


--====================================================================================
-- UserAction restart police
--====================================================================================

	RegisterNetEvent('police:fouille')
	AddEventHandler('police:fouille', function()
		if(isCopInService) then
			t, distance = GetClosestPlayer()
			if(distance ~= -1 and distance < 1) then
				TriggerServerEvent("police:targetFouille", GetPlayerServerId(t))
			else
				TriggerServerEvent("police:targetFouilleEmpty")
			end
		else
			TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Vous n'êtes pas en service !")
		end
	end)

	RegisterNetEvent('police:amende')
	AddEventHandler('police:amende', function(t, amount)
		if(isCopInService) then
			TriggerServerEvent("police:amendeGranted", t, amount)
		else
			TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Vous n'êtes pas en service !")
		end
	end)

	RegisterNetEvent('police:cuff')
	AddEventHandler('police:cuff', function(t)
		if(isCopInService) then
			t, distance = GetClosestPlayer()
			if(distance ~= -1 and distance < 1) then
				TriggerServerEvent("police:cuffGranted", GetPlayerServerId(t))
			else
				TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Aucun joueur à portée !")
			end
		else
			TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Vous n'êtes pas en service !")
		end
	end)

	RegisterNetEvent('police:getArrested')
	AddEventHandler('police:getArrested', function()
		if (isCop == false) then
			handCuffed = not handCuffed
			if (handCuffed) then
				TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Vous avez été menotté.")
				SetPedComponentVariation(GetPlayerPed(-1), 7, 41, 0 ,0)
			else
				TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Liberté ! Adieu merveilleuses menottes ...")
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0 ,0)
			end
		end
	end)

	RegisterNetEvent('police:payAmende')
	AddEventHandler('police:payAmende', function(amount)
		TriggerServerEvent('bank:withdrawAmende', amount)
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Vous avez payé une amende de $"..amount..".")
	end)



	RegisterNetEvent('police:forceEnter')
	AddEventHandler('police:forceEnter', function(id)
		if(isCopInService) then
			t, distance = GetClosestPlayer()
			if(distance ~= -1 and distance < 1) then
				TriggerServerEvent("police:forceEnterAsk", GetPlayerServerId(t))
			else
				TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Aucun joueur menotté à portée !")
			end
		else
			TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Vous n'êtes pas en service !")
		end
	end)





--====================================================================================
-- Vehicule gestion
--====================================================================================

function POLICE_showInfoClient() 
    if POLICE_CALL_ACCEPT_P ~= 0 then

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
        if POLICE_CALL_ACCEPT_P == 1 then
            AddTextComponentString(POLICE_TEXT.CALL_INFO_OK)
        else 
            if POLICE_nbMecanoisInService == 0 then
                AddTextComponentString(POLICE_TEXT.CALL_INFO_NO_PERSONNEL)
            elseif POLICE_nbMecanoDispo == 0 then
                AddTextComponentString(POLICE_TEXT.CALL_INFO_ALL_BUSY)
            else
                AddTextComponentString(POLICE_TEXT.CALL_INFO_WAIT)
            end
        end  
        DrawText(offsetX, offsetY - 0.015 )
    end
end

function POLICE_showInfoJobs()
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
    AddTextComponentString('~o~Police Info')
    DrawText(offsetX, offsetY - 0.03)

    SetTextFont(1)
    SetTextScale(0.0,0.5)
    SetTextCentre(false)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")

    AddTextComponentString(POLICE_nbMissionEnAttenteText)
    DrawText(offsetX - 0.065, offsetY -0.002)
end



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if isCop then
            --gestionService()
            
            if isCopInService then
				--TriggerServerEvent('police:setService', true)
                POLICE_showInfoJobs()	
			else
				--TriggerServerEvent('police:setService', false)
            end
        end

        if POLICE_CALL_ACCEPT_P ~= 0 then
            POLICE_showInfoClient()
        end
        -- Citizen.Trace('isCop: ' .. (isCop and 'True' or 'False'))
        -- POLICE_showInfoJobs()
    end
end)

--
RegisterNetEvent('police:drawMarker')	
AddEventHandler('police:drawMarker', function (boolean)
	isCop = true
    Citizen.Trace('NOW COP')
    Citizen.Trace('NOW COP')
    Citizen.Trace('NOW COP')
end)
RegisterNetEvent('police:drawBlips')	
AddEventHandler('police:drawBlips', function ()

end)
RegisterNetEvent('police:marker')	
AddEventHandler('police:marker', function ()
end)

RegisterNetEvent('police:deleteBlips')
AddEventHandler('police:deleteBlips', function ()
    isCop = false
	Citizen.Trace("NOMORECOP")
	TriggerServerEvent("police:removeCop")
	TriggerEvent("police:finishService")
	
	RemoveAllPedWeapons(GetPlayerPed(-1), true)
end)

--====================================================================================
-- Call System
--====================================================================================

-- Notification
function notifIcon(icon, type, sender, title, text)
	Citizen.CreateThread(function()
        Wait(1)
        SetNotificationTextEntry("STRING");
        if POLICE_TEXT[text] ~= nil then
            text = POLICE_TEXT[text]
        end
        AddTextComponentString(text);
        SetNotificationMessage(icon, icon, true, type, sender, title, text);
        DrawNotification(false, true);
	end)
end

RegisterNetEvent("police:PersonnelMessage")
AddEventHandler("police:PersonnelMessage",function(message)
    if isCopInService then
        notifIcon("CHAR_BLANK_ENTRY", 1, "Police Info", false, message)
    end
end)

RegisterNetEvent("police:ClientMessage")
AddEventHandler("police:ClientMessage",function(message)
    notifIcon("CHAR_BLANK_ENTRY", 1, "Police", false, message)
end)

-- 
function acceptMissionPolice(data) 
    local mission = data.mission 
    TriggerServerEvent('police:AcceptMission', mission.id)
end

function finishCurrentMissionPolice()
    TriggerServerEvent('police:FinishMission', POLICE_currentMissions.id)
    POLICE_currentMissions = nil
    if POLICE_currentBlip ~= nil then
        RemoveBlip(POLICE_currentBlip)
    end
end

function updateMenuMissionPolice() 
    local items = {{['Title'] = 'Retour', ['ReturnBtn'] = true }}
      for k,v in pairs(POLICE_listMissions) do
        Citizen.Trace('==>' .. k )
    end
    for _,m in pairs(POLICE_listMissions) do 
        local item = {
            Title = '' .. m.id .. ' - ' .. m.type,
            mission = m,
            Function = acceptMissionPolice
        }
        if #m.acceptBy ~= 0 then
            item.Title = item.Title .. ' (' .. #m.acceptBy ..' Unité)'
            item.TextColor = {39, 174, 96, 255}
        end
        table.insert(items, item)
        Citizen.Trace('add')
    end

    if POLICE_currentMissions ~= nil then
        table.insert(items, {['Title'] = 'Terminer la mission', ['Function'] = finishCurrentMissionPolice})
    end
    table.insert(items, {['Title'] = 'Fermer'})

    menu = {['Title'] = 'Missions en cours',  ['SubMenu'] = {
        ['Title'] = 'Missions en cours', ['Items'] = items
    }}
    updateMenuPolice(menu)
end

function callPolice(type)
    local myPed = GetPlayerPed(-1)
    local myCoord = GetEntityCoords(myPed)
    TriggerServerEvent('police:Call', myCoord.x, myCoord.y, myCoord.z, type)
end

RegisterNetEvent('police:MissionAccept')
AddEventHandler('police:MissionAccept', function (mission)
    POLICE_currentMissions = mission
    SetNewWaypoint(mission.pos[1], mission.pos[2])
    POLICE_currentBlip = AddBlipForCoord(mission.pos[1], mission.pos[2], mission.pos[3])
    SetBlipSprite(POLICE_currentBlip, 58)
    SetBlipColour(POLICE_currentBlip, 5)
    SetBlipAsShortRange(POLICE_currentBlip, true)
    --SetBlipFlashes(POLICE_currentBlip,1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(POLICE_TEXT.Blip)
	EndTextCommandSetBlipName(POLICE_currentBlip)
    SetBlipAsMissionCreatorBlip(POLICE_currentBlip, true)

end)

RegisterNetEvent('police:MissionCancel')
AddEventHandler('police:MissionCancel', function ()
    POLICE_currentMissions = nil
    if POLICE_currentBlip ~= nil then
        RemoveBlip(POLICE_currentBlip)
    end
end)

RegisterNetEvent('police:MissionChange')
AddEventHandler('police:MissionChange', function (missions)
    if not isCopInService then
        return
    end 
    
    POLICE_listMissions = missions
    local nbMissionEnAttente = 0
    for _,m in pairs(POLICE_listMissions) do
        if #m.acceptBy == 0 then
            nbMissionEnAttente = nbMissionEnAttente + 1
        end
    end
    if nbMissionEnAttente == 0 then 
        POLICE_nbMissionEnAttenteText = POLICE_TEXT.InfoPoliceNoAppel
    else
        POLICE_nbMissionEnAttenteText = '~g~ ' .. nbMissionEnAttente .. ' ' .. POLICE_TEXT.InfoPoliceNbAppel
    end
  
    updateMenuMissionPolice()
end)

RegisterNetEvent('police:openMenu')
AddEventHandler('police:openMenu', function()
    if isCopInService then
        TriggerServerEvent('police:requestMission')
        openMenuPoliceGeneral()
    else
        showMessageInformation("~r~Vous devez être en service pour acceder au menu")
    end
end)

RegisterNetEvent('police:callPolice')
AddEventHandler('police:callPolice',function(data)
    callPolice(data.type)
end)

RegisterNetEvent('police:callPoliceCustom')
AddEventHandler('police:callPoliceCustom',function()
    local raison = openTextInput('','', 32)
    if raison ~= nil and raison ~= '' then 
        callPolice(raison)
    end
end)

RegisterNetEvent('police:callStatus')
AddEventHandler('police:callStatus',function(status)
    POLICE_CALL_ACCEPT_P = status
end)

RegisterNetEvent('police:personnelChange')
AddEventHandler('police:personnelChange',function(nbPersonnel, nbDispo)
    --Citizen.Trace('nbPersonnel : ' .. nbPersonnel .. ' dispo' .. nbDispo)
    POLICE_nbMecanoisInService = nbPersonnel
    POLICE_nbMecanoDispo = nbDispo
end)

RegisterNetEvent('police:cancelCall')
AddEventHandler('police:cancelCall',function(data)
    TriggerServerEvent('police:cancelCall')
end)

--====================================================================================
-- Initialisation
--====================================================================================


RegisterNetEvent('police:drawGetService')
AddEventHandler('police:drawGetService', function (source)
	isCopInService = not isCopInService
    --onServiceChangePolice()
	Citizen.Trace("DRAWDRAW")
	TriggerServerEvent('police:setService', isCopInService)
	if(existingVeh ~= nil) then
		SetEntityAsMissionEntity(existingVeh, true, true)
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
		existingVeh = nil
	end
end)

RegisterNetEvent('police:getSkin')
AddEventHandler('police:getSkin', function (source)
    local playerPed = GetPlayerPed(-1)
    if (isCop and isCopInService) then
        SetPedComponentVariation(playerPed, 11, 55, 0, 2)  --Chemise Police
        SetPedComponentVariation(playerPed, 8, 58, 0, 2)   --Ceinture + matraque Police 
        SetPedComponentVariation(playerPed, 4, 35, 0, 2)   --Pantalon Police
        SetPedComponentVariation(playerPed, 6, 24, 0, 2)   -- Chaussure Police
        SetPedComponentVariation(playerPed, 10, 8, 0, 2)   --grade 0
        SetPedComponentVariation(playerPed, 3, 0, 0, 2)   -- under skin
        GiveWeaponToPed(playerPed, GetHashKey("WEAPON_NIGHTSTICK"), true, true)
        GiveWeaponToPed(playerPed, GetHashKey("WEAPON_PISTOL50"), 100, true, true)
        GiveWeaponToPed(playerPed, GetHashKey("WEAPON_STUNGUN"), true, true)
        GiveWeaponToPed(playerPed, GetHashKey("WEAPON_PUMPSHOTGUN"), 100, true, true)
    else
        TriggerServerEvent("skin_customization:SpawnPlayer")
        RemoveAllPedWeapons(GetPlayerPed(-1), true)
    end
end)

RegisterNetEvent('police:receiveIsCop')
AddEventHandler('police:receiveIsCop', function(result)
    if (result == "inconnu") then
        isCop = false
        isCopInService = false
        --onServiceChangePolice()
    else
        isCop = true
    end
end)

RegisterNetEvent('police:nowCop')
AddEventHandler('police:nowCop', function()
    isCop = true
    isCopInService = false
    --onServiceChangePolice()
    TriggerServerEvent("metiers:jobs", 2)
end)

RegisterNetEvent('police:noLongerCop')
AddEventHandler('police:noLongerCop', function()
    isCop = false
    isCopInService = false
    --onServiceChangePolice()
    TriggerServerEvent("metiers:jobs", 1)
    if(existingVeh ~= nil) then
        SetEntityAsMissionEntity(existingVeh, true, true)
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
        existingVeh = nil
    end
end)

RegisterNetEvent('police:postAmendes')
RegisterNetEvent('police:postAmendes', function(data)
    
end)

RegisterNetEvent('police:postAmendesCustom')
RegisterNetEvent('police:postAmendesCustom', function(data)
    
end)

AddEventHandler("playerSpawned", function(source)
    TriggerServerEvent("police:checkIsCop")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if (handCuffed == true) then
            RequestAnimDict('mp_arresting')
            SetPedComponentVariation(GetPlayerPed(-1), 7, 41, 0 ,0)

            while not HasAnimDictLoaded('mp_arresting') do
            Citizen.Wait(0)
            end
            
            local myPed = PlayerPedId()
            local animation = 'idle'
            local flags = 16

            TaskPlayAnim(myPed, 'mp_arresting', animation, 8.0, -8, -1, flags, 0, 0, 0, 0)
        end
    end
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

--====================================================================================
-- Action
--====================================================================================
function POLICE_Check()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:targetCheckInventory", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', 'GOVERNMENT', {255, 0, 0}, "pas de joueur proche!")
	end
end

function POLICE_Cuffed()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:cuffGranted", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', 'GOVERNMENT', {255, 0, 0}, "pas de joueur proche!")
	end
end

function POLICE_Crocheter()
	Citizen.CreateThread(function()
        Citizen.Trace('POLICE_Crocheter')
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        --GetClosestVehicle(x,y,z,distance dectection, 0 = tous les vehicules, Flag 70 = tous les veicules sauf police a tester https://pastebin.com/kghNFkRi)
        veh = GetClosestVehicle(plyCoords["x"], plyCoords["y"], plyCoords["z"], 5.001, 0, 70)
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
        Citizen.Wait(20000)
        SetVehicleDoorsLocked(veh, 1)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        drawNotification("La voiture est ouverte.")
	end)
end

function POLICE_PutInVehicle()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		local v = GetVehiclePedIsIn(GetPlayerPed(-1), true)
		TriggerServerEvent("police:forceEnterAsk", GetPlayerServerId(t), v)
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "pas de joueur proche!")
	end
end

function POLICE_UnseatVehicle()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:confirmUnseat", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "pas de joueur proche")
	end
end

function POLICE_CheckPlate()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
	if(DoesEntityExist(vehicleHandle)) then
		TriggerServerEvent("police:checkingPlate", GetVehicleNumberPlateText(vehicleHandle))
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Pas de véhicule proche!")
	end
end

function POLICE_FINE_DATA(data)
    POLICE_Fines(data.tarif, data.Title)
end

function POLICE_FINE_CUSTOM()
    local r = openTextInput('','', 128)
    if r ~= nil and r ~= '' then
        local t = tonumber(openTextInput('','', 12))
        if t ~= nil and t > 0 then
            POLICE_Fines(t,r)
        end
    end
end

function POLICE_Fines(amount, reason)
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:finesGranted", GetPlayerServerId(t), amount, reason)
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Pas de joueur proche!")
	end
end
--====================================================================================
-- Event 
--====================================================================================

RegisterNetEvent('police:payFines')
AddEventHandler('police:payFines', function(amount)
	TriggerServerEvent('bank:withdrawAmende', amount)
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Vous avez payé $"..amount.." d'amende.")
end)

RegisterNetEvent('police:dropIllegalItem')
AddEventHandler('police:dropIllegalItem', function(id)
    TriggerEvent("player:looseItem", tonumber(id), exports.vdk_inventory:getQuantity(id))
end)

RegisterNetEvent('police:unseatme')
AddEventHandler('police:unseatme', function(t)
    local ped = GetPlayerPed(t)			
    ClearPedTasksImmediately(ped)
    plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
    local xnew = plyPos.x + 2
    local ynew = plyPos.y + 2
    
    SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

RegisterNetEvent('police:forcedEnteringVeh')
AddEventHandler('police:forcedEnteringVeh', function()
    if(handCuffed) then
        -- local pos = GetEntityCoords(GetPlayerPed(-1), 0)
        -- local entityWorld = GetOffsetFromEntityInWorldCoords(player, 0, 3.0, 0.0)
        -- local rayHandle = Cast_3dRayPointToPoint(pos.x, pos.y, pos.z-1, entityWorld.x, entityWorld.y, entityWorld.z,5, 10, player, 0)
        -- local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
        local ped = GetPlayerPed(-1)
        local coordFrom =GetOffsetFromEntityInWorldCoords( ped, 0.0, 0.0, 0.0 )
        local coordTo = GetOffsetFromEntityInWorldCoords( ped, 0.0, 3.0, -0.8 )
        local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
        local _, _, _, _, vehicleHandle = GetRaycastResult( rayHandle )
        if vehicleHandle ~= nil then
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicleHandle, 2)
            TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Dans La voiture")
        end
    end
end)

RegisterNetEvent('police:resultAllCopsInService')
AddEventHandler('police:resultAllCopsInService', function(array)
	allServiceCops = array
	enableCopBlips()
end)

function enableCopBlips()

	-- for k, existingBlip in pairs(blipsCops) do
        -- RemoveBlip(existingBlip)
    -- end
	-- blipsCops = {}
	
	-- local localIdCops = {}
	-- for id = 0, 64 do
		-- if(NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1)) then
			-- for i,c in pairs(allServiceCops) do
				-- if(i == GetPlayerServerId(id)) then
					-- localIdCops[id] = c
					-- break
				-- end
			-- end
		-- end
	-- end
	
	-- for id, c in pairs(localIdCops) do
		-- local ped = GetPlayerPed(id)
		-- local blip = GetBlipFromEntity(ped)
		
		-- if not DoesBlipExist( blip ) then

			-- blip = AddBlipForEntity( ped )
			-- SetBlipSprite( blip, 1 )
			-- Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
			-- HideNumberOnBlip( blip )
			-- SetBlipNameToPlayerName( blip, id )
			
			-- SetBlipScale( blip,  0.85 )
			-- SetBlipAlpha( blip, 255 )
			
			-- table.insert(blipsCops, blip)
		-- else
			
			-- blipSprite = GetBlipSprite( blip )
			
			-- HideNumberOnBlip( blip )
			-- if blipSprite ~= 1 then
				-- SetBlipSprite( blip, 1 )
				-- Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
			-- end
			
			-- Citizen.Trace("Name : "..GetPlayerName(id))
			-- SetBlipNameToPlayerName( blip, id )
			-- SetBlipScale( blip,  0.85 )
			-- SetBlipAlpha( blip, 255 )
			
			-- table.insert(blipsCops, blip)
		-- end
	-- end
end

--====================================================================================
-- Initialisation
--====================================================================================


TriggerServerEvent('police:requestPersonnel')
--TriggerServerEvent("police:checkIsCop")

-- Register a network event 
RegisterNetEvent( 'deleteVehicle' )

-- The distance to check in front of the player for a vehicle
-- Distance is in GTA units, which are quite big  
local distanceToCheck = 5.0

-- Add an event handler for the deleteVehicle event. 
-- Gets called when a user types in /dv in chat (see server.lua)
function POLICE_deleteVehicle()
    local ped = GetPlayerPed( -1 )

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
        local pos = GetEntityCoords( ped )
        -- log( "Player is at:\nX: " .. pos.x .. " Y: " .. pos.y .. " Z: " .. pos.z )
        -- log( "Found vehicle?: " .. tostring( DoesEntityExist( vehicle ) ) )

        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then 
                ShowNotification( "Vehicule supprime." )
                SetEntityAsMissionEntity( vehicle, true, true )
                deleteCar( vehicle )
            else 
                ShowNotification( "Mettez-vous à la place conducteur" )
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
                ShowNotification( "Rapprochez-vous d'un vehicule" )
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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlPressed(1, 323) then --Start holding X
			if IsPedInAnyVehicle(LocalPed(), true) == false then
				TaskHandsUp(GetPlayerPed(-1), 1000, -1, -1, true) -- Perform animation.
			end
		end
		if IsControlPressed(1, 29) then --Start holding B
			if IsPedInAnyVehicle(LocalPed(), true) == false then
				TaskToggleDuck(GetPlayerPed(-1), 1000, -1, -1, true) -- Perform animation.
				RequestAnimDict( 'gestures@f@standing@casual' )
				while not HasAnimDictLoaded('gestures@f@standing@casual') do
					Citizen.Wait(0)
				end
				if HasAnimDictLoaded('gestures@f@standing@casual') then
					TaskPlayAnim( GetPlayerPed(-1), 'gestures@f@standing@casual', 'gesture_point' ,8.0, -8.0, -1, 0, 0, false, false, false )
				end
			end
		end
		
	end
end)


--[[---------------------------------------------------------------------------------
||                                                                                  ||
||                          SPEEDCAMERA SCRIPT - GTA5 - FiveM                       ||
||                                   Author = Shedow                                ||
||                            Created for N3MTV community                           ||
||                                                                                  ||
----------------------------------------------------------------------------------]]--
 
local maxSpeed = 0
-- local minSpeed = 0
local info = ""
local isRadarPlaced = false -- bolean to get radar status
local Radar -- entity object
local RadarBlip -- blip
local RadarPos = {} -- pos
local RadarAng = 0 -- angle
local LastPlate = ""
local LastVehDesc = ""
local LastSpeed = 0
local LastInfo = ""
 
local function GetPlayers2()
    local players = {}
    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end
 
local function GetClosestDrivingPlayerFromPos(radius, pos)
    local players = GetPlayers2()
    local closestDistance = radius or -1
    local closestPlayer = -1
    local closestVeh = -1
    for _ ,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local ped = GetPlayerPed(value)
            if GetVehiclePedIsUsing(ped) ~= 0 then
                local targetCoords = GetEntityCoords(ped, 0)
                local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], pos["x"], pos["y"], pos["z"], true)
                if(closestDistance == -1 or closestDistance > distance) then
                    closestVeh = GetVehiclePedIsUsing(ped)
                    closestPlayer = value
                    closestDistance = distance
                end
            end
        end
    end
    return closestPlayer, closestVeh, closestDistance
end
 
 
function radarSetSpeed(defaultText)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", defaultText or "", "", "", "", 5)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local gettxt = tonumber(GetOnscreenKeyboardResult())
        if gettxt ~= nil then
            return gettxt
        else
            ClearPrints()
            SetTextEntry_2("STRING")
            AddTextComponentString("~r~Veuillez entrer un nombre correct !")
            DrawSubtitleTimed(3000, 1)
            return
        end
    end
    return
end
 
 
local function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
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
 
function POLICE_radar()
    if isRadarPlaced then -- remove the previous radar if it exists, only one radar per cop
       
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), RadarPos.x, RadarPos.y, RadarPos.z, true) < 0.9 then -- if the player is close to his radar
       
            RequestAnimDict("anim@apt_trans@garage")
            while not HasAnimDictLoaded("anim@apt_trans@garage") do
               Wait(1)
            end
            TaskPlayAnim(GetPlayerPed(-1), "anim@apt_trans@garage", "gar_open_1_left", 1.0, -1.0, 5000, 0, 1, true, true, true) -- animation
       
            Citizen.Wait(2000) -- prevent spam radar + synchro spawn with animation time
       
            SetEntityAsMissionEntity(Radar, false, false)
           
            DeleteObject(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
            DeleteEntity(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
            Radar = nil
            RadarPos = {}
            RadarAng = 0
            isRadarPlaced = false
           
            RemoveBlip(RadarBlip)
            RadarBlip = nil
            LastPlate = ""
            LastVehDesc = ""
            LastSpeed = 0
            LastInfo = ""
           
        else
           
            ClearPrints()
            SetTextEntry_2("STRING")
            AddTextComponentString("~r~Vous n'êtes pas à coté de votre Radar !")
            DrawSubtitleTimed(3000, 1)
           
            Citizen.Wait(1500) -- prevent spam radar
       
        end
   
    else -- or place a new one
        maxSpeed = radarSetSpeed("50")
       
        Citizen.Wait(200) -- wait if the player was in moving
        RadarPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.5, 0)
        RadarAng = GetEntityRotation(GetPlayerPed(-1))
       
        if maxSpeed ~= nil then -- maxSpeed = nil only if the player hasn't entered a valid number
       
            RequestAnimDict("anim@apt_trans@garage")
            while not HasAnimDictLoaded("anim@apt_trans@garage") do
               Wait(1)
            end
            TaskPlayAnim(GetPlayerPed(-1), "anim@apt_trans@garage", "gar_open_1_left", 1.0, -1.0, 5000, 0, 1, true, true, true) -- animation
           
            Citizen.Wait(1500) -- prevent spam radar placement + synchro spawn with animation time
           
            RequestModel("prop_cctv_pole_01a")
            while not HasModelLoaded("prop_cctv_pole_01a") do
               Wait(1)
            end
           
            Radar = CreateObject(1927491455, RadarPos.x, RadarPos.y, RadarPos.z - 7, true, true, true) -- http://gtan.codeshock.hu/objects/index.php?page=1&search=prop_cctv_pole_01a
            SetEntityRotation(Radar, RadarAng.x, RadarAng.y, RadarAng.z - 115)
            -- SetEntityInvincible(Radar, true) -- doesn't work, radar still destroyable
            -- PlaceObjectOnGroundProperly(Radar) -- useless
            SetEntityAsMissionEntity(Radar, true, true)
           
            FreezeEntityPosition(Radar, true) -- set the radar invincible (yeah, SetEntityInvincible just not works, okay FiveM.)
 
            isRadarPlaced = true
           
            RadarBlip = AddBlipForCoord(RadarPos.x, RadarPos.y, RadarPos.z)
            SetBlipSprite(RadarBlip, 380) -- 184 = cam
            SetBlipColour(RadarBlip, 1) -- https://github.com/Konijima/WikiFive/wiki/Blip-Colors
            SetBlipAsShortRange(RadarBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Radar")
            EndTextCommandSetBlipName(RadarBlip)
       
        end
       
    end
end
 
Citizen.CreateThread(function()
    while true do
        Wait(0)
 
        if isRadarPlaced then
       
            if HasObjectBeenBroken(Radar) then -- check is the radar is still there
               
                SetEntityAsMissionEntity(Radar, false, false)
                SetEntityVisible(Radar, false)
                DeleteObject(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
                DeleteEntity(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
               
                Radar = nil
                RadarPos = {}
                RadarAng = 0
                isRadarPlaced = false
               
                RemoveBlip(RadarBlip)
                RadarBlip = nil
               
                LastPlate = ""
                LastVehDesc = ""
                LastSpeed = 0
                LastInfo = ""
               
            end
           
            if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), RadarPos.x, RadarPos.y, RadarPos.z, true) > 100 then -- if the player is too far from his radar
           
                SetEntityAsMissionEntity(Radar, false, false)
                SetEntityVisible(Radar, false)
                DeleteObject(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
                DeleteEntity(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
               
                Radar = nil
                RadarPos = {}
                RadarAng = 0
                isRadarPlaced = false
               
                RemoveBlip(RadarBlip)
                RadarBlip = nil
               
                LastPlate = ""
                LastVehDesc = ""
                LastSpeed = 0
                LastInfo = ""
               
                ClearPrints()
                SetTextEntry_2("STRING")
                AddTextComponentString("~r~Vous êtes parti trop loin de votre Radar !")
                DrawSubtitleTimed(3000, 1)
               
            end
           
        end
       
        if isRadarPlaced then
 
            local viewAngle = GetOffsetFromEntityInWorldCoords(Radar, -8.0, -4.4, 0.0) -- forwarding the camera angle, to increase or reduce the distance, just make a cross product like this one :  ( X * 11.0 ) / 20.0 = Y   gives  (Radar, X, Y, 0.0)
            local ply, veh, dist = GetClosestDrivingPlayerFromPos(20, viewAngle) -- viewAngle
 
            -- local debuginfo = string.format("%s ~n~%s ~n~%s ~n~", ply, veh, dist)
            -- drawTxt(0.27, 0.1, 0.185, 0.206, 0.40, debuginfo, 255, 255, 255, 255)
 
            if veh ~= nil then
           
                local vehPlate = GetVehicleNumberPlateText(veh) or ""
                local vehSpeedKm = GetEntitySpeed(veh)*3.6
                local vehDesc = GetDisplayNameFromVehicleModel(GetEntityModel(veh))--.." "..GetVehicleColor(veh)
                if vehDesc == "CARNOTFOUND" then vehDesc = "" end
               
                -- local vehSpeedMph= GetEntitySpeed(veh)*2.236936
                -- if vehSpeedKm > minSpeed then            
                     
                if vehSpeedKm < maxSpeed then
                    info = string.format("~b~Véhicule  ~w~ %s ~n~~b~Plaque    ~w~ %s ~n~~y~Km/h        ~g~%s", vehDesc, vehPlate, math.ceil(vehSpeedKm))
                else
                    info = string.format("~b~Véhicule  ~w~ %s ~n~~b~Plaque    ~w~ %s ~n~~y~Km/h        ~r~%s", vehDesc, vehPlate, math.ceil(vehSpeedKm))
                    if LastPlate ~= vehPlate then
                        LastSpeed = vehSpeedKm
                        LastVehDesc = vehDesc
                        LastPlate = vehPlate
                    elseif LastSpeed < vehSpeedKm and LastPlate == vehPlate then
                            LastSpeed = vehSpeedKm
                    end
                    LastInfo = string.format("~b~Véhicule  ~w~ %s ~n~~b~Plaque    ~w~ %s ~n~~y~Km/h        ~r~%s", LastVehDesc, LastPlate, math.ceil(LastSpeed))
                end
                   
                DrawRect(0.76, 0.0455, 0.18, 0.09, 0,10, 28, 210)
                drawTxt(0.77, 0.1, 0.185, 0.206, 0.40, info, 255, 255, 255, 255)
               
                DrawRect(0.76, 0.145, 0.18, 0.09, 0,10, 28, 210)
                drawTxt(0.77, 0.20, 0.185, 0.206, 0.40, LastInfo, 255, 255, 255, 255)
                 
                -- end
               
            end
           
        end
           
    end  
end)