Path = {}
Path.__index = Path

function Path:create(d)
    local path = {}
    setmetatable(path, Path)
    path.points = {}
    path._index = 0
    path.d = 20 or d
    return path
end

function Path:addPoint(point)
    self.points[self._index] = point
    self._index = self._index + 1
end

function Path:start()
    return self.points[0]
end

function Path:stop()
    return self.points[self._index - 1]
end

function Path:draw()
    local r, g, b, a = love.graphics.getColor()
    for i=1, #self.points do
        local start = self.points[i-1]
        local stop = self.points[i]

        love.graphics.setLineWidth(self.d)
        love.graphics.setColor(0.31, 0.31, 0.31, 0.7)
        love.graphics.line(start.x, start.y, stop.x, stop.y)
        love.graphics.setBlendMode("replace")
        love.graphics.circle("fill", start.x, start.y, self.d / 2)
        love.graphics.circle("fill", stop.x, stop.y, self.d / 2)

        love.graphics.setColor(0., 0., 0., 0.7)
        love.graphics.setLineWidth(self.d / 10)
        love.graphics.line(start.x, start.y, stop.x, stop.y)
        
    end
    love.graphics.setColor(r, g, b, a)
end