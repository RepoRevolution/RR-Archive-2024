---@diagnostic disable: param-type-mismatch
if not LOADED then return end

local custom = lib.require('client.custom')
if not custom then return end

local UI_READY, UI_LOADED = false, false
local camera, selectMode, spawned, threadId, mugshotLoaded, skinLoaded = nil, false, nil, nil, nil, nil
local CHARACTERS, SLOTS, IDENTIFIER = {}, 0, nil

RegisterNUICallback('ready', function(_, resultCallback)
    UI_READY = true

    local config = {
        allow_character_remove = Config.Characters.allow_character_remove,
        validation_data = Config.Identity.validation_data,
        nationalities = Config.Identity.nationalities,
        spawn_points = Config.Identity.spawn_points,
        classes = Config.Identity.classes,
        locale = lib.getLocales()
    }
    resultCallback(config)
end)

RegisterNUICallback('loaded', function(_, _)
    UI_LOADED = true
end)

local function getMugshotURL(ped, transparent)
    if not DoesEntityExist(ped) then return nil end
    local handle, txd = ESX.Game.GetPedMugshot(ped, transparent)
    if not txd then return nil end
    local url = ('https://nui-img/%s/%s'):format(txd, txd)

    mugshotLoaded = promise:new()
    SendNUIMessage({
        action = 'mugshot',
        url = url,
        handle = handle
    })

    return Citizen.Await(mugshotLoaded)
end

RegisterNUICallback('mugshot', function(data, _)
    if mugshotLoaded then
        UnregisterPedheadshot(data.handle)
        mugshotLoaded:resolve(data.url)
        mugshotLoaded = nil
    end
end)

Citizen.CreateThread(function()
    if ESX.PlayerLoaded then
        IDENTIFIER = ESX.PlayerData.identifier or nil
    end

    while not ESX.PlayerLoaded do
        if NetworkIsPlayerActive(PlayerId()) then
            exports['spawnmanager']:setAutoSpawn(false)
            TriggerEvent(RESOURCE .. ':client:characterSelection')
            break
        end
        Citizen.Wait(100)
    end
end)

local function changeSpawnCamera(playerPed, spawn)
    if camera then
        StartPlayerTeleport(PlayerId(), spawn.x, spawn.y, spawn.z, spawn.w or spawn.heading, false, true, true)
        repeat Citizen.Wait(100) until not IsPlayerTeleportActive()

        local height = GetEntityHeight(playerPed, spawn.x, spawn.y, spawn.z, false, false)
        local offset = GetOffsetFromEntityInWorldCoords(playerPed, GetPedType(playerPed) ~= 28 and 0 or 1.35, GetPedType(playerPed) ~= 28 and 0.75 or 1.25, height + 0.5)
        SetCamCoord(camera, offset.x, offset.y, offset.z)
        PointCamAtEntity(camera, playerPed, 0, 0, GetPedType(playerPed) ~= 28 and 0.5 or 0, false)
    end
end

RegisterNetEvent(RESOURCE .. ':client:characterSelection', function()
    DoScreenFadeOut(500)
    repeat Citizen.Wait(100) until IsScreenFadedOut() and UI_READY

    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeUI' })
    UI_LOADED = false
    spawned = false

    custom.pauseTimeSync(true)
    Citizen.Wait(500)
    TriggerServerEvent(RESOURCE .. ':server:virtualSoloSession', true)
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(camera, true)
    RenderScriptCams(true, false, 1, true, true)

    Citizen.CreateThread(function()
        selectMode = true
        MumbleSetVolumeOverride(PlayerId(), 0.0)
        while selectMode do
            DisableAllControlActions(0)
            SetPlayerInvincible(PlayerId(), true)
            ThefeedHideThisFrame()
            HideHudComponentThisFrame(11)
            HideHudComponentThisFrame(12)
            HideHudComponentThisFrame(21)
            HideHudAndRadarThisFrame()
            Citizen.Wait(0)
        end
        local playerId, playerPed = PlayerId(), PlayerPedId()
        MumbleSetVolumeOverride(playerId, -1.0)
        SetPlayerInvincible(playerId, false)
        FreezeEntityPosition(playerPed, false)
    end)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    TriggerEvent('esx:loadingScreenOff')
    Citizen.Wait(500)

    lib.callback(RESOURCE .. ':server:loadCharacters', false, function(characters, slots)
        exports['spawnmanager']:forceRespawn()
        CHARACTERS, SLOTS = characters, slots

        skinLoaded = promise:new()
        TriggerEvent('skinchanger:loadSkin', { sex = 0 }, function()
            skinLoaded:resolve()
        end)
        Citizen.Await(skinLoaded)

        local playerPed = PlayerPedId()
        SetPedAoBlobRendering(playerPed, false)
        SetEntityAlpha(playerPed, 0, false)
        changeSpawnCamera(playerPed, Config.Characters.character_create_position)

        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "openUI",
            characters = characters,
            slots = slots,
        })

        repeat Citizen.Wait(100) until UI_LOADED
        DoScreenFadeIn(500)
    end)
