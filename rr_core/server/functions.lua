ESX.GetPlayers = GetPlayers

---@param playerId integer
---@param byType string? 'steam' | 'license' | 'license2' | 'xbl' | 'ip' | 'discord' | 'live'  | 'fivem'
---@return string | nil
function ESX.GetIdentifier(playerId, byType)
    if Config.EnableDebug or GetConvarInt('sv_fxdkMode', 0) == 1 then
        return ('ESX-DEBUG-LICENSE%s'):format(playerId and ('-ID(%s)'):format(playerId) or '')
    end

    local identifier
    byType = byType or ('%s:'):format(Config.Identifier:lower())

    for _, v in ipairs(GetPlayerIdentifiers(playerId)) do
        if string.match(v, byType) then
            identifier = string.gsub(v, byType, '')
            break
        end
    end

    return identifier
end

function ESX.RegisterUsableItem(item, cb)
    Server.UsableItemsCallbacks[item] = cb
end

function ESX.UseItem(source, item, ...)
    if ESX.Items[item] then
        local itemCallback = Server.UsableItemsCallbacks[item]

        if itemCallback then
            local success, result = pcall(itemCallback, source, item, ...)

            if not success then
                return ESX.Print(result and 'error' or 'warning', result and result or ('An error occured when using item ^5`%s`^7! This was not caused by ESX.'):format(item))
            end
        end
    else
        ESX.Print('warning', ('Item ^5`%s`^7 was used but does not exist!'):format(item))
    end
end

function ESX.GetItemLabel(item)
    if Config.OxInventory then
        item = exports.ox_inventory:Items(item)
        if item then
            return item.label
        end
    end

    if not ESX.Items[item] then
        return ESX.Print('warning', ('Attemting to get invalid Item -> ^5%s^7'):format(item))
    end

    return ESX.Items[item].label
end

function ESX.GetUsableItems()
    local usables = {}

    for k in pairs(Server.UsableItemsCallbacks) do
        usables[k] = true
    end

    return usables
end

---@param type string
---@param name string
---@param count number
---@param label string
---@param coordinates xPlayer | vector3 | number
---@param components any
---@param tintIndex any
function ESX.CreatePickup(type, name, count, label, coordinates, components, tintIndex)
    local pickupId = (Server.PickupId == 65635 and 0 or Server.PickupId + 1)
    local coords

    local typeCoordinates = type(coordinates)

    if typeCoordinates == 'table' and coordinates.getCoords then -- xPlayer
        coords = coordinates.getCoords()
    elseif typeCoordinates == 'vector3' then
        coords = coordinates
    elseif typeCoordinates == 'number' then
        local xPlayer = ESX.Players[coordinates]
        coords = xPlayer and xPlayer.getCoords()
    end

    if not coords then return ESX.Print('error', 'The 5th parameter passed in ^3ESX.CreatePickup^7 is invalid!') end

    Server.Pickups[pickupId] = { type = type, name = name, count = count, label = label, coords = coords }

    if type == 'item_weapon' then
        Server.Pickups[pickupId].components = components
        Server.Pickups[pickupId].tintIndex = tintIndex
    end

    ESX.TriggerSafeEvent('esx:createPickup', -1, {
        pickupId = pickupId,
        label = label,
        coords = coords,
        type = type,
        name = name,
        components = components,
        tintIndex = tintIndex
    }, { server = false, client = true })

    Server.PickupId = pickupId
end
