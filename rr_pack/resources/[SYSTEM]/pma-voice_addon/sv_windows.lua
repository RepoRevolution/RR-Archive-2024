RegisterNetEvent('pma-voice_addon:server:rollWindows', function(netId, windowId, state)
    TriggerClientEvent('pma-voice_addon:client:rollWindows', -1, netId, windowId, state)
end)