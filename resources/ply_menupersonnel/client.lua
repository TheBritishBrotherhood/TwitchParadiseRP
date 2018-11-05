--[[Register]]--


RegisterNetEvent("ply_menupersonnel:getItems")
RegisterNetEvent("ply_menupersonnel:updateQuantity")
RegisterNetEvent("ply_menupersonnel:repairKit")
RegisterNetEvent("ply_menupersonnel:lockPick")

--phone
RegisterNetEvent('ply_menupersonnel:unreaded')
RegisterNetEvent('ply_menupersonnel:nbMsgUnreaded')
RegisterNetEvent('ply_menupersonnel:setSteamId')
RegisterNetEvent("ply_menupersonnel:repertoryGetNumberListFromServer")
RegisterNetEvent("ply_menupersonnel:messageryGetOldMsgFromServer")
RegisterNetEvent('ply_menupersonnel:notifsNewMsg')
RegisterNetEvent('ply_menupersonnel:readMsg')
RegisterNetEvent('ply_menupersonnel:deleteUnreaded')
RegisterNetEvent('ply_menupersonnel:closeMsg')
RegisterNetEvent("ply_menupersonnel:notifs")
RegisterNetEvent('ply_menupersonnel:getPhoneNumberOnLoaded')


--[[Local/Global]]--

ITEMS = {}

--phone
local options = {
	x = 0.12,
	y = 0.2,
	width = 0.22,
	height = 0.04,
	scale = 0.4,
	font = 0,
	menu_title = 'Phone',
	menu_subtitle = 'Actions',
	color_r = 192,
	color_g = 57,
	color_b = 43,
}

local openKey = 289
local current_steam_id = ''
local phone_number = ''

NUMBERS_LIST = {}
OLDS_MSG = {}



--[[Functions]]--

function LocalPed()
	return GetPlayerPed(-1)
end

function MenuPersonnel() -- Menu Général
	MenuTitle = "Menu"
	ClearMenu()
	Menu.addButton("Animations","AnimationsMenu",nil) -- Animations - pas fait
	Menu.addButton("Inventory","InventoryMenu",nil) -- Inventaire
--	Menu.addButton("Phone","phoneMenu",nil) -- Téléphone- pas fait
	Menu.addButton("Close","CloseMenu",nil) -- Fermer le menu
end

function AnimationsMenu() -- Menu Animations
	MenuTitle = "Animations"
	ClearMenu()
	Menu.addButton("Applaud","Anim1Menu",nil)
	Menu.addButton("To take a picture","Anim2Menu",nil)
	Menu.addButton("Play music","Anim3Menu",nil)
	Menu.addButton("View on map","Anim4Menu",nil)
	--Menu.addButton("Faire du Yoga","Anim5Menu",nil)
	--Menu.addButton("Faire des pompes","Anim6Menu",nil)
	Menu.addButton("Back","MenuPersonnel",nil) -- Retour au Menu Général
end

function Anim1Menu()
	Citizen.CreateThread(function()
	TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CHEERING", 0, 1)
	PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
	Citizen.Wait(5000)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	end)
end

function Anim2Menu()
	Citizen.CreateThread(function()
		TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_MOBILE_FILM_SHOCKING", 0, 1)
		PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
		Citizen.Wait(5000)
		ClearPedTasksImmediately(GetPlayerPed(-1))
	end)
end

function Anim3Menu()
	Citizen.CreateThread(function()
		TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_MUSICIAN", 0, 1)
		PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
		Citizen.Wait(5000)
		ClearPedTasksImmediately(GetPlayerPed(-1))
	end)
end

function Anim4Menu()
	Citizen.CreateThread(function()
		TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_TOURIST_MAP", 0, 1)
		PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
		Citizen.Wait(5000)
		ClearPedTasksImmediately(GetPlayerPed(-1))
	end)
end

function Anim5menu()
	Citizen.CreateThread(function()
		TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_YOGA", 0, 1)
		PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
		Citizen.Wait(5000)
		ClearPedTasksImmediately(GetPlayerPed(-1))
	end)
end

function Anim6menu()
	Citizen.CreateThread(function()
		TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_PUSH_UPS", 0, 1)
		PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
		Citizen.Wait(5000)
		ClearPedTasksImmediately(GetPlayerPed(-1))
	end)
