Config = {}
Config.Debug = false
Config.Framework = 'ESX' -- ESX, QB, auto, custom

Config.Database = {
    vehicles_table = 'owned_vehicles',
    vehicles_table_owner_column = 'owner',
    vehicles_table_plate_column = 'plate',
    vehicles_table_model_column = 'vehicle',
    permanent_keys_table = 'vehicles_perm_keys'
}

Config.Locks = {
    always_unlocked = {
        classes = { 8, 13, 14, 21 },
        models = {}
    },
    whitelisted = {
        { model = `dilettante` }
        -- { model = `dilettante`, job = 'unemployed' }
        -- { model = `dilettante`, job = { 'unemployed', 'police' } }
    },
    sound_enabled = true,
    default_lock_npc_vehicles = true,
    chance_moving_vehicle_unlocked = 0,
    chance_parked_vehicle_unlocked = 0
}

Config.Lockpick = {
    enabled = true,
    command = false, -- 'vehicle_lockpick', -- Command name or false to disable
    item = 'lockpick', -- Item name or false to disable
    excluded_zones = {
        {
            points = {
                vec3(-513.085693, 6001.753906, 33.0),
                vec3(-447.059326, 6066.210938, 33.0),
                vec3(-427.793396, 6025.463867, 33.0),
                vec3(-419.076935, 5997.257324, 33.0),
                vec3(-465.441772, 5953.002441, 33.0)
            },
            height = 15.0
        }
    },
    call_police = true,
    alert_vehicle_owner = true
}

Config.Hotwire = {
    enabled = true,
    command = 'vehicle_hotwire', -- Command name or false to disable
    command_keyboard_bind = 'H', -- Command must be set
    item = false, -- 'pliers', -- Item name or false to disable
    call_police = true,
    alert_vehicle_owner = true
}

Config.Carjacking = {
    enabled = true,
    distance_from_vehicle = 20.0,
    max_speed_of_vehicle = 35.0, -- MPH
    lock_stealed_vehicle = false,
    shut_engine_off = true,
    weapon_chances = {
        ['default'] = 0.0, -- any other weapons
        [3566412244] = 0.1, -- meele
        [690389602] = 0.2, -- stun gun
        [416676503] = 0.4, -- pistols
        [3337201093] = 0.5, -- SMG
        [970310034] = 0.6, -- rifles
        [860033945] = 0.7, -- shotguns
        [1159398588] = 0.8, -- MG
        [3082541095] = 0.9, -- snipers
        [2725924767] = 1.0, -- heavy
        [1548507267] = 0.2, -- throwables
    },
    call_police = true,
    chance_to_get_keys = 0.75,
    chance_to_fight_with_ped = 0.5,
    ped_weapons = {
        `WEAPON_PISTOL`,
        `WEAPON_COMBATPISTOL`,
        `WEAPON_MICROSMG`
    },
    ped_accuracy = 95.0
}

Config.Engine = {
    enabled = true,
    command = 'vehicle_engine', -- Command name or false to disable
    command_keyboard_bind = 'Y', -- Command must be set
    disable_auto_start = true,
    can_turn_off_when_hotwired = true,
    turn_off_while_exit = false,
    hold_exit_key_to_stay_on = false
}