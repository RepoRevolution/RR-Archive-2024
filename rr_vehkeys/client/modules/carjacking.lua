if not Client then return end

---@param entity number
---@return boolean
local function isValidPed(entity)
	local pedType = GetPedType(entity)
	if (pedType == 6 or pedType == 27 or pedType == 29 or pedType == 28)
	or not DoesEntityExist(entity) or not IsEntityAPed(entity)
	or IsPedAPlayer(entity) or IsEntityDead(entity)
    or IsPedDeadOrDying(entity, true) or not IsPedInAnyVehicle(entity, false) then 
        return false
    end
	return true
end

---@param weaponGroup number
---@return boolean
local function calculateWeaponChances(weaponGroup)
    math.randomseed(GetGameTimer())
    local chance = math.random(0, 100) / 100
    if Config.Carjacking.weapon_chances[weaponGroup] then
        return chance <= Config.Carjacking.weapon_chances[weaponGroup]
    else
        return chance <= Config.Carjacking.weapon_chances.default
    end
end

---@param vehicle number
---@return number
local function carjackingSequence(vehicle)
	local task = OpenSequenceTask()
	TaskSetBlockingOfNonTemporaryEvents(0, true)
	TaskLeaveVehicle(0, vehicle, 256)
	SetPedDropsWeaponsWhenDead(0, false)
	SetPedFleeAttributes(0, 0, false)
	SetPedCombatAttributes(0, 17, true)
	SetPedHearingRange(0, 3.0)
	SetPedSeeingRange(0, 0.0)
	SetPedAlertness(0, 0)
	SetPedKeepTask(0, true)
	TaskHandsUp(0, -1, cache.ped, -1, false)
	CloseSequenceTask(task)
	return task
end

if Config.Carjacking.enabled then
    Citizen.CreateThread(function()
        while true do
            local sleep = 500
            if not cache.vehicle then
                local aiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
                if aiming and IsPedArmed(cache.ped, 6) then
                    local vehicle = GetVehiclePedIsIn(entity, false)
                    if isValidPed(entity) and vehicle ~= 0 and #(cache.coords - GetEntityCoords(vehicle)) < Config.Carjacking.distance_from_vehicle and GetPedInVehicleSeat(vehicle, -1) == entity then
                        local speed = GetEntitySpeed(vehicle) * 2.236936
                        if speed < Config.Carjacking.max_speed_of_vehicle then
                            SERVER_LOG(2, '[^1CARJACKING^7]', ('Player ^5%s ^7attempted to carjack a vehicle ^5%s^7'):format(GetPlayerServerId(PlayerId()), vehicle))
                            Citizen.Wait(200)
                            local weapon = GetSelectedPedWeapon(cache.ped)
                            local weaponGroup = GetWeapontypeGroup(weapon)
                            if calculateWeaponChances(weaponGroup) then
                                sleep = 3000
                                local sequence = carjackingSequence(vehicle)
                                TaskPerformSequence(entity, sequence)
                                SetVehicleLock(vehicle, Config.Carjacking.lock_stealed_vehicle)
                                SetVehicleEngine(vehicle, not Config.Carjacking.shut_engine_off)
                                SetNeedHotwire(vehicle, Config.Carjacking.shut_engine_off)
                                local handsUp = 5000
                                while handsUp > 0 do
                                    Citizen.Wait(1000)
                                    handsUp = handsUp - 1000
                                    if not GetEntityPlayerIsFreeAimingAt(PlayerId()) and handsUp > 0 then break
                                    elseif handsUp <= 0 then
                                        math.randomseed(GetGameTimer())
                                        if (math.random(0, 100) / 100) <= Config.Carjacking.chance_to_get_keys then
                                            SetVehicleLock(vehicle, false)
                                            SetNeedHotwire(vehicle, false)
                                            GiveKeys(vehicle, 0, true)
                                        else Client.Custom.notify('error', nil, locale('carjacking_no_keys'):format(Client.getVehicleName(vehicle))) end
                                        break
                                    end
                                end
                                if Config.Carjacking.call_police then
                                    Client.Custom.callPolice('carjacking', GetEntityCoords(vehicle), vehicle)
                                end
                                ClearSequenceTask(sequence)
                                ClearPedTasks(entity)
                                TaskSetBlockingOfNonTemporaryEvents(entity, false)
                                TaskSmartFleePed(entity, cache.ped, 40.0, 20000, true, true)
                                aiming = false
                                SERVER_LOG(2, '[^1CARJACKING^7]', ('Player ^5%s ^7successfully carjacked a vehicle ^5%s^7'):format(GetPlayerServerId(PlayerId()), vehicle))
                            else
                                sleep = 3000
                                math.randomseed(GetGameTimer())
                                if (math.random(0, 100) / 100) <= Config.Carjacking.chance_to_fight_with_ped then
                                    SERVER_LOG(2, '[^1CARJACKING^7]', ('Player ^5%s ^7failed to carjack a vehicle ^5%s^7 and fight with the owner'):format(GetPlayerServerId(PlayerId()), vehicle))
                                    ClearPedTasks(entity)
                                    local pedWeapon = Config.Carjacking.ped_weapons[math.random(1, #Config.Carjacking.ped_weapons)]
                                    SetPedDropsWeaponsWhenDead(entity, false)
                                    GiveWeaponToPed(entity, pedWeapon, 100, false, true)
                                    SetPedInfiniteAmmo(entity, true, pedWeapon)
                                    TaskCombatPed(entity, cache.ped, 0, 16)
                                    SetPedAccuracy(entity, Config.Carjacking.ped_accuracy)
                                    Citizen.Wait(5000)
                                else
                                    SERVER_LOG(2, '[^1CARJACKING^7]', ('Player ^5%s ^7failed to carjack a vehicle ^5%s^7'):format(GetPlayerServerId(PlayerId()), vehicle))
                                end
                                aiming = false
                            end
                        end
                    end
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end