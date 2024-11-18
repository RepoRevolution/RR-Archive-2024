ESX = {}
ESX.UI = {}
ESX.PlayerData = {}
ESX.PlayerLoaded = false
Client = {}

exports('getSharedObject', function()
    return ESX
end)

local export = lib.require('modules.export')
export.createESX('getSharedObject', function()
    return ESX
end)

function ESX.GetConfig() ---@diagnostic disable-line: duplicate-set-field
    return Config
end

lib.require('modules.safeEvent.client')