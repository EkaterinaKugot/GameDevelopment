Boid = {}
Boid.__index = Boid

function Boid:create(x, y)
    local boid = {}
    setmetatable(boid, Boid)
    boid.position = Vector:create(x, y)
    boid.velocity = Vector:create(math.random(-10, 10) / 10, math.random(-10, 10) / 10)
    boid.acceleration = Vector:create(0, 0)
    boid.r = 5
    boid.vertices = {0, - boid.r * 2, -boid.r, boid.r * 2, boid.r, 2 * boid.r}
    boid.maxSpeed = 4
    boid.maxForce = 0.1
    return boid
end

function Boid:update(boids)
    self:flock(boids)
    self.velocity:add(self.acceleration)
    self.velocity:limit(self.maxSpeed)
    self.position:add(self.velocity)
    self.acceleration:mul(0)
    self:borders()
end

function Boid:flock(boids)
    local sep = self:separate(boids)
    local align = self:align(boids)
    local coh = self:cohesion(boids)

    sep:mul(1.5)
    align:mul(1)
    coh:mul(1)

    if isSep then
        self:applyForce(sep)
    end

    if isAlign then
        self:applyForce(align)
    end

    if isCoh then
        self:applyForce(coh)
    end
end

function Boid:applyForce(force)
    self.acceleration:add(force)
end

function Boid:seek(target)
    local desired = target - self.position
    desired:norm()
    desired:mul(self.maxSpeed)
    local steer = desired - self.velocity
    steer:limit(self.maxForce)
    return steer
end

function Boid:separate(others)
    local separation = 25
    local steer = Vector:create(0, 0)
    local count = 0
    for i=0, #others do
        local other = others[i]
        local d = self.position:distTo(other.position)
        if d > 0 and d < separation then
            local diff = self.position - other.position
            diff:norm()
            diff:div(d)
            steer:add(diff)
            count = count + 1
        end
    end 

    if count > 0 then
        steer:div(count)
    end

    if steer:mag() > 0 then
        steer:norm()
        steer:mul(self.maxSpeed)
        steer:sub(self.velocity)
        steer:limit(self.maxForce)
    end

    return steer
end

function Boid:align(others)
    local alignment = 50
    local sum = Vector:create(0, 0)
    local count = 0

    for i=0, #others do
        local other = others[i]
        local d = self.position:distTo(other.position)
        if d > 0 and d < alignment then
            sum:add(other.velocity)
            count = count + 1
        end
    end 

    if count > 0 then
        sum:div(count)
        sum:norm()
        sum:mul(self.maxSpeed)
        local steer = sum - self.velocity
        steer:limit(self.maxForce)
        return steer
    else
        return Vector:create(0, 0)
    end
end

function Boid:cohesion(others)
    local neighbours = 50
    local sum = Vector:create(0, 0)
    local count = 0

    for i=0, #others do
        local other = others[i]
        local d = self.position:distTo(other.position)
        if d > 0 and d < neighbours then
            sum:add(other.position)
            count = count + 1
        end
    end 

    if count > 0 then
        sum:div(count)
        return self:seek(sum)
    else
        return Vector:create(0, 0)
    end
end

function Boid:borders()
    if self.position.x < -self.r then
        self.position.x = width - self.r
    end
    if self.position.x > width + self.r then
        self.position.x = self.r
    end

    if self.position.y < -self.r then
        self.position.y = height - self.r
    end
    if self.position.y > height + self.r then
        self.position.y = self.r
    end
end

function Boid:countOthers(others)
    local separation = 50
    local count = 0
    for i=0, #others do
        local other = others[i]
        local d = self.position:distTo(other.position)
        if d > 0 and d < separation then
            count = count + 1
        end
    end 

    return count
end

function Boid:draw(others)
    local count = self:countOthers(others)
    r, g, b, a = love.graphics.getColor()

    love.graphics.setColor(0, 0.1 + ((count / #others) / 10)*9, 0.5)
    local theta = self.velocity:heading() + math.pi / 2
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.rotate(theta)
    love.graphics.polygon("fill", self.vertices)
    love.graphics.pop()

    love.graphics.setColor(r, g, b, a)
end

