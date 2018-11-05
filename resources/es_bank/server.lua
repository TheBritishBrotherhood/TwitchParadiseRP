local banks = {
	["fleeca"] = {
		position = { ['x'] = 147.04908752441, ['y'] = -1044.9448242188, ['z'] = 29.36802482605 },
		reward = math.random (2500, 15000),
		nameofbank = "Fleeca Bank",
		lastrobbed = 0
	},
	["fleeca2"] = {
		position = { ['x'] = -2957.6674804688, ['y'] = 481.45776367188, ['z'] = 15.697026252747 },
		reward = math.random (3000, 10000),
		nameofbank = "Fleeca Bank (Highway)",
		lastrobbed = 0
	},
	["blainecounty"] = {
		position = { ['x'] = -107.06505584717, ['y'] = 6474.8012695313, ['z'] = 31.62670135498 },
		reward = math.random (250, 3600),
		nameofbank = "Blaine County Savings",
		lastrobbed = 0
	},
	["fleeca3"] = {
        position = { ['x'] = 265.418426513672, ['y'] = 213.640502929688, ['z'] = 101.683471679688 },
        reward = math.random (25000, 100000),
        nameofbank = "National Bank",
        lastrobbed = 0
    }
}

local robbers = {}

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('es_bank:toofar')
AddEventHandler('es_bank:toofar', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_bank:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" .. banks[robb].nameofbank)
	end
end)

RegisterServerEvent('es_bank:rob')
AddEventHandler('es_bank:rob', function(robb)
	if banks[robb] then
		local bank = banks[robb]

		if (os.time() - bank.lastrobbed) < 7200 and bank.lastrobbed ~= 0 then
			TriggerClientEvent('chatMessage', source, 'ROBBERY', {255, 0, 0}, "This has already been robbed recently. Please wait another: ^2" .. (7200 - (os.time() - bank.lastrobbed)) .. "^0 seconds.")
			return
		end
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery in progress at ^2" .. bank.nameofbank)
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "You started a robbery at: ^2" .. bank.nameofbank .. "^0, do not get too far away from this point!")
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "The Alarm has been triggered!")
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Hold the fort for ^15 ^0minutes and the money is yours!")
		TriggerClientEvent('es_bank:currentlyrobbing', source, robb)
		banks[robb].lastrobbed = os.time()
		robbers[source] = robb
		local savedSource = source
		SetTimeout(300000, function()
			if(robbers[savedSource])then
				TriggerClientEvent('es_bank:robberycomplete', savedSource, job)
				TriggerEvent('es:getPlayerFromId', savedSource, function(target) 
					if(target)then
						--target:addDirty_Money(bank.reward) 
						target:addMoney(bank.reward)
						TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery is over at: ^2" .. bank.nameofbank)			
					end
				end)
			end
		end)
	end
end)