require("gist/Lua/lib/project")
require("gist/Lua/lib/table_ext")
require("gist/Lua/lib/string_ext")

local old = require("gist/Lua/Store_old_basecn").Store
local new = require("gist/Lua/Store_new_basecn").Store

local function ParseStringMap(raw)
    local ret = {}
    local kvs = string.split(raw, ";")
    for _, kv in pairs(kvs) do
        local ts = string.split(kv, ",")
        if #ts == 2 then
            ret[ts[1]] = ts[2]
        else
            logError("bad param #ts is not 2", raw)
        end
    end
    return ret
end

local function replaceParams(tab, prop)
    for _, value in pairs(tab) do
        value[prop] = ParseStringMap(value[prop])
    end
end

replaceParams(old, "Params")
replaceParams(old, "ShowParams")
replaceParams(new, "Params")
replaceParams(new, "ShowParams")

table.sort(old, function(a, b)
    return a.ID < b.ID
end)
table.sort(new, function(a, b)
    return a.ID < b.ID
end)

table.isSubsetOf(old, new)
-- table.isSubsetOf(new, old)
