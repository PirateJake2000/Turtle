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

function mine()
    turtle.dig()
    slave:forward()

    local blockUp = turtle.inspectUp()
    local blockDown = turtle.inspectDown()
    
    slave:turnLeft()
    local blockLeft = turtle.inspect()
    slave:turnRight()

    slave:turnRight()
    local blockRight = turtle.inspect()
    slave:turnLeft()

    return {
        up = blockUp,
        down = blockDown,
        left = blockLeft,
        right = blockRight
    }
end

-- Settings
local startPos = slave.position
local startFacing = slave.facing
local mineDepth = 30

local rows = 4
local rowLength = 16

-- go down to mineDepth
while slave.position.y > mineDepth do
    turtle.digDown()
    slave:down()
end

print("Reached Mine Depth")

local currentRow = 0
--------------------
:: mine ::
--------------------
local rowEndPos = slave.position + slave.facing * rowLength

-- while not at end of row mine
while slave.position ~= rowEndPos do
    local blocks = mine()
end

if slave.facing == startFacing then
    slave:turnRight()
    turtle.dig()
    slave:forward()
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
    turtle.dig()
    slave:forward()
    slave:turnLeft()
end

currentRow = currentRow + 1
--------------------
if (currentRow <= rows) then goto mine else
    print("Returning to home")
    slave:goToDestructive(startPos)
    slave:headingCommand(startFacing)
end
--------------------
