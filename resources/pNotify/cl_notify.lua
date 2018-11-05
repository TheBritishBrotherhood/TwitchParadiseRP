--[[
Complete List of Options:
        type
        layout
        theme
        text
        timeout
        progressBar
        closeWith
        animation = {
            open
            close
        }
        sounds = {
            volume
            conditions
            sources
        }
        docTitle = {
            conditions
        }
        modal
        id
        force
        queue
        killer
        container
        buttons

More details below or visit the creators website http://ned.im/noty/options.html

Layouts:
    top
    topLeft
    topCenter
    topRight
    center
    centerLeft
    centerRight
    bottom
    bottomLeft
    bottomCenter
    bottomRight

Types:
    alert
    success
    error
    warning
    info

Themes: -- You can create more themes inside html/themes.css, use the gta theme as a template.
    gta
    mint
    relax
    metroui

Animations:
    open:
        noty_effects_open
        gta_effects_open
    close:
        noty_effects_close
        gta_effects_close

closeWith: -- array, You will probably never use this.
    click
    button

sounds:
    volume: 0.0 - 1.0
    conditions: -- array
        docVisible
        docHidden
    sources: -- array of sound files

modal:
    true
    false

force:
    true
    false

queue: -- default is global, you can make it what ever you want though.
    global

killer: -- will close all visible notification and show only this one
    true
    false

visit the creators website http://ned.im/noty/options.html for more information
--]]

function SetQueueMax(queue, max)
    local tmp = {
        queue = tostring(queue),
        max = tonumber(max)
    }

    SendNUIMessage({maxNotifications = tmp})
end

function SendNotification(options)
    options.animation = options.animation or {}
    options.sounds = options.sounds or {}
    options.docTitle = options.docTitle or {}

    local options = {
        type = options.type or "success",
        layout = options.layout or "centerLeft",
        theme = options.theme or "gta",
        text = options.text or "Notifacation: Vehicle Locked",
        timeout = options.timeout or 5000,
        progressBar = options.progressBar or true,
        sounds = {
            volume = options.sounds.volume or 1,
            conditions = options.sounds.conditions or {},
            sources = options.sounds.sources or {}
        },
        modal = options.modal or false, --Creates dark overlay
        force = options.force or false,
        queue = options.queue or "source",
        killer = options.killer or true,
        container = options.container or false,
        buttons = options.button or false
    }

    SendNUIMessage({options = options})
end

RegisterNetEvent("pNotify:SendNotification")
AddEventHandler("pNotify:SendNotification", function(options)
    SendNotification(options)
end)

RegisterNetEvent("pNotify:SetQueueMax")
AddEventHandler("pNotify:SetQueueMax", function(queue, max)
    SetQueueMax(queue, max)
end)
