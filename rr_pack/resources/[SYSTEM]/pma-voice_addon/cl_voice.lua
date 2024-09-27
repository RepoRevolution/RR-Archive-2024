---@diagnostic disable: undefined-field
if not lib then return end
local classes = Config.VehiclesAlwaysHearable.classes
local models = Config.VehiclesAlwaysHearable.models
local outsideSeats = Config.VehiclesAlwaysHearable.outsideSeats

local function getPlayerSeat(vehicle, playerPed)
    local model = GetEntityModel(vehicle)
    local seats = GetVehicleModelNumberOfSeats(model)

    for i = -1, seats - 2 do
        if GetPedInVehicleSeat(vehicle, i) == playerPed then
            return i
        end
    end

    return nil
end

local function vehicleHearable(vehicle)
    local class = GetVehicleClass(vehicle)
    local model = GetEntityModel(vehicle)

    if lib.table.contains(classes, class) or lib.table.contains(models, model) then
        return true
    end

    local doors = GetNumberOfVehicleDoors(vehicle)
    for i = 0, doors - 1 do
        local angle = GetVehicleDoorAngleRatio(vehicle, i)
        if angle > 0.0 or IsVehicleDoorDamaged(vehicle, i) then
            return true
        end
    end

    ---@TODO: noRoofExtras 
    if not AreAllVehicleWindowsIntact(vehicle) or not AreAllVehicleWindowsClosed(vehicle) or not DoesVehicleHaveRoof(vehicle) or GetConvertibleRoofState(vehicle) ~= 0 then
        return true
    end

    return false
end

Citizen.CreateThread(function()
    exports['pma-voice']:overrideProximityCheck(function(targetPlayer)
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local proximity = LocalPlayer.state.proximity
        if not proximity or not proximity.distance then return false end
        local distance = GetConvar('voice_useNativeAudio', 'false') == 'true' and proximity.distance * 3 or proximity.distance
    
        -- Target data
        local targetPed = GetPlayerPed(targetPlayer)
        local targetPos = GetEntityCoords(targetPed)
    
        -- Distance
        if playerPed == targetPed or #(playerPos - targetPos) > distance then return false end

        if proximity.mode ~= 'Custom' then
            -- Check vehicles
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
            local targetVeh = GetVehiclePedIsIn(targetPed, false)

            if DoesEntityExist(playerVeh) then
                local model = GetEntityModel(playerVeh)
                local playerSeat = getPlayerSeat(playerVeh, playerPed)
                local outside = outsideSeats[model] and lib.table.contains(outsideSeats[model], playerSeat) or false
                
                if not DoesEntityExist(targetVeh) then
                    if not outside and not vehicleHearable(playerVeh) then
                        return false
                    end
                else
                    local targetModel = GetEntityModel(targetVeh)
                    local targetSeat = getPlayerSeat(targetVeh, targetPed)
                    local targetOutside = outsideSeats[targetModel] and lib.table.contains(outsideSeats[targetModel], targetSeat) or false

                    if playerVeh ~= targetVeh then
                        if (not outside and not vehicleHearable(playerVeh)) or (not targetOutside and not vehicleHearable(targetVeh)) then
                            return false
                        end
                    else
                        if (outside and not targetOutside) or (not outside and targetOutside) then
                            if not vehicleHearable(playerVeh) then
                                return false
                            end
                        end
                    end
                end
            else
                if DoesEntityExist(targetVeh) then
                    local targetModel = GetEntityModel(targetVeh)
                    local targetSeat = getPlayerSeat(targetVeh, targetPed)
                    local targetOutside = outsideSeats[targetModel] and lib.table.contains(outsideSeats[targetModel], targetSeat) or false

                    if not targetOutside and not vehicleHearable(targetVeh) then
                        return false
                    end
                end
            end

            -- Check interiors
            local playerInterior = GetInteriorFromEntity(playerPed)
            local targetInterior = GetInteriorFromEntity(targetPed)

            if playerInterior ~= 0 and targetInterior ~= 0 then
                if playerInterior == targetInterior then
                    local elevation = playerPos.z - targetPos.z
                    elevation = elevation < 0 and (elevation * -1) or elevation
                    if elevation > 3.95 then
                        return false
                    end
                end
            end
        end
    
        return true
    end)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        exports['pma-voice']:resetProximityCheck()
    end
end)