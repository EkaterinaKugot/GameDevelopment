require "wave"
require "vector"

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    amplitude = 50
    vel = 0.001
    angle = 0
    y1 = 200
    wave = Wave:create(Vector:create(200, y1), Vector:create(500, y1), amplitude, vel, angle)

    y2 = 500
    wave1 = Wave:create(Vector:create(100, y2), Vector:create(600, y2), amplitude, vel, angle)

end

function love.draw()
    wave:draw()
    wave1:draw()
end