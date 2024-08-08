local args = {...}
-- Imports
vector = require("Library.Vector")
ins = require("Library.ins")

-- Setup
local slave = ins(vector(-2806, 64, 3048), vector(0,0,-1))

-- Main
for k,v in pairs(args) do
    print(k,v)
end