end)

RegisterNUICallback('changeSpawnCamera', function(spawnPointId, _)
    if selectMode and spawnPointId then
        local spawnPoint = Config.Identity.spawn_points[tonumber(spawnPointId) + 1]
        if not spawnPoint then return end

        if threadId and IsThreadActive(threadId) then TerminateThread(threadId) end
        Citizen.CreateThread(function()
            threadId = GetIdOfThisThread()
            DoScreenFadeOut(500)
            repeat Wait(100) until IsScreenFadedOut()

            local playerPed = PlayerPedId()
            local coords = spawnPoint.position
            changeSpawnCamera(playerPed, coords)

            DoScreenFadeIn(500)
            threadId = nil
        end)
    end
end)

local function correctSkin(skin)
    local count = 0
    for _ in pairs(skin) do
        count = count + 1
    end
    return count > 1
end

RegisterNUICallback('selectCharacter', function(characterId, callback)
    if selectMode then
        characterId = tonumber(characterId)
        if characterId == 0 then
            DoScreenFadeOut(500)
            repeat Citizen.Wait(100) until IsScreenFadedOut()

            skinLoaded = promise:new()
            TriggerEvent('skinchanger:loadSkin', { sex = 0 }, function()
                skinLoaded:resolve()
            end)
            Citizen.Await(skinLoaded)

            spawned = false
            local playerPed = PlayerPedId()
            SetPedAoBlobRendering(playerPed, false)
            SetEntityAlpha(playerPed, 0, false)
            TriggerEvent('esx_skin:resetFirstSpawn')
            callback(true)
        else
            local character = CHARACTERS[characterId]
            if character and spawned ~= characterId then
                if threadId and IsThreadActive(threadId) then TerminateThread(threadId) end
                Citizen.CreateThread(function()
                    threadId = GetIdOfThisThread()
                    spawned = characterId

                    DoScreenFadeOut(500)
                    repeat Citizen.Wait(100) until IsScreenFadedOut()

                    local playerPed = PlayerPedId()
                    local skin = character.skin or nil
                    if not skin or not next(skin) or not correctSkin(skin) then
                        local model = character.sex == 0 and 'mp_m_freemode_01' or 'mp_f_freemode_01'
                        skin = Config.Characters.default_skins[model]
                        skin.sex = character.sex
                        skin.model = model
                    end

                    skinLoaded = promise:new()
                    TriggerEvent('skinchanger:loadSkin', skin, function()
                        skinLoaded:resolve()
                    end)
                    Citizen.Await(skinLoaded)

                    playerPed = PlayerPedId()
                    local coords = character.position
                    if coords then
                        coords = vec4(coords.x, coords.y, coords.z, coords.heading)
                    else coords = Config.Characters.character_create_position end
                    changeSpawnCamera(playerPed, coords)

                    FreezeEntityPosition(playerPed, true)
                    SetPedAoBlobRendering(playerPed, true)
                    ResetEntityAlpha(playerPed)

                    DoScreenFadeIn(500)
                    callback(true)
                    threadId = nil
                end)
            end
        end
    end
end)

RegisterNUICallback('createCharacter', function(data, callback)
    if selectMode or (threadId and IsThreadActive(threadId)) then
        local slot do
            for i = 1, SLOTS do
                if not CHARACTERS[i] then
                    slot = i
                    break
                end
            end
        end
        if not slot then callback({ error = true, message = locale('invalidData') }) end

        lib.callback(RESOURCE .. ':server:createCharacter', false, function(response)
            if not response.error then
                TriggerEvent(RESOURCE .. ':client:characterSelection')
            end
            callback(response)
        end, slot, data)
    end
end)

