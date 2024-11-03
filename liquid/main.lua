require "vector"
require "mover"
require "liquid"
require "rect"

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    rect1 = Rect:create(Vector:create(250, 200), Vector:create(), 1, 100, 50)
    rect2 = Rect:create(Vector:create(400, 200), Vector:create(), 1, 50, 100)
    local h = 150
    liquid = Liquid:create(0, height-h, width, h, 0.025)

    gravity = Vector:create(0, 0.001)
end

function love.update()
    rect1:applyForce(gravity)
    rect2:applyForce(gravity)

    local friction = (rect1.velocity * -1):norm()
    if friction then
        friction:mul(0.0005)
        rect1:applyForce(friction)
    end

    local friction = (rect2.velocity * -1):norm()
    if friction then
        friction:mul(0.0005)
        rect2:applyForce(friction)
    end
    
    if liquid:isInside(rect1) then
        local mag = rect1.velocity:mag()
        drag = liquid.c * mag * mag * rect1.w
        local dragVec = (rect1.velocity * -1):norm()
        dragVec:mul(drag)
        rect1:applyForce(dragVec)
    end

    if liquid:isInside(rect2) then
        local mag = rect2.velocity:mag()
        drag = liquid.c * mag * mag * rect2.w
        local dragVec = (rect2.velocity * -1):norm()
        dragVec:mul(drag)
        rect2:applyForce(dragVec)
    end
    
    rect1:force_boundaries() 
    rect1:update()

    rect2:force_boundaries() 
    rect2:update()

    liquid:update()
end

function love.draw()
    rect1:draw()
    rect2:draw()
    liquid:draw()
end