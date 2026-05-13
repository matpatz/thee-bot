--!nonstrict
--[[
    genv.luau  (ExploitLib)
    Provides exploit / executor global functions and libraries.

    Interface expected by main.luau:
        ExploitLib:setEnv(ctx)           — receives sandbox internals
        ExploitLib:setGlobalEnv(Env)     — receives the final Env table
        ExploitLib.funcs                 — { [funcName] = function }
        ExploitLib.libs                  — { [libName]  = { [key] = value } }
]]

local ExploitLib = {}
ExploitLib.__index = ExploitLib

-- Will be populated by setEnv / setGlobalEnv
local Ctx = {}
local GlobalEnv = {}

function ExploitLib:setEnv(ctx)
    for k, v in next, ctx do
        Ctx[k] = v
    end
end

function ExploitLib:setGlobalEnv(env)
    GlobalEnv = env
end

-- ── funcs: top-level exploit globals ─────────────────────────────────────────
-- Each function here gets added to SecureEnv as a tracked C-closure via Function().
ExploitLib.funcs = {

    -- Identity / executor detection
    identifyexecutor = function()
        return "Unveilr", "1.0"
    end,
    identify_executor = function()
        return "Unveilr", "1.0"
    end,

    -- Thread identity
    getthreadidentity = function()
        return 6
    end,
    get_thread_identity = function()
        return 6
    end,
    setthreadidentity = function(id) end,
    set_thread_identity = function(id) end,

    -- Closures
    isexecutorclosure = function(f)
        return false
    end,
    checkcaller = function()
        return false
    end,
    iscclosure = function(f)
        local info = debug.info(f, "s")
        return info == "[C]"
    end,
    islclosure = function(f)
        local info = debug.info(f, "s")
        return info ~= "[C]"
    end,
    newcclosure = function(f)
        return f  -- best-effort stub
    end,
    clonefunction = function(f)
        -- wrap in a new closure
        return function(...) return f(...) end
    end,

    -- Upvalue manipulation (stubs)
    getupvalue  = function(f, i) end,
    getupvalues = function(f) return {} end,
    setupvalue  = function(f, i, v) end,

    -- Constants (stubs)
    getconstants = function(f) return {} end,
    getconstant  = function(f, i) end,
    setconstant  = function(f, i, v) end,

    -- Proto (stubs)
    getprotos = function(f) return {} end,
    getproto  = function(f, i) return function() end end,

    -- GC / instance lists (stubs)
    getgc           = function(incTables) return {} end,
    getinstances    = function() return {} end,
    getnilinstances = function() return {} end,

    -- Metatable manipulation
    getrawmetatable = function(t)
        return getmetatable(t)
    end,
    setrawmetatable = function(t, mt)
        return setmetatable(t, mt)
    end,
    hookmetamethod  = function(obj, method, hook)
        local mt = getmetatable(obj)
        if not mt then error("no metatable") end
        local old = mt[method]
        mt[method] = hook
        return old
    end,

    -- Hook function
    hookfunction  = function(a, b) return a end,
    replaceclosure = function(a, b) return a end,

    -- namecall method
    getnamecallmethod = function() return nil end,
    setnamecallmethod = function(m) end,

    -- Clipboard
    setclipboard = function(s) end,
    toclipboard  = function(s) end,

    -- Mouse
    mousemoverel = function(x, y) end,
    mousemoveabs = function(x, y) end,
    mouse1click  = function() end,
    mouse2click  = function() end,
    mouse1press  = function() end,
    mouse1release = function() end,
    mouse2press  = function() end,
    mouse2release = function() end,
    keypress     = function(k) end,
    keyrelease   = function(k) end,

    -- Roblox interaction
    fireclickdetector    = function(obj, dist) end,
    fireproximityprompt  = function(obj) end,
    firetouchinterest    = function(part, other, toggle) end,

    -- GUI
    gethui = function()
        return GlobalEnv and GlobalEnv.game
    end,
    sethui = function(gui) end,

    -- Script source / bytecode
    getscriptclosure  = function(s) return function() end end,
    getscriptfunction = function(s) return function() end end,
    getscriptbytecode = function(s) return "" end,
    dumpstring        = function(s) return "" end,
    decompile         = function(s) return "-- decompiled" end,

    -- Teleport
    queue_on_teleport  = function(s) end,
    queueonteleport    = function(s) end,

    -- Misc
    isrbxactive       = function() return true end,
    iswindowactive    = function() return true end,
    getloadedmodules  = function() return {} end,
    getconnections    = function(sig) return {} end,
    getcallbackvalue  = function(obj, cb) end,
    getspecialinfo    = function(f) return {} end,

    -- Protect / unprotect (stubs)
    isreadonly        = function(t) return table.isfrozen(t) end,
    makereadonly      = function(t) table.freeze(t) end,
    makewriteable     = function(t) end,
    protect_gui       = function(gui) end,
    unprotect_gui     = function(gui) end,

    -- getsenv / getrenv stubs
    getsenv = function(s) return {} end,
}

-- ── libs: executor library namespaces ────────────────────────────────────────
ExploitLib.libs = {

    -- Drawing library (all stubs)
    Drawing = {
        new = function(shape)
            local obj = {
                Visible = false,
                Color = {R=1,G=1,B=1},
                Transparency = 1,
                ZIndex = 1,
                Remove = function(self) end,
                Destroy = function(self) end,
            }
            return obj
        end,
        Fonts = { UI=0, System=1, Plex=2, Monospace=3 },
    },
}

return ExploitLib
