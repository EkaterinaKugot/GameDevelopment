BoxParticleSystem = {}
BoxParticleSystem.__index = BoxParticleSystem

function BoxParticleSystem:create()
    local system = {}
    setmetatable(system, BoxParticleSystem)
    system.particles = {}
    system.index = 0
    return system
end

function BoxParticleSystem:addParticle(particle)
    self.particles[self.index] = particle
    self.index = self.index + 1
end

function BoxParticleSystem:draw()
    for k, v in pairs(self.particles) do 
        v:draw()
    end
end

function BoxParticleSystem:update()
    for k, v in pairs(self.particles) do 
        v:update()
        if v:isDead() then
            self.particles[k] = nil
        end
    end
end