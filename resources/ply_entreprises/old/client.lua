--[[Register]]--


RegisterNetEvent('ply_ressources:SpawnJobVehicle')
RegisterNetEvent('ply_ressources:SetLoaddout')
RegisterNetEvent('ply_ressources:DelJobVehicle')
RegisterNetEvent('ply_ressources:noJob')
RegisterNetEvent('ply_ressources:serviceOn')
RegisterNetEvent('ply_ressources:serviceOff')
RegisterNetEvent('ply_ressources:noService')
RegisterNetEvent('ply_ressources:alreadyVehicleJob')
RegisterNetEvent('ply_ressources:goToJob')
RegisterNetEvent('ply_ressources:jobVehicleBack')
RegisterNetEvent('ply_ressources:noJobVehicle')
RegisterNetEvent('ply_ressources:jobQuit')
RegisterNetEvent('ply_ressources:getVitems')
RegisterNetEvent('ply_ressources:setJobInfo')
RegisterNetEvent('ply_ressources:JobItemAdd')
RegisterNetEvent('ply_ressources:JobItemSold')
RegisterNetEvent('ply_ressources:JobItemMoreSpace')
RegisterNetEvent('ply_ressources:noJobItemToTraitement')
RegisterNetEvent('ply_ressources:noJobItemToSell')


--[[Local/Global]]--


VITEMS = {}
IJOBS = {}

local ressources = {
	{	
	ressource1="Ore (copper)",
	ressource2="Ingot (copper)",
	job_name="Miner (copper)",
	job_vehicle="Rubble",
	colour=17,
	d=67,
	r=89,
	t=79,
	v=108,
	dname="Vehicle depot (copper)",
	rname="Mine (copper)",
	tname="Treatment (copper)",
	vname="Sale (copper)",
	xd=481.915,
	yd=-1977.266,
	zd=23.483,
	xr=2946.823,
	yr=2804.022,
	zr=41.371,
	xt=312.385,
	yt=2872.32,
	zt=43.506,
	xv=-114.416,
	yv=-1050.48,
	zv=27.273,
	time1=0,
	time2=0,
	time3=0
	},{	
	ressource1="Ore (gold)",
	ressource2="Ingot (gold)",
	job_name="Miner (gold)",
	job_vehicle="Scrap",
	colour=46,
	d=67,
	r=89,
	t=79,
	v=108,
	dname="Vehicle depot (gold)",
	rname="Mine (gold)",
	tname="Treatment (gold)",
	vname="Sale (gold)",
	xd=815.705,
	yd=2185.12,
	zd=51.202,
	xr=-605.207,
	yr=2104.57,
	zr=127.824,
	xt=82.213,
	yt=6323.33,
	zt=31.238,
	xv=-635.636,
	yv=-240.29,
	zv=38.102,
	time1=0,
	time2=0,
	time3=0
	},

}

depot = { {x=nil, y=nil, z=nil}, }
recolte = { {x=nil, y=nil, z=nil, ressource1=nil, time=nil}, }
traitement = { {x=nil, y=nil, z=nil, ressource1=nil, ressource2=nil, time=nil}, }
vente = { {x=nil, y=nil, z=nil, ressource2=nil, time=nil}, }


--[[Function]]--

function MenuVehicleJob()
    MenuTitle = "Trunk"
    ClearMenu()
    for ind, value in pairs(VITEMS) do    	
        if (value.quantity > 0) then
            Menu.addButton(tostring(value.name) .. " : " .. tostring(value.quantity), "ItemJobMenu", ind)--value.id)
 		end
    end    
    Menu.addButton("Fermer","CloseMenu2",nil) 
end

function ItemJobMenu(itemId)
    MenuTitle = "Options :"
    ClearMenu()
    Menu.addButton("Delete 1", "delete", itemId)
    Menu.addButton("Delete All", "deleteAll", itemId)
    Menu.addButton("Back", "MenuVehicleJob", nil)
end

function delete(itemId)
    TriggerServerEvent("ply_ressources:updateQuantity", itemId)
    TriggerServerEvent("ply_ressources:getVitems")
    Wait(1000)
    MenuVehicleJob()
end

function deleteAll(itemId)
    TriggerServerEvent("ply_ressources:dellAllFromId", itemId)
    TriggerServerEvent("ply_ressources:getVitems")
    Wait(1000)
    MenuVehicleJob()
end

function MenuMineur(job_name)
	local job_name = job_name
    MenuTitle = job_name
    ClearMenu()
    Menu.addButton("Taking / Leaving Service","Service",job_name)
    Menu.addButton("Taking a vehicle","PVehicule",nil)
    Menu.addButton("Return the vehicle","RVehicule",nil)
    Menu.addButton("To resign","Fired",nil)
    Menu.addButton("Close","CloseMenu",nil) 
