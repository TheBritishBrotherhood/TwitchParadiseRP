local jailPassword = "password" --change this password to your liking and don't share it with the criminals ;-)
 
-----------------------------
 
RegisterServerEvent("chatCommandEntered")
AddEventHandler('chatCommandEntered', function(fullcm)
    cm = stringsplit(fullcm, " ")
 
    if(cm[1] == "*jailme") then
        local jT = 180
        if tablelength(cm) > 1 then
            if cm[2] ~= nil then
                jT = tonumber(cm[2])               
            end
        end
        if jT > 1000 then
            jT = 1000
        end
       
        print("Jailing ".. GetPlayerName(source) .. " for ".. jT .." secs")
        TriggerClientEvent("JP", source, jT)
        TriggerClientEvent('chatMessage', -1, 'JUDGE', { 0, 0, 0 }, GetPlayerName(source) ..' jailed for '.. jT ..' secs')
    elseif cm[1] == "*unjail" then
        if tablelength(cm) > 2 then
            if cm[2] == jailPassword then
                local tPID = tonumber(cm[3])
                print("Unjailing ".. GetPlayerName(tPID).. " - cm entered by ".. GetPlayerName(source))
                TriggerClientEvent("UnJP", tPID)
            else
                print("Incorrect jailPassword entered by ".. GetPlayerName(source))
            end
        end
    elseif cm[1] == "*jail" then
        if tablelength(cm) > 2 then
            if cm[2] == jailPassword then
                local tPID = tonumber(cm[3])
                local jT = 180
                if tablelength(cm) > 3 then
                    if cm[4] ~= nil then
                        jT = tonumber(cm[4])               
                    end
                end
                if jT > 1000 then
                    jT = 1000
                end
                print("Jailing ".. GetPlayerName(tPID).. " for ".. jT .." secs - cm entered by ".. GetPlayerName(source))
                TriggerClientEvent("JP", tPID, jT)
                TriggerClientEvent('chatMessage', -1, 'JUDGE', { 0, 0, 0 }, GetPlayerName(tPID) ..' jailed for '.. jT ..' secs')
            else
                print("Incorrect jailPassword entered by ".. GetPlayerName(source))
            end
        end
    end
end)
 
print('Jailer by Albo1125 (LUA, FiveReborn). Commands to type in chat (T):')
print('/jailme SECS - Jails yourself, if SECS not given defaults to 180.')
print('/unjail PSWD PLAYERID - Unjails the player with PLAYERID (hold up arrow ingame to see) if PSWD matches specified jail password.')
print('/jail PSWD PLAYERID SECS - Jails the player with PLAYERID (hold up arrow ingame to see) if PSWD matches specified jail password. If SECS not given defaults to 180')
function stringsplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}
 
  for i = 0, #a - 1 do
     table.insert(t, a[i])
  end
 
  return t
end
 
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
