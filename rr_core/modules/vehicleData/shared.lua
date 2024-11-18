local function loadJson(file)
    local t = json.decode(LoadResourceFile(cache.resource, file) or '{}')

    if not t then
        error(('An unknown error occured while loading @%s/%s'):format(cache.resource, file), 2)
    end

    return t
end

---@type TopVehicleStats
local topStats = loadJson('files/topVehicleStats.json')

---@type table<string, VehicleData>
local vehicleData = loadJson('files/vehicles.json')

AddStateBagChangeHandler('esx:vehicleStats', 'global', function(_, _, value)
    topStats = value
end)

AddStateBagChangeHandler('esx:vehicleData', 'global', function(_, _, value)
    vehicleData = value
end)

if IsDuplicityVersion() then
    function Server.RefreshVehicleData()
        GlobalState:set('esx:vehicleStats', loadJson('files/topVehicleStats.json'), true)
        GlobalState:set('esx:vehicleData', loadJson('files/vehicles.json'), true)
    end

    do Server.RefreshVehicleData() end
end

local function filterData(model, data, filter)
    if filter.model and not model:find(filter.model) then return end
    if filter.bodytype and filter.bodytype ~= data.bodytype then return end
    if filter.class and filter.class ~= data.class then return end
    if filter.doors and filter.doors == data.doors then return end
    if filter.make and filter.make ~= data.make then return end
    if filter.seats and filter.seats ~= data.seats then return end
    if filter.type and filter.type ~= data.type then return end
    if filter.hash and filter.hash ~= data.hash then return end

    return true
end

---@param filter? 'land' | 'air' | 'sea'
---@return TopVehicleStats?
function ESX.GetTopVehicleStats(filter)
    if filter then
        return topStats[filter]
    end

    return topStats
end

---@param filter? string | string[] | table<string, string | number>
function ESX.GetVehicleData(filter)
    if filter then
        if type(filter) == 'table' then
            local rv = {}

            if table.type(filter) == 'array' then
                for i = 1, #filter do
                    local model = filter[i]
                    rv[model] = vehicleData[model]
                end
            else
                for model, data in pairs(vehicleData) do
                    if filterData(model, data, filter) then
                        rv[model] = data
                    end
                end
            end

            return rv
        end

        return vehicleData[filter]
    end

    return vehicleData
end