end

function Service(job_name)	
	local job_name = job_name
	TriggerServerEvent('ply_ressources:CheckJobService', job_name)
end

function PVehicule()
	TriggerServerEvent('ply_ressources:CheckJobVehiclePlate',source)	
	CloseMenu()
end

function RVehicule()
	TriggerServerEvent('ply_ressources:BackJobVehicle',source)
end

function Fired()
	TriggerServerEvent('ply_ressources:quitJob',job_name)
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function CloseMenu()
    ClearMenu()
    Menu.hidden = true
    TriggerServerEvent("ply_ressources:getJobInfo")
    TriggerServerEvent("ply_ressources:getVitems")
end

function CloseMenu2()
    ClearMenu()
    Menu.hidden2 = true
    TriggerServerEvent("ply_ressources:getJobInfo")
    TriggerServerEvent("ply_ressources:getVitems")
end

function LocalPed()
	return GetPlayerPed(-1)
end

function IsPlayerInRangeOfGarage()
	return inrangeofgarage
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

--[[Event]]--

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("ply_ressources:getVitems")
end)

AddEventHandler("ply_ressources:getVitems", function(VTHEITEMS)
    VITEMS = {}
    VITEMS = VTHEITEMS
end)

AddEventHandler("ply_ressources:setJobInfo", function(THEIJOBS)
    IJOBS = {}
    IJOBS = THEIJOBS
end)

--[[Citizen]]--

--menu du vehicule
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)		
		for i, v in pairs(IJOBS) do 
			local jobId = v.job_id
			local jobPlate = v.job_vehicle_plate
			if IsPedInAnyVehicle(LocalPed(), true) == false and IsControlJustPressed(1, 7) then
				if jobId ~= 3 then
					local pos = GetEntityCoords(GetPlayerPed(-1))
					local veh = GetClosestVehicle(pos, 3.000, 0, 70)
					SetEntityAsMissionEntity(veh, true, true)
					if DoesEntityExist(veh) then
						local plate = GetVehicleNumberPlateText(veh)
						if jobPlate == plate then
							MenuVehicleJob()
							Menu.hidden2 = not Menu.hidden2
						else			
							drawNotification("You are not near your service vehicle") 
						end		
					end
				end
			end
			Menu.renderGUI2()
		end
	end
end)

--dépot de camion--
Citizen.CreateThread(function()
    for _, item in pairs(ressources) do
		item.blip = AddBlipForCoord(item.xd, item.yd, item.zd)
		SetBlipSprite(item.blip, item.d)
		SetBlipAsShortRange(item.blip, true)
		SetBlipColour(item.blip, item.colour)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.dname)
		EndTextCommandSetBlipName(item.blip)
		SetBlipAsShortRange(item.blip,true)
		SetBlipAsMissionCreatorBlip(item.blip,true)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, ressource in pairs(ressources) do
			DrawMarker(1, ressource.xd, ressource.yd, ressource.zd,0,0,0,0,0,0,10.001,10.0001,0.5001,255,220,60,255,0,0,0,0)
			if GetDistanceBetweenCoords(ressource.xd, ressource.yd, ressource.zd,GetEntityCoords(LocalPed())) < 5 and IsPedInAnyVehicle(LocalPed(), true) == false then
				drawTxt('~g~E~s~ to open the menu',0,1,0.5,0.8,0.6,255,255,255,255)		
				if IsControlJustPressed(1, 86) then
					depot.x = ressource.xd
					depot.y = ressource.yd
					depot.z = ressource.zd
					job_name = ressource.job_name
					MenuMineur(job_name)
					Menu.hidden = not Menu.hidden
				end
				Menu.renderGUI()
			end
		end
	end
end)

AddEventHandler('ply_ressources:SetLoadout', function(loadout)
	Citizen.CreateThread(function()
		local loadout = loadout
		local model = GetHashKey(loadout)
		RequestModel(model)
	    while not HasModelLoaded(model) do
	        RequestModel(model)
	        Citizen.Wait(0)
	    end
	    SetPlayerModel(PlayerId(), model)
	    SetModelAsNoLongerNeeded(model)
    end)
end)

