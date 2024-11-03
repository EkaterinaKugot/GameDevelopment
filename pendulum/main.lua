require "vector"
require "pendulum"

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    pendulum = Pendulum:create(Vector:create(200, 0), 300)

end

function love.draw()
    pendulum:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        pendulum:clicked(x, y)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        pendulum:unclicked()
    end
end