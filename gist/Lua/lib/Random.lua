require("gist/Lua/lib/class")

-- https://en.wikipedia.org/wiki/Linear_congruential_generator
-- glibc (used by GCC)[15]
local math_floor = math.floor

local MULTIPLIER = 1103515245
local INCREMENT = 12345
local MODULUS = 2147483648

local cls = class("Random")

function cls:ctor(seed)
    self.seed = seed or 0
end

---Initializes the random number generator state with a seed.
function cls:InitState(seed)
    self.seed = seed
end

function cls:NextSeed()
    local next = (self.seed * MULTIPLIER + INCREMENT) % MODULUS
    self.seed = next
    return next
end

---Returns a random number between 0.0 [inclusive] and 1.0 [exclusive] (Read Only).
---@return float
function cls:value()
    return self:NextSeed() / MODULUS
end

---Return a random int number between min [inclusive] and max [exclusive].
---@param min int
---@param max int
---@return int
function cls:Range(min, max)
    return math_floor(self:value() * (max - min)) + min
end

---@return bool
function cls:Bool()
    return self:value() < 0.5
end

return cls
