vehStorage = {}

RegisterServerEvent("ls:check")
AddEventHandler("ls:check" function(plate, vehicleId, isPlayerInside, notificationParam)

	TriggerEvent("es:getPlayerFromId", source, function(user)
	    playerIdentifier = user.identifier
	end)

	Search(plate, playerIdentifier, vehicleId, isPlayerInside, notificationParam)
end)

RegisterServerEvent("ls:changeLockStatus")
AddEventHandler("ls:changeLockStatus", function(param, plate)

	UpdateTable(param, plate)
end)

function Search(plate, playerIdentifier, vehicleId, isPlayerInside, notificationParam)
	result = 0
	for i=1, #(vehStorage) do
		if vehStorage[i].plate == plate then
			result = result + 1
			if vehStorage[i].owner == playerIdentifier then
				TriggerClientEvent("ls:lock", source, vehStorage[i].lockStatus, vehStorage[i].id)
			else
				TriggerClientEvent("pNotify:SendNotification", source,{
            text = "<b style='color:red'>Alert:</b> <br /> <b style='color:white'>You do not have the keys to this vehicle.",
            type = "success",
            timeout = (10000),
            layout = "centerRight",
            queue = "right"
        })
			end
		end
	end

	if result == 0 and isPlayerInside then

		randomMsg = RandomMsg()
		--TriggerClientEvent("ls:sendNotification", source, notificationParam, randomMsg, 0.5)
		TriggerClientEvent("pNotify:SendNotification", source,{
            text = "<b style='color:red'>Alert:</b> <br /> <b style='color:white'>You found the keys in the glovebox",
            type = "success",
            timeout = (10000),
            layout = "centerRight",
            queue = "right"
        })
		table.insert(vehStorage, {plate=plate, owner=playerIdentifier, lockStatus=0, id=vehicleId})

	end
end

function UpdateTable(param, plate)
	for i=1, #(vehStorage) do
		if vehStorage[i].plate == plate then
			vehStorage[i].lockStatus = param
		end
	end
end

function RandomMsg()
	random = math.random(1, 6)
	if random == 1 then randomMsg = "You have found the keys on the sun-shield." end
	if random == 2 then randomMsg = "You found the keys in the glove box." end
	if random == 3 then randomMsg = "You found the keys on the passenger seat." end
	if random == 4 then randomMsg = "You found the keys on the floor." end
	if random == 5 then randomMsg = "The keys were already on the contact, you took them." end
	return randomMsg
end






