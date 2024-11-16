Repeller = {}
Repeller.__index = Repeller

function Repeller:create(x, y, strength, r)
    local repeller = {}
    setmetatable(repeller, Repeller)
    repeller.position = Vector:create(x, y)
    repeller.strength = strength or 10
    repeller.r = r or 40
    return repeller
end

function Repeller:repel(particle)
    local dir = self.position - particle.position
    local d = dir:mag()
    -- if d <= self.r * 2.01 then
    --     d = 1
    -- end
    dir = dir:norm()
    local force = -1 * self.strength / (d * d)
    dir:mul(force)
    return dir
end