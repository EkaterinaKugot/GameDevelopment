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

