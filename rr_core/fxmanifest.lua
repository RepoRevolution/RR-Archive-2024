--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]] --
name 'rr_core'
author 'RepoRevolution'
version '0.1.0'

--[[ Manifest ]] --
dependencies {
    '/server:9282',
    '/gameBuild:3258',
    '/onesync',
	'oxmysql',
	'ox_lib'
}

provides {
    'es_extended'
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
    'init.lua',
    'config.weapons.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.logs.lua',
    'server/common.lua',
    'server/functions.lua',
    'modules/**/*shared*.lua',
    'modules/**/*server*.lua',
    'server/classes/**/*.lua',
    'server/events.lua',
    -- 'server/paycheck.lua',
    'server/main.lua',
    -- 'server/commands.lua'
}

client_scripts {
    'client/common.lua',
    'client/functions.lua',
    'modules/**/*shared*.lua',
    'modules/**/*client*.lua',
    'client/events.lua',
    'client/main.lua'
}

files {
    'modules/export.lua',
    'files/*.*',
    'locales/*.json',
    'imports.lua'
}
