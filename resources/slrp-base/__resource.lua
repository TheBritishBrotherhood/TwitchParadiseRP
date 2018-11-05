-- resource_type 'gametype' { name = 'www.seedlessrp.com'}
resource_type 'gametype' { name = 'fs_freeroam'}

description 'FiveM'

-- Manifest
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-- Requiring essentialmode
dependency 'essentialmode'

-- General
client_scripts {
  'client.lua',
  'events/smoke.lua',
  --'events/fleecaJob.lua',
  'player/map.lua',
  'player/scoreboard.lua',
  'stores/stripclub.lua',
  'stores/vehshop.lua',
  'stores/taqilala.lua',
}

server_scripts {
  'config.lua',
  'server.lua',
  'player/commands.lua',
  'stores/vehshop_s.lua',
}