RegisterNUICallback('deleteCharacter', function(characterId, callback)
    if selectMode and Config.Characters.allow_character_remove or (threadId and IsThreadActive(threadId)) then
        characterId = tonumber(characterId)
        if characterId > 0 then
            local character = CHARACTERS[characterId]
            if character then
                lib.callback(RESOURCE .. ':server:deleteCharacter', false, function(response)
                    callback(true)
                    if response then
                        TriggerEvent(RESOURCE .. ':client:characterSelection')
                    end
                end, characterId)
            end
        end
    end
end)

RegisterNUICallback('playCharacter', function(characterId, callback)
    if selectMode or (threadId and IsThreadActive(threadId)) then
        characterId = tonumber(characterId)
        if characterId > 0 then
            local character = CHARACTERS[characterId]
            if character and not character.disabled then
                DoScreenFadeOut(500)
                repeat Citizen.Wait(100) until IsScreenFadedOut()

                SetCamActive(camera, false)
                RenderScriptCams(false, false, 0, true, true)
                camera = nil

                SetNuiFocus(false, false)
                SendNUIMessage({
                    action = "closeUI"
                })
                UI_LOADED = false

                TriggerServerEvent(RESOURCE .. ':server:playCharacter', characterId)
                callback(true)
            end
        end
    end
end)

AddEventHandler('esx:playerLoaded', function(playerData, isNew, skin)
    if isNew or not skin or not correctSkin(skin) then
        isNew = true
        local sex = playerData.sex == "m" and 0 or 1
        skin.sex = sex

        local playerPed = PlayerPedId()
        local createPosition = Config.Characters.character_create_position
        StartPlayerTeleport(PlayerId(), createPosition.x, createPosition.y, createPosition.z, createPosition.w, false, true, true)
        repeat Citizen.Wait(100) until not IsPlayerTeleportActive()
        FreezeEntityPosition(playerPed, false)

        skinLoaded = promise:new()
        TriggerEvent('skinchanger:loadSkin', skin, function()
            playerPed = PlayerPedId()
            SetPedAoBlobRendering(playerPed, true)
            ResetEntityAlpha(playerPed)

            TriggerEvent('esx_skin:openSaveableMenu',
            function()
                DoScreenFadeOut(0)
                skinLoaded:resolve()
            end, function()
                DoScreenFadeOut(0)
                skinLoaded:resolve()
            end)

            Citizen.Wait(1500)
            DoScreenFadeIn(500)
        end)
        Citizen.Await(skinLoaded)

        playerPed = PlayerPedId()
        local coords = playerData.metadata.spawnPoint
        StartPlayerTeleport(PlayerId(), coords.x, coords.y, coords.z, coords.w, false, true, true)
        repeat Citizen.Wait(100) until not IsPlayerTeleportActive()
        TriggerServerEvent(RESOURCE .. ':server:characterRegistered')
    end
    TriggerServerEvent(RESOURCE .. ':server:virtualSoloSession', false)
    custom.pauseTimeSync(false)

    selectMode, spawned, threadId, skinLoaded = false, nil, nil, nil
    CHARACTERS, SLOTS = {}, 0

    DoScreenFadeIn(500)
    repeat Citizen.Wait(100) until IsScreenFadedIn()

    TriggerServerEvent('esx:onPlayerSpawn')
    TriggerEvent('esx:onPlayerSpawn')
    TriggerEvent('playerSpawned')
    TriggerEvent('esx:restoreLoadout')

    IDENTIFIER = playerData.identifier
end)

RegisterCommand('relog', function()
    if IDENTIFIER then
        TriggerServerEvent(RESOURCE .. ':server:relog')
    end
end, false)

RegisterNetEvent('esx:onPlayerLogout', function()
    custom.relog(cache.coords, IDENTIFIER)
    local mugshot = getMugshotURL(cache.ped, true)
    if IDENTIFIER and mugshot then
        TriggerServerEvent(RESOURCE .. ':server:updateMugshot', IDENTIFIER, mugshot)
    end
    IDENTIFIER = nil

    TriggerEvent(RESOURCE .. ':client:characterSelection')
    TriggerEvent('esx_skin:resetFirstSpawn')
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if ESX.PlayerLoaded and IDENTIFIER then
            sleep = sleep * 60 * 15
            local mugshot = getMugshotURL(cache.ped, true)
            if mugshot then
                TriggerServerEvent(RESOURCE .. ':server:updateMugshot', IDENTIFIER, mugshot)
            end
        end
        Citizen.Wait(sleep)
    end
end)