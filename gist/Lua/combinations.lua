require("gist/Lua/lib/table_ext")

local set = { "a", "b", "c", "d", "e" }

local function comb(s, n)
    if n <= 0 then
        return {}
    end
    local len = #s
    n = math.min(len, n)
    local ptrs = {}
    for i = 1, n do
        table.insert(ptrs, i)
    end
    local r = {}
    while true do
        local one = {}
        for i = 1, n do
            local p = ptrs[i]
            table.insert(one, s[p])
        end
        table.insert(r, one)
        -- cant move
        if ptrs[1] > len - n then
            break
        end
        -- move ptr
        for i = n, 1, -1 do
            if ptrs[i] < len - (n - i) then
                ptrs[i] = ptrs[i] + 1
                for j = i + 1, n do
                    ptrs[j] = ptrs[i] + j - i
                end
                break
            end
        end
    end
    return r
end

local function allCombs(s)
    local r = {}
    for i = 1, #s do
        for _, v in ipairs(comb(s, i)) do
            table.insert(r, v)
        end
    end
    return r
end

local res = allCombs(set)

for _, v in ipairs(res) do
    print(table.concat(v, ""))
end
