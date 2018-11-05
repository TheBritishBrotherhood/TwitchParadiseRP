local emotePlay = false
local lastDic = ""
local lastCli = ""
 
function playEmote(data)
    TriggerEvent('gc:playEmote', data.EmoteName)
end
 
function customAnimation()
    local dictionaries = openTextInput("", lastDic, 180)
    if dictionaries ~= nil then
        lastDic = dictionaries
        local clip = openTextInput("", lastCli, 180)
        if clip ~= nil then
            lastCli = clip
            local loop = openTextInput("","",1)
            local l =  not  (loop == nil or loop == '0' or loop == '')
            TriggerEvent('gc:playAminationAdv', dictionaries, clip, l)
        end
    end
end
 
function playAmination(data)
    TriggerEvent('gc:playAmination', data.dictionaries, data.clip)
end
 
function playAminationLoop(data)
    TriggerEvent('gc:playAminationAdv', data.dictionaries, data.clip, true)
end
 
 
RegisterNetEvent("gc:playEmote")
AddEventHandler("gc:playEmote", function(emoteNane)
    local ped = GetPlayerPed(-1);
    if ped then
        TaskStartScenarioInPlace(ped, emoteNane, 0, false)
        emotePlay = true
    end
end)
 
 
RegisterNetEvent("gc:playAmination")
AddEventHandler("gc:playAmination", function(dictionaries, clip)
    local lPed = GetPlayerPed(-1)
    if DoesEntityExist(lPed) then
        Citizen.CreateThread(function()
            RequestAnimDict(dictionaries)
            while not HasAnimDictLoaded(dictionaries) do
                Citizen.Wait(100)
            end
           
            if IsEntityPlayingAnim(lPed, dictionaries, clip, 3) then
                ClearPedSecondaryTask(lPed)
                SetEnableYes(lPed, false)
            else
                TaskPlayAnim(lPed, dictionaries, clip, 8.0, -8, -1, 16, 0, 0, 0, 0)
                SetEnableYes(lPed, true)
            end    
        end)
    end
end)
 
RegisterNetEvent("gc:playAminationAdv")
AddEventHandler("gc:playAminationAdv", function(dictionaries, clip, loop)
    local lPed = GetPlayerPed(-1)
    if DoesEntityExist(lPed) then
        Citizen.CreateThread(function()
            RequestAnimDict(dictionaries)
            while not HasAnimDictLoaded(dictionaries) do
                Citizen.Wait(100)
            end
           
            if IsEntityPlayingAnim(lPed, dictionaries, clip, 3) then
                ClearPedSecondaryTask(lPed)
                SetEnableYes(lPed, false)
            else
                local flag = 16
                if loop == true then
                    flag = 49
                end
                TaskPlayAnim(lPed, dictionaries, clip, 8.0, -8, -1, flag, 0, 0, 0, 0)
                SetEnableYes(lPed, true)
            end    
        end)
    end
end)
RegisterNetEvent("gc:clearAmination")
AddEventHandler("gc:clearAmination", function()
    local lPed = GetPlayerPed(-1)
    if DoesEntityExist(lPed) then
        Citizen.CreateThread(function()
            ClearPedSecondaryTask(lPed)
            SetEnableYes(lPed, false)  
        end)
    end
end)
 
function stopEmote()
  ClearPedTasks(GetPlayerPed(-1))
  emotePlay = false
end
 
 
-- Sprint   21
-- Jump 22
-- MoveLeftRight    30
-- MoveUpDown   31
-- MoveUpOnly   32
-- MoveDownOnly 33
-- MoveLeftOnly 34
-- MoveRightOnly    35
 
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if emotePlay then
      if IsControlJustPressed(1, 22) or IsControlJustPressed(1, 30) or IsControlJustPressed(1, 31) then -- INPUT_JUMP
        stopEmote()
      end
    end
  end
end)