if not LOADED then return end

local UI_READY = false
RegisterNUICallback('ready', function(_, _)
    UI_READY = true
end)

Recorder = {}
local isRecording, urls = false, nil

function Recorder.IsRecording()
    return isRecording
end

function Recorder.StartRecording(url, color, reason)
    if not UI_READY or isRecording then return end
    isRecording = true

    local identifiers = lib.callback.await(RESOURCE .. ':server:getIdentifiers', false)
    SendNUIMessage({
        action = 'startRecording',
        params = {
            url = url,
            color = color,
            reason = reason,
            identifiers = identifiers
        }
    })
end

function Recorder.StopRecording()
    if not UI_READY or not isRecording then return end
    SendNUIMessage({
        action = 'stopRecording'
    })
    isRecording = false

    urls = promise:new()
    return Citizen.Await(urls)
end

RegisterNUICallback('recordingStopped', function(data, _)
    if urls then urls:resolve(data) end
end)

local function getRecorder()
    return Recorder
end
exports('getRecorder', getRecorder)

require 'client.admincam'