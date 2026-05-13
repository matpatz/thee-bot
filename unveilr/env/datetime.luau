--!nonstrict
--[[
    DateTime — stub for roblox.DateTime replacement.
    Mirrors the Roblox DateTime API surface that main.luau injects
    via `roblox.DateTime = DateTime`.
]]

local DateTime = {}
DateTime.__index = DateTime

function DateTime.now()
    return setmetatable({ UnixTimestamp = os.time(), UnixTimestampMillis = os.time() * 1000 }, DateTime)
end

function DateTime.fromUnixTimestamp(ts)
    return setmetatable({ UnixTimestamp = ts, UnixTimestampMillis = ts * 1000 }, DateTime)
end

function DateTime.fromUnixTimestampMillis(ms)
    return setmetatable({ UnixTimestamp = ms / 1000, UnixTimestampMillis = ms }, DateTime)
end

function DateTime.fromIsoDate(s)
    return DateTime.now()
end

function DateTime:ToIsoDate()
    return os.date("!%Y-%m-%dT%H:%M:%SZ", self.UnixTimestamp)
end

function DateTime:ToUniversalTime()
    local t = os.date("!*t", self.UnixTimestamp)
    return {
        Year = t.year, Month = t.month, Day = t.day,
        Hour = t.hour, Minute = t.min, Second = t.sec,
        Millisecond = 0
    }
end

function DateTime:ToLocalTime()
    return self:ToUniversalTime()
end

function DateTime:FormatUniversalTime(format, locale)
    return os.date("!" .. (format or "%Y-%m-%d %H:%M:%S"), self.UnixTimestamp)
end

function DateTime:FormatLocalTime(format, locale)
    return os.date(format or "%Y-%m-%d %H:%M:%S", self.UnixTimestamp)
end

return DateTime
