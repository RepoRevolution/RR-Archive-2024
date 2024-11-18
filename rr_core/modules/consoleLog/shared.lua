local types = {
    ['info'] = '^2INFO^7',
    ['warning'] = '^6WARNING^7',
    ['error'] = '^8ERROR^7',
    ['debug'] = '^9DEBUG^7'
}

---@param func function
local function functionName(func)
    local info = debug.getinfo(func, 'n')
    return info and info.name or 'unknown function'
end

---@param printType string
---@param ... any
function ESX.Print(printType, ...)
    if (not DEBUG and printType:lower() == 'debug') or not types[printType:lower()] then return end

    local args = {...}
    local formattedArgs = {}

    local prefix = types[printType:lower()]
    local invoking = GetInvokingResource() or cache.resource
    table.insert(formattedArgs, ('[%s][%s]'):format(prefix, invoking))

    for i = 1, #args do
        local arg = args[i]
        local argType = type(arg)

        local formattedArg
        if argType == 'table' then
            formattedArg = json.encode(arg)
        elseif argType == 'function' then
            formattedArg = functionName(arg)
        elseif argType == 'nil' then
            formattedArg = 'NULL'
        else formattedArg = tostring(arg) end

        table.insert(formattedArgs, formattedArg)
    end

    print(table.concat(formattedArgs, ' '))
end

function ESX.Trace(message)
    ESX.Print('info', message)
end
