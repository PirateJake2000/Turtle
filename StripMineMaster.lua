local args = {...}

-- Imports
vector = require("Library.Vector")
ins = require("Library.ins")

-- Arguments
-- 1 -> Turtle count
-- 2 -> Lowest turtle 
-- 3 -> Rows 
-- 4 -> RowLength

-- Setup
local slave = ins(vector(-444,90,-331), vector(-1,0,0))

-- Main
function spawnAndSetupTurtle()
    -- Find turtle in inventory
    for i=1,16 do 
        if turtle.getItemCount(i) > 0 and turtle.getItemDetail(i).name == "computercraft:turtle_normal" then
            turtle.select(i)
            turtle.place()
            return
        end
    end

    -- Run update script on the placed turtle
    peripheral.call("front", "run", "update")
end