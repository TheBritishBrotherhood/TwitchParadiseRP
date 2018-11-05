--====================================================================================
-- #Author: Jonathan D @ Gannon
-- 
-- Développée pour la communauté n3mtv
--      https://www.twitch.tv/n3mtv
--      https://twitter.com/n3m_tv
--      https://www.facebook.com/lan3mtv
--====================================================================================





--===================================================================================================================================================--
--                Build Menu -- playAmination = joue l'aniamtion une fois et playAminationLoop pour jouer l'animation en boucle.                     -- 
-- site des emotes = http://docs.ragepluginhook.net/html/62951c37-a440-478c-b389-c471230ddfc5.htm#amb@code_human_wander_idles_cop@male@staticSection --
--===================================================================================================================================================--
local KeyOpenJobsMenu = 166 -- F5
local currentJobs = ''
local hasMenuJob = false
RegisterNetEvent('metiers:updateJob')
AddEventHandler('metiers:updateJob', function(nameJob)
    if hasMenuJob then
        table.remove(Menu.item.Items, 1)
    end
    hasMenuJob = false

    if nameJob == 'Policier' or 
       nameJob == 'Ambulancier' or 
       nameJob == 'Taxi' or 
       nameJob == 'Mecano' then
       table.insert(Menu.item.Items, 1, {['Title'] = 'Menu ' .. nameJob, ['Function'] = openMenuJobs } )
       hasMenuJob = true
       --Citizen.Trace('-----------------------')
    end
    if nameJob == 'Policier' then
        currentJobs = 'police'
    else
        currentJobs = string.lower(nameJob)
    end
end)

function openMenuJobs()
    TriggerEvent(currentJobs .. ':openMenu')
end

