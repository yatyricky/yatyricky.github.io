require("gist.Lua.lib.math_ext")
require("gist.Lua.lib.table_ext")

local f = { [2] = 10,[40]=20,[90]=40 }

local sum = 0

for i = 1, 100 do
    local res = math.piecewiseFunc(f, i)
    print(tostring(i) .. "," .. tostring(res))
    sum = sum + res
end

print("exp="..tostring(sum / 100))
