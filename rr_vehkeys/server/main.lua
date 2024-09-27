if not DB then return end
while not DB.IsConnected() do Citizen.Wait(100) end

local fw = lib.require('server.framework')
if not fw then return end
Server = {}
Server.Framework = fw
Server.Keys = {}

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

local function contains(list, plate, model)
    for _, v in ipairs(list) do
        if v.plate == plate and v.model == model then
            return true
        end
    end
    return false
end

local function getIndex(list, plate, model)
    for index, v in ipairs(list) do
        if v.plate == plate and v.model == model then
            return index
        end
    end
end

local function getKeys(source)
    local owner = fw.getPlayerIdentifier(source)
    if not owner then return {} end

    local keys = Server.Keys[owner] or {}
    if not keys.owned then
        local ownedKeys = DB.Keys():getOwnedVehicles(owner)
        for _, key in ipairs(ownedKeys) do
            local owned = keys.owned or {}
            local plate = key[Config.Database.vehicles_table_plate_column]
            local model = key[Config.Database.vehicles_table_model_column]
            
            if plate and model then
                if type(plate) == 'string' then
                    local json_plate = json.decode(plate)
                    if json.isobject(json_plate) then
                        plate = json_plate.plate or nil
                    end
                end
                if type(model) == 'string' then
                    local json_model = json.decode(model)
                    if json.isobject(json_model) then
                        model = json_model.model or 0
                    end
                end
                if plate then
                    local temp = keys.temp or nil
                    if temp and contains(temp, plate, model) then
                        table.remove(temp, getIndex(temp, plate, model))
                        keys.temp = temp
                    end
                    
                    local perm = keys.perm or nil
                    if perm and contains(perm, plate, model) then
                        table.remove(perm, getIndex(perm, plate, model))
                        DB.Keys():removePermKey(plate, model, owner)
                        keys.perm = perm
                    end

                    table.insert(owned, { plate = plate, model = model })
                end
            end
            keys.owned = owned
        end
        Server.Keys[owner] = keys

        Citizen.SetTimeout(15000, function()
            if not Server.Keys[owner] then return end
            Server.Keys[owner].owned = nil
        end)
    end

    return keys
end
lib.callback.register(RESOURCE .. ':server:getKeys', getKeys)
exports('getKeys', getKeys)

RegisterNetEvent(RESOURCE .. ':server:giveKey', function(plate, model, keyType, stolen)
    local _source = source
    local owner = fw.getPlayerIdentifier(_source)
    if not owner then return end

    local keys = getKeys(_source)
    if not contains(keys.owned or {}, plate, model) and not contains(keys.temp or {}, plate, model) and not contains(keys.perm or {}, plate, model) then
        if keyType == 0 then
            local temp = keys.temp or {}
            table.insert(temp, { plate = plate, model = model, stolen = stolen or nil })
            keys.temp = temp
        elseif keyType == 1 then
            local perm = keys.perm or {}
            table.insert(perm, { plate = plate, model = model })
            DB.Keys():addPermKey(plate, model, owner)
            keys.perm = perm
        end
    else
        TriggerClientEvent(RESOURCE .. ':client:notify', _source, 'error', nil, locale('keys_get_already_have'):format(plate))
        return
    end
    Server.Keys[owner] = keys

    TriggerClientEvent(RESOURCE .. ':client:updateKeys', _source, keys)
    TriggerClientEvent(RESOURCE .. ':client:notify', _source, 'success', nil, locale('keys_get'):format(keyType == 0 and locale('keys_temporary') or locale('keys_permanent'), plate))
    
    local webhook = Config.Logs.give_key
    if webhook and webhook.enabled then
        local identifiers = getIdentifiers(source)
        DISCORD_LOG(webhook.url, {
            mentions = webhook.mentions,
            embeds = {
                {
                    color = webhook.color,
                    title = 'Player got keys',
                    description = ('Player **%s** *(%s)* got new keys'):format(identifiers['player'], identifiers['discord'] and ('<@%s>'):format(identifiers['discord']) or 'discord identifier not found'),
                    fields = {
                        {
                            name = 'Plate',
                            value = ('```%s```'):format(plate),
                            inline = true
                        },
                        {
                            name = 'Keys type',
                            value = ('```%s```'):format(keyType == 0 and 'Temporary' or 'Permanent'),
                            inline = true
                        },
                        {
                            name = 'Character ID',
                            value = ('```%s```'):format(owner),
                        }
                    }
                }
            }
        })
    end
    
    LOG(2, '[^2KEYS^7]', ('Player ^5%s ^7get ^5%s ^7keys to the vehicle with the plate ^5%s^7'):format(owner, keyType == 0 and 'temporary' or 'permanent', plate))
end)

