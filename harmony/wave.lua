--wave.lua

Wave = {}
Wave.__index = Wave

function Wave:create(start, end1, amplitude, vel, angle)
    local wave = {}
    setmetatable(wave, Wave)
    wave.start = start
    wave.end1 = end1
    wave.amplitude = amplitude
    wave.vel = vel
    wave.angle = angle
    return wave
end


function Wave:draw()
    for x=self.start.x, self.end1.x, 10 do
        local y = self.amplitude * math.sin((self.angle + x / 24 / 10) * 4)

        love.graphics.setColor(x, (y + self.amplitude) / self.amplitude, x, 0.5)
        love.graphics.circle("fill", x, y + self.start.y, 10)
    end
    self.angle = self.angle + self.vel
end