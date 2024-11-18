ESX.Game = {}

function ESX.Game.GetPedMugshot(ped, transparent)
    if not DoesEntityExist(ped) then return end

    local mugshot = transparent and RegisterPedheadshotTransparent(ped) or RegisterPedheadshot(ped)

    while not IsPedheadshotReady(mugshot) do Citizen.Wait(0) end

    return mugshot, GetPedheadshotTxdString(mugshot)
end

function ESX.Game.Teleport(entity, coords, cb)
    local vector = type(coords) == 'vector4' and coords or type(coords) == 'vector3' and vector4(coords, 0.0) or vector4(coords.x, coords.y, coords.z, coords.heading or 0.0)

    if DoesEntityExist(entity) then
        RequestCollisionAtCoord(vector.x, vector.y, vector.z)

        while not HasCollisionLoadedAroundEntity(entity) do Citizen.Wait(0) end

        SetEntityCoords(entity, vector.x, vector.y, vector.z, false, false, false, false)
        SetEntityHeading(entity, vector.w)
    end

    return cb and cb()
end

function ESX.Game.SpawnObject(model, coords, cb, networked)
    networked = (networked == nil and true) or networked
    model = type(model) == 'number' and model or joaat(model)
    local typeCoords = type(coords)
    coords = (typeCoords == 'vector3' or typeCoords == 'vector4') and coords or vector4(coords.x, coords.y, coords.z, coords.w or coords.heading or 0.0)

    if networked then
        ESX.TriggerServerCallback('esx:onesync:spawnObject', function(netId)
            if cb then
                local entity = NetworkGetEntityFromNetworkId(netId)
                local attempt = 0

                while not DoesEntityExist(entity) do
                    entity = NetworkGetEntityFromNetworkId(netId)
                    attempt += 1
                    if attempt > 250 then break end
                    Citizen.Wait(0)
                end

                cb(entity)
            end
        end, model, coords, coords.w)
    else
        Citizen.CreateThread(function()
            ESX.Streaming.RequestModel(model)

            local entity = CreateObject(model, coords.x, coords.y, coords.z, networked, false, true)

            if cb then cb(entity) end
        end)
    end
end

function ESX.Game.SpawnLocalObject(model, coords, cb)
    ESX.Game.SpawnObject(model, coords, cb, false)
end

function ESX.Game.DeleteVehicle(vehicleEntity)
    SetEntityAsMissionEntity(vehicleEntity, true, true)
    DeleteVehicle(vehicleEntity)

    return DoesEntityExist(vehicleEntity)
end

function ESX.Game.DeleteObject(objectEntity)
    SetEntityAsMissionEntity(objectEntity, false, true)
    DeleteObject(objectEntity)

    return DoesEntityExist(objectEntity)
end

