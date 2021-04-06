require("gist/Lua/lib/table_ext")

local t = {1,2,3,4,5,6,7,7,2,4,6,5,5}

print(table.concat(t, ","))

local ret = table.filterInPlace(t, function(v)
    return v > 4
end)

print(table.concat(t, ","))
print(table.concat(ret, ","))