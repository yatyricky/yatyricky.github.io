require("gist.Lua.lib.table_ext")

local function string_split(inputstr, sep)
    if string.len(inputstr) == 0 then
        return {}
    end
    sep = sep or "%s"
    local t = {}
    for field, s in string.gmatch(inputstr, "([^" .. sep .. "]*)(" .. sep .. "?)") do
        table.insert(t, field)
        if s == "" then
            return t
        end
    end
    return t
end

-- print(table.show(string_split("", ";")))
-- print(table.show(string_split("1;", ";")))
-- print(table.show(string_split(";1;2", ";")))
-- print(table.show(string_split(";;", ";")))

local ta = {}
local tb = {a = ta}
ta.a = tb
tb.f = function()
    -- body
end
ta[tb] = false
tb.c = {}
tc = {
    [tb.f] = tb
}
tb.c.xx=tc

print(table.show(ta))