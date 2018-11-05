skins = {
	{
		name = "mp_f_freemode_01",
		display = "Woman"
	},
	{
		name = "mp_m_freemode_01",
		display = "Man"
	}
}

local isSpawnedInHospitalOnDeath = true

RegisterNetEvent("skin_customization:Customization")
RegisterNetEvent("skin_customization:OnDeath")

function InitMenu()
	ClearMenu()
	Menu.addTitle("Choose a skin");
   	Menu.addButton(skins[2].display, "SendSkin", skins[2].name);
	Menu.addButton(skins[1].display, "SendSkin", skins[1].name);
end

function SendSkin(skin)
    TriggerServerEvent("skin_customization:ChoosenSkin",skin)
end

--Notification joueur
function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

AddEventHandler("skin_customization:Customization",function(skin)
    ChangeSkin(skin,nil)
	--Notify("Skin chargé")
	InitDrawMenu()
end)

AddEventHandler("skin_customization:OnDeath",function()
	print("ondeath")
	if isSpawnedInHospitalOnDeath then
		SetEntityCoords(GetPlayerPed(-1), 295.83, -1446.94, 29.97, 1, 0, 0, 1) -- Hospital
		print("spawn")
	end
	TriggerServerEvent("skin_customization:SpawnPlayer")
end)

RegisterNetEvent("skin_customization:updateComponents")
AddEventHandler("skin_customization:updateComponents",function(args)
		ChangeComponent({0,0,args[1],args[2]})-- 1:componentID; 2: page; 3: drawbleID; 4: textureID
		ChangeComponent({2,0,args[3],args[4]})
		ChangeComponent({4,0,args[5],args[6]})
		ChangeComponent({6,0,args[7],args[8]})
		ChangeComponent({11,0,args[9],args[10]})
		ChangeComponent({8,0,args[11],args[12]})
		Notify("Skin and loaded components")
end)

function InitDrawMenu()
	ClearMenu()
	Menu.addButton("Face","DrawableChoice",{0,0})
	Menu.addButton("Hair","DrawableChoice",{2,0})
	Menu.addButton("Torso","DrawableChoice",{11,0})
	Menu.addButton("T-shirt","DrawableChoice",{8,0})
	Menu.addButton("Trousers","DrawableChoice",{4,0})
	Menu.addButton("Shoes","DrawableChoice",{6,0})
end

function DrawableChoice(args)
	ClearMenu()
	local max = GetNumberOfPedDrawableVariations(GetPlayerPed(-1), args[1])

	if max > (args[2]+1)*8 then
		max = (args[2]+1)*8
	end
	if args[2] > 0 then
		Menu.addButton("Previous page","DrawableChoice",{args[1],args[2]-1})
	end
	for i = args[2]*8,max-1 do				
		Menu.addButton("Draw: "..i,"TextureChoice",{args[1],0,i})
	end
	if max <= (args[2]+1)*8 then
		Menu.addButton("Next page","DrawableChoice",{args[1],args[2]+1})
	end
	Menu.addButton("Return","InitDrawMenu","")
end

function TextureChoice(args)
	ClearMenu()
	local max = GetNumberOfPedTextureVariations(GetPlayerPed(-1),args[1],args[3])
	if max > (args[2]+1)*8 then
		max = (args[2]+1)*8
	end
	if args[2] > 0 then
		Menu.addButton("Previous page","TextureChoice",{args[1],args[2]-1,args[3]})
	end
	for i = args[2]*8,max-1 do
		if IsPedComponentVariationValid(GetPlayerPed(-1), args[1], args[3], i) then
			Menu.addButton("Text: "..i,"ChangeComponent",{args[1],args[2],args[3],i})
		end
	end
	if max <= (args[2]+1)*8 then
		Menu.addButton("Next page","TextureChoice",{args[1],args[2]+1,args[3]})
	end
	Menu.addButton("Return","DrawableChoice",args)
end

function ChangeComponent(args)-- 1:componentID; 2: page; 3: drawbleID; 4: textureID
	SetPedComponentVariation(GetPlayerPed(-1), args[1], args[3], args[4], 2)
	TriggerServerEvent("skin_customization:SaveComponents",args)
end

AddEventHandler('onPlayerDied', function(playerId, reason, position)
	print("ondeath")
	if isSpawnedInHospitalOnDeath then
		SetEntityCoords(GetPlayerPed(-1), 295.83, -1446.94, 29.97, 1, 0, 0, 1) -- Hospital
		print("spawn")
	end
	TriggerServerEvent("skin_customization:SpawnPlayer")
end)

--Action lors du spawn du joueur
local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
--On verifie que c'est bien le premier spawn du joueur
if firstspawn == 0 then
	TriggerServerEvent("skin_customization:SpawnPlayer")
	firstspawn = 1
end
end)

function ChangeSkin(skin,components)
	--Menu.hidden = true
	-- Get model hash.
	local modelhashed = GetHashKey(skin)

    
    -- Request the model, and wait further triggering untill fully loaded.
	RequestModel(modelhashed)
	while not HasModelLoaded(modelhashed) do 
	    RequestModel(modelhashed)
	    Citizen.Wait(0)
	end
    -- Set playermodel.
	SetPlayerModel(PlayerId(), modelhashed)

	if components == nil then
		local playerPed = GetPlayerPed(-1)
	 	--SET_PED_COMPONENT_VARIATION(Ped ped, int componentId, int drawableId, int textureId, int paletteId)
		 --SetPedComponentVariation(playerPed, 0, 0, 0, 2) --Face
		 --SetPedComponentVariation(playerPed, 2, 11, 4, 2) --Hair 
		 --SetPedComponentVariation(playerPed, 4, 1, 5, 2) -- Pantalon
		 --SetPedComponentVariation(playerPed, 6, 1, 0, 2) -- Shoes
		 --SetPedComponentVariation(playerPed, 11, 7, 2, 2) -- Jacket
		 TriggerServerEvent("skin_customization:ChoosenComponents")
	end
	  --local a = "" -- nil doesnt work
	  --TriggerServerEvent("weaponshop:playerSpawned",a)
	 -- TriggerServerEvent("item:getItems")
	SetModelAsNoLongerNeeded(modelhashed)
end

-- Citizen.CreateThread(function()
--	 while true do
--		 Citizen.Wait(0)
--		 if IsControlJustPressed(1, 289) then -- INPUT_CELLPHONE_DOWN
--			 InitMenu()                       
--			 Menu.hidden = not Menu.hidden    
--		 end
--		 Menu.renderGUI()
--	 end
-- end)