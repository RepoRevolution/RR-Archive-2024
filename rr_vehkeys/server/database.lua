if not LOADED then return end

DB = {}
local DB_CONNECTED = false

function DB.IsConnected()
    return DB_CONNECTED
end

function DB.Keys()
    local self = {}

    function self:getAllPermKeys()
        return MySQL.query.await(('SELECT * FROM `%s`'):format(Config.Database.permanent_keys_table))
    end

    function self:addPermKey(plate, model, owner)
        MySQL.insert(('INSERT INTO `%s` (`plate`, `model`, `owner`) VALUES (?, ?, ?)'):format(Config.Database.permanent_keys_table), { plate, model, owner })
    end

    function self:removePermKey(plate, model, owner)
        if owner then
            MySQL.query(('DELETE FROM `%s` WHERE `plate` = ? OR `plate` = ? AND `model` = ? AND `owner` = ?'):format(Config.Database.permanent_keys_table), { plate, Server.Framework.Trim(plate), model, owner })
        else
            MySQL.query(('DELETE FROM `%s` WHERE `plate` = ? OR `plate` = ? AND `model` = ?'):format(Config.Database.permanent_keys_table), { plate, Server.Framework.Trim(plate), model })
        end
    end

    function self:getOwnedVehicles(owner)
        return MySQL.query.await(('SELECT * FROM `%s` WHERE `%s` = ?'):format(Config.Database.vehicles_table, Config.Database.vehicles_table_owner_column), { owner })
    end

    function self:getVehicleOwner(plate)
        return MySQL.scalar.await(('SELECT `%s` FROM `%s` WHERE `%s` = ? OR `%s` = ?'):format(Config.Database.vehicles_table_owner_column, Config.Database.vehicles_table, Config.Database.vehicles_table_plate_column, Config.Database.vehicles_table_plate_column), { plate, Server.Framework.Trim(plate) })
    end

    return self
end

MySQL.ready(function()
    local query = ([[
        CREATE TABLE IF NOT EXISTS `%s` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `plate` varchar(12) NOT NULL,
            `model` varchar(255) NOT NULL,
            `owner` varchar(48) NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci
    ]]):format(Config.Database.permanent_keys_table)

    if MySQL.query.await(query) then
        LOG(2, '[^1SQL^7]', ('Prepared MySQL for resource ^5%s^7'):format(RESOURCE))
    else
        return LOG(4, ('Unable to prepare MySQL for resource ^5%s^7'):format(RESOURCE))
    end

    DB_CONNECTED = true
end)