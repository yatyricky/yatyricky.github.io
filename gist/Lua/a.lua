require("lib/table_ext")

math.randomseed(os.time())

local a = {1,2,3,4,5}

for i = 1, 10 do
    print(table.join(table.randomSubset(a, 4), ", "))
end
