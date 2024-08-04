-- Imports
vector = require("vector")
ins = require("ins")

-- INS
local slave = ins(vector(-2746, 25, 3002), vector(1,0,0))
--slave:load()

local inventory = {}
local blocksDug = 0

function sortInventory()
    print("sorting")
    turtle.select(1)
    local selectedItem = turtle.getItemDetail()
    if not selectedItem.name == "minecraft:cobbled_deepslate" then
        --move item 1 to free slot
        for i=2,16 do
            turtle.select(i)
            local selectedItem = turtle.getItemDetail()
            if not selectedItem then
                turtle.transferTo(i)
            end
        end
    end

    for i=2,16 do
        turtle.select(i)
        local selectedItem = turtle.getItemDetail()
        if selectedItem and selectedItem.name == "minecraft:cobbled_deepslate" then
            local success = turtle.transferTo(1)
            if not success then
                turtle.drop()
            end

        end
    end
end

function updateInventory()
    sortInventory()

    for i=1,16 do
        turtle.select(i)
        local selectedItem = turtle.getItemDetail()

        inventory[i] = selectedItem 
    end                                                                                 -- boobs, thighs, not being asian

    turtle.select(1)
end

function isInventoryFull()
    for i=1,16 do
        if inventory[i] == nil then
            return false
        end
    end

    return true
end


function digLayer()
    if turtle.dig() then dug() end
    local moved = slave:forward()
    if turtle.digUp() then dug() end
    if turtle.digDown() then dug() end
    return moved
end

function dug()
    blocksDug = blocksDug + 1
end

function isFluid()
    local _,up = turtle.inspectUp()
    local _,down = turtle.inspectDown()
    return up.name == "minecraft:lava" or down.name == "minecraft:lava" or up.name == "minecraft.water" or down.name == "minecraft.water"
end

function buildFluidWall()
    turtle.select(1)--select block for building

    turtle.placeDown()
    slave:up()
    slave:up()
    turtle.placeUp()
    slave:down()
    slave:down()
end

-- Main
function digTunnel(length)
    local target = slave.position + slave.facing * length

    while true do
        local moved = digLayer()

        print("blocksDug: " .. blocksDug)
        
        if blocksDug > 32 then
            updateInventory()
            blocksDug = 0
        end

        if slave.position == target then break end
    end
end

function mine(length)
    turtle.select(1)

    while true do
        slave:forward()
        local _, front = turtle.inspect()

        if _ then
            turtle.dig()
            slave:forward()
            turtle.digUp()
            turtle.digDown()

            break
        end
    end

    rowStart = slave.position

    slave:turnLeft()

    digTunnel(length)

    slave:down()

    returnHome(length)
end

function returnHome(length)
    slave:lookAt(rowStart-vector(0,-1,0))

    while slave.position ~= rowStart-vector(0,-1,0) do
        slave:forward()

        if isFluid() then
            buildFluidWall()
        end
    end
    
    slave:turnRight()

    while true do
        local _, down = turtle.inspectDown()
        if down.name == "minecraft:chest" then
            break
        end
        slave:forward()
    end

    print("reached the chest")

    for i=1, 16 do
        turtle.select(i)
        turtle.dropDown()
    end

    slave:up()
    slave:turnRight()
    slave:turnRight()

    refuel(length)
end

function refuel(length)
    turtle.select(1)

    local fuel = turtle.getFuelLevel()

    local neededFuel = length * 4 - fuel

    local neededCoal = math.ceil(neededFuel / 8)

    print("needed coal: " .. neededCoal)

    while neededCoal > 0 do
        turtle.suckUp(1)
        neededCoal = neededCoal - 1
    end
    
    for i=1, 16 do
        turtle.select(i)
        turtle.refuel()
    end
end

-- 1 coal = 8 fuel -> 8 movement 
-- min = lenght * 4

for i=1,30 do
    mine(128)
end

