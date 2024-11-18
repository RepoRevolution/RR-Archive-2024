---@diagnostic disable: undefined-field
local xVehicleMethods = lib.require('server.classes.vehicle.vehicleMethods')

---@type table<entityId, table<number, table>>
Server.VehiclesPropertiesQueue = {}

---@param vehicleId? integer | number
---@param vehicleOwner? string | boolean
---@param vehicleGroup? string | boolean
---@param vehicleNetId integer | number
---@param vehicleEntity integer | number
---@param vehicleModel string
---@param vehiclePlate string
---@param vehicleVin string
---@param vehicleScript string
---@param vehicleMetadata table
---@return xVehicle
local function createExtendedVehicle(vehicleId, vehicleOwner, vehicleGroup, vehicleNetId, vehicleEntity, vehicleModel, vehiclePlate, vehicleVin, vehicleScript, vehicleMetadata)
    ---@type xVehicle
    local self = {} ---@diagnostic disable-line: missing-fields

    self.id = vehicleId
    self.owner = vehicleOwner
    self.group = vehicleGroup
    self.netId = vehicleNetId
    self.entity = vehicleEntity
    self.model = vehicleModel
    self.plate = vehiclePlate
    self.vin = vehicleVin
    self.script = vehicleScript
    self.stored = nil
    self.variables = {}
    self.metadata = vehicleMetadata or {}

    local stateBag = Entity(self.entity).state

    stateBag:set('id', self.id, true)
    stateBag:set('owner', self.owner, true)
    stateBag:set('group', self.group, true)
    stateBag:set('model', self.model, true)
    stateBag:set('plate', self.plate, true)
    stateBag:set('vin', self.vin, true)
    stateBag:set('metadata', self.metadata, true)

    for fnName, fn in pairs(xVehicleMethods) do
        self[fnName] = fn(self)
    end

    for fnName, fn in pairs(Server.ExtendedVehicleMethods) do
        self[fnName] = fn(self)
    end

    return self
end

---@param id? number
---@param owner? string | boolean
---@param group? string | boolean
---@param plate string
---@param model string
---@param script string
---@param metadata table
---@param coords vector3
---@param heading number
---@param vType string
---@param properties table
---@return xVehicle?
local function spawnVehicle(id, owner, group, plate, vin, model, script, metadata, coords, heading, vType, properties)
    local entity = Server.SpawnVehicle(model, vType, coords, heading)

    if not entity then return end

    local xVehicle = createExtendedVehicle(id, owner, group, NetworkGetNetworkIdFromEntity(entity), entity, model, plate, vin, script, metadata)

    Server.Vehicles[xVehicle.entity] = xVehicle

    Server.TriggerEventHooks('onVehicleCreate', { xVehicle = xVehicle })

    Entity(entity).state:set('initVehicle', true, true)

    ESX.SetVehicleProperties(entity, properties)

    if owner or group then xVehicle.setStored(false) end

    TriggerEvent('esx:vehicleCreated', xVehicle.entity, xVehicle.netId, xVehicle)

    return xVehicle
end

---@param modelName string
---@param modelType string
---@param coordinates vector3
---@param heading number
function Server.SpawnVehicle(modelName, modelType, coordinates, heading)
    if modelType == 'bicycle' or modelType == 'quadbike' or modelType == 'amphibious_quadbike' then
        modelType = 'bike'
    elseif modelType == 'amphibious_automobile' or modelType == 'submarinecar' then
        modelType = 'automobile'
    elseif modelType == 'blimp' then
        modelType = 'heli'
    end

    local entity = CreateVehicleServerSetter(joaat(modelName), modelType, coordinates.x, coordinates.y, coordinates.z, heading)

    if not DoesEntityExist(entity) then return ESX.Print('error', ('Failed to spawn vehicle (^4%s^7)'):format(modelName)) end

    TriggerEvent('entityCreated', entity)

    return entity
end

