--[[Register]]--


RegisterNetEvent('helishop:FinishMoneyCheckForHeli')

--[[Local/Global]]--

local helishop = {
	opened = false,
	title = "Hangar",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.9,
		y = 0.08,
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
				{name = "Helicopters", description = ""},
			}
		},
		["Helicopters"] = {
			title = "",
			name = "Helicopters",
			buttons = {
				{name = "Super Volito", costs = 10000000, description = {}, model = "supervolito"},
                                {name = "Super Volito 2", costs = 11000000, description = {}, model = "supervolito2"},
                                {name = "Volatus", costs = 15000000, description = {}, model = "volatus"},
                                {name = "Swift", costs = 20000000, description = {}, model = "swift"},
                                {name = "Swift 2", costs = 25000000, description = {}, model = "swift2"},
			}
		},
	}
}
local fakeheli = {model = '', car = nil}
local helishop_locations = {
{entering = {-722.634582519531,-1472.89721679688,5.00052261352539}, inside = {-721.634582519531,-1472.89721679688,5.00052261352539}, outside = {-720.634582519531,-1472.89721679688,5.00052261352539}},
}
local helishop_blips ={}
local inrangeofhelishop = false
local currentlocation = nil
local boughtheli = false
local heli_price = 0
local backlock = false
local firstspawn = 0



--[[Functions]]--

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

function IsPlayerInRangeOfhelishop()
	return inrangeofhelishop
end

function ShowhelishopBlips(bool)
	if bool and #helishop_blips == 0 then
		for station,pos in pairs(helishop_locations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			-- 60 58 137
			SetBlipSprite(blip,360)
			SetBlipColour(blip, 3)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Achat Hélicos')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			table.insert(helishop_blips, {blip = blip, pos = loc})
		end
		Citizen.CreateThread(function()
			while #helishop_blips > 0 do
				Citizen.Wait(0)
				local inrange = false
				for i,b in ipairs(helishop_blips) do
					DrawMarker(1,b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,200,0,0,0,0)
					if IsPlayerWantedLevelGreater(GetPlayerIndex(),0) == false and helishop.opened == false and IsPedInAnyVehicle(LocalPed(), true) == false and  GetDistanceBetweenCoords(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],GetEntityCoords(LocalPed())) < 5 then
						drawTxt('Press ~g~ENTER~s~ to access helicopter shop',0,1,0.5,0.8,0.6,255,255,255,255)
						currentlocation = b
						inrange = true
					end
				end
				inrangeofhelishop = inrange
			end
		end)
	elseif bool == false and #helishop_blips > 0 then
		for i,b in ipairs(helishop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		helishop_blips = {}
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

function OpenCreator()
	boughtheli = false
	local ped = LocalPed()
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])
	helishop.currentmenu = "main"
	helishop.opened = true
	helishop.selectedbutton = 0
end

function CloseCreator(name, heli, price)
	Citizen.CreateThread(function()
		local ped = LocalPed()
		if not boughtheli then
			local pos = currentlocation.pos.entering
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
		else
			local name = name
			local heli = heli
			local price = price
			local veh = GetVehiclePedIsUsing(ped)
			local model = GetEntityModel(veh)
			local colors = table.pack(GetVehicleColours(veh))
			local extra_colors = table.pack(GetVehicleExtraColours(veh))

			local mods = {}
			for i = 0,24 do
				mods[i] = GetVehicleMod(veh,i)
			end
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
			local pos = currentlocation.pos.outside

			FreezeEntityPosition(ped,false)
			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(0)
			end
			personalheli = CreateVehicle(model,pos[1],pos[2],pos[3],pos[4],true,false)
			SetModelAsNoLongerNeeded(model)
			for i,mod in pairs(mods) do
				SetVehicleModKit(personalheli,0)
				SetVehicleMod(personalheli,i,mod)
			end
			SetVehicleOnGroundProperly(personalheli)
			local plate = GetVehicleNumberPlateText(personalheli)
			SetVehicleHasBeenOwnedByPlayer(personalboat,true)
			local id = NetworkGetNetworkIdFromEntity(personalheli)
			SetNetworkIdCanMigrate(id, true)
			Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalheli))
			SetVehicleColours(personalheli,colors[1],colors[2])
			SetVehicleExtraColours(personalheli,extra_colors[1],extra_colors[2])
			TaskWarpPedIntoVehicle(GetPlayerPed(-1),personalheli,-1)
			SetEntityVisible(ped,true)
			local primarycolor = colors[1]
			local secondarycolor = colors[2]	
			local pearlescentcolor = extra_colors[1]
			local wheelcolor = extra_colors[2]
			TriggerServerEvent('helishop:BuyForHeli', name, heli, price, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
		end
		helishop.opened = false
		helishop.menu.from = 1
		helishop.menu.to = 10
	end)
end

function drawMenuButton(button,x,y,selected)
	local menu = helishop.menu
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

function drawMenuInfo(text)
	local menu = helishop.menu
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

function drawMenuRight(txt,x,y,selected)
	local menu = helishop.menu
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

function drawMenuTitle(txt,x,y)
	local menu = helishop.menu
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
	--TODO:check if player own car
	if t then
		drawMenuRight("OWNED",helishop.menu.x,y,selected)
	else
		drawMenuRight(button.costs.."$",helishop.menu.x,y,selected)
	end
end

function round(num, idp)
	if idp and idp>0 then
		local mult = 10^idp
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end

function ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = helishop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Helicopters" then
			OpenMenu('Helicopters')
		end
	--elseif this == "Pneumatique" or this == "Voiles" or this == "Jetski" or this == "submersibles" or this == "Chalutier" then
	elseif this == "Helicopters" then
		TriggerServerEvent('helishop:CheckMoneyForHeli',button.name,button.model,button.costs)
	end
end

function OpenMenu(menu)
	fakeheli = {model = '', car = nil}
	helishop.lastmenu = helishop.currentmenu
	if menu == "Helicopters" then
		helishop.lastmenu = "main"
	end
	helishop.menu.from = 1
	helishop.menu.to = 10
	helishop.selectedbutton = 0
	helishop.currentmenu = menu
end


function Back()
	if backlock then
		return
	end
	backlock = true
	if helishop.currentmenu == "main" then
		CloseCreator()
	--elseif boatshop.currentmenu == "Pneumatique" or boatshop.currentmenu == "Voiles" or boatshop.currentmenu == "Jetski" or boatshop.currentmenu == "submersibles" or boatshop.currentmenu == "Chalutier" then
	elseif helishop.currentmenu == "Helicopters" then
		if DoesEntityExist(fakeheli.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakeheli.car))
		end
		fakeheli = {model = '', car = nil}
		OpenMenu(helishop.lastmenu)
	else
		OpenMenu(helishop.lastmenu)
	end

end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end



--[[Citizen]]--

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1,201) and IsPlayerInRangeOfhelishop() then
			if helishop.opened then
				CloseCreator()
			else
				OpenCreator()
			end
		end
		if helishop.opened then
			local ped = LocalPed()
			local menu = helishop.menu[helishop.currentmenu]
			drawTxt(helishop.title,1,1,helishop.menu.x,helishop.menu.y,1.0, 255,255,255,255)
			drawMenuTitle(menu.title, helishop.menu.x,helishop.menu.y + 0.08)
			drawTxt(helishop.selectedbutton.."/"..tablelength(menu.buttons),0,0,helishop.menu.x + helishop.menu.width/2 - 0.0385,helishop.menu.y + 0.067,0.4, 255,255,255,255)
			local y = helishop.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= helishop.menu.from and i <= helishop.menu.to then

					if i == helishop.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,helishop.menu.x,y,selected)
					if button.costs ~= nil then
						--if boatshop.currentmenu == "Pneumatique" or boatshop.currentmenu == "Voiles" or boatshop.currentmenu == "Jetski" or boatshop.currentmenu == "submersibles" or boatshop.currentmenu == "Chalutier" then
						if helishop.currentmenu == "Helicopters" then
							DoesPlayerHaveVehicle(button.model,button,y,selected)
						else
						drawMenuRight(button.costs.."$",helishop.menu.x,y,selected)
						end
					end
					y = y + 0.04
					--if boatshop.currentmenu == "Pneumatique" or boatshop.currentmenu == "Voiles" or boatshop.currentmenu == "Jetski" or boatshop.currentmenu == "submersibles" or boatshop.currentmenu == "Chalutier" then
					if helishop.currentmenu == "Helicopters" then
						if selected then
							if fakeheli.model ~= button.model then
								if DoesEntityExist(fakeheli.car) then
									Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakeheli.car))
								end
								local pos = currentlocation.pos.inside
								local hash = GetHashKey(button.model)
								RequestModel(hash)
								while not HasModelLoaded(hash) do
									Citizen.Wait(0)
									drawTxt("~b~Chargement...",0,1,0.5,0.5,1.5,255,255,255,255)

								end
								local veh = CreateVehicle(hash,pos[1],pos[2],pos[3],pos[4],false,false)
								while not DoesEntityExist(veh) do
									Citizen.Wait(0)
									drawTxt("~b~Chargement...",0,1,0.5,0.5,1.5,255,255,255,255)
								end
								FreezeEntityPosition(veh,true)
								SetEntityInvincible(veh,true)
								SetVehicleDoorsLocked(veh,4)
								--SetEntityCollision(veh,false,false)
								TaskWarpPedIntoVehicle(LocalPed(),veh,-1)
								for i = 0,24 do
									SetVehicleModKit(veh,0)
									RemoveVehicleMod(veh,i)
								end
								fakeheli = { model = button.model, car = veh}
							end
						end
					end
					if selected and IsControlJustPressed(1,201) then
						ButtonSelected(button)
					end
				end
			end
		end
		if helishop.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if helishop.selectedbutton > 1 then
					helishop.selectedbutton = helishop.selectedbutton -1
					if buttoncount > 10 and helishop.selectedbutton < helishop.menu.from then
						helishop.menu.from = helishop.menu.from -1
						helishop.menu.to = helishop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if helishop.selectedbutton < buttoncount then
					helishop.selectedbutton = helishop.selectedbutton +1
					if buttoncount > 10 and helishop.selectedbutton > helishop.menu.to then
						helishop.menu.to = helishop.menu.to + 1
						helishop.menu.from = helishop.menu.from + 1
					end
				end
			end
		end

	end
end)


--[[Events]]--


AddEventHandler('helishop:FinishMoneyCheckForHeli', function(name, heli, price)
	local name = name
	local heli = heli
	local price = price
	boughtheli = true	
	CloseCreator(name, heli, price)
end)

AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		ShowhelishopBlips(true)
		firstspawn = 1
	end
end)
