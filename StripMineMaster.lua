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
local slave = ins(vector(-2928,67,3119), vector(-1,0,0))


-- select item in inventory
function selectItem(itemName)
    for i=1,16 do
        turtle.select(i)
        local _,detail = turtle.getItemDetail
        if detail.name == itemName then return true end
    end

    return false
end



-- place turtle below and send it to its altitude
function sendTurtle()
    if not selectItem("computercraft:turtle_normal") then return end

    turtle.placeDown()
    
    selectItem("minecraft:coal")
    
    -- amount of coal needed
    local altDifference = math.abs(slave:position.y - (mineDepth - turtlesSent*5))
    local coal = ((rows * (rowLength + 3) + altDifference * 2 ) + extraFuel) / 80
    
    -- tell turtle how deep to go by amount of red wool
    turtle.dropDown()



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
    if turtle.inspectUp().name ~= "minecraft:chest" then
        os.sleep(3)
        checkForChest()
    end

    turtle.digDown()
    
    
end

setUp()