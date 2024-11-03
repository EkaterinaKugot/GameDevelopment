require "vector"
require "mover"

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    mover1 = Mover:create(Vector:create(250, 300), Vector:create(), 1)
    mover2 = Mover:create(Vector:create(550, 300), Vector:create(), 2)

    wind = Vector:create(0.001, 0)
    isWind = false
    gravity = Vector:create(0, 0.001)
    isGravity = false
    floating = Vector:create(0, -0.002)
    isFloating = false
end

function love.update()
    if isGravity then
        mover1:applyForce(gravity)
        mover2:applyForce(gravity)
    end
    if isFloating then
        mover1:applyForce(floating)
        mover2:applyForce(floating)
    end
    if isWind then
        mover1:applyForce(wind)
        mover2:applyForce(wind)
    end

    if mover1.position.x < width / 2 then
        local friction = (mover1.velocity * -1):norm()
        if friction then
            friction:mul(0.0005)
            mover1:applyForce(friction)
        end
    end
    
    if mover2.position.x < width / 2 then
        local friction = (mover2.velocity * -1):norm()
        if friction then
            friction:mul(0.0005)
            mover2:applyForce(friction)
        end
    end

    if mover1.position.x >= width / 2 then
        local friction = (mover1.velocity * -1):norm()
        if friction then
            friction:mul(-0.0005)
            mover1:applyForce(friction)
        end
    end
    
    if mover2.position.x >= width / 2 then
        local friction = (mover2.velocity * -1):norm()
        if friction then
            friction:mul(-0.0005)
            mover2:applyForce(friction)
        end
    end

    mover1:force_boundaries()
    mover2:force_boundaries()
    
    mover1:update()
    mover2:update()
end

function love.draw()
    mover1:draw()
    mover2:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("w: " .. tostring(isWind) .. " g: " .. 
    tostring(isGravity) .. " f: " .. tostring(isFloating))
end

function love.keypressed(key) 
    if key == 'g' then
        isGravity = not isGravity
    end

    if key == 'f' then
        isFloating = not isFloating
    end

    if key == 'w' then
        isWind = not isWind
        if isWind then
            wind:mul(-1)
        end
    end
end