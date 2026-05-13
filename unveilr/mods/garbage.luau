--!nonstrict
--[[
    Garbage-string detection utility.
    IsGarbageString(s) → true if the string looks like obfuscation garbage
    SetGarbageData(ctx) → receives context (DoIgnore table, Strings table) 
                          so the heuristic can skip known-good strings.
]]

local Context = { DoIgnore = {}, Strings = {} }

local NON_ENGLISH = "[\0-\31\189-\255{}]"

local function IsGarbageString(s : string) : boolean
    if typeof(s) ~= "string" then return false end
    if Context.DoIgnore and Context.DoIgnore[s] then return false end
    if Context.Strings and Context.Strings[s] then return false end

    -- Heuristics: high proportion of non-printable / non-ASCII bytes
    -- or a very short string that is all uppercase hex-like chars
    if #s == 0 then return false end

    if s:find(NON_ENGLISH) then return true end

    -- count non-readable chars (outside printable ASCII range 32-126)
    local bad = 0
    for i = 1, #s do
        local b = s:byte(i)
        if b < 32 or b > 126 then bad += 1 end
    end
    if bad / #s > 0.3 then return true end

    -- very long random-looking identifier (no vowels, all mixed case)
    if #s > 20 then
        local vowels = select(2, s:gsub("[aeiouAEIOU]", ""))
        if vowels == 0 then return true end
    end

    return false
end

local function SetGarbageData(ctx : { [string]: any })
    if ctx.DoIgnore then Context.DoIgnore = ctx.DoIgnore end
    if ctx.Strings   then Context.Strings  = ctx.Strings  end
end

return { IsGarbageString, SetGarbageData }
