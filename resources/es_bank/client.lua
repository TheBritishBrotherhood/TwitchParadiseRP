local robbing = false
local bank = ""
local secondsRemaining = 0

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

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

RegisterNetEvent('es_bank:currentlyrobbing')
AddEventHandler('es_bank:currentlyrobbing', function(robb)
	robbing = true
	bank = robb
	secondsRemaining = 480
end)

RegisterNetEvent('es_bank:toofarlocal')
AddEventHandler('es_bank:toofarlocal', function(robb)
	robbing = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "The robbery was cancelled, you will receive nothing.")
	robbingName = ""
	secondsRemaining = 0
	incircle = false
end)


RegisterNetEvent('es_bank:robberycomplete')
AddEventHandler('es_bank:robberycomplete', function(robb)
	robbing = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Robbery done, you have recieved the cash!")
	bank = ""
	secondsRemaining = 0
	incircle = false
end)

Citizen.CreateThread(function()
	while true do
		if robbing then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(banks)do
		local ve = v.position

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 500)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Robbable Bank")
		EndTextCommandSetBlipName(blip)
	end
end)
incircle = false

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		for k,v in pairs(banks)do
			local pos2 = v.position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
				if not robbing then
					DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)
					
					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0)then
						if (incircle == false) then
							DisplayHelpText("Press ~INPUT_CONTEXT~ to rob ~b~" .. v.nameofbank .. "~w~ beware, the police will be alerted!")
						end
						incircle = true
						if(IsControlJustReleased(1, 51))then
							TriggerServerEvent('es_bank:rob', k)
						end
					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
						incircle = false
					end
				end
			end
		end

		if robbing then
			
			drawTxt(0.66, 1.44, 1.0,1.0,0.4, "Robbing bank: ~r~" .. secondsRemaining .. "~w~ seconds remaining", 255, 255, 255, 255)
			
			local pos2 = banks[bank].position

			if(IsPlayerDead(PlayerId())) then
                    if(alreadyDead == false) then
                        TriggerServerEvent('es_bank:toofar', bank)
                        alreadyDead = true
                    end
                else
                    alreadyDead = false
                end

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 7.5)then
				TriggerServerEvent('es_bank:toofar', bank)
			end
		end

		Citizen.Wait(0)
	end
end)