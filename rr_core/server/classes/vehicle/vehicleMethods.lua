local xVehicleMethods = {
    ---@param self xVehicle
    setCoords = function(self)
        ---@param coords table | vector3 | vector4
        return function(coords)
            local vector = vector4(coords?.x, coords?.y, coords?.z, coords?.w or coords?.heading or 0.0)

            if not vector then return end

            SetEntityCoords(self.entity, vector.x, vector.y, vector.z, false, false, false, false)
            SetEntityHeading(self.entity, vector.w)
        end
    end,

    ---@param self xVehicle
    getCoords = function(self)
        ---@param vector? boolean whether to return the vehicle coords as vector4 or as table
        ---@return vector4 | table
        return function(vector)
            local coords = GetEntityCoords(self.entity)
            local heading = GetEntityHeading(self.entity)

            return vector and vector4(coords.x, coords.y, coords.z, heading) or { x = coords.x, y = coords.y, z = coords.z, heading = heading }
        end
    end,

    ---@param self xVehicle
    set = function(self)
        ---@param key string
        ---@param value any
        return function(key, value)
            self.variables[key] = value
            Entity(self.entity).state:set(key, value, true)
        end
    end,

    ---@param self xVehicle
    get = function(self)
        ---@param key? string
        ---@return any
        return function(key)
            return key and self.variables[key] or self.variables
        end
    end,

    ---@param self xVehicle
    setMetadata = function(self)
        local validValueTypes = { ['nil'] = true, ['number'] = true, ['string'] = true, ['table'] = true, ['boolean'] = true }

        ---@param index string
        ---@param value? number | string | table | boolean
        ---@param subValue? number | string | table | boolean
        ---@return boolean
        return function(index, value, subValue)
            if not index then
                ESX.Print('error', 'xVehicle.setMetadata ^5index^7 is Missing!')
                return false
            end

            if type(index) ~= 'string' then
                ESX.Print('error', 'xVehicle.setMetadata ^5index^7 should be ^5string^7!')
                return false
            end

            local _type = type(value)

            if not subValue then
                if not validValueTypes[_type] then
                    ESX.Print('error', ('xVehicle.setMetadata ^5%s^7 should be ^5number^7 or ^5string^7 or ^5table^7 or ^5boolean^7!'):format(value))
                    return false
                end

                self.metadata[index] = value
            else
                if _type ~= 'number' and _type ~= 'string' then
                    ESX.Print('error', ('xVehicle.setMetadata ^5value^7 should be ^5string^7 as a subIndex!'):format(value))
                    return false
                end

                ---@cast value number | string

                if not validValueTypes[type(subValue)] then
                    ESX.Print('error', ('xVehicle.setMetadata ^5%s^7 should be ^5number^7 or ^5string^7 or ^5table^7 or ^5boolean^7!'):format(subValue))
                    return false
                end

                if not self.metadata[index] then
                    self.metadata[index] = {}
                end

                self.metadata[index][value] = subValue
            end

            -- TODO: trigger an event to show metadata changed(like xPlayer)
            Entity(self.entity).state:set('metadata', self.metadata, true)

            return true
        end
    end,

    ---@param self xVehicle
    getMetadata = function(self)
        ---@param index? string
        ---@param subIndex? number | string | table
        ---@return nil | number | string | table | boolean
        return function(index, subIndex)
            if not index then return self.metadata end

            if type(index) ~= 'string' then ESX.Print('error', 'xVehicle.getMetadata ^5index^7 should be ^5string^7!') end

            if self.metadata[index] then
                if subIndex and type(self.metadata[index]) == 'table' then
                    local _type = type(subIndex)

                    if _type == 'number' or _type == 'string' then
                        return self.metadata[index][subIndex]
                    elseif _type == 'table' then
                        local returnValues = {}

                        for i = 1, #subIndex do
                            if self.metadata[index][subIndex[i]] then
                                returnValues[subIndex[i]] = self.metadata[index][subIndex[i]]
                            end
                        end

                        return returnValues
                    end

                    return nil
                end

                return self.metadata[index]
            end

            return nil
        end
    end,

    ---@param self xVehicle
    delete = function(self)
        ---@param removeFromDb? boolean delete the entry from database as well or no (defaults to false if not provided and nil)
        return function(removeFromDb)
            local id = self.id
            local entity = self.entity
            local netId = self.netId
            local vin = self.vin
            local plate = self.plate

            if self.owner or self.group then
                if removeFromDb then
                    MySQL.prepare('DELETE FROM `owned_vehicles` WHERE `id` = ?', { self.id })
                else
                    MySQL.prepare('UPDATE `owned_vehicles` SET `stored` = ?, `metadata` = ? WHERE `id` = ?', { self.stored, json.encode(self.metadata), self.id })
                end
            end

            Server.Vehicles[entity] = nil
            Server.VehiclesPropertiesQueue[entity] = nil

            if DoesEntityExist(entity) then DeleteEntity(entity) end

            TriggerEvent('esx:vehicleDeleted', id, entity, netId, vin, plate)
        end
    end,

    ---@param self xVehicle
    setStored = function(self)
        ---@param value? boolean
        ---@param despawn? boolean remove the vehicle entity from the game world as well or not (defaults to false if not provided and nil)
        return function(value, despawn)
            self.stored = value

            MySQL.prepare.await('UPDATE `owned_vehicles` SET `stored` = ? WHERE `id` = ?', { self.stored, self.id })

            if despawn then
                self.delete()
            end
        end
    end,

    ---@param self xVehicle
    setOwner = function(self)
        ---@param newOwner? string
        return function(newOwner)
            self.owner = newOwner

            MySQL.prepare.await('UPDATE `owned_vehicles` SET `owner` = ? WHERE `id` = ?', { self.owner or nil --[[to make sure 'false' is not being sent]], self.id })

            Entity(self.entity).state:set('owner', self.owner, true)
        end
    end,

    ---@param self xVehicle
    setGroup = function(self)
        ---@param newGroup? string
        return function(newGroup)
            self.group = newGroup

            MySQL.prepare.await('UPDATE `owned_vehicles` SET `job` = ? WHERE `id` = ?', { self.group or nil --[[to make sure 'false' is not being sent]], self.id })

            Entity(self.entity).state:set('group', self.group, true)
        end
    end,

    ---@param self xVehicle
    setPlate = function(self)
        ---@param newPlate string
        return function(newPlate)
            self.plate = ('%-8s'):format(newPlate)

            MySQL.prepare.await('UPDATE `owned_vehicles` SET `plate` = ? WHERE `id` = ?', { self.plate, self.id })

            Entity(self.entity).state:set('plate', self.plate, true)
        end
    end
}

return xVehicleMethods
