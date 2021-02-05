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

function string.endsWith(str1, str2)
    return string.sub(str1, (#str1 - #str2) + 1, #str1) == str2
end

print(string.endsWith("￥14.00", ".00"))
print(string.endsWith("¥13.99", ".00"))

print("--------")

local function parseStringRet(retVal)
    print("I/SAGISDK lua received ret value", retVal, "eol")
    local t = type(retVal)
    print("type", t)
    if t ~= "string" then
        print("return value from native should be string, got", t, "eol")
        return nil
    end
    print("len", #retVal)
    if #retVal == 0 then
        return nil
    end
    local signature = string.sub(retVal, 1, 1)
    local value = string.sub(retVal, 1)
    print("signature", signature, "value", value)
    if signature == "S" then
        return value
    elseif signature == "Z" then
        return value == "1"
    elseif signature == "D" then
        return tonumber(value)
    else
        print("return value from native is unknown type, got", signature, "eol")
        return value
    end
end

print(parseStringRet("Z1"))
print(parseStringRet("Z0"))
print(parseStringRet("D15.7"))