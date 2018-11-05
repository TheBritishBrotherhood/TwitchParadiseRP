AddEventHandler('chatMessage', function(source, name, message)
	if string.sub(message,1,string.len("/"))=="/" then
		--ne doit rien se passer c'est une commande
	else
		TriggerClientEvent("sendProximityMessage", -1, source, name, message)
	end
	CancelEvent()
end)

-- ME COMMAND (/me [Message]) Outcomes: Name Message (All in purple)
TriggerEvent('es:addCommand', 'me', function(source, args, user)
    table.remove(args, 1)
    local pname = GetPlayerName(source)
    TriggerClientEvent("sendProximityMessageMe", -1, source, pname, table.concat(args, " "))
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

-- DO COMMAND (/do [Message]) Outcomes: Action: *Name Message
TriggerEvent('es:addCommand', 'do', function(source, args, user)
	table.remove(args, 1)
	local pname = GetPlayerName(source)
	TriggerClientEvent("sendProximityMessageDo", -1, source, pname, table.concat(args, " "))
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

TriggerEvent('es:addCommand', 'ooc', function(source, args, user)
	table.remove(args, 1)
	local message = table.concat(args, " ")
	--TriggerClientEvent('chatMessage', -1, "^1(( ^0Global", {100, 100, 100}, tag .. "^4 " .. GetPlayerName(source) .. " ^4(^0"..source.."^4): ^0" .. message .. "^1))")
	TriggerClientEvent('chatMessage', -1, "OOC | " GetPlayerName(source), { 128, 128, 128 }, ^0" .. message .. "^1))
end)