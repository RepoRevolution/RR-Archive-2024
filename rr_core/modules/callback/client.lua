---@param eventName string
---@param cb? any
---@param ... any
---@return ...
function ESX.TriggerServerCallback(eventName, cb, ...)
    local isCbFunction = type(cb) == 'function' or (type(cb) == 'table' and cb?.__cfx_functionReference and true)
    local params = lib.callback.await(eventName, false, ...)

    if not isCbFunction then
        return table.unpack(params)
    end

    return cb(table.unpack(params))
end

---@param eventName string
---@param callback function
function ESX.RegisterClientCallback(eventName, callback)
    lib.callback.register(eventName, callback)
end
