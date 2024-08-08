local args = {...}

-- Imports
vector = require("Library.Vector")
ins = require("Library.ins")

-- Arguments
-- 1 -> Turtle count
-- 2 -> Lowest turtle 
-- 3 -> Rows 
-- 4 -> RowLength
local turtleCount = args[1]
local mineDepth = args[2] -- Lowest Turtle
local rows = 16
local rowLength = 16 * 3
local extraFuel = 64

local turtlesSent = 0

-- Setup
print("Setup")
print("enter turtle x")
local x = tonumber(read())
print("enter turtle y")
local y = tonumber(read())
print("enter turtle z")
local z = tonumber(read())
print("enter turtle facing x")
local fx = tonumber(read())
print("enter turtle facing y")
local fy = tonumber(read())
print("enter turtle facing z")
local fz = tonumber(read())

term.clear()
term.setCursorPos(1,1)

print("setup")
print("Enter how many rows you want to mine")
rows = tonumber(read())
print("Enter how long you want the rows to be")
rowLength = tonumber(read())
print("How deep do you want the mine to be?")
mineDepth = tonumber(read())


local slave = ins(vector(x,y,z), vector(fx,fy,fz))

-- Rednet setup
rednet.open("right")


-- select item in inventory
function selectItem(itemName)
    for i=1,16 do
        turtle.select(i)
        local _,detail = turtle.getItemDetail
        if detail.name == itemName then return true end
    end

    return false
end



-- place turtle below and give it sufficient coal
function placeMiner()
    if not selectItem("computercraft:turtle_normal") then return end

    turtle.placeDown()
    
    selectItem("minecraft:coal")
    
    -- amount of coal needed
    local altDifference = math.abs(slave.position.y - (mineDepth - turtlesSent*5))
    local coal = math.floor(((rows * (rowLength + 3) + altDifference * 2 ) + extraFuel) / 80)
    
    -- give miner coal
    turtle.dropDown(coal)

    

end


-- Check for chest
function setUp()

    local function checkForChest()
        for i = 1, 16 do
            if turtle.getItemDetail(i) ~= nil then
                if turtle.getItemDetail(i).name == "minecraft:chest" then
                    -- Place chest above turtle
                    turtle.select(i)
                    turtle.placeUp()
                end
            end
        end
    end

    checkForChest()
    -- Check to see if a chest was placed
    
    local _,above = turtle.inspectUp()
    if above.name ~= "minecraft:chest" then
        os.sleep(3)
        checkForChest()
    end

    turtle.digDown()

    -- Place turtle
    placeMiner()

    -- Rednet broadcast information
    rednet.broadcast(
        {
            ["location"] = slave.position + vector(0,-1,0),
            ["facing"] = slave.facing,
            ["mineDepth"] = mineDepth,
            ["rows"] = rows,
            ["rowLength"] = rowLength
        }
    )
    
end

setUp()