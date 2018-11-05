resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

dependency 'essentialmode'

ui_page 'gui/ui.html'

files {
	--'gui/ui.html',
	'gui/job-icon.png',
	'gui/pricedown.ttf',
	"gui/chomeur.png",
	"gui/mineur.png",
	"gui/bucheron.png",
	"gui/fermier.png",
	"gui/pecheur.png",
	"gui/brasseur.png",
	"gui/vigneron.png",
	"gui/ambulancier.png",
	"gui/mecano.png",
	"gui/taxi.png",
}

client_script {
	'gui/gui.lua',
	'poleemploi/metiers_config.lua',
	'chomeur/chomeur_config.lua',
	'fermier/fermier_config.lua',
	'bucheron/bucheron_config.lua',
	'mineur/mineur_config.lua',
	'pecheur/pecheur_config.lua',
	'vigneron/vigneron_config.lua',
	'brasseur/brasseur_config.lua',
	'poleemploi/metiers_client.lua',
	'chomeur/chomeur_client.lua',
	'fermier/fermier_client.lua',
	'bucheron/bucheron_client.lua',
	'mineur/mineur_client.lua',
	'pecheur/pecheur_client.lua',
	'vigneron/vigneron_client.lua',
	'brasseur/brasseur_client.lua',
	'mecano/mecano_client.lua',
	'mecano/mecano_Menu.lua',
}

server_script {
	'../essentialmode/config.lua',
	'poleemploi/metiers_server.lua',
	'chomeur/chomeur_server.lua',
	'fermier/fermier_server.lua',
	'bucheron/bucheron_server.lua',
	'mineur/mineur_server.lua',
	'pecheur/pecheur_server.lua',
	'vigneron/vigneron_config.lua',
	'vigneron/vigneron_server.lua',
	'brasseur/brasseur_config.lua',
	'brasseur/brasseur_server.lua',
	'mecano/mecano_server.lua',
}

export 'getIsInService'

