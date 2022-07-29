require("gist/Lua/lib/table_ext")

local mathSqrt = math.sqrt

local function fastSqrt(value)
    local r = 0.141
    for i = 1, 4 do
        r = (r + value / r) / 2
    end
    return r
end

-- for i = 0.02, 0.4, 0.02 do
--     local precise = mathSqrt(i)
--     local fuzzy = fastSqrt(i)
--     local error = (fuzzy - precise) / precise
--     local scale = (fuzzy - precise) * 1000
--     print(precise,",", fuzzy,",", error,",", scale)
-- end

local iterations = 10000000

local now = os.clock()

for i = 1, iterations do
    math.sqrt(0.04)
end

print("math.sqrt takes", os.clock() - now)

now = os.clock()

for i = 1, iterations do
    fastSqrt(0.04)
end

print("fast.sqrt takes", os.clock() - now)
