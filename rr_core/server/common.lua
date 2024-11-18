if not LOADED then return end

ESX = {}
ESX.Players = {}
ESX.Items = {}
Server = {}
Server.DatabaseConnected = false
Server.PlayersByCid = {} --[[@type table<string, xPlayer> ]]
Server.PlayersByIdentifier = {} --[[@type table<string, xPlayer> ]]
Server.Vehicles = {} --[[@type table<number, xVehicle> ]]
Server.UsableItemsCallbacks = {}
Server.Pickups = {}
Server.PickupId = 0

exports('getSharedObject', function()
    return ESX
end)

local export = lib.require('modules.export')
export.createESX('getSharedObject', function()
    return ESX
end)

local function startDBSync()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10 * 60 * 1000)

            Server.SavePlayers()
        end
    end)
end

MySQL.ready(function()
    if not Config.OxInventory then
        local items = MySQL.query.await('SELECT * FROM items')
        for _, v in ipairs(items) do
            ESX.Items[v.name] = { label = v.label, weight = v.weight, rare = v.rare, canRemove = v.can_remove }
        end
    else
        TriggerEvent('__cfx_export_ox_inventory_Items', function(ref)
            if ref then
                ESX.Items = ref()
            end
        end)

        AddEventHandler('ox_inventory:itemList', function(items)
            ESX.Items = items
        end)

        while not next(ESX.Items) do
            Citizen.Wait(0)
        end
    end

    while not ESX.RefreshJobs or not ESX.RefreshGroups do Citizen.Wait(0) end
    ESX.RefreshJobs()

    ESX.Trace(('rr_core by ^5Overextended & RepoRevolution v%s^0 initialized!'):format(GetResourceMetadata(cache.resource, 'version', 0)))

    -- if Config.EnablePaycheck then
    --     StartPayCheck()
    -- end

    startDBSync()
    Server.DatabaseConnected = true
end)

function ESX.GetConfig() ---@diagnostic disable-line: duplicate-set-field
    return Config
end

lib.require('modules.hooks.server')
lib.require('modules.override.server')
lib.require('modules.safeEvent.server')