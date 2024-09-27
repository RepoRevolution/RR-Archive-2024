Config = {}
Config.Debug = true

Config.Centrals = {
    {
        name = 'Paleto Bay Sheriff`s Office',
        zone = {
            coords = vec3(-447.652740, 6010.892090, 32.206176),
            size = vector3(3.6, 4.8, 3.0),
            rotation = 45
        },
        radio_ranges = { 100, 200, 300, 400, 500, 600, '201-230' }
    }
}

Config.Signal = {
    submixes = {
        {
            max_distance = 150.0,
            submix_name = 'rr_radio_close',
            submix_data = {
                freq_low = 389.0,
                freq_hi = 3248.0,
                fudge = 0.0,
                rm_mod_freq = 0.0,
                rm_mix = 0.16,
                o_freq_lo = 348.0,
                o_freq_hi = 4900.0
            }
        },
        {
            max_distance = 200.0,
            submix_name = 'rr_radio_near',
            submix_data = {
                freq_low = 389.0,
                freq_hi = 2300.0,
                fudge = 0.0,
                rm_mod_freq = 0.85,
                rm_mix = 1.1,
                o_freq_lo = 348.0,
                o_freq_hi = 3300.0
            }
        },
        {
            max_distance = 300.0,
            submix_name = 'rr_radio_far',
            submix_data = {
                freq_low = 389.0,
                freq_hi = 1500.0,
                fudge = 0.2,
                rm_mod_freq = 1.2,
                rm_mix = 1.5,
                o_freq_lo = 348.0,
                o_freq_hi = 2500.0
            }
        },
        {
            max_distance = 350.0,
            submix_name = 'rr_radio_very_far',
            submix_data = {
                freq_low = 500.0,
                freq_hi = 1000.0,
                fudge = 0.0,
                rm_mod_freq = 500.0,
                rm_mix = 1.5,
                o_freq_lo = 750.0,
                o_freq_hi = 2000.0
            }
        }
    }
}