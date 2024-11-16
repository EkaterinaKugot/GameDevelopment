Mover = {}
Mover.__index = Mover

function Mover:create(x, y, mass)
    local mover = {}
    setmetatable(mover, Mover)
    mover.position = Vector:create(x, y)
    mover.velocity = Vector:create(0, 0)
    mover.acceleration = Vector:create(0, 0)
    mover.dragOffset = Vector:create(0, 0)
    mover.damping = 0.995
    mover.mass = mass or 10
    mover.dragging = false
    return mover
end

function Mover:applyForce(force)
    local f = force / self.mass
    self.acceleration:add(f)
end

function Mover:update()
    self:drag()
    self.velocity:add(self.acceleration)
    self.velocity:mul(self.damping)
    self.position:add(self.velocity)
    self.acceleration:mul(0)
end

function Mover:draw()
    local tp = "fill"
    if self.dragging then
        tp = "line"
    end
    love.graphics.circle(tp, self.position.x, self.position.y, self.mass)
end

function Mover:drag()
    if self.dragging then
        local x, y = love.mouse.getPosition()
        self.position.x = x + self.dragOffset.x
        self.position.y = y + self.dragOffset.y
    end
end

function Mover:clicked(mousex, mousey)
    local diff = self.position - Vector:create(mousex, mousey)
    local d = diff:mag()
    if d < self.mass then
        self.dragging = true
        self.dragOffset.x = self.position.x - mousex
        self.dragOffset.y = self.position.y - mousey
    end
end

function Mover:unclicked()
    self.dragging = false
end
