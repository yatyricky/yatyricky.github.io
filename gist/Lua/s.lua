require("gist/Lua/Common/Polyfill")
require("gist/Lua/lib/string_ext")
require("gist/Lua/lib/table_ext")

local s = ""
print(table.toJSON(string.split(s, ",")))
