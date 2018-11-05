TriggerEvent('es:addCommand', 'voip', function(source, args, user)

	TriggerClientEvent('pv:voip', source, args[2])

end)