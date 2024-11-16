Pendulum = {}
Pendulum.__index = Pendulum

function Pendulum:create(origin, length)
    local pendulum = {}
    setmetatable(pendulum, Pendulum)
    pendulum.origin = origin
    pendulum.length = length
    pendulum.position = Vector:create(0, 0)
    pendulum.aVelocity = 0
    pendulum.aAcceleration = 0
    pendulum.damping = 0.995
    pendulum.r = 20
    pendulum.dragging = false
    pendulum.angle = 0
    return pendulum
end

function Pendulum:update()
    self:drag()
    self.aAcceleration = (-1 * gravity.y / self.length) * math.sin(self.angle)
    self.aVelocity = self.aVelocity + self.aAcceleration
    self.aVelocity = self.aVelocity * self.damping
    self.angle = self.angle + self.aVelocity
end

function Pendulum:drag()
    if self.dragging then
        local x, y = love.mouse.getPosition()
        local diff = self.origin - Vector:create(x, y)
        self.angle = math.atan2(diff.y * -1, diff.x) - math.pi / 2
    end
end

function Pendulum:draw()
    self.position.x = self.length * math.sin(self.angle) + self.origin.x
    self.position.y = self.length * math.cos(self.angle) + self.origin.y

    love.graphics.circle("line", self.origin.x, self.origin.y, 5)
    love.graphics.line(self.origin.x, self.origin.y, self.position.x, self.position.y)

    r, g, b, a = love.graphics.getColor()
    if self.dragging then
        love.graphics.setColor(1, 0, 0)
    end
    love.graphics.circle("fill", self.position.x, self.position.y, self.r)
    love.graphics.setColor(r, g, b, a)
end

function Pendulum:clicked(mousex, mousey)
    local diff = self.position - Vector:create(mousex, mousey)
    if diff:mag() < self.r then
        self.dragging = true
    end
end

function Pendulum:unclicked()
    if self.dragging then
        self.aVelocity = 0
        self.dragging = false
    end
end