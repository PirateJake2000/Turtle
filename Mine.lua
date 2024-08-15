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
local slave = ins(vector(2682,66,1255), vector(1,0,0))

-- Ores
local oreDict = {
    "minecraft:coal_ore",
    "minecraft:iron_ore",
    "minecraft:gold_ore",
    "minecraft:redstone_ore",
    "minecraft:lapis_ore",
    "minecraft:diamond_ore",
    "minecraft:emerald_ore",
    "minecraft:copper_ore",

    "minecraft:deepslate_coal_ore",
    "minecraft:deepslate_iron_ore",
    "minecraft:deepslate_gold_ore",
    "minecraft:deepslate_redstone_ore",
    "minecraft:deepslate_lapis_ore",
    "minecraft:deepslate_diamond_ore",
    "minecraft:deepslate_emerald_ore",
    "minecraft:deepslate_copper_ore",

    "mekanism:osmium_ore",
    "mekanism:deepslate_osmium_ore",

    "mekanism:copper_ore",
    "mekanism:deepslate_copper_ore",

    "mekanism:tin_ore",
    "mekanism:deepslate_tin_ore",
}

local keepDict = {
    "minecraft:coal",
    "minecraft:raw_iron",
    "minecraft:raw_gold",
    "minecraft:redstone",
    "minecraft:lapis_lazuli",
    "minecraft:diamond",
    "minecraft:emerald",
    "minecraft:raw_copper",

    "mekanism:raw_osmium",
    "mekanism:raw_copper",
    "mekanism:raw_tin",
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
        for i,ore in pairs(knownOres) do
            if ore == removeOre then
                table.remove(knownOres, i)
                return
            end
        end
    end

    local function oreIsKnown(checkOre)
        for i,ore in pairs(knownOres) do -- Table expected got nil
            if ore == checkOre then
                return true
            end
        end
    end
    
    local function updateKnownOres()
        for i,dir in pairs(directions) do
            if not oreIsKnown(slave.position + dir) then
                slave:headingCommand(dir)
                local _,data = turtle.inspect()
                if data.name == oreName then
                    table.insert(knownOres, slave.position + slave.facing)
                end
            end
        end

        if not oreIsKnown(slave.position + vector(0,1,0)) then
            local _,data = turtle.inspectUp()
            if data.name == oreName then
                table.insert(knownOres, slave.position + vector(0,1,0))
            end
        end

        if not oreIsKnown(slave.position + vector(0,-1,0)) then
            local _,data = turtle.inspectDown()
            if data.name == oreName then
                table.insert(knownOres, slave.position + vector(0,-1,0))
            end
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
    if (_) then blockUp.position = slave.position + vector(0,1,0) end


    local _,blockDown = turtle.inspectDown()
    if (_) then blockDown.position = slave.position + vector(0,-1,0) end
    
    slave:turnLeft()
    local _,blockLeft = turtle.inspect()
    if (_) then blockLeft.position = slave.position + slave.facing end

    slave:turnRight()

    slave:turnRight()
    local _,blockRight = turtle.inspect()
    if (_) then blockRight.position = slave.position + slave.facing end

    slave:turnLeft()

    local blockTable = {}

    if blockUp then table.insert(blockTable, blockUp) end
    if blockDown then table.insert(blockTable, blockDown) end
    if blockLeft then table.insert(blockTable, blockLeft) end
    if blockRight then table.insert(blockTable, blockRight) end

    return blockTable
end

function forceForward()
    local success = slave:forward()
    if not success then 
        turtle.dig()
        forceForward()
    end
end

function dumpInventory()
    -- Dump all none ore items
    for i = 1, 16 do
        turtle.select(i)
        local item = turtle.getItemDetail()
        if item then
            local keep = false
            for i, keepItem in ipairs(keepDict) do
                if item.name == keepItem then
                    keep = true
                    break
                end
            end

            if not keep then
                turtle.drop()
            end
        end
    end


end
-----------------------------------------------
-- Settings
local startPos = slave.position
local startFacing = slave.facing
local mineDepth = tonumber(args[1]) or 10

local rows = tonumber(args[2]) or 8
local rowLength = tonumber(args[3]) or 32
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

                local ogPosition = slave.position:clone()
                local ogFacing = slave.facing:clone()

                dumpInventory()
                mineVein(value.position, value.name)

                -- Work out how many blocks needed to travel to get back to startPos
                local blocksAwayFromHomeX = math.abs(startPos.x - slave.position.x)
                local blocksAwayFromHomeZ = math.abs(startPos.z - slave.position.z)
                local blocksAwayFromHomeY = math.abs(startPos.y - slave.position.y)

                local blocksAway = blocksAwayFromHomeX + blocksAwayFromHomeZ + blocksAwayFromHomeY

                if (blocksAway > turtle.getFuelLevel()) then
                    -- Low fuel go home time
                    currentRow = rows
                end

                print("Found Ore: " .. value.name)
                print("Position: " .. value.position)

                slave:goToDestructive(ogPosition)
                slave:headingCommand(ogFacing)
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
        forceForward()
        turtle.dig()
        forceForward()
        turtle.dig()
        forceForward()
        slave:turnRight()
    else
        slave:turnLeft()
        turtle.dig()
        forceForward()
        turtle.dig()
        forceForward()
        turtle.dig()
        forceForward()
        slave:turnLeft()
    end

    goto mine 
else
    print("Returning to home")
    slave:goToDestructive(startPos)
    slave:headingCommand(startFacing)
end
-----------------------------------------------






