--[[Register]]--

RegisterNetEvent("ply_hangars:getPlane")
RegisterNetEvent('ply_hangars:SpawnPlane')
RegisterNetEvent('ply_hangars:StorePlane')
RegisterNetEvent('ply_hangars:BuyTrue')
RegisterNetEvent('ply_hangars:BuyFalse')
RegisterNetEvent('ply_hangars:StorePlaneTrue')
RegisterNetEvent('ply_hangars:StorePlaneFalse')
RegisterNetEvent('ply_hangars:SelPlaneTrue')
RegisterNetEvent('ply_hangars:SelPlaneFalse')


--[[Local/Global]]--

PLANES = {}

local vente_location = {-1647.722, -3150.767, 12.992}
local ventenamefr = "Vente"
local ventenameen = "Sell"
local hangars = {
	{name="Hangar", colour=3, id=359, x=-1277.756, y=-3392.445, z=12.940, axe = 320.000},
}

hangarSelected = { {x=nil, y=nil, z=nil}, }

--[[Functions]]--

function configLang(lang)
	local lang = lang
	if lang == "FR" then
		lang_string = {
			menu0 = "Rentrer l'avion",
			menu1 = "Hangar",
			menu2 = "Sortir un avion",
			menu3 = "Fermer",
			menu4 = "Avions",
			menu5 = "Retour",
			menu6 = "Sortir",
			menu7 = "~g~E~s~ pour ouvrir le menu",
			menu8 = "~g~E~s~ pour vendre l'avion à 50% du prix d\'achat",
			state1 = "Sortit",
			state2 = "Rentré",
			text1 = "Aucun avion présent",
			text2 = "La zone est encombrée",
			text3 = "Cet avion est déjà sorti",
			text4 = "Avion sorti",
			text5 = "Ce n'est pas ton avion",
			text6 = "Avion rentré",
			text7 = "Avion acheté, bon vent",
			text8 = "Fonds insuffisants",
			text9 = "Avion vendu"
	}

	elseif lang == "EN" then
		lang_string = {
			menu0 = "Store the plane",
			menu1 = "Hangar",
			menu2 = "Get a plane",
			menu3 = "Close",
			menu4 = "Planes",
			menu5 = "Back",
			menu6 = "Get",
			menu7 = "~g~E~s~ to open menu",
			menu8 = "~g~E~s~ to sell the plane at 50% of the purchase price",
			state1 = "Out",
			state2 = "In",
			text1 = "No plane present",
			text2 = "The area is crowded",
			text3 = "This plane is already out",
			text4 = "Plane out",
			text5 = "It's not your plane",
			text6 = "Plane stored",
			text7 = "Plane bought, good wind",
			text8 = "Insufficient funds",
			text9 = "Plane sold"
	}
	end
end



--[[Menu Hangar]]--

function MenuHangar()
    ped = GetPlayerPed(-1);
    MenuTitle = lang_string.menu1
    ClearMenu()
    Menu.addButton(lang_string.menu0,"RentrerAvion",nil)
    Menu.addButton(lang_string.menu2,"ListeAvion",nil)
    Menu.addButton(lang_string.menu3,"CloseMenu",nil) 
end

function RentrerAvion()
	Citizen.CreateThread(function()
		local caissei = GetClosestVehicle(hangarSelected.x, hangarSelected.y, hangarSelected.z, 3.000, 0, 16386)
		SetEntityAsMissionEntity(caissei, true, true)
		local plate = GetVehicleNumberPlateText(caissei)
		if DoesEntityExist(caissei) then
			TriggerServerEvent('ply_hangars:CheckForPlane',plate)
		else
			drawNotification(lang_string.text1)
		end   
	end)
	CloseMenu()
end

function ListeAvion()
    ped = GetPlayerPed(-1);
    MenuTitle = lang_string.menu4
    ClearMenu()
    for ind, value in pairs(PLANES) do
            Menu.addButton(tostring(value.plane_name) .. " : " .. tostring(value.plane_state), "OptionAvion", value.id)
    end    
    Menu.addButton(lang_string.menu5,"MenuHangar",nil)
