require "vector"
require "particle"
require "repeller"


function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    repeller = Repeller:create(width/2 - 200, height/2 + 100)
    system = ParticleSystem:create(Vector:create(width/2, height/2), 100, Particle)

end

function love.update()
    system:apply(repeller)
    system:update()
end

function love.draw()
    system:draw()
end