lib.addCommand('integrate_keys', {
    help = 'Integrate keys to the closest vehicle',
    params = {
        {
            name = 'keyType',
            type = 'number',
            help = 'Key type, 0 - temporary, 1 - permanent',
            optional = true,
        }
    },
    restricted = 'group.admin'
}, function(source, args, _)
    local keyType = args.keyType or 0
    TriggerClientEvent(RESOURCE .. ':client:integrateKeys', source, keyType)
end)

RegisterNetEvent(RESOURCE .. ':server:giveCopyKey', function(target, plate, model, keyType)
    local _source = source
    local owner = fw.getPlayerIdentifier(_source)
    if not owner then return end

    local identifier = fw.getPlayerIdentifier(target)
    if not identifier then return end

    local keys = getKeys(target)
    if not contains(keys.owned or {}, plate, model) and not contains(keys.temp or {}, plate, model) and not contains(keys.perm or {}, plate, model) then
        if keyType == 0 then
            local temp = keys.temp or {}
            table.insert(temp, { plate = plate, model = model })
            keys.temp = temp
        elseif keyType == 1 then
            local perm = keys.perm or {}
            table.insert(perm, { plate = plate, model = model })
            DB.Keys():addPermKey(plate, model, identifier)
            keys.perm = perm
        end
    else
        TriggerClientEvent(RESOURCE .. ':client:notify', _source, 'error', nil, locale('keys_give_already_have'):format(fw.getName(target), plate))
        return
    end
    Server.Keys[identifier] = keys

    TriggerClientEvent(RESOURCE .. ':client:updateKeys', target, keys)
    TriggerClientEvent(RESOURCE .. ':client:notify', _source, 'success', nil, locale('keys_give'):format(keyType == 0 and locale('keys_temporary') or locale('keys_permanent'), plate, fw.getName(target)))
    TriggerClientEvent(RESOURCE .. ':client:notify', target, 'success', nil, locale('keys_get_copy'):format(keyType == 0 and locale('keys_temporary') or locale('keys_permanent'), plate, fw.getName(_source)))
    
    local webhook = Config.Logs.give_key_copy
    if webhook and webhook.enabled then
        local identifiers1 = getIdentifiers(source)
        local identifiers2 = getIdentifiers(target)
        DISCORD_LOG(webhook.url, {
            mentions = webhook.mentions,
            embeds = {
                {
                    color = webhook.color,
                    title = 'Player got keys from player',
                    description = ('Player **%s** *(%s)* got new keys from player **%s** *(%s)*'):format(identifiers2['player'], identifiers2['discord'] and ('<@%s>'):format(identifiers2['discord']) or 'discord identifier not found', identifiers1['player'], identifiers1['discord'] and ('<@%s>'):format(identifiers1['discord']) or 'discord identifier not found'),
                    fields = {
                        {
                            name = 'Plate',
                            value = ('```%s```'):format(plate),
                            inline = true
                        },
                        {
                            name = 'Keys type',
                            value = ('```%s```'):format(keyType == 0 and 'Temporary' or 'Permanent'),
                            inline = true
                        },
                        {
                            name = 'Target character ID',
                            value = ('```%s```'):format(identifier),
                        },
                        {
                            name = 'Owner character ID',
                            value = ('```%s```'):format(owner),
                        },
                    }
                }
            }
        })
    end

    LOG(2, '[^2KEYS^7]', ('Player ^5%s ^7get ^5%s ^7keys to the vehicle with the plate ^5%s ^7from player ^5%s^7'):format(identifier, keyType == 0 and 'temporary' or 'permanent', plate, owner))
end)

RegisterNetEvent(RESOURCE .. ':server:revokePermKeys', function(plate, model)
    local _source = source
    local owner = fw.getPlayerIdentifier(_source)
    if not owner then return end

    local revoked = {}
    for identifier, keys in pairs(Server.Keys) do
        local perm = keys.perm or nil
        if perm and contains(perm, plate, model) then
            table.remove(perm, getIndex(perm, plate, model))
            table.insert(revoked, identifier)
            keys.perm = perm
            local target = fw.getPlayerSourceFromIdentifier(identifier)
            if target then
                TriggerClientEvent(RESOURCE .. ':client:updateKeys', target, getKeys(target))
                TriggerClientEvent(RESOURCE .. ':client:notify', target, 'success', nil, locale('keys_revoked'):format(plate))
            end
        end
    end
    DB.Keys():removePermKey(plate, model)
    TriggerClientEvent(RESOURCE .. ':client:notify', _source, 'success', nil, locale('keys_revoke_permanent'):format(plate))
    
    local webhook = Config.Logs.revoke_all_keys
    if webhook and webhook.enabled then
        local identifiers = getIdentifiers(source)
        DISCORD_LOG(webhook.url, {
            mentions = webhook.mentions,
            embeds = {
                {
                    color = webhook.color,
                    title = 'Player revoke all keys',
                    description = ('Player **%s** *(%s)* revoke keys'):format(identifiers['player'], identifiers['discord'] and ('<@%s>'):format(identifiers['discord']) or 'discord identifier not found'),
                    fields = {
                        {
                            name = 'Plate',
                            value = ('```%s```'):format(plate),
                            inline = true
                        },
                        {
                            name = 'Keys type',
                            value = '```Permanent```',
                            inline = true
                        },
                        {
                            name = 'Revoked from character IDs',
                            value = ('```%s```'):format(table.concat(revoked, '\n')),
                        },
                        {
                            name = 'Owner character ID',
                            value = ('```%s```'):format(owner),
                        }
                    }
                }
            }
        })
    end

    LOG(2, '[^2KEYS^7]', ('Removed all ^5permanent ^7keys to the vehicle with the plate ^5%s^7'):format(plate))
end)

