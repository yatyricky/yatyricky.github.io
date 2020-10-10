-- local number_offset = math.floor(math.random() * 54321 + 12345)
local number_offset = 0

---encode_num
---@param num number
---@return TENum
local function encode(num)
    local str = tostring(num + number_offset)
    return string.format("%ssagi%s", string.sub(str, 1, 1), string.sub(str, 2, string.len(str)))
end

---decode_num
---@param value TENum
---@return number
local function decode(value)
    local first = string.sub(value, 1, 1)
    local second = string.sub(value, 6, string.len(value))
    return tonumber(string.format("%s%s", first, second)) - number_offset
end

local numbers = {-75,
-14.66,
-0.5,
0,
0.0004,
1.999,
100.02,
}

for i = 1, #numbers do
    local n = numbers[i]
    print(string.format("original %s, encoded %s, decoded %s", n, encode(n), decode(encode(n))))
end