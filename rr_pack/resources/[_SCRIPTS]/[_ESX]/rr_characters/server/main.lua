if not LOADED then return end

if not DB then return end
while not DB.IsConnected() do Citizen.Wait(100) end

local DEFAULT_IDENTIFIER, DEFAULT_SLOTS = ESX.GetConfig().Identifier or GetConvar('sv_lan', '') == 'true' and 'ip' or 'license', Config.Characters.default_character_slots or 1

function GetDefaultIdentifier(playerSrc)
    local identifier = GetPlayerIdentifierByType(playerSrc, DEFAULT_IDENTIFIER)
    return identifier and identifier:gsub(DEFAULT_IDENTIFIER .. ':', '')
end

if next(ESX.Players) then
    local players = table.clone(ESX.Players)
	table.wipe(ESX.Players)
	for _, player in pairs(players) do
		ESX.Players[GetDefaultIdentifier(player.source)] = true
	end
else ESX.Players = {} end

AddEventHandler('playerConnecting', function(_, _, deferrals)
	deferrals.defer()
	local identifier = GetDefaultIdentifier(source)
	if identifier then
        if ESX.Players[identifier] then
            deferrals.done(('A player is already connected to the server with this identifier.\nYour identifier: %s:%s'):format(DEFAULT_IDENTIFIER, identifier))
        else
            deferrals.done()
        end
	else
		deferrals.done(('Unable to retrieve player identifier.\nIdentifier type: %s'):format(DEFAULT_IDENTIFIER))
	end
end)

AddEventHandler('playerDropped', function()
	ESX.Players[GetDefaultIdentifier(source)] = nil
end)

RegisterNetEvent(RESOURCE .. ':server:virtualSoloSession', function(boolean, entity)
    if boolean then
        if not entity then
            local playerPed = GetPlayerPed(source)
            SetPlayerRoutingBucket(source, playerPed)
            SetRoutingBucketPopulationEnabled(playerPed, false)
        else
            local bucketId = GetPlayerRoutingBucket(source)
            SetEntityRoutingBucket(entity, bucketId)
        end
    else
        if not entity then SetPlayerRoutingBucket(source, 0)
        else SetEntityRoutingBucket(entity, 0) end
    end
end)

lib.callback.register(RESOURCE .. ':server:loadCharacters', function(source)
    local playerSrc = source
    local identifier = GetDefaultIdentifier(playerSrc)
    ESX.Players[identifier] = true
    local slots = DB.Slots():getSlots(identifier) or DEFAULT_SLOTS
    local charIds = ('%s%%:%s'):format(DB.GetPrefix(), identifier)
    local characters = DB.Users():getCharacters(charIds, slots)

    local result = {}
    for id, character in pairs(characters) do
        character.name = character.firstname .. ' ' .. character.lastname
        character.accounts = json.decode(character.accounts) or {}
        character.position = json.decode(character.position)
        character.sex = character.sex == 'm' and 0 or 1

        local job, grade = character.job or 'unemployed', tostring(character.job_grade)
        if ESX.Jobs[job] and ESX.Jobs[job].grades[grade] then
            grade = ESX.Jobs[job].grades[grade].label
            job = ESX.Jobs[job].label
        end
        character.job, character.job_grade = job, grade

        character.skin = json.decode(character.skin) or {}
        character.mugshot = character.mugshot or nil

        result[id] = character
    end

    return result, slots
end)

local function checkDOBFormat(str)
    local v = Config.Identity.validation_data
    str = tostring(str)
    if not string.match(str, "(%d%d)/(%d%d)/(%d%d%d%d)") then
        return false
    end

    local m, d, y = string.match(str, "(%d+)/(%d+)/(%d+)")

    m = tonumber(m)
    d = tonumber(d)
    y = tonumber(y)

    if ((d <= 0) or (d > 31)) or ((m <= 0) or (m > 12)) or ((y <= v.lowest_year) or (y > v.highest_year)) then
        return false
    elseif m == 4 or m == 6 or m == 9 or m == 11 then
        return d <= 30
    elseif m == 2 then
        if y % 400 == 0 or (y % 100 ~= 0 and y % 4 == 0) then
            return d <= 29
        else
            return d <= 28
        end
    else
        return d <= 31
    end
end

local function formatDate(str)
    local v = Config.Identity.validation_data
    local m, d, y = string.match(str, "(%d+)/(%d+)/(%d+)")
    local date = str

    if v.date_format == "MM/DD/YYYY" then
        date = m .. "/" .. d .. "/" .. y
    elseif v.date_format == "YYYY/MM/DD" then
        date = y .. "/" .. m .. "/" .. d
    else
        date = d .. "/" .. m .. "/" .. y
    end

    return date
end

local function splitString(inputstr, sep)
    sep = sep or '%s'
    local t = {}
    for str in string.gmatch(inputstr, '([^'..sep..']+)') do
        table.insert(t, str)
    end
    return t
