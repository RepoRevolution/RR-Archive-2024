function ESX.IsPlayerLoaded()
    return ESX.PlayerLoaded
end

function ESX.GetPlayerData()
    return ESX.PlayerData
end

---@param key string
---@param val any
function ESX.SetPlayerData(key, val)
    local current = ESX.PlayerData[key]
    ESX.PlayerData[key] = val

    if key ~= 'inventory' and key ~= 'loadout' then
        if type(val) == 'table' or val ~= current then
            TriggerEvent('esx:setPlayerData', key, val, current)
        end
    end
end

---@param account string Account name (money/bank/black_money)
---@return table | nil
function ESX.GetAccount(account)
    for i = 1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == account then
            return ESX.PlayerData.accounts[i]
        end
    end
    return nil
end

function ESX.ShowInventory()
    if not Config.Player.enable_default_inventory then return end

end

---@param items string | table<number, string>
---@param count? boolean
---@return table | number
function ESX.SearchInventory(items, count)
    if type(items) == 'string' then items = { items } end

    local returnData = {}
    local itemCount = #items

    for i = 1, itemCount do
        local itemName = items[i]
        returnData[itemName] = count and 0

        for _, item in pairs(ESX.PlayerData.inventory) do
            if item.name == itemName then
                if count then
                    returnData[itemName] = returnData[itemName] + item.count
                else
                    returnData[itemName] = item
                end
            end
        end
    end

    if next(returnData) then
        if itemCount == 1 then
            returnData = returnData[items[1]]
        end
    end

    return returnData
end