end

function InventoryMenu() -- Menu Inventaire
	MenuTitle = "Items"
	ClearMenu()
	for ind, value in pairs(ITEMS) do
		if (value.quantity >= 1) then
			Menu.addButton(tostring(value.name) .. " : " .. tostring(value.quantity), "ItemMenu", ind) -- Menu option pour chaque objet
		end
	end
	Menu.addButton("Back","MenuPersonnel",nil) -- Retour au Menu Général
end

function ItemMenu(itemId) -- Menu option pour chaque objet
	MenuTitle = "Options"
	ClearMenu()
	Menu.addButton("Use", "use", { itemId, 1 }) -- Ajoute une quantité de 1, sera remplacé plus tard par "utiliser/consommer"
	Menu.addButton("Delete 1", "delete", { itemId, 1 }) -- Supprime une quantité de 1
	Menu.addButton("Back", "InventoryMenu", nil) -- Retour à l'inventaire
end

function delete(arg) -- Fonction supprimer
	local itemId = tonumber(arg[1])
	local qty = arg[2]
	local item = ITEMS[itemId]
	item.quantity = item.quantity - qty
	TriggerServerEvent("ply_menupersonnel:updateQuantity", item.quantity, itemId)
	TriggerServerEvent("ply_basemod:getPlayerInventory")
	InventoryMenu()
end

function use(arg)
	local itemId = tonumber(arg[1])
	local qty = arg[2]
	local item = ITEMS[itemId]
	item.quantity = item.quantity - qty
	TriggerServerEvent("ply_menupersonnel:useItem", itemId, ITEMS[itemId])
	TriggerServerEvent("ply_basemod:getPlayerInventory")
	InventoryMenu()
end

function CloseMenu() -- Fonction fermer le menu
	Menu.hidden = true
end

function Chat(debugg)
	TriggerEvent("chatMessage", '', { 0, 0x99, 255 }, tostring(debugg))
end

function lockpick()
	Citizen.CreateThread(function()
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, 0)
		veh = GetClosestVehicle(plyCoords["x"], plyCoords["y"], plyCoords["z"], 5.001, 0, 70)
		TaskPlayAnim(GetPlayerPed(-1),"mini@repair","fixing_a_player", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
		StartVehicleAlarm(vehicle)
		StartVehicleAlarm(veh)
		Citizen.Wait(20000)
		SetVehicleDoorsLocked(veh, 1)
		ClearPedTasksImmediately(GetPlayerPed(-1))
		DrawMissionText("~y~You unlocked the vehicle", 15000)
	end)
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

--phone
function drawTxt(options)
	SetTextFont(options.font)
	SetTextProportional(0)
	SetTextScale(options.scale, options.scale)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry('STRING')
	AddTextComponentString(options.text)
	DrawRect(options.xBox,options.y,options.width,options.height,0,0,0,150)
	DrawText(options.x - options.width/2 + 0.005, options.y - options.height/2 + 0.0028)
end

