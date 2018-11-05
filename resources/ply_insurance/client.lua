--[[Register]]--

RegisterNetEvent("ply_insurance:getCars")
RegisterNetEvent("ply_insurance:addedInsurance")
RegisterNetEvent("ply_insurance:notEnoughMoney")
RegisterNetEvent("ply_insurance:backInGarage")

--[[Local/Global]]--

local plyPed = {
	{type=4, hash=0xc99f21c4, x=149.474, y=-1042.27, z=28.369, a=2374176, dir=337.71},
	{type=2, hash=0xc99f21c4, x=147.802, y=-1041.68, z=28.369, a=1375178, dir=337.71},
}

local insuranceLocation = {
	{ name="Insurance", color=25, id=171, x=149.929, y=-1040.43, z=28.374},
}

local options = {
	x = 0.1,
	y = 0.2,
	width = 0.2,
	height = 0.04,
	scale = 0.4,
	font = 0,
	menu_title = "PLY INSURANCE",
	menu_subtitle = "Insurance",
	color_r = 0,
	color_g = 20,
	color_b = 255,
}

insurancepercent = 0.35
carLoaded = false
CARS = {}
temp = true


--[[Functions]]--
--Menu

function insuranceMenu()
	ClearMenu()
	options.menu_title = options.menu_title
	Menu.addButton("Insure a car","addCarInsurance",nil)
	Menu.addButton("Insure a motorbike (SOON)","insuranceMenu",nil)
	Menu.addButton("Insure a boat (SOON)","insuranceMenu",nil)
	Menu.addButton("Insure a plane (SOON)","insuranceMenu",nil)
	Menu.addButton("Recover a vehicle","recover",nil)
	Menu.addButton("Close","CloseMenu",nil)
end

function addCarInsurance()
	options.menu_title = options.menu_title
	options.menu_subtitle = "CARS"
	ClearMenu()
	for i, v in pairs(CARS) do
		if v.insurance == "off" then
			local price = v.vehicle_price * insurancepercent
			local price = round(price, -2)
			Menu.addButton(v.vehicle_name.." : $"..price, "insure", {v.id,v.vehicle_name,price})
		end
	end
	Menu.addButton("Back","insuranceMenu",nil)
end

function insure(arg)
	local id = arg[1]
	local name = arg[2]
	local price = arg[3]
	TriggerServerEvent("ply_insurance:addInsurance",id,name,price)
	CloseMenu()
end

function recover()
	options.menu_title = options.menu_title
	options.menu_subtitle = "RECOVER"
	ClearMenu()
	for i, v in pairs(CARS) do
		if v.insurance == "on" and v.garage_id == 0 then
			Menu.addButton(v.vehicle_name, "recover2", {v.id,v.vehicle_name,v.instance})
		end
	end
	Menu.addButton("Back","insuranceMenu",nil)
end

function recover2(arg)
	local id = arg[1]
	local name = arg[2]
	local instance = arg[3]
	if DoesEntityExist(instance) then
		exports.pNotify:SendNotification({text = "Your "..name.." was found, look at the BlueCarMarker", type = "success", queue = "left", timeout = 5000, layout = "centerRight"})
		LostCarBlip = AddBlipForEntity(instance)
		SetBlipSprite(LostCarBlip, 225)
		SetBlipColour(LostCarBlip, 3)
		SetBlipAsMissionCreatorBlip(LostCarBlip,true)
		SetBlipRoute(LostCarBlip, true)
	else
		TriggerServerEvent("ply_insurance:recoverCars",arg[1],arg[2])
	end
end

function CloseMenu()
		Menu.hidden = true
end

--Base
function ShowInfo(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function round(num, numDecimalPlaces)
  if numDecimalPlaces and numDecimalPlaces>0 then
    local mult = 10^numDecimalPlaces
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end


--[[Citizen]]--

Citizen.CreateThread(function()
	RequestModel(GetHashKey("a_m_y_business_01"))
	while not HasModelLoaded(GetHashKey("a_m_y_business_01")) do
		Wait(1)
	end
	RequestAnimDict("mini@strip_club@idles@dj@idle_03")
		while not HasAnimDictLoaded("mini@strip_club@idles@dj@idle_03") do
	Wait(1)
	end
	-- Spawn the DMV Ped
	for _, item in pairs(plyPed) do
		plyMainPed =  CreatePed(item.type, item.hash, item.x, item.y, item.z, item.a, false, true)
		SetEntityHeading(plyMainPed, item.dir)
		FreezeEntityPosition(plyMainPed, true)
		SetEntityInvincible(plyMainPed, true)
		SetBlockingOfNonTemporaryEvents(plyMainPed, true)
		TaskPlayAnim(plyMainPed,"mini@strip_club@idles@bouncer@idle_03","idle_03", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if temp then
			for _, item in pairs(insuranceLocation) do
				item.blip = AddBlipForCoord(item.x, item.y, item.z)
				SetBlipSprite(item.blip, item.id)
				SetBlipAsShortRange(item.blip, true)
				SetBlipColour(item.blip, item.color)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(item.name)
				EndTextCommandSetBlipName(item.blip)
			end
			temp = false
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, v in pairs(insuranceLocation) do
			DrawMarker(1, v.x, v.y, v.z,0,0,0,0,0,0,1.001,1.0001,1.0001,51,255,102,255,0,0,0,0)
			if GetDistanceBetweenCoords(v.x, v.y, v.z,GetEntityCoords(GetPlayerPed(-1))) < 1 and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
				ShowInfo("~INPUT_VEH_HORN~ to interact with ~g~NPC~s~", 0)
				if IsControlJustPressed(1, 86) then
					insuranceMenu()
					Menu.hidden = not Menu.hidden
				end
				Menu.renderGUI(options)
			end
		end
	end
end)

--[[Events]]--


AddEventHandler("ply_insurance:getCars", function(THECARS)
	carLoaded = false
	CARS = {}
	CARS = THECARS
	carLoaded = true
end)

AddEventHandler('ply_insurance:addedInsurance', function(name)
	exports.pNotify:SendNotification({text = "Your "..name.." was insured, Thank you", type = "success", queue = "left", timeout = 2000, layout = "centerRight"})
	Menu.hidden = true
	TriggerServerEvent("ply_basemod:getPlayerVehicle")
end)

AddEventHandler('ply_insurance:notEnoughMoney', function()
	exports.pNotify:SendNotification({text = "You do not have enough money", type = "error", queue = "left", timeout = 2000, layout = "centerRight"})
end)

AddEventHandler('ply_insurance:backInGarage', function()
	exports.pNotify:SendNotification({text = "Your "..name.." was sent in the public garage", type = "success", queue = "left", timeout = 2000, layout = "centerRight"})
end)