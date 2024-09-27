if not LOADED then return end
--
local function getInflation()
    return lib.callback.await(RESOURCE .. ':server:getInflation', false, GetInvokingResource())
end
exports('getInflation', getInflation)

RegisterNUICallback('getInflation', function (_, resultCallback)
    local inflation = getInflation()
    resultCallback(inflation)
end)

local function getPrice(price)
    return lib.callback.await(RESOURCE .. ':server:getPrice', false, price, GetInvokingResource())
end
exports('getPrice', getPrice)

RegisterNUICallback('getInflation', function (price, resultCallback)
    price = getPrice(price)
    resultCallback(price)
end)