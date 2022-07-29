local a = {1,2}
math.randomseed(os.time())
local function ShuffleInPlace(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end
ShuffleInPlace(a)

print(table.concat(a))