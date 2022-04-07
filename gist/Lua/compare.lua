require("gist/Lua/lib/math_ext")
require("gist/Lua/lib/table_ext")

require("gist/Lua/lib/compat")

local left = require("gist/Lua/left").StoreByID
local right = require("gist/Lua/right").StoreByID

local function leftProcess(t)
    local keys = table.keys(t)
    table.sort(keys)
    return table.concat(table.imap(keys, function(i, v)
        return tostring(v).."="..tostring(t[v])
    end), ";")
end

for key, v in pairs(left) do
    v.Items = leftProcess(v.Items)
    v.BetterItems = leftProcess(v.BetterItems)
    v.FirstItems = leftProcess(v.FirstItems)
end

local function rightProcess(t)
    table.sort(t, function(a,b)
        return a.k < b.k
    end)
    return table.concat(table.imap(t, function(i, v)
        return tostring(v.k).."="..tostring(v.v)
    end), ";")
end

for _, v in pairs(right) do
    v.Items = rightProcess(v.Items)
    v.BetterItems = rightProcess(v.BetterItems)
    v.FirstItems = rightProcess(v.FirstItems)
end

table.compare(left, right)

print("done")