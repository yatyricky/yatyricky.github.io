-- require("gist/Lua/Common/Polyfill")
-- require("gist/Lua/lib/string_ext")
-- require("gist/Lua/lib/table_ext")

math.randomseed(os.time())

local nonDropCount = 0

local function tryDrop()
    local chance = 0.2 + 0.2 * nonDropCount
    if math.random() < chance then
        nonDropCount = 0
        return 1
    else
        nonDropCount = nonDropCount + 1
        return 0
    end
end

local function brute(count)
    local sum = 0
    for i = 1, count do
        sum = sum + tryDrop()
    end
    return (sum / count) * 100
end

print(brute(1000000))
