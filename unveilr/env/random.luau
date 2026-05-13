--!nonstrict
--[[
    RandomLib — stub for roblox.Random replacement.
    Mirrors the Roblox Random API surface that main.luau injects
    via `roblox.Random = RandomLib`.
]]

local Random = {}
Random.__index = Random

function Random.new(seed)
    return setmetatable({ _r = seed and math.random or math.random }, Random)
end

function Random:NextNumber(min, max)
    if min and max then return min + math.random() * (max - min) end
    if min then return math.random() * min end
    return math.random()
end

function Random:NextInteger(min, max)
    return math.random(min, max)
end

function Random:NextUnitVector()
    -- approximate unit vector
    local x, y, z = math.random()-0.5, math.random()-0.5, math.random()-0.5
    local len = math.sqrt(x*x + y*y + z*z)
    if len == 0 then return {X=1,Y=0,Z=0} end
    return {X=x/len, Y=y/len, Z=z/len}
end

function Random:Clone()
    return Random.new()
end

return Random
