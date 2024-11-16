Spring = {}
Spring.__index = Spring

function Spring:create(x, y, l)
    local spring = {}
    setmetatable(spring, Spring)
    spring.anchor = Vector:create(x, y)
    spring.length = l
    spring.k = 0.1
    return spring
end

function Spring:connect(mover)
    local f = mover.position - self.anchor
    local d = f:mag()
    local stretch = d - self.length
    local f = f:norm()
    f:mul(-1 * self.k * stretch)
    mover:applyForce(f)
end

function Spring:draw()
    love.graphics.rectangle("fill", self.anchor.x - 5, self.anchor.y - 5, 10, 10)
end

function Spring:drawLine(mover)
    love.graphics.line(mover.position.x, mover.position.y, self.anchor.x, self.anchor.y)
end

function Spring:constrainLength(mover, minlen, maxlen)
    local dir = mover.position - self.anchor
    local d = dir:mag()
    local dir = dir:norm()
    if d < minlen then
        dir:mul(minlen)
        mover.position = self.anchor + dir
        mover.velocity:mul(0)
    elseif d > maxlen then
        dir:mul(maxlen)
        mover.position = self.anchor + dir
        mover.velocity:mul(0)
    end
    
end
