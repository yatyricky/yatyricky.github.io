require("gist/Lua/lib/table_ext")

local t = {
    {id=12,val="red1"},
    {id=12,val="red2"},
    {id=5,val="blue1"},
    {id=5,val="blue2"},
    {id=47,val="green1"},
    {id=47,val="green2"},
}

local function sortBullets()
    local grouped = table.query(t, {
        groupBy = function(_, info)
            return info.id
        end,
    })
    print(table.show(grouped, "grouped", nil, true))
    local keys = table.keys(grouped)
    print(table.show(keys, "keys", nil, true))
    table.sort(keys)
    print(table.show(keys, "keys_sorted", nil, true))
    local sorted = {}
    local hasValue = true
    while hasValue do
        hasValue = false
        for _, id in pairs(keys) do
            local group = grouped[id]
            local oi, info = next(group)
            if info then
                table.insert(sorted, info)
                group[oi] = nil
            end
            if next(group) then
                hasValue = true
            end
        end
    end
    return sorted
end

print(table.show(t, "t1", nil, true))

local r = sortBullets()
print(table.show(r, "sorted", nil, true))


