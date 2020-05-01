require("lib/table_ext")

local oldMap = require("MapDB")
local newMap = require("newMap")

-- math.randomseed(os.time())

-- local a = {1,2,3,4,5}

-- for i = 1, 10 do
--     print(table.join(table.randomSubset(a, 4), ", "))
-- end

local res, why = table.equals(oldMap, newMap)

print((res and "true" or "false") .. " - " .. (why and why or "NIL"))
