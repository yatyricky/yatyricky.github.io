require("gist/Lua/lib/table_ext")
local t= {}
table.insert(t, math.random())
table.insert(t, math.random())
table.insert(t, math.random())
table.insert(t, math.random())
table.insert(t, math.random())

print(table.show(t))

for k,v in pairs(t) do
    t[k] = nil
end
print(table.show(t))

table.insert(t, 1)
table.insert(t, 2)
table.insert(t, 3)
print(table.show(t))
