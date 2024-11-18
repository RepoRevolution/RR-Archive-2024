local pickups = {}

Citizen.CreateThread(function()
    while not MULTICHAR do
        Citizen.Wait(100)

        if NetworkIsPlayerActive(PlayerId()) then
            DoScreenFadeOut(0)
            Citizen.Wait(500)
            TriggerServerEvent('esx:onPlayerJoined')
            break
        end
    end
end)

AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
    ESX.PlayerData = xPlayer

    if not MULTICHAR then
        exports.rr_core:spawnPlayer({
            x = ESX.PlayerData.coords.x,
            y = ESX.PlayerData.coords.y,
            z = ESX.PlayerData.coords.z + 0.25,
            heading = ESX.PlayerData.coords.heading,
            model = `mp_m_freemode_01`
        })

        TriggerServerEvent('esx:onPlayerSpawn')

        TriggerEvent('esx:onPlayerSpawn')
        TriggerEvent('esx:restoreLoadout')

        if isNew then
            TriggerEvent('skinchanger:loadDefaultModel', skin.sex == 0)
        elseif skin then
            TriggerEvent('skinchanger:loadSkin', skin)
        end

        TriggerEvent('esx:loadingScreenOff')

        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
    end

    while not DoesEntityExist(ESX.PlayerData.ped) do Citizen.Wait(20) end
    ESX.PlayerLoaded = true

    local metadata = ESX.PlayerData.metadata

    if metadata.health then
        SetEntityHealth(ESX.PlayerData.ped, metadata.health)
    end

    if metadata.armor and metadata.armor > 0 then
        SetPedArmour(ESX.PlayerData.ped, metadata.armor)
    end

    local timer = GetGameTimer()
    while not HaveAllStreamingRequestsCompleted(ESX.PlayerData.ped) and (GetGameTimer() - timer) < 2000 do Citizen.Wait(0) end

    if Config.Player.enable_pvp then
        SetCanAttackFriendly(ESX.PlayerData.ped, true, false)
        NetworkSetFriendlyFireOption(true)
    end

    if Config.Player.disable_vehicle_shuff then
        SetPedConfigFlag(ESX.PlayerData.ped, 184, true)
    end

    if Config.Player.disable_dispatch_services then
        for i = 1, 15 do
            EnableDispatchService(i, false)
        end
    end

    if Config.Player.disable_scenarios then
        local scenarios = {
            "WORLD_VEHICLE_ATTRACTOR",
            "WORLD_VEHICLE_AMBULANCE",
            "WORLD_VEHICLE_BICYCLE_BMX",
            "WORLD_VEHICLE_BICYCLE_BMX_BALLAS",
            "WORLD_VEHICLE_BICYCLE_BMX_FAMILY",
            "WORLD_VEHICLE_BICYCLE_BMX_HARMONY",
            "WORLD_VEHICLE_BICYCLE_BMX_VAGOS",
            "WORLD_VEHICLE_BICYCLE_MOUNTAIN",
            "WORLD_VEHICLE_BICYCLE_ROAD",
            "WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",
            "WORLD_VEHICLE_BIKER",
            "WORLD_VEHICLE_BOAT_IDLE",
            "WORLD_VEHICLE_BOAT_IDLE_ALAMO",
            "WORLD_VEHICLE_BOAT_IDLE_MARQUIS",
            "WORLD_VEHICLE_BOAT_IDLE_MARQUIS",
            "WORLD_VEHICLE_BROKEN_DOWN",
            "WORLD_VEHICLE_BUSINESSMEN",
            "WORLD_VEHICLE_HELI_LIFEGUARD",
            "WORLD_VEHICLE_CLUCKIN_BELL_TRAILER",
            "WORLD_VEHICLE_CONSTRUCTION_SOLO",
            "WORLD_VEHICLE_CONSTRUCTION_PASSENGERS",
            "WORLD_VEHICLE_DRIVE_PASSENGERS",
            "WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED",
            "WORLD_VEHICLE_DRIVE_SOLO",
            "WORLD_VEHICLE_FIRE_TRUCK",
            "WORLD_VEHICLE_EMPTY",
            "WORLD_VEHICLE_MARIACHI",
            "WORLD_VEHICLE_MECHANIC",
            "WORLD_VEHICLE_MILITARY_PLANES_BIG",
            "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
            "WORLD_VEHICLE_PARK_PARALLEL",
            "WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN",
            "WORLD_VEHICLE_PASSENGER_EXIT",
            "WORLD_VEHICLE_POLICE_BIKE",
            "WORLD_VEHICLE_POLICE_CAR",
            "WORLD_VEHICLE_POLICE",
            "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
            "WORLD_VEHICLE_QUARRY",
            "WORLD_VEHICLE_SALTON",
            "WORLD_VEHICLE_SALTON_DIRT_BIKE",
            "WORLD_VEHICLE_SECURITY_CAR",
            "WORLD_VEHICLE_STREETRACE",
            "WORLD_VEHICLE_TOURBUS",
            "WORLD_VEHICLE_TOURIST",
            "WORLD_VEHICLE_TANDL",
            "WORLD_VEHICLE_TRACTOR",
            "WORLD_VEHICLE_TRACTOR_BEACH",
            "WORLD_VEHICLE_TRUCK_LOGS",
            "WORLD_VEHICLE_TRUCKS_TRAILERS",
            "WORLD_VEHICLE_DISTANT_EMPTY_GROUND",
            "WORLD_HUMAN_PAPARAZZI",
        }

        for _, v in pairs(scenarios) do
            SetScenarioTypeEnabled(v, false)
        end
    end

    for i = 1, #Config.Player.remove_hud_components do
        if Config.Player.remove_hud_components[i] then
            SetHudComponentPosition(i, 999999.0, 999999.0)
        end
    end

    local playerId = PlayerId()
    if Config.Player.disable_health_regen then
        SetPlayerHealthRechargeMultiplier(playerId, 0.0)
    end

    if Config.Player.disable_npc_drops then
        local weaponPickups = { `PICKUP_WEAPON_CARBINERIFLE`, `PICKUP_WEAPON_PISTOL`, `PICKUP_WEAPON_PUMPSHOTGUN` }
        for i = 1, #weaponPickups do
            ToggleUsePickupsForPlayer(playerId, weaponPickups[i], false)
        end
    end

    if Config.Player.disable_weapon_wheel or Config.Player.disable_aim_assist or Config.Player.disable_vehicle_rewards or Config.Player.disable_display_ammo then
        Citizen.CreateThread(function()
            while true do
                if Config.Player.disable_display_ammo then
                    DisplayAmmoThisFrame(false)
                end

                if Config.Player.disable_weapon_wheel then
                    BlockWeaponWheelThisFrame()
                    DisableControlAction(0, 37, true)
                end

                if Config.Player.disable_aim_assist then
                    if IsPedArmed(ESX.PlayerData.ped, 4) then
                        SetPlayerLockonRangeOverride(playerId, 2.0)
                    end
                end

                if Config.Player.disable_vehicle_rewards then
                    DisablePlayerVehicleRewards(playerId)
                end

                Citizen.Wait(0)
            end
        end)
    end

    SetDefaultVehicleNumberPlateTextPattern(-1, Config.Patterns.plate)

    Client.StartServerSyncLoop()
    Client.StartDroppedItemsLoop()

    if IsScreenFadedOut() then DoScreenFadeIn(500) end
