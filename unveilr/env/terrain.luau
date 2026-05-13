--!nonstrict
--[[
    terrain.luau — GetTerrainMaterialColor stub.
    Called as: GetTerrainMaterialColor(materialKey)
    Returns a Color3-like table for the given terrain material.
]]

local MaterialColors = {
    ["Grass"]           = { R = 106/255, G = 127/255, B = 63/255  },
    ["Slate"]           = { R = 63/255,  G = 75/255,  B = 80/255  },
    ["Concrete"]        = { R = 127/255, G = 120/255, B = 111/255 },
    ["Brick"]           = { R = 138/255, G = 86/255,  B = 62/255  },
    ["Sand"]            = { R = 198/255, G = 189/255, B = 154/255 },
    ["WoodPlanks"]      = { R = 159/255, G = 114/255, B = 55/255  },
    ["Wood"]            = { R = 159/255, G = 114/255, B = 55/255  },
    ["Ground"]          = { R = 106/255, G = 127/255, B = 63/255  },
    ["SmoothPlastic"]   = { R = 163/255, G = 162/255, B = 165/255 },
    ["Metal"]           = { R = 168/255, G = 168/255, B = 168/255 },
    ["Cobblestone"]     = { R = 132/255, G = 123/255, B = 90/255  },
    ["Ice"]             = { R = 200/255, G = 222/255, B = 240/255 },
    ["Snow"]            = { R = 240/255, G = 244/255, B = 252/255 },
    ["Glacier"]         = { R = 147/255, G = 198/255, B = 207/255 },
    ["Sandstone"]       = { R = 198/255, G = 170/255, B = 109/255 },
    ["Mud"]             = { R = 58/255,  G = 46/255,  B = 36/255  },
    ["Rock"]            = { R = 102/255, G = 100/255, B = 94/255  },
    ["Basalt"]          = { R = 30/255,  G = 30/255,  B = 37/255  },
    ["CrackedLava"]     = { R = 232/255, G = 156/255, B = 74/255  },
    ["Limestone"]       = { R = 210/255, G = 202/255, B = 163/255 },
    ["Pavement"]        = { R = 148/255, G = 148/255, B = 140/255 },
    ["Water"]           = { R = 40/255,  G = 118/255, B = 211/255 },
    ["Air"]             = { R = 0,       G = 0,       B = 0       },
    ["LeafyGrass"]      = { R = 106/255, G = 127/255, B = 63/255  },
}

local function GetTerrainMaterialColor(material : string)
    return MaterialColors[material] or { R = 0, G = 0, B = 0 }
end

return GetTerrainMaterialColor
