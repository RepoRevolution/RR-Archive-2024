if not NUI then return end
NUI.ready = false
local inNUI = false

RegisterNUICallback('ready', function(_, resultCallback)
    NUI.ready = true
    resultCallback({
        locales = lib.getLocales()
    })
end)

function NUI.closeUI()
    SendNUIMessage({
        action = 'closeUI'
    })
    SetNuiFocus(false, false)
    inNUI = false
end

RegisterNUICallback('closeUI', function()
    NUI.closeUI()
end)

local function translateKeyType(keyType)
    if keyType == 'temp' then
        return 0
    elseif keyType == 'perm' then
        return 1
    elseif keyType == 'owned' then
        return 2
    else return 3 end
end

function NUI.updateKeys(keys)
    local list = {}

    for keyType, data in pairs(keys) do
        for _, key in ipairs(data) do
            table.insert(list, {
                type = translateKeyType(keyType),
                plate = key.plate,
                model = key.model,
                stolen = key.stolen,
                label = Client.getVehicleName(key.model)
            })
        end
    end

    local job = Client.Framework.getJob()
    for _, whitelisted in ipairs(Config.Locks.whitelisted) do
        if whitelisted.model then
            if not whitelisted.job
                or (type(whitelisted.job) == 'table' and lib.table.contains(whitelisted.job, job))
                or (type(whitelisted.job) == 'string' and whitelisted.job == job)
            then
                table.insert(list, {
                    type = translateKeyType('whls'),
                    plate = 'All plates',
                    model = whitelisted.model,
                    stolen = false,
                    label = Client.getVehicleName(whitelisted.model)
                })
            end
        end
    end
    
    SendNUIMessage({
        action = 'updateKeys',
        keys = list
    })
end

function NUI.updateNearbyPlayers(players)
    SendNUIMessage({
        action = 'updateNearbyPlayers',
        players = players
    })
end

function NUI.openKeysMenu(keys)
    NUI.updateKeys(keys)

    SendNUIMessage({
        action = 'openKeysMenu'
    })
    SetNuiFocus(true, true)

    inNUI = true
    Citizen.CreateThread(function()
        while inNUI do
            local coords, name = GetEntityCoords(cache.ped), 'Unknown character'
            local players = lib.getNearbyPlayers(coords, 5.0, true)

            local list = {}
            for _, player in ipairs(players) do
                local target = GetPlayerServerId(player.id)
                name = lib.callback.await(RESOURCE .. ':server:getCharacterName', false, target) or 'Unknown character'

                table.insert(list, {
                    id = target,
                    name = name
                })
            end

            NUI.updateNearbyPlayers(list)
            Citizen.Wait(2500)
        end
        NUI.updateNearbyPlayers({})
    end)
end

RegisterNUICallback('giveCopyKey', function(data)
    local vehicle, keyType = data.vehicle, data.keyType
    if not vehicle or not keyType then return end

    local target = data.target
    if not target then
        local coords = GetEntityCoords(cache.ped)
        target = lib.getClosestPlayer(coords, 2.0, false)
        if not target then
            Client.Custom.notify('error', 'no_player', locale('keys_give_no_target'))
            return
        end
        target = GetPlayerServerId(target.playerId)
    end

    TriggerServerEvent(RESOURCE .. ':server:giveCopyKey', target, vehicle.plate, vehicle.model, keyType)
end)

RegisterNUICallback('revokePermKeys', function(data)
    local vehicle = data.vehicle
    if not vehicle then return end
    TriggerServerEvent(RESOURCE .. ':server:revokePermKeys', vehicle.plate, vehicle.model)
end)

RegisterNUICallback('removeKey', function(data)
    local vehicle, keyType = data.vehicle, data.keyType
    if not vehicle or not keyType then return end
    TriggerServerEvent(RESOURCE .. ':server:removeKey', vehicle.plate, vehicle.model, keyType)
end)