if not LOADED then return end
Client, NUI = {}, {}
Client.source = GetPlayerServerId(PlayerId())

---@UTILS: All utils functions
function Client.playGameSound(data, networked)
    local coords = data.coords or GetEntityCoords(cache.ped)
    PlaySoundFromCoord(-1, data.sound, coords.x, coords.y, coords.z, data.dict, networked, 1.5, false)
end

function Client.playUISound(sound)
    SendNUIMessage({ action = 'sound', type = sound })
end

local disableSubmixReset = {}
function Client.toggleVoice(playerId, state, submix)
    if state then
        disableSubmixReset[playerId] = true
        if submix then MumbleSetSubmixForServerId(playerId, submix)
        else MumbleSetSubmixForServerId(playerId, Signal.default_submix) end
    else
        disableSubmixReset[playerId] = nil
        Citizen.SetTimeout(350, function()
            if not disableSubmixReset[playerId] then
                MumbleSetSubmixForServerId(playerId, -1)
            end
        end)
    end
    exports['pma-voice']:setTalkingOnRadio(playerId, state)
end

function Client.radioActive(state)
    exports['pma-voice']:usingRadio(state)
    TriggerEvent("pma-voice:radioActive", state)
    LocalPlayer.state:set("radioActive", state, true);
end

---@CHAPTER: Radio management
Radio = {
    enabled = false,
    channels = {},
    currentChannel = 0,
    PTT = false
}
ChannelsData = {}

function Radio:joinChannel(channel)
    channel = tonumber(channel)
    if not channel or channel < 1 then return warn('Invalid channel') end
    
    ---@TODO: Implement channel restricted check

    if not table.contains(self.channels, channel) then
        table.insert(self.channels, channel)
        self.currentChannel = channel
        TriggerServerEvent(RESOURCE .. ':server:joinChannel', channel)
    elseif self.currentChannel ~= channel then
        self.currentChannel = channel
    end
    exports['pma-voice']:updateUI(true, self.currentChannel)
    Client.playGameSound({ sound = 'Radio_On', dict = 'TAXI_SOUNDS' }, true)
end

RegisterNetEvent(RESOURCE .. ':client:joinRejected', function(channel)
    if table.contains(Radio.channels, channel) then
        table.remove(Radio.channels, table.indexOf(Radio.channels, channel))
        if Radio.currentChannel == channel then
            Radio.currentChannel = Radio.channels[next(Radio.channels)] or 0
            exports['pma-voice']:updateUI(Radio.currentChannel ~= 0, Radio.currentChannel)
        end
    end
end)

RegisterNetEvent(RESOURCE .. ':client:joinedChannel', function(channel, playerId, playerInfo)
    ChannelsData[channel] = ChannelsData[channel] or {}
    ChannelsData[channel][playerId] = playerInfo
    if Radio.PTT then
        exports['pma-voice']:updateVoiceTargets(ChannelsData[channel])
    end
end)

RegisterNetEvent(RESOURCE .. ':client:syncChannel', function(channel, channelData)
    ChannelsData[channel] = channelData
    for playerId, data in pairs(ChannelsData[channel]) do
        if playerId ~= Client.source then
            local connection, submix = data.ptt, nil
            if connection then connection, submix = Signal:connect(playerId, data.coords) end
            Client.toggleVoice(playerId, connection, submix)
        end
    end
end)

function Radio:leaveChannel(channel)
    channel = tonumber(channel)
    if not channel or channel < 1 then return warn('Invalid channel') end
    if not table.contains(self.channels, channel) then warn('Not in channel') return end
    table.remove(self.channels, table.indexOf(self.channels, channel))
    if self.currentChannel == channel then
        self.currentChannel = self.channels[next(self.channels)] or 0
        exports['pma-voice']:updateUI(self.currentChannel ~= 0, self.currentChannel)
    end
    TriggerServerEvent(RESOURCE .. ':server:leaveChannel', channel)
    Client.playGameSound({ sound = 'Radio_Off', dict = 'TAXI_SOUNDS' }, true)
end

RegisterNetEvent(RESOURCE .. ':client:leavedChannel', function(channel, playerId)
    if not ChannelsData[channel] or not ChannelsData[channel][playerId] then return end
    if playerId == Client.source then
        for targetId, _ in pairs(ChannelsData[channel]) do
            if targetId ~= Client.source then
                Client.toggleVoice(targetId, false)
            end
        end
        ChannelsData[channel] = nil
        exports['pma-voice']:updateVoiceTargets({})
    else
        Client.toggleVoice(playerId, false)
        ChannelsData[channel][playerId] = nil
        if Radio.PTT then
            exports['pma-voice']:updateVoiceTargets(ChannelsData[channel])
        end
    end
end)