end)

local function onPlayerSpawn()
    ESX.SetPlayerData('ped', PlayerPedId())
    ESX.SetPlayerData('dead', false)
end

AddEventHandler('playerSpawned', onPlayerSpawn)
AddEventHandler('esx:onPlayerSpawn', onPlayerSpawn)

AddEventHandler('esx:onPlayerLogout', function()
    ESX.PlayerLoaded = false
end)

AddEventHandler('esx:setMaxWeight', function(newMaxWeight)
    ESX.SetPlayerData('maxWeight', newMaxWeight)
end)

AddEventHandler('esx:onPlayerDeath', function()
    ESX.SetPlayerData('ped', PlayerPedId())
    ESX.SetPlayerData('dead', true)
end)

AddEventHandler('skinchanger:modelLoaded', function()
    while not ESX.PlayerLoaded do Citizen.Wait(100) end

    TriggerEvent('esx:restoreLoadout')
end)

AddEventHandler('esx:restoreLoadout', function()
    if Config.OxInventory or not ESX.PlayerData.loadout then return end

    local ammoTypes = {}
    RemoveAllPedWeapons(ESX.PlayerData.ped, true)

    for _, v in ipairs(ESX.PlayerData.loadout) do
        local weaponName = v.name
        local weaponHash = joaat(weaponName)

        GiveWeaponToPed(ESX.PlayerData.ped, weaponHash, 0, false, false)
        SetPedWeaponTintIndex(ESX.PlayerData.ped, weaponHash, v.tintIndex)

        local ammoType = GetPedAmmoTypeFromWeapon(ESX.PlayerData.ped, weaponHash)

        for _, v2 in ipairs(v.components) do
            local componentHash = ESX.GetWeaponComponent(weaponName, v2).hash
            GiveWeaponComponentToPed(ESX.PlayerData.ped, weaponHash, componentHash)
        end

        if not ammoTypes[ammoType] then
            AddAmmoToPed(ESX.PlayerData.ped, weaponHash, v.ammo)
            ammoTypes[ammoType] = true
        end
    end
end)

