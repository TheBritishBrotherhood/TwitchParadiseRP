-- Loading MySQL Class
require "resources/essentialmode/lib/MySQL"

-- MySQL:open("IP", "databasname", "user", "password")
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "tprp")

-- Rcon commands
AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'getPlayers' then
		TriggerEvent('es:getPlayers', function(pl)
			for k,v in pairs(pl) do
				RconPrint(GetPlayerName(k):gsub("%s+", "_") .. " " .. v.permission_level .. " " .. k)
			end
		end)

		CancelEvent()
	elseif commandName == 'ap_kick' then
		if(GetPlayerName(args[1])) then
			DropPlayer(args[1])
			RconPrint('kicked')
		end

		CancelEvent()
	elseif commandName == 'ap_slay' then
		TriggerClientEvent('es_admin:kill', args[1])
		RconPrint('killed')

		CancelEvent()
	end
end)
