-- Define a class
Player = {}
Player.__index = Player

-- Constructor
function Player:new(x, y)
    local instance = setmetatable({}, Player)
    instance.x = x
    instance.y = y
    instance.velocity = 0
    instance.acceleration = 250
    instance.terminal_velocity = 600
    instance.jump_height = 200

    instance.alive = true

    return instance
end

function Player:move(dt)
    self.velocity = self.velocity + self.acceleration * dt
    if self.velocity > self.terminal_velocity then
        self.velocity = self.terminal_velocity
    end
    self.y = self.y + self.velocity * dt
end

function Player:render()
    if not self.alive then return end
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.rectangle("fill", self.x, self.y, 48, 48)
    love.graphics.setColor(1, 1, 1, 1)
end

-- Return the class
return Player