---@CHAPTER: Central management
Central = {
    array = {},
    current = nil
}

Citizen.CreateThread(function()
    for _, data in ipairs(Config.Centrals) do
        local zone = lib.zones.box({
            name = data.name,
            coords = data.zone.coords,
            size = data.zone.size,
            rotation = data.zone.rotation,
            debug = Config.Debug,
            onEnter = function(self)
                Central.current = self.id
                exports['pma-voice']:updateUI(true, self.name)
                LOG(2, ('[^2CENTRAL^7] You are in ^5%s^7'):format(self.name))
            end,
            onExit = function(self)
                if Central.current == self.id then
                    Central.current = nil
                    exports['pma-voice']:updateUI(Radio.currentChannel ~= 0, Radio.currentChannel)
                    LOG(2, ('[^2CENTRAL^7] You left ^5%s^7'):format(self.name))
                end
            end,
        })
        Central.array[zone.id] = data
    end
end)

---@CHAPTER: Signal management
Signal = {
    default_submix = 0,
    submixes = {}
}

function Signal:connect(playerId, coords)
    local connection, submix, submixName, distance = false, nil, nil, 0.0
    if coords then
        distance = #(coords - GetEntityCoords(cache.ped))
        local lastDistance = math.huge
        for _, data in ipairs(Signal.submixes) do
            if distance <= data.distance and data.distance < lastDistance then
                connection = true
                submix = data.id
                submixName = data.name
                lastDistance = data.distance
            end
        end
    end
    if connection then
        LOG(2, ('[^2SIGNAL^7] Player ^5%s^7 is talking to you from distance ^5%s^7 using submix ^5%s^7'):format(playerId, distance, submixName))
    else
        LOG(2, ('[^2SIGNAL^7] Player ^5%s^7 is trying to talk to you from distance ^5%s^7, but is too far'):format(playerId, distance))
    end
    return connection, submix
end

Citizen.CreateThread(function()
    local submix = CreateAudioSubmix('rr_radio')
    SetAudioSubmixEffectRadioFx(submix, 0)
    SetAudioSubmixEffectParamInt(submix, 0, GetHashKey('default'), 1)
    SetAudioSubmixOutputVolumes(submix, 0, 1.0, 0.25, 0.0, 0.0, 1.0, 1.0)
    AddAudioSubmixOutput(submix, 0)
    Signal.default_submix = submix

    for _, data in ipairs(Config.Signal.submixes) do
        submix = CreateAudioSubmix(data.submix_name)
        SetAudioSubmixEffectRadioFx(submix, 0)
        SetAudioSubmixEffectParamInt(submix, 0, GetHashKey('default'), 1)
        SetAudioSubmixEffectParamFloat(
            submix, 0, GetHashKey('freq_low'),
            data.submix_data.freq_low or 389.0)
        SetAudioSubmixEffectParamFloat(
            submix, 0, GetHashKey('freq_hi'),
            data.submix_data.freq_hi or 3248.0)
        SetAudioSubmixEffectParamFloat(
            submix, 0, GetHashKey('fudge'),
            data.submix_data.fudge or 0.0)
        SetAudioSubmixEffectParamFloat(
            submix, 0, GetHashKey('rm_mod_freq'),
            data.submix_data.rm_mod_freq or 0.0)
        SetAudioSubmixEffectParamFloat(
            submix, 0, GetHashKey('rm_mix'),
            data.submix_data.rm_mix or 0.16)
        SetAudioSubmixEffectParamFloat(
            submix, 0, GetHashKey('o_freq_lo'),
            data.submix_data.o_freq_lo or 348.0)
        SetAudioSubmixEffectParamFloat(
            submix, 0, GetHashKey('o_freq_hi'),
            data.submix_data.o_freq_hi or 4900.0)
        SetAudioSubmixOutputVolumes(
            submix, 0,
            1.0 --[[ frontLeftVolume ]], 0.25 --[[ frontRightVolume ]],
            0.0 --[[ rearLeftVolume ]], 0.0 --[[ rearRightVolume ]],
            1.0 --[[ channel5Volume ]], 1.0 --[[ channel6Volume ]]
        )
        AddAudioSubmixOutput(submix, 0)

        table.insert(Signal.submixes, {
            name = data.submix_name,
            distance = data.max_distance,
            id = submix
        })
    end
end)

