Config.Logs = {
    give_key = {
        enabled = false,
        webhook = '',
        mentions = {
            roles = { --[[ roleId number or 'here' / 'everyone' ]]},
            users = { --[[ userId number ]] }
        },
        color = 0x00ff00
    },
    give_key_copy = {
        enabled = false,
        webhook = '',
        mentions = {
            roles = {},
            users = {}
        },
        color = 0x00ff00
    },
    remove_key = {
        enabled = false,
        webhook = '',
        mentions = {
            roles = {},
            users = {}
        },
        color = 0x00ff00
    },
    revoke_all_keys = {
        enabled = false,
        webhook = '',
        mentions = {
            roles = {},
            users = {}
        },
        color = 0x00ff00
    }
}