end

local function getIdentifiers(source)
    local result = {}
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in ipairs(identifiers) do
        local split = splitString(identifier, ':')
        if #split == 2 and split[1] ~= 'ip' then
            result[split[1]] = split[2]
        end
    end
    result['player'] = GetPlayerName(source)
    return result
end

lib.callback.register(RESOURCE .. ':server:createCharacter', function(source, id, data)
    if type(id) == 'number' and next(data) then
        local identity = { metadata = {} }
        local v = Config.Identity.validation_data
        if not data.firstName or data.firstName:match('%W') or data.firstName:match('%d')
            or data.firstName:len() < 2 or data.firstName:len() > v.max_name_length
        then
            return { error = true, message = locale('invalid_name', v.max_name_length), field = 'firstName' }
        end
        identity.firstName = data.firstName:gsub("^%l", string.upper)

        if not data.lastName or data.lastName:match('%W') or data.lastName:match('%d')
            or data.lastName:len() < 2 or data.lastName:len() > v.max_name_length
        then
            return { error = true, message = locale('invalid_name', v.max_name_length), field = 'lastName' }
        end
        identity.lastName = data.lastName:gsub("^%l", string.upper)

        if not data.sex or data.sex ~= 'm' and data.sex ~= 'f' and data.sex ~= 'M' and data.sex ~= 'F' then
            return { error = true, message = locale('invalid_data'), field = 'sex' }
        end
        identity.sex = data.sex

        data.height = tonumber(data.height)
        if not data.height or data.height < v.min_height or data.height > v.max_height then
            return { error = true, message = locale('invalid_height', v.min_height, v.max_height), field = 'height' }
        end
        identity.height = data.height

        if not data.dateOfBirth or not checkDOBFormat(data.dateOfBirth) then
            LOG(1, data.dateOfBirth, checkDOBFormat(data.dateOfBirth))
            return { error = true, message = locale('invalid_date', v.lowest_year, v.highest_year), field = 'birthDate' }
        end
        identity.dateOfBirth = formatDate(data.dateOfBirth)

        data.nationality = tonumber(data.nationality) + 1
        if not data.nationality or not Config.Identity.nationalities[data.nationality] then
            return { error = true, message = locale('invalid_data'), field = 'nationality' }
        end
        identity.metadata.nationality = Config.Identity.nationalities[data.nationality]

        data.spawnPoint = tonumber(data.spawnPoint) + 1
        if not data.nationality or not Config.Identity.spawn_points[data.spawnPoint] then
            return { error = true, message = locale('invalid_data'), field = 'spawnPoint' }
        end
        identity.metadata.spawnPoint = Config.Identity.spawn_points[data.spawnPoint].position

        if not data.class or not Config.Identity.classes[data.class] then
            return { error = true, message = locale('invalid_data'), field = 'class' }
        end
        identity.metadata.class = data.class

        local charId = ('%s%s:%s'):format(DB.GetPrefix(), id, GetDefaultIdentifier(source))
        if DB.Users():createCharacter(charId, identity) then
            LOG(2, '[^2CHARACTER^7]', ('Player ^5%s ^7created a new character with character id ^5%s^7.'):format(GetPlayerName(source), charId))

            local webhook = Config.Logs.character_created
            if webhook and webhook.enabled then
                local identifiers = getIdentifiers(source)
                DISCORD_LOG(webhook.url, {
                    mentions = webhook.mentions,
                    embeds = {
                        {
                            color = webhook.color,
                            title = 'Character created',
                            description = ('Player **%s** *(%s)* created new character'):format(identifiers['player'], identifiers['discord'] and ('<@%s>'):format(identifiers['discord']) or 'discord identifier not found'),
                            fields = {
                                {
                                    name = 'Character name',
                                    value = ('```%s %s```'):format(identity.firstName, identity.lastName),
                                },
                                {
                                    name = 'Character ID',
                                    value = ('```%s```'):format(charId)
                                }
                            }
                        }
                    }
                })
            end

            return { error = false }
        end
    end

    return { error = true, message = locale('invalid_data'), field = false }
end)

lib.callback.register(RESOURCE .. ':server:deleteCharacter', function(source, id)
    if type(id) == 'number' and Config.Characters.allow_character_remove then
        local charId = ('%s%s:%s'):format(DB.GetPrefix(), id, GetDefaultIdentifier(source))
        if DB.Users():deleteCharacter(charId) then
            LOG(2, '[^1CHARACTER^7]', ('Player ^5%s ^7deleted character with character id ^5%s^7.'):format(GetPlayerName(source), charId))

            local webhook = Config.Logs.character_removed
            if webhook and webhook.enabled then
                local identifiers = getIdentifiers(source)
                DISCORD_LOG(webhook.url, {
                    mentions = webhook.mentions,
                    embeds = {
                        {
                            color = webhook.color,
                            title = 'Character removed',
                            description = ('Player **%s** *(%s)* removed character'):format(identifiers['player'], identifiers['discord'] and ('<@%s>'):format(identifiers['discord']) or 'discord identifier not found'),
                            fields = {
                                {
                                    name = 'Character ID',
                                    value = ('```%s```'):format(charId)
                                }
                            }
                        }
                    }
                })
            end

            return true
        end
    end

    return false
end)

