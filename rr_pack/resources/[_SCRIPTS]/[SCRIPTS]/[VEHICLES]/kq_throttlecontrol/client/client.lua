local control = true
local maxRpm = Config.MaxRpm

CreateThread(function()
    while true do
        local sleep = 500

        local playerPed = PlayerPedId()
        local inVehicle = IsPedInAnyVehicle(playerPed, false) and not IsPedInFlyingVehicle(playerPed)
        if inVehicle then
            sleep = 150

            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if control and math.abs(GetVehicleThrottleOffset(vehicle)) > 0.2 and GetEntitySpeed(vehicle) * 2.236936 <= Config.MaxSpeed then
                sleep = 80

                local rpm = GetVehicleCurrentRpm(vehicle)
                if rpm > maxRpm then
                    SetVehicleCurrentRpm(vehicle, maxRpm)
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)

RegisterCommand('+throttlecontrol', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) and not IsPedInFlyingVehicle(playerPed) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if GetPedInVehicleSeat(vehicle, -1) == playerPed then
            control = false
        end
    end
end, false)

RegisterCommand('-throttlecontrol', function()
    control = true
end, false)

RegisterKeyMapping('+throttlecontrol', '[VEH] Sterowanie przepustnicą', 'keyboard', Config.keybinds.slow.input)