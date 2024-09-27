if not LOADED then return end
--
local DB_NAME, DB_CONNECTED, DB_TABLES = nil, false, {}
local START_MONEY, START_MONEY_WITH_CHARACTERS, IN_CIRCULATION_MONEY, INFLATION = 0.0, 0.0, 0.0, 0.0
local DB_MONEY_INFO, DB_MONEY_WARNINGS = {}, {}

local function round(number)
    local value = ('%.2f'):format(number)
    local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right
end

local function buildQuery(tableName, columns)
    local query = 'SELECT '
    for i = 1, #columns, 1 do
        local column = columns[i]
        if not columns[i + 1] then
            query = query .. '`' .. column .. '` '
        else
            query = query .. '`' .. column .. '`, '
        end
    end
    query = query .. 'FROM `' .. tableName .. '`'
    return query
end

local function calculateInflation()
    INFLATION = START_MONEY_WITH_CHARACTERS > 0 and (((IN_CIRCULATION_MONEY - START_MONEY_WITH_CHARACTERS) / START_MONEY_WITH_CHARACTERS) * 100) or 0.0
end

local function jsonGetMoney(data, sum)
    if not sum then sum = 0.0 end
    if json.isarray(data) then
        for _, value in ipairs(data) do
            if json.isarray(value) or json.isobject(value) then
                sum = jsonGetMoney(value, sum)
            end
        end
    elseif json.isobject(data) then
        local id = data.name or data.id
        if (id and lib.table.contains(Config.Database.column_keywords, id)) or not id then
            for key, subdata in pairs(data) do
                if (not id and lib.table.contains(Config.Database.object_keywords, key)) or lib.table.contains(Config.Database.object_fields_keywords, key) then
                    if type(subdata) == 'number' then
                        sum = sum + subdata
                    elseif json.isarray(subdata) or json.isobject(subdata) then
                        sum = jsonGetMoney(subdata, sum)
                    end
                end
            end
        end
    end

    return sum
end

local function lastValue(tableName, column, primaryKey, value)
    if primaryKey then
        if not DB_MONEY_INFO[tableName] then
            DB_MONEY_INFO[tableName] = {}
        end

        if not DB_MONEY_INFO[tableName][primaryKey] then
            DB_MONEY_INFO[tableName][primaryKey] = {}
        end

        if not DB_MONEY_INFO[tableName][primaryKey][column] then
            DB_MONEY_INFO[tableName][primaryKey][column] = value
        else
            local oldValue = DB_MONEY_INFO[tableName][primaryKey][column]
            local diff = value - oldValue
            if diff < 0.0 and diff < (Config.Money.difference_warning * (-1)) or diff > Config.Money.difference_warning then
                if not DB_MONEY_WARNINGS[tableName] then DB_MONEY_WARNINGS[tableName] = {} end
                if not DB_MONEY_WARNINGS[tableName][primaryKey] then DB_MONEY_WARNINGS[tableName][primaryKey] = {} end
                DB_MONEY_WARNINGS[tableName][primaryKey][column] = {
                    old = oldValue,
                    current = value,
                    difference = diff
                }
            end
            DB_MONEY_INFO[tableName][primaryKey][column] = value
        end
    end
end