function DisplayHelpText(str)
	SetTextComponentFormat('STRING')
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function notifs(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString( msg )
	DrawNotification(false, false)
end

function phoneMenu()
	TriggerServerEvent("ply_basemod:repertoryGetNumberList")
	MenuTitle = phone_number
	ClearMenu()
	if not IsEntityDead(GetPlayerPed(-1)) then
		Menu.addButton("Phonebook", "repertoryMenu", nil)
		Menu.addButton("Messaging", "messageryMenu", nil)
	end
	Menu.addButton("Services", "publicMenu", nil)
	if not IsEntityDead(GetPlayerPed(-1)) then
		Menu.addButton("Empty memory", "cleanMemoryMenu", nil)
	end
	Menu.addButton("Storing the phone", "closePhone", nil)
end

function closePhone()
	ClearMenu()
	MenuPersonnel()
end

function repertoryMenu()
	MenuTitle = "Phonebook"
	ClearMenu()
	Menu.addButton("Add a number", "newNumero", nil )
	for ind, value in pairs(NUMBERS_LIST) do
		Menu.addButton(tostring(value.nom), "repertoryContact", tostring(value.identifier))
	end
	Menu.addButton("Back", "phoneMenu", nil )
end

function newNumero()
	DisplayOnscreenKeyboard(2, "FMMC_KEY_TIP8", '', '', '', '', '', 11)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local result = GetOnscreenKeyboardResult()
		TriggerServerEvent("ply_menupersonnel:addNewNumero", result)
		phoneMenu()
	end
end

function repertoryContact(contact)
	MenuTitle = 'Phonebook'
	ClearMenu()
	Menu.addButton('Display number', 'checkContact', contact )
	Menu.addButton('Send a message', 'writeMsg', contact )
	Menu.addButton('Delete', 'deleteContact', contact )
	Menu.addButton('Back', 'repertoryMenu', nil )
end

function checkContact(contact)
	TriggerServerEvent("ply_menupersonnel:checkContactServer", contact)
end

function writeMsg(receiver)
	DisplayOnscreenKeyboard(2, "FMMC_KEY_TIP8", "(250 characters max)", "", "", "", "", 250)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local result = GetOnscreenKeyboardResult()
		local msg = {
			receiver = receiver,
			msg = result
		}
		TriggerServerEvent("ply_menupersonnel:sendNewMsg", msg)
		phoneMenu()
	end
end

function deleteContact(contact)
	TriggerServerEvent("ply_menupersonnel:deleteContact", contact)
	phoneMenu()
end

function messageryMenu()
	MenuTitle = "Messaging"
	ClearMenu()
	for ind, value in pairs(OLDS_MSG) do
		local n = ""
		if value.has_read == 0 then
			n = " - ~r~Unread"
		end
		Menu.addButton(value.nom .. " " .. n, "msgMenu", {msg = value.msg, nom = value.nom, date= value.date, has_read = value.has_read, receiver_id = value.receiver_id, owner_id = value.owner_id})
	end
	Menu.addButton("Delete all", "deleteAll", nil )
	Menu.addButton("Retour", "phoneMenu", nil )
end

function msgMenu(msg)
	--TriggerServerEvent("ply_menupersonnel:messageryGetOldMsg")
	MenuTitle = "From "..msg.nom
	ClearMenu()
	Citizen.Trace(json.encode(msg))
	Menu.addButton("Read", "readMsg", {msg = msg.msg, nom = msg.nom, date= msg.date, has_read = msg.has_read, receiver_id = msg.receiver_id})
	Menu.addButton("Reply", "respondTo", msg.owner_id)
	Menu.addButton("Delete", "deleteMsg", {msg = msg.msg, nom = msg.nom, date= msg.date, has_read = msg.has_read, receiver_id = msg.receiver_id, owner_id = msg.owner_id})
	Menu.addButton("Back", "messageryMenu", nil )
end

function readMsg(msg)
	TriggerEvent('ply_menupersonnel:readMsg', {by = msg.nom, msg = msg.msg})
	MenuTitle = "From "..msg.nom
	ClearMenu()
	if msg.has_read == 0 then
		TriggerServerEvent("ply_menupersonnel:setMsgReaded", msg)
		TriggerServerEvent("ply_basemod:messageryGetOldMsg")
		SendNUIMessage({read = true})
	end
	Menu.addButton("Close", "closeMsg", nil)
end

function closeMsg()
	TriggerEvent('ply_menupersonnel:closeMsg')
	phoneMenu()
end

function respondTo(contact)
	DisplayOnscreenKeyboard(2, "FMMC_KEY_TIP8", "(250 characters max)", "", "", "", "", 250)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local result = GetOnscreenKeyboardResult()
		local msg = {
			receiver = contact,
			msg = result
		}
		TriggerServerEvent("ply_menupersonnel:sendNewMsg", msg)
		phoneMenu()
	end
end

function deleteMsg(msg)
	local delmsg = {owner = msg.owner_id, receiver = msg.receiver_id, msg = msg.msg}
	TriggerEvent('ply_menupersonnel:deleteUnreaded')
	TriggerServerEvent("ply_menupersonnel:deleteMsg", delmsg)
	phoneMenu()
end

function deleteAll()
	MenuTitle = "Delete all"
	ClearMenu()
	Menu.addButton("Yes", "deleteAllAction", nil)
	Menu.addButton("No", "messageryMenu", nil )
end

function deleteAllAction()
	TriggerServerEvent('ply_menupersonnel:deleteAllMsg')
	phoneMenu()
end

function publicMenu()
	MenuTitle = "Services"
	ClearMenu()
	Menu.addButton("Police", "callPolice", nil)
	Menu.addButton("Medics", "callMedics", nil)
	Menu.addButton("Mechanic", "callTroubleshooters", nil)
	Menu.addButton("Taxi", "callTaxis", nil)
	Menu.addButton("Back", "phoneMenu", nil )
end

function callPolice()
	MenuTitle = "Call police"
	ClearMenu()
	Menu.addButton("Report a Poll", "callPoliceAction", {fn= "police:callPolice", type = 'vole'})
	Menu.addButton("Report an aggression", "callPoliceAction", {fn= "police:callPolice", type = 'aggression'})
	Menu.addButton("Custom reason", "callPoliceAction", {fn= "police:callPoliceCustom", type = nil})
	Menu.addButton("Cancel my call", "callPoliceAction", {fn= "police:cancelCall", type = nil})
	Menu.addButton("Back", "phoneMenu", nil )
end

function callPoliceAction(arg)
	TriggerEvent(arg.fn, {type = arg.type})
	publicMenu()
end

function callMedics()
	MenuTitle = "Medcis"
	ClearMenu()
	Menu.addButton("Call Coma", "callMedicsAction", {type= 'Coma', fn='ambulancier:callAmbulancier'})
	Menu.addButton("Call ambulance", "callMedicsAction", {type='Demande', fn='ambulancier:callAmbulancier'})
	Menu.addButton("Respawn", "callMedicsAction", {type=nil, fn='ambulancier:selfRespawn'})
	Menu.addButton("Cancel my call", "callMedicsAction", {type=nil, fn='ambulancier:cancelCall'})
	Menu.addButton("Back", "phoneMenu", nil )
end

function callMedicsAction(arg)
	TriggerEvent(arg.fn, {type = arg.type})
	publicMenu()
end

function callTroubleshooters()
	MenuTitle = "Mechanic"
	ClearMenu()
	Menu.addButton("Motorbike", "callTroubleshootersAction", {type="moto", fn="mecano:callMecano"})
	Menu.addButton("Car", "callTroubleshootersAction", {type="voiture", fn="mecano:callMecano"})
	Menu.addButton("Van", "callTroubleshootersAction", {type="camionnette", fn="mecano:callMecano"})
	Menu.addButton("Truck", "callTroubleshootersAction", {type="camion", fn="mecano:callMecano"})
	Menu.addButton("Cancel my call", "callTroubleshootersAction", {type=nil, fn="mecano:cancelCall"})
	Menu.addButton("Back", "phoneMenu", nil )
end

function callTroubleshootersAction(arg)
	TriggerEvent(arg.fn, {type = arg.type})
	publicMenu()
end

function callTaxis()
	MenuTitle = "Taxis"
	ClearMenu()
	Menu.addButton("1 person", "callTaxisAction", {type="1 personne", fn="taxi:callService"})
	Menu.addButton("2 persons", "callTaxisAction", {type="2 personne", fn="taxi:callService"})
	Menu.addButton("3 persons", "callTaxisAction", {type="3 personne", fn="taxi:callService"})
	Menu.addButton("Cancel my call", "callTaxisAction", {type=nil, fn="taxi:cancelCall"})
	Menu.addButton("Back", "phoneMenu", nil )
end
function callTaxisAction(arg)
	TriggerEvent(arg.fn, {type = arg.type})
	publicMenu()
end

function cleanMemoryMenu()
	MenuTitle = "Reset"
	ClearMenu()
	Menu.addButton("Yes", "cleanMemoryMenuAction", nil)
	Menu.addButton("No", "phoneMenu", nil )
end

function cleanMemoryMenuAction()
	TriggerServerEvent('ply_menupersonnel:resetPhone')
end

--[[Citizen]]--

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(LocalPed(), true) == false and IsControlJustPressed(1, 311) then
			TriggerServerEvent("ply_basemod:getPlayerInventory")
			MenuPersonnel()
			Menu.hidden = not Menu.hidden
		end
		Menu.renderGUI()
	end
end)



