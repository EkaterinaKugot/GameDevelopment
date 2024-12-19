Maze = {}
Maze.__index = Maze

local h_dir, v_dir = 0, 1

function Maze:create(width_, height_, complexity, density)
    local maze = {}
    setmetatable(maze, Maze)
    maze.width = math.floor(width_ / 2) * 2 + 1
    maze.height = math.floor(height_ / 2) * 2 + 1
    maze.complexity = complexity or 0.75
    maze.density = complexity or 0.75
    maze.maze = {}
    for i = 1, maze.width do
        maze.maze[i] = {}
        for j = 1, maze.width do
            maze.maze[i][j] = 0
        end
    end
    return maze
end

function Maze:gen(seed)
    local seed = seed or os.time()
    love.math.setRandomSeed(seed)

    self:wall(v_dir, 1, 1, self.height);
	self:wall(v_dir, self.height, 1, self.height);
	self:wall(h_dir, 1, 1, self.width);
    self:wall(h_dir, self.width, 1, self.width);
    
    local complexity = math.floor(self.complexity * (5 * (self.width + self.height)))
    local density = math.floor(self.density * (math.floor(self.width / 2) * math.floor(self.height / 2)))

    for i = 1, density + 1 do
        x = love.math.random(1, math.floor(self.width / 2)) * 2 + 1
        y = love.math.random(1, math.floor(self.height / 2)) * 2 + 1
        self.maze[y][x] = 1
        for j = 1, complexity + 1 do
            neighbours = {}
            if x > 2 then
                table.insert(neighbours, {y, x - 2})
            end
            if x < self.width - 1 then
                table.insert(neighbours, {y, x + 2})
            end
            if y > 2 then
                table.insert(neighbours, {y - 2, x})
            end
            if y < self.height - 1 then
                table.insert(neighbours, {y + 2, x})
            end
            if #neighbours > 0 then
                local yx = neighbours[love.math.random(1, #neighbours)]
                local y_ = yx[1]
                local x_ = yx[2]
                if self:isFloor(x_, y_) then
                    self.maze[y_][x_] = 1
                    self.maze[y_ + math.floor((y - y_) / 2)][x_ + math.floor((x - x_) / 2)] = 1
                    x = x_
                    y = y_
                end
            end
        end
    end

end

function Maze:wall(direction, num, from, to)
    if direction == h_dir then
        for i = from, to do
            self.maze[i][num] = 1
        end
    end
    if direction == v_dir then
        for i = from, to do
            self.maze[num][i] = 1
        end
    end
end

function Maze:isWall(x, y)
    return self.maze[y][x] == 1
end

function Maze:isFloor(x, y)
    return self.maze[y][x] == 0
end