local function loadInflation()
    local startMoney = START_MONEY
    local firstLoad = START_MONEY == 0.0
    local inCirculationMoney = 0.0
    DB_MONEY_WARNINGS = {}

    local MONEY = promise:new()
    MySQL.query(('SELECT COUNT(*) FROM `%s`'):format(Config.Database.characters_table), {}, function(response)
        if response then
            local rowCount = tonumber(response[1]['COUNT(*)'])
            MONEY:resolve(0.0 + rowCount * Config.Money.per_character_start)
        end
    end)
    Citizen.Await(MONEY)
    startMoney = startMoney + MONEY.value

    for tableName, columns in pairs(DB_TABLES) do
        MONEY = promise:new()

        local primaryKey = MySQL.scalar.await("SELECT COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_NAME = ? AND CONSTRAINT_NAME = 'PRIMARY' OR TABLE_NAME = ?", { tableName, tableName }) or nil
        if primaryKey and not lib.table.contains(columns, primaryKey) then table.insert(columns, primaryKey) end

        MySQL.query(buildQuery(tableName, columns), {}, function(response)
            if response then
                local money = 0.0
                for _, row in ipairs(response) do
                    local primary = row[primaryKey] or nil
                    for column, data in pairs(row) do
                        if column ~= primaryKey then
                            if type(data) == 'number' then
                                lastValue(tableName, column, primary, data)
                                money = money + data
                            else
                                data = json.decode(data)
                                if data ~= nil then
                                    local jsonMoney = jsonGetMoney(data)
                                    lastValue(tableName, column, primary, jsonMoney)
                                    money = money + jsonMoney
                                end
                            end
                        end
                    end
                end
                MONEY:resolve(money)
            else MONEY:resolve(0.0) end
        end)
        Citizen.Await(MONEY)
        inCirculationMoney = inCirculationMoney + MONEY.value
        if MONEY.value > 0.0 then LOG(2, '[^2UPDATE^7]', ('Loaded %s$ from table `%s` columns `%s`.'):format(round(MONEY.value), tableName, json.encode(columns))) end
    end

    if firstLoad then
        START_MONEY = inCirculationMoney - startMoney
        START_MONEY_WITH_CHARACTERS = START_MONEY + startMoney
        IN_CIRCULATION_MONEY = inCirculationMoney
    else START_MONEY_WITH_CHARACTERS, IN_CIRCULATION_MONEY = startMoney, inCirculationMoney end
    calculateInflation()
    LOG(2, '[^8UPDATED^7]', ('Money base %s$, in circulation %s$, inflation %s%%.'):format(round(START_MONEY_WITH_CHARACTERS), round(IN_CIRCULATION_MONEY), round(INFLATION)))

    local logInflation = Config.Logs.inflation
    if logInflation and logInflation.enabled then
        DISCORD_LOG(logInflation.url, {
            mentions = logInflation.mentions,
            embeds = {
                {
                    color = logInflation.color,
                    title = 'Inflation update',
                    description = 'Recalculated start money and inflation. Check below for details',
                    fields = {
                        {
                            name = 'Start money',
                            value = ('```%s$```'):format(round(START_MONEY_WITH_CHARACTERS)),
                            inline = true
                        },
                        {
                            name = 'Money',
                            value = ('```%s$```'):format(round(IN_CIRCULATION_MONEY)),
                            inline = true
                        },
                        {
                            name = 'Inflation',
                            value = ('```diff\n%s%s%%```'):format(INFLATION > 0 and '+' or '', round(INFLATION)),
                            inline = true
                        }
                    }
                }
            }
        })
    end

    if next(DB_MONEY_WARNINGS) then
        local currentDate = os.date('%Y-%m-%d-%H_%M_%S')
        local fileName = ('log_%s.md'):format(currentDate)
        local fileData, embeds = '', {}
        local tableCount, columnCount, keyCount = 0, 0, 0

        for tableName, keys in pairs(DB_MONEY_WARNINGS) do
            tableCount = tableCount + 1
            fileData = fileData .. ('## Database table: `%s`\n'):format(tableName)
            local description = ''
            for key, columns in pairs(keys) do
                keyCount = keyCount + 1
                description = description .. ('### Primary table key: `%s`\n'):format(key)
                for column, data in pairs(columns) do
                    columnCount = columnCount + 1
                    local info = (
                        'Previous value: %s$\n' ..
                        '%s%s$\n' ..
                        'Current value: %s$'
                    ):format(round(data.old), data.difference > 0 and '+' or '', round(data.difference), round(data.current))
                    description = description .. ('**Table column: `%s`**\n```diff\n%s\n```\n'):format(column, info)
                end
            end
            fileData = fileData .. description
            table.insert(embeds, {
                title = ('Database table: `%s`\n'):format(tableName),
                description = description,
            })
        end

        SaveResourceFile(RESOURCE, 'data/' .. fileName, fileData, -1)

        local logWarning = Config.Logs.money_change_warning
        if logWarning and logWarning.enabled then
            for _, embed in ipairs(embeds) do
                embed.color = logWarning.color
            end

            DISCORD_LOG(logWarning.url, {
                mentions = logWarning.mentions,
                content = (
                    '## Money change detected\n' .. 
                    '*(**%s** columns in **%s** tables with **%s** keys)*\n' ..
                    (#embeds > 10 and ':warning: **WARNING!** Too much data was received! Discord don\'t send all of them. **__CHECK FILE!__**\n' or '') ..
                    '### All details in file: ```%s```'
                ):format(columnCount, tableCount, keyCount, GetResourcePath(RESOURCE) .. '/data/' .. fileName),
                embeds = embeds
            })
        end
    end

    SaveResourceFile(RESOURCE, 'data/current.json', json.encode({
        startMoney = START_MONEY,
        moneyInfo = DB_MONEY_INFO
    }, { indent = true }), -1)
end

local function startInflation()
    while DB_CONNECTED do
        Citizen.Wait(Config.Money.update_interval * 60 * 1000)
        loadInflation()
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if RESOURCE == resourceName then
        SaveResourceFile(RESOURCE, 'data/current.json', json.encode({
            startMoney = START_MONEY,
            moneyInfo = DB_MONEY_INFO
        }, { indent = true }), -1)
    end
end)

