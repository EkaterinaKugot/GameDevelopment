-- main.lua

require "fly"
require "perlin"

function love.load()
    background = love.graphics.newImage("resources/background.png")
    love.window.setMode(background:getWidth(), background:getHeight())
    love.graphics.setBackgroundColor(37 / 255, 226 / 255, 247 / 255)

    -- fly = Fly:create("resources/mosquito_small.png", 100, 100)
    -- tx = 0
    -- ty = -1
    
    flies = HerdFlies:create("resources/mosquito_small.png", 0, background:getWidth(), 0, background:getHeight(), 10)

end

function love.update(dt)
    flies:update(background:getWidth(), background:getHeight())
    -- fly:update()
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    
    -- fly:draw()
    flies:draw()
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end