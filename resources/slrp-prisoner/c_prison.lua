--[[
  Product: FiveM Prisoner lua script
  Copyright: (c) 2000 - 2017 by Psd Designs, Inc.
  Programmer: Simon Lewis
  Contact: simon@psd-designs.com
  Version: 0.1

  Unauthorized reproduction or distribution of this program,
  or any portion of it, may result in severe civil and criminal penalties,
  and will be prosecuted to the maximun extent possible under the law.
]]

-- cell controls marker
local markerX, markerY, markerZ = 465.2287, -995.9999, 23.1999

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- Pre set integers and boolean
local currentVehicle = 0
local currentSeat = 0
local cellone = false
local celltwo = false
local cellthree = false

-- Display text message
function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

-- Show Notification messages
function ShowNotification( text )
   SetNotificationTextEntry( "STRING" )
   AddTextComponentString( text )
   DrawNotification( false, false )
end

-- NEW VERSION
local cells = {
	["cone"] = { event = "prison:s_openONE" },
	["ctwo"] = { event = "prison:s_openTWO" },
  ["cthree"] = { event = "prison:s_openTHREE" },
	["call"] = { event = "prison:s_openALL" },
}

function InitMenuCells()
	MenuTitle = "Controls"
	ClearMenu()
	Menu.addButton("Open/Close Cell One", "callSE", cells["cone"].event)
	Menu.addButton("Open/Close Cell Two", "callSE", cells["ctwo"].event)
	Menu.addButton("Open/Close Cell Three", "callSE", cells["cthree"].event)
	--Menu.addButton("Open/Close All Cells", "callSE", cells["call"].event)
end

function callSE(evt)
	Menu.hidden = not Menu.hidden
	Menu.renderGUI()
	TriggerServerEvent(evt)
end

-- Make door marker circle
Citizen.CreateThread(function()
  while true do
	  Citizen.Wait(0)
    if cellone then
       DrawMarker(1, 462.0317, -993.7909, 23.3049, 0, 0, 0, 0, 0, 0, 1.109, 1.1019, 0.8009, 0, 79, 255, 165, 0,0, 0,0)
    end
    if celltwo then
       DrawMarker(1, 461.8481, -998.3590, 23.3049, 0, 0, 0, 0, 0, 0, 1.109, 1.1019, 0.8009, 0, 79, 255, 165, 0,0, 0,0)
    end
    if cellthree then
		   DrawMarker(1, 461.8315, -1001.9790, 23.3049, 0, 0, 0, 0, 0, 0, 1.109, 1.1019, 0.8009, 0, 79, 255, 165, 0,0, 0,0)
    end
  end
end)

-- Make control panel marker circle
Citizen.CreateThread(function()
  while true do
	  Citizen.Wait(0)
    DrawMarker(1, markerX, markerY, markerZ, 0, 0, 0, 0, 0, 0, 1.109, 1.1019, 0.8009, 0, 79, 255, 165, 0,0, 0,0)
  end
end)

-- Check if player is near an cell controls
function IsNearCellDoorControls()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  local distance = GetDistanceBetweenCoords(markerX, markerY, markerZ, plyCoords["x"], plyCoords["y"], plyCoords["z"], false)
  if (distance <= 1) then
    return true
  end
end

-- Display message when over zone
Citizen.CreateThread(function()
  while true do
	  Citizen.Wait(0)
    if IsNearCellDoorControls() then
			drawTxt('Press ~g~H~s~ to access the ~b~Cell door controls', 2, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
      if IsControlJustPressed(1, Keys["H"]) then
         TriggerServerEvent("prison:s_openMENU")
			 elseif not IsNearCellDoorControls() then
				 ClearMenu()
 	       Menu.hidden = true
 	    end
	  end
		Menu.renderGUI()
  end
end)

-- Display message when over zone
Citizen.CreateThread(function()
  while true do
	  Citizen.Wait(0)
    local myPed = GetPlayerPed(-1)
    if cellone and (GetDistanceBetweenCoords(462.0317, -993.7909, 23.3049, GetEntityCoords(myPed)) < 1) then
       TriggerServerEvent("prison:s_Pushback", myPed)
    elseif celltwo and (GetDistanceBetweenCoords(461.8481, -998.3590, 23.3049, GetEntityCoords(myPed)) < 1) then
       TriggerServerEvent("prison:s_Pushback", myPed)
    elseif cellthree and (GetDistanceBetweenCoords(461.8315, -1001.9790, 23.3049, GetEntityCoords(myPed)) < 1) then
       TriggerServerEvent("prison:s_Pushback", myPed)
    end
  end
end)

RegisterNetEvent("prison:c_PushUser")
RegisterNetEvent("prison:c_OpenMenu")
RegisterNetEvent("prison:c_OpenCellOne")
RegisterNetEvent("prison:c_OpenCellTwo")
RegisterNetEvent("prison:c_OpenCellThree")
RegisterNetEvent("prison:c_OpenCellAll")

AddEventHandler("prison:c_OpenMenu", function()
	if IsNearCellDoorControls() then
     InitMenuCells()
	   Menu.hidden = not Menu.hidden
  end
end)

AddEventHandler("prison:c_OpenCellOne", function()
  cellone = not cellone
end)

AddEventHandler("prison:c_OpenCellTwo", function()
  celltwo = not celltwo
end)

AddEventHandler("prison:c_OpenCellThree", function()
  cellthree = not cellthree
end)

AddEventHandler("prison:c_OpenCellAll", function()
  cellone = not cellone
  celltwo = not celltwo
  cellthree = not cellthree
end)

AddEventHandler("prison:c_PushUser", function()
  local myPed = GetPlayerPed(-1)
  if cellone and (GetDistanceBetweenCoords(462.0317, -993.7909, 23.3049, GetEntityCoords(myPed)) < 1) then
     SetEntityCoords(myPed, 459.8648, -994.6914, 24.9149)
  elseif celltwo and (GetDistanceBetweenCoords(461.8481, -998.3590, 23.3049, GetEntityCoords(myPed)) < 1) then
     SetEntityCoords(myPed, 458.7749, -997.9138, 24.9149)
  elseif cellthree and (GetDistanceBetweenCoords(461.8315, -1001.9790, 23.3049, GetEntityCoords(myPed)) < 1) then
     SetEntityCoords(myPed, 458.8635, -1001.4504, 24.9149)
  end
end)

-- Show in game text message at the bottom of screen
AddEventHandler("c_text", function(text, time)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(text)
  DrawSubtitleTimed(time, 1)
end)
