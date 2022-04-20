require("gist/Lua/lib/math_ext")
require("gist/Lua/lib/table_ext")

require("gist/Lua/lib/compat")

local left = require("gist/Lua/left").StoreByID
local right = require("gist/Lua/right").StoreByID

local function processTab(t)
    local keys = table.keys(t)
    table.sort(keys)
    return table.concat(table.imap(keys, function(i, v)
        return tostring(v).."="..tostring(t[v])
    end), ";")
end

local function processKV(t)
    table.sort(t, function(a,b)
        return a.k < b.k
    end)
    return table.concat(table.imap(t, function(i, v)
        return tostring(v.k).."="..tostring(v.v)
    end), ";")
end

local function unaryProcess(t)
    if table.isEmpty(t) then
        return t
    end
    local firstK, firstV = next(t)
    if type(firstV) == "table" then
        return processKV(t)
    else
        return processTab(t)
    end
end

for key, v in pairs(left) do
    v.Items = unaryProcess(v.Items)
    v.BetterItems = unaryProcess(v.BetterItems)
    v.FirstItems = unaryProcess(v.FirstItems)
end

for _, v in pairs(right) do
    v.Items = unaryProcess(v.Items)
    v.BetterItems = unaryProcess(v.BetterItems)
    v.FirstItems = unaryProcess(v.FirstItems)
end

table.compare(left, right)

print("done")