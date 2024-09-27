if not Client then return end

---@param vehicle number
---@param status boolean
function SetHotwired(vehicle, status)
    if vehicle and DoesEntityExist(vehicle) then
        Client.requestControlOfVehicle(vehicle)
        local state = Entity(vehicle).state
        state:set('vehicle_hotwired', status or false, true)
        SERVER_LOG(2, '[^5HOTWIRE^7]', ('Player ^5%s ^7set vehicle ^5%s ^7hotwired status to ^5%s^7'):format(GetPlayerServerId(PlayerId()), vehicle, state.vehicle_hotwired))
    end
end
exports('setHotwired', SetHotwired)

---@param vehicle number
---@param status boolean
function SetNeedHotwire(vehicle, status)
    if vehicle and DoesEntityExist(vehicle) then
        Client.requestControlOfVehicle(vehicle)
        local state = Entity(vehicle).state
        state:set('vehicle_need_hotwire', status or false, true)
        SERVER_LOG(2, '[^5HOTWIRE^7]', ('Player ^5%s ^7set vehicle ^5%s ^7need hotwire status to ^5%s^7'):format(GetPlayerServerId(PlayerId()), vehicle, state.vehicle_need_hotwire))
    end
end
exports('setNeedHotwire', SetNeedHotwire)

---@param vehicle number
function PrepareVehicle(vehicle)
    local state = Entity(vehicle).state
    local keys = HasKeys(vehicle)
    local engine = GetIsVehicleEngineRunning(vehicle)

    if keys then
        SetHotwired(vehicle, false)
        SetNeedHotwire(vehicle, false)
        SetVehicleUndriveable(vehicle, false)
    elseif not keys and engine then
        SetNeedHotwire(vehicle, false)
        if state.vehicle_hotwired == false then
            GiveKeys(vehicle, 0, true)
        end
    elseif not keys and not engine then
        SetNeedHotwire(vehicle, Config.Hotwire.enabled)
    end
end

function Hotwire()
    if Config.Hotwire.enabled then
        if not Client.Framework.IsPlayerLoaded() or Client.thread and IsThreadActive(Client.thread) then return end
        Citizen.CreateThread(function()
            local threadId = GetIdOfThisThread()
            Client.thread = threadId
            local vehicle, seat = cache.vehicle, cache.seat
            if vehicle and DoesEntityExist(vehicle) and seat then
                local state = Entity(vehicle).state
                if state.vehicle_need_hotwire then
                    SetCurrentPedWeapon(cache.ped, GetHashKey('WEAPON_UNARMED'), true)
                    FreezeEntityPosition(cache.ped, true)

                    local dict = 'veh@handler@base'
                    local anim = 'hotwire'
                    if lib.requestAnimDict(dict) then
                        TaskPlayAnim(cache.ped, dict, anim, 8.0, -8.0, -1, 49, 0, false, false, false)
                    end

                    Citizen.Wait(5000) -- mandatory debug
                    ---@TODO: Minigame
                    local success = math.random(0, 1)

                    ClearPedTasks(cache.ped)
                    FreezeEntityPosition(cache.ped, false)

                    if success then
                        SetNeedHotwire(vehicle, false)
                        SetHotwired(vehicle, true)
                        SetVehicleEngine(vehicle, true)
                        SetVehicleUndriveable(vehicle, false)
                        Client.Custom.notify('success', 'hotwire_success', locale('hotwire_success'):format(Client.getVehicleName(vehicle)))
                        SERVER_LOG(2, '[^5HOTWIRE^7]', ('Player ^5%s ^7successfully hotwired vehicle ^5%s^7'):format(GetPlayerServerId(PlayerId()), vehicle))
                    else
                        Client.vehicleAlarm(vehicle)
                        if Config.Hotwire.call_police then
                            Client.Custom.callPolice('hotwire', GetEntityCoords(vehicle), vehicle)
                            SERVER_LOG(2, '[^5HOTWIRE^7]', 'Alerted police')
                        end
                        if Config.Hotwire.alert_vehicle_owner then
                            local owner = lib.callback.await(RESOURCE .. ':server:getVehicleOwner', false, GetVehicleNumberPlateText(vehicle))
                            if owner then
                                Client.Custom.alertOwner('hotwire', owner, GetEntityCoords(vehicle), vehicle)
                                SERVER_LOG(2, '[^5HOTWIRE^7]', ('Alerted player ^5%s ^7which is vehicle ^5%s^7 owner'):format(owner, vehicle))
                            end
                        end
                        Client.Custom.notify('error', 'hotwire_failed', locale('hotwire_failed'):format(Client.getVehicleName(vehicle)))
                        SERVER_LOG(2, '[^5HOTWIRE^7]', ('Player ^5%s ^7failed to hotwire vehicle ^5%s^7'):format(GetPlayerServerId(PlayerId()), vehicle))
                    end
                else
                    SERVER_LOG(2, '[^5HOTWIRE^7]', ('Player ^5%s ^7attempted to hotwire a vehicle ^5%s ^7that does not need hotwire'):format(GetPlayerServerId(PlayerId()), vehicle))
                end
            end
            Citizen.Wait(1500)
            Client.thread = nil
        end)
    end
end
exports('hotwire', Hotwire)

if Config.Hotwire.enabled then
    if Config.Hotwire.command then
        RegisterCommand(Config.Hotwire.command, function()
            Hotwire()
        end, false)
        RegisterKeyMapping(Config.Hotwire.command, locale('command_vehicle_hotwire'), 'keyboard', Config.Hotwire.command_keyboard_bind)
    end

    if Config.Hotwire.item then
        RegisterNetEvent(RESOURCE .. ':client:hotwire', Hotwire)
    end
end