end

function OptionAvion(planeID)
	local planeID = planeID
    MenuTitle = "Options"
    ClearMenu()
    Menu.addButton(lang_string.menu6, "SortirAvion", planeID)
    Menu.addButton(lang_string.menu5, "ListeAvion", nil)
end

function SortirAvion(planeID)
	local planeID = planeID
	TriggerServerEvent('ply_hangars:CheckForSpawnPlane', planeID)
	CloseMenu()
end


---Generic Fonction

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function CloseMenu()
    Menu.hidden = true
    TriggerServerEvent("ply_hangars:CheckHangarForPlane")
end

function LocalPed()
	return GetPlayerPed(-1)
end

function Chat(debugg)
    TriggerEvent("chatMessage", '', { 0, 0x99, 255 }, tostring(debugg))
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

--[[Citizen]]--

--hangar
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, hangar in pairs(hangars) do
			DrawMarker(1, hangar.x, hangar.y, hangar.z, 0, 0, 0, 0, 0, 0, 10.001, 10.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(hangar.x, hangar.y, hangar.z, GetEntityCoords(LocalPed())) < 10 and IsPedInAnyVehicle(LocalPed(), true) == false then
				drawTxt(lang_string.menu7,0,1,0.5,0.8,0.6,255,255,255,255)
				if IsControlJustPressed(1, 86) then
					hangarSelected.x = hangar.x
					hangarSelected.y = hangar.y
					hangarSelected.z = hangar.z
					hangarSelected.axe = hangar.axe					
					MenuHangar()
					Menu.hidden = not Menu.hidden 
				end
				Menu.renderGUI() 
			end
		end
	end
end)

--closmenurange
Citizen.CreateThread(function()
	while true do
		local near = false
		Citizen.Wait(0)
		for _, hangar in pairs(hangars) do		
			if (GetDistanceBetweenCoords(hangar.x, hangar.y, hangar.z, GetEntityCoords(LocalPed())) < 10 and near ~= true) then 
				near = true							
			end
		end
		if near == false then 
			Menu.hidden = true;
		end
	end
end)

--blips
Citizen.CreateThread(function()
    for _, item in pairs(hangars) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipAsShortRange(item.blip, true)
		SetBlipColour(item.blip, item.colour)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.name)
		EndTextCommandSetBlipName(item.blip)
    end
end)


--vente
Citizen.CreateThread(function()
	local loc = vente_location
	local pos = vente_location
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,207)
	SetBlipColour(blip, 3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(ventenameen)
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
	checkgarage = 0
	while true do
		Wait(0)
		DrawMarker(1,vente_location[1],vente_location[2],vente_location[3],0,0,0,0,0,0,10.001,10.0001,0.5001,0,155,255,200,0,0,0,0)
		if GetDistanceBetweenCoords(vente_location[1],vente_location[2],vente_location[3],GetEntityCoords(LocalPed())) < 10 and IsPedInAnyVehicle(LocalPed(), true) == false then
			drawTxt(lang_string.menu8,0,1,0.5,0.8,0.6,255,255,255,255)
			if IsControlJustPressed(1, 86) then
				local caissei = GetClosestVehicle(vente_location[1],vente_location[2],vente_location[3], 10.000, 0, 16386)
				SetEntityAsMissionEntity(caissei, true, true)
				local platecaissei = GetVehicleNumberPlateText(caissei)
				if DoesEntityExist(caissei) then
					TriggerServerEvent('ply_hangars:CheckForSelPlane',platecaissei)
				else
					drawNotification(lang_string.text1)
				end  
			end
		end
	end
end)



--[[Events]]--

AddEventHandler("ply_hangars:getPlane", function(THEPLANES)
    PLANES = {}
    PLANES = THEPLANES
end)

