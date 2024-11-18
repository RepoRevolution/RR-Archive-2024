Config = {}
Config.Debug = true

Config.UI = {
    textUI = {
        position = 'left-center'
    },
    progress = {
        type = 'bar',
        position = 'bottom'
    },
    notification = {
        position = 'top-right'
    }
}

Config.AdminGroups = {
    'owner', 'admin'
}

-- Pattern string format
-- 1 will lead to a random number from 0-9.
-- A will lead to a random letter from A-Z.
-- . will lead to a random letter or number, with 50% probability of being either.
-- ^1 will lead to a literal 1 being emitted.
-- ^A will lead to a literal A being emitted.
-- Any other character will lead to said character being emitted.
Config.Patterns = {
    plate = '........'
}

Config.FiveM = {
    map = 'San Andreas',
    gameType = 'RP'
}

Config.Player = {
    max_weight = 30,
    starting_accounts = {
        bank = 10000,
        money = 1000
    },
    identity = false,
    enable_pvp = true,
    enable_default_inventory = true,
    disable_health_regen = true,
    disable_vehicle_shuff = true,
    disable_dispatch_services = true,
    disable_scenarios = true,
    disable_wanted_level = true,
    disable_npc_drops = true,
    disable_vehicle_rewards = true,
    disable_weapon_wheel = false,
    disable_aim_assist = true,
    disable_display_ammo = true,
    remove_hud_components = {
        [1] = true, --WANTED_STARS,
        [2] = false, --WEAPON_ICON
        [3] = true, --CASH
        [4] = true, --MP_CASH
        [5] = true, --MP_MESSAGE
        [6] = false, --VEHICLE_NAME
        [7] = true, -- AREA_NAME
        [8] = false, -- VEHICLE_CLASS
        [9] = true, --STREET_NAME
        [10] = false, --HELP_TEXT
        [11] = false, --FLOATING_HELP_TEXT_1
        [12] = false, --FLOATING_HELP_TEXT_2
        [13] = true, --CASH_CHANGE
        [14] = false, --RETICLE
        [15] = false, --SUBTITLE_TEXT
        [16] = false, --RADIO_STATIONS
        [17] = false, --SAVING_GAME,
        [18] = false, --GAME_STREAM
        [19] = false, --WEAPON_WHEEL
        [20] = false, --WEAPON_WHEEL_STATS
        [21] = false, --HUD_COMPONENTS
        [22] = false, --HUD_WEAPONS
    }
}