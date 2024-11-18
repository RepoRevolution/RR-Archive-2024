ESX.Math = {}

function ESX.Math.Round(value, numDecimalPlaces)
    if not numDecimalPlaces then return math.floor(value + 0.5) end

    local power = 10 ^ numDecimalPlaces

    return math.floor((value * power) + 0.5) / (power)
end
ESX.Round = ESX.Math.Round

-- credit http://richard.warburton.it
function ESX.Math.GroupDigits(value)
    local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')

    return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. ','):reverse()) .. right
end

function ESX.Math.Trim(value)
    if not value then return end

    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

function ESX.Math.Random(length)
    if type(length) ~= 'number' or length <= 0 then return end

    local minRange = 10 ^ (length - 1)
    local maxRange = (10 ^ length) - 1

    return math.random(minRange, maxRange)
end
ESX.GetRandomNumber = ESX.Math.Random
