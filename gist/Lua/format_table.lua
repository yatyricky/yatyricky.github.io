require("gist/Lua/lib/string_ext")
require("gist/Lua/lib/table_ext")

local function LuaInspectorProcessNewLines(tbody)
    local tab = {}
    for _, tr in pairs(tbody) do
        print("current tr is", table.show(tr))
        local newTr = {}
        local rows = 1
        for i, td in pairs(tr) do
            newTr[i] = string.split(td, "\n")
            print("split td", td, table.show(newTr[i]))
            if #newTr[i] > rows then
                rows = #newTr[i]
            end
        end
        print("max rows is", rows)
        for i = 1, rows do
            local toInsert = {}
            for _, _tr in pairs(newTr) do
                table.insert(toInsert, _tr[i] or "")
            end
            table.insert(tab, toInsert)
        end
    end
    return tab
end

local function formatTable(tbody)
    local s = ""
    for _, tr in pairs(tbody) do
        s = s .. table.concat(tr, "|") .. "\n"
    end
    return s
end

print(formatTable(LuaInspectorProcessNewLines({
    {"a1", "b1"},
    {"a2", "b2\nb2x"},
    {"a3", "b3"},
})))