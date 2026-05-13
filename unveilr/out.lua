    local fenv = getfenv()
    local v0 = fenv.print
    local v1 = v0("Unable to load hookOp on this file, this file ran as it would without hookOp.")