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

local m1, m2

m1 = collectgarbage("count")
print("before", m1)

local tab = require("client.Assets.LuaFramework.config.ExportData.Config.Language")

m2 = collectgarbage("count")
print("after",m2)
print("diff", m2-m1)