--[[Events]]--

AddEventHandler("ply_menupersonnel:getItems", function(THEITEMS)
	ITEMS = {}
	ITEMS = THEITEMS
end)

AddEventHandler("ply_menupersonnel:repairKit", function(item_id)
	Citizen.CreateThread(function()
		local pedCoords = GetEntityCoords(LocalPed(), 0)
		local veh = GetClosestVehicle(pedCoords["x"], pedCoords["y"], pedCoords["z"], 5.001, 0, 70)
		SetEntityAsMissionEntity(veh, true, true)
		if DoesEntityExist(veh) then
			RequestAnimDict("mini@repair")
			while (not HasAnimDictLoaded("mini@repair")) do
				Citizen.Wait(0)
			end
			TaskPlayAnim(LocalPed(),"mini@repair","fixing_a_car", 8.0, 0.0, 10000, 1, 0,true, true, true)
			drawNotification("Repairing ...")
			Citizen.Wait(10000)
			SetVehicleFixed(veh, 1)
			SetVehicleDeformationFixed(veh, 1)
			SetVehicleUndriveable(veh, 1)
			ClearPedTasksImmediately(LocalPed())
			drawNotification("Vehicle is fully Repaired")
			TriggerServerEvent("ply_menupersonnel:removeItem")
    		TriggerServerEvent("ply_basemod:getPlayerInventory")
		else
			drawNotification("You are too far from a vehicle")
		end
	end)
end)

