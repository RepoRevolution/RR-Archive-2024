---@diagnostic disable: inject-field
local Framework = {}
local playerData, playerLoaded = nil, false

function Framework.IsPlayerLoaded()
    return playerLoaded
end

if FRAMEWORK == 'ESX' then
    RegisterNetEvent('esx:playerLoaded', function(xPlayer)
        playerData = xPlayer
        playerLoaded = true
    end)
    
    RegisterNetEvent('esx:onPlayerLogout', function()
        playerData = nil
        playerLoaded = false
    end)

    RegisterNetEvent('esx:setJob', function(job)
        if playerLoaded then
            playerData.job = job
        end
    end)

    AddEventHandler('onResourceStart', function(resourceName)
        if RESOURCE ~= resourceName then return end
        playerData = ESX.GetPlayerData()
        if playerData.job then playerLoaded = true end
    end)

    function Framework.getJob()
        if not playerData then return nil end
        return playerData.job.name
    end

    function Framework.Trim(string)
        return ESX.Math.Trim(string)
    end
elseif FRAMEWORK == 'QB' then
    return nil
-- make your own custom framework here
elseif FRAMEWORK == 'custom' then
    return nil
end

return Framework