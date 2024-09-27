local Custom = {}

---@param notifyType string -- 'success', 'error', 'warning' or nil
---@param id string -- 'vehicle_lock', 'vehicle_locked', 'vehicle_unlocked', 'lockpick_success', 'lockpick_failed', 'hotwire_success', 'hotwire_failed', 'no_player'
---@param message string
function Custom.notify(notifyType, id, message)
    local icon = nil
    if not id then icon = 'key'
    elseif id == 'vehicle_lock' or id == 'vehicle_locked' or id == 'vehicle_unlocked' then icon = 'lock'
    elseif id == 'lockpick_success' or id == 'lockpick_failed' then icon = 'screwdriver'
    elseif id == 'hotwire_success' or id == 'hotwire_failed' then icon = 'screwdriver-wrench' end
    
    lib.notify({
        id = id,
        type = notifyType,
        icon = icon,
        description = message
    })
end

---@param callType string
---@param coords vector3
---@param vehicle number
function Custom.callPolice(callType, coords, vehicle)
    -- Dispatch your own services
    if callType == 'lockpick' then
        
    elseif callType == 'hotwire' then

    elseif callType == 'carjacking' then

    end
end

---@param callType string
---@param target number
---@param coords vector3
---@param vehicle number
function Custom.alertOwner(callType, target, coords, vehicle)
    -- Notify the owner of the vehicle
    if callType == 'lockpick' then

    elseif callType == 'hotwire' then

    end
end

return Custom