require("vector")
require("boid")


function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    bs = {}
    for i = 0, 200 do
        b = Boid:create(width / 2, height / 2)
        bs[i] = b
    end

    isSep = false
    isAlign = false
    isCoh = false
end

function love.update(dt)
    local x, y = love.mouse.getPosition()
    local target = Vector:create(x, y)
    for i = 0, #bs do
        local b = bs[i]
        local steer = b:seek(target)
        b:applyForce(steer)
        b:update(bs)
    end
end


function love.draw()
    for i = 0, #bs do
        bs[i]:draw(bs)
    end

    if isSep then
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(0, 0, 1)
    end
    love.graphics.circle("fill", 10, 10, 5)

    if isAlign then
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(0, 0, 1)
    end
    love.graphics.circle("fill", 20, 10, 5)

    if isCoh then
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(0, 0, 1)
    end
    love.graphics.circle("fill", 30, 10, 5)
end

function love.keypressed(key)
    if key == "1" then
        isSep = not isSep
    end
    if key == "2" then
        isAlign = not isAlign
    end
    if key == "3" then
        isCoh = not isCoh
    end
end