---@param data table | number
---@param coords vector3 | vector4
---@param heading? number
---@param forceSpawn? boolean if true, it will spawn the vehicle no matter if the vehicle already is spawned in the game world. If false or nil, it checks if the vehicle has not been already spawned
---@return table | number | nil
function ESX.CreateVehicle(data, coords, heading, forceSpawn)
    local typeData = type(data)
    local script = GetInvokingResource()

    if typeData ~= 'number' and typeData ~= 'table' then
        ESX.Print('error', ('Invalid type of data (^1%s^7) in ^5ESX.CreateVehicle^7!'):format(typeData))
        return
    end

    if typeData == 'number' then
        local typeCoords = type(coords)

        if typeCoords == 'table' then
            if not coords[1] or not coords[2] or not coords[3] then
                ESX.Print('error', ('Invalid type of coords (^1%s^7) in ^5ESX.CreateVehicle^7!'):format(typeCoords))
                return
            end

            coords = vector3(coords[1], coords[2], coords[3])
            heading = heading or coords[4]
        elseif typeCoords == 'vector4' then
            coords = vector3(coords.x, coords.y, coords.z)
            heading = heading or coords.w
        elseif typeCoords ~= 'vector3' then
            ESX.Print('error', ('Invalid type of coords (^1%s^7) in ^5ESX.CreateVehicle^7!'):format(typeCoords))
            return
        end

        heading = heading or 0.0

        local vehicle = MySQL.prepare.await(('SELECT `owner`, `job`, `plate`, `vin`, `model`, `class`, `vehicle`, `metadata` FROM `owned_vehicles` WHERE `id` = ? %s'):format(not forceSpawn and 'AND `stored` = 1' or ''), { data })

        if not vehicle then
            ESX.Print('error', ('Failed to spawn vehicle with id %s (invalid id%s)'):format(data, not forceSpawn and ' or already spawned' or ''))
            return
        end

        vehicle.vehicle = json.decode(vehicle.vehicle --[[@as string]])
        vehicle.metadata = json.decode(vehicle.metadata --[[@as string]])

        if not vehicle.vin or not vehicle.metadata or not vehicle.model or not vehicle.class then
            local vehicleData = nil

            if vehicle.model then
                local vData = ESX.GetVehicleData(vehicle.model)

                if vData then
                    vehicleData = { model = vehicle.model, data = vData }
                end
            end

            if not vehicleData then
                for vModel, vData in pairs(ESX.GetVehicleData()) do
                    if vData.hash == vehicle.vehicle?.model then
                        vehicleData = { model = vModel, data = vData }
                        break
                    end
                end
            end

            if not vehicleData then
                ESX.Print('error', ('Vehicle model hash (^1%s^7) is invalid \nEnsure vehicle exists in ^2`@es_extended/files/vehicles.json`^7'):format(vehicle.vehicle?.model))
                return
            end

            MySQL.prepare.await('UPDATE `owned_vehicles` SET `vin` = ?, `type` = ?, `model` = ?, `class` = ?, `metadata` = ? WHERE `id` = ?', {
                vehicle.vin or Server.GenerateVin(vehicleData.model),
                vehicleData.data?.type,
                vehicle.model or vehicleData.model,
                vehicle.class or vehicleData.data?.class,
                vehicle.metadata and json.encode(vehicle.metadata) or '{}',
                data
            })

            return ESX.CreateVehicle(data, coords, heading, forceSpawn)
        end

        local modelData = ESX.GetVehicleData(vehicle.model) --[[@as VehicleData]]

        if not modelData then
            ESX.Print('error', ('Vehicle model (^1%s^7) is invalid \nEnsure vehicle exists in ^2`@es_extended/files/vehicles.json`^7'):format(vehicle.model))
            return
        end

        return spawnVehicle(data, vehicle.owner, vehicle.job, vehicle.plate, vehicle.vin, vehicle.model, script, vehicle.metadata, coords, heading, modelData.type, vehicle.vehicle)
    end

    local typeModel = type(data.model)

    if typeModel ~= 'string' and typeModel ~= 'number' then
        ESX.Print('error', ('Invalid type of data.model (^1%s^7) in ^5ESX.CreateVehicle^7!'):format(typeModel))
        return
    end

    if typeModel == 'number' or type(tonumber(data.model)) == 'number' then
        typeModel = 'number'
        data.model = tonumber(data.model) --[[@as number]]

        for vModel, vData in pairs(ESX.GetVehicleData()) do
            if vData.hash == data.model then
                data.model = vModel
                break
            end
        end
    end

    local model = typeModel == 'string' and data.model:lower() or data.model --[[@as string]]
    local modelData = ESX.GetVehicleData(model) --[[@as VehicleData]]

    if not modelData then
        ESX.Print(('Vehicle model (^1%s^7) is invalid \nEnsure vehicle exists in ^2`@es_extended/files/vehicles.json`^7'):format(model), 'error', true)
        return
    end

    local owner = type(data.owner) == 'string' and data.owner or false
    local group = type(data.group) == 'string' and data.group or false
    local stored = data.stored
    local plate = Server.GeneratePlate()
    local vin = Server.GenerateVin(model)
    local metadata = {}
    local vehicleProperties = data.properties or {}

    vehicleProperties.plate = plate
    vehicleProperties.model = modelData.hash -- backward compatibility with esx-legacy

    local vehicleId = (owner or group) and MySQL.prepare.await('INSERT INTO `owned_vehicles` (`owner`, `plate`, `vin`, `vehicle`, `type`, `job`, `model`, `class`, `metadata`, `stored`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        owner or nil, plate, vin, json.encode(vehicleProperties), modelData.type, group or nil, model, modelData.class, json.encode(metadata), stored
    }) or nil

    if stored then
        return vehicleId
    end

    return spawnVehicle(vehicleId, owner, group, plate, vin, model, script, metadata, coords, heading or 90.0, modelData.type, vehicleProperties)
