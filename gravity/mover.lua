--mover.lua

Mover = {}
Mover.__index = Mover

function Mover:create(position, velocity, mass)
    local mover = {}
    setmetatable(mover, Mover)
    mover.position = position
    mover.velocity = velocity
    mover.mass = mass or 1
    mover.size = 20
    mover.acceleration = Vector:create(0, 0)
    return mover
end

function Mover:applyForce(force)
    if force.y > 0 then
        self.acceleration:add(force)
        self.acceleration:mul(self.mass)
    else
        self.acceleration:add(force)
        self.acceleration:div(self.mass)
    end
end

function Mover:update()
    self.velocity = self.velocity + self.acceleration
    self.position = self.position + self.velocity
    self.acceleration:mul(0)
end

function Mover:draw()
    love.graphics.circle("fill", self.position.x, self.position.y, self.size)
end

function Mover:force_boundaries()

    if self.position.x > width - self.size then
        self.position.x = width - self.size
        self.velocity.x = self.velocity.x * -1
    elseif self.position.x < self.size then
        self.position.x = self.size
        self.velocity.x = self.velocity.x * -1
    end

    if self.position.y > height - self.size then
        self.position.y = height - self.size
        self.velocity.y = self.velocity.y * -1
    elseif self.position.y < self.size then
        self.position.y = self.size
        self.velocity.y = self.velocity.y * -1
    end
end

function Mover:check_boundaries()
    if self.position.x > width then
        self.position.x = 0
    elseif self.position.x < 0 then
        self.position.x = width
    end

    if self.position.y > height then
        self.position.y = 0
    elseif self.position.y < 0 then
        self.position.y = height
    end
end

function Mover:attract(mover)
    local force = self.position - mover.position
    local distance = force:mag()
    if distance then
        if distance < 5 then
            distance = 5
        end
        if distance > 50 then
            distance = 50
        end
        local direction = force:norm()
        local strength = (0.4 * self.mass * mover.mass) / (distance * distance)
        direction:mul(strength)
        return direction
    end
end


Movers = {}
Movers.__index = Movers

function Movers:create(xmin, xmax, ymin, ymax, n, mass)
    local movers = {}
    setmetatable(movers, Movers)
    movers.n = n
    movers.objs = {}
    for i=1, n do
        local x = love.math.random(xmin, xmax)
        local y = love.math.random(ymin, ymax)
        movers.objs[i] = Mover:create(Vector:create(x, y), Vector:create(), mass)
    end
    return movers
end

function Movers:draw()
    for i=1, self.n do
        self.objs[i]:draw()
    end
end

function Movers:update()
    for i=1, self.n do
        for j=1, self.n do
            if i ~= j then
                local strength = self.objs[i]:attract(self.objs[j])
                self.objs[i]:applyForce(strength:__mul(-1))
            end
        end
    end
    for i=1, self.n do
        self.objs[i]:force_boundaries()
        self.objs[i]:update()
    end
end