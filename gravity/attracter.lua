Attracter = {}
Attracter.__index = Attracter

function Attracter:create(position, mass)
    local attracter = {}
    setmetatable(attracter, Attracter)
    attracter.position = position
    attracter.mass = mass
    attracter.size = 30 + 0.3 * mass
    attracter.inner_size = attracter.size
    return attracter
end

function Attracter:update()

end

function Attracter:draw()
    love.graphics.circle("line", self.position.x, self.position.y, self.size)
    self.inner_size = self.inner_size - 0.5
    if self.inner_size <= 0 then
        self.inner_size = self.size
    end
    love.graphics.circle("line", self.position.x, self.position.y, self.inner_size)
end

function Attracter:attract(mover)
    local force = self.position - mover.position
    local distance = force:mag()
    if distance then
        if distance < 5 then
            distance = 5
        end
        if distance > 25 then
            distance = 25
        end
        local direction = force:norm()
        local strength = (0.4 * self.mass * mover.mass) / (distance * distance)
        direction:mul(strength)
        return direction
    end
end
