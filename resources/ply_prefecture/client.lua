--[[Register]]--

RegisterNetEvent("ply_prefecture:GetLicences")
RegisterNetEvent("ply_prefecture:CheckForRealVeh")
RegisterNetEvent("ply_prefecture:VehRegistered")
RegisterNetEvent("ply_prefecture:LicenseFalse")
RegisterNetEvent("ply_prefecture:LicenseTrue")


--[[Local/Global]]--

LICENCES = {}
local prefecture_location = {173.100, -446.234, 40.081}
local prefecture = {title = "Prefecture", currentpos = nil, marker = { r = 0, g = 155, b = 255, a = 200, type = 1 }}

local options = {
	x = 0.1,
	y = 0.2,
	width = 0.2,
	height = 0.04,
	scale = 0.4,
	font = 0,
	menu_title = "PREFECTURE",
	menu_subtitle = "Options",
	color_r = 0,
	color_g = 20,
	color_b = 255,
}


--[[Functions]]--

function configLang(lang)
	local lang = lang
	if lang == "FR" then
		lang_string = {
			menu1 = "Acheter un permis",
			menu2 = "Enregistrer un véhicule",
			menu3 = "Fermer",
			menu4 = "Permis",
			menu5 = "Retour",
			menu10 = "~g~E~s~ pour ouvrir le menu",
			text1 = "Ce n'est pas la bon vehicule",
			text2 = "Aucun véhicule présent",
			text3 = "Vehicule enregistré",
			text4 = "Ce permis est déjà acheté",
			text5 = "Permis acheté"
	}

	elseif lang == "EN" then
		lang_string = {
			menu1 = "Buy a license",
			menu2 = "Register a vehicle",
			menu3 = "Close",
			menu4 = "Licences",
			menu5 = "Back",
			menu10 = "~g~E~s~ to open menu",
			text1 = "This is not the right vehicle",
			text2 = "No vehicles present",
			text3 = "Vehicle registered",
			text4 = "This licence is already purchased",
			text5 = "Licence purchased"
	}
	end
end

function MenuPrefecture()
	ClearMenu()
	options.menu_title = options.menu_title
	--Menu.addButton("Buy a licence","AcheterPermis",nil)
	Menu.addButton("Register a vehicle","EnregistrerVehicule",nil)
	Menu.addButton("Close","CloseMenu",nil)
end

function EnregistrerVehicule()
	TriggerServerEvent('ply_prefecture:CheckForVeh',source)
	CloseMenu()
end

function AcheterPermis()
	options.menu_title = options.menu_title
	options.menu_subtitle = "LICENCES"
	ClearMenu()
	for ind, value in pairs(LICENCES) do
		Menu.addButton(tostring(value.name) .. " : " .. tostring(value.price), "OptionPermis", value.id)
	end
	Menu.addButton("Back","MenuPrefecture",nil)
end

function OptionPermis(licID)
	local licID = licID
	TriggerServerEvent("ply_prefecture:CheckForLicences", licID)
	CloseMenu()
end

function CloseMenu()
	Menu.hidden = true
	TriggerServerEvent("ply_prefecture:GetLicences")
end

function ShowInfo(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function drawNotification(text)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(text)
  DrawNotification(false, false)
end


--[[Events]]--

AddEventHandler("playerSpawned", function()
	local lang = "FR"
	TriggerServerEvent("ply_prefecture:GetLicences")
	--TriggerServerEvent("ply_prefecture:Lang", lang)
	--configLang(lang)
end)

AddEventHandler("ply_prefecture:GetLicences", function(THELICENCES)
	LICENCES = {}
	LICENCES = THELICENCES
end)


AddEventHandler("ply_prefecture:CheckForRealVeh", function(personalvehicle)
	Citizen.CreateThread(function()
		checkvname1 = true
		checkvname2 = true
		local brutmodel = personalvehicle
		local personalvehicle = string.lower(personalvehicle)
		local caisse = GetClosestVehicle(prefecture_location[1],prefecture_location[2],prefecture_location[3], 5.000, 0, 70)
		SetEntityAsMissionEntity(caisse, true, true)
		if DoesEntityExist(caisse) then
			local vname = GetDisplayNameFromVehicleModel(GetEntityModel(caisse))
			local vname1 = GetLabelText(vname)
			local vname1 = string.lower(vname1)
			local vname1 = vname1:gsub("%s+", "")
			local vname1 = vname1.gsub(vname1, "%s+", "")

			local vname2 = string.lower(vname)
			local vname2 = vname2:gsub("%s+", "")
			local vname2 = vname2.gsub(vname2, "%s+", "")
			print(vname)
			print(vname1)
			print(vname2)
			if personalvehicle ~= vname1 then
				checkvname1 = false
			end
			if vname2 == "cogcabri" then
				vname2 = "cogcabrio"
			end
			if vname2 == "oracle" then
				vname2 = "oracle2"
			end
			if vname2 == "buffalo02" then
				vname2 = "buffalo2"
			end
			if personalvehicle ~= vname2 then
				checkvname2 = false
			end
			if checkvname1 == false and checkvname2 == false then
				exports.pNotify:SendNotification({text = "It's not your vehicle", type = "error", queue = "left", timeout = 3000, layout = "centerRight"})
			else
				local name = personalvehicle
				local plate = GetVehicleNumberPlateText(caisse)

				TriggerServerEvent('ply_prefecture:SetLicenceForVeh', name, brutmodel, plate, caisse)
			end
		else
			exports.pNotify:SendNotification({text = "No vehicles present", type = "error", queue = "left", timeout = 3000, layout = "centerRight"})
		end
	end)
end)

AddEventHandler("ply_prefecture:VehRegistered", function()
	exports.pNotify:SendNotification({text = "Vehicle registered, Now go get some insurance!", type = "success", queue = "left", timeout = 4000, layout = "centerRight"})
	TriggerServerEvent("ply_basemod:getPlayerVehicle")
end)

AddEventHandler("ply_prefecture:LicenseFalse", function()
	exports.pNotify:SendNotification({text = "This licence is already purchased", type = "error", queue = "left", timeout = 3000, layout = "centerRight"})

end)

AddEventHandler("ply_prefecture:LicenseTrue", function()
	exports.pNotify:SendNotification({text = "Licence purchased", type = "success", queue = "left", timeout = 3000, layout = "centerRight"})
end)



--[[Citizen]]--

Citizen.CreateThread(function()
	local loc = prefecture_location
	pos = prefecture_location
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,267)
	SetBlipColour(blip,1)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Prefecture')
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
	while true do
		Wait(0)
		DrawMarker(1,prefecture_location[1],prefecture_location[2],prefecture_location[3],0,0,0,0,0,0,4.001,4.0001,0.5001,0,155,255,200,0,0,0,0)
		if GetDistanceBetweenCoords(prefecture_location[1],prefecture_location[2],prefecture_location[3],GetEntityCoords(GetPlayerPed(-1))) < 5 and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
			ShowInfo("~INPUT_VEH_HORN~ to open ~g~Menu~s~", 0)
			if IsControlJustPressed(1, 86) then
				MenuPrefecture()
				Menu.hidden = not Menu.hidden
			end
			Menu.renderGUI(options)
		end
	end
end)