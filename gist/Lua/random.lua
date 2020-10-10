require("gist/Lua/lib/table_ext")

local function RandomListWeight(pool, count)
    count = count or 1
    local total = 0
    for _, w in pairs(pool) do
        total = total + w
    end
    local result = {}
    for _ = 1, count do
        if total <= 0 then
            break
        end
        local rand = math.random(total)
        for obj, w in pairs(pool) do
            rand = rand - w
            if rand <= 0 then
                total = total - w
                pool[obj] = 0
                table.insert(result, obj)
                break
            end
        end
    end
    return result
end

local tab = {1,2,3,4,5}
print(table.show(tab))
print(table.show(RandomListWeight(tab, 0)))
print(table.show(tab))
print(table.show(RandomListWeight(tab, 1)))
print(table.show(tab))
print(table.show(RandomListWeight(tab, 2)))
print(table.show(tab))
print(table.show(RandomListWeight(tab, 3)))
print(table.show(tab))
print(table.show(RandomListWeight(tab, 4)))
print(table.show(tab))
print(table.show(RandomListWeight(tab, 5)))
print(table.show(tab))
print(table.show(RandomListWeight(tab, 6)))
print(table.show(tab))