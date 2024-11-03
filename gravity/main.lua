require "vector"
require "mover"
require "attracter"

-- function love.load()
--     width = love.graphics.getWidth()
--     height = love.graphics.getHeight()
--     mover1 = Mover:create(Vector:create(400, 300), Vector:create(), 1)
--     attracter1= Attracter:create(Vector:create(250, 200), 1)
--     attracter2= Attracter:create(Vector:create(550, 400), 1)
-- end

-- function love.update()
--     local strength1 = attracter1:attract(mover1)
--     local strength2 = attracter2:attract(mover1)
--     print(strength1)
--     print(strength2)
--     mover1:applyForce(strength1)
--     mover1:applyForce(strength2)
--     mover1:force_boundaries()
--     mover1:update()
-- end

-- function love.draw()
--     mover1:draw()
--     attracter1:draw()
--     attracter2:draw()
-- end


function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    movers = Movers:create(200, width-200, 200, height-200, 10, 1)
end

function love.update()
    movers:update()
end

function love.draw()
    movers:draw()
end