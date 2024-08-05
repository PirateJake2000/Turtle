local ins = {
    __call = function(_, position, facing)
        return setmetatable({
            position = position,
            facing = facing,
            facingRight = facing:cross(vector(0,1,0))
        }, ins)
    end,

    __tostring = function(self)
        return "pos: " .. self.position .. "\nlook: " .. self.facing .. "\nlookRight" .. self.facingRight
    end,

    __index = {
        save = function(self)
            local saveFile = fs.open("data.txt", "w")
            
            saveFile.write(textutils.serialise({
                position = self.position,
                facing = self.facing,
                facingRight = self.facingRight
            }))
        
            saveFile.close()
        end,

        load = function(self)
            if (not fs.exists("data.txt")) then
                self:save()
            end
        
            local saveFile = fs.open("data.txt", "r")
            local data = textutils.unserialise(saveFile.readAll())

            local position = vector(data.position.x, data.position.y, data.position.z)
            local facing = vector(data.facing.x, data.facing.y, data.facing.z)
            local facingRight = vector(data.facingRight.x, data.facingRight.y, data.facingRight.z)

            self.position = position
            self.facing = facing
            self.facingRight = facingRight

            saveFile.close()            
        end,

        canMove = function(self)
            if (turtle.getFuelLevel() > 10) then
                return true
            else
                print("Out of fuel")
                return false
            end
        end,

        
  
        forward = function(self)
            -- if has fuel
            if not self.canMove() then return end
        
            -- move
            local moved = turtle.forward()
            
            -- update ins
            if moved then
                self.position = self.position + self.facing
            end
            
            -- save ins
            self:save()

            return moved
        end,

        back = function(self)
            -- if has fuel
            if not self.canMove() then return end
        
            -- move
            local moved = turtle.back()
        
            -- update ins
            if moved then
                self.position = self.position - self.facing
            end
        
            -- save ins
            self:save()
            
            return moved
        end,

        right = function(self)
            -- if has fuel
            if not self.canMove() then return end
        
            -- move
            turtle.turnRight()
            local moved = turtle.forward()
            turtle.turnLeft()
        
            -- update ins
            if moved then
                self.position = self.position + self.facingRight
            end

            -- save ins
            self:save()
        
            return moved
        end,

        left = function(self)
            -- if has fuel
            if not self.canMove() then return end
        
            -- move
            turtle.turnLeft()
            local moved = turtle.forward()
            turtle.turnRight()
        
            -- update ins
            if moved then
                self.position = self.position - self.facingRight
            end
        
            -- save ins
            self:save()
            
            return moved
        end,

        up = function(self)
            -- if has fuel
            if not self.canMove() then return end
        
            -- move
            local moved = turtle.up()
        
            -- update ins
            if moved then
                self.position = self.position + vector(0,1,0)
            end
        
            -- save ins
            self:save()
            
            return moved
        end,

        down = function(self)
            -- if has fuel
            if not self.canMove() then return end
        
            -- move
            local moved = turtle.down()
        
            -- update ins
            if moved then
                self.position = self.position - vector(0,1,0)
            end

            -- save ins
            self:save()
        
            return moved
        end,

        turnRight = function(self)
            -- if has fuel
            if not self.canMove() then return end

            -- rotate
            turtle.turnRight()

            -- update ins
            local temp = self.facing:clone()
            self.facing = self.facingRight
            self.facingRight = -temp
            
            -- save ins
            self:save()

        end,

        turnLeft = function(self)
            -- if has fuel
            if not self.canMove() then return end

            -- rotate
            turtle.turnLeft()

            -- update ins
            local temp = self.facing:clone()
            self.facing = -self.facingRight
            self.facingRight = temp
            
            -- save ins
            self:save()
            
        end,

        -- takes a heading vector as a command i.e. vector(0,0,-1)
        headingCommand = function(self, heading) 
            -- if has fuel
            if not self.canMove() then return end

            -- break when heading is already correct or when the heading command is not horizontal
            if self.facing == heading or #vector(heading.x,0,heading.z) == 0 then return end

            -- calculate heading direction
            local x = self.facing:cross(heading).y

            -- turn heading direction
            if x==1 then self:turnLeft() end
            if x==-1 then self:turnRight() end
            if x==0 then self:turnRight() self:turnRight() end
        end,

        -- looks at a block
        lookAt = function(self, target)
            -- if has fuel
            if not self.canMove() then return end

            -- calculate heading direction
            local heading = (target - self.position):round()

            -- turn heading direction
            self:headingCommand(heading)
        end,

        -- goes to a block
        goTo = function(self, target)
            local tempTarget = vector(target.x, self.position.y, self.position.z)
            self:lookAt(tempTarget)

            -- move to target
            local steps = self.position:distance(tempTarget)

            print(steps)

            for i=1, steps do
                self:forward()
            end

            tempTarget = vector(self.position.x, self.position.y, target.z)

            self:lookAt(tempTarget)

            steps = self.position:distance(tempTarget)

            for i=1, steps do
                self:forward()
            end
            
        end,

        -- goes to a block destructively
        goToDestructive = function(self, target)
            local tempTarget = vector(target.x, self.position.y, self.position.z)
            self:lookAt(tempTarget)

            -- move to target
            local steps = self.position:distance(tempTarget)

            print(steps)

            for i=1, steps do
                turtle.dig()
                self:forward()
            end

            tempTarget = vector(self.position.x, self.position.y, target.z)

            self:lookAt(tempTarget)

            steps = self.position:distance(tempTarget)

            for i=1, steps do
                turtle.dig()
                self:forward()
            end

            while self.position.y < target.y do
                turtle.digUp()
                self:up()
            end

            while self.position.y > target.y do
                turtle.digDown()
                self:down()
            end
            
        end,
    }
}

return setmetatable(ins, ins)