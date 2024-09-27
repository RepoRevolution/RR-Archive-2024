local Framework = {}

if FRAMEWORK == 'ESX' then
    local function getPlayer(source)
        return ESX.GetPlayerFromId(source)
    end

    function Framework.getPlayerIdentifier(source)
        local xPlayer = getPlayer(source)
        return xPlayer.getIdentifier()
    end

    function Framework.getName(source)
        local xPlayer = getPlayer(source)
        return xPlayer.getName()
    end

    function Framework.getPlayerSourceFromIdentifier(identifier)
        local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
        return xPlayer.source or nil
    end

    function Framework.registerUsableItem(item, fun)
        ESX.RegisterUsableItem(item, fun)
    end

    function Framework.Trim(string)
        return ESX.Math.Trim(string)
    end
elseif FRAMEWORK == 'QB' then
    return nil
-- make your own custom framework here
elseif FRAMEWORK == 'custom' then
    return nil
end

return Framework