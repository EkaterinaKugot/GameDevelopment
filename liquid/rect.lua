--rect.lua

Rect = {}
Rect.__index = Rect

function Rect:create(position, velocity, mass, w, h)
    local rect = {}
    setmetatable(rect, Rect)
    rect.position = position
    rect.velocity = velocity
    rect.mass = mass or 1
    rect.h = h
    rect.w = w
    rect.acceleration = Vector:create(0, 0)
    return rect
end

function Rect:applyForce(force)
    if force.y > 0 then
        self.acceleration:add(force)
        self.acceleration:mul(self.mass)
    else
        self.acceleration:add(force)
        self.acceleration:div(self.mass)
    end
end

function Rect:update()
    self.velocity = self.velocity + self.acceleration
    self.position = self.position + self.velocity
    self.acceleration:mul(0)
end

function Rect:draw()
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.w, self.h)
end

function Rect:force_boundaries()
    if self.position.x > width - self.w then
        self.position.x = width - self.w
        self.velocity.x = self.velocity.x * -1
    elseif self.position.x < self.w then
        self.position.x = self.w
        self.velocity.x = self.velocity.x * -1
    end

    if self.position.y > height - self.h then
        self.position.y = height - self.h
        self.velocity.y = self.velocity.y * -1
    elseif self.position.y < self.h then
        self.position.y = self.h
        self.velocity.y = self.velocity.y * -1
    end
end