RegisterNetEvent(RESOURCE .. ':server:removeKey', function(plate, model, keyType)
    local _source = source
    local owner = fw.getPlayerIdentifier(_source)
    if not owner then return end

    local keys = Server.Keys[owner] or nil
    if not keys or not next(keys) then return end

    if keyType == 0 then
        local temp = keys.temp or nil
        if temp and contains(temp, plate, model) then
            table.remove(temp, getIndex(temp, plate, model))
            keys.temp = temp
        end
    elseif keyType == 1 then
        local perm = keys.perm or nil
        if perm and contains(perm, plate, model) then
            table.remove(perm, getIndex(perm, plate, model))
            DB.Keys():removePermKey(plate, model, owner)
            keys.perm = perm
        end
    end
    Server.Keys[owner] = keys

    TriggerClientEvent(RESOURCE .. ':client:updateKeys', _source, getKeys(_source))
    TriggerClientEvent(RESOURCE .. ':client:notify', _source, 'success', nil, locale('keys_drop'):format(keyType == 0 and locale('keys_temporary') or locale('keys_permanent'), plate))
    
    local webhook = Config.Logs.remove_key
    if webhook and webhook.enabled then
        local identifiers = getIdentifiers(source)
        DISCORD_LOG(webhook.url, {
            mentions = webhook.mentions,
            embeds = {
                {
                    color = webhook.color,
                    title = 'Player remove keys',
                    description = ('Player **%s** *(%s)* dropped keys'):format(identifiers['player'], identifiers['discord'] and ('<@%s>'):format(identifiers['discord']) or 'discord identifier not found'),
                    fields = {
                        {
                            name = 'Plate',
                            value = ('```%s```'):format(plate),
                            inline = true
                        },
                        {
                            name = 'Keys type',
                            value = ('```%s```'):format(keyType == 0 and 'Temporary' or 'Permanent'),
                            inline = true
                        },
                        {
                            name = 'Character ID',
                            value = ('```%s```'):format(owner),
                        }
                    }
                }
            }
        })
    end
    
    LOG(2, '[^2KEYS^7]', ('Player ^5%s ^7lost ^5%s ^7keys to the vehicle with the plate ^5%s^7'):format(owner, keyType == 0 and 'temporary' or 'permanent', plate))
end)

RegisterNetEvent(RESOURCE .. ':server:playSound', function(coords, sound, ref, range)
    TriggerClientEvent(RESOURCE .. ':client:playSound', -1, coords, sound, ref, range)
end)

lib.callback.register(RESOURCE .. ':server:getVehicleOwner', function(_, plate)
    local owner = DB.Keys():getVehicleOwner(plate) or nil
    if owner then owner = fw.getPlayerSourceFromIdentifier(owner) or nil end
    return owner
end)

lib.callback.register(RESOURCE .. ':server:getCharacterName', function(_, target)
    return fw.getName(target)
end)

Citizen.CreateThread(function()
    local permKeys = DB.Keys():getAllPermKeys()
    for _, key in ipairs(permKeys) do
        local keys = Server.Keys[key.owner] or {}
        local perm = keys.perm or {}
        if not contains(perm, key.plate, key.model) then
            table.insert(perm, { plate = key.plate, model = tonumber(key.model) })
            keys.perm = perm
        end
        Server.Keys[key.owner] = keys
    end

    if Config.Lockpick.enabled and Config.Lockpick.item then
        fw.registerUsableItem(Config.Lockpick.item, function(source)
            TriggerClientEvent(RESOURCE .. ':client:lockpick', source)
        end)
    end

    if Config.Hotwire.enabled and Config.Hotwire.item then
        fw.registerUsableItem(Config.Hotwire.item, function(source)
            TriggerClientEvent(RESOURCE .. ':client:hotwire', source)
        end)
    end
end)