require("gist/Lua/lib/table_ext")

local t = {1,2,3,4,5,6,7,7,2,4,6,5,5}

print(table.concat(t, ","))

table.sort(t)

print(table.concat(t, ","))