Citizen.CreateThread(function()
    local mysql_connection_string = GetConvar('mysql_connection_string', '')
    if mysql_connection_string == '' then
        return LOG(4, ('Unable to start `%s`. Unable to determine database from `mysql_connection_string` in your server.cfg file.'):format(RESOURCE))
    elseif mysql_connection_string:find('mysql://') then
        mysql_connection_string = mysql_connection_string:sub(9, -1)
		DB_NAME = mysql_connection_string:sub(mysql_connection_string:find('/')+1, -1):gsub('[%?]+[%w%p]*$', '')
    else
        ---@diagnostic disable-next-line: cast-local-type
        mysql_connection_string = { mysql_connection_string:strsplit(';') }
        for _, val in ipairs(mysql_connection_string) do
            if val:match('database') then
                DB_NAME = val:sub(10, #val)
                break
            end
        end
    end

    if not DB_NAME or DB_NAME == '' then return LOG(4, ('Unable to start `%s`. Unable to determine database from `mysql_connection_string` in your server.cfg file.'):format(RESOURCE)) end

    local query = ('SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = "%s" AND (COLUMN_NAME IN (?) OR DATA_TYPE = "LONGTEXT")'):format(DB_NAME)
    MySQL.query(query, { Config.Database.column_keywords }, function(DB_SEARCH)
        if DB_SEARCH then
            for _, column in ipairs(DB_SEARCH) do
                local table_name = column.TABLE_NAME
                local column_name = column.COLUMN_NAME
    
                if not Config.Database.ignored_tables[table_name] or (type(Config.Database.ignored_tables[table_name]) == 'table' and not lib.table.contains(Config.Database.ignored_tables[table_name], column_name)) then
                    DB_TABLES[table_name] = DB_TABLES[table_name] or {}
                    table.insert(DB_TABLES[table_name], column_name)
                else LOG(2, '[^1SQL_SEARCH^7]', ('Ignored column `%s` from table `%s`.'):format(column_name, table_name)) end
            end
            DB_CONNECTED = true

            local data = LoadResourceFile(RESOURCE, 'data/current.json')
            data = json.decode(data)
            if data then
                START_MONEY = data.startMoney
                DB_MONEY_INFO = data.moneyInfo
            end

            loadInflation()
            startInflation()
        else return LOG(4, ('Unable to start `%s`. Unable to connect database.'):format(RESOURCE)) end
    end)
end)

local function getInflation(resource)
    resource = resource or GetInvokingResource()
    LOG(2, '[^2INFLATION^7]', ('Resource `%s` get inflation percent.'):format(resource or 'undefined'))

    return INFLATION
end
exports('getInflation', getInflation)

lib.callback.register(RESOURCE .. ':server:getInflation', function(_, resource)
    return getInflation(('[%s (%s)]: %s'):format(GetPlayerName(source), source, resource))
end)

local function getPrice(price, resource)
    if not price then return 1.0 end
    local result = price
    
    if INFLATION < 0.0 then
        result = price - (price * ((INFLATION * -1) / 100))
        if result < 1.0 then result = 1.0 end
    else
        result = price + (price * (INFLATION / 100))
    end
    result = round(result)

    resource = resource or GetInvokingResource()
    LOG(2, '[^2PRICE^7]', ('Resource `%s` calculated inflation price ^1%s$ ^7-> ^2%s$^7.'):format(resource or 'undefined', round(price), result))

    return result
end
exports('getPrice', getPrice)

lib.callback.register(RESOURCE .. ':server:getPrice', function(source, price, resource)
    return getPrice(price, ('[%s (%s)]: %s'):format(GetPlayerName(source), source, resource))
end)

local isBusy = false
lib.addCommand('inflation', {
    help = 'Reload money and calculate inflation',
    params = {},
    restricted = 'group.admin'
}, function(_, _, _)
    if not isBusy then
        isBusy = true
        loadInflation()
        LOG(1, ('Money base %s$, in circulation %s$, inflation %s%%.'):format(round(START_MONEY_WITH_CHARACTERS), round(IN_CIRCULATION_MONEY), round(INFLATION)))
        Citizen.SetTimeout(15000, function()
            isBusy = false
        end)
    end
end)

local function addMoney(amount)
    START_MONEY = START_MONEY + amount
    SaveResourceFile(RESOURCE, 'data/current.json', json.encode({
        startMoney = START_MONEY,
        moneyInfo = DB_MONEY_INFO
    }, { indent = true }), -1)
    loadInflation()
    LOG(2, '[^8UPDATED^7]', ('Added %s$ to start money.'):format(round(amount)))
end
exports('addMoney', addMoney)