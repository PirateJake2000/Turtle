-- Imports
vector = require("Library.Vector")
ins = require("Library.ins")

-- Setup
local slave = ins(vector(-261,78,-70), vector(0,0,-1))

-- Ores
local oreDict = {
    "minecraft:coal_ore",
    "minecraft:iron_ore",
    "minecraft:gold_ore",
    "minecraft:redstone_ore",
    "minecraft:lapis_ore",
    "minecraft:diamond_ore",
    "minecraft:emerald_ore",
}


-- Functions
function mineVein(oreVector)

end

function mine()
    turtle.dig()
    slave:forward()

    local blockUp = turtle.inspectUp()
    blockUp.position = slave.position + vector(0,1,0)

    local blockDown = turtle.inspectDown()
    blockDown.position = slave.position + vector(0,-1,0)
    
    slave:turnLeft()
    local blockLeft = turtle.inspect()
    blockLeft.position = slave.position + slave.facing

    slave:turnRight()

    slave:turnRight()
    local blockRight = turtle.inspect()
    blockRight.position = slave.position + slave.facing

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
local mineDepth = 10

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

local rowEndPos = slave.position + slave.facing * rowLength

-- while not at end of row mine
while slave.position ~= rowEndPos do
    local blocks = mine()

    for key, value in pairs(blocks) do
        if value.name in oreDict then
            mineVein(value.position)
            print("Found Ore: " .. value.name)
            print("Position: " .. value.position)
        end
    end
end

currentRow = currentRow + 1
--------------------
if (currentRow <= rows) then goto mine else
    print("Returning to home")
    slave:goToDestructive(startPos)
    slave:headingCommand(startFacing)
end
--------------------