AddEventHandler("ply_menupersonnel:lockPick", function(item_id)
	Citizen.CreateThread(function()
		local pedCoords = GetEntityCoords(LocalPed(), 0)
		local veh = GetClosestVehicle(pedCoords["x"], pedCoords["y"], pedCoords["z"], 5.001, 0, 70)
		SetEntityAsMissionEntity(veh, true, true)
		if DoesEntityExist(veh) then
			RequestAnimDict("mini@repair")
			while (not HasAnimDictLoaded("mini@repair")) do
				Citizen.Wait(0)
			end
			TaskPlayAnim(LocalPed(),"mini@repair","fixing_a_car", 8.0, 0.0, 10000, 1, 0,true, true, true)
			StartVehicleAlarm(veh)
			drawNotification("Crocheting ...")
			Citizen.Wait(10000)
			SetVehicleDoorsLocked(veh, 1)
			ClearPedTasksImmediately(LocalPed())
			drawNotification("You unlocked the vehicle")
			TriggerServerEvent("ply_menupersonnel:removeItem")
			TriggerServerEvent("ply_basemod:getPlayerInventory")
		else
			drawNotification("You are too far from a vehicle")
		end
	end)
end)

--phone
AddEventHandler("playerSpawned", function()
	TriggerServerEvent("ply_menupersonnel:getPhoneNumber")
end)

AddEventHandler('ply_menupersonnel:unreaded', function()
	SendNUIMessage({unreaded = true})
end)

AddEventHandler('ply_menupersonnel:nbMsgUnreaded', function(counter)
	SendNUIMessage({nbMsgUnreaded = counter})
end)

AddEventHandler('ply_menupersonnel:setSteamId', function(steam_id)
	current_steam_id = steam_id
end)

AddEventHandler('ply_menupersonnel:getPhoneNumberOnLoaded', function(number)
	phone_number = number
end)

AddEventHandler("ply_menupersonnel:repertoryGetNumberListFromServer", function(TNUMBERSLIST)
	NUMBERS_LIST = {}
	NUMBERS_LIST = TNUMBERSLIST
end)

AddEventHandler("ply_menupersonnel:messageryGetOldMsgFromServer", function(TOLDSMSG)
	OLDS_MSG = {}
	OLDS_MSG = TOLDSMSG
end)

AddEventHandler('ply_menupersonnel:notifsNewMsg', function(notif)
	SendNUIMessage({unreaded = true})
	PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
	notifs( notif )
end)

AddEventHandler('ply_menupersonnel:readMsg', function(msg)
	SendNUIMessage({read = true, by = msg.by, msg = msg.msg})
end)

AddEventHandler('ply_menupersonnel:deleteUnreaded', function(msg)
	SendNUIMessage({deleteUnreaded = true})
end)

AddEventHandler('ply_menupersonnel:closeMsg', function()
	SendNUIMessage({closeRead = true})
end)

AddEventHandler("ply_menupersonnel:notifs", function(msg)
	notifs(msg)
end)