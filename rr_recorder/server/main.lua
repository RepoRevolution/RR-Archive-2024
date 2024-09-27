if not LOADED then return end

local function splitString(inputstr, sep)
    sep = sep or '%s'
    local t = {}
    for str in string.gmatch(inputstr, '([^'..sep..']+)') do
        table.insert(t, str)
    end
    return t
end

local function getCharacter(source)
    if FRAMEWORK == 'ESX' then
        return ESX.GetPlayerFromId(source)
    elseif FRAMEWORK == 'QB' then
        return QBCore.Functions.GetPlayer(source)
    end
end

local function getCharacterIdentifier(source)
    local character = getCharacter(source)
    if FRAMEWORK == 'ESX' then
        return character.getIdentifier()
    elseif FRAMEWORK == 'QB' then
        return character.PlayerData.citizenid
    end
end

local function getCharacterName(source)
    local character = getCharacter(source)
    if FRAMEWORK == 'ESX' then
        return character.getName()
    elseif FRAMEWORK == 'QB' then
        return character.PlayerData.charinfo.firstname .. ' ' .. character.PlayerData.charinfo.lastname
    end
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
    result['charId'] = getCharacterIdentifier(source)
    result['charName'] = getCharacterName(source)
    return result
end

lib.callback.register(RESOURCE .. ':server:getIdentifiers', function(source)
    return getIdentifiers(source)
end)