end

---@param vehicleEntity number | integer
---@return xVehicle?
function ESX.GetVehicle(vehicleEntity)
    return Server.Vehicles[vehicleEntity]
end

---@return xVehicle[]
function ESX.GetVehicles()
    local vehicles, size = {}, 0

    for _, xVehicle in pairs(Server.Vehicles) do
        size += 1
        vehicles[size] = xVehicle
    end

    return vehicles
end

---@return string
function Server.GeneratePlate()
    local generatedPlate = string.upper(ESX.GetRandomString(8, string.upper(Config.Patterns.plate)))
    return not MySQL.scalar.await('SELECT 1 FROM `owned_vehicles` WHERE `plate` = ?', { generatedPlate }) and generatedPlate or Server.GeneratePlate()
end

---@param model string
---@return string
function Server.GenerateVin(model)
    local vehicleData = ESX.GetVehicleData(model:lower())

    ---@diagnostic disable-next-line: param-type-mismatch
    local pattern = ('1%s%s.A%s'):format(vehicleData.make == '' and 'ESX' or vehicleData.make:sub(1, 3), model:sub(1, 3), ESX.GetRandomNumber(10))
    local generatedVin = string.upper(ESX.GetRandomString(17, pattern))

    return not MySQL.scalar.await('SELECT 1 FROM `owned_vehicles` WHERE `vin` = ?', { generatedVin }) and generatedVin or Server.GenerateVin(model)
end

---@param resource string?
function Server.SaveVehicles(resource)
    local parameters, pSize = {}, 0
    local vehicles, vSize = {}, 0

    if not next(Server.Vehicles) then return end

    if resource == cache.resource then resource = nil end

    for _, xVehicle in pairs(Server.Vehicles) do
        if not resource or resource == xVehicle.script then
            if (xVehicle.owner or xVehicle.group) ~= false then -- TODO: might need to remove this check as I think it's handled through xVehicle.delete()
                pSize += 1
                parameters[pSize] = { xVehicle.stored, json.encode(xVehicle.metadata), xVehicle.id }
            end

            vSize += 1
            vehicles[vSize] = xVehicle.entity
        end
    end

    if vSize > 0 then
        ESX.DeleteVehicle(vehicles)
    end

    if pSize > 0 then
        MySQL.prepare('UPDATE `owned_vehicles` SET `stored` = ?, `metadata` = ? WHERE `id` = ?', parameters)
    end
