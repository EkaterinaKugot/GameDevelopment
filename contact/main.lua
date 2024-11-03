function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    r1 = 20
    r2 = 30

    xc1 = r1
    yc1 = 50
    vc1 = 1

    xc2 = width - r2
    yc2 = 40
    vc2 = -1


    sr1 = 40
    xr1 = sr1
    yr1 = 150
    vr1 = 1

    sr2 = 40
    xr2 = width - sr2 * 2
    yr2 = 150
    vr2 = -1


    ax = 0
    ay = 250
    bx = 20
    by = 275
    vl1 = 1

    cx = width
    cy = 250
    dx = width - 20
    dy = 275
    vl2 = -1

    p1x = 100
    p1y = 350
    p2x = 0
    p2y = 350
    pv = 1

    r3 = 30
    xc3 = width - r3
    yc3 = 350
    vc3 = -1

end

function love.update()
    xc1 = xc1 + vc1
    xc2 = xc2 + vc2

    if xc1 > width - r1 or xc1 < r1 then
        vc1 = -vc1
    end

    if xc2 > width - r2 or xc2 < r2 then
        vc2 = -vc2
    end

    xr1 = xr1 + vr1
    xr2 = xr2 + vr2

    if xr1 > width - sr1 or xr1 < 0 then
        vr1 = -vr1
    end

    if xr2 > width - sr2 or xr2 < 0 then
        vr2 = -vr2
    end

    ax = ax + vl1
    bx = bx + vl1
    if bx > width or ax < 0 then
        vl1 = -vl1
    end

    cx = cx + vl2
    dx = dx + vl2
    if cx > width or dx < 0 then
        vl2 = -vl2
    end

    if love.keyboard.isDown("space") then

        p1x = p1x + pv
        p2x = p2x + pv
        if p2x > width or p1x < 0 then
            pv = -pv
        end

        xc3 = xc3 + vc3
        if xc3 > width - r3 or xc3 < r3 then
            vc3 = -vc3
        end
    end
end

function circle_collision()
    local dx = xc1 - xc2
    local dy = yc1 - yc2
    local dist = math.sqrt( (dx * dx) + (dy * dy) )

    return dist <= (r1 + r2)
end

function rect_collision()
    local bottom = yr1 + sr1 < yr2
    local top = yr1 > yr2 + sr2
    local left = xr1 > xr2 + sr2
    local rigth = xr1 + sr1 < xr2
    return not (bottom or top or left or rigth)
end

function line_collision()
    local denom = ((dy - cy) * (bx - ax)) - ((dx - cx) * (by - ay))
    local ua = (dx - cx) * (ay - cy) - (dy - cy) * (ax - cx)
    local ua = ua / denom
    local ub = (bx - ax) * (ay - cy) - (by - ay) * (ax - cx)
    local ub = ub / denom
    return (ua >= 0 and ua <= 1) and (ub >= 0 and ub <= 1)
end

function line_circle_collision()
    local locp1x = p1x - xc3
    local locp1y = p1y - yc3

    local locp2x = p2x - xc3
    local locp2y = p2y - yc3

    local p1p2x = locp2x - locp1x
    local p1p2y = locp2y - locp1y

    local a = p1p2x * p1p2x + p1p2y * p1p2y
    local b = 2 * (p1p2x * locp1x + p1p2y * locp1y)
    local c = locp1x * locp1x + locp1y * locp1y - r3 * r3
    local delta = b * b - (4 * a * c)
    if delta < 0 then
        return nil
    elseif delta == 0 then
        local u = -b / ( 2 * a)
        local x = p1x + (u * p1p2x)
        local y = p1y + (u * p1p2y)
        return {{x, y}}
    else
        sqr = math.sqrt(delta)
        local u1 = (-b + sqr) / (2 * a)
        local u2 = (-b - sqr) / (2 * a)
        print(u1, u2)
        if not(u1 > 0 and u1 < 1) and not(u2 > 0 and u2 < 1) then
            return nil
        end
        local x1 = p1x + (u1 * p1p2x)
        local y1 = p1y + (u1 * p1p2y)
        local x2 = p1x + (u2 * p1p2x)
        local y2 = p1y + (u2 * p1p2y)
        return {{x1, y1}, {x2, y2}}
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    if circle_collision() then
        love.graphics.setColor(1, 0, 0)
    end

    love.graphics.circle("fill", xc1, yc1, r1)
    love.graphics.circle("fill", xc2, yc2, r2)

    love.graphics.setColor(1, 1, 1)
    if rect_collision() then
        love.graphics.setColor(1, 0, 0)
    end

    love.graphics.rectangle("fill", xr1, yr1, sr1, sr1)
    love.graphics.rectangle("fill", xr2, yr2, sr2, sr2)

    love.graphics.setColor(1, 1, 1)
    if line_collision() then
        love.graphics.setColor(1, 0, 0)
    end

    love.graphics.setLineWidth(2)
    love.graphics.line(ax, ay, bx, by)
    love.graphics.line(cx, cy, dx, dy)

    love.graphics.setColor(1, 1, 1)
    local result = line_circle_collision()
    if result then
        love.graphics.setColor(0, 1, 0)
        for count = 1, #result do
            x = result[count][1]
            y = result[count][2]
            love.graphics.circle("fill", x, y, 4)
        end
        love.graphics.setColor(1, 0, 0)
    end
    love.graphics.line(p1x, p1y, p2x, p2y)
    love.graphics.circle("fill", xc3, yc3, r3)

    love.graphics.setLineWidth(1)
end