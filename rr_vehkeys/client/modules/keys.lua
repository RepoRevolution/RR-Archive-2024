if not Client then return end

---@return table<string, table>
function GetKeys()
    return lib.callback.await(RESOURCE .. ':server:getKeys', false)
end
exports('getKeys', GetKeys)

---@param vehicle number | table
---@param keyType number
---@param stolen boolean | nil
function GiveKeys(vehicle, keyType, stolen)
    if not vehicle then return end
    local plate, model = Client.getVehicleData(vehicle)
    if not plate or not model then return end
    TriggerServerEvent(RESOURCE .. ':server:giveKey', plate, model, keyType or 0, stolen)
end
exports('giveKeys', GiveKeys)

---@param keyType number
function IntegrateKeys(keyType)
    local coords = GetEntityCoords(cache.ped)
    local vehicle = lib.getClosestVehicle(coords, 3.0, true)
    if not vehicle then return end
    GiveKeys(vehicle, keyType)
end
exports('integrateKeys', IntegrateKeys)
RegisterNetEvent(RESOURCE .. ':client:integrateKeys', IntegrateKeys)

---@param vehicle number | table
---@return boolean
function HasKeys(vehicle)
    if Client.Framework.IsPlayerLoaded() then
        local plate, model = Client.getVehicleData(vehicle)
        if not plate or not model then return false end

        local keys = lib.callback.await(RESOURCE .. ':server:getKeys', false)
        for _, data in pairs(keys) do
            for _, v in ipairs(data) do
                if v.plate == plate and v.model == model then
                    return true
                end
            end
        end

        local job = Client.Framework.getJob()
        for _, whitelisted in ipairs(Config.Locks.whitelisted) do
            if whitelisted.model and whitelisted.model == model then
                if not whitelisted.job
                    or (type(whitelisted.job) == 'table' and lib.table.contains(whitelisted.job, job))
                    or (type(whitelisted.job) == 'string' and whitelisted.job == job)
                then
                    return true
                end
            end
        end
    end
    return false
end
exports('hasKeys', HasKeys)

function KeysMenu()
    local keys = lib.callback.await(RESOURCE .. ':server:getKeys', false)
    NUI.openKeysMenu(keys)
end
exports('keysMenu', KeysMenu)
RegisterCommand('vehicle_keys', KeysMenu, false)