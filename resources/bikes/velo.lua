RegisterNetEvent('velo:FinishMoneyCheckForVel')

local velshop = {
	opened = false,
	title = "Bike rental",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.9,
		y = 0.1,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 4,
		["main"] = { 
			title = "CATEGORIES", 
			name = "main",
			buttons = { 
				{name = "Classic Bikes", description = ''},
				{name = "Sports bikes", description = ''},
			}
		},
		["vehicles"] = { 
			title = "VEHICLES", 
			name = "vehicles",
			buttons = { 
				{name = "Classic Bikes", description = ''},
				{name = "Sports bikes", description = ''},
				}
		},
		["Classic-Bikes"] = { 
			title = "Classic-Bikes", 
			name = "Classic-Bikes",
			buttons = { 
				{name = "BMX", costs = 20, description = {}, model = "bmx"},
				{name = "ATV", costs = 20, description = {}, model = "scorcher"},
				{name = "Bike", costs = 20, description = {}, model = "cruiser"},			
			}
		},
		["Sports-bikes"] = { 
			title = "Sports-bikes", 
			name = "Sports-bikes",
			buttons = { 
				{name = "Sports bike", costs = 20, description = {}, model = "fixter"},
				{name = "Sports bike 1", costs = 20, description = {}, model = "tribike"},
				{name = "sports bike 2", costs = 20, description = {}, model = "tribike2"},
				{name = "sports bike 3", costs = 20, description = {}, model = "tribike3"},
			}
		},
	}
}
-- entering = cercle /// -- inside = le ped  /// outside = achat du véhicule //// la quatrieme posistions = angle
local fakevelo = {model = '', velo = nil}
local velo_localisations = {
{entering = {-1259.06,-1439.04,3.59489}, inside = {-1262.94,-1439.67,4.35304, 120.1953}, outside = {-1263.37,-1440.99,4.35418,322.345}},
{entering = {93.938,-742.776,45.100}, inside = {93.938,-742.776,45.100, 77.562}, outside = {93.938,-741.776,45.100, 77.562}},
{entering = {-1235.52,-1448.94,3.59207}, inside = {-1235.93,-1452.72,3.48886, 120.1953}, outside = {-1235.26,-1453.83,3.49025,322.345}},
{entering = {-1220.11,-1494.01,3.58438}, inside = {-1223.15,-1496.19,3.60312, 120.1953}, outside = {-1224.06,-1496.51,3.60949,322.345}},
{entering = {1695.59826, 4925.820800,  41.231708},inside = {1695.59826, 4925.820800,  42.231708},outside  = {1695.59826, 4925.820800,  42.231708}},
{entering = {-377.009307, 6031.3295,  30.521402},inside = {-377.009307, 6031.3295,  31.521402},outside  = {-377.009307, 6031.3295,  31.521402}},
{entering = {531.460998, -144.138565,  57.53329},inside = {531.46099, -144.13856,  58.53329},outside  = {531.4609, -144.1385,  58.5332}},
}

local velshop_blips ={}
local inrangeofvelshop = false
local currentlocationvelo = nil
local boughtvelo = false

local function LocalPed()
return GetPlayerPed(-1)
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

function IsPlayerinrangeofvelshop()
return inrangeofvelshop
end

function ShowvelshopBlips(bool)
	if bool and #velshop_blips == 0 then
		for station,pos in pairs(velo_localisations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])

			SetBlipSprite(blip,162)
			SetBlipColour(blip, 64)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Bike rental')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			table.insert(velshop_blips, {blip = blip, pos = loc})
		end
		Citizen.CreateThread(function()
			while #velshop_blips > 0 do
				Citizen.Wait(0)
				local inrange = false
				for i,b in ipairs(velshop_blips) do
					if IsPlayerWantedLevelGreater(GetPlayerIndex(),0) == false and velshop.opened == false and IsPedInAnyVehicle(LocalPed(), true) == false and  GetDistanceBetweenCoords(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],GetEntityCoords(LocalPed())) < 5 then
						DrawMarker(1,b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,200,0,0,0,0)
						drawTxt('Press ~g~ENTER~s~ to rent a ~b~bike',0,1,0.5,0.8,0.6,255,255,255,255)
						currentlocationvelo = b
						inrange = true
					end
				end
				inrangeofvelshop = inrange
			end
		end)
	elseif bool == false and #velshop_blips > 0 then
		for i,b in ipairs(velshop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		velshop_blips = {}
	end
end

function f(n)
return n + 0.0001
end

function LocalPed()
return GetPlayerPed(-1)
end

function try(f, catch_f)
local status, exception = pcall(f)
if not status then
catch_f(exception)
end
end
function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function OpenCreatorvelo()		
	boughtvelo = false
	local ped = LocalPed()
	local pos = currentlocationvelo.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])
	velshop.currentmenu = "main"
	velshop.opened = true
	velshop.selectedbutton = 0