RegisterNetEvent(RESOURCE .. ':server:playCharacter', function(id)
	if type(id) == 'number' then
		TriggerEvent('esx:onPlayerJoined', source, DB.GetPrefix() .. id)
		ESX.Players[GetDefaultIdentifier(source)] = true

        LOG(2, '[^2CHARACTER^7]', ('Player ^5%s ^7selected character with id ^5%s ^7for play.'):format(GetPlayerName(source), id))
	end
end)

RegisterNetEvent(RESOURCE .. ':server:characterRegistered', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

	local playerClass = xPlayer.getMeta('class')
	for id, class in pairs(Config.Identity.classes) do
		if id == playerClass then
			for item, count in pairs(class.items) do
				xPlayer.addInventoryItem(item, count)
			end
			break
		end
	end

    LOG(2, '[^2CHARACTER^7]', ('Player ^5%s ^7has successfully registered a new character ^5%s^7.'):format(GetPlayerName(source), xPlayer.getName()))

    local webhook = Config.Logs.character_registered
        if webhook and webhook.enabled then
            local identifiers = getIdentifiers(source)
            DISCORD_LOG(webhook.url, {
                mentions = webhook.mentions,
                embeds = {
                    {
                        color = webhook.color,
                        title = 'Character registered',
                        description = ('Player **%s** *(%s)* registered character and collected start items'):format(identifiers['player'], identifiers['discord'] and ('<@%s>'):format(identifiers['discord']) or 'discord identifier not found'),
                        fields = {
                            {
                                name = 'Character name',
                                value = ('```%s```'):format(xPlayer.getName())
                            },
                            {
                                name = 'Character ID',
                                value = ('```%s```'):format(xPlayer.getIdentifier())
                            }
                        }
                    }
                }
            })
        end
end)

local playerPlayTime = {}
AddEventHandler('esx:playerLoaded', function(_, xPlayer)
	local charId = xPlayer.getIdentifier()
	local playTime = DB.Users():getCharacterPlayTime(charId) or 0
	playerPlayTime[charId] = { joined = os.time(), time = playTime }
end)

AddEventHandler('esx:playerDropped', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local charId = xPlayer.getIdentifier()
	local exited = os.time()
	if not playerPlayTime[charId] then return end
	local playTime = playerPlayTime[charId].time + os.difftime(exited, playerPlayTime[charId].joined)
	DB.Users():updateCharacterPlayTime(charId, playTime)
end)

RegisterNetEvent(RESOURCE .. ':server:relog', function()
	TriggerEvent('esx:playerLogout', source)
end)

RegisterNetEvent(RESOURCE .. ':server:updateMugshot', function(charId, url)
	if not charId or not url then return end
    DB.Mugshots():updateMugshot(charId, url)
end)

lib.addCommand('setslots', {
    help = locale('command_setslots_help'),
    params = {
        {
            name = 'target',
            type = 'string',
            help = locale('command_setslots_target_help')
        },
        {
            name = 'slots',
            type = 'number',
            help = locale('command_setslots_slots_help'),
            optional = true,
        },
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    DB.Slots():setSlots(args.target, args.slots)

    TriggerClientEvent('ox_lib:notify', source, {
        id = 'rr_characters.setslots',
        message = (locale('notify_set_slots')):format(args.target, args.slots or DEFAULT_SLOTS)
    })
end)

lib.addCommand('togglecharacter', {
    help = locale('command_togglecharacter_help'),
    params = {
        {
            name = 'target',
            type = 'string',
            help = locale('command_togglecharacter_target_help')
        },
        {
            name = 'id',
            type = 'number',
            help = locale('command_togglecharacter_target_character_help'),
        },
        {
            name = 'state',
            type = 'number',
            help = locale('command_togglecharacter_state_help'),
        },
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    args.state = args.state > 0 and true or false
    local charId = ('%s%s:%s'):format(DB.GetPrefix(), args.id, args.target)
    if DB.Users():toggleCharacter(charId, args.state) then
        TriggerClientEvent('ox_lib:notify', source, {
            id = 'rr_characters.togglecharacter',
            message = (locale('notify_toggle_character')):format(args.target, args.id, args.state and locale('notify_toggle_character_enabled') or locale('notify_toggle_character_disabled'))
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            id = 'rr_characters.togglecharacter',
            message = (locale('notify_toggle_character_error')):format(args.id, args.target)
        })
    end
end)