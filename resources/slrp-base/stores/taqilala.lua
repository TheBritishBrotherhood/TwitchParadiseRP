-- Configure the coordinates where the strippers should be placed.
local strippers = {}

-- Configure the coordinates for the bartenders.
  local bartenders = {
    {type=5, hash=0x780c01bd, x=-561.789, y=286.718, z=82.176, a=263.704},
  }

-- Configure the coordinates for the bartenders.
local bouncers = {
  {type=4, hash=0x9fd4292d, x=-566.424, y=274.986, z=83.020, a=177.602},
  {type=4, hash=0x9fd4292d, x=-564.476, y=279.706, z=83.020, a=180.102},
}

function LocalPed()
  return GetPlayerPed(-1)
end

function StartText()
  DrawMarker(1, -1171.42, -1572.72, 3.6636, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
  ShowInfo("Press ~INPUT_CONTEXT~ to buy a drink", 0)
end

Citizen.CreateThread(function()
  -- Load the ped modal (s_f_y_bartender_01)
  RequestModel(GetHashKey("s_f_y_bartender_01"))
  while not HasModelLoaded(GetHashKey("s_f_y_bartender_01")) do
    Wait(1)
  end

  -- Load the ped modal (mp_f_stripperlite)
  RequestModel(GetHashKey("mp_f_stripperlite"))
  while not HasModelLoaded(GetHashKey("mp_f_stripperlite")) do
    Wait(1)
  end

  -- Load the ped modal (s_m_m_bouncer_01)
  RequestModel(GetHashKey("s_m_m_bouncer_01"))
  while not HasModelLoaded(GetHashKey("s_m_m_bouncer_01")) do
    Wait(1)
  end

  -- Load the animation (testing)
  RequestAnimDict("mini@strip_club@idles@stripper")
  while not HasAnimDictLoaded("mini@strip_club@idles@stripper") do
    Wait(1)
  end

  -- Load the bouncer animation (testing)
  RequestAnimDict("mini@strip_club@idles@bouncer@base")
  while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
    Wait(1)
  end

    -- Spawn the bartender to the coordinates
    bartender =  CreatePed(5, 0x780c01bd, -561.789, 286.718, 82.176, 263.704, false, true)
    SetBlockingOfNonTemporaryEvents(bartender, true)
    SetPedCombatAttributes(bartender, 46, true)
    SetPedFleeAttributes(bartender, 0, 0)
    SetPedRelationshipGroupHash(bartender, GetHashKey("CIVFEMALE"))


  -- Spawn the bouncers to the coordinates
  for _, item in pairs(bouncers) do
    ped =  CreatePed(item.type, item.hash, item.x, item.y, item.z, item.a, false, true)
    GiveWeaponToPed(ped, 0x1B06D571, 2800, false, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedArmour(ped, 100)
    SetPedMaxHealth(ped, 100)
    SetPedRelationshipGroupHash(ped, GetHashKey("army"))
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GUARD_STAND_PATROL", 0, true)
    SetPedCanRagdoll(ped, false)
    SetPedDiesWhenInjured(ped, false)
    TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end

  -- Spawn the strippers to the coordinates
  for _, item in pairs(strippers) do
    stripper =  CreatePed(item.type, item.hash, item.x, item.y, item.z, item.a, false, true)
    GiveWeaponToPed(stripper, 0x99B507EA, 2800, false, true)
    SetPedCombatAttributes(stripper, 46, true)
    SetPedFleeAttributes(stripper, 0, 0)
    SetPedArmour(stripper, 200)
    SetPedMaxHealth(stripper, 200)
    SetPedDiesWhenInjured(ped, false)
    SetPedRelationshipGroupHash(stripper, GetHashKey("army"))
    TaskPlayAnim(stripper,"mini@strip_club@idles@stripper","stripper_idle_03", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
  end
end)


local playerCoords
local playerPed
showStartText = false

Citizen.CreateThread(function()
    while true do
       Wait(0)
       playerPed = GetPlayerPed(-1)
       playerCoords = GetEntityCoords(playerPed, 0)

       if(GetDistanceBetweenCoords(playerCoords, -562.129, 286.71, 82.176) < 2) then
         if(showStartText == false) then
           StartText()
         end

         -- Start mission
         if(IsControlPressed(1, 38)) then
           TriggerServerEvent("es_freeroam:pay", tonumber(50))
           Toxicated()
           Citizen.Wait(120000)
           reality()
         end
       else
         showStartText = false
       end --if GetDistanceBetweenCoords ...
    end
end)


function Toxicated()
  RequestAnimSet("move_m@drunk@verydrunk")
  while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
    Citizen.Wait(0)
  end

  TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_DRUG_DEALER", 0, 1)
  DoScreenFadeOut(1000)
  Citizen.Wait(1000)
  ClearPedTasksImmediately(GetPlayerPed(-1))
  SetTimecycleModifier("spectator5")
  SetPedMotionBlur(GetPlayerPed(-1), true)
  SetPedMovementClipset(GetPlayerPed(-1), "move_m@drunk@verydrunk", true)
  SetPedIsDrunk(GetPlayerPed(-1), true)
  DoScreenFadeIn(1000)
  end

  function reality()
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
    SetPedIsDrunk(GetPlayerPed(-1), false)
    SetPedMotionBlur(GetPlayerPed(-1), false)
    -- Stop the toxication
    Citizen.Trace("Going back to reality\n")
    end
