--Fonction cmd /dropgun
RegisterServerEvent("chatCommandEntered")
RegisterServerEvent("chatMessageEntered")

AddEventHandler("chatMessage", function(p, color, msg)
    if msg:sub(1, 1) == "/" then
        fullcmd = stringSplit(msg, " ")
        cmd = fullcmd[1]
        args = makeArgs(fullcmd)
        if cmd == "/dropgun" then
            CancelEvent()
            TriggerClientEvent("dropweapon", p)
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

function makeArgs(cmd)
    args = {}
    for i = 2, #cmd, 1 do
        table.insert(args, cmd[i])
    end
    return args
end

--fonction keybinding
RegisterServerEvent('drops')
AddEventHandler('drops', function()
  TriggerClientEvent('dropweapon', source)
end)
