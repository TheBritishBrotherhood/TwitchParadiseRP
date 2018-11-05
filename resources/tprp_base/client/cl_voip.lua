local voip = {}
voip['default'] = {name = 'default', setting = 15.0}
voip['local'] = {name = 'local', setting = 10.0}
voip['whisper'] = {name = 'whisper', setting = 2.0}
voip['yell'] = {name = 'yell', setting = 25.0}

AddEventHandler('onClientMapStart', function()
	NetworkSetTalkerProximity(voip['default'].setting)
end)

RegisterNetEvent('pv:voip')
AddEventHandler('pv:voip', function(voipDistance)

	if voip[voipDistance]then
		distanceName = voip[voipDistance].name
		distanceSetting = voip[voipDistance].setting
	else
		distanceName = voip['default'].name
		distanceSetting = voip['default'].setting
	end
	
	NotificationMessage("Your VOIP is now ~b~" .. distanceName ..".")
	NetworkSetTalkerProximity(distanceSetting)
		
end)

function NotificationMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end