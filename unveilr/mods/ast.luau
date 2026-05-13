--!nonstrict
--[[
    AST library for unveilr/main.luau
    Reconstructed from usage patterns in main.luau.

    Every node is a table: { kind = string, data = { ... } }
    Blocks have:  { kind = "block", data = { statements = { ... } } }
]]

local insert = table.insert
local concat = table.concat
local format = string.format
local rep    = string.rep

-- ── sentinel ────────────────────────────────────────────────────────────────
local AST_KEY = {}   -- unique key to mark AST nodes

local function node(kind, data)
    local n = { kind = kind, data = data }
    n[AST_KEY] = true
    return n
end

-- ── Ast namespace ────────────────────────────────────────────────────────────
local Ast = {}

function Ast.IsAst(v)
    return type(v) == "table" and v[AST_KEY] == true
end

-- ── Leaf constructors ────────────────────────────────────────────────────────
function Ast.Variable(name)
    return node("variable", { name = tostring(name) })
end

function Ast.Number(n)
    return node("number", { value = n })
end

function Ast.String(s)
    return node("string", { value = s })
end

function Ast.Boolean(b)
    return node("boolean", { value = b })
end

function Ast.Nil()
    return node("nil", {})
end

function Ast.RawText(s)
    return node("rawtext", { value = s })
end

-- ── Expression constructors ──────────────────────────────────────────────────
function Ast.Index(base, key)
    return node("index", { base = base, key = key })
end

function Ast.BinaryOp(left, op, right)
    return node("binop", { left = left, op = op, right = right })
end

function Ast.UnaryOp(operand, op)
    return node("unop", { operand = operand, op = op })
end

function Ast.Group(expr)
    return node("group", { expr = expr })
end

function Ast.FunctionCall(func, args)
    return node("call", { func = func, args = args or {} })
end

function Ast.Namecall(base, method, args)
    return node("namecall", { base = base, method = method, args = args or {} })
end

function Ast.ArgList(args)
    return node("arglist", { args = args or {} })
end

function Ast.InterpolatedString(...)
    return node("interpolated", { parts = { ... } })
end

function Ast.Table(entries)
    -- entries can be: { node, node, ... }  or  { { key=node, value=node }, ... }
    return node("table", { entries = entries or {} })
end

-- ── Block & statement constructors ───────────────────────────────────────────
function Ast.new()
    return node("block", { statements = {} })
end

function Ast.Block(stmts)
    return node("block", { statements = stmts or {} })
end

function Ast.addStatement(block, stmt)
    if stmt == nil then return end
    insert(block.data.statements, stmt)
end

function Ast.Assign(targets, values, isStatement)
    return node("assign", { vars = targets, values = values, isStatement = isStatement })
end

function Ast.Return(values)
    return node("return", { values = values })
end

function Ast.Function(params, body)
    return node("function", { params = params or {}, body = body })
end

function Ast.End(label)
    return node("end", { label = label })
end

-- ── Control flow ─────────────────────────────────────────────────────────────
function Ast.IfStat(condition, thenBlock, elseBlock)
    return node("if", { condition = condition, thenBlock = thenBlock, elseBlock = elseBlock })
end

function Ast.WhileLoop(condition, body)
    return node("while", { condition = condition, body = body })
end

function Ast.ForNum(var, from, to, step, body)
    return node("fornum", { var = var, from = from, to = to, step = step, body = body })
end

function Ast.ForPrep(i, v, iter, id)
    -- generic for-in loop header (FORPREP opcode style)
    return node("forprep", { i = i, v = v, iter = iter, id = id })
end

-- ── Comment variants ─────────────────────────────────────────────────────────
-- Comment      = stripped by Minify when minifying
-- PermaComment = always preserved
-- NonOptionalComment = always preserved, may carry extra node
function Ast.Comment(content)
    return node("comment", { content = content })
end

function Ast.PermaComment(...)
    return node("permacomment", { parts = { ... } })
end

function Ast.NonOptionalComment(content, extra)
    return node("nonoptcomment", { content = content, extra = extra })
end

-- ── Stringify ────────────────────────────────────────────────────────────────
local Stringify  -- forward decl

local function StringifyList(list, sep)
    local parts = {}
    for _, v in ipairs(list) do
        insert(parts, Stringify(v))
    end
    return concat(parts, sep or ", ")
end

local function escape(s)
    return s:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\0", "\\0")
end

