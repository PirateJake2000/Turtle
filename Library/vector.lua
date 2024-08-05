local vector = {
    __call = function(_, x, y, z)
        return setmetatable({x = x or 0, y = y or 0, z = z or 0}, vector)
    end,

    __tostring = function(self)
        return string.format("[%d, %d, %d]", math.floor(self.x), math.floor(self.y), math.floor(self.z))
    end,

    __concat = function(self, other)
        return tostring(self) .. tostring(other)
    end,

    __add = function(self, other)
        return vector(self.x + other.x, self.y + other.y, self.z + other.z)
    end,

    __sub = function(self, other)
        return vector(self.x - other.x, self.y - other.y, self.z - other.z)
    end,

    __mul = function(self, b)
        return vector(self.x * b, self.y * b, self.z * b)
    end,

    __div = function(self, b)
        return vector(self.x / b, self.y / b, self.z / b)
    end,

    __unm = function(self)
        return vector(-self.x, -self.y, -self.z)
    end,

    __eq = function(self, other)
        return self.x == other.x and self.y == other.y and self.z == other.z
    end,

    __lt = function(self, other)
        return self.x < other.x and self.y < other.y and self.z < other.z
    end,

    __le = function(self, other)
        return self.x <= other.x and self.y <= other.y and self.z <= other.z
    end,

    __len = function(self)
        return math.sqrt(self.x^2 + self.y^2 + self.z^2)
    end,

    __index = {
        isVector = true,

        clone = function(self)
            return vector(self.x, self.y, self.z)
        end,

        unpack = function(self)
            return self.x, self.y, self.z
        end,

        dot = function(self, other)
            return self.x * other.x + self.y * other.y + self.z * other.z
        end,

        cross = function(self, other)
            return vector(self.y * other.z - self.z * other.y, self.z * other.x - self.x * other.z, self.x * other.y - self.y * other.x)
        end,

        norm = function(self)
            return self / #self
        end,

        distance = function(self, other)
            return #(self - other)
        end,

        lerp = function(self, other, t)
            return self + (other - self) * t
        end,

        round = function(self)
            local temp = vector(self.x, 0, self.z):norm()

            
            
            local solutions = {
                vector(0,0,-1),
                vector(1,0,0),
                vector(0,0,1),
                vector(-1,0,0)
            }

            local solution = 1
            local bestDot = -1
            for i,v in pairs(solutions) do
                local dot = temp:dot(v)
                if dot > bestDot then
                    bestDot = dot
                    solution = i
                end
            end

            return solutions[solution]
        end

        --- Returns the index of the closest vector in the list
        ---@param vectorList table
        ---@param self vector
        ---@return number
        closestVectorIndex = function(self, vectorList)
            local minDist = math.huge()
            local minId = 0
            for i,v in pairs(vectorList) do
                local dist = #(self-v)
                if dist < minDist then
                    minDist = dist
                    minId = i
                end
            end

            return minId
        end
    }
}

return setmetatable(vector, vector)