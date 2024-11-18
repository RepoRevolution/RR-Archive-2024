---@diagnostic disable: undefined-field, inject-field
---@class DiscordMentions
---@field roles? table<number, number | string>
---@field users? table<number, number>

---@class DiscordEmbedField
---@field name? string(len: 256)
---@field value? string(len: 1024)
---@field inline? boolean

---@class DiscordEmbedFooter
---@field text? string(len: 2048)
---@field icon_url? string

---@class DiscordEmbed
---@field author table<string, string>
---@field color? number
---@field title? string(len: 256)
---@field description? string(len: 4096)
---@field fields table<number, DiscordEmbedField>(len: 25)
---@field image? string
---@field footer DiscordEmbedFooter

---@class DiscordWebhook
---@field username? string(len: 80)
---@field avatar_url? string
---@field tts? boolean
---@field mentions DiscordMentions
---@field content? string(len: 2000)
---@field embeds table<number, DiscordEmbed>(len: 10)

---@param webhook string
---@param params DiscordWebhook
function ESX.DiscordLog(webhook, params)
    if not webhook or not params then return end
    local invoking = GetInvokingResource() or cache.resource

    local payload = {
        username = params.username or invoking,
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

    ---@diagnostic disable-next-line: param-type-mismatch
    PerformHttpRequest(webhook, nil, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end
