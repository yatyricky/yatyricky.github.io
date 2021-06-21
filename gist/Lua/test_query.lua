require("gist.Lua.lib.table_ext")

local tabIndexed = {
    { ID = 1, Group = 2, Value = 11 },
    { ID = 2, Group = 2, Value = 15 },
    { ID = 3, Group = 0, Value = 32 },
    { ID = 4, Group = 2, Value = 11 },
    { ID = 5, Group = 0, Value = 8 },
    { ID = 6, Group = 2, Value = 13 },
}

print(table.show(table.query(tabIndexed, {
    select = function(k, v)
        return {
            category = v.Group * 10,
            val = v.Value,
            idx = v.ID
        }
    end,
    where = function(k, v)
        return v.Value < 20
    end,
    groupBy = function(k, v)
        return v.category
    end,
    sort = function(a, b)
        return a.idx < b.idx
    end,
    distinct = function(k, v)
        return v.Value, 100 - v.ID
    end
}), "tab", "  ", true))