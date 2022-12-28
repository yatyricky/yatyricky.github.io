local old_require = require

function as_is(any)
    return any
end

function require(mod)
    if mod == "MemorySafe.SafeNumber" then
        return as_is
    end

    return old_require(mod)
end

local mapdb = require("client/Assets/LuaFramework/config/ExportData_wx/Config/ChapterDB")

local dict = {}

local function countTab(tab)
    for k, v in pairs(tab) do
        if type(v) == "table" then
            dict[v] = 1
            countTab(v)
        end
    end
end

countTab(mapdb)

local c = 0
for k, v in pairs(dict) do
    c = c + 1
end

print("tabs count:", c)
