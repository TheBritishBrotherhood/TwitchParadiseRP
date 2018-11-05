--[[Register]]--


RegisterNetEvent('ply_hangars:FinishMoneyCheckForPlane')

--[[Local/Global]]--

local planeshop = {
	opened = false,
	title = "",
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
				{name = "Civil", description = ""},
				{name = "Militaire", description = ""},
			}
		},
		["Civil"] = {
			title = "Civil",
			name = "Civil",
			buttons = {
				{name = "Cuban 800", costs = 1500000, description = {}, model = "cuban800"},
                {name = "Dodo", costs = 1200000, description = {}, model = "dodo"},
                {name = "Duster", costs = 990000, description = {}, model = "duster"},
                {name = "Luxor", costs = 2000000, description = {}, model = "luxor"},
                {name = "Mammatus", costs = 1100000, description = {}, model = "mammatus"},
                {name = "Mil-Jet", costs = 2500000, description = {}, model = "miljet"},
                {name = "Nimbus", costs = 2500000, description = {}, model = "nimbus"},
                {name = "Shamal", costs = 2200000, description = {}, model = "shamal"},
                {name = "Velum", costs = 1200000, description = {}, model = "velum"},
                {name = "Vestra", costs = 1900000, description = {}, model = "vestra"},
			}
		},
		["Militaire"] = {
			title = "Militaire",
			name = "Militaire",
			buttons = {
				--{name = "Besra", costs = 2500000, description = {}, model = "besra"},
				--{name = "Hydra", costs = 2500000, description = {}, model = "hydra"},
				--{name = "Titan", costs = 2500000, description = {}, model = "titan"},
			}
		},
	}
}
local fakeplane = {model = '', car = nil}
local planeshop_locations = {
{entering = {-1025.038,-3017.475,12.845}, inside = {-977.644,-2990.122,13.945,60.000}, outside = {-977.644,-2990.122,13.945,60.000}},
}
local planeshop_blips ={}
local inrangeofplaneshop = false
local currentlocation = nil
local boughtplane = false
local plane_price = 0
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

function IsPlayerInRangeOfPlaneshop()
	return inrangeofplaneshop
end

function ShowPlaneshopBlips(bool)
	if bool and #planeshop_blips == 0 then
		for station,pos in pairs(planeshop_locations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			SetBlipSprite(blip,307)
			SetBlipColour(blip, 3)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Control Tower')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			table.insert(planeshop_blips, {blip = blip, pos = loc})
		end
		Citizen.CreateThread(function()
			while #planeshop_blips > 0 do
				Citizen.Wait(0)
				local inrange = false
				for i,b in ipairs(planeshop_blips) do
					DrawMarker(1,b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,200,0,0,0,0)
					if IsPlayerWantedLevelGreater(GetPlayerIndex(),0) == false and planeshop.opened == false and IsPedInAnyVehicle(LocalPed(), true) == false and  GetDistanceBetweenCoords(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],GetEntityCoords(LocalPed())) < 5 then
						drawTxt('Press ~g~Enter~s~ to access the purchase menu',0,1,0.5,0.8,0.6,255,255,255,255)
						currentlocation = b
						inrange = true
					end
				end
				inrangeofplaneshop = inrange
			end
		end)
	elseif bool == false and #planeshop_blips > 0 then
		for i,b in ipairs(planeshop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		planeshop_blips = {}
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
	boughtplane = false
	local ped = LocalPed()
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])
	planeshop.currentmenu = "main"
	planeshop.opened = true
	planeshop.selectedbutton = 0
end

function CloseCreator(name, plane, price)
	Citizen.CreateThread(function()
		local ped = LocalPed()
		if not boughtplane then
			local pos = currentlocation.pos.entering
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
		else
			local name = name
			local plane = plane
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
			personalplane = CreateVehicle(model,pos[1],pos[2],pos[3],pos[4],true,false)
			SetModelAsNoLongerNeeded(model)
			for i,mod in pairs(mods) do
				SetVehicleModKit(personalplane,0)
				SetVehicleMod(personalplane,i,mod)
			end
			SetVehicleOnGroundProperly(personalplane)
			local plate = GetVehicleNumberPlateText(personalplane)
			SetVehicleHasBeenOwnedByPlayer(personalplane,true)
			local id = NetworkGetNetworkIdFromEntity(personalplane)
			SetNetworkIdCanMigrate(id, true)
			Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalplane))
			SetVehicleColours(personalplane,colors[1],colors[2])
			SetVehicleExtraColours(personalplane,extra_colors[1],extra_colors[2])
			TaskWarpPedIntoVehicle(GetPlayerPed(-1),personalplane,-1)
			SetEntityVisible(ped,true)
			local primarycolor = colors[1]
			local secondarycolor = colors[2]	
			local pearlescentcolor = extra_colors[1]
			local wheelcolor = extra_colors[2]
			TriggerServerEvent('ply_hangars:BuyForPlane', name, plane, price, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
		end
		planeshop.opened = false
		planeshop.menu.from = 1
		planeshop.menu.to = 10
	end)
