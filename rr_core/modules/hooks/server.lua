---@diagnostic disable: inject-field
if Server.TriggerEventHooks then return end

local export = lib.require('modules.export')
local eventHooks, hookId, clock = {}, 0, os.clock -- instead of microtime which is used by ox, we gotta use clock since os.microtime is not recognized in our lua lint workflow
local api = setmetatable({}, {
    __newindex = function(self, index, value)
        exports(index, value)
        export.createESX(index, value)
        rawset(self, index, value)
    end
})

---@param event string
---@param cb function
---@param options? table
function api.registerHook(event, cb, options)
    if not eventHooks[event] then eventHooks[event] = {} end

    local mt = getmetatable(cb)
    mt.__index, mt.__newindex = nil, nil
    cb.resource = GetInvokingResource() or cache.resource
    hookId = hookId + 1 -- very strange but if we use compound operator of += here, the lint crashes although we are using this operator in other part of the code!
    cb.hookId = hookId

    if type(options) == 'table' then
        for k, v in pairs(options) do
            cb[k] = v
        end
    end

    eventHooks[event][#eventHooks[event] + 1] = cb

    return hookId
end

---@param resource string
---@param id? number
local function removeResourceHooks(resource, id)
    for _, hooks in pairs(eventHooks) do
        for i = #hooks, 1, -1 do
            local hook = hooks[i]

            if hook.resource == resource and (not id or hook.hookId == id) then
                table.remove(hooks, i)
            end
        end
    end
end

AddEventHandler('onResourceStop', removeResourceHooks)
AddEventHandler('onServerResourceStop', removeResourceHooks)

---@param id? number
function api.removeHooks(id)
    removeResourceHooks(GetInvokingResource() or cache.resource, id)
end

---@param event string
---@param payload? table
function Server.TriggerEventHooks(event, payload)
    local hooks = eventHooks[event]

    if hooks then
        for i = 1, #hooks do
            local hook = hooks[i]

            ESX.Print('debug', ('Triggering event hook `%s:%s:%s`'):format(hook.resource, event, i))

            local start = clock()
            local _, response = xpcall(hooks[i], function() ESX.Print('error', ('There was an error in trigerring event hook `%s:%s:%s`'):format(hook.resource, event, i)) end, payload)
            local executionTime = (clock() - start) * 1000 -- convert execution time to milliseconds

            if executionTime >= 100 then
                ESX.Print('warning', ('Execution of event hook `%s:%s:%s` took %.2fms'):format(hook.resource, event, i, executionTime))
            end

            if response == false then
                return false
            end
        end
    end

    return true
end
