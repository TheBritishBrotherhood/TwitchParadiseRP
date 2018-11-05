--[[Register]]--

RegisterNetEvent("helishop:getHeli")
RegisterNetEvent('helishop:SpawnHeli')
RegisterNetEvent('helishop:StoreHeli')
RegisterNetEvent('helishop:SelHeli')



--[[Local/Global]]--

helis = {}

local vente_location = {-701.019287109375,-1447.36840820313,5.00052452087402} -- a definir

local heliports = {
	{name="Heliport", colour=3, id=64, x=-725.428771972656, y=-1443.3955078125, z=5.00051927566528, axe = 120.000},
}

heliportsSelected = { {x=nil, y=nil, z=nil}, }

--[[Functions]]--

--[[Menu Dock]]--

function MenuHeli()
    ped = GetPlayerPed(-1);
    MenuTitle = "Heliport"
    ClearMenu()
    Menu.addButton("Rentrer l'hélico","RentrerHelico",nil)
    Menu.addButton("Sortir un hélico","ListeHelico",nil)
    Menu.addButton("Fermer","CloseMenu",nil) 
end

function RentrerHelico()
	TriggerServerEvent('helishop:CheckForHeli',source)
	CloseMenu()
end

function ListeHelico()
    ped = GetPlayerPed(-1);
    MenuTitle = "Hélicoptères"
    ClearMenu()
    for ind, value in pairs(HELICOS) do
            Menu.addButton(tostring(value.heli_name) .. " : " .. tostring(value.heli_state), "OptionHeli", value.id)
    end    
    Menu.addButton("Retour","MenuHeli",nil)
end

function OptionHeli(heliID)
	local heliID = heliID
    MenuTitle = "Options"
    ClearMenu()
    Menu.addButton("Sortir", "SortirHeli", heliID)
    Menu.addButton("Retour", "ListeVHeli", nil)
end

function SortirHeli(heliID)
	local heliID = heliID
	TriggerServerEvent('helishop:CheckForSpawnHeli', heliID)
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

--dock
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, heliport in pairs(heliports) do
			DrawMarker(1, heliport.x, heliport.y, heliport.z, 0, 0, 0, 0, 0, 0, 5.001, 5.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(heliport.x, heliport.y, heliport.z, GetEntityCoords(LocalPed())) < 10 and IsPedInAnyVehicle(LocalPed(), true) == false then
				drawTxt('~g~E~s~ pour ouvrir le menu',0,1,0.5,0.8,0.6,255,255,255,255)
				if IsControlJustPressed(1, 86) then
					heliportsSelected.x = heliport.x
					heliportsSelected.y = heliport.y
					heliportsSelected.z = heliport.z
					heliportsSelected.axe = heliport.axe
					MenuHeli()
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
		for _, heliport in pairs(heliports) do		
			if (GetDistanceBetweenCoords(heliport.x, heliport.y, heliport.z, GetEntityCoords(LocalPed())) < 10 and near ~= true) then 
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
    for _, item in pairs(heliports) do
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
	AddTextComponentString('Revente')
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
	checkgarage = 0
	while true do
		Wait(0)
		DrawMarker(1,vente_location[1],vente_location[2],vente_location[3],0,0,0,0,0,0,5.001,5.0001,0.5001,0,155,255,200,0,0,0,0)
		if GetDistanceBetweenCoords(vente_location[1],vente_location[2],vente_location[3],GetEntityCoords(LocalPed())) < 5 and IsPedInAnyVehicle(LocalPed(), true) == false then
			drawTxt('~g~E~s~ pour vendre l\'hélico à 50% du prix d\'achat',0,1,0.5,0.8,0.6,255,255,255,255)
			if IsControlJustPressed(1, 86) then
				TriggerServerEvent('helishop:CheckForSelHeli',source)
			end
		end
	end
end)



--[[Events]]--

AddEventHandler("helishop:getHeli", function(THEHELICOS)
    HELICOS = {}
    HELICOS = THEHELICOS
end)

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("helishop:CheckHeliportForHeli")
end)

AddEventHandler('helishop:SpawnHeli', function(heli, plate, state, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
	local heli = heli
	local car = GetHashKey(heli)
	local plate = plate
	local state = state
	local primarycolor = tonumber(primarycolor)
	local secondarycolor = tonumber(secondarycolor)
	local pearlescentcolor = tonumber(pearlescentcolor)
	local wheelcolor = tonumber(wheelcolor)
	Citizen.CreateThread(function()
		Citizen.Wait(3000)
		local caisseo = GetClosestVehicle(heliportsSelected.x, heliportsSelected.y, heliportsSelected.z, 3.000, 0, 12294)
		if DoesEntityExist(caisseo) then
			drawNotification("La zone est encombrée") 
		else
			if state == "Sortit" then
				drawNotification("Cet hélico n'est pas au hangar")
			else
				local mods = {}
				for i = 0,24 do
					mods[i] = GetVehicleMod(veh,i)
				end
				RequestModel(car)
				while not HasModelLoaded(car) do
				Citizen.Wait(0)
				end
				veh = CreateVehicle(car, heliportsSelected.x, heliportsSelected.y, heliportsSelected.z, heliportsSelected.axe, true, false)
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
				drawNotification("Hélicoptère sorti")				
				TriggerServerEvent('helishop:SetHeliOut', heli, plate)
   				TriggerServerEvent("helishop:CheckHeliportForHeli")
			end
		end
	end)
end)

AddEventHandler('helishop:StoreHeli', function(heli, plate)
	local heli = GetHashKey(heli)	
	local plate = plate
	Citizen.CreateThread(function()
		Citizen.Wait(3000)
		local caissei = GetClosestVehicle(heliportsSelected.x, heliportsSelected.y, heliportsSelected.z, 5.000, 0, 12294)
		SetEntityAsMissionEntity(caissei, true, true)		
		local platecaissei = GetVehicleNumberPlateText(caissei)
		if DoesEntityExist(caissei) then	
			if plate ~= platecaissei then					
				drawNotification("Ce n'est pas ton hélicoptère")
			else
				Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
				drawNotification("Hélicoptère rentré")
				TriggerServerEvent('helishop:SetHeliIn', plate)
				TriggerServerEvent("helishop:CheckHeliportForHeli")
			end
		else
			drawNotification("Aucun hélicoptère présent")
		end   
	end)
end)

AddEventHandler('helishop:SelHeli', function(heli, plate)
	local heli = GetHashKey(heli)	
	local plate = plate
	Citizen.CreateThread(function()		
		Citizen.Wait(0)
		local caissei = GetClosestVehicle(vente_location[1],vente_location[2],vente_location[3], 3.000, 0, 12294)
		SetEntityAsMissionEntity(caissei, true, true)
		local platecaissei = GetVehicleNumberPlateText(caissei)
		if DoesEntityExist(caissei) then
			if plate ~= platecaissei then
				drawNotification("Ce n'est pas ton hélicoptère")
			else
				Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
				TriggerServerEvent('helishop:SelHeli', helico)
				TriggerServerEvent("helishop:CheckHeliportForHeli")
			end
		else
			drawNotification("Aucun hélicoptère présent")
		end
	end)
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
