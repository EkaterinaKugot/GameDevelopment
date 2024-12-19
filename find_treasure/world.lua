World = {}
World.__index = World

function World:create(map)
    local world = {}
    setmetatable(world, World)

    
    map = map or self:gen(30, 30)

    world.map = map
    world.height = #map
    world.width = #map[1]
    world.player = nil
    world.start_position = {0, 0}
    world.coin = {-1, -1}
    world.visited = {}
    for i = 1, world.height do
        world.visited[i] = {}
        for j = 1, world.width do
            world.visited[i][j] = false
        end
    end
    return world
end

function World:gen(width, height)
    local maze = Maze:create(width, height, 0.4, 1)
    maze:gen()
    local mmap = maze.maze

    local map = {}

    for i = 1, maze.height do
        map[i] = {}
        for j = 1, maze.width do
            map[i][j] = 0
        end
    end

    -- left, down, up, right
    local convert = {{1, 0, 0, 1, 7},
                     {1, 1, 0, 0, 4},
                     {0, 1, 0, 1, 3},
                     {1, 0, 1, 0, 6},
                     {0, 0, 1, 1, 5},
                     {0, 0, 0, 1, 11},
                     {1, 0, 0, 0, 12},
                     {0, 1, 0, 0, 9},
                     {0, 0, 1, 0, 10},
                     {1, 1, 0, 1, 13},
                     {1, 0, 1, 1, 14},
                     {1, 1, 1, 0, 15},
                     {0, 1, 1, 1, 16}}

    for i = 1, maze.height do
        for j = 1, maze.width do
            if i == 1 and j == 1 then
                map[i][j] = 3
            elseif i == 1 and j == maze.width then
                map[i][j] = 4
            elseif i == maze.height and j == 1 then
                map[i][j] = 5
            elseif i == maze.height and j == maze.width then
                map[i][j] = 6
            elseif i == 1 or i == maze.height then
                map[i][j] = 7
            elseif j == 1 or j == maze.width then
                map[i][j] = 8
            elseif mmap[i][j] == 1 then
                local cond = false
                for k = 1, #convert do
                    c = convert[k]
                    if mmap[i][j - 1] == c[1] and mmap[i + 1][j] == c[2] and  mmap[i - 1][j] == c[3] and mmap[i][j + 1] == c[4] then
                        map[i][j] = c[5]
                        cond = true
                        break
                    end
                end
                if not cond then
                    map[i][j] = 8
                end
            end
            
        end
    end
    return map
end

function dist(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function World:placeObjects()
    local px = 0
    local py = 0
    while true do
        px = love.math.random(1, self.width) - 1
        py = love.math.random(1, self.height) - 1
        if not self:isWall(px, py) then
            self.player = Player:create(self:localToGlobal(px, py))
            self.start_position = {px, py}
            break
        end
    end

    local max_dist = 0
    local dx = 0
    local dy = 0
    for i = 1, self.width do
        for j = 1, self.height do
            local x = i - 1
            local y = j - 1
            if not self:isWall(x, y) then
                local d = dist(px, py, x, y)
                if d > max_dist then
                    dx = x
                    dy = y
                    max_dist = d
                end
            end
        end
    end
    world.coin = {dx, dy}
end

function World:visit(x, y)
    local x = x + 1
    local y = y + 1
    local coords = {{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}}
    self.visited[y][x] = true
    for i = 1, #coords do
        local c = coords[i]
        self.visited[c[2]][c[1]] = true
    end
end

function World:update(player)
    local tx, ty = self:globalToLocal(player.x, player.y)
    self:visit(tx, ty)
    if self:isWall(tx, ty) then
        local x, y = self.localToGlobal(tx, ty)
        self.player.x = x
        self.player.y = y
        self.player.tx = x
        self.player.ty = y
    end
end

function World:getLeftIndex(player)
    local tx, ty = self:globalToLocal(self.player.x, self.player.y)
    tx = tx - 1
    if not self:isWall(tx, ty) then
        return self:localToIndex(tx, ty)
    end
end

function World:getRightIndex(player)
    local tx, ty = self:globalToLocal(self.player.x, self.player.y)
    tx = tx + 1
    if not self:isWall(tx, ty) then
        return self:localToIndex(tx, ty)
    end
end

function World:getUpIndex(player)
    local tx, ty = self:globalToLocal(self.player.x, self.player.y)
    ty = ty - 1
    if not self:isWall(tx, ty) then
        return self:localToIndex(tx, ty)
    end
end

function World:getDownIndex(player)
    local tx, ty = self:globalToLocal(self.player.x, self.player.y)
    ty = ty + 1
    if not self:isWall(tx, ty) then
        return self:localToIndex(tx, ty)
    end
end

function World:getEnv()
    local env = {}
    local lx, ly = self:globalToLocal(self.player.x, self.player.y)
    env.position = {lx, ly}
    env.left = self:getLeftIndex() == nil
    env.right = self:getRightIndex() == nil
    env.up = self:getUpIndex() == nil
    env.down = self:getDownIndex() == nil
    env.coin = self:checkCoin(lx, ly)
    return env
end

function World:checkCoin(lx, ly)
    local index = self:localToIndex(self.coin[1], self.coin[2])
    if index == self:localToIndex(lx, ly) then
        return "underfoot"
    elseif index == self:getLeftIndex() then
        return "left"
    elseif index == self:getRightIndex() then
        return "right"
    elseif index == self:getUpIndex() then
        return "up"
    elseif index == self:getDownIndex() then
        return "down"
    end
    return "nope"
end

function World:move(direction)
    if direction == "left" then
        index = world:getLeftIndex()
    elseif direction == "right" then
        index = world:getRightIndex()
    elseif direction == "up" then
        index = world:getUpIndex()
    elseif direction == "down" then
        index = world:getDownIndex() 
    end
    if index then
        player:setFollow(index)
    end
end

function World:draw()
    for i = 1, self.height do
        for j = 1, self.width do
            if self.visited[i][j] then
                local cell = world.map[i][j]
                texture = env.textures[cell]
                love.graphics.draw(env.tileset, texture, 16 * (j - 1), 16 * (i - 1))
            end
        end
    end
    if self.visited[self.coin[2] + 1][self.coin[1] + 1] then
        love.graphics.draw(env.tileset, env.textures[18], 16 * (self.coin[1]), 16 * (self.coin[2]))
    end
end

function World:isWall(x, y)
    local cell = self.map[y + 1][x + 1]
    return cell >=3 and cell <= 12
end

function World:isSpike(x, y)
    local cell = self.map[y + 1][x + 1]
    return cell == 14
end

function World:getNeighbours(n)
    local x, y = self:indexToLocal(n)
    local coords = {{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}}
    local neighbours = {}
    for i = 1, #coords do
        local coord = coords[i]
        if not self:isWall(coord[1], coord[2]) then
            table.insert(neighbours, self:localToIndex(coord[1], coord[2]))
        end
    end
    return neighbours
end

function World:localToIndex(x, y)
    return x + self.width * y
end

function World:indexToLocal(n)
    local y = math.floor(n / self.width)
    local x = n % self.width
    return x, y
end

function World:globalToLocal(x, y)
    return math.floor(x / 16), math.floor(y / 16)
end

function World:localToGlobal(x, y)
    return (x * 16) + 8, (y * 16) + 8
end