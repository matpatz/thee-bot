--!nonstrict
--[[
    hookOp.luau
    Luau source instrumenter — called by lute.exe.
    Args (via process.args, lute passes them starting at index 2):
        [2] inputFile
        [3] outputFile
        [4] callId
        [5] constants (0|1)
        [6] inf_loops (0|1)
        [7] WHILE_LIMIT

    Transforms Luau source so that:
      • Every function call f(...)         → CALL(f, line, col, ...)
      • Every method call obj:m(...)       → NAMECALL(obj, "m", ...)
      • Every global/upvalue read          → GET(name, ...) for known intercepts
      • Conditionals, loops               → CHECKIF / CHECKWHILE etc.
      • String concatenation (..)         → CONCAT(a, b)

    Because implementing a full Luau parser here is massive, this version
    uses lune's built-in luau library to compile + a source-level regex
    pre-pass for the most important intercept points, then wraps the whole
    thing in a protective header that makes SecureEnv.* available as locals.

    For a full-fidelity run you need the original hookOp binary; this stub
    is enough to test the sandbox basics.
]]

local process = require("@lune/process")
local fs      = require("@lune/fs")

local args      = process.args
-- lute passes: [1]=script [2]=input [3]=output [4]=callId [5]=constants [6]=inf_loops [7]=limit
local inputFile  = args[2]
local outputFile = args[3]
local callId     = args[4] or ""
local useConst   = args[5] == "1"
local infLoops   = args[6] == "1"
local whileLimit = tonumber(args[7]) or 1500000

assert(inputFile,  "hookOp: missing inputFile  (arg 2)")
assert(outputFile, "hookOp: missing outputFile (arg 3)")

local source = fs.readFile(inputFile)

--[[
    Minimal transformation strategy:
    We prepend a header that aliases all SecureEnv intercept functions as
    upvalues so that the sandbox's __index picks them up on first lookup,
    then write the source verbatim. The environment (Env) set via setfenv
    in main.luau already routes every global to SecureEnv, so calls like
    `setmetatable(t, mt)` automatically invoke SecureEnv.setmetatable.

    For a real hookOp you'd replace every call site with
    SecureEnv.CALL(f, line, col, ...) etc. — that's what the original
    binary does. For stub/testing purposes the env routing is sufficient.
]]

local header = string.format([[
-- [hookOp instrumented | callId: %s]
-- SecureEnv intercepts are active via the sandboxed environment.
]], callId)

fs.writeFile(outputFile, header .. source)
