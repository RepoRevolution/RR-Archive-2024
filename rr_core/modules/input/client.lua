function ESX.HashString(str)
    local hash = joaat(str)
    local input_map = string.format("~INPUT_%s~", string.upper(string.format("%x", hash)))
    input_map = string.gsub(input_map, "FFFFFFFF", "")

    return input_map
end

function ESX.RegisterInput(command_name, label, input_group, key, on_press, on_release)
    lib.addKeybind({
        name = command_name,
        description = label,
        defaultKey = key,
        defaultMapper = input_group,
        onPressed = on_press,
        onReleased = on_release
    })
end