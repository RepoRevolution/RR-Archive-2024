---@diagnostic disable: param-type-mismatch
---@param vehicle number
local function requestControlOfVehicle(vehicle)
    local netTime = 15
    NetworkRegisterEntityAsNetworked(vehicle)
    NetworkRequestControlOfEntity(vehicle)
    while not NetworkHasControlOfEntity(vehicle) and netTime > 0 do
        Citizen.Wait(1)
        NetworkRequestControlOfEntity(vehicle)
        netTime = netTime - 1
    end
end

local windows = {
    [0] = '_VEH_RF_WINDOW',
    [1] = '_VEH_LF_WINDOW',
    [2] = '_VEH_RR_WINDOW',
    [3] = '_VEH_LR_WINDOW'
}
DecorRegister(windows[0], 2)
DecorRegister(windows[1], 2)
DecorRegister(windows[2], 2)
DecorRegister(windows[3], 2)

---@param vehicle number
---@return boolean
function AreAllVehicleWindowsClosed(vehicle)
    requestControlOfVehicle(vehicle)
    for _, decor in pairs(windows) do
        if DecorExistOn(vehicle, decor) and DecorGetBool(vehicle, decor) then
            return false
        end
    end
    return true
end

---@param vehicle number
---@param state boolean
---@param sync boolean | nil
local function rollAllWindows(vehicle, state, sync)
    for index, decor in pairs(windows) do
        if GetIsDoorValid(vehicle, index) then
            if not sync then
                DecorSetBool(vehicle, decor, state)
            end
            if state then
                RollDownWindow(vehicle, index)
            else
                RollUpWindow(vehicle, index)
            end
        end
    end
end

RegisterNetEvent('pma-voice_addon:client:rollWindows', function(netId, windowId, state)
    local vehicle = NetToVeh(netId)
    Citizen.Wait(50)
    if not windowId then
        rollAllWindows(vehicle, state, true)
    else
        if state then
            RollDownWindow(vehicle, windowId)
        else
            RollUpWindow(vehicle, windowId)
        end
    end
end)

---@param vehicle number
---@param windowId number | nil
local function rollWindows(vehicle, windowId)
    if not vehicle then return end
    requestControlOfVehicle(vehicle)
    if not windowId then
        if not AreAllVehicleWindowsClosed(vehicle) then
            rollAllWindows(vehicle, false)
            TriggerServerEvent('pma-voice_addon:server:rollWindows', VehToNet(vehicle), nil, false)
        else
            rollAllWindows(vehicle, true)
            TriggerServerEvent('pma-voice_addon:server:rollWindows', VehToNet(vehicle), nil, true)
        end
    else
        windowId = tonumber(windowId)
        if windowId < 0 or windowId > 3 or not GetIsDoorValid(vehicle, windowId) then return end
        if DecorExistOn(vehicle, windows[windowId]) and DecorGetBool(vehicle, windows[windowId]) then
            DecorSetBool(vehicle, windows[windowId], false)
            RollUpWindow(vehicle, windowId)
            TriggerServerEvent('pma-voice_addon:server:rollWindows', VehToNet(vehicle), windowId, false)
        else
            DecorSetBool(vehicle, windows[windowId], true)
            RollDownWindow(vehicle, windowId)
            TriggerServerEvent('pma-voice_addon:server:rollWindows', VehToNet(vehicle), windowId, true)
        end
    end
end
exports('rollWindows', rollWindows)