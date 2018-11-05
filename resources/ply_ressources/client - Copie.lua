--[[Register]]--

RegisterNetEvent("ply_ressources:getPlayerBackPackSize")
RegisterNetEvent("ply_ressources:getrItems")
RegisterNetEvent("ply_ressources:itemAdded")
RegisterNetEvent("ply_ressources:noItemtoTreat")
RegisterNetEvent("ply_ressources:noItemtoSell")
RegisterNetEvent("ply_ressources:itemSold")
RegisterNetEvent("ply_ressources:notEnoughItemtoTreat")


--[[Local/Global]]--

BACKPACKSIZE = nil
RITEMS = {}


harvestSelected = {{x=nil, y=nil, z=nil}}
treatmentSelected = {{x=nil, y=nil, z=nil}}
sellSelected = {{x=nil, y=nil, z=nil}}

local ressources = {
	Canabis = {
		harvest = {name = "Canabis foot",x=2221.536,y=5576.860,z=53.822,time=2000,weight=600,hide=true},
		treatment = {name = "Canabis heads",colour=2,id=1,x=2193.599,y=5595.099,z=53.761,time=2000,weight=600,ratio=15,pre_item="Canabis foot",hide=true},
		sell = {colour=2,id=1,x=2221.896,y=5612.985,z=55.007,price=20,time=2000,pre_item="Canabis heads",hide=true}
	},
	Coca = {
		harvest = {name = "Coca foot",colour=2,id=1,x=3300.47,y=5170.82,z=18.685,time=500,weight=600,hide=true},
		treatment = {name = "Coca leaves",colour=2,id=1,x=3308.29,y=5194.64,z=18.416,time=500,weight=10,pre_item="Coca foot",hide=true},
		sell = {colour=2,id=1,x=3304.45,y=5184.8,z=19.711,price=20,time=500,pre_item="Coca leaves",hide=true}
	},
	Orange1={
		harvest={bname="Harvest of oranges",name="Orange",x=2003.19,y=4787.08,z=41.799,time=2000,weight=600,hide=false},
		treatment={bname="Manufacturing of orange juice",name="Orange juice",colour=47,id=1,x=1978.54,y=5171.68,z=46.639,time=2000,weight=10,pre_item="Orange",hide=false},
		sell={bname="Sale of orange juice",name="Orange juice",colour=47,id=1,x=2240.45,y=5159.58,z=56.83,price=20,time=2000,pre_item="Orange juice",hide=false}},
	Orange2={harvest={bname="Harvest of oranges",name="Orange",x=3300.47,y=5170.82,z=18.68,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange3={harvest={bname="Harvest of oranges",name="Orange",x=1982.10,y=4772.33,z=41.92,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange4={harvest={bname="Harvest of oranges",name="Orange",x=2015.01,y=4800.67,z=41.93,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange5={harvest={bname="Harvest of oranges",name="Orange",x=2030.71,y=4801.71,z=41.90,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange6={harvest={bname="Harvest of oranges",name="Orange",x=2059.86,y=4842.35,z=41.83,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange7={harvest={bname="Harvest of oranges",name="Orange",x=1908.75,y=5070.85,z=46.38,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange8={harvest={bname="Harvest of oranges",name="Orange",x=1893.70,y=5057.78,z=48.79,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange9={harvest={bname="Harvest of oranges",name="Orange",x=1854.29,y=5023.68,z=53.74,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange10={harvest={bname="Harvest of oranges",name="Orange",x=1838.87,y=5039.85,z=57.49,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange11={harvest={bname="Harvest of oranges",name="Orange",x=2064.43,y=4820.21,z=41.84,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange12={harvest={bname="Harvest of oranges",name="Orange",x=2085.74,y=4825.50,z=41.59,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange13={harvest={bname="Harvest of oranges",name="Orange",x=2083.01,y=4853.63,z=41.86,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange14={harvest={bname="Harvest of oranges",name="Orange",x=2097.87,y=4841.30,z=41.67,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange15={harvest={bname="Harvest of oranges",name="Orange",x=2117.65,y=4842.53,z=41.56,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange16={harvest={bname="Harvest of oranges",name="Orange",x=2122.44,y=4861.17,z=41.10,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange17={harvest={bname="Harvest of oranges",name="Orange",x=2145.86,y=4867.03,z=40.69,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange18={harvest={bname="Harvest of oranges",name="Orange",x=2122.96,y=4883.39,z=40.91,time=2000,weight=600,hide=false},treatment={},sell={}},
	Orange19={harvest={bname="Harvest of oranges",name="Orange",x=2101.70,y=4878.13,z=41.08,time=2000,weight=600,hide=false},treatment={},sell={}},
}


--[[Functions]]--

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function LocalPed()
	return GetPlayerPed(-1)
end

function Chat(debugg)
    TriggerEvent("chatMessage", '', { 0, 0x99, 255 }, tostring(debugg))
end

function ShowInfo(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function harvestItem(playerBackPackWeight,name,weight,time)
	Wait(time)
	if harvestState then
		local playerBackPackWieghtLeft = playerBackPackWeight - getPlayerBackPackWeightTotal()
		if (playerBackPackWieghtLeft - weight) > weight then
			TriggerServerEvent("ply_ressources:addHarvestToPlayer",name)
			TriggerServerEvent("ply_menupersonnel:getItems")
			harvestItem(playerBackPackWeight,name,weight,time)
		else
			drawNotification("There is no room left")
			harvestState = false
		end
	end
end

function treatmentItem(name,time,previousItem)
	Wait(time)
	if treatmentState then
		TriggerServerEvent("ply_ressources:addTreatToPlayer",name,previousItem)
		TriggerServerEvent("ply_menupersonnel:getItems")
		treatmentItem(name,time,previousItem)
	end
end

function sellItem(name,time)
	Wait(time)
	if sellState then
		TriggerServerEvent("ply_ressources:sellItemFromPlayer",name)
		TriggerServerEvent("ply_menupersonnel:getItems")
		sellItem(name,time)
	end
end

function getPlayerBackPackWeightTotal()
	local sum = 0
	if RITEMS then
		for _, v in pairs(RITEMS) do
			sum = sum + (v.weight * v.quantity)
		end
	end	
	return sum
end

--[[Citizen]]--


--récolte--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, res in pairs(ressources) do
			--if res.harvest.hide == false then
			--	DrawMarker(1, res.harvest.x, res.harvest.y, res.harvest.z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
			--end
			if GetDistanceBetweenCoords(res.harvest.x, res.harvest.y, res.harvest.z, GetEntityCoords(LocalPed())) < 2 and IsPedInAnyVehicle(LocalPed(), true) == false then
				ShowInfo("~INPUT_VEH_HORN~ to harverst", 0)
				if IsControlJustPressed(1, 86) then
					harvestState = true
            		TriggerServerEvent("ply_menupersonnel:getItems")
            		BACKPACKSIZE = 29000
					name = res.harvest.name
					time = res.harvest.time
					weight = res.harvest.weight
					harvestSelected.x = res.harvest.x
					harvestSelected.y = res.harvest.y
					harvestSelected.z = res.harvest.z
					drawNotification(name..": harvesting...")
					harvestItem(BACKPACKSIZE,name,weight,time)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, res in pairs(ressources) do
			if GetDistanceBetweenCoords(harvestSelected.x, harvestSelected.y, harvestSelected.z, GetEntityCoords(LocalPed())) > 2 then
				if harvestState then			
				harvestState = false
				drawNotification("Harvest canceled")
				end
			end
		end
	end
end)




--traitement--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, res in pairs(ressources) do
			if res.treatment.hide == false then
				DrawMarker(1, res.treatment.x, res.treatment.y, res.treatment.z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
			end
			if GetDistanceBetweenCoords(res.treatment.x, res.treatment.y, res.treatment.z, GetEntityCoords(LocalPed())) < 1 and IsPedInAnyVehicle(LocalPed(), true) == false then
				ShowInfo("~INPUT_VEH_HORN~ to treat", 0)
				if IsControlJustPressed(1, 86) then
					treatmentState = true
            		TriggerServerEvent("ply_menupersonnel:getItems")
					name = res.treatment.name
					time = res.treatment.time
					treatmentSelected.x = res.treatment.x
					treatmentSelected.y = res.treatment.y
					treatmentSelected.z = res.treatment.z
					previousItem = res.treatment.pre_item
					drawNotification(name..": treatment...")
					treatmentItem(name,time,previousItem)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, res in pairs(ressources) do
			if GetDistanceBetweenCoords(treatmentSelected.x, treatmentSelected.y, treatmentSelected.z, GetEntityCoords(LocalPed())) > 2 then
				if treatmentState then			
				treatmentState = false
				drawNotification("Treatment canceled")
				end
			end
		end
	end
end)

--vente-- 
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, res in pairs(ressources) do
			if res.sell.hide == false then
				DrawMarker(1, res.sell.x, res.sell.y, res.sell.z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
			end
			if GetDistanceBetweenCoords(res.sell.x, res.sell.y, res.sell.z, GetEntityCoords(LocalPed())) < 1 and IsPedInAnyVehicle(LocalPed(), true) == false then
				ShowInfo("~INPUT_VEH_HORN~ to sell", 0)
				if IsControlJustPressed(1, 86) then
					sellState = true
            		TriggerServerEvent("ply_menupersonnel:getItems")
					name = res.sell.pre_item
					time = res.sell.time
					sellSelected.x = res.sell.x
					sellSelected.y = res.sell.y
					sellSelected.z = res.sell.z
					drawNotification(name..": sale...")
					sellItem(name,time)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, res in pairs(ressources) do
			if GetDistanceBetweenCoords(sellSelected.x, sellSelected.y, sellSelected.z, GetEntityCoords(LocalPed())) > 2 then
				if sellState then
				sellState = false
				drawNotification("Sale canceled")
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	for _, resb in pairs(ressources) do
		if resb.treatment.hide == false then
			resb.blip = AddBlipForCoord(resb.treatment.x, resb.treatment.y, resb.treatment.z)
			SetBlipSprite(resb.blip, resb.treatment.id)
			SetBlipAsShortRange(resb.blip, true)
			SetBlipColour(resb.blip, resb.treatment.colour)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(resb.treatment.bname)
			EndTextCommandSetBlipName(resb.blip)
		end
	end
end)

Citizen.CreateThread(function()
	for _, resb in pairs(ressources) do
		if resb.sell.hide == false then
			resb.blip = AddBlipForCoord(resb.sell.x, resb.sell.y, resb.sell.z)
			SetBlipSprite(resb.blip, resb.sell.id)
			SetBlipAsShortRange(resb.blip, true)
			SetBlipColour(resb.blip, resb.sell.colour)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(resb.sell.bname)
			EndTextCommandSetBlipName(resb.blip)
		end
	end
end)




--[[Events]]--

AddEventHandler("playerSpawned", function()
	TriggerServerEvent("ply_ressources:getPlayerBackPackSize")
end)

AddEventHandler("ply_ressources:getPlayerBackPackSize", function(THEBACKPACKSIZE)
    BACKPACKSIZE = THEBACKPACKSIZE
end)

AddEventHandler("ply_ressources:getrItems", function(PITEMS)
    RITEMS = PITEMS
end)

AddEventHandler('ply_ressources:itemAdded', function(ressource,total)
	drawNotification(ressource.." has been added\nTotal: "..total)
end)

AddEventHandler('ply_ressources:noItemtoTreat', function()
	drawNotification("There is nothing to treat")	
	treatmentState = false
end)

AddEventHandler('ply_ressources:noItemtoSell', function()
	drawNotification("There is nothing to sell")	
	sellState = false
end)

AddEventHandler('ply_ressources:itemSold', function(ressource,total)
	drawNotification(ressource.." has been sold\nRemains: "..total)
end)

AddEventHandler('ply_ressources:notEnoughItemtoTreat', function(name1,name2,quantity,ratio,prequanity)
	drawNotification("Lack of "..name2.."\nIt takes "..quantity.." for "..ratio.." "..name1.."\nand you have only "..prequanity)	
	treatmentState = false
end)
