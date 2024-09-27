if not Client then return end
local lock_status, unlock_status = 2, 0

---@param vehicle number
---@param status boolean | number
function SetVehicleLock(vehicle, status)
    if vehicle and DoesEntityExist(vehicle) then
        Client.requestControlOfVehicle(vehicle)
        local state = Entity(vehicle).state
        local lock = unlock_status
        if type(status) == 'boolean' then
            lock = status and lock_status or unlock_status
        elseif type(status) == 'number' then
            if status == 0 or status == 1 then
                lock = unlock_status
            elseif status == 2 or status == 10 then
                lock = lock_status
            else lock = status end
        end
        state:set('vehicle_locked', lock, true)
        SetVehicleDoorsLocked(vehicle, lock)
        SERVER_LOG(2, '[^3LOCK^7]', ('Vehicle ^5%s ^7is now ^5%s^7'):format(vehicle, lock == lock_status and 'locked' or 'unlocked'))
    end
end
exports('setVehicleLock', SetVehicleLock)

---@param vehicle number
---@return number | nil
function GetVehicleLock(vehicle)
    if vehicle and DoesEntityExist(vehicle) then
        local state = Entity(vehicle).state
        if not state.vehicle_locked then
            SetVehicleLock(vehicle, GetVehicleDoorLockStatus(vehicle))
        end
        return state.vehicle_locked
    end
end
exports('getVehicleLock', GetVehicleLock)

RegisterCommand('vehicle_lock', function()
    if not Client.Framework.IsPlayerLoaded() or Client.thread and IsThreadActive(Client.thread) then return end
    Citizen.CreateThread(function()
        local threadId = GetIdOfThisThread()
        Client.thread = threadId

        local coords = GetEntityCoords(cache.ped)
        local vehicle = lib.getClosestVehicle(coords, 5.0, true)
        if vehicle and DoesEntityExist(vehicle) and not IsPedTryingToEnterALockedVehicle(cache.ped) then
            local class, props = GetVehicleClass(vehicle), lib.getVehicleProperties(vehicle)
            if not lib.table.contains(Config.Locks.always_unlocked.classes, class) and not lib.table.contains(Config.Locks.always_unlocked.models, props.model) then
                if HasKeys(vehicle) then
                    if not cache.vehicle then
                        local dict = 'anim@mp_player_intmenu@key_fob@'
                        local anim = 'fob_click'
                        if lib.requestAnimDict(dict) then
                            TaskPlayAnim(cache.ped, dict, anim, 15.0, -10.0, 1500, 49, 0, false, false, false)
                        end
                    end
                    coords = GetEntityCoords(vehicle)
                    if Config.Locks.sound_enabled then
                        Client.playSound(coords, 'Remote_Control_Fob', 'PI_Menu_Sounds', 5.0)
                    end

                    local state = Entity(vehicle).state
                    if not state.vehicle_locked then
                        SetVehicleLock(vehicle, GetVehicleDoorLockStatus(vehicle))
                    end

                    SetVehicleLights(vehicle, 2)
                    Citizen.Wait(120)
                    SetVehicleLights(vehicle, 1)
                    Citizen.Wait(120)
                    SetVehicleLights(vehicle, 2)
                    Citizen.Wait(120)

                    if state.vehicle_locked == 0 or state.vehicle_locked == 1 then
                        SetVehicleLock(vehicle, lock_status)
                        Client.Custom.notify('success', 'vehicle_locked', locale('vehicle_locked'):format(Client.getVehicleName(vehicle)))
                        SERVER_LOG(2, '[^3LOCK^7]', ('Player ^5%s ^7locked vehicle ^5%s^7'):format(GetPlayerServerId(PlayerId()), vehicle))
                    else
                        SetVehicleLock(vehicle, unlock_status)
                        Client.Custom.notify(nil, 'vehicle_unlocked', locale('vehicle_unlocked'):format(Client.getVehicleName(vehicle)))
                        SERVER_LOG(2, '[^3LOCK^7]', ('Player ^5%s ^7unlocked vehicle ^5%s^7'):format(GetPlayerServerId(PlayerId()), vehicle))
                    end
                    SetVehicleDoorsLocked(vehicle, state.vehicle_locked)

                    if Config.Locks.sound_enabled then
                        Client.playSound(coords, 'Remote_Control_Close', 'PI_Menu_Sounds', 5.0)
                    end
                    SetVehicleLights(vehicle, 0)
                else
                    Client.Custom.notify('error', 'vehicle_lock', locale('vehicle_no_keys'):format(Client.getVehicleName(vehicle)))
                    SERVER_LOG(2, '[^3LOCK^7]', ('Player ^5%s ^7attempted to change lock status in vehicle ^5%s^7, but has no keys'):format(GetPlayerServerId(PlayerId()), vehicle))
                end
            else
                Client.Custom.notify('error', 'vehicle_lock', locale('vehicle_always_unlocked'):format(Client.getVehicleName(vehicle)))
                SERVER_LOG(2, '[^3LOCK^7]', ('Player ^5%s ^7attempted to change lock status in vehicle ^5%s^7, but it is always unlocked'):format(GetPlayerServerId(PlayerId()), vehicle))
            end
        end
        Citizen.Wait(1500)
        Client.thread = nil
    end)
end, false)
RegisterKeyMapping('vehicle_lock', locale('command_vehicle_lock'), 'keyboard', 'L')

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local vehicle = GetVehiclePedIsTryingToEnter(cache.ped)
        if DoesEntityExist(vehicle) then
            sleep = 10
            local state = Entity(vehicle).state
            local driver = GetPedInVehicleSeat(vehicle, -1)

            Client.requestControlOfVehicle(vehicle)
            if not state.vehicle_locked then
                if Config.Locks.default_lock_npc_vehicles then
                    local class, model = GetVehicleClass(vehicle), GetEntityModel(vehicle)

                    if not lib.table.contains(Config.Locks.always_unlocked.classes, class) and not lib.table.contains(Config.Locks.always_unlocked.models, model) then
                        local random = math.random(100)
                        local chance = Config.Locks.chance_parked_vehicle_unlocked
                        if DoesEntityExist(driver) then
                            if IsPedAPlayer(driver) then 
                                SetVehicleLock(vehicle, lock_status)
                            else
                                chance = Config.Locks.chance_moving_vehicle_unlocked
                                if random < chance then 
                                    SetVehicleLock(vehicle, unlock_status)
                                else
                                    SetVehicleLock(vehicle, lock_status)
                                    TaskVehicleDriveWander(driver, vehicle, 100.0, 525116)
                                end
                            end
                        elseif random < chance then SetVehicleLock(vehicle, unlock_status)
                        else SetVehicleLock(vehicle, lock_status) end
                    else SetVehicleLock(vehicle, unlock_status) end
                else SetVehicleLock(vehicle, unlock_status) end
            end
            SetVehicleDoorsLocked(vehicle, state.vehicle_locked)
        end
        Citizen.Wait(sleep)
    end
end)