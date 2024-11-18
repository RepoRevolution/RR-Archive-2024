DEBUG = Config.Debug
LOCALE = GetConvar('rr:locale', 'en')
IDENTIFIER = GetConvar('rr:identifier', 'license')
MULTICHAR = GetResourceState('rr_characters') ~= 'missing'
ONESYNC = GetConvar('onesync', 'off')
LOADED = false

table.contains = function(t, object)
    for _, v in pairs(t) do
        if v == object then
            return true
        end
    end
    return false
end

table.indexOf = function(t, object)
    for i, v in pairs(t) do
        if v == object then
            return i
        end
    end
    return nil
end

table.length = function(t)
    local length = 0
    for _ in pairs(t) do length = length + 1 end
    return length
end

local success, message
success, message = lib.checkDependency('oxmysql', '2.6.0')
if not success then return warn(message) end

success, message = lib.checkDependency('ox_lib', '3.0.0')
if not success then return warn(message) end
if not lib then return warn(('`%s` needs `ox_lib` resource to run with version 3.0.0+'):format(GetCurrentResourceName())) end

LOADED = true
lib.locale()