AddEventHandler('ply_ressources:SpawnJobVehicle', function(veh)
	local veh = veh
	local brutmodel = veh	
	local model = GetHashKey(veh)
	local playerPed = GetPlayerPed(-1)
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		local veh = GetClosestVehicle(depot.x, depot.y, depot.z, 5.000, 0, 70)
		if DoesEntityExist(caisseo) then
			drawNotification("The area is cluttered") 
		else	
			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(0)
			end	
			camion = CreateVehicle(model, depot.x, depot.y, depot.z, 0.0, true, false)
			SetVehicleOnGroundProperly(camion)
			TaskWarpPedIntoVehicle(playerPed, camion, -1)
			local plate = GetVehicleNumberPlateText(camion)
			TriggerServerEvent('ply_ressources:SetJobVehiclePlateModel', plate, brutmodel)
		end
	end)
end)

AddEventHandler('ply_ressources:DelJobVehicle', function(plate)
	local plate = plate
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		local veh = GetClosestVehicle(depot.x, depot.y,depot.z, 5.000, 0, 70)
		SetEntityAsMissionEntity(veh, true, true)		
		local plateveh = GetVehicleNumberPlateText(veh)
		if DoesEntityExist(veh) then	
			if plate ~= plateveh then					
				drawNotification("This is not the right vehicle")
			else
				Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
				TriggerServerEvent("ply_ressources:SetNullVehPlate")
			end
		else
			drawNotification("No vehicles present")
		end   
	end)
end)



--récolte--
Citizen.CreateThread(function()
    for _, item in pairs(ressources) do
		item.blip = AddBlipForCoord(item.xr, item.yr, item.zr)
		SetBlipSprite(item.blip, item.r)
		SetBlipAsShortRange(item.blip, true)
		SetBlipColour(item.blip, item.colour)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.rname)
		EndTextCommandSetBlipName(item.blip)
		SetBlipAsShortRange(item.blip,true)
		SetBlipAsMissionCreatorBlip(item.blip,true)
    end
end)

Citizen.CreateThread(function()
	while true do		
		Citizen.Wait(0)
		for _, ressource in pairs(ressources) do
		--DrawMarker(1,ressource_location[1],ressource_location[2],ressource_location[3],0,0,0,0,0,0,10.001,10.0001,0.5001,255,220,60,255,0,0,0,0)
			if GetDistanceBetweenCoords(ressource.xr, ressource.yr, ressource.zr,GetEntityCoords(LocalPed())) < 20 and IsPedInAnyVehicle(LocalPed(), true) == false then
				ShowInfo("~INPUT_VEH_HORN~ to mine", 0)
	    		if IsControlJustPressed(1, 86) then
					recolte.x = ressource.xr
					recolte.y = ressource.yr
					recolte.z = ressource.zr
					recolte.ressource1 = ressource.ressource1
					recolte.time = ressource.time1
					camion = GetClosestVehicle(GetEntityCoords(LocalPed()), 4.000, 0, 70)
					if DoesEntityExist(camion) then
						local time = recolte.time
						SetEntityAsMissionEntity(camion, true, true)
						plate_camion = GetVehicleNumberPlateText(camion)
						for _, v in pairs(IJOBS) do 
							local plate = v.job_vehicle_plate
							if plate_camion == v.job_vehicle_plate then
							Wait(time)
							TriggerServerEvent("ply_ressources:GetItemLegit", recolte.ressource1)
							else
								drawNotification("You are not close enough to your service vehicle")
							end
						end
					else
						drawNotification("Where is the vehicle?")
					end
				end
			end
		end
	end
end)

--traitement--
Citizen.CreateThread(function()
    for _, item in pairs(ressources) do
		item.blip = AddBlipForCoord(item.xt, item.yt, item.zt)
		SetBlipSprite(item.blip, item.t)
		SetBlipAsShortRange(item.blip, true)
		SetBlipColour(item.blip, item.colour)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.tname)
		EndTextCommandSetBlipName(item.blip)
		SetBlipAsShortRange(item.blip,true)
		SetBlipAsMissionCreatorBlip(item.blip,true)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, ressource in pairs(ressources) do
		--DrawMarker(1,traitement_location[1],traitement_location[2],traitement_location[3],0,0,0,0,0,0,10.001,10.0001,0.5001,255,220,60,255,0,0,0,0)
			if GetDistanceBetweenCoords(ressource.xt, ressource.yt, ressource.zt,GetEntityCoords(LocalPed())) < 10 and IsPedInAnyVehicle(LocalPed(), true) == false then
	    		ShowInfo("~INPUT_VEH_HORN~ to melt", 0)
				if IsControlJustPressed(1, 86) then
					traitement.x = ressource.xt
					traitement.y = ressource.yt
					traitement.z = ressource.zt
					traitement.ressource1 = ressource.ressource1
					traitement.ressource2 = ressource.ressource2
					traitement.time = ressource.time2
					camion = GetClosestVehicle(GetEntityCoords(LocalPed()), 4.000, 0, 70)
					if DoesEntityExist(camion) then
						local time = traitement.time
						SetEntityAsMissionEntity(camion, true, true)
						plate_camion = GetVehicleNumberPlateText(camion)
						for _, v in pairs(IJOBS) do 
							local plate = v.job_vehicle_plate
							if plate_camion == v.job_vehicle_plate then
							Wait(time)
							TriggerServerEvent("ply_ressources:GetItemLegit2", traitement.ressource1, traitement.ressource2)
							else
								drawNotification("You are not close enough to your service vehicle")
							end
						end
					else
						drawNotification("Where is the vehicle?")
					end
				end
			end
		end
	end
