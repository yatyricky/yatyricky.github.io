require("gist/Lua/lib/table_ext")

local iterations = 10000000
local now

now = os.clock()
local temp = {"",".",""}
for i = 1, iterations do
    local s = "left" .. "." .. "right"
end
print(".. takes", os.clock() - now)

now = os.clock()
for i = 1, iterations do
    local s = string.format("%s.%s", "left", "right")
end
print("string.format takes", os.clock() - now)

now = os.clock()
local temp = {"",".",""}
for i = 1, iterations do
    temp[1] = "left"
    temp[3] = "right"
    local s = table.concat(temp)
end
print("table.concat takes", os.clock() - now)
