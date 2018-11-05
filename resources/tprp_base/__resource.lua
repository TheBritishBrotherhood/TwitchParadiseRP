-- resource manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

-- dependency
dependency 'essentialmode'

-- client scripts
client_scripts {
    'client/pointing.lua',
    'client/stamina.lua',
    'client/ragdoll.lua',
    'client/carlock.lua',
    'client/heal.lua',
    'client/train_c.lua',
    'client/pause_menu.lua',
    'client/nowanted.lua',
    'client/no_drive_by.lua',
    'client/watermark.lua',
    'client/ipl.lua',
    'client/adverts_client.lua',
    'client/lock_c.lua',
    'client/cl_handsup.lua',
    'client/heli_client.lua',
    'client/es_pld.lua',
    'client/carwash_client.lua',
    'client/cl_voip.lua',
    'client/carhud.lua',
    --'client/CarState_c.lua',
    'client/weadrop_c.lua',
    'client/discord_c.lua',
    'client/jail_c.lua',
    --'client/localchat_c.lua',
    'frfuel.net.dll',
    'sirencontrols.net.dll'
}

-- server scripts
server_scripts {
    'server/train_s.lua',
    'server/ooc_s.lua',
    'server/adverts_server.lua',
    'server/lock_s.lua',
    'server/sv_handsup.lua',
    'server/heli_server.lua',
    'server/carwash_server.lua',
    'server/sv_voip.lua',
    'server/weadrop_s.lua',
    --'server/CarState.lua',
    'server/jail_s.lua',
    --'server/localchat_s.lua'
}

file "foodhud_config.ini"
file "config.ini"