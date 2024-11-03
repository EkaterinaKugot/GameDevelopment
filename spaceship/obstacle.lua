Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle:create()
    local obstacle = {}
    setmetatable(obstacle, Obstacle)
    obstacle.angle = Vector:create(0, 0)
    obstacle.velocity = Vector:create(
        0,
    love.math.random(-0.05, 0.05)
)
    obstacle.amplitude = Vector:create(100, 200)
    obstacle.position = Vector:create(0, 0)
    obstacle.r = 20
    return obstacle
end


function Obstacle:update()
    self.angle:add(self.velocity)
    self.position.x = self.position.x + 1 
    self.position.y = math.sin(self.angle.y) * self.amplitude.y
end

function Obstacle:draw()
    love.graphics.push()
    love.graphics.translate(0, height/2)
    love.graphics.circle("fill", self.position.x, self.position.y, self.r)
    love.graphics.pop()
end

function Obstacle:check_boundaries()
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

