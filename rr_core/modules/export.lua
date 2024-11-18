local function esx(name, cb)
    AddEventHandler(('__cfx_export_es_extended_%s'):format(name), function(setCallback)
        setCallback(cb)
    end)
end

local function qb(name, cb)
    AddEventHandler(('__cfx_export_qb-core_%s'):format(name), function(setCallback)
        setCallback(cb)
    end)
end

return {
    createESX = esx,
    createQB = qb
}