---@CHAPTER: Talking
local function isChannelBusy(channel)
    for playerId, data in pairs(ChannelsData[channel] or {}) do
        if playerId ~= Client.source and data.ptt then
            return true
        end
    end
    return false
end

local ptt, timeout = false, false
lib.addKeybind({
    name = 'radio_talk',
    description = '[PMA] Talk over radio',
    defaultKey = 'CAPITAL',
    onPressed = function(self)
        if not timeout and not Radio.PTT and Radio.currentChannel > 0 then
            ptt, timeout = true, true
            Citizen.SetTimeout(1000, function() timeout = false end)
            local channel = Radio.currentChannel
            if not isChannelBusy(channel) and ptt then
                Radio.PTT = true
                exports['pma-voice']:updateVoiceTargets(ChannelsData[channel] or {})
                local coords = GetEntityCoords(cache.ped)
                TriggerServerEvent(RESOURCE .. ':server:talkingOnChannel', channel, true, coords)
                Citizen.CreateThread(function()
                    Client.playUISound('start_talk')
                    Client.radioActive(true)
                    while ptt do
                        if Radio.currentChannel ~= channel then break end
                        SetControlNormal(0, 249, 1.0)
                        SetControlNormal(1, 249, 1.0)
                        SetControlNormal(2, 249, 1.0)
                        Citizen.Wait(0)
                    end
                    ExecuteCommand("-radio_talk")
                end)
            else Client.playUISound('busy') end
        end
    end,
    onReleased = function(self)
        ptt = false
        if Radio.currentChannel > 0 and Radio.PTT then
            Radio.PTT = false
            Client.radioActive(false)
            Client.playUISound('stop_talk')
            TriggerServerEvent(RESOURCE .. ':server:talkingOnChannel', Radio.currentChannel, false)
        end
    end
})

RegisterNetEvent(RESOURCE .. ':client:talkingRejected', function()
    ptt = false
    Radio.PTT = false
    Client.radioActive(false)
    Client.playUISound('busy')
end)

RegisterNetEvent(RESOURCE .. ':client:talkingOnChannel', function(channel, playerId, state, coords)
    if not ChannelsData[channel] or not ChannelsData[channel][playerId] then return end
    ChannelsData[channel][playerId].ptt = state
    ChannelsData[channel][playerId].coords = coords
    local connection, submix = state, nil
    if state then connection, submix = Signal:connect(playerId, coords) end
    Client.toggleVoice(playerId, connection, submix)
    if connection then Client.playUISound('start_talk')
    else Client.playUISound('stop_talk') end
end)

---@CHAPTER: Keybinds
lib.addKeybind({
    name = 'radio_next_channel',
    description = '[PMA] (LAlt+) Next connected channel',
    defaultKey = 'DOWN',
    onPressed = function(self)
        if Radio.currentChannel > 0 and #Radio.channels > 1 then
            if IsControlPressed(0, 19) then
                local index = (table.indexOf(Radio.channels, Radio.currentChannel) + 1)
                if index > #Radio.channels then index = 1 end
                Radio:joinChannel(Radio.channels[index])
            end
        end
    end
})

lib.addKeybind({
    name = 'radio_connect_next_channel',
    description = '[PMA] (LAlt+) Next radio channel',
    defaultKey = 'RIGHT',
    onPressed = function()
        if Radio.currentChannel > 0 then
            if IsControlPressed(0, 19) then
                local nextChannel = Radio.currentChannel + 1
                Radio:leaveChannel(Radio.currentChannel)
                ---@TODO: Implement channel max check
                if nextChannel < 99999 then
                    Radio:joinChannel(nextChannel)
                end
            end
        end
    end
})

lib.addKeybind({
    name = 'radio_connect_prev_channel',
    description = '[PMA] (LAlt+) Previous radio channel',
    defaultKey = 'LEFT',
    onPressed = function()
        if Radio.currentChannel > 0 then
            if IsControlPressed(0, 19) then
                local nextChannel = Radio.currentChannel - 1
                Radio:leaveChannel(Radio.currentChannel)
                if nextChannel > 0 then
                    Radio:joinChannel(nextChannel)
                end
            end
        end
    end
})

---@CHAPTER: Primary events
AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName == 'pma-voice' then
        exports['pma-voice']:updateUI(Radio.currentChannel ~= 0, Radio.currentChannel)
    end
end)