AddEventHandler('esx:setAccountMoney', function(account)
    for i = 1, #(ESX.PlayerData.accounts) do
        if ESX.PlayerData.accounts[i].name == account.name then
            ESX.PlayerData.accounts[i] = account
            break
        end
    end

    ESX.SetPlayerData('accounts', ESX.PlayerData.accounts)
end)

AddEventHandler('esx:setMetadata', function(metadata)
    ESX.SetPlayerData('metadata', metadata)
end)

function Client.StartServerSyncLoop() ---@diagnostic disable-line: duplicate-set-field
    Citizen.CreateThread(function()
        local currentWeapon = { Ammo = 0 }
        local sleep

        while ESX.PlayerLoaded do
            sleep = 1500

            if GetSelectedPedWeapon(ESX.PlayerData.ped) ~= -1569615261 then
                sleep = 1000
                local _, weaponHash = GetCurrentPedWeapon(ESX.PlayerData.ped, true)
                local weapon = ESX.GetWeaponFromHash(weaponHash)

                if weapon then
                    local ammoCount = GetAmmoInPedWeapon(ESX.PlayerData.ped, weaponHash)

                    if weapon.name ~= currentWeapon.name then
                        currentWeapon.Ammo = ammoCount
                        currentWeapon.name = weapon.name
                    else
                        if ammoCount ~= currentWeapon.Ammo then
                            currentWeapon.Ammo = ammoCount

                            TriggerServerEvent('esx:updateWeaponAmmo', weapon.name, ammoCount)
                        end
                    end
                end
            end

            Citizen.Wait(sleep)
        end
    end)
end

