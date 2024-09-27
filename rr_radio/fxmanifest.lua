--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]] --
name 'rr_radio'
author 'RepoRevolution | MineCop'
version '0.2.0'
description '[ESX] Radio communication system'

--[[ Manifest ]] --
dependencies {
	'/onesync',
	'oxmysql',
	'ox_lib',
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
	'init.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.logs.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua',
    'client/nui.lua'
}

files {
    'nui/index.html',
    'nui/app.js',
    'nui/*.ogg',
    'locales/*.json',
}
ui_page 'nui/index.html'

escrow_ignore {
	'config.lua',
	'config.logs.lua',
}