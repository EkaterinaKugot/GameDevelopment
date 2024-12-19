Player = {}
Player.__index = Player

function Player:create(x, y)
    local player = {}
    setmetatable(player, Player)
    player.x = x
    player.y = y
    player.tx = x
    player.ty = y
    player.duration = 0.5
    player.currentTime = 0
    player.state = "idle"
    player.current = 1
    -- player.follow = {}
    player.follow = nil
    return player
end

function Player:setTarget(x, y)
    self.tx = x
    self.ty = y
end

function Player:setFollow(index)
    if index and self.state == "idle" then
        self.follow = index
        -- table.insert(self.follow, index)
    end
end

function Player:update(dt, world)
    if self.state == "move" then
        self.currentTime = self.currentTime + dt
        if self.currentTime >= self.duration then
            self.currentTime = self.currentTime - self.duration
        end
    end
    
    -- if #self.follow > 0 then
        if self.state == "idle" and self.follow then
            -- local x, y = world:indexToLocal(table.remove(self.follow, 1))
            local x, y = world:indexToLocal(self.follow)
            local gx, gy = world:localToGlobal(x, y)
            self:setTarget(gx, gy)
            self.follow = nil
        end
    -- end

    self.state = "idle"

    if self.x ~= self.tx then
        if self.x > self.tx then
            self.x = self.x - 1
        else
            self.x = self.x + 1
        end
        self.state = "move"
    end
    if self.y ~= self.ty then
        if self.y > self.ty then
            self.y = self.y - 1
        else
            self.y = self.y + 1
        end
        self.state = "move"
    end
end

function Player:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    local spriteNum = 1
    if self.state == "move" then
        spriteNum = math.floor(self.currentTime / self.duration * #pl.textures) + 1
        if spriteNum > #pl.textures then
            spriteNum = #pl.textures
        end
    end
    print(spriteNum)
    love.graphics.draw(pl.tileset, pl.textures[spriteNum], -12, -12, 0, 0.5, 0.5)
    love.graphics.pop()
end