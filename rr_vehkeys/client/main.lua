if not LOADED then return end

local fw = lib.require('client.framework')
if not fw then return end

local custom = lib.require('client.custom')
if not custom then return end

Client, NUI = {}, {}
Client.Framework = fw
Client.Custom = custom

---@param vehicle number
function Client.requestControlOfVehicle(vehicle)
    NetworkRegisterEntityAsNetworked(vehicle)
    NetworkRequestControlOfEntity(vehicle)
    local timeout = 50
    while not NetworkHasControlOfEntity(vehicle) and timeout > 0 do
        Citizen.Wait(1)
        timeout = timeout - 1
        NetworkRequestControlOfEntity(vehicle)
    end
end

---@param vehicle number | table
---@return string | nil, number
function Client.getVehicleData(vehicle)
    local plate, model = '', 0
    if type(vehicle) == 'number' and DoesEntityExist(vehicle) then
        plate, model = GetVehicleNumberPlateText(vehicle), GetEntityModel(vehicle)
    elseif type(vehicle) == 'table' then
        plate, model = vehicle.plate or nil, vehicle.model and (type(vehicle.model) == 'string' and GetHashKey(vehicle.model) or vehicle.model) or nil
    end
    return plate, model
end

---@param vehicle number | string entity, entity model or entity model hash
---@return string
function Client.getVehicleName(vehicle)
    local model
    if type(vehicle) == 'number' and DoesEntityExist(vehicle) then
        model = GetEntityModel(vehicle)
    else
        if type(vehicle) == 'string' then
            vehicle = GetHashKey(vehicle)
        end
        model = vehicle
    end

    if not model or not IsModelValid(model) then
        return 'Unknown vehicle'
    end

    local makeName = GetMakeNameFromVehicleModel(model)
    if makeName == 'CARNOTFOUND' or makeName == '' then makeName = nil end
    local modelName = GetLabelText(GetDisplayNameFromVehicleModel(model))
    if modelName == 'CARNOTFOUND' or modelName == '' then modelName = nil end

    return ('%s%s'):format(makeName and ('%s '):format(makeName:lower():gsub("^%l", string.upper)) or '', modelName and modelName or '')
end

---@param coords vector3
---@param sound string
---@param ref string
---@param range number
function Client.playSound(coords, sound, ref, range)
    TriggerServerEvent(RESOURCE .. ':server:playSound', coords, sound, ref, range)
end

---@param vehicle number
function Client.vehicleAlarm(vehicle)
    SetVehicleAlarm(vehicle, true)
    SetVehicleAlarmTimeLeft(vehicle, 10000)
    StartVehicleAlarm(vehicle)
end

RegisterNetEvent(RESOURCE .. ':client:playSound', function(coords, sound, ref, range)
    PlaySoundFromCoord(-1, sound, coords.x, coords.y, coords.z, ref, false, range, false)
end)

RegisterNetEvent(RESOURCE .. ':client:notify', function(notifyType, id, message)
    custom.notify(notifyType, id, message)
end)

RegisterNetEvent(RESOURCE .. ':client:updateKeys', function(keys)
    local vehicle, seat = cache.vehicle, cache.seat
    if vehicle and DoesEntityExist(vehicle) and seat and seat == -1 then
        PrepareVehicle(vehicle)
    end
    NUI.updateKeys(keys)
end)

lib.onCache('seat', function(seat)
    if seat and seat == -1 then
        local vehicle = cache.vehicle
        if vehicle and DoesEntityExist(vehicle) then
            local state = Entity(vehicle).state
            local class, model = Client.getVehicleData(vehicle)
            if not state.vehicle_locked then
                if not lib.table.contains(Config.Locks.always_unlocked.classes, class) and not lib.table.contains(Config.Locks.always_unlocked.models, model) then
                    SetVehicleLock(vehicle, true)
                else SetVehicleLock(vehicle, false) end
            end
            PrepareVehicle(vehicle)
        end
    end
end)