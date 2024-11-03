require "vector"
require "mover"
require "obstacle"

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    gravity = Vector:create(0, 0.01)

    mover  = Mover:create(Vector:create(width/4, 100), Vector:create(), 5)
    obstacle = Obstacle:create()

end

function love.update()
    if love.keyboard.isDown("left") then
        mover.angle = mover.angle - 0.05
    end
    if love.keyboard.isDown("right") then
        mover.angle = mover.angle + 0.05
    end

    if love.keyboard.isDown("up") then
        local x = 0.1 * math.cos(mover.angle)
        local y = 0.1 * math.sin(mover.angle)
        mover:applyForce(Vector:create(x, y))
        mover.active = true
    else
        mover.active = false
    end

    mover:check_boundaries()
    mover:update()
    obstacle:check_boundaries()
    obstacle:update()
end

function love.draw()
    mover:draw(obstacle.position.x, obstacle.position.y, obstacle.r, obstacle.angle)
    obstacle:draw()
end