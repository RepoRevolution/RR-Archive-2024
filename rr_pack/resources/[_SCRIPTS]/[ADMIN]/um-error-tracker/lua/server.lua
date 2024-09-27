lib.callback.register('um-admin-tracker:server:getConsoleBuffer', function()
    return GetConsoleBuffer()
end)

RegisterCommand('errortracker', function(source)
    if source <= 0 then return end
    TriggerClientEvent('um-admin-tracker:client:errorTracker', source)
end, true)

lib.versionCheck('alp1x/um-error-tracker')