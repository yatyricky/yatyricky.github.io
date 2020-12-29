require("gist.Lua.lib.table_ext")

local a = 12
local b = "asb"
local c = null
local d = {}
-- local e
local f = false

local t_concat = table.concat
local t_insert = table.insert

local tempStrQuotes = { "\"", 0, "\"" }

local function strAddQuoates(str)
    tempStrQuotes[2] = str
    return t_concat(tempStrQuotes)
end

local function concats(...)
    local list = {}
    local maxKey = 0
    for k, v in pairs({ ... }) do
        local str = v
        local t = type(str)
        if t == "string" then
            str = strAddQuoates(str)
        elseif t == "table" then
            str = table.show(str)
        else
            str = tostring(str)
        end
        list[k] = str
        if k > maxKey then
            maxKey = k
        end
    end
    for i = 1, maxKey do
        if not list[i] then
            list[i] = "nil"
        end
    end
    return t_concat(list, ", ")
end

local function log(...)
    print(concats(...))
end

log(aaz, zxcas, "")