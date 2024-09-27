if not Client then return end

---@param vehicle number
---@param status boolean
function SetVehicleEngine(vehicle, status)
    if vehicle and DoesEntityExist(vehicle) then
        Client.requestControlOfVehicle(vehicle)
        local state = Entity(vehicle).state
        state:set('vehicle_engine', status or false, true)
        SetVehicleEngineOn(vehicle, state.vehicle_engine, false, true)
        SERVER_LOG(2, '[^6ENGINE^7]', ('Player ^5%s ^7set vehicle ^5%s ^7engine status to ^5%s^7'):format(GetPlayerServerId(PlayerId()), vehicle, status))
    end
end

---@param vehicle number
function ToggleVehicleEngine(vehicle)
    if vehicle and DoesEntityExist(vehicle) then
        local state = Entity(vehicle).state
        if type(state.vehicle_engine) ~= 'boolean' then
            SetVehicleEngine(vehicle, GetIsVehicleEngineRunning(vehicle))
        end
        if state.vehicle_engine and state.vehicle_hotwired then
            if Config.Engine.can_turn_off_when_hotwired then
                SetVehicleEngine(vehicle, false)
                PrepareVehicle(vehicle)
            end
        elseif not state.vehicle_need_hotwire or state.vehicle_need_hotwire == false then
            SetVehicleEngine(vehicle, not state.vehicle_engine)
        end
    end
end
exports('toggleVehicleEngine', ToggleVehicleEngine)

if Config.Hotwire.enabled or Config.Engine.enabled then
    Citizen.CreateThread(function()
        while true do
            local sleep = 500
            local vehicle = cache.vehicle
            if vehicle and DoesEntityExist(vehicle) then
                local state = Entity(vehicle).state
                if (Config.Hotwire.enabled and state.vehicle_need_hotwire) 
                    or (Config.Engine.enabled and Config.Engine.disable_auto_start and not state.vehicle_engine)
                then
                    SetVehicleEngineOn(vehicle, false, true, true)
                    SetVehicleUndriveable(vehicle, true)
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end

if Config.Engine.enabled and Config.Engine.command then
    RegisterCommand(Config.Engine.command, function()
        ToggleVehicleEngine(cache.vehicle)
    end, false)
    RegisterKeyMapping(Config.Engine.command, locale('command_vehicle_engine'), 'keyboard', Config.Engine.command_keyboard_bind)

    Citizen.CreateThread(function()
        local function stayEngineRunning(vehicle)
            SetVehicleEngineOn(vehicle, true, true, true)
            local timeout = 15
            while not GetIsVehicleEngineRunning(vehicle) and timeout > 15 do
                Citizen.Wait(1)
                SetVehicleEngineOn(vehicle, true, true, true)
                timeout = timeout - 1
            end
            SetVehicleLights(vehicle, 0)
        end
    
        while true do
            local sleep = 500
            local vehicle = cache.vehicle
            if vehicle and cache.seat == -1 and GetIsVehicleEngineRunning(vehicle) then
                sleep = 10
                if IsControlJustPressed(2, 75) and DoesEntityExist(vehicle) and not IsEntityDead(cache.ped) then
                    Citizen.Wait(386)
                    if Config.Engine.turn_off_while_exit and Config.Engine.hold_exit_key_to_stay_on then
                        if IsControlPressed(2, 75) and DoesEntityExist(vehicle) and not IsEntityDead(cache.ped) then
                            stayEngineRunning(vehicle)
                        end
                    elseif not Config.Engine.turn_off_while_exit then
                        stayEngineRunning(vehicle)
                    end
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end