function Client.StartDroppedItemsLoop() ---@diagnostic disable-line: duplicate-set-field
    if Config.OxInventory then return end
    Citizen.CreateThread(function()
        local sleep

        while ESX.PlayerLoaded do
            sleep = 1500
            local _, closestDistance = ESX.Game.GetClosestPlayer(cache.coords)

            for pickupId, pickup in pairs(pickups) do
                local distance = #(cache.coords - pickup.coords)

                PlaceObjectOnGroundProperly(pickup.obj)

                if distance < 5 then
                    sleep = 0
                    local label = pickup.label

                    if distance < 1 then
                        if IsControlJustReleased(0, 38) then
                            if IsPedOnFoot(ESX.PlayerData.ped) and (closestDistance == -1 or closestDistance > 3) and not pickup.inRange then
                                pickup.inRange = true

                                local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
                                ESX.Streaming.RequestAnimDict(dict)
                                TaskPlayAnim(ESX.PlayerData.ped, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
                                RemoveAnimDict(dict)
                                Wait(1000)

                                TriggerServerEvent('esx:onPickup', pickupId)
                                PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
                            end
                        end

                        label = ('%s~n~%s'):format(label, locale('threw_pickup_prompt'))
                    end

                    ESX.Game.Utils.DrawText3D({
                        x = pickup.coords.x,
                        y = pickup.coords.y,
                        z = pickup.coords.z + 0.25
                    }, label, 1.2, 1)
                elseif pickup.inRange then
                    pickup.inRange = false
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end

AddEventHandler('onClientResourceStart', function(resource)
    if resource ~= cache.resource or Config.OxInventory then return end

    local function setObjectProperties(entity, pickupId, coords, label)
        SetEntityAsMissionEntity(entity, true, false)
        PlaceObjectOnGroundProperly(entity)
        FreezeEntityPosition(entity, true)
        SetEntityCollision(entity, false, true)

        pickups[pickupId] = {
            obj = entity,
            label = label,
            inRange = false,
            coords = vector3(coords.x, coords.y, coords.z)
        }
    end

    AddEventHandler('esx:createPickup', function(pickupId, label, coords, type, name, components, tintIndex)
        if type == 'item_weapon' then
            local weaponHash = joaat(name)
            ESX.Streaming.RequestWeaponAsset(weaponHash)
            local pickupObject = CreateWeaponObject(weaponHash, 50, coords.x, coords.y, coords.z, true, 1.0, 0)
            SetWeaponObjectTintIndex(pickupObject, tintIndex)

            for _, v in ipairs(components) do
                local component = ESX.GetWeaponComponent(name, v)
                GiveWeaponComponentToWeaponObject(pickupObject, component.hash)
            end

            setObjectProperties(pickupObject, pickupId, coords, label)
        else
            ESX.Game.SpawnLocalObject('prop_money_bag_01', coords, function(entity)
                setObjectProperties(entity, pickupId, coords, label)
            end)
        end
    end)

    AddEventHandler('esx:removePickup', function(pickupId)
        if pickups[pickupId] and pickups[pickupId].obj then
            ESX.Game.DeleteObject(pickups[pickupId].obj)
            pickups[pickupId] = nil
        end
    end)

    AddEventHandler('esx:createMissingPickups', function(missingPickups)
        for pickupId, pickup in pairs(missingPickups) do
            TriggerEvent('esx:createPickup', pickupId, pickup.label, pickup.coords, pickup.type, pickup.name, pickup.components, pickup.tintIndex)
        end
    end)

    AddEventHandler('esx:addInventoryItem', function(item, count, showNotification)
        for k, v in ipairs(ESX.PlayerData.inventory) do
            if v.name == item then
                ESX.UI.ShowInventoryItemNotification(true, v.label, count - v.count)
                ESX.PlayerData.inventory[k].count = count
                break
            end
        end

        if showNotification then
            ESX.UI.ShowInventoryItemNotification(true, item, count)
        end
    end)

    AddEventHandler('esx:removeInventoryItem', function(item, count, showNotification)
        for k, v in ipairs(ESX.PlayerData.inventory) do
            if v.name == item then
                ESX.UI.ShowInventoryItemNotification(false, v.label, v.count - count)
                ESX.PlayerData.inventory[k].count = count
                break
            end
        end

        if showNotification then
            ESX.UI.ShowInventoryItemNotification(false, item, count)
        end
    end)

    AddEventHandler('esx:setWeaponTint', function(weapon, weaponTintIndex)
        SetPedWeaponTintIndex(ESX.PlayerData.ped, joaat(weapon), weaponTintIndex)
    end)

    if Config.EnableDefaultInventory then
        RegisterCommand('showinv', function()
            if ESX.PlayerData.dead then return end

            ESX.ShowInventory()
        end, false)

        RegisterKeyMapping('showinv', locale('keymap_showinventory'), 'keyboard', 'F2')
    end
end)

ESX.RegisterClientCallback('esx:getVehicleType', function(cb, model)
    cb(ESX.GetVehicleType(model))
end)

lib.onCache('ped', function(value)
    ESX.SetPlayerData('ped', value)

    if Config.Player.disable_vehicle_shuff then
        SetPedConfigFlag(value, 184, true)
    end

    TriggerEvent('esx:restoreLoadout')
end)

do
    if Config.Player.disable_wanted_level then
        ClearPlayerWantedLevel(PlayerId())
        SetMaxWantedLevel(0)
    end
end