--====================================================================================
-- #Author: Jonathan D @ Gannon
-- 
-- Développée pour la communauté n3mtv
--      https://www.twitch.tv/n3mtv
--      https://twitter.com/n3m_tv
--      https://www.facebook.com/lan3mtv
--====================================================================================

local Menu = {}
local itemMenuGeneralPolice = {}
local itemMenuChoixPoliceService = {}
local itemMenuChoixPoliceVehicle = {}

local UrgencePoliceMenu = {['Title'] = 'Missions en cours',  ['SubMenu'] = {
    ['Title'] = 'Missions en cours', ['Items'] = {
        {['Title'] = 'Retour', ['ReturnBtn'] = true },
        {['Title'] = 'Fermer'},
}}}

function updateMenuPolice(newUrgenceMenu)
    itemMenuGeneralPolice.Items[1] = newUrgenceMenu
end

function openMenuPoliceGeneral() 
    Menu.item = itemMenuGeneralPolice
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceVehicleCar()
    Menu.item = itemMenuChoixPoliceVehicleCar
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceVehicleHeli()
    Menu.item = itemMenuChoixPoliceVehicleHeli
    Menu.isOpen = true
    Menu.initMenu()
end

function MenuChoixPoliceService()
    Menu.item = itemMenuChoixPoliceService
    Menu.isOpen = true
    Menu.initMenu()
end


itemMenuGeneralPolice = {
    ['Title'] = 'Police',
    ['Items'] = {
        UrgencePoliceMenu,
        {['Title'] = 'Fouiller', ['Function'] = POLICE_Check},
        {['Title'] = 'Menoter', ['Function'] = POLICE_Cuffed},
        {['Title'] = 'Placer dans le véhicle', ['Function'] = POLICE_PutInVehicle},
        {['Title'] = 'Sortir du véhicule', ['Function'] = POLICE_UnseatVehicle},
        {['Title'] = 'Amendes',  ['SubMenu'] = {
            ['Title'] = 'Amendes', 
            ['Items'] = {
                {['Title'] = 'Code de la Route',  ['SubMenu'] = { 
                    ['Title'] = 'Amendes - Code de la route', 
                    ['Items'] = {
                        {['Title'] = 'Non respect du code de la route', ['Function'] = POLICE_FINE_DATA, tarif = 100},
                        {['Title'] = 'Petit Excès de vitesse'	, ['Function'] = POLICE_FINE_DATA, tarif = 100},
                        {['Title'] = 'Grand Excès de vitesse'	, ['Function'] = POLICE_FINE_DATA, tarif = 400},
                        {['Title'] = 'Conduite dangereuse', ['Function'] = POLICE_FINE_DATA, tarif = 150},
                        {['Title'] = 'Véhicule trop endommagé', ['Function'] = POLICE_FINE_DATA, tarif = 250},
                        {['Title'] = 'Conduite état ivresse / drogue', ['Function'] = POLICE_FINE_DATA, tarif = 1500},
                        {['Title'] = 'Délit de fuite', ['Function'] = POLICE_FINE_DATA, tarif = 5000},
                    }
                }},
                {['Title'] = 'Délits et Crimes Pénal',  ['SubMenu'] = { 
                    ['Title'] = 'Amendes - Code de la route', 
                    ['Items'] = {
                        {['Title'] = 'Activités illicites', ['Function'] = POLICE_FINE_DATA, tarif = 5000},
                        {['Title'] = 'Violences', ['Function'] = POLICE_FINE_DATA, tarif = 5000},
                        {['Title'] = 'Vol de véhicule', ['Function'] = POLICE_FINE_DATA, tarif = 10000},
                        {['Title'] = 'Braquage', ['Function'] = POLICE_FINE_DATA, tarif = 15000},
                        {['Title'] = 'Dégradations', ['Function'] = POLICE_FINE_DATA, tarif = 5000},
                        {['Title'] = 'Outrage contre LSPD', ['Function'] = POLICE_FINE_DATA, tarif = 5000},
                        {['Title'] = 'Violence contre LSPD', ['Function'] = POLICE_FINE_DATA, tarif = 15000},
                        {['Title'] = 'Crimes', ['Function'] = POLICE_FINE_DATA, tarif = 70000},
                    }
                }},
                { ['Title'] = 'Autre', ['Function'] = POLICE_FINE_CUSTOM }, -- policier/chasseur
            }
        }},
        {['Title'] = 'Crocheter', ['Function'] = POLICE_Crocheter},
        {['Title'] = 'Verifier la plaque', ['Function'] = POLICE_CheckPlate},
		{['Title'] = 'Placer un Radar', ['Function'] = POLICE_radar},
		{['Title'] = 'Supprimer le Vehicule', ['Function'] = POLICE_deleteVehicle}
		
    }
}

