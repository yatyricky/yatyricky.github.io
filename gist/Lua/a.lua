require("gist/Lua/lib/table_ext")

local tab = setmetatable({}, {__mode="v"})

local f1 = function() print("func1") end
local f2 = function() print("func2") end
local f3 = function() print("func3") end

tab[1] = f1
tab[3] = f2
tab[7] = f3

print(table.show(tab))

f1 = nil
collectgarbage()
print(table.show(tab))