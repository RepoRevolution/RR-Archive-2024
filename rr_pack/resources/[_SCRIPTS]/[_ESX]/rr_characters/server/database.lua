---@diagnostic disable: cast-local-type
DB = {}
local DB_NAME, DB_CONNECTED, DB_TABLES, DB_PREFIX = nil, false, {}, Config.Database.character_prefix

function DB.IsConnected()
    return DB_CONNECTED
end

function DB.GetPrefix()
    return DB_PREFIX
end

function DB.Slots()
    local self = {}

    function self:getSlots(identifier)
        return MySQL.scalar.await(('SELECT `slots` FROM `%s` WHERE `identifier` = ?'):format(Config.Database.slots_table), { identifier })
    end

    function self:updateSlots(identifier, slots)
        if slots then
            MySQL.insert(('INSERT INTO `%s` (`identifier`, `slots`) VALUES (?, ?) ON DUPLICATE KEY UPDATE `slots` = VALUES(`slots`)'):format(Config.Database.slots_table), { identifier, slots })
        else
            MySQL.query(('DELETE FROM `%s` WHERE `identifier` = ?'):format(Config.Database.slots_table), { identifier })
        end
    end

    return self
end

function DB.Mugshots()
    local self = {}

    function self:getMugshots(identifier)
        local result = {}
        local response = MySQL.query.await(('SELECT `identifier`, `url` FROM `%s` WHERE `identifier` LIKE ?'):format(Config.Database.mugshots_table), { identifier })
        if response then
            for _, mugshot in ipairs(response) do
                result[mugshot.identifier] = mugshot.url
            end
        end
        return result
    end

    function self:updateMugshot(charId, url)
        MySQL.insert(('INSERT INTO `%s` (`identifier`, `url`) VALUES (?, ?) ON DUPLICATE KEY UPDATE `url` = VALUES(`url`)'):format(Config.Database.mugshots_table), { charId, url })
    end

    return self
end