itemMenuChoixPoliceVehicleCar = {
    ['Title'] = 'Police - Choix du véhicule',
    ['Items'] = {
        {['Title'] = 'Voiture', ['Function'] = POLICE_SpanwVehicleCar, type = 'Car', model = 'police3'},
        {['Title'] = 'Moto', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policeb'},
        {['Title'] = 'Transporter', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'policet'},
        {['Title'] = 'Filature', ['Function'] = POLICE_SpanwVehicleCar,  type = 'Car', model = 'police4'},
    }
}

itemMenuChoixPoliceVehicleHeli = {
    ['Title'] = 'Police - Choix du véhicule',
    ['Items'] = {
        {['Title'] = 'Helicoptère', ['Function'] = POLICE_invokeVehicle, type = 'Chopper', model = 'polmav'},
    }
}

itemMenuChoixPoliceService = {
    ['Title'] = 'Police - Vest',
    ['Items'] = {
        {['Title'] = 'Prendre le service', ['Function'] = takeService},
        {['Title'] = 'Prendre le service ( Investigation ) ', ['Function'] = takeServiceInvestigation},
        {['Title'] = 'Mettre le gillet par balles', ['Function'] = equipeVest, type = 'Bulletproof jacket'},
        {['Title'] = 'Retirer le giller par balles', ['Function'] = equipeVest, type = 'Take offbulletproof jacket'},
        {['Title'] = "Mettre chasuble jaune", ['Function'] = equipeVest, type = 'High-visibility clothing'},
        {['Title'] = "Retirer chasuble Jaune", ['Function'] = equipeVest, type = 'Take off High-visibility clothing'},
        {['Title'] = 'Quitter le service', ['Function'] = finishService},
    }
}

--====================================================================================
--  Option Menu
--====================================================================================
Menu.backgroundColor = { 52, 73, 94, 196 }
Menu.backgroundColorActive = {243, 156, 18, 255}
Menu.tileTextColor = {243, 156, 18, 255}
Menu.tileBackgroundColor = { 255,255,255, 255 }
Menu.textColor = { 255,255,255,255 }
Menu.textColorActive = { 255,255,255, 255 }

Menu.keyOpenMenu = 170 -- N+
Menu.keyUp = 172 -- PhoneUp
Menu.keyDown = 173 -- PhoneDown
Menu.keyLeft = 174 -- PhoneLeft || Not use next release Maybe 
Menu.keyRight =	175 -- PhoneRigth || Not use next release Maybe 
Menu.keySelect = 176 -- PhoneSelect
Menu.KeyCancel = 177 -- PhoneCancel
Menu.IgnoreNextKey = false
Menu.posX = 0.05
Menu.posY = 0.05

Menu.ItemWidth = 0.20
Menu.ItemHeight = 0.03

Menu.isOpen = false   -- /!\ Ne pas toucher
Menu.currentPos = {1} -- /!\ Ne pas toucher

--====================================================================================
--  Menu System
--====================================================================================

function Menu.drawRect(posX, posY, width, heigh, color)
    DrawRect(posX + width / 2, posY + heigh / 2, width, heigh, color[1], color[2], color[3], color[4])
end

function Menu.initText(textColor, font, scale)
    font = font or 0
    scale = scale or 0.35
    SetTextFont(font)
    SetTextScale(0.0,scale)
    SetTextCentre(true)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextColour(textColor[1], textColor[2], textColor[3], textColor[4])
    SetTextEntry("STRING")
end

function Menu.draw() 
    -- Draw Rect
    local pos = 0
    local menu = Menu.getCurrentMenu()
    local selectValue = Menu.currentPos[#Menu.currentPos]
    local nbItem = #menu.Items
    -- draw background title & title
    Menu.drawRect(Menu.posX, Menu.posY , Menu.ItemWidth, Menu.ItemHeight * 2, Menu.tileBackgroundColor)    
    Menu.initText(Menu.tileTextColor, 4, 0.7)
    AddTextComponentString(menu.Title)
    DrawText(Menu.posX + Menu.ItemWidth/2, Menu.posY)

    -- draw bakcground items
    Menu.drawRect(Menu.posX, Menu.posY + Menu.ItemHeight * 2, Menu.ItemWidth, Menu.ItemHeight + (nbItem-1)*Menu.ItemHeight, Menu.backgroundColor)
    -- draw all items
    for pos, value in pairs(menu.Items) do
        if pos == selectValue then
            Menu.drawRect(Menu.posX, Menu.posY + Menu.ItemHeight * (1+pos), Menu.ItemWidth, Menu.ItemHeight, Menu.backgroundColorActive)
            Menu.initText(Menu.textColorActive)
        else
            Menu.initText(value.TextColor or Menu.textColor)
        end
        AddTextComponentString(value.Title)
        DrawText(Menu.posX + Menu.ItemWidth/2, Menu.posY + Menu.ItemHeight * (pos+1))
    end
    
end

function Menu.getCurrentMenu()
    local currentMenu = Menu.item
    for i=1, #Menu.currentPos - 1 do
        local val = Menu.currentPos[i]
        currentMenu = currentMenu.Items[val].SubMenu
    end
    return currentMenu
end

function Menu.initMenu()
    Menu.currentPos = {1}
    Menu.IgnoreNextKey = true 
end

function Menu.keyControl()
    if Menu.IgnoreNextKey == true then
        Menu.IgnoreNextKey = false 
        return
    end
    if IsControlJustPressed(1, Menu.keyDown) then 
        local cMenu = Menu.getCurrentMenu()
        local size = #cMenu.Items
        local slcp = #Menu.currentPos
        Menu.currentPos[slcp] = (Menu.currentPos[slcp] % size) + 1

    elseif IsControlJustPressed(1, Menu.keyUp) then 
        local cMenu = Menu.getCurrentMenu()
        local size = #cMenu.Items
        local slcp = #Menu.currentPos
        Menu.currentPos[slcp] = ((Menu.currentPos[slcp] - 2 + size) % size) + 1

    elseif IsControlJustPressed(1, Menu.KeyCancel) then 
        table.remove(Menu.currentPos)
        if #Menu.currentPos == 0 then
            Menu.isOpen = false 
        end

    elseif IsControlJustPressed(1, Menu.keySelect)  then
        local cSelect = Menu.currentPos[#Menu.currentPos]
        local cMenu = Menu.getCurrentMenu()
        if cMenu.Items[cSelect].SubMenu ~= nil then
            Menu.currentPos[#Menu.currentPos + 1] = 1
        else
            if cMenu.Items[cSelect].ReturnBtn == true then
                table.remove(Menu.currentPos)
                if #Menu.currentPos == 0 then
                    Menu.isOpen = false 
                end
            else
                if cMenu.Items[cSelect].Function ~= nil then
                    cMenu.Items[cSelect].Function(cMenu.Items[cSelect])
                end
                if cMenu.Items[cSelect].Event ~= nil then
                    TriggerEvent(cMenu.Items[cSelect].Event, cMenu.Items[cSelect])
                end
                if cMenu.Items[cSelect].Close == nil or cMenu.Items[cSelect].Close == true then
                    Menu.isOpen = false
                end
            end
        end
    end

end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
        if IsControlJustPressed(1, Menu.keyOpenMenu) then
            Menu.isOpen = false
        end
        if Menu.isOpen then
            Menu.draw()
            Menu.keyControl()
        end
	end
end)
