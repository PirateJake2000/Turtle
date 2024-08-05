local args = {...}

-- Imports
vector = require("Library.Vector")
ins = require("Library.ins")

-- Arguments
-- 1 -> INS X
-- 2 -> INS Y
-- 3 -> INS Z
-- 4 -> INS Facing X
-- 5 -> INS Facing Y
-- 6 -> INS Facing Z
-- 7 -> Mining Depth
-- 8 -> Mining Rows
-- 9 -> Mining RowLength

-- Setup
local slave = ins(vector(-444,90,-331), vector(-1,0,0))

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

-- Directions
local directions = {
    vector(0,0,-1),
    vector(1,0,0),
    vector(0,0,1),
    vector(-1,0,0)
}


-- Functions
function mineVein(startPosition, oreName)
    local knownOres = {startPosition}

    local function removeOreFromTable(removeOre)
        for i,ore in pairs(konwnOres) do
            if ore == removeOre then
                table.remove(knownOres, i)
                return
            end
        end
    end
    
    local function updateKnownOres()
        for i,dir in pairs(directions) do
            slave:headingCommand(dir)
            local _,data = turtle.inspect()
            if data.name == oreName then
                table.insert(knownOres, slave.position + slave.facing)
            end
        end

        local _,data = turtle.inspectUp()
        if data.name == oreName then
            table.insert(knownOres, slave.position + vector(0,1,0))
        end

        local _,data = turtle.inspectDown()
        if data.name == oreName then
            table.insert(knownOres, slave.position + vector(0,-1,0))
        end
    end

    while #knownOres > 0 do
        local id = slave.position:closestVectorIndex(knownOres)
        slave:goToDestructive(knownOres[id])
        table.remove(knownOres, id)
        updateKnownOres()
    end
end

function mine()
    turtle.dig()
    slave:forward()

    local _,blockUp = turtle.inspectUp()
    blockUp.position = slave.position + vector(0,1,0)

    local _,blockDown = turtle.inspectDown()
    blockDown.position = slave.position + vector(0,-1,0)
    
    slave:turnLeft()
    local _,blockLeft = turtle.inspect()
    blockLeft.position = slave.position + slave.facing

    slave:turnRight()

    slave:turnRight()
    local _,blockRight = turtle.inspect()
    blockRight.position = slave.position + slave.facing

    slave:turnLeft()


    return {
        up = blockUp,
        down = blockDown,
        left = blockLeft,
        right = blockRight
    }
end

-----------------------------------------------
-- Settings
local startPos = slave.position
local startFacing = slave.facing
local mineDepth = args[7] or 25

local rows = args[8] or 4
local rowLength = args[9] or 16
-----------------------------------------------


-----------------------------------------------
-- Go down to mineDepth
-----------------------------------------------
while slave.position.y > mineDepth do
    turtle.digDown()
    slave:down()
end



local currentRow = 0
-----------------------------------------------
:: mine :: -- Start of mine sequence
-----------------------------------------------
local rowEndPos = slave.position + slave.facing * rowLength

-- while not at end of row mine
while slave.position ~= rowEndPos do
    local blocks = mine()

    for key, value in pairs(blocks) do
        -- Loop through oreDict and check if the block is in the oreDict
        for i, ore in ipairs(oreDict) do
            if value.name == ore then
                -- {
                --   name = "minecraft:oak_log",
                --   state = { axis = "x" },
                --   tags = { ["minecraft:logs"] = true, ... },
                -- }

                mineVein(value.position, value.name)
                print("Found Ore: " .. value.name)
                print("Position: " .. value.position)
            end
        end
    end
end

currentRow = currentRow + 1
-----------------------------------------------
-- End of mine sequence
-----------------------------------------------
if (currentRow <= rows) then 
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

    goto mine 
else
    print("Returning to home")
    slave:goToDestructive(startPos)
    slave:headingCommand(startFacing)
end
-----------------------------------------------