Stringify = function(n, indent)
    if n == nil then return "nil" end
    indent = indent or 0
    local pad = rep("    ", indent)

    local k = n.kind
    local d = n.data

    if k == "variable" then
        return d.name

    elseif k == "number" then
        local v = d.value
        if v == math.huge then return "math.huge"
        elseif v == -math.huge then return "-math.huge"
        elseif v ~= v then return "0/0"  -- NaN
        end
        local s = tostring(v)
        return s

    elseif k == "string" then
        return '"' .. escape(tostring(d.value)) .. '"'

    elseif k == "boolean" then
        return tostring(d.value)

    elseif k == "nil" then
        return "nil"

    elseif k == "rawtext" then
        return d.value

    elseif k == "index" then
        local base = Stringify(d.base)
        local key  = d.key
        if key.kind == "string" and key.data.value:match("^[%a_][%w_]*$") then
            return base .. "." .. key.data.value
        end
        return base .. "[" .. Stringify(key) .. "]"

    elseif k == "binop" then
        return Stringify(d.left) .. " " .. d.op .. " " .. Stringify(d.right)

    elseif k == "unop" then
        local op = d.op
        if op == "not" then
            return "not " .. Stringify(d.operand)
        end
        return op .. Stringify(d.operand)

    elseif k == "group" then
        return "(" .. Stringify(d.expr) .. ")"

    elseif k == "call" then
        return Stringify(d.func) .. "(" .. StringifyList(d.args) .. ")"

    elseif k == "namecall" then
        return Stringify(d.base) .. ":" .. Stringify(d.method) .. "(" .. StringifyList(d.args) .. ")"

    elseif k == "arglist" then
        return StringifyList(d.args)

    elseif k == "interpolated" then
        -- `part1{expr}part2` → build as concat for simplicity
        local parts = {}
        for _, p in ipairs(d.parts) do
            insert(parts, Stringify(p))
        end
        return "(" .. concat(parts, " .. ") .. ")"

    elseif k == "table" then
        local entries = d.entries
        if #entries == 0 then return "{}" end
        local parts = {}
        for _, e in ipairs(entries) do
            if Ast.IsAst(e) then
                insert(parts, Stringify(e))
            elseif e.key then
                local ks = Stringify(e.key)
                local ev = e.val or e.value
                if e.key.kind == "string" and e.key.data.value:match("^[%a_][%w_]*$") then
                    insert(parts, e.key.data.value .. " = " .. Stringify(ev))
                else
                    insert(parts, "[" .. ks .. "] = " .. Stringify(ev))
                end
            else
                insert(parts, Stringify(e.value))
            end
        end
        return "{ " .. concat(parts, ", ") .. " }"

    elseif k == "block" then
        local lines = {}
        for _, stmt in ipairs(d.statements) do
            if stmt ~= nil then
                local s = Stringify(stmt, indent + 1)
                if s and s ~= "" then
                    insert(lines, pad .. "    " .. s)
                end
            end
        end
        return concat(lines, "\n")

    elseif k == "assign" then
        local lhs = StringifyList(d.vars or {})
        local rhs = StringifyList(d.values or {})
        if d.isStatement then
            return lhs .. " = " .. rhs
        end
        return "local " .. lhs .. " = " .. rhs

    elseif k == "return" then
        if not d.values or #d.values == 0 then
            return "return"
        end
        return "return " .. StringifyList(d.values)

    elseif k == "function" then
        local params = concat(d.params or {}, ", ")
        local body = Stringify(d.body, indent)
        return "function(" .. params .. ")\n" .. body .. "\n" .. pad .. "end"

    elseif k == "end" then
        return "end" .. (d.label and " --[[ " .. tostring(d.label) .. " ]]" or "")

    elseif k == "if" then
        local s = "if " .. Stringify(d.condition) .. " then\n"
        s = s .. Stringify(d.thenBlock, indent) .. "\n"
        if d.elseBlock then
            s = s .. pad .. "else\n"
            s = s .. Stringify(d.elseBlock, indent) .. "\n"
        end
        s = s .. pad .. "end"
        return s

    elseif k == "while" then
        return "while " .. Stringify(d.condition) .. " do\n"
            .. Stringify(d.body, indent) .. "\n"
            .. pad .. "end"

    elseif k == "fornum" then
        local step = d.step and (", " .. Stringify(d.step)) or ""
        return "for " .. tostring(d.var) .. " = " .. Stringify(d.from)
            .. ", " .. Stringify(d.to) .. step .. " do\n"
            .. Stringify(d.body, indent) .. "\n"
            .. pad .. "end"

    elseif k == "forprep" then
        return "for " .. Stringify(d.i) .. ", " .. Stringify(d.v)
            .. " in next, " .. Stringify(d.iter) .. " do"

    elseif k == "comment" then
        return "--[[ " .. Stringify(d.content) .. " ]]"

    elseif k == "permacomment" then
        local ps = {}
        for _, p in ipairs(d.parts or {}) do insert(ps, Stringify(p)) end
        return "-- " .. concat(ps, " ")

    elseif k == "nonoptcomment" then
        local s = "--[[ " .. Stringify(d.content)
        if d.extra then s = s .. " " .. Stringify(d.extra) end
        return s .. " ]]"

    else
        return "-- [unknown ast node: " .. tostring(k) .. "]"
    end
end

-- ── Minify ───────────────────────────────────────────────────────────────────
-- When `doMinify` is true, strips comment nodes.
-- Returns a new tree (shallow copy of non-comment nodes).
local function MinifyBlock(blk, doMinify)
    if not blk or blk.kind ~= "block" then return blk end
    local newStmts = {}
    for _, stmt in ipairs(blk.data.statements) do
        if stmt == nil then
            -- skip nils
        elseif doMinify and (stmt.kind == "comment") then
            -- strip regular comments when minifying
        else
            insert(newStmts, stmt)
        end
    end
    return node("block", { statements = newStmts })
end

local function Minify(ast, doMinify)
    return MinifyBlock(ast, doMinify)
end

-- ── Module-level globals ─────────────────────────────────────────────────────
local Globals = {}

local function SetGlobal(name, value)
    Globals[name] = value
end

-- ── Public API ────────────────────────────────────────────────────────────────
local AstLib = {
    Ast        = Ast,
    Stringify  = function(ast) return Stringify(ast, 0) end,
    Minify     = Minify,
    SetGlobal  = SetGlobal,
    GetGlobal  = function(name) return Globals[name] end,
    ExprToCode = function(node, indent) return Stringify(node, indent or 0) end,
}

return AstLib