function ESX.Game.SpawnVehicle(vehicle, coords, heading, cb, networked)
    local model = type(vehicle) == 'number' and vehicle or joaat(vehicle)
    local vector = type(coords) == 'vector3' and coords or vec(coords.x, coords.y, coords.z)
    networked = networked == nil and true or networked

    local playerCoords = GetEntityCoords(cache.ped)

    if not vector or not playerCoords then return end

    local dist = #(playerCoords - vector)

    if dist > 424 then -- Onesync infinity Range (https://docs.fivem.net/docs/scripting-reference/onesync/)
        local executingResource = GetInvokingResource() or cache.resource
        return ESX.Print('error', ('Resource ^5%s^7 tried to spawn vehicle on the client but the position is too far away (Out of onesync range).'):format(executingResource))
    end

    Citizen.CreateThread(function()
        ESX.Streaming.RequestModel(model)

        local vehicleEntity = CreateVehicle(model, vector.x, vector.y, vector.z, heading, networked, true)

        if networked then
            local id = NetworkGetNetworkIdFromEntity(vehicleEntity)
            SetNetworkIdCanMigrate(id, true)
            SetEntityAsMissionEntity(vehicleEntity, true, true)
        end

        SetVehicleHasBeenOwnedByPlayer(vehicleEntity, true)
        SetVehicleNeedsToBeHotwired(vehicleEntity, false)
        SetModelAsNoLongerNeeded(model)
        SetVehRadioStation(vehicleEntity, 'OFF')

        while not HasCollisionLoadedAroundEntity(vehicleEntity) do
            RequestCollisionAtCoord(vector.x, vector.y, vector.z)
            Citizen.Wait(0)
        end

        if cb then
            cb(vehicleEntity)
        end
    end)
end

function ESX.Game.SpawnLocalVehicle(vehicle, coords, heading, cb)
    ESX.Game.SpawnVehicle(vehicle, coords, heading, cb, false)
end

function ESX.Game.IsVehicleEmpty(vehicle)
    local passengers = GetVehicleNumberOfPassengers(vehicle)
    local driverSeatFree = IsVehicleSeatFree(vehicle, -1)

    return passengers == 0 and driverSeatFree
end

function ESX.Game.GetObjects()
    return GetGamePool('CObject')
end

function ESX.Game.GetPeds(onlyOtherPeds)
    local myPed, pool = ESX.PlayerData.ped, GetGamePool('CPed')

    if not onlyOtherPeds then
        return pool
    end

    local peds = {}
    for i = 1, #pool do
        if pool[i] ~= myPed then
            peds[#peds + 1] = pool[i]
        end
    end

    return peds
end

function ESX.Game.GetVehicles()
    return GetGamePool('CVehicle')
end

function ESX.Game.GetPlayers(onlyOtherPlayers, returnKeyValue, returnPeds)
    local players, myPlayer = {}, PlayerId()

    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)

        if DoesEntityExist(ped) and ((onlyOtherPlayers and player ~= myPlayer) or not onlyOtherPlayers) then
            if returnKeyValue then
                players[player] = ped
            else
                players[#players + 1] = returnPeds and ped or player
            end
        end
    end

    return players
end

function ESX.Game.GetClosestObject(coords, modelFilter)
    return ESX.Game.GetClosestEntity(ESX.Game.GetObjects(), false, coords, modelFilter)
end

function ESX.Game.GetClosestPed(coords, modelFilter)
    return ESX.Game.GetClosestEntity(ESX.Game.GetPeds(true), false, coords, modelFilter)
end

function ESX.Game.GetClosestPlayer(coords)
    return ESX.Game.GetClosestEntity(ESX.Game.GetPlayers(true, true), true, coords, nil)
end

function ESX.Game.GetClosestVehicle(coords, modelFilter)
    return ESX.Game.GetClosestEntity(ESX.Game.GetVehicles(), false, coords, modelFilter)
end

local function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
    local nearbyEntities = {}

    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        local playerPed = ESX.PlayerData.ped
        coords = GetEntityCoords(playerPed)
    end

    for k, entity in pairs(entities) do
        local distance = #(coords - GetEntityCoords(entity))

        if distance <= maxDistance then
            nearbyEntities[#nearbyEntities + 1] = isPlayerEntities and k or entity
        end
    end

    return nearbyEntities
end

function ESX.Game.GetPlayersInArea(coords, maxDistance)
    return EnumerateEntitiesWithinDistance(ESX.Game.GetPlayers(true, true), true, coords, maxDistance)
end

function ESX.Game.GetVehiclesInArea(coords, maxDistance)
    return EnumerateEntitiesWithinDistance(ESX.Game.GetVehicles(), false, coords, maxDistance)
end

function ESX.Game.IsSpawnPointClear(coords, maxDistance)
    return #ESX.Game.GetVehiclesInArea(coords, maxDistance) == 0
end

function ESX.Game.GetClosestEntity(entities, isPlayerEntities, coords, modelFilter)
    local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        local playerPed = ESX.PlayerData.ped
        coords = GetEntityCoords(playerPed)
    end

    if modelFilter then
        filteredEntities = {}

        for _, entity in pairs(entities) do
            if modelFilter[GetEntityModel(entity)] then
                filteredEntities[#filteredEntities + 1] = entity
            end
        end
    end

    for k, entity in pairs(filteredEntities or entities) do
        local distance = #(coords - GetEntityCoords(entity))

        if closestEntityDistance == -1 or distance < closestEntityDistance then
            closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
        end
    end

    return closestEntity, closestEntityDistance
end

function ESX.Game.GetVehicleInDirection()
    local playerPed = ESX.PlayerData.ped
    local playerCoords = GetEntityCoords(playerPed)
    local inDirection = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(playerCoords.x, playerCoords.y, playerCoords.z, inDirection.x, inDirection.y, inDirection.z, 10, playerPed, 0)
    local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)

    if hit == 1 and GetEntityType(entityHit) == 2 then
        local entityCoords = GetEntityCoords(entityHit)
        return entityHit, entityCoords
    end

    return nil
end

function ESX.Game.GetVehicleProperties(vehicle)
    return lib.getVehicleProperties(vehicle)
end

function ESX.Game.SetVehicleProperties(vehicle, props)
    return lib.setVehicleProperties(vehicle, props)
end

ESX.Game.Utils = {}

function ESX.Game.Utils.DrawText3D(coords, text, size, font)
    local vector = type(coords) == 'vector3' and coords or vector3(coords.x, coords.y, coords.z)

    local camCoords = GetFinalRenderedCamCoord()
    local distance = #(vector - camCoords)

    if not size then size = 1 end
    if not font then font = 0 end

    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(font)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText('STRING')
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(vector.x, vector.y, vector.z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end
