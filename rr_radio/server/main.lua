if not LOADED then return end
PlayersData, ChannelsData, CentralData = {}, {}, {}

---@UTILS
local function initializePlayer(playerId)
    ---@TODO: Implement state bags
    return {
        channels = {}
    }
end

---@CHAPTER: Channels management
local function joinChannel(channel)
    PlayersData[source] = PlayersData[source] or initializePlayer(source)

    ---@TODO: Implement channel restricted check
    if not true then
        TriggerClientEvent(RESOURCE .. ':client:joinRejected', source, channel)
        LOG(2, '[^2RADIO^7]', ('^5%s^7[^5%s^7] try to join restricted channel ^5%s^7'):format(GetPlayerName(source), source, channel))
        return
    end
    --------------------------------------------

    ChannelsData[channel] = ChannelsData[channel] or {}
    local playerInfo = {
        name = GetPlayerName(source),
        ptt = false,
        coords = nil
    }
    for targetId, _ in pairs(ChannelsData[channel]) do
        TriggerClientEvent(RESOURCE .. ':client:joinedChannel', targetId, channel, source, playerInfo)
    end
    if not table.contains(PlayersData[source].channels, channel) then
        table.insert(PlayersData[source].channels, channel)
    end
    ChannelsData[channel][source] = playerInfo
    TriggerClientEvent(RESOURCE .. ':client:syncChannel', source, channel, ChannelsData[channel])
    LOG(2, '[^2RADIO^7]', ('^5%s^7[^5%s^7] joined channel ^5%s^7'):format(playerInfo.name, source, channel))
end
RegisterNetEvent(RESOURCE .. ':server:joinChannel', joinChannel)

local function leaveChannel(channel)
    local source = source
    if not ChannelsData[channel] or not ChannelsData[channel][source] then return end
    PlayersData[source] = PlayersData[source] or initializePlayer(source)
    for targetId, _ in pairs(ChannelsData[channel]) do
        TriggerClientEvent(RESOURCE .. ':client:leavedChannel', targetId, channel, source)
    end
    if table.contains(PlayersData[source].channels, channel) then
        table.remove(PlayersData[source].channels, table.indexOf(PlayersData[source].channels, channel))
    end
    ChannelsData[channel][source] = nil
    if table.length(ChannelsData[channel]) == 0 then
        ChannelsData[channel] = nil
    end
    LOG(2, '[^2RADIO^7]', ('^5%s^7[^5%s^7] left channel ^5%s^7'):format(GetPlayerName(source), source, channel))
end
RegisterNetEvent(RESOURCE .. ':server:leaveChannel', leaveChannel)

---@CHAPTER: Central management

---@CHAPTER: Talking
local function isChannelBusy(channel)
    for playerId, data in pairs(ChannelsData[channel] or {}) do
        if playerId ~= source and data.ptt then
            return true
        end
    end
    return false
end

RegisterNetEvent(RESOURCE .. ':server:talkingOnChannel', function(channel, state, coords)
    if not ChannelsData[channel] or not ChannelsData[channel][source] then return end
    local playerName = GetPlayerName(source)
    if state and isChannelBusy(channel) then
        TriggerClientEvent(RESOURCE .. ':client:talkingRejected', source)
        LOG(2, '[^2RADIO^7]', ('^5%s^7[^5%s^7] try to talk on busy channel ^5%s^7'):format(playerName, source, channel))
        return
    end
    ChannelsData[channel][source].ptt = state
    ChannelsData[channel][source].coords = coords
    for targetId, _ in pairs(ChannelsData[channel]) do
        if targetId ~= source then
            TriggerClientEvent(RESOURCE .. ':client:talkingOnChannel', targetId, channel, source, state, coords)
        end
    end
    LOG(2, '[^2RADIO^7]', ('^5%s^7[^5%s^7] is now ^5%s ^7on channel ^5%s^7'):format(playerName, source, state and 'talking' or 'silent', channel))
end)

---@CHAPTER: Primary events
AddEventHandler("playerDropped", function()
	local source = source
	if PlayersData[source] then
        local list = { table.unpack(PlayersData[source].channels) }
		for _, channel in ipairs(list) do
            leaveChannel(channel)
        end
		PlayersData[source] = nil
	end
end)

AddEventHandler('playerJoining', function()
	if not PlayersData[source] then
		PlayersData[source] = initializePlayer(source)
	end
end)

Citizen.CreateThread(function()
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        PlayersData[playerId] = initializePlayer(playerId)
    end
end)