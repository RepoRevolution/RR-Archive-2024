if not NUI then return end
NUI.ready = false

RegisterNUICallback('ready', function(_, resultCallback)
    NUI.ready = true
    resultCallback({
        locales = lib.getLocales()
    })
end)

function NUI.closeUI()
    SendNUIMessage({
        action = 'closeUI'
    })
    SetNuiFocus(false, false)
end

RegisterNUICallback('closeUI', function()
    NUI.closeUI()
end)

---@DEBUG
RegisterCommand('radio_join', function(_, args)
    local channel = tonumber(args[1])
    if channel then
        Radio:joinChannel(channel)
    end
end, false)

RegisterCommand('radio_leave', function(_, args)
    local channel = tonumber(args[1])
    if not channel then
        local list = { table.unpack(Radio.channels) }
        for _, channel in ipairs(list) do
            Radio:leaveChannel(channel)
        end
    else
        Radio:leaveChannel(channel)
    end
end, false)

RegisterCommand('radio_check', function()
    LOG(2, json.encode(ChannelsData, { indent = true }), Radio.channels, Radio.currentChannel)
end, false)