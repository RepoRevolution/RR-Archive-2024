--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]] --
name 'rr_vehkeys'
author 'RepoRevolution | MineCop'
version '1.0.0'
description '[ESX/QB/Custom] Vehicle keys.'

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
	'server/database.lua',
	'server/main.lua',
}

client_scripts {
	'client/main.lua',
	'client/nui.lua',
	'client/modules/keys.lua',
	'client/modules/locks.lua',
	'client/modules/lockpick.lua',
	'client/modules/hotwire.lua',
	'client/modules/engine.lua',
	'client/modules/carjacking.lua'
}

files { 
	'nui/index.html',
	'nui/assets/*.js',
	'nui/assets/*.css',
	'locales/*.json',
	'client/framework.lua',
	'client/custom.lua'
}
ui_page 'nui/index.html'
-- ui_page 'http://localhost:5173/'

escrow_ignore {
	'config.lua',
	'config.logs.lua',
	'server/framework.lua',
	'client/framework.lua',
	'client/custom.lua'
}