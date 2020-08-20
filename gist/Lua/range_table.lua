require("gist/Lua/lib/table_ext")

local rangeTabCache = {}

local function GetValueFromRangeTable(t, key)
    local tmpTable = rangeTabCache[t]
    if not tmpTable then
        tmpTable = {}

        for k, v in pairs(t) do
            table.insert(tmpTable, {
                level = k,
                value = v,
            })
        end
        table.sort(tmpTable, function(a, b)
            return a.level < b.level
        end)

        rangeTabCache[t] = tmpTable
    end

    local ret = nil
    for i = 1, #tmpTable do
        if key < tmpTable[i].level then
            if ret == nil then
                return tmpTable[i].value
            else
                return ret
            end
        end
        ret = tmpTable[i].value
    end
    return ret
end

local tab = {
    [0] = 0,
    [10] = 1,
    [25] = 2,
    [50] = 3,
    [100] = 4,
    [200] = 5,
    [300] = 6,
    [400] = 7,
    [500] = 8,
    [600] = 9,
    [700] = 10,
}

for i = 0, 800 do
    print(i, GetValueFromRangeTable(tab, i))
end

