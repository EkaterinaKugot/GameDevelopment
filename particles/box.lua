Box = {}
Box.__index = Box

function Box:create(origin, size)
    local box = {}
    setmetatable(box, Box)
    box.origin = origin
    box.size = size
    box.csize = size
    box.state = "live"
    return box
end

function Box:draw()
    if self.state ~= "dead" then
        r, g, b, a = love.graphics.getColor()
        love.graphics.rectangle("line", self.origin.x - self.size/2, self.origin.y - self.size/2, self.size, self.size)
        love.graphics.setColor(0, 0, 1)
        local p1x, p1y = self.origin.x - self.size/2, self.origin.y - self.size/2
        local p2x, p2y = p1x + self.size, p1y
        local p3x, p3y = p2x, p2y + self.size
        local p4x, p4y = p1x, p3y
        
        love.graphics.circle("fill", p1x, p1y, 5)
        love.graphics.circle("fill", p2x, p2y, 5)
        love.graphics.circle("fill", p3x, p3y, 5)
        love.graphics.circle("fill", p4x, p4y, 5)

        love.graphics.setColor(r, g, b, a)
    end
end

function Box:clicked(mousex, mousey)
    if mousex > self.origin.x - self.size/2 and mousex < self.origin.x + self.size/2 and
        mousey > self.origin.y - self.size/2 and mousey < self.origin.y + self.size/2 then
        self.state = "die"
    end
end

function Box:isDead()
    return self.state == "dead"
end

function Box:update()
    if self.state == "die" then
        self.size = self.size - 0.3
    end

    if self.size < 0 and self.state ~= "dead" then 
        self.state = "dead"

        local p1 = Vector:create(self.origin.x - self.csize/2, self.origin.y - self.csize/2)
        local p2 = Vector:create(p1.x + self.csize, p1.y)
        local p3 = Vector:create(p2.x, p2.y + self.csize)
        local p4 = Vector:create(p1.x, p3.y)
        Psystem:addParticle(SegmentParticle:create(p1, p2))
        Psystem:addParticle(SegmentParticle:create(p2, p3))
        Psystem:addParticle(SegmentParticle:create(p3, p4))
        Psystem:addParticle(SegmentParticle:create(p4, p1))

        Psystem:addParticle(SegmentParticleCircle:create(p1))
        Psystem:addParticle(SegmentParticleCircle:create(p2))
        Psystem:addParticle(SegmentParticleCircle:create(p3))
        Psystem:addParticle(SegmentParticleCircle:create(p4))
    end

    if self.state == "dead" then
        self.state = "live"
        self.size = math.random(50, 150)
        self.csize = self.size
        self.origin = Vector:create(math.random(150, width), math.random(150, height))
    end
end