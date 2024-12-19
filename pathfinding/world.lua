World = {}
World.__index = World

function World:create(map)
    local world = {}
    setmetatable(world, World)
    world.map = map
    world.height = #map
    world.width = #map[1]
    return world
end

function World:draw()
    for i = 1, self.height do
        for j = 1, self.width do
            local cell = world.map[i][j]
            texture = env.textures[cell]
            love.graphics.draw(env.tileset, texture, 16 * (j - 1), 16 * (i - 1))
        end
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

function World:getPath(from, to)
    local ifrom = self:localToIndex(from[1], from[2])
    local ito = self:localToIndex(to[1], to[2])
    local path = {}
    local frontier = PQueue:create()
    frontier:put(0, ifrom)
    local visited = {}
    visited[ifrom] = -1
    local costs = {}
    costs[ifrom] = 0

    while frontier:size() > 0 do
        local p, current = frontier:get()
        -- if current == ito then
        if frontier:size() == 0 then
            break
        end
        local nbs = self:getNeighbours(current)
        if #nbs > 0 then
            for i=1, #nbs do
                local next = nbs[i]
                local x, y = self:indexToLocal(next)
                local cost = 1
                if self:isSpike(x, y) then
                    cost = 10
                end
                new_cost = costs[current] + cost
                if costs[next] == nil or new_cost < costs[next] then
                    costs[next] = new_cost
                    local priority = new_cost
                    frontier:put(priority, next)
                    visited[next] = current
                end
            end
        end
    end
    local current = ito
    local fromidx = ifrom
    while current ~= fromidx do
        table.insert(path, current)
        current = visited[current]
    end 
    table.insert(path, ifrom)
    return path
end

function World:inTable(table, key)
    for k, v in pairs(table) do
        if k[1] == key[1] and k[2] == key[2] then
            return true
        end
    end
    return false
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
