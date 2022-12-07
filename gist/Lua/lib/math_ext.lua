math.clamp = function(value, min, max)
    return math.min(math.max(min, value), max)
end

math.round = function(value)
    return math.floor(value + 0.5)
end

math.fuzzySqrt = function(value)
    
end

function math.easeLinear(t)
    return t
end

function math.easeInQuint(t)
    return t * t * t * t
end

---@param f table<float, float> 分段函数的点
---@param x float x值
---@param ease (fun(t: float): float) | Nil defaults to math.easeLinear
function math.piecewiseFunc(f, x, ease)
    ease = ease or math.easeLinear
    local keys = table.keys(f)
    table.sort(keys)
    local x0 = keys[1]
    local y0 = f[x0]
    local n = #keys
    local x1 = keys[n]
    local y1 = f[x1]
    if x <= x0 then
        return y0
    end
    if x >= x1 then
        return y1
    end
    for i = 2, n do
        x0 = keys[i - 1]
        x1 = keys[i]
        if x0 <= x and x <= x1 then
            y0 = f[x0]
            y1 = f[x1]
            local dx = x1 - x0
            local dy = y1 - y0
            local nx = (x - x0) / dx -- normalized x
            local t = ease(nx)
            return y0 + t * dy
        end
    end
    return y1
end
