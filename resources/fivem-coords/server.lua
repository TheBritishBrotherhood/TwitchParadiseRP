
print("Write /pos ingame to save the coords in a .txt in server's main folder")

RegisterServerEvent("SaveCoords")
AddEventHandler("SaveCoords", function( PlayerName , x , y , z )
 file = io.open( PlayerName .. "-Coords.txt", "a")
    if file then
        file:write("{" .. x .. "," .. y .. "," .. z .. "},")
        file:write("\n")
    end
    file:close()
end)

AddEventHandler("chatMessage", function(p, color, msg)
    if msg:sub(1, 1) == "/" then
        fullcmd = stringSplit(msg, " ")
        cmd = fullcmd[1]

        if cmd == "/pos" then
        	TriggerClientEvent("SaveCommand", p)
        	CancelEvent()
        end
    end
end)

function stringSplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
     table.insert(t, a[i])
  end

  return t
end