--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]] --
name 'rr_characters'
author 'RepoRevolution | MineCop'
version '1.0.3'
description '[ESX] Characters and identity system.'

--[[ Manifest ]] --
dependencies {
	'/onesync',
	'oxmysql',
	'ox_lib',
	'es_extended',
	'esx_skin'
}

provide { 'esx_multicharacter' }

shared_scripts {
	'@ox_lib/init.lua',
	'@es_extended/imports.lua',
	'config.lua',
	'init.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.logs.lua',
	'server/database.lua',
	'server/main.lua'
}

client_script 'client/main.lua'

files {
	'web/ui.html', 'web/images/*.png', 'web/assets/*.js', 'web/assets/*.css', 'locales/*.json', 
	'client/custom.lua'
}
-- ui_page 'web/ui.html'
ui_page 'http://localhost:5173/'

escrow_ignore {
	'config.lua',
	'config.logs.lua',
	'client/custom.lua',
}