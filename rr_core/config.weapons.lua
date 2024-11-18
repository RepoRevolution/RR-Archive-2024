Config.DefaultWeaponTints = {
    [0] = locale("tint_default"),
    [1] = locale("tint_green"),
    [2] = locale("tint_gold"),
    [3] = locale("tint_pink"),
    [4] = locale("tint_army"),
    [5] = locale("tint_lspd"),
    [6] = locale("tint_orange"),
    [7] = locale("tint_platinum")
}

Config.Weapons = {
    -- Melee
    { name = "WEAPON_DAGGER",    label = locale("weapon_dagger"),    components = {} },
    { name = "WEAPON_BAT",       label = locale("weapon_bat"),       components = {} },
    { name = "WEAPON_BATTLEAXE", label = locale("weapon_battleaxe"), components = {} },
    {
        name = "WEAPON_KNUCKLE",
        label = locale("weapon_knuckle"),
        components = {
            { name = "knuckle_base",    label = locale("component_knuckle_base"),    hash = `COMPONENT_KNUCKLE_VARMOD_BASE` },
            { name = "knuckle_pimp",    label = locale("component_knuckle_pimp"),    hash = `COMPONENT_KNUCKLE_VARMOD_PIMP` },
            { name = "knuckle_ballas",  label = locale("component_knuckle_ballas"),  hash = `COMPONENT_KNUCKLE_VARMOD_BALLAS` },
            { name = "knuckle_dollar",  label = locale("component_knuckle_dollar"),  hash = `COMPONENT_KNUCKLE_VARMOD_DOLLAR` },
            { name = "knuckle_diamond", label = locale("component_knuckle_diamond"), hash = `COMPONENT_KNUCKLE_VARMOD_DIAMOND` },
            { name = "knuckle_hate",    label = locale("component_knuckle_hate"),    hash = `COMPONENT_KNUCKLE_VARMOD_HATE` },
            { name = "knuckle_love",    label = locale("component_knuckle_love"),    hash = `COMPONENT_KNUCKLE_VARMOD_LOVE` },
            { name = "knuckle_player",  label = locale("component_knuckle_player"),  hash = `COMPONENT_KNUCKLE_VARMOD_PLAYER` },
            { name = "knuckle_king",    label = locale("component_knuckle_king"),    hash = `COMPONENT_KNUCKLE_VARMOD_KING` },
            { name = "knuckle_vagos",   label = locale("component_knuckle_vagos"),   hash = `COMPONENT_KNUCKLE_VARMOD_VAGOS` }
        }
    },
    { name = "WEAPON_BOTTLE",        label = locale("weapon_bottle"),        components = {} },
    { name = "WEAPON_CROWBAR",       label = locale("weapon_crowbar"),       components = {} },
    { name = "WEAPON_FLASHLIGHT",    label = locale("weapon_flashlight"),    components = {} },
    { name = "WEAPON_GOLFCLUB",      label = locale("weapon_golfclub"),      components = {} },
    { name = "WEAPON_HAMMER",        label = locale("weapon_hammer"),        components = {} },
    { name = "WEAPON_HATCHET",       label = locale("weapon_hatchet"),       components = {} },
    { name = "WEAPON_KNIFE",         label = locale("weapon_knife"),         components = {} },
    { name = "WEAPON_MACHETE",       label = locale("weapon_machete"),       components = {} },
    { name = "WEAPON_NIGHTSTICK",    label = locale("weapon_nightstick"),    components = {} },
    { name = "WEAPON_WRENCH",        label = locale("weapon_wrench"),        components = {} },
    { name = "WEAPON_POOLCUE",       label = locale("weapon_poolcue"),       components = {} },
    { name = "WEAPON_STONE_HATCHET", label = locale("weapon_stone_hatchet"), components = {} },
    {
        name = "WEAPON_SWITCHBLADE",
        label = locale("weapon_switchblade"),
        components = {
            { name = "handle_default",   label = locale("component_handle_default"),   hash = `COMPONENT_SWITCHBLADE_VARMOD_BASE` },
            { name = "handle_vip",       label = locale("component_handle_vip"),       hash = `COMPONENT_SWITCHBLADE_VARMOD_VAR1` },
            { name = "handle_bodyguard", label = locale("component_handle_bodyguard"), hash = `COMPONENT_SWITCHBLADE_VARMOD_VAR2` }
        }
    },
    -- Handguns
    {
        name = "WEAPON_APPISTOL",
        label = locale("weapon_appistol"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_PISTOL` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_APPISTOL_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_APPISTOL_CLIP_02` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_PI_FLSH` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_PI_SUPP` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_APPISTOL_VARMOD_LUXE` }
        }
    },
    {
        name = "WEAPON_CERAMICPISTOL",
        label = locale("weapon_ceramicpistol"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_rounds"), hash = `AMMO_PISTOL` }
    },
    {
        name = "WEAPON_COMBATPISTOL",
        label = locale("weapon_combatpistol"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_PISTOL` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_COMBATPISTOL_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_COMBATPISTOL_CLIP_02` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_PI_FLSH` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_PI_SUPP` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER` }
        }
    },
    {
        name = "WEAPON_DOUBLEACTION",
        label = locale("weapon_doubleaction"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_rounds"), hash = `AMMO_PISTOL` }
    },
    {
        name = "WEAPON_NAVYREVOLVER",
        label = locale("weapon_navyrevolver"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_rounds"), hash = `AMMO_PISTOL` }
    },
    {
        name = "WEAPON_FLAREGUN",
        label = locale("weapon_flaregun"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_flaregun"), hash = `AMMO_FLAREGUN` }
    },
    {
        name = "WEAPON_GADGETPISTOL",
        label = locale("weapon_gadgetpistol"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_rounds"), hash = `AMMO_PISTOL` }
    },
    {
        name = "WEAPON_HEAVYPISTOL",
        label = locale("weapon_heavypistol"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_PISTOL` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_HEAVYPISTOL_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_HEAVYPISTOL_CLIP_02` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_PI_FLSH` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_PI_SUPP` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_HEAVYPISTOL_VARMOD_LUXE` }
        }
    },
    {
        name = "WEAPON_REVOLVER",
        label = locale("weapon_revolver"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_PISTOL` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",     label = locale("component_clip_default"),     hash = `COMPONENT_REVOLVER_CLIP_01` },
            { name = "vip_finish",       label = locale("component_vip_finish"),       hash = `COMPONENT_REVOLVER_VARMOD_BOSS` },
            { name = "bodyguard_finish", label = locale("component_bodyguard_finish"), hash = `COMPONENT_REVOLVER_VARMOD_GOON` }
        }
    },
    {
        name = "WEAPON_REVOLVER_MK2",
        label = locale("weapon_revolver_mk2"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_PISTOL` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",     label = locale("component_clip_default"),     hash = `COMPONENT_REVOLVER_MK2_CLIP_01` },
            { name = "ammo_tracer",      label = locale("component_ammo_tracer"),      hash = `COMPONENT_REVOLVER_MK2_CLIP_TRACER` },
            { name = "ammo_incendiary",  label = locale("component_ammo_incendiary"),  hash = `COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY` },
            { name = "ammo_hollowpoint", label = locale("component_ammo_hollowpoint"), hash = `COMPONENT_REVOLVER_MK2_CLIP_HOLLOWPOINT` },
            { name = "ammo_fmj",         label = locale("component_ammo_fmj"),         hash = `COMPONENT_REVOLVER_MK2_CLIP_FMJ` },
            { name = "scope_holo",       label = locale("component_scope_holo"),       hash = `COMPONENT_AT_SIGHTS` },
            { name = "scope_small",      label = locale("component_ammo_fmj"),         hash = `COMPONENT_AT_SCOPE_MACRO_MK2` },
            { name = "flashlight",       label = locale("component_flashlight"),       hash = `COMPONENT_AT_PI_FLSH` },
            { name = "compensator",      label = locale("component_compensator"),      hash = `COMPONENT_AT_PI_COMP_03` },
            { name = "camo_finish",      label = locale("component_camo_finish"),      hash = `COMPONENT_REVOLVER_MK2_CAMO` },
            { name = "camo_finish2",     label = locale("component_camo_finish2"),     hash = `COMPONENT_REVOLVER_MK2_CAMO_02` },
            { name = "camo_finish3",     label = locale("component_camo_finish3"),     hash = `COMPONENT_REVOLVER_MK2_CAMO_03` },
            { name = "camo_finish4",     label = locale("component_camo_finish4"),     hash = `COMPONENT_REVOLVER_MK2_CAMO_04` },
            { name = "camo_finish5",     label = locale("component_camo_finish5"),     hash = `COMPONENT_REVOLVER_MK2_CAMO_05` },
            { name = "camo_finish6",     label = locale("component_camo_finish6"),     hash = `COMPONENT_REVOLVER_MK2_CAMO_06` },
            { name = "camo_finish7",     label = locale("component_camo_finish7"),     hash = `COMPONENT_REVOLVER_MK2_CAMO_07` },
            { name = "camo_finish8",     label = locale("component_camo_finish8"),     hash = `COMPONENT_REVOLVER_MK2_CAMO_08` },
            { name = "camo_finish9",     label = locale("component_camo_finish9"),     hash = `COMPONENT_REVOLVER_MK2_CAMO_09` },
            { name = "camo_finish10",    label = locale("component_camo_finish10"),    hash = `COMPONENT_REVOLVER_MK2_CAMO_10` },
            { name = "camo_finish11",    label = locale("component_camo_finish11"),    hash = `COMPONENT_REVOLVER_MK2_CAMO_IND_01` }
        }
    },
    {
        name = "WEAPON_MARKSMANPISTOL",
        label = locale("weapon_marksmanpistol"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_rounds"), hash = `AMMO_PISTOL` }
    },
    {
        name = "WEAPON_PISTOL",
        label = locale("weapon_pistol"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_PISTOL` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_PISTOL_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_PISTOL_CLIP_02` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_PI_FLSH` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_PI_SUPP_02` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_PISTOL_VARMOD_LUXE` }
        }
    },
    {
        name = "WEAPON_PISTOL_MK2",
        label = locale("weapon_pistol_mk2"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_PISTOL` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",        label = locale("component_clip_default"),        hash = `COMPONENT_PISTOL_MK2_CLIP_01` },
            { name = "clip_extended",       label = locale("component_clip_extended"),       hash = `COMPONENT_PISTOL_MK2_CLIP_02` },
            { name = "ammo_tracer",         label = locale("component_ammo_tracer"),         hash = `COMPONENT_PISTOL_MK2_CLIP_TRACER` },
            { name = "ammo_incendiary",     label = locale("component_ammo_incendiary"),     hash = `COMPONENT_PISTOL_MK2_CLIP_INCENDIARY` },
            { name = "ammo_hollowpoint",    label = locale("component_ammo_hollowpoint"),    hash = `COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT` },
            { name = "ammo_fmj",            label = locale("component_ammo_fmj"),            hash = `COMPONENT_PISTOL_MK2_CLIP_FMJ` },
            { name = "scope",               label = locale("component_scope"),               hash = `COMPONENT_AT_PI_RAIL` },
            { name = "flashlight",          label = locale("component_flashlight"),          hash = `COMPONENT_AT_PI_FLSH_02` },
            { name = "suppressor",          label = locale("component_suppressor"),          hash = `COMPONENT_AT_PI_SUPP_02` },
            { name = "compensator",         label = locale("component_suppressor"),          hash = `COMPONENT_AT_PI_COMP` },
            { name = "camo_finish",         label = locale("component_camo_finish"),         hash = `COMPONENT_PISTOL_MK2_CAMO` },
            { name = "camo_finish2",        label = locale("component_camo_finish2"),        hash = `COMPONENT_PISTOL_MK2_CAMO_02` },
            { name = "camo_finish3",        label = locale("component_camo_finish3"),        hash = `COMPONENT_PISTOL_MK2_CAMO_03` },
            { name = "camo_finish4",        label = locale("component_camo_finish4"),        hash = `COMPONENT_PISTOL_MK2_CAMO_04` },
            { name = "camo_finish5",        label = locale("component_camo_finish5"),        hash = `COMPONENT_PISTOL_MK2_CAMO_05` },
            { name = "camo_finish6",        label = locale("component_camo_finish6"),        hash = `COMPONENT_PISTOL_MK2_CAMO_06` },
            { name = "camo_finish7",        label = locale("component_camo_finish7"),        hash = `COMPONENT_PISTOL_MK2_CAMO_07` },
            { name = "camo_finish8",        label = locale("component_camo_finish8"),        hash = `COMPONENT_PISTOL_MK2_CAMO_08` },
            { name = "camo_finish9",        label = locale("component_camo_finish9"),        hash = `COMPONENT_PISTOL_MK2_CAMO_09` },
            { name = "camo_finish10",       label = locale("component_camo_finish10"),       hash = `COMPONENT_PISTOL_MK2_CAMO_10` },
            { name = "camo_finish11",       label = locale("component_camo_finish11"),       hash = `COMPONENT_PISTOL_MK2_CAMO_IND_01` },
            { name = "camo_slide_finish",   label = locale("component_camo_slide_finish"),   hash = `COMPONENT_PISTOL_MK2_CAMO_SLIDE` },
            { name = "camo_slide_finish2",  label = locale("component_camo_slide_finish2"),  hash = `COMPONENT_PISTOL_MK2_CAMO_02_SLIDE` },
            { name = "camo_slide_finish3",  label = locale("component_camo_slide_finish3"),  hash = `COMPONENT_PISTOL_MK2_CAMO_03_SLIDE` },
            { name = "camo_slide_finish4",  label = locale("component_camo_slide_finish4"),  hash = `COMPONENT_PISTOL_MK2_CAMO_04_SLIDE` },
            { name = "camo_slide_finish5",  label = locale("component_camo_slide_finish5"),  hash = `COMPONENT_PISTOL_MK2_CAMO_05_SLIDE` },
            { name = "camo_slide_finish6",  label = locale("component_camo_slide_finish6"),  hash = `COMPONENT_PISTOL_MK2_CAMO_06_SLIDE` },
            { name = "camo_slide_finish7",  label = locale("component_camo_slide_finish7"),  hash = `COMPONENT_PISTOL_MK2_CAMO_07_SLIDE` },
            { name = "camo_slide_finish8",  label = locale("component_camo_slide_finish8"),  hash = `COMPONENT_PISTOL_MK2_CAMO_08_SLIDE` },
            { name = "camo_slide_finish9",  label = locale("component_camo_slide_finish9"),  hash = `COMPONENT_PISTOL_MK2_CAMO_09_SLIDE` },
            { name = "camo_slide_finish10", label = locale("component_camo_slide_finish10"), hash = `COMPONENT_PISTOL_MK2_CAMO_10_SLIDE` },
            { name = "camo_slide_finish11", label = locale("component_camo_slide_finish11"), hash = `COMPONENT_PISTOL_MK2_CAMO_IND_01_SLIDE` }
        }
    },
    {
        name = "WEAPON_PISTOL50",
        label = locale("weapon_pistol50"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_PISTOL` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_PISTOL50_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_PISTOL50_CLIP_02` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_PI_FLSH` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_AR_SUPP_02` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_PISTOL50_VARMOD_LUXE` }
        }
    },
    {
        name = "WEAPON_SNSPISTOL",
        label = locale("weapon_snspistol"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_PISTOL` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_SNSPISTOL_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_SNSPISTOL_CLIP_02` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_SNSPISTOL_VARMOD_LOWRIDER` }
        }
    },
    {
        name = "WEAPON_SNSPISTOL_MK2",
        label = locale("weapon_snspistol_mk2"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_PISTOL` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",        label = locale("component_clip_default"),        hash = `COMPONENT_SNSPISTOL_MK2_CLIP_01` },
            { name = "clip_extended",       label = locale("component_clip_extended"),       hash = `COMPONENT_SNSPISTOL_MK2_CLIP_02` },
            { name = "ammo_tracer",         label = locale("component_ammo_tracer"),         hash = `COMPONENT_SNSPISTOL_MK2_CLIP_TRACER` },
            { name = "ammo_incendiary",     label = locale("component_ammo_incendiary"),     hash = `COMPONENT_SNSPISTOL_MK2_CLIP_INCENDIARY` },
            { name = "ammo_hollowpoint",    label = locale("component_ammo_hollowpoint"),    hash = `COMPONENT_SNSPISTOL_MK2_CLIP_HOLLOWPOINT` },
            { name = "ammo_fmj",            label = locale("component_ammo_fmj"),            hash = `COMPONENT_SNSPISTOL_MK2_CLIP_FMJ` },
            { name = "scope",               label = locale("component_scope"),               hash = `COMPONENT_AT_PI_RAIL_02` },
            { name = "flashlight",          label = locale("component_flashlight"),          hash = `COMPONENT_AT_PI_FLSH_03` },
            { name = "suppressor",          label = locale("component_suppressor"),          hash = `COMPONENT_AT_PI_SUPP_02` },
            { name = "compensator",         label = locale("component_suppressor"),          hash = `COMPONENT_AT_PI_COMP_02` },
            { name = "camo_finish",         label = locale("component_camo_finish"),         hash = `COMPONENT_SNSPISTOL_MK2_CAMO` },
            { name = "camo_finish2",        label = locale("component_camo_finish2"),        hash = `COMPONENT_SNSPISTOL_MK2_CAMO_02` },
            { name = "camo_finish3",        label = locale("component_camo_finish3"),        hash = `COMPONENT_SNSPISTOL_MK2_CAMO_03` },
            { name = "camo_finish4",        label = locale("component_camo_finish4"),        hash = `COMPONENT_SNSPISTOL_MK2_CAMO_04` },
            { name = "camo_finish5",        label = locale("component_camo_finish5"),        hash = `COMPONENT_SNSPISTOL_MK2_CAMO_05` },
            { name = "camo_finish6",        label = locale("component_camo_finish6"),        hash = `COMPONENT_SNSPISTOL_MK2_CAMO_06` },
            { name = "camo_finish7",        label = locale("component_camo_finish7"),        hash = `COMPONENT_SNSPISTOL_MK2_CAMO_07` },
            { name = "camo_finish8",        label = locale("component_camo_finish8"),        hash = `COMPONENT_SNSPISTOL_MK2_CAMO_08` },
            { name = "camo_finish9",        label = locale("component_camo_finish9"),        hash = `COMPONENT_SNSPISTOL_MK2_CAMO_09` },
            { name = "camo_finish10",       label = locale("component_camo_finish10"),       hash = `COMPONENT_SNSPISTOL_MK2_CAMO_10` },
            { name = "camo_finish11",       label = locale("component_camo_finish11"),       hash = `COMPONENT_SNSPISTOL_MK2_CAMO_IND_01` },
            { name = "camo_slide_finish",   label = locale("component_camo_slide_finish"),   hash = `COMPONENT_SNSPISTOL_MK2_CAMO_SLIDE` },
            { name = "camo_slide_finish2",  label = locale("component_camo_slide_finish2"),  hash = `COMPONENT_SNSPISTOL_MK2_CAMO_02_SLIDE` },
            { name = "camo_slide_finish3",  label = locale("component_camo_slide_finish3"),  hash = `COMPONENT_SNSPISTOL_MK2_CAMO_03_SLIDE` },
            { name = "camo_slide_finish4",  label = locale("component_camo_slide_finish4"),  hash = `COMPONENT_SNSPISTOL_MK2_CAMO_04_SLIDE` },
            { name = "camo_slide_finish5",  label = locale("component_camo_slide_finish5"),  hash = `COMPONENT_SNSPISTOL_MK2_CAMO_05_SLIDE` },
            { name = "camo_slide_finish6",  label = locale("component_camo_slide_finish6"),  hash = `COMPONENT_SNSPISTOL_MK2_CAMO_06_SLIDE` },
            { name = "camo_slide_finish7",  label = locale("component_camo_slide_finish7"),  hash = `COMPONENT_SNSPISTOL_MK2_CAMO_07_SLIDE` },
            { name = "camo_slide_finish8",  label = locale("component_camo_slide_finish8"),  hash = `COMPONENT_SNSPISTOL_MK2_CAMO_08_SLIDE` },
            { name = "camo_slide_finish9",  label = locale("component_camo_slide_finish9"),  hash = `COMPONENT_SNSPISTOL_MK2_CAMO_09_SLIDE` },
            { name = "camo_slide_finish10", label = locale("component_camo_slide_finish10"), hash = `COMPONENT_SNSPISTOL_MK2_CAMO_10_SLIDE` },
            { name = "camo_slide_finish11", label = locale("component_camo_slide_finish11"), hash = `COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE` }
        }
    },
    { name = "WEAPON_STUNGUN",   label = locale("weapon_stungun"),   tints = Config.DefaultWeaponTints, components = {} },
    { name = "WEAPON_RAYPISTOL", label = locale("weapon_raypistol"), tints = Config.DefaultWeaponTints, components = {} },
    {
        name = "WEAPON_VINTAGEPISTOL",
        label = locale("weapon_vintagepistol"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_PISTOL` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_VINTAGEPISTOL_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_VINTAGEPISTOL_CLIP_02` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_PI_SUPP` }
        }
    },
    -- Shotguns
    {
        name = "WEAPON_ASSAULTSHOTGUN",
        label = locale("weapon_assaultshotgun"),
        ammo = { label = locale("ammo_shells"), hash = `AMMO_SHOTGUN` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_ASSAULTSHOTGUN_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_ASSAULTSHOTGUN_CLIP_02` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_AR_FLSH` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_AR_SUPP` },
            { name = "grip",          label = locale("component_grip"),          hash = `COMPONENT_AT_AR_AFGRIP` }
        }
    },
    {
        name = "WEAPON_AUTOSHOTGUN",
        label = locale("weapon_autoshotgun"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_shells"), hash = `AMMO_SHOTGUN` }
    },
    {
        name = "WEAPON_BULLPUPSHOTGUN",
        label = locale("weapon_bullpupshotgun"),
        ammo = { label = locale("ammo_shells"), hash = `AMMO_SHOTGUN` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "flashlight", label = locale("component_flashlight"), hash = `COMPONENT_AT_AR_FLSH` },
            { name = "suppressor", label = locale("component_suppressor"), hash = `COMPONENT_AT_AR_SUPP_02` },
            { name = "grip",       label = locale("component_grip"),       hash = `COMPONENT_AT_AR_AFGRIP` }
        }
    },
    {
        name = "WEAPON_COMBATSHOTGUN",
        label = locale("weapon_combatshotgun"),
        ammo = { label = locale("ammo_shells"), hash = `AMMO_SHOTGUN` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "flashlight", label = locale("component_flashlight"), hash = `COMPONENT_AT_AR_FLSH` },
            { name = "suppressor", label = locale("component_suppressor"), hash = `COMPONENT_AT_AR_SUPP` }
        }
    },
    {
        name = "WEAPON_DBSHOTGUN",
        label = locale("weapon_dbshotgun"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_shells"), hash = `AMMO_SHOTGUN` }
    },
    {
        name = "WEAPON_HEAVYSHOTGUN",
        label = locale("weapon_heavyshotgun"),
        ammo = { label = locale("ammo_shells"), hash = `AMMO_SHOTGUN` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_HEAVYSHOTGUN_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_HEAVYSHOTGUN_CLIP_02` },
            { name = "clip_drum",     label = locale("component_clip_drum"),     hash = `COMPONENT_HEAVYSHOTGUN_CLIP_03` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_AR_FLSH` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_AR_SUPP_02` },
            { name = "grip",          label = locale("component_grip"),          hash = `COMPONENT_AT_AR_AFGRIP` }
        }
    },
    {
        name = "WEAPON_MUSKET",
        label = locale("weapon_musket"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_rounds"), hash = `AMMO_SHOTGUN` }
    },
    {
        name = "WEAPON_PUMPSHOTGUN",
        label = locale("weapon_pumpshotgun"),
        ammo = { label = locale("ammo_shells"), hash = `AMMO_SHOTGUN` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_AR_FLSH` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_SR_SUPP` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER` }
        }
    },
    {
        name = "WEAPON_PUMPSHOTGUN_MK2",
        label = locale("weapon_pumpshotgun_mk2"),
        ammo = { label = locale("ammo_shells"), hash = `AMMO_SHOTGUN` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "shells_default",     label = locale("component_shells_default"),     hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_01` },
            { name = "shells_incendiary",  label = locale("component_shells_incendiary"),  hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY` },
            { name = "shells_armor",       label = locale("component_shells_armor"),       hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_ARMORPIERCING` },
            { name = "shells_hollowpoint", label = locale("component_shells_hollowpoint"), hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT` },
            { name = "shells_explosive",   label = locale("component_shells_explosive"),   hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE` },
            { name = "scope_holo",         label = locale("component_scope_holo"),         hash = `COMPONENT_AT_SIGHTS` },
            { name = "scope_small",        label = locale("component_scope_small"),        hash = `COMPONENT_AT_SCOPE_MACRO_MK2` },
            { name = "scope_medium",       label = locale("component_scope_medium"),       hash = `COMPONENT_AT_SCOPE_SMALL_MK2` },
            { name = "flashlight",         label = locale("component_flashlight"),         hash = `COMPONENT_AT_AR_FLSH` },
            { name = "suppressor",         label = locale("component_suppressor"),         hash = `COMPONENT_AT_SR_SUPP_03` },
            { name = "muzzle_squared",     label = locale("component_muzzle_squared"),     hash = `COMPONENT_AT_MUZZLE_08` },
            { name = "camo_finish",        label = locale("component_camo_finish"),        hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO` },
            { name = "camo_finish2",       label = locale("component_camo_finish2"),       hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_02` },
            { name = "camo_finish3",       label = locale("component_camo_finish3"),       hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_03` },
            { name = "camo_finish4",       label = locale("component_camo_finish4"),       hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_04` },
            { name = "camo_finish5",       label = locale("component_camo_finish5"),       hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_05` },
            { name = "camo_finish6",       label = locale("component_camo_finish6"),       hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_06` },
            { name = "camo_finish7",       label = locale("component_camo_finish7"),       hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_07` },
            { name = "camo_finish8",       label = locale("component_camo_finish8"),       hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_08` },
            { name = "camo_finish9",       label = locale("component_camo_finish9"),       hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_09` },
            { name = "camo_finish10",      label = locale("component_camo_finish10"),      hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_10` },
            { name = "camo_finish11",      label = locale("component_camo_finish11"),      hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01` }
        }
    },
    {
        name = "WEAPON_SAWNOFFSHOTGUN",
        label = locale("weapon_sawnoffshotgun"),
        ammo = { label = locale("ammo_shells"), hash = `AMMO_SHOTGUN` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE` }
        }
    },
    -- SMG & LMG
    {
        name = "WEAPON_ASSAULTSMG",
        label = locale("weapon_assaultsmg"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_SMG` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_ASSAULTSMG_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_ASSAULTSMG_CLIP_02` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_AR_FLSH` },
            { name = "scope",         label = locale("component_scope"),         hash = `COMPONENT_AT_SCOPE_MACRO` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_AR_SUPP_02` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER` }
        }
    },
    {
        name = "WEAPON_COMBATMG",
        label = locale("weapon_combatmg"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_MG` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_COMBATMG_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_COMBATMG_CLIP_02` },
            { name = "scope",         label = locale("component_scope"),         hash = `COMPONENT_AT_SCOPE_MEDIUM` },
            { name = "grip",          label = locale("component_grip"),          hash = `COMPONENT_AT_AR_AFGRIP` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_COMBATMG_VARMOD_LOWRIDER` }
        }
    },
    {
        name = "WEAPON_COMBATMG_MK2",
        label = locale("weapon_combatmg_mk2"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_MG` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",     label = locale("component_clip_default"),     hash = `COMPONENT_COMBATMG_MK2_CLIP_01` },
            { name = "clip_extended",    label = locale("component_clip_extended"),    hash = `COMPONENT_COMBATMG_MK2_CLIP_02` },
            { name = "ammo_tracer",      label = locale("component_ammo_tracer"),      hash = `COMPONENT_COMBATMG_MK2_CLIP_TRACER` },
            { name = "ammo_incendiary",  label = locale("component_ammo_incendiary"),  hash = `COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY` },
            { name = "ammo_hollowpoint", label = locale("component_ammo_hollowpoint"), hash = `COMPONENT_COMBATMG_MK2_CLIP_ARMORPIERCING` },
            { name = "ammo_fmj",         label = locale("component_ammo_fmj"),         hash = `COMPONENT_COMBATMG_MK2_CLIP_FMJ` },
            { name = "grip",             label = locale("component_grip"),             hash = `COMPONENT_AT_AR_AFGRIP_02` },
            { name = "scope_holo",       label = locale("component_scope_holo"),       hash = `COMPONENT_AT_SIGHTS` },
            { name = "scope_medium",     label = locale("component_scope_medium"),     hash = `COMPONENT_AT_SCOPE_SMALL_MK2` },
            { name = "scope_large",      label = locale("component_scope_large"),      hash = `COMPONENT_AT_SCOPE_MEDIUM_MK2` },
            { name = "muzzle_flat",      label = locale("component_muzzle_flat"),      hash = `COMPONENT_AT_MUZZLE_01` },
            { name = "muzzle_tactical",  label = locale("component_muzzle_tactical"),  hash = `COMPONENT_AT_MUZZLE_02` },
            { name = "muzzle_fat",       label = locale("component_muzzle_fat"),       hash = `COMPONENT_AT_MUZZLE_03` },
            { name = "muzzle_precision", label = locale("component_muzzle_precision"), hash = `COMPONENT_AT_MUZZLE_04` },
            { name = "muzzle_heavy",     label = locale("component_muzzle_heavy"),     hash = `COMPONENT_AT_MUZZLE_05` },
            { name = "muzzle_slanted",   label = locale("component_muzzle_slanted"),   hash = `COMPONENT_AT_MUZZLE_06` },
            { name = "muzzle_split",     label = locale("component_muzzle_split"),     hash = `COMPONENT_AT_MUZZLE_07` },
            { name = "barrel_default",   label = locale("component_barrel_default"),   hash = `COMPONENT_AT_MG_BARREL_01` },
            { name = "barrel_heavy",     label = locale("component_barrel_heavy"),     hash = `COMPONENT_AT_MG_BARREL_02` },
            { name = "camo_finish",      label = locale("component_camo_finish"),      hash = `COMPONENT_COMBATMG_MK2_CAMO` },
            { name = "camo_finish2",     label = locale("component_camo_finish2"),     hash = `COMPONENT_COMBATMG_MK2_CAMO_02` },
            { name = "camo_finish3",     label = locale("component_camo_finish3"),     hash = `COMPONENT_COMBATMG_MK2_CAMO_03` },
            { name = "camo_finish4",     label = locale("component_camo_finish4"),     hash = `COMPONENT_COMBATMG_MK2_CAMO_04` },
            { name = "camo_finish5",     label = locale("component_camo_finish5"),     hash = `COMPONENT_COMBATMG_MK2_CAMO_05` },
            { name = "camo_finish6",     label = locale("component_camo_finish6"),     hash = `COMPONENT_COMBATMG_MK2_CAMO_06` },
            { name = "camo_finish7",     label = locale("component_camo_finish7"),     hash = `COMPONENT_COMBATMG_MK2_CAMO_07` },
            { name = "camo_finish8",     label = locale("component_camo_finish8"),     hash = `COMPONENT_COMBATMG_MK2_CAMO_08` },
            { name = "camo_finish9",     label = locale("component_camo_finish9"),     hash = `COMPONENT_COMBATMG_MK2_CAMO_09` },
            { name = "camo_finish10",    label = locale("component_camo_finish10"),    hash = `COMPONENT_COMBATMG_MK2_CAMO_10` },
            { name = "camo_finish11",    label = locale("component_camo_finish11"),    hash = `COMPONENT_COMBATMG_MK2_CAMO_IND_01` }
        }
    },
    {
        name = "WEAPON_COMBATPDW",
        label = locale("weapon_combatpdw"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_SMG` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_COMBATPDW_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_COMBATPDW_CLIP_02` },
            { name = "clip_drum",     label = locale("component_clip_drum"),     hash = `COMPONENT_COMBATPDW_CLIP_03` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_AR_FLSH` },
            { name = "grip",          label = locale("component_grip"),          hash = `COMPONENT_AT_AR_AFGRIP` },
            { name = "scope",         label = locale("component_scope"),         hash = `COMPONENT_AT_SCOPE_SMALL` }
        }
    },
    {
        name = "WEAPON_GUSENBERG",
        label = locale("weapon_gusenberg"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_MG` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_GUSENBERG_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_GUSENBERG_CLIP_02` }
        }
    },
    {
        name = "WEAPON_MACHINEPISTOL",
        label = locale("weapon_machinepistol"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_PISTOL` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_MACHINEPISTOL_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_MACHINEPISTOL_CLIP_02` },
            { name = "clip_drum",     label = locale("component_clip_drum"),     hash = `COMPONENT_MACHINEPISTOL_CLIP_03` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_PI_SUPP` }
        }
    },
    {
        name = "WEAPON_MG",
        label = locale("weapon_mg"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_MG` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_MG_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_MG_CLIP_02` },
            { name = "scope",         label = locale("component_scope"),         hash = `COMPONENT_AT_SCOPE_SMALL_02` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_MG_VARMOD_LOWRIDER` }
        }
    },
    {
        name = "WEAPON_MICROSMG",
        label = locale("weapon_microsmg"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_SMG` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_MICROSMG_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_MICROSMG_CLIP_02` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_PI_FLSH` },
            { name = "scope",         label = locale("component_scope"),         hash = `COMPONENT_AT_SCOPE_MACRO` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_AR_SUPP_02` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_MICROSMG_VARMOD_LUXE` }
        }
    },
    {
        name = "WEAPON_MINISMG",
        label = locale("weapon_minismg"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_SMG` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_MINISMG_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_MINISMG_CLIP_02` }
        }
    },
    {
        name = "WEAPON_SMG",
        label = locale("weapon_smg"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_SMG` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_SMG_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_SMG_CLIP_02` },
            { name = "clip_drum",     label = locale("component_clip_drum"),     hash = `COMPONENT_SMG_CLIP_03` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_AR_FLSH` },
            { name = "scope",         label = locale("component_scope"),         hash = `COMPONENT_AT_SCOPE_MACRO_02` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_PI_SUPP` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_SMG_VARMOD_LUXE` }
        }
    },
    {
        name = "WEAPON_SMG_MK2",
        label = locale("weapon_smg_mk2"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_SMG` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",     label = locale("component_clip_default"),     hash = `COMPONENT_SMG_MK2_CLIP_01` },
            { name = "clip_extended",    label = locale("component_clip_extended"),    hash = `COMPONENT_SMG_MK2_CLIP_02` },
            { name = "ammo_tracer",      label = locale("component_ammo_tracer"),      hash = `COMPONENT_SMG_MK2_CLIP_TRACER` },
            { name = "ammo_incendiary",  label = locale("component_ammo_incendiary"),  hash = `COMPONENT_SMG_MK2_CLIP_INCENDIARY` },
            { name = "ammo_hollowpoint", label = locale("component_ammo_hollowpoint"), hash = `COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT` },
            { name = "ammo_fmj",         label = locale("component_ammo_fmj"),         hash = `COMPONENT_SMG_MK2_CLIP_FMJ` },
            { name = "flashlight",       label = locale("component_flashlight"),       hash = `COMPONENT_AT_AR_FLSH` },
            { name = "scope_holo",       label = locale("component_scope_holo"),       hash = `COMPONENT_AT_SIGHTS_SMG` },
            { name = "scope_small",      label = locale("component_scope_small"),      hash = `COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2` },
            { name = "scope_medium",     label = locale("component_scope_medium"),     hash = `COMPONENT_AT_SCOPE_SMALL_SMG_MK2` },
            { name = "suppressor",       label = locale("component_suppressor"),       hash = `COMPONENT_AT_PI_SUPP` },
            { name = "muzzle_flat",      label = locale("component_muzzle_flat"),      hash = `COMPONENT_AT_MUZZLE_01` },
            { name = "muzzle_tactical",  label = locale("component_muzzle_tactical"),  hash = `COMPONENT_AT_MUZZLE_02` },
            { name = "muzzle_fat",       label = locale("component_muzzle_fat"),       hash = `COMPONENT_AT_MUZZLE_03` },
            { name = "muzzle_precision", label = locale("component_muzzle_precision"), hash = `COMPONENT_AT_MUZZLE_04` },
            { name = "muzzle_heavy",     label = locale("component_muzzle_heavy"),     hash = `COMPONENT_AT_MUZZLE_05` },
            { name = "muzzle_slanted",   label = locale("component_muzzle_slanted"),   hash = `COMPONENT_AT_MUZZLE_06` },
            { name = "muzzle_split",     label = locale("component_muzzle_split"),     hash = `COMPONENT_AT_MUZZLE_07` },
            { name = "barrel_default",   label = locale("component_barrel_default"),   hash = `COMPONENT_AT_SB_BARREL_01` },
            { name = "barrel_heavy",     label = locale("component_barrel_heavy"),     hash = `COMPONENT_AT_SB_BARREL_02` },
            { name = "camo_finish",      label = locale("component_camo_finish"),      hash = `COMPONENT_SMG_MK2_CAMO` },
            { name = "camo_finish2",     label = locale("component_camo_finish2"),     hash = `COMPONENT_SMG_MK2_CAMO_02` },
            { name = "camo_finish3",     label = locale("component_camo_finish3"),     hash = `COMPONENT_SMG_MK2_CAMO_03` },
            { name = "camo_finish4",     label = locale("component_camo_finish4"),     hash = `COMPONENT_SMG_MK2_CAMO_04` },
            { name = "camo_finish5",     label = locale("component_camo_finish5"),     hash = `COMPONENT_SMG_MK2_CAMO_05` },
            { name = "camo_finish6",     label = locale("component_camo_finish6"),     hash = `COMPONENT_SMG_MK2_CAMO_06` },
            { name = "camo_finish7",     label = locale("component_camo_finish7"),     hash = `COMPONENT_SMG_MK2_CAMO_07` },
            { name = "camo_finish8",     label = locale("component_camo_finish8"),     hash = `COMPONENT_SMG_MK2_CAMO_08` },
            { name = "camo_finish9",     label = locale("component_camo_finish9"),     hash = `COMPONENT_SMG_MK2_CAMO_09` },
            { name = "camo_finish10",    label = locale("component_camo_finish10"),    hash = `COMPONENT_SMG_MK2_CAMO_10` },
            { name = "camo_finish11",    label = locale("component_camo_finish11"),    hash = `COMPONENT_SMG_MK2_CAMO_IND_01` }
        }
    },
    {
        name = "WEAPON_RAYCARBINE",
        label = locale("weapon_raycarbine"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_SMG` },
        tints =
            Config.DefaultWeaponTints,
        components = {}
    },
    -- Rifles
    {
        name = "WEAPON_ADVANCEDRIFLE",
        label = locale("weapon_advancedrifle"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_RIFLE` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_ADVANCEDRIFLE_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_ADVANCEDRIFLE_CLIP_02` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_AR_FLSH` },
            { name = "scope",         label = locale("component_scope"),         hash = `COMPONENT_AT_SCOPE_SMALL` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_AR_SUPP` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE` }
        }
    },
    {
        name = "WEAPON_ASSAULTRIFLE",
        label = locale("weapon_assaultrifle"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_RIFLE` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_ASSAULTRIFLE_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_ASSAULTRIFLE_CLIP_02` },
            { name = "clip_drum",     label = locale("component_clip_drum"),     hash = `COMPONENT_ASSAULTRIFLE_CLIP_03` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_AR_FLSH` },
            { name = "scope",         label = locale("component_scope"),         hash = `COMPONENT_AT_SCOPE_MACRO` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_AR_SUPP_02` },
            { name = "grip",          label = locale("component_grip"),          hash = `COMPONENT_AT_AR_AFGRIP` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_ASSAULTRIFLE_VARMOD_LUXE` }
        }
    },
    {
        name = "WEAPON_ASSAULTRIFLE_MK2",
        label = locale("weapon_assaultrifle_mk2"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_RIFLE` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",     label = locale("component_clip_default"),     hash = `COMPONENT_ASSAULTRIFLE_MK2_CLIP_01` },
            { name = "clip_extended",    label = locale("component_clip_extended"),    hash = `COMPONENT_ASSAULTRIFLE_MK2_CLIP_02` },
            { name = "ammo_tracer",      label = locale("component_ammo_tracer"),      hash = `COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER` },
            { name = "ammo_incendiary",  label = locale("component_ammo_incendiary"),  hash = `COMPONENT_ASSAULTRIFLE_MK2_CLIP_INCENDIARY` },
            { name = "ammo_armor",       label = locale("component_ammo_armor"),       hash = `COMPONENT_ASSAULTRIFLE_MK2_CLIP_ARMORPIERCING` },
            { name = "ammo_fmj",         label = locale("component_ammo_fmj"),         hash = `COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ` },
            { name = "grip",             label = locale("component_grip"),             hash = `COMPONENT_AT_AR_AFGRIP_02` },
            { name = "flashlight",       label = locale("component_flashlight"),       hash = `COMPONENT_AT_AR_FLSH` },
            { name = "scope_holo",       label = locale("component_scope_holo"),       hash = `COMPONENT_AT_SIGHTS` },
            { name = "scope_small",      label = locale("component_scope_small"),      hash = `COMPONENT_AT_SCOPE_MACRO_MK2` },
            { name = "scope_large",      label = locale("component_scope_large"),      hash = `COMPONENT_AT_SCOPE_MEDIUM_MK2` },
            { name = "suppressor",       label = locale("component_suppressor"),       hash = `COMPONENT_AT_AR_SUPP_02` },
            { name = "muzzle_flat",      label = locale("component_muzzle_flat"),      hash = `COMPONENT_AT_MUZZLE_01` },
            { name = "muzzle_tactical",  label = locale("component_muzzle_tactical"),  hash = `COMPONENT_AT_MUZZLE_02` },
            { name = "muzzle_fat",       label = locale("component_muzzle_fat"),       hash = `COMPONENT_AT_MUZZLE_03` },
            { name = "muzzle_precision", label = locale("component_muzzle_precision"), hash = `COMPONENT_AT_MUZZLE_04` },
            { name = "muzzle_heavy",     label = locale("component_muzzle_heavy"),     hash = `COMPONENT_AT_MUZZLE_05` },
            { name = "muzzle_slanted",   label = locale("component_muzzle_slanted"),   hash = `COMPONENT_AT_MUZZLE_06` },
            { name = "muzzle_split",     label = locale("component_muzzle_split"),     hash = `COMPONENT_AT_MUZZLE_07` },
            { name = "barrel_default",   label = locale("component_barrel_default"),   hash = `COMPONENT_AT_AR_BARREL_01` },
            { name = "barrel_heavy",     label = locale("component_barrel_heavy"),     hash = `COMPONENT_AT_AR_BARREL_02` },
            { name = "camo_finish",      label = locale("component_camo_finish"),      hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO` },
            { name = "camo_finish2",     label = locale("component_camo_finish2"),     hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_02` },
            { name = "camo_finish3",     label = locale("component_camo_finish3"),     hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_03` },
            { name = "camo_finish4",     label = locale("component_camo_finish4"),     hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_04` },
            { name = "camo_finish5",     label = locale("component_camo_finish5"),     hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_05` },
            { name = "camo_finish6",     label = locale("component_camo_finish6"),     hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_06` },
            { name = "camo_finish7",     label = locale("component_camo_finish7"),     hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_07` },
            { name = "camo_finish8",     label = locale("component_camo_finish8"),     hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_08` },
            { name = "camo_finish9",     label = locale("component_camo_finish9"),     hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_09` },
            { name = "camo_finish10",    label = locale("component_camo_finish10"),    hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_10` },
            { name = "camo_finish11",    label = locale("component_camo_finish11"),    hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01` }
        }
    },
    {
        name = "WEAPON_BULLPUPRIFLE",
        label = locale("weapon_bullpuprifle"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_RIFLE` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_BULLPUPRIFLE_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_BULLPUPRIFLE_CLIP_02` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_AR_FLSH` },
            { name = "scope",         label = locale("component_scope"),         hash = `COMPONENT_AT_SCOPE_SMALL` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_AR_SUPP` },
            { name = "grip",          label = locale("component_grip"),          hash = `COMPONENT_AT_AR_AFGRIP` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_BULLPUPRIFLE_VARMOD_LOW` }
        }
    },
    {
        name = "WEAPON_BULLPUPRIFLE_MK2",
        label = locale("weapon_bullpuprifle_mk2"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_RIFLE` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",     label = locale("component_clip_default"),     hash = `COMPONENT_BULLPUPRIFLE_MK2_CLIP_01` },
            { name = "clip_extended",    label = locale("component_clip_extended"),    hash = `COMPONENT_BULLPUPRIFLE_MK2_CLIP_02` },
            { name = "ammo_tracer",      label = locale("component_ammo_tracer"),      hash = `COMPONENT_BULLPUPRIFLE_MK2_CLIP_TRACER` },
            { name = "ammo_incendiary",  label = locale("component_ammo_incendiary"),  hash = `COMPONENT_BULLPUPRIFLE_MK2_CLIP_INCENDIARY` },
            { name = "ammo_armor",       label = locale("component_ammo_armor"),       hash = `COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING` },
            { name = "ammo_fmj",         label = locale("component_ammo_fmj"),         hash = `COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ` },
            { name = "flashlight",       label = locale("component_flashlight"),       hash = `COMPONENT_AT_AR_FLSH` },
            { name = "scope_holo",       label = locale("component_scope_holo"),       hash = `COMPONENT_AT_SIGHTS` },
            { name = "scope_small",      label = locale("component_scope_small"),      hash = `COMPONENT_AT_SCOPE_MACRO_02_MK2` },
            { name = "scope_medium",     label = locale("component_scope_medium"),     hash = `COMPONENT_AT_SCOPE_SMALL_MK2` },
            { name = "barrel_default",   label = locale("component_barrel_default"),   hash = `COMPONENT_AT_BP_BARREL_01` },
            { name = "barrel_heavy",     label = locale("component_barrel_heavy"),     hash = `COMPONENT_AT_BP_BARREL_02` },
            { name = "suppressor",       label = locale("component_suppressor"),       hash = `COMPONENT_AT_AR_SUPP` },
            { name = "muzzle_flat",      label = locale("component_muzzle_flat"),      hash = `COMPONENT_AT_MUZZLE_01` },
            { name = "muzzle_tactical",  label = locale("component_muzzle_tactical"),  hash = `COMPONENT_AT_MUZZLE_02` },
            { name = "muzzle_fat",       label = locale("component_muzzle_fat"),       hash = `COMPONENT_AT_MUZZLE_03` },
            { name = "muzzle_precision", label = locale("component_muzzle_precision"), hash = `COMPONENT_AT_MUZZLE_04` },
            { name = "muzzle_heavy",     label = locale("component_muzzle_heavy"),     hash = `COMPONENT_AT_MUZZLE_05` },
            { name = "muzzle_slanted",   label = locale("component_muzzle_slanted"),   hash = `COMPONENT_AT_MUZZLE_06` },
            { name = "muzzle_split",     label = locale("component_muzzle_split"),     hash = `COMPONENT_AT_MUZZLE_07` },
            { name = "grip",             label = locale("component_grip"),             hash = `COMPONENT_AT_AR_AFGRIP_02` },
            { name = "camo_finish",      label = locale("component_camo_finish"),      hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO` },
            { name = "camo_finish2",     label = locale("component_camo_finish2"),     hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_02` },
            { name = "camo_finish3",     label = locale("component_camo_finish3"),     hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_03` },
            { name = "camo_finish4",     label = locale("component_camo_finish4"),     hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_04` },
            { name = "camo_finish5",     label = locale("component_camo_finish5"),     hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_05` },
            { name = "camo_finish6",     label = locale("component_camo_finish6"),     hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_06` },
            { name = "camo_finish7",     label = locale("component_camo_finish7"),     hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_07` },
            { name = "camo_finish8",     label = locale("component_camo_finish8"),     hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_08` },
            { name = "camo_finish9",     label = locale("component_camo_finish9"),     hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_09` },
            { name = "camo_finish10",    label = locale("component_camo_finish10"),    hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_10` },
            { name = "camo_finish11",    label = locale("component_camo_finish11"),    hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01` }
        }
    },
    {
        name = "WEAPON_CARBINERIFLE",
        label = locale("weapon_carbinerifle"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_RIFLE` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_CARBINERIFLE_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_CARBINERIFLE_CLIP_02` },
            { name = "clip_box",      label = locale("component_clip_box"),      hash = `COMPONENT_CARBINERIFLE_CLIP_03` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_AR_FLSH` },
            { name = "scope",         label = locale("component_scope"),         hash = `COMPONENT_AT_SCOPE_MEDIUM` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_AR_SUPP` },
            { name = "grip",          label = locale("component_grip"),          hash = `COMPONENT_AT_AR_AFGRIP` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_CARBINERIFLE_VARMOD_LUXE` }
        }
    },
    {
        name = "WEAPON_CARBINERIFLE_MK2",
        label = locale("weapon_carbinerifle_mk2"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_RIFLE` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",     label = locale("component_clip_default"),     hash = `COMPONENT_CARBINERIFLE_MK2_CLIP_01` },
            { name = "clip_extended",    label = locale("component_clip_extended"),    hash = `COMPONENT_CARBINERIFLE_MK2_CLIP_02` },
            { name = "ammo_tracer",      label = locale("component_ammo_tracer"),      hash = `COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER` },
            { name = "ammo_incendiary",  label = locale("component_ammo_incendiary"),  hash = `COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY` },
            { name = "ammo_armor",       label = locale("component_ammo_armor"),       hash = `COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING` },
            { name = "ammo_fmj",         label = locale("component_ammo_fmj"),         hash = `COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ` },
            { name = "grip",             label = locale("component_grip"),             hash = `COMPONENT_AT_AR_AFGRIP_02` },
            { name = "flashlight",       label = locale("component_flashlight"),       hash = `COMPONENT_AT_AR_FLSH` },
            { name = "scope_holo",       label = locale("component_scope_holo"),       hash = `COMPONENT_AT_SIGHTS` },
            { name = "scope_medium",     label = locale("component_scope_medium"),     hash = `COMPONENT_AT_SCOPE_MACRO_MK2` },
            { name = "scope_large",      label = locale("component_scope_large"),      hash = `COMPONENT_AT_SCOPE_MEDIUM_MK2` },
            { name = "suppressor",       label = locale("component_suppressor"),       hash = `COMPONENT_AT_AR_SUPP` },
            { name = "muzzle_flat",      label = locale("component_muzzle_flat"),      hash = `COMPONENT_AT_MUZZLE_01` },
            { name = "muzzle_tactical",  label = locale("component_muzzle_tactical"),  hash = `COMPONENT_AT_MUZZLE_02` },
            { name = "muzzle_fat",       label = locale("component_muzzle_fat"),       hash = `COMPONENT_AT_MUZZLE_03` },
            { name = "muzzle_precision", label = locale("component_muzzle_precision"), hash = `COMPONENT_AT_MUZZLE_04` },
            { name = "muzzle_heavy",     label = locale("component_muzzle_heavy"),     hash = `COMPONENT_AT_MUZZLE_05` },
            { name = "muzzle_slanted",   label = locale("component_muzzle_slanted"),   hash = `COMPONENT_AT_MUZZLE_06` },
            { name = "muzzle_split",     label = locale("component_muzzle_split"),     hash = `COMPONENT_AT_MUZZLE_07` },
            { name = "barrel_default",   label = locale("component_barrel_default"),   hash = `COMPONENT_AT_CR_BARREL_01` },
            { name = "barrel_heavy",     label = locale("component_barrel_heavy"),     hash = `COMPONENT_AT_CR_BARREL_02` },
            { name = "camo_finish",      label = locale("component_camo_finish"),      hash = `COMPONENT_CARBINERIFLE_MK2_CAMO` },
            { name = "camo_finish2",     label = locale("component_camo_finish2"),     hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_02` },
            { name = "camo_finish3",     label = locale("component_camo_finish3"),     hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_03` },
            { name = "camo_finish4",     label = locale("component_camo_finish4"),     hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_04` },
            { name = "camo_finish5",     label = locale("component_camo_finish5"),     hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_05` },
            { name = "camo_finish6",     label = locale("component_camo_finish6"),     hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_06` },
            { name = "camo_finish7",     label = locale("component_camo_finish7"),     hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_07` },
            { name = "camo_finish8",     label = locale("component_camo_finish8"),     hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_08` },
            { name = "camo_finish9",     label = locale("component_camo_finish9"),     hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_09` },
            { name = "camo_finish10",    label = locale("component_camo_finish10"),    hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_10` },
            { name = "camo_finish11",    label = locale("component_camo_finish11"),    hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01` }
        }
    },
    {
        name = "WEAPON_COMPACTRIFLE",
        label = locale("weapon_compactrifle"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_RIFLE` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_COMPACTRIFLE_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_COMPACTRIFLE_CLIP_02` },
            { name = "clip_drum",     label = locale("component_clip_drum"),     hash = `COMPONENT_COMPACTRIFLE_CLIP_03` }
        }
    },
    {
        name = "WEAPON_MILITARYRIFLE",
        label = locale("weapon_militaryrifle"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_RIFLE` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_MILITARYRIFLE_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_MILITARYRIFLE_CLIP_02` },
            { name = "ironsights",    label = locale("component_ironsights"),    hash = `COMPONENT_MILITARYRIFLE_SIGHT_01` },
            { name = "scope",         label = locale("component_scope"),         hash = `COMPONENT_AT_SCOPE_SMALL` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_AR_FLSH` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_AR_SUPP` }
        }
    },
    {
        name = "WEAPON_SPECIALCARBINE",
        label = locale("weapon_specialcarbine"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_RIFLE` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_SPECIALCARBINE_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_SPECIALCARBINE_CLIP_02` },
            { name = "clip_drum",     label = locale("component_clip_drum"),     hash = `COMPONENT_SPECIALCARBINE_CLIP_03` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_AR_FLSH` },
            { name = "scope",         label = locale("component_scope"),         hash = `COMPONENT_AT_SCOPE_MEDIUM` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_AR_SUPP_02` },
            { name = "grip",          label = locale("component_grip"),          hash = `COMPONENT_AT_AR_AFGRIP` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER` }
        }
    },
    {
        name = "WEAPON_SPECIALCARBINE_MK2",
        label = locale("weapon_specialcarbine_mk2"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_RIFLE` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",     label = locale("component_clip_default"),     hash = `COMPONENT_SPECIALCARBINE_MK2_CLIP_01` },
            { name = "clip_extended",    label = locale("component_clip_extended"),    hash = `COMPONENT_SPECIALCARBINE_MK2_CLIP_02` },
            { name = "ammo_tracer",      label = locale("component_ammo_tracer"),      hash = `COMPONENT_SPECIALCARBINE_MK2_CLIP_TRACER` },
            { name = "ammo_incendiary",  label = locale("component_ammo_incendiary"),  hash = `COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY` },
            { name = "ammo_armor",       label = locale("component_ammo_armor"),       hash = `COMPONENT_SPECIALCARBINE_MK2_CLIP_ARMORPIERCING` },
            { name = "ammo_fmj",         label = locale("component_ammo_fmj"),         hash = `COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ` },
            { name = "flashlight",       label = locale("component_flashlight"),       hash = `COMPONENT_AT_AR_FLSH` },
            { name = "scope_holo",       label = locale("component_scope_holo"),       hash = `COMPONENT_AT_SIGHTS` },
            { name = "scope_small",      label = locale("component_scope_small"),      hash = `COMPONENT_AT_SCOPE_MACRO_MK2` },
            { name = "scope_large",      label = locale("component_scope_large"),      hash = `COMPONENT_AT_SCOPE_MEDIUM_MK2` },
            { name = "suppressor",       label = locale("component_suppressor"),       hash = `COMPONENT_AT_AR_SUPP_02` },
            { name = "muzzle_flat",      label = locale("component_muzzle_flat"),      hash = `COMPONENT_AT_MUZZLE_01` },
            { name = "muzzle_tactical",  label = locale("component_muzzle_tactical"),  hash = `COMPONENT_AT_MUZZLE_02` },
            { name = "muzzle_fat",       label = locale("component_muzzle_fat"),       hash = `COMPONENT_AT_MUZZLE_03` },
            { name = "muzzle_precision", label = locale("component_muzzle_precision"), hash = `COMPONENT_AT_MUZZLE_04` },
            { name = "muzzle_heavy",     label = locale("component_muzzle_heavy"),     hash = `COMPONENT_AT_MUZZLE_05` },
            { name = "muzzle_slanted",   label = locale("component_muzzle_slanted"),   hash = `COMPONENT_AT_MUZZLE_06` },
            { name = "muzzle_split",     label = locale("component_muzzle_split"),     hash = `COMPONENT_AT_MUZZLE_07` },
            { name = "grip",             label = locale("component_grip"),             hash = `COMPONENT_AT_AR_AFGRIP_02` },
            { name = "barrel_default",   label = locale("component_barrel_default"),   hash = `COMPONENT_AT_SC_BARREL_01` },
            { name = "barrel_heavy",     label = locale("component_barrel_heavy"),     hash = `COMPONENT_AT_SC_BARREL_02` },
            { name = "camo_finish",      label = locale("component_camo_finish"),      hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO` },
            { name = "camo_finish2",     label = locale("component_camo_finish2"),     hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_02` },
            { name = "camo_finish3",     label = locale("component_camo_finish3"),     hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_03` },
            { name = "camo_finish4",     label = locale("component_camo_finish4"),     hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_04` },
            { name = "camo_finish5",     label = locale("component_camo_finish5"),     hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_05` },
            { name = "camo_finish6",     label = locale("component_camo_finish6"),     hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_06` },
            { name = "camo_finish7",     label = locale("component_camo_finish7"),     hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_07` },
            { name = "camo_finish8",     label = locale("component_camo_finish8"),     hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_08` },
            { name = "camo_finish9",     label = locale("component_camo_finish9"),     hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_09` },
            { name = "camo_finish10",    label = locale("component_camo_finish10"),    hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_10` },
            { name = "camo_finish11",    label = locale("component_camo_finish11"),    hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01` }
        }
    },
    -- Sniper
    {
        name = "WEAPON_HEAVYSNIPER",
        label = locale("weapon_heavysniper"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_SNIPER` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "scope",          label = locale("component_scope"),          hash = `COMPONENT_AT_SCOPE_LARGE` },
            { name = "scope_advanced", label = locale("component_scope_advanced"), hash = `COMPONENT_AT_SCOPE_MAX` }
        }
    },
    {
        name = "WEAPON_HEAVYSNIPER_MK2",
        label = locale("weapon_heavysniper_mk2"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_SNIPER` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",      label = locale("component_clip_default"),      hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_01` },
            { name = "clip_extended",     label = locale("component_clip_extended"),     hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_02` },
            { name = "ammo_incendiary",   label = locale("component_ammo_incendiary"),   hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY` },
            { name = "ammo_armor",        label = locale("component_ammo_armor"),        hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING` },
            { name = "ammo_fmj",          label = locale("component_ammo_fmj"),          hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ` },
            { name = "ammo_explosive",    label = locale("component_ammo_explosive"),    hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE` },
            { name = "scope_zoom",        label = locale("component_scope_zoom"),        hash = `COMPONENT_AT_SCOPE_LARGE_MK2` },
            { name = "scope_advanced",    label = locale("component_scope_advanced"),    hash = `COMPONENT_AT_SCOPE_MAX` },
            { name = "scope_nightvision", label = locale("component_scope_nightvision"), hash = `COMPONENT_AT_SCOPE_NV` },
            { name = "scope_thermal",     label = locale("component_scope_thermal"),     hash = `COMPONENT_AT_SCOPE_THERMAL` },
            { name = "suppressor",        label = locale("component_suppressor"),        hash = `COMPONENT_AT_SR_SUPP_03` },
            { name = "muzzle_squared",    label = locale("component_muzzle_squared"),    hash = `COMPONENT_AT_MUZZLE_08` },
            { name = "muzzle_bell",       label = locale("component_muzzle_bell"),       hash = `COMPONENT_AT_MUZZLE_09` },
            { name = "barrel_default",    label = locale("component_barrel_default"),    hash = `COMPONENT_AT_SR_BARREL_01` },
            { name = "barrel_heavy",      label = locale("component_barrel_heavy"),      hash = `COMPONENT_AT_SR_BARREL_02` },
            { name = "camo_finish",       label = locale("component_camo_finish"),       hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO` },
            { name = "camo_finish2",      label = locale("component_camo_finish2"),      hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_02` },
            { name = "camo_finish3",      label = locale("component_camo_finish3"),      hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_03` },
            { name = "camo_finish4",      label = locale("component_camo_finish4"),      hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_04` },
            { name = "camo_finish5",      label = locale("component_camo_finish5"),      hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_05` },
            { name = "camo_finish6",      label = locale("component_camo_finish6"),      hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_06` },
            { name = "camo_finish7",      label = locale("component_camo_finish7"),      hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_07` },
            { name = "camo_finish8",      label = locale("component_camo_finish8"),      hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_08` },
            { name = "camo_finish9",      label = locale("component_camo_finish9"),      hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_09` },
            { name = "camo_finish10",     label = locale("component_camo_finish10"),     hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_10` },
            { name = "camo_finish11",     label = locale("component_camo_finish11"),     hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01` }
        }
    },
    {
        name = "WEAPON_MARKSMANRIFLE",
        label = locale("weapon_marksmanrifle"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_SNIPER` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_MARKSMANRIFLE_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_MARKSMANRIFLE_CLIP_02` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_AR_FLSH` },
            { name = "scope",         label = locale("component_scope"),         hash = `COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_AR_SUPP` },
            { name = "grip",          label = locale("component_grip"),          hash = `COMPONENT_AT_AR_AFGRIP` },
            { name = "luxary_finish", label = locale("component_luxary_finish"), hash = `COMPONENT_MARKSMANRIFLE_VARMOD_LUXE` }
        }
    },
    {
        name = "WEAPON_MARKSMANRIFLE_MK2",
        label = locale("weapon_marksmanrifle_mk2"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_SNIPER` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",     label = locale("component_clip_default"),     hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_01` },
            { name = "clip_extended",    label = locale("component_clip_extended"),    hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_02` },
            { name = "ammo_tracer",      label = locale("component_ammo_tracer"),      hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER` },
            { name = "ammo_incendiary",  label = locale("component_ammo_incendiary"),  hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY` },
            { name = "ammo_armor",       label = locale("component_ammo_armor"),       hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING` },
            { name = "ammo_fmj",         label = locale("component_ammo_fmj"),         hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ` },
            { name = "scope_holo",       label = locale("component_scope_holo"),       hash = `COMPONENT_AT_SIGHTS` },
            { name = "scope_large",      label = locale("component_scope_large"),      hash = `COMPONENT_AT_SCOPE_MEDIUM_MK2` },
            { name = "scope_zoom",       label = locale("component_scope_zoom"),       hash = `COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2` },
            { name = "flashlight",       label = locale("component_flashlight"),       hash = `COMPONENT_AT_AR_FLSH` },
            { name = "suppressor",       label = locale("component_suppressor"),       hash = `COMPONENT_AT_AR_SUPP` },
            { name = "muzzle_flat",      label = locale("component_muzzle_flat"),      hash = `COMPONENT_AT_MUZZLE_01` },
            { name = "muzzle_tactical",  label = locale("component_muzzle_tactical"),  hash = `COMPONENT_AT_MUZZLE_02` },
            { name = "muzzle_fat",       label = locale("component_muzzle_fat"),       hash = `COMPONENT_AT_MUZZLE_03` },
            { name = "muzzle_precision", label = locale("component_muzzle_precision"), hash = `COMPONENT_AT_MUZZLE_04` },
            { name = "muzzle_heavy",     label = locale("component_muzzle_heavy"),     hash = `COMPONENT_AT_MUZZLE_05` },
            { name = "muzzle_slanted",   label = locale("component_muzzle_slanted"),   hash = `COMPONENT_AT_MUZZLE_06` },
            { name = "muzzle_split",     label = locale("component_muzzle_split"),     hash = `COMPONENT_AT_MUZZLE_07` },
            { name = "barrel_default",   label = locale("component_barrel_default"),   hash = `COMPONENT_AT_MRFL_BARREL_01` },
            { name = "barrel_heavy",     label = locale("component_barrel_heavy"),     hash = `COMPONENT_AT_MRFL_BARREL_02` },
            { name = "grip",             label = locale("component_grip"),             hash = `COMPONENT_AT_AR_AFGRIP_02` },
            { name = "camo_finish",      label = locale("component_camo_finish"),      hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO` },
            { name = "camo_finish2",     label = locale("component_camo_finish2"),     hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_02` },
            { name = "camo_finish3",     label = locale("component_camo_finish3"),     hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_03` },
            { name = "camo_finish4",     label = locale("component_camo_finish4"),     hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_04` },
            { name = "camo_finish5",     label = locale("component_camo_finish5"),     hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_05` },
            { name = "camo_finish6",     label = locale("component_camo_finish6"),     hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_06` },
            { name = "camo_finish7",     label = locale("component_camo_finish7"),     hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_07` },
            { name = "camo_finish8",     label = locale("component_camo_finish8"),     hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_08` },
            { name = "camo_finish9",     label = locale("component_camo_finish9"),     hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_09` },
            { name = "camo_finish10",    label = locale("component_camo_finish10"),    hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_10` },
            { name = "camo_finish11",    label = locale("component_camo_finish11"),    hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_IND_01` }
        }
    },
    {
        name = "WEAPON_SNIPERRIFLE",
        label = locale("weapon_sniperrifle"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_SNIPER` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "scope",          label = locale("component_scope"),          hash = `COMPONENT_AT_SCOPE_LARGE` },
            { name = "scope_advanced", label = locale("component_scope_advanced"), hash = `COMPONENT_AT_SCOPE_MAX` },
            { name = "suppressor",     label = locale("component_suppressor"),     hash = `COMPONENT_AT_AR_SUPP_02` },
            { name = "luxary_finish",  label = locale("component_luxary_finish"),  hash = `COMPONENT_SNIPERRIFLE_VARMOD_LUXE` }
        }
    },
    -- Heavy / Launchers
    {
        name = "WEAPON_COMPACTLAUNCHER",
        label = locale("weapon_compactlauncher"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_grenadelauncher"), hash = `AMMO_GRENADELAUNCHER` }
    },
    {
        name = "WEAPON_FIREWORK",
        label = locale("weapon_firework"),
        components = {},
        ammo = {
            label = locale("ammo_firework"), hash = `AMMO_FIREWORK` }
    },
    {
        name = "WEAPON_GRENADELAUNCHER",
        label = locale("weapon_grenadelauncher"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_grenadelauncher"), hash = `AMMO_GRENADELAUNCHER` }
    },
    {
        name = "WEAPON_HOMINGLAUNCHER",
        label = locale("weapon_hominglauncher"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_rockets"), hash = `AMMO_HOMINGLAUNCHER` }
    },
    {
        name = "WEAPON_MINIGUN",
        label = locale("weapon_minigun"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_rounds"), hash = `AMMO_MINIGUN` }
    },
    {
        name = "WEAPON_RAILGUN",
        label = locale("weapon_railgun"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_rounds"), hash = `AMMO_RAILGUN` }
    },
    {
        name = "WEAPON_RPG",
        label = locale("weapon_rpg"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_rockets"), hash = `AMMO_RPG` }
    },
    {
        name = "WEAPON_RAYMINIGUN",
        label = locale("weapon_rayminigun"),
        tints = Config.DefaultWeaponTints,
        components = {},
        ammo = {
            label = locale("ammo_rounds"), hash = `AMMO_MINIGUN` }
    },
    -- Thrown
    {
        name = "WEAPON_BALL",
        label = locale("weapon_ball"),
        components = {},
        ammo = {
            label = locale("ammo_ball"), hash = `AMMO_BALL` }
    },
    {
        name = "WEAPON_BZGAS",
        label = locale("weapon_bzgas"),
        components = {},
        ammo = {
            label = locale("ammo_bzgas"), hash = `AMMO_BZGAS` }
    },
    {
        name = "WEAPON_FLARE",
        label = locale("weapon_flare"),
        components = {},
        ammo = {
            label = locale("ammo_flare"), hash = `AMMO_FLARE` }
    },
    {
        name = "WEAPON_GRENADE",
        label = locale("weapon_grenade"),
        components = {},
        ammo = {
            label = locale("ammo_grenade"), hash = `AMMO_GRENADE` }
    },
    {
        name = "WEAPON_PETROLCAN",
        label = locale("weapon_petrolcan"),
        components = {},
        ammo = {
            label = locale("ammo_petrol"), hash = `AMMO_PETROLCAN` }
    },
    {
        name = "WEAPON_HAZARDCAN",
        label = locale("weapon_hazardcan"),
        components = {},
        ammo = {
            label = locale("ammo_petrol"), hash = `AMMO_PETROLCAN` }
    },
    {
        name = "WEAPON_MOLOTOV",
        label = locale("weapon_molotov"),
        components = {},
        ammo = {
            label = locale("ammo_molotov"), hash = `AMMO_MOLOTOV` }
    },
    {
        name = "WEAPON_PROXMINE",
        label = locale("weapon_proxmine"),
        components = {},
        ammo = {
            label = locale("ammo_proxmine"), hash = `AMMO_PROXMINE` }
    },
    {
        name = "WEAPON_PIPEBOMB",
        label = locale("weapon_pipebomb"),
        components = {},
        ammo = {
            label = locale("ammo_pipebomb"), hash = `AMMO_PIPEBOMB` }
    },
    {
        name = "WEAPON_SNOWBALL",
        label = locale("weapon_snowball"),
        components = {},
        ammo = {
            label = locale("ammo_snowball"), hash = `AMMO_SNOWBALL` }
    },
    {
        name = "WEAPON_STICKYBOMB",
        label = locale("weapon_stickybomb"),
        components = {},
        ammo = {
            label = locale("ammo_stickybomb"), hash = `AMMO_STICKYBOMB` }
    },
    {
        name = "WEAPON_SMOKEGRENADE",
        label = locale("weapon_smokegrenade"),
        components = {},
        ammo = {
            label = locale("ammo_smokebomb"), hash = `AMMO_SMOKEGRENADE` }
    },
    -- Tools
    {
        name = "WEAPON_FIREEXTINGUISHER",
        label = locale("weapon_fireextinguisher"),
        components = {},
        ammo = {
            label = locale("ammo_charge"), hash = `AMMO_FIREEXTINGUISHER` }
    },
    { name = "WEAPON_DIGISCANNER", label = locale("weapon_digiscanner"), components = {} },
    { name = "GADGET_PARACHUTE",   label = locale("gadget_parachute"),   components = {} },
    {
        name = "WEAPON_TACTICALRIFLE",
        label = locale("weapon_tactilerifle"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_RIFLE` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default",  label = locale("component_clip_default"),  hash = `COMPONENT_TACTICALRIFLE_CLIP_01` },
            { name = "clip_extended", label = locale("component_clip_extended"), hash = `COMPONENT_TACTICALRIFLE_CLIP_02` },
            { name = "flashlight",    label = locale("component_flashlight"),    hash = `COMPONENT_AT_AR_FLSH_REH` },
            { name = "grip",          label = locale("component_grip"),          hash = `COMPONENT_AT_AR_AFGRIP` },
            { name = "suppressor",    label = locale("component_suppressor"),    hash = `COMPONENT_AT_AR_SUPP_02` }
        }
    },
    {
        name = "WEAPON_PRECISIONRIFLE",
        label = locale("weapon_precisionrifle"),
        ammo = { label = locale("ammo_rounds"), hash = `AMMO_SNIPER` },
        tints = Config.DefaultWeaponTints,
        components = {
            { name = "clip_default", label = locale("component_clip_default"), hash = `COMPONENT_PRECISIONRIFLE_CLIP_01` },
        }
    },
    { name = "WEAPON_METALDETECTOR", label = locale("weapon_metaldetector"), components = {} }
}