end

---@param vehicleEntity integer | number | table<number, number>
function ESX.DeleteVehicle(vehicleEntity)
    local _type = type(vehicleEntity)

    if _type == 'table' then
        for i = 1, #vehicleEntity do
            ESX.DeleteVehicle(vehicleEntity[i])
        end

        return
    end

    if _type ~= 'number' or vehicleEntity <= 0 or not DoesEntityExist(vehicleEntity) or GetEntityType(vehicleEntity) ~= 2 then
        ESX.Print('warning', ('Tried to delete a vehicle entity (^1%s^7) that is invalid!'):format(vehicleEntity))
        return
    end

    local vehicle = Server.Vehicles[vehicleEntity]

    if vehicle then
        vehicle.delete()
    else
        DeleteEntity(vehicleEntity)
        Server.VehiclesPropertiesQueue[vehicleEntity] = nil
    end
end

---@param vehicleEntity integer | number | table<number, number>
---@param properties table<string, any>
function ESX.SetVehicleProperties(vehicleEntity, properties)
    if type(properties) ~= 'table' or not next(properties) then return end

    local _type = type(vehicleEntity)

    if _type == 'table' then
        for i = 1, #vehicleEntity do
            ESX.SetVehicleProperties(vehicleEntity[i], properties)
        end

        return
    end

    if _type ~= 'number' or vehicleEntity <= 0 or not DoesEntityExist(vehicleEntity) or GetEntityType(vehicleEntity) ~= 2 then
        ESX.Print('warning', ('Tried to set properties to a vehicle entity (^1%s^7) that is invalid!'):format(vehicleEntity))
        return
    end

    if not Server.VehiclesPropertiesQueue[vehicleEntity] then
        Server.VehiclesPropertiesQueue[vehicleEntity] = { properties }

        Entity(vehicleEntity).state:set('vehicleProperties', properties, true)
    elseif Server.VehiclesPropertiesQueue[vehicleEntity] then
        table.insert(Server.VehiclesPropertiesQueue[vehicleEntity], properties)
    end
end

AddStateBagChangeHandler('initVehicle', '', function(bagName, _, value, _, _)
    if value ~= nil then return end

    local entity = GetEntityFromStateBagName(bagName)

    if not entity or entity == 0 then return end

    for i = -1, 0 do
        if DoesEntityExist(entity) then
            local ped = GetPedInVehicleSeat(entity, i)

            if not IsPedAPlayer(ped) then
                DeleteEntity(ped)
            end
        end
    end
end)

AddStateBagChangeHandler('vehicleProperties', '', function(bagName, key, value, _, _)
    if value ~= nil then return end

    local entity = GetEntityFromStateBagName(bagName)

    if not entity or entity == 0 or not Server.VehiclesPropertiesQueue[entity] then return end

    table.remove(Server.VehiclesPropertiesQueue[entity], 1)

    if next(Server.VehiclesPropertiesQueue[entity]) then
        Citizen.Wait(10)
        return Server.VehiclesPropertiesQueue[entity]?[1] and Entity(entity).state:set(key, Server.VehiclesPropertiesQueue[entity][1], true)
        --[[
        local bagName = ('entity:%d'):format(NetworkGetNetworkIdFromEntity(entity))
        local payload = msgpack_pack(Core.VehiclesPropertiesQueue[entity][1])

        return SetStateBagValue(bagName, key, payload, payload:len(), true)
        ]]
    end

    Server.VehiclesPropertiesQueue[entity] = nil
end)

ESX.RegisterServerCallback('esx:generatePlate', function(_, cb)
    cb(Server.GeneratePlate())
end)
