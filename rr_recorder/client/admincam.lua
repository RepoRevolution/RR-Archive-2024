if not Config.AdminCam.enabled or not Config.AdminCam.url then return end

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        if IsPedArmed(cache.ped, 2 | 4) then
            Recorder.StartRecording(Config.AdminCam.url, 0x00ffdd, 'Admin Cam: Visible weapon')
        elseif Recorder.IsRecording() then
            local result = Recorder.StopRecording()
            LOG(2, json.encode(result))
        end
        Citizen.Wait(sleep)
    end
end)