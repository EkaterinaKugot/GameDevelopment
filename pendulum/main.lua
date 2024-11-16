require "vector"
require "pendulum"
require "spring"
require "mover"

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    pendulum = Pendulum:create(Vector:create(350, 0), 300)
    pendulum2 = Pendulum:create(pendulum.position, 200)
    gravity = Vector:create(0, 0.4)
    mover = Mover:create(width / 3, height / 2, 30)
    spring = Spring:create(width / 3, height / 2 - 100, 100)

end

function love.update()
    pendulum:update()
    pendulum2:update()
    spring:connect(mover)
    spring:constrainLength(mover, 20, 400)
    mover:applyForce(gravity)
    mover:update()
    
end

function love.draw()
    pendulum:draw()
    pendulum2:draw()
    spring:draw()
    spring:drawLine(mover)
    mover:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        pendulum:clicked(x, y)
        pendulum2:clicked(x, y)
        mover:clicked(x, y)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        pendulum:unclicked()
        pendulum2:unclicked()
        mover:unclicked()
    end
end