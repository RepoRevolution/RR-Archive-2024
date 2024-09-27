--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]] --
name 'rr_inflation'
author 'RepoRevolution | MineCop'
version '1.2.5'
description '[STANDALONE] Inflation system.'

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
	'server.lua'
}

client_script 'client.lua'

escrow_ignore {
	'config.lua',
	'config.logs.lua',
}