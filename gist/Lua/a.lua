require("gist.Lua.lib.table_ext")

function table_mulTable(t, o)
    for k, v in pairs(t) do
        local m = o[k]
        if m ~= nil then
            t[k] = v * m
        end
    end
end

local a = {
    x = 1,
    y = 0.5,
    w = 66
}
print(table.toJSON(a))

local m = {
    x = 0.5,
    w = 0.5
}

table_mulTable(a, m)

print(table.toJSON(a))
