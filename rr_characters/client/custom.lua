local custom = {}

function custom.pauseTimeSync(state)
    if state then
        TriggerEvent('cd_easytime:PauseSync', true, 12)
    else
        TriggerEvent('cd_easytime:PauseSync', false)
    end
end

function custom.relog(coords, charId)
    -- Triggered when player use command relog, you can place here some 3d text to inform other players...
end

return custom