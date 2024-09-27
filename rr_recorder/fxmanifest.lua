--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]] --
name 'rr_recorder'
author 'RepoRevolution | MineCop'
version '0.9.0'
description '[ESX/QB] Record and manage game footage with ease.'

--[[ Manifest ]] --
dependencies {
	'/onesync',
	'ox_lib',
	'utk_render'
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
	'init.lua'
}

server_script 'server/main.lua'
client_script 'client/main.lua'

files {
	'web/ui.html', 'web/assets/*.js', 'web/assets/*.css',
	'client/admincam.lua'
}
ui_page 'web/ui.html'

escrow_ignore {
	'config.lua'
}