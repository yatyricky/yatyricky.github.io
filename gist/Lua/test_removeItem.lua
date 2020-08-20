require("gist/Lua/lib/table_ext")

-- function test(list, ri, output, len)
--     local from = table.join(list,",")
--     table.removeItem(list, ri)
--     local to = table.join(list,",")
--     if to == output and #list == len then
--         print("OK", from, "removes", ri, "->", to, "len is", len)
--     else
--         print("FAIL", from, "removes", ri, "is not", output, "instead", to, "len is", len)
--     end
-- end

-- test({ 1,1,2,3,4,5,6,4}, 1, "2,3,4,5,6,4", 6)
-- test({ 1,1,2,3,4,5,6,4}, 4, "1,1,2,3,5,6", 6)
-- test({}, 1, "", 0)
-- test({ 1,1,2,3,4,5,6,4}, 7, "1,1,2,3,4,5,6,4", 8)
-- test({ 1,1,1,1}, 1, "", 0)
-- test({ 2,2,1,1,1,1}, 1, "2,2", 2)
-- test({ 2,2,1,1,1,1}, 2, "1,1,1,1", 4)

local tab = {
    {a=1,b="qwe",c=true},
    {a=2,b="rty",c=true},
    {a=3,b="uio",c=false},
    {a=4,b="asd",c=false},
    {a=5,b="fgh",c=true},
}

print(table.show(tab))

table.filterInPlace(tab, function(v)
    return v.c and v.a > 3
end)

print(table.show(tab), #tab)