AddEventHandler("playerSpawned", function()
    local lang = "EN"
    TriggerServerEvent("ply_hangars:CheckHangarForPlane")
    TriggerServerEvent("ply_hangars:Lang", lang)
    configLang(lang)
end)

AddEventHandler('ply_hangars:SpawnPlane', function(plane, plate, state, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
	local plane = plane
	local car = GetHashKey(plane)
	local plate = plate
	local state = state
	local primarycolor = tonumber(primarycolor)
	local secondarycolor = tonumber(secondarycolor)
	local pearlescentcolor = tonumber(pearlescentcolor)
	local wheelcolor = tonumber(wheelcolor)
	Citizen.CreateThread(function()
		Citizen.Wait(1000)
		local caisseo = GetClosestVehicle(hangarSelected.x, hangarSelected.y, hangarSelected.z, 10.000, 0, 16386)
		if DoesEntityExist(caisseo) then
			drawNotification(lang_string.text2) 
		else
			if state == lang_string.state1 then
				drawNotification(lang_string.text3)
			else
				local mods = {}
				for i = 0,24 do
					mods[i] = GetVehicleMod(veh,i)
				end
				RequestModel(car)
				while not HasModelLoaded(car) do
				Citizen.Wait(0)
				end
				veh = CreateVehicle(car, hangarSelected.x, hangarSelected.y, hangarSelected.z, hangarSelected.axe, true, false)
				for i,mod in pairs(mods) do
					SetVehicleModKit(personalvehicle,0)
					SetVehicleMod(personalvehicle,i,mod)
				end
				SetVehicleNumberPlateText(veh, plate)
				SetVehicleOnGroundProperly(veh)
				SetVehicleHasBeenOwnedByPlayer(veh,true)
				local id = NetworkGetNetworkIdFromEntity(veh)
				SetNetworkIdCanMigrate(id, true)
				SetVehicleColours(veh, primarycolor, secondarycolor)
				SetVehicleExtraColours(veh, pearlescentcolor, wheelcolor)
				SetEntityInvincible(veh, false) 
				drawNotification(lang_string.text4)				
				TriggerServerEvent('ply_hangars:SetPlaneOut', plane, plate)
   				TriggerServerEvent("ply_hangars:CheckHangarForPlane")
			end
		end
	end)
end)

AddEventHandler('ply_hangars:StorePlaneTrue', function()
	Citizen.CreateThread(function()
		Citizen.Wait(1000)
		local caissei = GetClosestVehicle(hangarSelected.x, hangarSelected.y, hangarSelected.z, 10.000, 0, 16386)
		SetEntityAsMissionEntity(caissei, true, true)
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
		drawNotification(lang_string.text6)
		TriggerServerEvent("ply_hangars:CheckHangarForPlane")
	end)
end)

AddEventHandler('ply_hangars:StorePlaneFalse', function()
	drawNotification(lang_string.text5)
end)

AddEventHandler('ply_hangars:SelPlaneTrue', function()
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		local caissei = GetClosestVehicle(vente_location[1],vente_location[2],vente_location[3], 10.000, 0, 16386)
		SetEntityAsMissionEntity(caissei, true, true)
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
		drawNotification(lang_string.text9)
		TriggerServerEvent("ply_hangars:CheckHangarForPlane")
	end)
end)

AddEventHandler('ply_hangars:SelPlaneFalse', function()
	drawNotification(lang_string.text5)
end)

AddEventHandler('ply_hangars:BuyTrue', function()
	drawNotification(lang_string.text7)
    TriggerServerEvent("ply_hangars:CheckHangarForPlane")
end)

AddEventHandler('ply_hangars:BuyFalse', function()
	drawNotification(lang_string.text8)
end)

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		RemoveIpl('v_carshowroom')
		RemoveIpl('shutter_open')
		RemoveIpl('shutter_closed')
		RemoveIpl('shr_int')
		RemoveIpl('csr_inMission')
		RequestIpl('v_carshowroom')
		RequestIpl('shr_int')
		RequestIpl('shutter_closed')
		firstspawn = 1
	end
end)