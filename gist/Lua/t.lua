require("gist/Lua/Common/Polyfill")
require("gist/Lua/lib/table_ext")

local function test()
    return true, false, 2
end

local t = {}
t[1] = test()

print(table.toJSON(t))
