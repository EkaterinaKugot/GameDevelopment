require("vector")
require("vehicle")
require("path")

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    path = Path:create()
    path:addPoint(Vector:create(0, 200))
    path:addPoint(Vector:create(100, 200))
    path:addPoint(Vector:create(300, 350)) 
    path:addPoint(Vector:create(600, 350))
    path:addPoint(Vector:create(width, 250))

    -- vehicle1 = Vehicle:create(400, 400)
    vehicle2 = Vehicle:create(400, 400)
    vehicle2.maxForce = 0.7
    vehicle2.maxSpeed = 2
end

function love.update(dt)
    -- vehicle1:follow(path)
    -- vehicle1:borders(path)
    vehicle2:follow(path)
    vehicle2:borders(path)
    -- vehicle1:update()
    vehicle2:update()
end

function love.draw()
    path:draw()
    -- vehicle1:draw()
    vehicle2:draw()
end

