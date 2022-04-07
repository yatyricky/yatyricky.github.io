require("gist/Lua/lib/table_ext")

local t = {}

for i = 1, 10000 do
    local r = math.random(-1, -5)
    table.addNum(t, r, 1)
end

print(table.toJSON(t))
