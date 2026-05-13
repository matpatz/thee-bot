--!nonstrict
--[[
    hookOpButNotReally.luau
    Called by lute.exe when hookOp is disabled.
    Args: [1]=thisScript [2]=inputFile [3]=outputFile [4]=callId 
          [5]=constants [6]=inf_loops [7]=WHILE_LIMIT

    Just passes the source through unchanged — no instrumentation.
    The sandbox Env.__index still routes all global lookups to SecureEnv,
    so the basic sandbox remains active even without call-level wrapping.
]]

local process = require("@lune/process")
local fs      = require("@lune/fs")

local args       = process.args
local inputFile  = args[2]
local outputFile = args[3]

local source = fs.readFile(inputFile)
fs.writeFile(outputFile, source)
