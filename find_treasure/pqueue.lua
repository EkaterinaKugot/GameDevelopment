PQueue = {}
PQueue.__index = PQueue

function PQueue:create()
    local pqueue = {}
    setmetatable(pqueue, PQueue)
    return pqueue
end

function PQueue:put(p, v)
    local q = self[p]
    if not q then
        q = {first = 1, last = 0}
        self[p] = q
    end
    q.last = q.last + 1
    q[q.last] = v
end

function PQueue:get()
    for p, q in pairs(self) do
        if q.first <= q.last then
            local v = q[q.first]
            q[q.first] = nil
            q.first = q.first + 1
            return p, v
        else
            self[p] = nil
        end
    end
end

function PQueue:size()
    local size = 0
    for p, q in pairs(self) do
        size = size + 1
    end
    return size
end