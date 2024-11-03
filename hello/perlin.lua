local function nand(x,y,z)
    z=z or 2^16
    if z<2 then
        return 1-x*y
    else
        return nand((x-x%z)/z,(y-y%z)/z,math.sqrt(z))*z+nand(x%z,y%z,math.sqrt(z))
    end
end
math["not"]=function(y,z)
    return nand(nand(0,0,z),y,z)
end
math["and"]=function(x,y,z)
    return nand(math["not"](0,z),nand(x,y,z),z)
end
math["or"]=function(x,y,z)
    return nand(math["not"](x,z),math["not"](y,z),z)
end
math["xor"]=function(x,y,z)
    return math["and"](nand(x,y,z),math["or"](x,y,z),z)
end

function lerp(v0, v1, t)
    return v0 * (1. - t) + v1 * t
end

function cosine(v0, v1, t)
    v = t * t * (3 - 2 * t)
    return lerp(v0, v1, v)
end

function remap(value, omin, omax, nmin, nmax)
    return ((value - omin) / (omax - omin)) * (nmax - nmin) + nmin
end

Noise = {}
Noise.__index = Noise

function Noise:create(amplitude, scale, npoints)
    local noise = {}
    setmetatable(noise, Noise)
    noise.ampl = amplitude
    noise.scale = scale
    noise.np = npoints
    noise.p = {}
    for i=0, npoints do
        noise.p[i] = love.math.random()
    end
    return noise
end

function Noise:call(x)
    x = x * self.scale
    xi = math.floor(x)
    t = x - xi
    xmin = math["and"](xi, self.np - 1)
    xmax = math["and"](xmin + 1, self.np - 1)
    return cosine(self.p[xmin], self.p[xmax], t) * self.ampl
end
