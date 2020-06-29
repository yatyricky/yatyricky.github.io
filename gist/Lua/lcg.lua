local seed = 0
local multiplier = 134775813
local increment = 1
local modulus = 4294967296

seed = 123456
print("seed = "..seed)

local function value() 
    local next = (multiplier * seed + increment) % modulus
    seed = next
    return next / modulus
end

local function Range(min,max)
    return math.floor(value() * (max-min)) + min
end

for i = 1, 20 do
    print(Range(0,10))
end