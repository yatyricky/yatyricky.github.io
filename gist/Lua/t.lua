require("gist.Lua.lib.global")
require("gist.Lua.lib.table_ext")

local tab = {1,2,3,4,5}

print(table.concat(table.slice(tab, 3), ","))
