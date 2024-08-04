-- Imports
vector = require("Library.Vector")
ins = require("Library.ins")

-- Setup
local slave = ins(vector(-261,78,-70), vector(0,0,-1))

print(slave.position)

-- Main
-- Turtle --
-- dig forward
-- move forward
-- check up
-- check down
-- turn left
-- check forward
-- turn right
-- turn right
-- check forward
-- turn left

-- if any check is ore then mineVein()
-- then return to tunnel


-- Functions
function mineVein()

end

-- Settings
local startPos = slave.position
local startFacing = slave.facing
local mineDepth = 50

local rows = 8
local rowLength = 32

-- go down to mineDepth
while slave.position.y > mineDepth do
    turtle.digDown()
    slave:down()
end

print("Reached Mine Depth")

local currentRow = 1
--------------------
:: mine ::
--------------------
for i=1,rowLength do
    turtle.dig()
    slave:forward()

    -- Check around for ores
end

if slave.facing == startFacing then
    slave:turnRight()
    turtle.dig()
    slave:forward()
    turtle.dig()
    slave:forward()
    slave:turnRight()
else
    slave:turnLeft()
    turtle.dig()
    slave:forward()
    turtle.dig()
    slave:forward()
    slave:turnLeft()
end

currentRow = currentRow + 1
--------------------
if (currentRow < rows) then goto mine else return end
--------------------
slave:goToDestructive(startPos)
