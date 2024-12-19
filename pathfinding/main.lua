require "world"
require "player"
require "pqueue"
require "maze"

function loadTextures()
    env = {}
    env.tileset = love.graphics.newImage("assets/RogueEnvironment16x16.png")

    local quads = {
        {0,  5*16,  0*16}, -- floor v1
        {1,  6*16,  0*16}, -- floor v2
        {2,  7*16,  0*16}, -- floor v3
        {3,  0*16,  0*16}, -- upper left corner
        {4,  3*16,  0*16}, -- upper right corner
        {5,  0*16,  3*16}, -- lower left corner
        {6,  3*16,  3*16}, -- lower right corner
        {7,  2*16,  0*16}, -- horizontal
        {8,  0*16,  2*16}, -- vertical
        {9,  1*16,  2*16}, -- up
        {10, 2*16,  3*16}, -- down
        {11, 2*16,  1*16}, -- left
        {12, 1*16,  1*16}, -- right
        {13, 1*16,  0*16}, -- down cross
        {14, 3*16, 14*16}, -- spikes
    }
    env.textures = {}
    for i = 1, #quads do
        local q = quads[i]
        env.textures[q[1]] = love.graphics.newQuad(q[2], q[3], 16, 16, env.tileset:getDimensions())
    end

    pl = {}
    pl.tileset = love.graphics.newImage("assets/RoguePlayer_48x48.png")
    pl.textures = {}
    for i = 1, 6 do
        pl.textures[i] = love.graphics.newQuad((i - 1) * 48, 48 * 2, 48, 48, pl.tileset:getDimensions())
    end

end

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    loadTextures()

    local map = {{ 3,  7,  7, 13,  7,  7,  7,  4},
                 { 8,  0,  0,  8,  0,  0,  0,  8},
                 { 8,  0,  0,  8,  0,  0,  0,  8},
                 { 8,  0,  0,  8, 14,  0,  0,  8},
                 { 8,  0,  0, 10,  0,  8,  0,  8},
                 { 8,  0,  0,  0,  0,  8,  0,  8},
                 { 8,  0,  0,  0,  0,  0,  0,  8},
                 { 5,  7,  7,  7,  7,  7,  7,  6}}
    
    -- local map = {{ 3,  7,  7,  7,  7, 7, 4},
    --             { 8,  0,  14,  0,  0, 0, 8},
    --             { 8,  0,  14,  0, 14, 0, 8},
    --             { 8,  0,  0,   0, 14, 0, 8},
    --             { 5,  7,  7,   7,  7, 7, 6}}

    maze = Maze:create(8, 8)
    maze:gen()

    print()
    for i = 1, #maze.maze do
        for j = 1, #maze.maze[i] do
            if maze.maze[i][j] == 1 then
                maze.maze[i][j] = 8
            end
        end
        print()
    end
    --map = maze.maze

    world = World:create(map)
    scaleX = width / (world.width * 16)
    scaleY = height / (world.height * 16)

    player = Player:create(World:localToGlobal(1, 2))
end

function love.update(dt)
    player:update(dt, world)
end

function love.draw()
    love.graphics.scale(scaleX, scaleY)
    world:draw()
    -- drawGraph(graph)
    player:draw(world)
end

function drawGraph(graph)
    r, g, b, a = love.graphics.getColor()
    for k, v in pairs(graph) do
        local cx, cy = world:indexToLocal(k)
        local sx, sy = World:localToGlobal(cx, cy)
        if v[1] then
            local ex, ey = World:localToGlobal(v[1], v[2])
            love.graphics.setColor(0, 0, 1)
            love.graphics.circle("fill", sx, sy, 2)
            love.graphics.setColor(0, 1, 0)
            love.graphics.circle("fill", ex - 4, ey, 2)
            love.graphics.line(sx, sy, ex, ey)
        else
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle("fill", sx, sy-2, 2)
        end
        
    end
    love.graphics.setColor(r, g, b, a)
end

function love.mousepressed(x, y, button)
    local gx = x * 1 / scaleX
    local gy = y * 1 / scaleY
    local lx, ly = World:globalToLocal(gx, gy)
    local tx, ty = World:localToGlobal(lx, ly)
    if world:isWall(lx, ly) then
        return
    end

    if button == 1 then
        player:setTarget(tx, ty)
        print("Is spike?", world:isSpike(lx, ly))
    end

    if button == 2 then
        local px, py = world:globalToLocal(player.x, player.y)
        local path = world:getPath({px, py}, {lx, ly})
        -- for i=1,#path do
        --     print(path[i])
        -- end
        player:setFollow(path)
    end
end