Menu = {}
Menu.item = {
    ['Title'] = 'Interactions',
    ['Items'] = {
        {['Title'] = 'Personnel', ['SubMenu'] = {
            ['Title'] = 'Menu',
                ['Items'] = {
                    { ['Title'] = 'Check ID', ['Event'] = 'gcl:openMeIdentity'},
					{ ['Title'] = 'Show ID', ['Event'] = 'gcl:showItentity'},
                }
            }
        },
		{['Title'] = 'Telephone' , ['Event'] = 'phone:toggleMenu'},
        {['Title'] = 'Emote', ['SubMenu'] = {
            ['Title'] = 'Menu',
            ['Items'] = {
                { ['Title'] = 'Flail', ['Function'] = playAminationLoop, ['dictionaries'] = "nm@hands", ['clip'] = 'flail' },
                { ['Title'] = 'Greet', ['SubMenu'] = {
                    ['Title'] = 'Greet Emotes',
                    ['Items'] = {
                        { ['Title'] = "Shake Hand", Function = playAmination ,  dictionaries = "mp_common", clip = 'givetake1_a'},
                        { ['Title'] = "Wave",   Function = playAmination ,  dictionaries = "gestures@m@standing@casual", clip = "gesture_hello" },
                        { ['Title'] = "High 5", Function = playAmination , dictionaries = "mp_ped_interaction", clip = "highfive_guy_a" },
                        { ['Title'] = "Salute", Function = playAmination , dictionaries = "mp_player_int_uppersalute", clip = "mp_player_int_salute" },
                    }
                }},
                { ['Title'] = 'Humor', ['SubMenu'] = {
                    ['Title'] = 'Humor Emotes',
                    ['Items'] = {
                        { ['Title'] = "Clap", Function = playEmote, ['EmoteName'] = "WORLD_HUMAN_CHEERING"},
                        { ['Title'] = "Wanker", Function = playAmination ,  dictionaries = "mp_player_int_upperwank", clip = "mp_player_int_wank_01" },
                        { ['Title'] = "Dammed ", Function = playAmination ,  dictionaries = "gestures@m@standing@casual", clip = "gesture_damn" },
                        { ['Title'] = "Calm Down ", Function = playAmination ,  dictionaries = "gestures@m@standing@casual", clip = "gesture_easy_now" },
                        { ['Title'] = "No way", Function = playAmination ,  dictionaries = "gestures@m@standing@casual", clip = "gesture_no_way" },
                        { ['Title'] = "Flip the Bird", Function = playAmination ,  dictionaries = "mp_player_int_upperfinger", clip = "mp_player_int_finger_01_enter" },
						{ ['Title'] = 'Give the finger', ['Function'] = playAmination, ['dictionaries'] = "mp_player_intfinger", ['clip'] = 'mp_player_int_finger' },
                        { ['Title'] = "Suicid Emote", Function = playAmination ,  dictionaries = "mp_suicide", clip = "pistol" },
                        { ['Title'] = "Super", Function = playAmination ,  dictionaries = "mp_action", clip = "thanks_male_06" },
                        { ['Title'] = "Embrace", Function = playAmination ,  dictionaries = "mp_ped_interaction", clip = "kisses_guy_a" },
						{ ['Title'] = 'Hands Up', ['Function'] = playAmination, ['dictionaries'] = "missminuteman_1ig_2", ['clip'] = 'handsup_base' },
						{ ['Title'] = 'Wave', ['Function'] = playAmination, ['dictionaries'] = "friends@frj@ig_1", ['clip'] = 'wave_e' },
                    }
                }},
                { ['Title'] = 'Sports', ['SubMenu'] = {
                    ['Title'] = 'Sports Emotes',
                    ['Items'] = {
                        { ['Title'] = "Yoga", Function = playEmote, ['EmoteName'] = "WORLD_HUMAN_YOGA"},
                        { ['Title'] = "Jogging", Function = playEmote, ['EmoteName'] = "WORLD_HUMAN_JOG_STANDING"},
                        { ['Title'] = "Push-ups", Function = playEmote, ['EmoteName'] = "WORLD_HUMAN_PUSH_UPS"},
                    }
                }},
                { ['Title'] = 'Festive', ['SubMenu'] = {
                    ['Title'] = 'Festive Emotes',
                    ['Items'] = {
                        { ['Title'] = "Drink", Function = playEmote, ['EmoteName'] = "WORLD_HUMAN_DRINKING"},
                        { ['Title'] = "Camp fire warmth", Function = playEmote, ['EmoteName'] = "WORLD_HUMAN_STAND_FIRE"},
                        { ['Title'] = "Play music", Function = playEmote, ['EmoteName'] = "WORLD_HUMAN_MUSICIAN"},
                    }
                }},
				{ ['Title'] = 'Stike a pose', ['SubMenu'] = {
                    ['Title'] = 'Pose Emotes',
                    ['Items'] = {
						{ ['Title'] = 'Lean on counter', ['Function'] = playEmote, ['EmoteName'] = 'PROP_HUMAN_BUM_SHOPPING_CART' },
						{ ['Title'] = 'Sit on the floor', ['Function'] = playEmote, ['EmoteName'] = 'WORLD_HUMAN_PICNIC' },
						{ ['Title'] = 'Lie on belly', ['Function'] = playEmote, ['EmoteName'] = 'WORLD_HUMAN_SUNBATHE' },
						{ ['Title'] = 'Lie on back', ['Function'] = playEmote, ['EmoteName'] = 'WORLD_HUMAN_SUNBATHE_BACK' },
                    }
                }},
                { ['Title'] = 'Other', ['SubMenu'] = {
                    ['Title'] = 'Other Emotes',
                    ['Items'] = {
						{ ['Title'] = 'Yes', ['Function'] = playAmination, ['dictionaries'] = "gestures@m@standing@casual", ['clip'] = 'gesture_pleased' }, 
						{ ['Title'] = 'No', ['Function'] = playAmination, ['dictionaries'] = "gestures@m@standing@casual", ['clip'] = 'gesture_head_no' },
                        { ['Title'] = "Welding", Function = playEmote, ['EmoteName'] = "WORLD_HUMAN_WELDING"},
                        { ['Title'] = "Take notes", Function = playEmote, ['EmoteName'] = "WORLD_HUMAN_CLIPBOARD"},
                        { ['Title'] = "Sit Chair", Function = playEmote, ['EmoteName'] = "PROP_HUMAN_SEAT_CHAIR"},
                        { ['Title'] = "Smoke", Function = playEmote, ['EmoteName'] = "WORLD_HUMAN_SMOKING"},
                        { ['Title'] = "Check Wrist Watch",   Function = playAmination ,  dictionaries = "amb@world_human_vehicle_mechanic@male@idle_a", clip = "WORLD_HUMAN_VEHICLE_MECHANIC" },
                        { ['Title'] = "Garb dez nuts", Function = playAmination , dictionaries = "mp_player_int_uppergrab_crotch", clip = "mp_player_int_grab_crotch" },
                        { ['Title'] = "Rock and Roll", Function = playAmination , dictionaries = "mp_player_int_upperrock", clip = "mp_player_int_rock" },
						{ ['Title'] = 'Selfie', ['Function'] = playEmote, ['EmoteName'] = 'WORLD_HUMAN_TOURIST_MOBILE' },
						{ ['Title'] = 'Portable', ['Function'] = playEmote, ['EmoteName'] = 'WORLD_HUMAN_STAND_MOBILE' },
                    }
                }},
				{ ['Title'] = 'Work', ['SubMenu'] = {
					['Title'] = 'Work Emots',
					['Items'] = {
						{ ['Title'] = 'Drill', ['Function'] = playEmote, ['EmoteName'] = 'WORLD_HUMAN_CONST_DRILL' }, -- mineur
						{ ['Title'] = 'Cop', ['Function'] = playEmote, ['EmoteName'] = 'WORLD_HUMAN_COP_IDLES' }, -- Police
						{ ['Title'] = 'Traffic', ['Function'] = playEmote, ['EmoteName'] = 'WORLD_HUMAN_CAR_PARK_ATTENDANT' }, -- police
						{ ['Title'] = 'Leaf Blower', ['Function'] = playEmote, ['EmoteName'] = 'WORLD_HUMAN_GARDENER_LEAF_BLOWER' }, -- Jardinier
						{ ['Title'] = 'Gardener', ['Function'] = playEmote, ['EmoteName'] = 'WORLD_HUMAN_GARDENER_PLANT' }, -- Jardinier
						{ ['Title'] = 'Fishing', ['Function'] = playEmote, ['EmoteName'] = 'WORLD_HUMAN_STAND_FISHING' }, -- P?cheur
						{ ['Title'] = 'Soulder', ['Function'] = playEmote, ['EmoteName'] = 'WORLD_HUMAN_WELDING' }, -- soudeur / crochetage
						{ ['Title'] = 'Examin victim', ['Function'] = playEmote, ['EmoteName'] = 'CODE_HUMAN_MEDIC_KNEEL' }, -- Pour medecin et ambulancier
						{ ['Title'] = 'Examin victim 2', ['Function'] = playEmote, ['EmoteName'] = 'CODE_HUMAN_MEDIC_TEND_TO_DEAD' }, -- Pour medecin et ambulancier
						{ ['Title'] = 'Time of death', ['Function'] = playEmote, ['EmoteName'] = 'CODE_HUMAN_MEDIC_TIME_OF_DEATH' }, -- Verbaliser
						{ ['Title'] = 'Binoculars', ['Function'] = playEmote, ['EmoteName']  = 'WORLD_HUMAN_BINOCULARS' }, -- policier/chasseur
					}
				}},
            },
        }},
		--{ ['Title'] = 'Piss', ['Event'] = 'gabs:enviepipi'},
		--{ ['Title'] = 'Add / Remove Hat', ['Event'] = 'accessories_switcher:toggleHat',['Close'] = false},
		--{ ['Title'] = 'Add / Remove Glasses', ['Event'] = 'accessories_switcher:toggleGlasses',['Close'] = false},
        { ['Title'] = 'Cancel Emote', ['Event'] = 'gc:clearAmination'},
		--{ ['Title'] = 'Suicide / Respawn', ['Event'] = 'ambulancier:selfRespawn'},
    }
}
--====================================================================================
--  Option Menu
--====================================================================================
Menu.backgroundColor = { 52, 73, 94, 196 }
Menu.backgroundColorActive = { 22, 160, 134, 255 }
Menu.tileTextColor = { 22, 160, 134, 255 }
Menu.tileBackgroundColor = { 255,255,255, 255 }
Menu.textColor = { 255,255,255,255 }
Menu.textColorActive = { 255,255,255, 255 }

Menu.keyOpenMenu = 57 -- F3    
Menu.keyUp = 172 -- PhoneUp
Menu.keyDown = 173 -- PhoneDown
Menu.keyLeft = 174 -- PhoneLeft || Not use next release Maybe 
Menu.keyRight =	175 -- PhoneRigth || Not use next release Maybe 
Menu.keySelect = 176 -- PhoneSelect
Menu.KeyCancel = 177 -- PhoneCancel

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
            Menu.initText(Menu.textColor)
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
    for i,v in ipairs(Menu.item.Items)do
            if( v['Title'] == 'Ambulancier')then
                table.remove(Menu.item.Items,i)
                
            end
    end
    TriggerEvent("ambulancier:menu")
    Menu.currentPos = {1}
    
end

function Menu.keyControl()
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(1, Menu.keyOpenMenu) then
            Menu.initMenu()
            Menu.isOpen = not Menu.isOpen
        end
        if Menu.isOpen then
            Menu.draw()
            Menu.keyControl()
        end
        if IsControlJustPressed(1, KeyOpenJobsMenu) then
            openMenuJobs()
        end
    end
end)