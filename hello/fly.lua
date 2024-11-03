-- fly.lua

Fly = {}
Fly.__index = Fly

function Fly:create(path, x, y, speed)
    local fly = {}
    setmetatable(fly, Fly)
    fly.path = path
    fly.x = x or 0
    fly.y = y or 0
    fly.image = love.graphics.newImage(path)
    fly.speed = speed or 1
    fly.tx = love.math.random(-10, 10)
    fly.ty = love.math.random(-10, 10)
    fly.stepx = love.math.random()
    fly.stepy = love.math.random()
    noisex = Noise:create(1, 1, 256)
    noisey = Noise:create(1, 1, 256)
    return fly
end


function Fly:update(width, height)

    self.tx = self.tx + self.stepx / 200
    self.ty = self.ty + self.stepy / 200
    
    local x = noisex:call(self.tx)
    local y = noisey:call(self.ty)
    self.x = remap(x, 0, 1, 50, width-50)
    self.y = remap(y, 0, 1, 50, height-50)
    -- local step = love.math.random()
    -- if step < 0.5 then
    --     self.x = self.x + self.speed
    -- elseif step > 0.5 and step < 0.65 then
    --     self.x = self.x - self.speed
    -- elseif step > 0.65 and step < 0.85 then
    --     self.y = self.y + self.speed
    -- else
    --     self.y = self.y - self.speed
    -- end
end

function Fly:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

HerdFlies = {}
HerdFlies.__index = HerdFlies

function HerdFlies:create(path, xmin, xmax, ymin, ymax, n, speed)
    local flies = {}
    setmetatable(flies, HerdFlies)
    flies.n = n
    flies.objs = {}
    for i=1, n do
        local x = love.math.random(xmin, xmax)
        local y = love.math.random(ymin, ymax)
        flies.objs[i] = Fly:create(path, x, y, speed)
    end
    return flies
end

function HerdFlies:draw()
    for i=1, self.n do
        self.objs[i]:draw()
    end
end

function HerdFlies:update(width, height)
    for i=1, self.n do
        self.objs[i]:update(width, height)
    end
end