--[[Register]]--

RegisterNetEvent('ply_stores:getAllDrink')
RegisterNetEvent('ply_stores:getAllFood')
RegisterNetEvent('ply_stores:getAllStuff')
RegisterNetEvent('ply_stores:getPlayerBackPackSize')
RegisterNetEvent('ply_stores:buyTrue')
RegisterNetEvent('ply_stores:buyFalseNoMoney')
RegisterNetEvent('ply_stores:getsItems')




--[[Local/Global]]--

local shops = {
	{ name="Grocery Store", color=25, id=52, x=1961.720, y=3740.500, z=31.343},
	{ name="Grocery Store", color=25, id=52, x=1165.980, y=2709.070, z=37.157},
	{ name="Grocery Store", color=25, id=52, x=547.347, y=2671.480, z=41.156},
	{ name="Grocery Store", color=25, id=52, x=2557.700, y=382.527, z=107.622},
	{ name="Grocery Store", color=25, id=52, x=-1820.620, y=792.252, z=137.139},
	{ name="Grocery Store", color=25, id=52, x=-1223.110, y=-906.713, z=11.326},
	{ name="Grocery Store", color=25, id=52, x=-707.769, y=-914.753, z=18.215},
	{ name="Grocery Store", color=25, id=52, x=26.232, y=-1347.850, z=28.497},
	{ name="Grocery Store", color=25, id=52, x=1136.300, y=-982.219, z=45.4158},
	{ name="Grocery Store", color=25, id=52, x=-48.737, y=-1757.61, z=28.421},
	{ name="Grocery Store", color=25, id=52, x=-1487.99, y=-379.045, z=39.1634},
	{ name="Grocery Store", color=25, id=52, x=373.963, y=325.589, z=102.566},
	{ name="Grocery Store", color=25, id=52, x=2679.170, y=3280.55, z=54.2412},
	{ name="Grocery Store", color=25, id=52, x=-2968.320, y=391.641, z=14.043},
	{ name="Grocery Store", color=25, id=52, x=1729.160, y=6414.200, z=34.037},
	{ name="Grocery Store", color=25, id=52, x=1391.930, y=3604.57, z=33.980},
	{ name="Grocery Store", color=25, id=52, x=-3241.770, y=1001.570, z=11.830},
	{ name="Grocery Store", color=25, id=52, x=-3039.110, y=586.209, z=6.908},
	{ name="Grocery Store", color=25, id=52, x=1163.340, y=-323.923, z=68.205},
}

FOOD = {}
DRINK = {}
STUFF = {}
BACKPACKSIZE = nil
SITEMS = {}

local showfoodmenu = true



--[[Functions]]--
--menu
function MenuGrocery()
	ped = GetPlayerPed(-1);
	MenuTitle = "Grocery Store"
	ClearMenu()
	--Menu.addButton("Drink","drink",nil)
	--Menu.addButton("Food","food",nil)
	Menu.addButton("Stuff","stuff",nil)
	Menu.addButton("Close","CloseMenu",nil)
end

function drink()
	ped = GetPlayerPed(-1);
	MenuTitle = "Drink"
	ClearMenu()
	for i, v in pairs(DRINK) do
			Menu.addButton(tostring(v.name).. " : "..tostring(v.price).."$", "buyStuff", {v.id,v.name,v.weight,v.price})
	end
	Menu.addButton("Retour","MenuGrocery",nil)
end

function food()
	ped = GetPlayerPed(-1);
	MenuTitle = "Food"
	ClearMenu()
	for i, v in pairs(FOOD) do
			Menu.addButton(tostring(v.name).. " : "..tostring(v.price).."$", "buyStuff", {v.id,v.name,v.weight,v.price})
	end
	Menu.addButton("Retour","MenuGrocery",nil)
end

function stuff()
	ped = GetPlayerPed(-1);
	MenuTitle = "Stuff"
	ClearMenu()
	for i, v in pairs(STUFF) do
			Menu.addButton(tostring(v.name).. " : "..tostring(v.price).."$", "buyStuff", {v.id,v.name,v.weight,v.price})
	end
	Menu.addButton("Retour","MenuGrocery",nil)
end

function buyStuff(arg)
	local id = arg[1]
	local name = arg[2]
	local weight = arg[3]
	local price = arg[4]
	local playerBackPackWeightLeft = BACKPACKSIZE - getPlayerBackPackWeightTotal()
	if (playerBackPackWeightLeft >= weight) then
		TriggerServerEvent('ply_stores:buyStuff',id,name,weight,price)
	else
		exports.pNotify:SendNotification({text = "There is no room left", type = "warning", queue = "left", timeout = 3000, layout = "centerRight"})
	end
end

function CloseMenu()
	Menu.hidden = true
end


--other
function ShowInfo(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function getPlayerBackPackWeightTotal()
	local sum = 0
	if SITEMS ~= nil then
		for _, v in pairs(SITEMS) do
			sum = sum + (v.weight * v.quantity)
		end
	end
	return sum
end

--[[Citizen]]--

Citizen.CreateThread(function()
	for _, item in pairs(shops) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipAsShortRange(item.blip, true)
		SetBlipColour(item.blip, item.color)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(item.name)
		EndTextCommandSetBlipName(item.blip)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, v in pairs(shops) do
			DrawMarker(1, v.x, v.y, v.z,0,0,0,0,0,0,1.001,1.0001,1.0001,51,255,102,255,0,0,0,0)
			if GetDistanceBetweenCoords(v.x, v.y, v.z,GetEntityCoords(GetPlayerPed(-1))) < 1 and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
				ShowInfo("~INPUT_VEH_HORN~ to open ~g~menu~s~", 0)
				if IsControlJustPressed(1, 86) then
					MenuGrocery()
					Menu.hidden = not Menu.hidden
				end
				Menu.renderGUI()
			end
		end
	end
end)



--[[Events]]--

AddEventHandler("ply_stores:getAllDrink", function(THEDRINK)
	DRINK = {}
	DRINK = THEDRINK
end)

AddEventHandler("ply_stores:getAllFood", function(THEFOOD)
	FOOD = {}
	FOOD = THEFOOD
end)

AddEventHandler("ply_stores:getAllStuff", function(THESTUFF)
	STUFF = {}
	STUFF = THESTUFF
end)

AddEventHandler("ply_stores:getPlayerBackPackSize", function(THEBACKPACKSIZE)
	BACKPACKSIZE = THEBACKPACKSIZE
end)

AddEventHandler("ply_stores:getsItems", function(THESITEMS)
	SITEMS = {}
	SITEMS = THESITEMS
end)

AddEventHandler('ply_stores:buyTrue', function(item_name, item_quantity)
	exports.pNotify:SendNotification({text = item_name.." bought\nTotal: "..item_quantity, type = "success", queue = "left", timeout = 3000, layout = "centerRight"})
	TriggerServerEvent("ply_basemod:getPlayerInventory")
end)

AddEventHandler('ply_stores:buyFalseNoMoney', function()
	exports.pNotify:SendNotification({text = 'You do not have enough money', type = "error", queue = "left", timeout = 3000, layout = "centerRight"})
end)