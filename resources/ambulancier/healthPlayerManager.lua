--[[
################################################################
- Creator: Jyben
- Edition: Charli62128
- Date: 30/04/2017
- Url: https://github.com/Jyben/emergency
- Licence: Apache 2.0
################################################################
--]]

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

function Chat(t)
	TriggerEvent("chatMessage", 'AMBU', { 0, 255, 255}, "" .. tostring(t))
end

local isDead = false
local isKO = false

--[[
################################
            THREADS
################################
--]]

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local playerPed = GetPlayerPed(-1)
    local playerID = PlayerId()
    local currentPos = GetEntityCoords(playerPed, true)
    local previousPos

    isDead = IsEntityDead(playerPed)
    
    if isKO and previousPos ~= currentPos then
      isKO = false
    end

   if (GetEntityHealth(playerPed) < 120 and not isDead and not isKO) then
      if (IsPedInMeleeCombat(playerPed)) then
        SetPlayerKO(playerID, playerPed)
      end
    end

    previousPos = currentPos
  end
end)

--Citizen.CreateThread(function()
--	while true do
--		Citizen.Wait(0)
--  	if IsEntityDead(PlayerPedId())then
--			StartScreenEffect("DeathFailOut", 0, 0)
--			ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
--
--			local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
--
--			if HasScaleformMovieLoaded(scaleform) then
--				Citizen.Wait(0)
--
--				PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
--				BeginTextComponent("STRING")
--				AddTextComponentString("~r~you are in a coma")
--				EndTextComponent()
--				PopScaleformMovieFunctionVoid()
--
--		  	Citizen.Wait(500)
--
--		    while IsEntityDead(PlayerPedId()) do
--					DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
--			 		Citizen.Wait(0)
--		    end
--
--		  	StopScreenEffect("DeathFailOut")
--			end
--		end
--	end
--end)

--[[
################################
            EVENTS
################################
--]]

AddEventHandler("playerSpawned", function(spawn)
     exports.spawnmanager:setAutoSpawn(false)
  end)
 

-- Triggered when player died by environment
AddEventHandler('baseevents:onPlayerDied',
  function(playerId, reasonID)
    TriggerEvent('es_em:playerInComa')
    SendNotification('Your in a coma! Press F2 to call EMS, If none are online then press F2/medics/respawn.')
  end
)

-- Triggered when player died by an another player
AddEventHandler('baseevents:onPlayerKilled',
  function(playerId, playerKill, reasonID)
      TriggerEvent('es_em:playerInComa')
      SendNotification('Your in a coma! Press F2 to call EMS, If none are online then press F2/medics/respawn.')
  end
)

function Resurrect()
		local playerPed = GetPlayerPed(-1)
		ResurrectPed(playerPed)
		SetEntityHealth(playerPed, GetPedMaxHealth(playerPed)/2)
		ClearPedTasksImmediately(playerPed)
		notif('You have been resurrected')
		
end


RegisterNetEvent('ambulancier:rescue')
AddEventHandler('ambulancier:rescue',
	function()
			TriggerServerEvent("ambulancier:needs")
			Resurrect()
			TriggerServerEvent("skin:reloadSkin")
	end
)


RegisterNetEvent("ambulancier:forceRespawn")
AddEventHandler("ambulancier:forceRespawn",
function()
  --TriggerServerEvent("ambulancier:resetInventory")
  --RemoveAllPedWeapons(GetPlayerPed(-1), true)
  --Chat("ICI")
	NetworkResurrectLocalPlayer(ambulancier_sortie.x, ambulancier_sortie.y, ambulancier_sortie.z, true, true, false)
	Wait(100)
	--TriggerServerEvent("item:reset")
	--TriggerServerEvent("item:getItems")
	--TriggerServerEvent("skin:reloadSkin")
	--TriggerEvent("police:finishService")
	--RemoveAllPedWeapons(GetPlayerPed(-1), true)
	Citizen.Wait(10000)
	TriggerServerEvent("police:checkIsCop")
	--TriggerServerEvent("weaponshop:RemoveWeaponsToPlayer")
  TriggerEvent('spwanManager:forceRespawn')
end)

--[[
################################
        BUSINESS METHODS
################################
--]]

function SetPlayerKO(playerID, playerPed)
  isKO = true
  SendNotification('KO !')
  SetPedToRagdoll(playerPed, 6000, 6000, 0, 0, 0, 0)
end

function SendNotification(message)
  SetNotificationTextEntry('STRING')
  AddTextComponentString(message)
  DrawNotification(false, false)
end

--[[
################################
        USEFUL METHODS
################################
--]]

function GetStringReason(reasonID)
  local reasonString = 'Tuer'

  if reasonID == 0 or reasonID == 56 or reasonID == 1 or reasonID == 2 then
    reasonIDString = 'Molester'
  elseif reasonID == 3 then
    reasonIDString = 'Poignarder'
  elseif reasonID == 4 or reasonID == 6 or reasonID == 18 or reasonID == 51 then
    reasonIDString = 'Exploser'
  elseif reasonID == 5 or reasonID == 19 then
    reasonIDString = 'Bruler'
  elseif reasonID == 7 or reasonID == 9 then
    reasonIDString = 'Coup de crosse'
  elseif reasonID == 10 or reasonID == 11 then
    reasonIDString = 'Par Balle'
  elseif reasonID == 12 or reasonID == 13 or reasonID == 52 then
    reasonIDString = 'Par Balle'
  elseif reasonID == 14 or reasonID == 15 or reasonID == 20 then
    reasonIDString = 'Par Balle'
  elseif reasonID == 16 or reasonID == 17 then
    reasonIDString = 'Par Balle'
  elseif reasonID == 49 or reasonID == 50 then
    reasonString = 'Ecraser'
  end

  return reasonString
end