end)

--vente--
Citizen.CreateThread(function()
    for _, item in pairs(ressources) do
		item.blip = AddBlipForCoord(item.xv, item.yv, item.zv)
		SetBlipSprite(item.blip, item.v)
		SetBlipAsShortRange(item.blip, true)
		SetBlipColour(item.blip, item.colour)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.vname)
		EndTextCommandSetBlipName(item.blip)
		SetBlipAsShortRange(item.blip,true)
		SetBlipAsMissionCreatorBlip(item.blip,true)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, ressource in pairs(ressources) do
		--DrawMarker(1,vente_location[1],vente_location[2],vente_location[3],0,0,0,0,0,0,10.001,10.0001,0.5001,255,220,60,255,0,0,0,0)
			if GetDistanceBetweenCoords(ressource.xv, ressource.yv, ressource.zv,GetEntityCoords(LocalPed())) < 10 and IsPedInAnyVehicle(LocalPed(), true) == false then
	    		ShowInfo("~INPUT_VEH_HORN~ to sell", 0)
				if IsControlJustPressed(1, 86) then
					vente.x = ressource.xv
					vente.y = ressource.yv
					vente.z = ressource.zv
					vente.ressource2 = ressource.ressource2
					vente.time = ressource.time3
					camion = GetClosestVehicle(GetEntityCoords(LocalPed()), 4.000, 0, 70)
					if DoesEntityExist(camion) then
						local time = vente.time
						SetEntityAsMissionEntity(camion, true, true)
						plate_camion = GetVehicleNumberPlateText(camion)
						for _, v in pairs(IJOBS) do 
							local plate = v.job_vehicle_plate
							if plate_camion == v.job_vehicle_plate then
							Wait(time)
							TriggerServerEvent("ply_ressources:SelItemLegit", vente.ressource2)
							else
								drawNotification("You are not close enough to your service vehicle")
							end
						end
					else
						drawNotification("Where is the vehicle?")
					end					
				end
			end
		end
	end
end)

AddEventHandler('ply_ressources:noJob', function()
	drawNotification("You are not hired for this job")
end)

AddEventHandler('ply_ressources:serviceOn', function()
	drawNotification("Beginning of service, do not forget to take a vehicle")
end)

AddEventHandler('ply_ressources:serviceOff', function()
	drawNotification("End of service, do not forget to return the vehicle")
end)

AddEventHandler('ply_ressources:noService', function()
	drawNotification("You have not started your service")
end)

AddEventHandler('ply_ressources:alreadyVehicleJob', function()
	drawNotification("You already have a vehicle")
end)

AddEventHandler('ply_ressources:goToJob', function()
	drawNotification("Deposit received. Go to work and return the vehicle in good condition")
    TriggerServerEvent("ply_ressources:getVitems")
    TriggerServerEvent("ply_ressources:getJobInfo")
end)

AddEventHandler('ply_ressources:jobVehicleBack', function()
	drawNotification("Vehicle returned, here is your deposit")
end)

AddEventHandler('ply_ressources:noJobVehicle', function()
	drawNotification("Where is the vehicle for this job?")
end)

AddEventHandler('ply_ressources:jobQuit', function()
	drawNotification("You left this job")
end)

AddEventHandler('ply_ressources:JobItemAdd', function(ressource,total)
	drawNotification(ressource.." has been added\nTotal: "..total)
end)

AddEventHandler('ply_ressources:JobItemSold', function(ressource,total)
	drawNotification(ressource.." has been sold\nRemains: "..total)
end)

AddEventHandler('ply_ressources:JobItemMoreSpace', function(ressource,total)
	drawNotification("Service vehicle is full")
end)

AddEventHandler('ply_ressources:noJobItemToTraitement', function(ressource,total)
	drawNotification("There is nothing to treat")
end)

AddEventHandler('ply_ressources:noJobItemToSell', function(ressource,total)
	drawNotification("There is nothing to sell")
end)