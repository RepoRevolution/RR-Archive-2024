--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]] --
name 'pma-voice_addon'
author 'MineCop'
version '1.0.0'
description 'MineScripts Dev'

--[[ Manifest ]] --
dependencies {
	'/onesync',
	'pma-voice',
	'ox_lib'
}

shared_script '@ox_lib/init.lua'
client_scripts {
	'config.lua',
	'cl_windows.lua',
	'cl_voice.lua'
}
server_script 'sv_windows.lua'