end

function CloseCreatorvelo()
	Citizen.CreateThread(function()
		local ped = LocalPed()
		if not boughtvelo then
			local pos = currentlocationvelo.pos.entering
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
		else
			local veh = GetVehiclePedIsUsing(ped)
			local model = GetEntityModel(veh)
			local colors = table.pack(GetVehicleColours(veh))
			local extra_colors = table.pack(GetVehicleExtraColours(veh))

			local mods = {}
			for i = 0,24 do
				mods[i] = GetVehicleMod(veh,i)
			end	
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
			local pos = currentlocationvelo.pos.outside

			FreezeEntityPosition(ped,false)
			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(0)
			end
			personalvehicle = CreateVehicle(model,pos[1],pos[2],pos[3],pos[4],true,false)
			SetModelAsNoLongerNeeded(model)
			for i,mod in pairs(mods) do
				SetVehicleModKit(personalvehicle,0)
				SetVehicleMod(personalvehicle,i,mod)
			end
			SetVehicleOnGroundProperly(personalvehicle)
			SetVehicleHasBeenOwnedByPlayer(personalvehicle,true)
			local id = NetworkGetNetworkIdFromEntity(personalvehicle)
			SetNetworkIdCanMigrate(id, true)
			Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
			SetVehicleColours(personalvehicle,colors[1],colors[2])
			SetVehicleExtraColours(personalvehicle,extra_colors[1],extra_colors[2])
			TaskWarpPedIntoVehicle(GetPlayerPed(-1),personalvehicle,-1)
			SetEntityVisible(ped,true)
			
			
		end
		velshop.opened = false
		velshop.menu.from = 1
		velshop.menu.to = 10
	end)
end

function drawMenuVeloButton(button,x,y,selected)
	local menu = velshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)	
end

function drawMenuVeloInfo(text)
	local menu = velshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
	DrawText(0.365, 0.934)	
end

function drawMenuVeloRight(txt,x,y,selected)
	local menu = velshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)	
end

function drawMenuVeloTitle(txt,x,y)
local menu = velshop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)	
end
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
function Notify(text)
SetNotificationTextEntry('STRING')
AddTextComponentString(text)
DrawNotification(false, false)
end

function DoesPlayerHaveVehicle(model,button,y,selected)
		local t = false
		if t then
			drawMenuVeloRight("OWNED",velshop.menu.x,y,selected)
		else
			drawMenuVeloRight(button.costs.."$",velshop.menu.x,y,selected)
		end
end

