require "vector"
require "particle"
require "repeller"
require "box_particles_system"
require "box"


function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    box = Box:create(Vector:create(width/2, height/2), 100)
    Psystem = BoxParticleSystem:create()

end

function love.update()
    box:update()
    Psystem:update()
end

function love.draw()
    box:draw()
    Psystem:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    box:clicked(x, y)
end