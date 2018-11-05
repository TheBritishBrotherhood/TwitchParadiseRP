--[[
  Product: FiveM Vehicle Restrictions lua script
  Copyright: (c) 2000 - 2017 by Psd Designs, Inc.
  Programmer: Simon Lewis
  Contact: simon@psd-designs.com
  Version: 0.1

  Unauthorized reproduction or distribution of this program,
  or any portion of it, may result in severe civil and criminal penalties,
  and will be prosecuted to the maximun extent possible under the law.
]]

-- Pre set integers
local currentVehicle = 0
local currentSeat = 0

-- Show Notification messages
function ShowNotification( text )
   SetNotificationTextEntry( "STRING" )
   AddTextComponentString( text )
   DrawNotification( false, false )
end

-- Get current seat player is in
function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
  return -2
end

--[[
   Blocked vehicles list
   Add vehicle hashcode to list to prevent them from being driven by civilians
]]

local vehicles = {
      { hash="-475225213" }, -- police trainer
      { hash="666014468" }, -- police cruiser
      { hash="2038038420" }, -- police stanier
      { hash="-1537810200" }, -- police buffalo
      { hash="-1309990298" }, -- fbi buffalo
      { hash="-64097686" }, -- fbi granger
      { hash="-35776806" }, -- sheriff cruiser
      { hash="-2007311232" }, -- sheriff buffalo
      --{ hash="-239432727" }, -- sheriff towtruck
      { hash="-545384401" }, -- highway cruiser
      { hash="-57703123" }, -- highway buffalo
      { hash="2005531687" }, -- highway byke
}

function VehicleList()
    local get_ped = PlayerPedId()
    local currentVehicle = GetVehiclePedIsIn(get_ped)
    local model = GetEntityModel(currentVehicle)
    local currentHash = GetHashKey(model, _r)

    --[[
      Remove [ -- ] from the trace codes below to get the current vehicle hash code that your in,
      and dispaly it in the GTA:V console
    ]]

    --Citizen.Trace('vehicle ' .. tostring(currentHash) .. "\n")

    for i, pos in ipairs(vehicles) do
    local hash = pos.hash
    if ( tostring(currentHash) == hash ) then
      return true
    end
  end
  return false
end

-- Prevent car from block list from being driven
Citizen.CreateThread(function()
  while true do
	  Citizen.Wait(0)
    local get_ped = PlayerPedId()
    if IsPedInAnyVehicle(get_ped, false) then
       local currentSeat = GetPedVehicleSeat(get_ped)
       if VehicleList() == true and ( currentSeat == -1 ) then
          TriggerServerEvent("s_IsCarDriveable")
         elseif VehicleList() == false and ( currentSeat == -1 ) then
          TriggerEvent("c_Driveable")
       end
     end
   end
end)

-- Remove all players weapons when exting any police vehicles
Citizen.CreateThread(function()
 while true do
	 Citizen.Wait(0)
		local ply = GetPlayerPed(-1)
		if IsControlJustPressed(1, 23) and IsPedInAnyVehicle(ply, false) then
		  if VehicleList() then
        TriggerServerEvent("s_RemoveAllWeapons")
      end
		end
	end
end)

-- Makes car drivable for police officers and admins
RegisterNetEvent("c_Driveable")
AddEventHandler("c_Driveable", function()
   playerPed = GetPlayerPed(-1)
   playerVehicle = GetVehiclePedIsIn(playerPed, true)
	 SetVehicleUndriveable(playerVehicle, false)
end)

-- Makes cars undrivable for civilians
RegisterNetEvent("c_Undriveable")
AddEventHandler("c_Undriveable", function()
   playerPed = GetPlayerPed(-1)
   playerVehicle = GetVehiclePedIsIn(playerPed, true)
	 SetVehicleUndriveable(playerVehicle, true)
end)

RegisterNetEvent("c_RemWeap")
AddEventHandler("c_RemWeap", function()
   playerPed = GetPlayerPed(-1)
   DisablePlayerVehicleRewards(playerPed)
   RemoveAllPedWeapons(playerPed, true)
   TriggerEvent("c_text", " You dropped your weapons down the side of the seat. ", 2000)
end)

-- Show in game text message at the bottom of screen
AddEventHandler("c_text", function(text, time)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(text)
  DrawSubtitleTimed(time, 1)
end)