end

function drawMenuButton(button,x,y,selected)
	local menu = planeshop.menu
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
	local menu = planeshop.menu
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
	local menu = planeshop.menu
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
	local menu = planeshop.menu
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
		drawMenuRight("OWNED",planeshop.menu.x,y,selected)
	else
		drawMenuRight(button.costs.."$",planeshop.menu.x,y,selected)
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
	local this = planeshop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Civil" then
			OpenMenu('Civil')
		elseif btn == "Militaire" then
			OpenMenu('Militaire')
		end
	elseif this == "Civil" or this == "Militaire" then
		TriggerServerEvent('ply_hangars:CheckMoneyForPlane',button.name,button.model,button.costs)
	end
end

function OpenMenu(menu)
	fakeplane = {model = '', car = nil}
	planeshop.lastmenu = planeshop.currentmenu
	if menu == "Civil" then
		planeshop.lastmenu = "main"
	elseif menu == "Militaire"  then
		planeshop.lastmenu = "main"
	end
	planeshop.menu.from = 1
	planeshop.menu.to = 10
	planeshop.selectedbutton = 0
	planeshop.currentmenu = menu
end


function Back()
	if backlock then
		return
	end
	backlock = true
	if planeshop.currentmenu == "main" then
		CloseCreator()
	elseif planeshop.currentmenu == "Civil" or planeshop.currentmenu == "Militaire" then
		if DoesEntityExist(fakeplane.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakeplane.car))
		end
		fakeplane = {model = '', car = nil}
		OpenMenu(planeshop.lastmenu)
	else
		OpenMenu(planeshop.lastmenu)
	end

end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end



--[[Citizen]]--

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1,201) and IsPlayerInRangeOfPlaneshop() then
			if planeshop.opened then
				CloseCreator()
			else
				OpenCreator()
			end
		end
		if planeshop.opened then
			local ped = LocalPed()
			local menu = planeshop.menu[planeshop.currentmenu]
			drawTxt(planeshop.title,1,1,planeshop.menu.x,planeshop.menu.y,1.0, 255,255,255,255)
			drawMenuTitle(menu.title, planeshop.menu.x,planeshop.menu.y + 0.08)
			drawTxt(planeshop.selectedbutton.."/"..tablelength(menu.buttons),0,0,planeshop.menu.x + planeshop.menu.width/2 - 0.0385,planeshop.menu.y + 0.067,0.4, 255,255,255,255)
			local y = planeshop.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= planeshop.menu.from and i <= planeshop.menu.to then

					if i == planeshop.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,planeshop.menu.x,y,selected)
					if button.costs ~= nil then
						if planeshop.currentmenu == "Civil" or planeshop.currentmenu == "Militaire" then
							DoesPlayerHaveVehicle(button.model,button,y,selected)
						else
						drawMenuRight(button.costs.."$",planeshop.menu.x,y,selected)
						end
					end
					y = y + 0.04
					if planeshop.currentmenu == "Civil" or planeshop.currentmenu == "Militaire" then
						if selected then
							if fakeplane.model ~= button.model then
								if DoesEntityExist(fakeplane.car) then
									Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakeplane.car))
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
								fakeplane = { model = button.model, car = veh}
							end
						end
					end
					if selected and IsControlJustPressed(1,201) then
						ButtonSelected(button)
					end
				end
			end
		end
		if planeshop.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if planeshop.selectedbutton > 1 then
					planeshop.selectedbutton = planeshop.selectedbutton -1
					if buttoncount > 10 and planeshop.selectedbutton < planeshop.menu.from then
						planeshop.menu.from = planeshop.menu.from -1
						planeshop.menu.to = planeshop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if planeshop.selectedbutton < buttoncount then
					planeshop.selectedbutton = planeshop.selectedbutton +1
					if buttoncount > 10 and planeshop.selectedbutton > planeshop.menu.to then
						planeshop.menu.to = planeshop.menu.to + 1
						planeshop.menu.from = planeshop.menu.from + 1
					end
				end
			end
		end

	end
end)


--[[Events]]--


AddEventHandler('ply_hangars:FinishMoneyCheckForPlane', function(name, plane, price)
	local name = name
	local plane = plane
	local price = price
	boughtplane = true	
	CloseCreator(name, plane, price)
end)

AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		ShowPlaneshopBlips(true)
		firstspawn = 1
	end
end)