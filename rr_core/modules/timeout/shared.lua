local activeTimeouts, cancelledTimeouts = {}, {}
local timeoutsCount = 0

---@param msec number
---@param cb? function
---@return number
function ESX.SetTimeout(msec, cb)
    timeoutsCount += 1
    local timeoutId = timeoutsCount
    activeTimeouts[timeoutId] = true

    Citizen.SetTimeout(msec, function()
        activeTimeouts[timeoutId] = nil

        if not cancelledTimeouts[timeoutId] then return cb and cb() end

        cancelledTimeouts[timeoutId] = nil
    end)

    return timeoutId
end

---@param timeoutId number
---@return boolean
function ESX.ClearTimeout(timeoutId)
    if not activeTimeouts[timeoutId] then return false end

    cancelledTimeouts[timeoutId] = true

    return true
end
