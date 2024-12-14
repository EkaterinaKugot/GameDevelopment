Particle = {}
Particle.__index = Particle

function Particle:create(position)
    local particle= {}
    setmetatable(particle, Particle)
    particle.position = position
    particle.acceleration = Vector:create(0, 0.05)
    particle.velocity = Vector:create(math.random(-400, 400) / 100, math.random(-200, 0) / 100)

    particle.maxlifespan = math.random(100, 400)
    particle.lifespan = math.random(0, particle.maxlifespan) 
    particle.texture = love.graphics.newImage("assets/texture.png")
    return particle
end

function Particle:update()

    self.velocity:add(self.acceleration)
    self.position:add(self.velocity)
    self.lifespan = self.lifespan - 1
    
end

function Particle:draw()
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0.34, 0.77, 0.12, self.lifespan / self.maxlifespan)
    love.graphics.draw(self.texture, self.position.x, self.position.y)
    love.graphics.setColor(r, g, b, a)
end

function Particle:isDead()
    if self.lifespan < 0 then
        return true
    end
    return false
end

function Particle:applyForce(force)
    self.acceleration:add(force)
end

ParticleSystem = {}
ParticleSystem.__index = ParticleSystem

function ParticleSystem:create(origin, n, cls)
    local system = {}
    setmetatable(system, ParticleSystem)
    system.origin = origin
    system.n = n or 10
    system.index = 0
    system.particles = {}
    system.cls = cls or Particle
    return system
end

function ParticleSystem:createParticle()
    return self.cls:create(self.origin:copy())
end

function ParticleSystem:draw()
    for k, v in pairs(self.particles) do
        v:draw()
    end
end

function ParticleSystem:apply(repeller)
    local dir
    for k, v in pairs(self.particles) do
        dir = repeller:repel(v)
        v:applyForce(dir)
    end
end

function ParticleSystem:update()
    if #self.particles < self.n then
        self.particles[self.index] = self:createParticle()
        self.index = self.index + 1
    end

    for k, v in pairs(self.particles) do
        if v:isDead() then
            self.particles[k] = self:createParticle()
        end
        v:update()
        
    end
end

SegmentParticle = {}
SegmentParticle.__index = SegmentParticle

function SegmentParticle:create(loc1, loc2)
    local segment = {}
    setmetatable(segment, SegmentParticle)
    segment.loc1 = loc1:copy()
    segment.loc2 = loc2:copy()
    segment.acceleration = Vector:create(0, 0.05)
    segment.velocity = Vector:create(math.random(-200, 200) / 100, math.random(-100, 0) / 100)
    segment.lifespan = 100 
    return segment
end

function SegmentParticle:update()
    self.velocity:add(self.acceleration)
    self.loc1:add(self.velocity)
    self.loc2:add(self.velocity)
    self.lifespan = self.lifespan - 0.02
end

function SegmentParticle:isDead()
    return self.lifespan < 1
end

function SegmentParticle:draw()
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(1, 1, 1, self.lifespan / 100)
    love.graphics.line(self.loc1.x, self.loc1.y, self.loc2.x, self.loc2.y)
    love.graphics.setColor(r, g, b, a)
end

SegmentParticleCircle = {}
SegmentParticleCircle.__index = SegmentParticleCircle

function SegmentParticleCircle:create(loc)
    local segment = {}
    setmetatable(segment, SegmentParticleCircle)
    segment.loc = loc:copy()
    segment.acceleration = Vector:create(0, 0.05)
    segment.velocity = Vector:create(math.random(-200, 200) / 100, math.random(-100, 0) / 100)
    segment.lifespan = 100 
    return segment
end

function SegmentParticleCircle:update()
    self.velocity:add(self.acceleration)
    self.loc:add(self.velocity)
    self.lifespan = self.lifespan - 0.02
end

function SegmentParticleCircle:isDead()
    return self.lifespan < 1
end

function SegmentParticleCircle:draw()
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0, 0, 1, self.lifespan / 100)
    love.graphics.circle("fill", self.loc.x, self.loc.y, 5)
    love.graphics.setColor(r, g, b, a)
end

