Mover = {}
Mover.__index = Mover

function Mover:create(position, velocity, mass)
    local mover = {}
    setmetatable(mover, Mover)
    mover.position = position
    mover.velocity = velocity
    mover.mass = mass or 1
    mover.acceleration = Vector:create(0, 0)
    mover.angle = 0 
    mover.active = false
    return mover
end

function Mover:applyForce(force)
        self.acceleration:add(force)
end

function line_circle_collision(p1x, p1y, p2x, p2y, xc3, yc3, r3)
    local locp1x = p1x - xc3
    local locp1y = p1y - yc3

    local locp2x = p2x - xc3
    local locp2y = p2y - yc3

    local p1p2x = locp2x - locp1x
    local p1p2y = locp2y - locp1y

    local a = p1p2x * p1p2x + p1p2y * p1p2y
    local b = 2 * (p1p2x * locp1x + p1p2y * locp1y)
    local c = locp1x * locp1x + locp1y * locp1y - r3 * r3
    local delta = b * b - (4 * a * c)
    if delta < 0 then
        return nil
    elseif delta == 0 then
        local u = -b / ( 2 * a)
        local x = p1x + (u * p1p2x)
        local y = p1y + (u * p1p2y)
        return {{x, y}}
    else
        sqr = math.sqrt(delta)
        local u1 = (-b + sqr) / (2 * a)
        local u2 = (-b - sqr) / (2 * a)
        -- print(u1, u2)
        if not(u1 > 0 and u1 < 1) and not(u2 > 0 and u2 < 1) then
            return nil
        end
        local x1 = p1x + (u1 * p1p2x)
        local y1 = p1y + (u1 * p1p2y)
        local x2 = p1x + (u2 * p1p2x)
        local y2 = p1y + (u2 * p1p2y)
        return {{x1, y1}, {x2, y2}}
    end
end

function Mover:update()
    self.velocity = self.velocity + self.acceleration
    self.position = self.position + self.velocity
    self.acceleration:mul(0)
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


function Mover:draw(xc3, yc3, r3)
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.rotate(self.angle)
    r, g, b, a = love.graphics.getColor()

    love.graphics.setLineWidth(4)

    local t_yc3 = yc3 + (height / 2)
    
    if line_circle_collision(self.position.x-30, self.position.y-30, self.position.x+30, self.position.y, xc3, t_yc3, r3) then
        love.graphics.setColor(1, 0, 0)
    elseif line_circle_collision(self.position.x+30, self.position.y, self.position.x-30, self.position.y+30, xc3, t_yc3, r3) then
        love.graphics.setColor(1, 0, 0)
    elseif line_circle_collision(self.position.x-30, self.position.y+30, self.position.x-30, self.position.y-30, xc3, t_yc3, r3) then
        love.graphics.setColor(1, 0, 0)
    end

    love.graphics.line(-30, -30, 30, 0, -30, 30, -30, -30)

    love.graphics.setColor(1, 1, 1)
    local type = "line"
    if self.active then
        love.graphics.setColor(1, 0, 0, 1)
        type = "fill"
    end
    love.graphics.rectangle(type, -40, 5, 10, 20)
    love.graphics.rectangle(type, -40, -25, 10, 20)

    love.graphics.setColor(r, g, b, a)
    love.graphics.pop()
end