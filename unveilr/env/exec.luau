--!nonstrict
--[[
    ExecutorEnvironment: maps executor/exploit function names to their 
    common aliases.  Used by IsExecutor() to detect which executor a 
    script was likely written for.
    Structure: { [executorName] = { "funcname1", "funcname2", ... } }
]]

return {
    Synapse = {
        "syn_check", "syn_protect_gui", "syn_queue_on_teleport",
        "syn_get_thread_identity", "syn_set_thread_identity"
    },
    ScriptWare = {
        "sw_check", "checkcaller", "getscriptbytecode"
    },
    KRNL = {
        "KRNL_LOADED", "krnl_check"
    },
    Oxygen = {
        "oxygen_check"
    },
    Fluxus = {
        "fluxus_check"
    },
    Generic = {
        "getgenv", "getrenv", "getrawmetatable", "setrawmetatable",
        "hookfunction", "hookmetamethod", "newcclosure",
        "getnamecallmethod", "setnamecallmethod",
        "isexecutorclosure", "iscclosure", "islclosure",
        "clonefunction", "getupvalues", "getupvalue", "setupvalue",
        "getgc", "getinstances", "getnilinstances",
        "fireclickdetector", "fireproximityprompt",
        "readfile", "writefile", "appendfile", "listfiles", "isfile", "isfolder",
        "makefolder", "delfolder", "delfile",
        "request", "http_request", "http.request",
        "loadstring", "loadfile",
        "Drawing", "cleardrawcache",
        "queue_on_teleport", "queueonteleport",
        "get_thread_identity", "set_thread_identity",
        "getthreadidentity", "setthreadidentity",
        "getscriptclosure", "getscriptfunction",
        "decompile", "dumpstring",
        "setclipboard", "toclipboard",
        "identify_executor", "identifyexecutor",
        "gethiddenproperty", "sethiddenproperty",
        "sethui", "gethui",
        "mousemoverel", "mousemoveabs",
        "mouse1click", "mouse2click",
        "isrbxactive",
    }
}
