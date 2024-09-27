if not Client then return end
local excluded_zones = {}

---@param coords vector3
---@return boolean
local function checkExcludeZones(coords)
    for _, zone in ipairs(excluded_zones) do
        if zone:contains(coords) then
            return true
        end
    end
    return false
end

function Lockpick()
    if Config.Lockpick.enabled then
        if not Client.Framework.IsPlayerLoaded() or Client.thread and IsThreadActive(Client.thread) then return end
        Citizen.CreateThread(function()
            local threadId = GetIdOfThisThread()
            Client.thread = threadId
            local coords = GetEntityCoords(cache.ped)
            local vehicle = lib.getClosestVehicle(coords, 2.5, false)
            if vehicle and DoesEntityExist(vehicle) and not IsPedTryingToEnterALockedVehicle(cache.ped) then
                local state = Entity(vehicle).state
                if state.vehicle_locked then
                    local passengers = GetVehicleNumberOfPassengers(vehicle)
                    if passengers <= 0 and IsVehicleSeatFree(vehicle, -1) then
                        if state.vehicle_locked == 2 or state.vehicle_locked == 10 then
                            if not checkExcludeZones(coords) then
                                SetCurrentPedWeapon(cache.ped, GetHashKey('WEAPON_UNARMED'), true)
                                FreezeEntityPosition(cache.ped, true)
                
                                local dict = 'veh@break_in@0h@p_m_one@'
                                local anim = 'low_force_entry_ds'
                                local playAnim = true
                                if lib.requestAnimDict(dict) then
                                    Citizen.CreateThread(function()
                                        while playAnim do
                                            TaskPlayAnim(cache.ped, dict, anim, 15.0, -10.0, 1500, 49, 0, false, false, false)
                                            Citizen.Wait(1500)
                                        end
                                    end)
                                end

                                Citizen.Wait(5000) -- mandatory debug
                                ---@TODO: Minigame
                                local success = math.random(0, 1)

                                playAnim = false
                                ClearPedTasks(cache.ped)
                                FreezeEntityPosition(cache.ped, false)

                                if success then
                                    SetVehicleLock(vehicle, false)
                                    Client.Custom.notify('success', 'lockpick_success', locale('lockpick_success'):format(Client.getVehicleName(vehicle)))
                                    SERVER_LOG(2, '[^4LOCKPICK^7]', ('Player ^5%s ^7successfully lockpicked a vehicle ^5%s^7'):format(GetPlayerServerId(PlayerId()), vehicle))
                                else
                                    Client.vehicleAlarm(vehicle)
                                    if Config.Lockpick.call_police then
                                        Client.Custom.callPolice('lockpick', GetEntityCoords(vehicle), vehicle)
                                        SERVER_LOG(2, '[^4LOCKPICK^7]', 'Alerted police')
                                    end
                                    if Config.Lockpick.alert_vehicle_owner then
                                        local owner = lib.callback.await(RESOURCE .. ':server:getVehicleOwner', false, GetVehicleNumberPlateText(vehicle))
                                        if owner then
                                            Client.Custom.alertOwner('lockpick', owner, GetEntityCoords(vehicle), vehicle)
                                            SERVER_LOG(2, '[^4LOCKPICK^7]', ('Alerted player ^5%s ^7which is vehicle ^5%s^7 owner'):format(owner, vehicle))
                                        end
                                    end
                                    Client.Custom.notify('error', 'lockpick_failed', locale('lockpick_failed'):format(Client.getVehicleName(vehicle)))
                                    SERVER_LOG(2, '[^4LOCKPICK^7]', ('Player ^5%s ^7failed to lockpick a vehicle ^5%s^7'):format(GetPlayerServerId(PlayerId()), vehicle))
                                end
                            else
                                if Config.Lockpick.call_police then
                                    Client.Custom.callPolice('lockpick', GetEntityCoords(vehicle), vehicle)
                                    SERVER_LOG(2, '[^4LOCKPICK^7]', 'Alerted police')
                                end
                                Client.Custom.notify('error', 'lockpick_failed', locale('lockpick_excluded_zone'):format(Client.getVehicleName(vehicle)))
                                SERVER_LOG(2, '[^4LOCKPICK^7]', ('Player ^5%s ^7attempted to lockpick a vehicle ^5%s^7 in an excluded zone'):format(GetPlayerServerId(PlayerId()), vehicle))
                            end
                        else
                            Client.Custom.notify('error', 'lockpick_failed', locale('lockpick_already_unlocked'):format(Client.getVehicleName(vehicle)))
                            SERVER_LOG(2, '[^4LOCKPICK^7]', ('Player ^5%s ^7attempted to lockpick a vehicle ^5%s^7 that is already unlocked'):format(GetPlayerServerId(PlayerId()), vehicle))
                        end
                    else
                        SERVER_LOG(2, '[^4LOCKPICK^7]', ('Player ^5%s ^7attempted to lockpick a vehicle ^5%s^7 with passengers'):format(GetPlayerServerId(PlayerId()), vehicle))
                    end
                else
                    Client.Custom.notify('error', 'lockpick_failed', locale('lockpick_need_check'):format(Client.getVehicleName(vehicle)))
                    SERVER_LOG(2, '[^4LOCKPICK^7]', ('Player ^5%s ^7attempted to lockpick a vehicle ^5%s^7 that has not locked status'):format(GetPlayerServerId(PlayerId()), vehicle))
                end
            end
            Citizen.Wait(1500)
            Client.thread = nil
        end)
    end
end
exports('lockpick', Lockpick)

if Config.Lockpick.enabled then
    for _, zone in ipairs(Config.Lockpick.excluded_zones) do
        local poly = lib.zones.poly({
            points = zone.points,
            thickness = zone.height or 2.0,
            debug = Config.Debug
        })
        table.insert(excluded_zones, poly)
    end

    if Config.Lockpick.command then
        RegisterCommand(Config.Lockpick.command, function()
            Lockpick()
        end, false)
    end

    if Config.Lockpick.item then
        RegisterNetEvent(RESOURCE .. ':client:lockpick', Lockpick)
    end
end