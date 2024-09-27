---@diagnostic disable: param-type-mismatch, undefined-field, inject-field
RESOURCE = GetCurrentResourceName()
FRAMEWORK = Config.Framework or 'auto'
LOADED = false

---@param func function
local function functionName(func)
    local info = debug.getinfo(func, 'n')
    return info and info.name or 'unknown function'
end

---@param level number
---@param ... any
local function consoleLog(level, ...)
    local args = {...}
    local formattedArgs = {}

    if type(level) ~= 'number' or level == 2 and not Config.Debug then return end

    table.insert(formattedArgs,
        (
            level == 1 and '[^2INFO^7]' or level == 2 and '[^9DEBUG^7]'
            or level == 3 and '[^6WARNING^7]' or '[^8ERROR^7]'
        )
    )

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

function LOG(level, ...) consoleLog(level, ...) end

if not IsDuplicityVersion() then
    function SERVER_LOG(level, ...)
        TriggerServerEvent(RESOURCE .. ':server:log', level, ...)
    end
else
    RegisterNetEvent(RESOURCE .. ':server:log', function(level, ...)
        LOG(level, ...)
    end)

    ---@param url string
    ---@param params table<string, any>
    function DISCORD_LOG(url, params)
        if not url or not params then return end

        local payload = {
            username = params.username or RESOURCE,
            avatar_url = params.avatar_url or nil,
            tts = params.tts or false,
            allowed_mentions = {
                parse = { 'roles', 'users', 'everyone' }
            },
            content = nil,
            embeds = {}
        }
        if #payload.username > 80 then payload.username = payload.username:sub(1, 77) .. '...' end

        local content = ''
        if params.mentions then
            local mentions = params.mentions
            if mentions.roles and #mentions.roles > 0 then
                content = content .. '||'
                for _, role in ipairs(mentions.roles) do
                    if type(role) == 'string' then
                        content = content .. ('@%s'):format(role)
                    elseif type(role) == 'number' then
                        content = content .. ('<@&%s>'):format(role)
                    end
                end
                content = content .. '||\n'
            end

            if mentions.users and #mentions.users > 0 then
                content = content .. '||'
                for _, user in ipairs(mentions.users) do
                    if type(user) == 'number' then
                        content = content .. ('<@%s>'):format(user)
                    end
                end
                content = content .. '||\n'
            end
        end
        if #content > 2000 then content = content:sub(1, 1997) .. '...' end
        payload.content = content .. (params.content or '')

        if params.embeds and #params.embeds > 0 then
            for i = 1, 10, 1 do
                local embed = params.embeds[i]
                if embed then
                    local object = {
                        author = {
                            name = 'RepoRevolution',
                            url = 'https://reporevolution.tebex.io',
                            icon_url = 'https://avatars.githubusercontent.com/u/138621224?s=200&v=4'
                        },
                        color = embed.color or nil,
                        title = embed.title or nil,
                        description = embed.description or nil,
                        fields = embed.fields or {},
                        image = embed.image or nil,
                        footer = embed.footer or nil,
                        timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ', os.time()),
                    }

                    if object.title and #object.title > 256 then object.title = object.title:sub(1, 253) .. '...' end
                    if object.description and #object.description > 4096 then object.description = object.description:sub(1, 4093) .. '...' end

                    while #object.fields > 25 do table.remove(object.fields) end
                    for _, field in ipairs(object.fields) do
                        if field.name and #field.name > 256 then field.name = field.name:sub(1, 253) .. '...' end
                        if field.value and #field.value > 1024 then field.value = field.value:sub(1, 1021) .. '...' end
                    end

                    if object.footer and object.footer.text and #object.footer.text > 2048 then object.footer.text = object.footer.text:sub(1, 2045) .. '...' end

                    table.insert(payload.embeds, object)
                end
            end
        end

        PerformHttpRequest(url, function(status, response, _, errorData)
            LOG(2, '[^3WEBHOOK^7]', 'Response code:', tostring(status))
            LOG(2, '[^3WEBHOOK^7]', 'Response:', tostring(response))
            LOG(2, '[^3WEBHOOK^7]', 'Error:', tostring(errorData))
        end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
    end
end

local success, message
success, message = lib.checkDependency('oxmysql', '2.6.0')
if not success then return LOG(4, message) end

success, message = lib.checkDependency('ox_lib', '3.0.0')
if not success then return LOG(4, message) end
if not lib then return LOG(4, ('`%s` needs `ox_lib` resource to run'):format(RESOURCE)) end

if FRAMEWORK == 'auto' then
    if GetResourceState('es_extended') == 'started' then
        FRAMEWORK = 'ESX'
        ESX = exports['es_extended']:getSharedObject()
    elseif GetResourceState('qb-core') == 'started' then
        FRAMEWORK = 'QB'
        QB = exports['qb-core']:GetCoreObject()
    else FRAMEWORK = nil end
elseif FRAMEWORK == 'ESX' then
    if GetResourceState('es_extended') == 'started' then
        FRAMEWORK = 'ESX'
        ESX = exports['es_extended']:getSharedObject()
    end
elseif FRAMEWORK == 'QB' then
    if GetResourceState('qb-core') == 'started' then
        FRAMEWORK = 'QB'
        QB = exports['qb-core']:GetCoreObject()
    end
end
if not FRAMEWORK then return LOG(4, 'No framework found') end

LOADED = true
lib.locale()