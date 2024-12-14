Path = {}
Path.__index = Path

function Path:create(start, stop, d)
    local path = {}
    setmetatable(path, Path)
    path.start = start
    path.stop = stop
    path.d = 20 or d
    return path
end

function Path:draw()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setLineWidth(self.d)
    love.graphics.setColor(0.31, 0.31, 0.31, 0.7)
    love.graphics.line(self.start.x, self.start.y, self.stop.x, self.stop.y)
    love.graphics.setBlendMode("replace")
    love.graphics.circle("fill", self.start.x, self.start.y, self.d / 2)
    love.graphics.circle("fill", self.stop.x, self.stop.y, self.d / 2)

    love.graphics.setColor(0., 0., 0., 0.7)
    love.graphics.setLineWidth(self.d / 10)
    love.graphics.line(self.start.x, self.start.y, self.stop.x, self.stop.y)

    love.graphics.setColor(r, g, b, a)
end