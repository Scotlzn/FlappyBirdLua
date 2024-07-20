math.randomseed(os.time())

Pipe = {}
Pipe.__index = Pipe

function Pipe:new(x)
    local instance = setmetatable({}, Pipe)
    instance.x = x
    instance.speed = 150

    instance.width = 32

    local offset = 180
    local midpoint = math.random(offset, 360 + offset)

    local hole = {
        midpoint - math.random(60, 150),
        midpoint + math.random(60, 150)
    }

    instance.top = {0, hole[1]}
    instance.btm = {hole[2], 720 - hole[2]}

    return instance
end

function Pipe:move(dt)
    self.x = self.x - self.speed * dt
end

function Pipe:render()
    love.graphics.setColor(0, 0.8, 0, 1)
    love.graphics.rectangle("fill", self.x, self.top[1], self.width, self.top[2])
    love.graphics.rectangle("fill", self.x, self.btm[1], self.width, self.btm[2])
    love.graphics.setColor(1, 1, 1, 1)
end

return Pipe