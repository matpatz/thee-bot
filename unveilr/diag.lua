-- Diagnostic exploit to trace what each step returns inside the sandbox

-- Step 1: get an untracked table
local t = table.pack()
print("table.pack() type:", type(t))
print("table.pack() n:", t.n)

-- Step 2: create the metatable
local mt = { __index = function(_, key)
    print("__index called with key:", key, type(key))
    return nil
end }

-- Step 3: call setmetatable
local result = setmetatable(t, mt)
print("setmetatable returned:", type(result), result == t)

-- Step 4: try accessing a key to trigger __index
print("accessing t.test:", t.test)
print("done")