function DB.Users()
    local self = {}

    function self:getCharacters(identifier, slots)
        local result = {}
        local response = MySQL.query.await(('SELECT `identifier`, `firstname`, `lastname`, `disabled`, `created`, `last_seen`, `play_time`, `sex`, `dateofbirth`, `position`, `job`, `job_grade`, `accounts`, `skin` FROM `%s` WHERE `identifier` LIKE ? LIMIT ?'):format(Config.Database.users_table), { identifier, slots })
        if response then
            for _, character in ipairs(response) do
                local id = tonumber(character.identifier:sub(#DB_PREFIX + 1, character.identifier:find(':') - 1))
                if id then
                    result[id] = character
                end
            end
        end

        local mugshots = DB.Mugshots():getMugshots(identifier)
        for charId, url in pairs(mugshots) do
            local id = tonumber(charId:sub(#DB_PREFIX + 1, charId:find(':') - 1))
            if id then
                result[id].mugshot = url
            end
        end
        return result
    end

    function self:createCharacter(charId, data)
        return MySQL.insert.await(('INSERT INTO `%s`(`identifier`, `firstname`, `lastname`, `sex`, `dateofbirth`, `height`, `metadata`) VALUES (?, ?, ?, ?, ?, ?, ?)'):format(Config.Database.users_table), {
            charId,
            data.firstName, data.lastName,
            data.sex, data.dateOfBirth, data.height,
            json.encode(data.metadata)
        })
    end

    function self:toggleCharacter(charId, state)
        return MySQL.update.await(('UPDATE `%s` SET `disabled` = ? WHERE `identifier` = ?'):format(Config.Database.users_table), { state, charId })
    end

    function self:getCharacterPlayTime(charId)
        return MySQL.scalar.await(('SELECT `play_time` FROM `%s` WHERE `identifier` = ? LIMIT 1'):format(Config.Database.users_table), { charId })
    end

    function self:updateCharacterPlayTime(charId, seconds)
        return MySQL.update(('UPDATE `%s` SET `play_time` = ? WHERE `identifier` = ?'):format(Config.Database.users_table), { seconds, charId })
    end

    function self:deleteCharacter(charId)
        local queries = {}

        if Config.Database.full_character_remove then
            for tableName, column in pairs(DB_TABLES) do
                queries[#queries + 1] = { query = ('DELETE FROM `%s` WHERE `%s` = ?'):format(tableName, column), values = { charId } }
            end
        else
            queries[#queries + 1] = { query = ('DELETE FROM `%s` WHERE `identifier` = ?'):format(Config.Database.users_table, charId), values = { charId } }
        end

        return MySQL.transaction.await(queries)
    end

    return self
end

Citizen.CreateThread(function()
    local mysql_connection_string = GetConvar('mysql_connection_string', '')
    if mysql_connection_string == '' then
        LOG(4, ('Unable to start `%s`. Unable to determine database from `mysql_connection_string` in your server.cfg file.'):format(RESOURCE))
    elseif mysql_connection_string:find('mysql://') then
        mysql_connection_string = mysql_connection_string:sub(9, -1)
		DB_NAME = mysql_connection_string:sub(mysql_connection_string:find('/')+1, -1):gsub('[%?]+[%w%p]*$', '')
    else
        mysql_connection_string = { mysql_connection_string:strsplit(';') }
        for _, val in ipairs(mysql_connection_string) do
            if val:match('database') then
                DB_NAME = val:sub(10, #val)
                break
            end
        end
    end

    MySQL.ready(function()
        local length = #DB_PREFIX + #tostring(Config.Database.max_characters) + 1 + Config.Database.identifier_length

        local insert = {}
        insert[#insert + 1] = {
            query = (
                'ALTER TABLE `%s`' ..
                'ADD COLUMN IF NOT EXISTS `firstname` varchar(%s) DEFAULT NULL,' ..
                'ADD COLUMN IF NOT EXISTS `lastname` varchar(%s) DEFAULT NULL,' ..
                'ADD COLUMN IF NOT EXISTS `sex` varchar(1) DEFAULT NULL,' ..
                'ADD COLUMN IF NOT EXISTS `dateofbirth` varchar(10) DEFAULT NULL,' ..
                'ADD COLUMN IF NOT EXISTS `height` int(11) DEFAULT NULL,' ..
                'ADD COLUMN IF NOT EXISTS `disabled` tinyint(1) DEFAULT 0,' ..
                'ADD COLUMN IF NOT EXISTS `created` timestamp DEFAULT current_timestamp(),' ..
                'ADD COLUMN IF NOT EXISTS `last_seen` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),' .. 
                'ADD COLUMN IF NOT EXISTS `play_time` bigint(20) DEFAULT NULL'
            ):format(Config.Database.users_table, Config.Identity.validation_data.max_name_length, Config.Identity.validation_data.max_name_length)
        }

        insert[#insert + 1] = {
            query = ([[
                CREATE TABLE IF NOT EXISTS `%s` (
                    `identifier` varchar(%s) NOT NULL,
                    `url` longtext NOT NULL,
                    PRIMARY KEY (`identifier`),
                    CONSTRAINT `%s_ibfk_1` FOREIGN KEY (`identifier`) REFERENCES `%s` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci
            ]]):format(Config.Database.mugshots_table, length, Config.Database.mugshots_table, Config.Database.users_table)
        }

        insert[#insert + 1] = {
            query = ([[
                CREATE TABLE IF NOT EXISTS `%s` (
                    `identifier` varchar(%s) NOT NULL,
                    `slots` int(11) NOT NULL,
                    PRIMARY KEY (`identifier`),
                    KEY `slots` (`slots`) USING BTREE
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci
            ]]):format(Config.Database.slots_table, Config.Database.identifier_length)
        }
        
        if MySQL.transaction.await(insert) then
            LOG(2, '[^1SQL^7]', ('Prepared MySQL for resource ^5%s^7'):format(RESOURCE))
        else
            return LOG(4, ('Unable to prepare MySQL for resource ^5%s^7'):format(RESOURCE))
        end

        local columns, count = {}, 0
        local DB_COLUMNS = MySQL.query.await("SELECT TABLE_NAME, COLUMN_NAME, CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = ? AND DATA_TYPE = 'varchar' AND COLUMN_NAME IN (?)", { DB_NAME, { 'identifier', 'owner', 'citizenid' } })
        if DB_COLUMNS then
            for _, column in ipairs(DB_COLUMNS) do
                DB_TABLES[column.TABLE_NAME] = column.COLUMN_NAME
    
                if column?.CHARACTER_MAXIMUM_LENGTH ~= length then
                    count = count + 1
                    columns[column.TABLE_NAME] = column.COLUMN_NAME
                    LOG(2, '[^1SQL^7]', ('Found ^5%s^7 column in ^5%s^7 with different length ^5VARCHAR(%s)^7'):format(column.COLUMN_NAME, column.TABLE_NAME, column.CHARACTER_MAXIMUM_LENGTH))
                end
            end
    
            if next(columns) then
                local query = 'ALTER TABLE `%s` MODIFY COLUMN `%s` VARCHAR(%s)'
                local drop, queries, restore = {}, {}, {}
    
                for tableName, column in pairs(columns) do
                    local constraints = {}
                    local foreignKeys = MySQL.query.await(('SELECT CONSTRAINT_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = "%s" AND TABLE_NAME = "%s" AND COLUMN_NAME = "%s" AND REFERENCED_TABLE_NAME IS NOT NULL'):format(DB_NAME, tableName, column))
    
                    if foreignKeys then
                        LOG(2, '[^1SQL^7]', ('Found ^5%s^7 foreign keys for ^5%s^7.%s'):format(#foreignKeys, tableName, column))
                        for _, foreignKey in ipairs(foreignKeys) do 
                            local constraint = {
                                name = foreignKey.CONSTRAINT_NAME,
                                table = foreignKey.REFERENCED_TABLE_NAME,
                                column = foreignKey.REFERENCED_COLUMN_NAME
                            }
                            local rules = MySQL.query.await(('SELECT UPDATE_RULE, DELETE_RULE FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = "%s" LIMIT 1'):format(foreignKey.CONSTRAINT_NAME))
                            if rules then
                                constraint.update = rules[1].UPDATE_RULE
                                constraint.delete = rules[1].DELETE_RULE
                                constraints[#constraints + 1] = constraint
                            end
                        end
                    end
    
                    for _, constraint in ipairs(constraints) do
                        query = 'ALTER TABLE `%s` DROP FOREIGN KEY `%s`'
                        LOG(2, '[^1SQL^7]', ('Dropping foreign key ^5%s^7 from ^5%s^7.%s'):format(constraint.name, tableName, column))
                        drop[#drop + 1] = { query = query:format(tableName, constraint.name) }
                    end
    
                    queries[#queries + 1] = { query = query:format(tableName, column, length) }
                    LOG(2, '[^1SQL^7]', ('Updating ^5%s^7.%s to use ^5VARCHAR(%s)^7'):format(tableName, column, length))
    
                    for _, constraint in ipairs(constraints) do
                        query = 'ALTER TABLE `%s` ADD CONSTRAINT `%s` FOREIGN KEY (`%s`) REFERENCES `%s`(`%s`) ON UPDATE %s ON DELETE %s'
                        LOG(2, '[^1SQL^7]', ('Restore foreign key ^5%s^7 to ^5%s^7.%s'):format(constraint.name, tableName, column))
                        restore[#restore + 1] = { query = query:format(tableName, constraint.name, column, constraint.table, constraint.column, constraint.update, constraint.delete) }
                    end
                end
    
                if MySQL.transaction.await(drop) and MySQL.transaction.await(queries) and MySQL.transaction.await(restore) then
                    LOG(1, ('Updated ^5%s^7 columns to use ^5VARCHAR(%s)^7'):format(count, length))
                else
                    return LOG(4, ('Unable to update ^5%s^7 columns to use ^5VARCHAR(%s)^7'):format(count, length))
                end
            end
    
            DB_CONNECTED = true

            while not next(ESX.Jobs) do
                ESX.Jobs = ESX.GetJobs()
                Citizen.Wait(500)
            end
        end
    end)
end)