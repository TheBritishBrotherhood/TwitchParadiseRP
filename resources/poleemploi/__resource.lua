resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

dependency 'essentialmode'

--ui_page 'gui/ui.html'


client_script {
	--'gui/gui.lua',
	'metiers_config.lua',
}

server_script {
	'../essentialmode/config.lua',
	'metiers_server.lua',
}

export 'getIsInService'

