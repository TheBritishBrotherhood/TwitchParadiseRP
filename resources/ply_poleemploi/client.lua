--[[Local/Global]]--

RegisterNetEvent("ply_poleemploi:getJobs")
RegisterNetEvent("ply_poleemploi:JobTrue")


--[[Local/Global]]--

JOBS = {}
local pole_emploi_location = {237.592, -406.183, 46.924}


--[[Functions]]--

function MenuJobs()
  ped = GetPlayerPed(-1);
  MenuTitle = "Job Center"
  ClearMenu()
  for ind, value in pairs(JOBS) do
          Menu.addButton(tostring(value.name), "SetJobs", {value.id,value.name})
  end
  Menu.addButton("Close Menu","CloseMenu",nil)
end

function SetJobs(arg)
  TriggerServerEvent('ply_poleemploi:updateJobs', arg[1],arg[2])
  CloseMenu()
end

function CloseMenu()
  Menu.hidden = true
  TriggerServerEvent("ply_poleemploi:getJobs")
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x , y)
end

function drawNotification(text)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(text)
  DrawNotification(false, false)
end

function ShowInfo(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end



--[[Citizen]]--

Citizen.CreateThread(function()
	local loc = pole_emploi_location
	pos = pole_emploi_location
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,408)
	SetBlipColour(blip, 1)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Pole Emploi')
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
	checkgarage = 0
	while true do
		Wait(0)
		DrawMarker(1,pole_emploi_location[1],pole_emploi_location[2],pole_emploi_location[3],0,0,0,0,0,0,4.001,4.0001,0.5001,200,60,60,255,0,0,0,0)
		if GetDistanceBetweenCoords(pole_emploi_location[1],pole_emploi_location[2],pole_emploi_location[3],GetEntityCoords(GetPlayerPed(-1))) < 5 and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
			--drawTxt('~g~E~s~ pour ouvrir le menu des métiers',0,1,0.5,0.8,0.6,255,255,255,255)
			ShowInfo("~INPUT_VEH_HORN~ to open ~g~menu~s~", 0)
			if IsControlJustPressed(1, 86) then
				TriggerServerEvent("ply_poleemploi:getJobs")
				MenuJobs()
				Menu.hidden = not Menu.hidden
			end
			Menu.renderGUI()
		end
	end
end)



--[[Event]]--

AddEventHandler("ply_poleemploi:getJobs", function(THEJOBS)
	JOBS = {}
	JOBS = THEJOBS
end)

AddEventHandler("ply_poleemploi:JobTrue", function(jobs_name)
	local jobs_name = jobs_name
	exports.pNotify:SendNotification({text = "You are now hired for "..jobs_name, type = "success", queue = "left", timeout = 3000, layout = "centerRight"})
end)