local backlock = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1,201) and IsPlayerinrangeofvelshop() then
			if velshop.opened then
				CloseCreatorvelo()
			else
				OpenCreatorvelo()
			end
		end
		if velshop.opened then
			local ped = LocalPed()
			local menu = velshop.menu[velshop.currentmenu]
			drawTxt(velshop.title,1,1,velshop.menu.x,velshop.menu.y,1.0, 255,255,255,255)
			drawMenuVeloTitle(menu.title, velshop.menu.x,velshop.menu.y + 0.08)
			drawTxt(velshop.selectedbutton.."/"..tablelength(menu.buttons),0,0,velshop.menu.x + velshop.menu.width/2 - 0.0385,velshop.menu.y + 0.067,0.4, 255,255,255,255)
			local y = velshop.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false
			
			for i,button in pairs(menu.buttons) do
				if i >= velshop.menu.from and i <= velshop.menu.to then
					
					if i == velshop.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuVeloButton(button,velshop.menu.x,y,selected)
					if button.costs ~= nil then
						if velshop.currentmenu == "Classic-Bikes" or velshop.currentmenu == "Sports-bikes" then
							DoesPlayerHaveVehicle(button.model,button,y,selected)
						else
						drawMenuVeloRight(button.costs.."$",velshop.menu.x,y,selected)
						end
					end
					y = y + 0.04
					if velshop.currentmenu == "Classic-Bikes" or velshop.currentmenu == "Sports-bikes" then
						if selected then
							if fakevelo.model ~= button.model then
								if DoesEntityExist(fakevelo.velo) then
									Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakevelo.velo))
								end
								local pos = currentlocationvelo.pos.inside
								local hash = GetHashKey(button.model)
								RequestModel(hash)
								while not HasModelLoaded(hash) do
									Citizen.Wait(0)
									drawTxt("~b~Loading...",0,1,0.5,0.5,1.5,255,255,255,255)
									
								end
								local veh = CreateVehicle(hash,pos[1],pos[2],pos[3],pos[4],false,false)
								while not DoesEntityExist(veh) do
									Citizen.Wait(0)
									drawTxt("~b~Loading...",0,1,0.5,0.5,1.5,255,255,255,255)
								end
								FreezeEntityPosition(veh,true)
								SetEntityInvincible(veh,true)
								SetVehicleDoorsLocked(veh,4)
								TaskWarpPedIntoVehicle(LocalPed(),veh,-1)
								for i = 0,24 do
									SetVehicleModKit(veh,0)
									RemoveVehicleMod(veh,i)
								end
								fakevelo = { model = button.model, velo = veh}
							end
						end
					end
					if selected and IsControlJustPressed(1,201) then
						ButtonSelected(button)
					end
				end
			end	
		end
		if velshop.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if velshop.selectedbutton > 1 then
					velshop.selectedbutton = velshop.selectedbutton -1
					if buttoncount > 10 and velshop.selectedbutton < velshop.menu.from then
						velshop.menu.from = velshop.menu.from -1
						velshop.menu.to = velshop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if velshop.selectedbutton < buttoncount then
					velshop.selectedbutton = velshop.selectedbutton +1
					if buttoncount > 10 and velshop.selectedbutton > velshop.menu.to then
						velshop.menu.to = velshop.menu.to + 1
						velshop.menu.from = velshop.menu.from + 1
					end
				end	
			end
		end
		
	end
end)


function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end
function ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = velshop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Classic Bikes" then
			OpenMenu('Classic-Bikes')
		elseif btn == "Sports bikes" then
			OpenMenu('Sports-bikes')
		end
		
	elseif this == "Classic-Bikes" or this == "Sports-bikes" then

	local name = button.name	
		local vehicle = button.model
		local price = button.costs
		TriggerServerEvent('velo:CheckMoneyForVel',name, vehicle, price)
	end
end

AddEventHandler('velo:FinishMoneyCheckForVel', function(name, vehicle, price)	
	local name = name
	local vehicle = vehicle
	local price = price
	boughtvelo = true
	CloseCreatorvelo(name, vehicle, price)
end)


function OpenMenu(menu)
	fakevelo = {model = '', velo = nil}
	velshop.lastmenu = velshop.currentmenu
	if menu == "vehicles" then
		velshop.lastmenu = "main"
	elseif menu == "bikes"  then
		velshop.lastmenu = "main"
	elseif menu == 'race_create_objects' then
		velshop.lastmenu = "main"
	elseif menu == "race_create_objects_spawn" then
		velshop.lastmenu = "race_create_objects"
	end
	velshop.menu.from = 1
	velshop.menu.to = 10
	velshop.selectedbutton = 0
	velshop.currentmenu = menu	
end


function Back()
	if backlock then
		return
	end
	backlock = true
	if velshop.currentmenu == "main" then
		CloseCreatorvelo()
	elseif velshop.currentmenu == "Classic-Bikes" or velshop.currentmenu == "Sports-bikes" then
		if DoesEntityExist(fakevelo.velo) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakevelo.velo))
		end
		fakevelo = {model = '', velo = nil}
		OpenMenu(velshop.lastmenu)
	else
		OpenMenu(velshop.lastmenu)
	end
	
end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
if firstspawn == 0 then
	ShowvelshopBlips(true)
	firstspawn = 1
end
end)