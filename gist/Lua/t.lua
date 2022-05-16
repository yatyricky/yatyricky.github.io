local t = setmetatable({}, {
    __index = function(t, k)
        return "ooo"
    end
})

t = {}

local a

print(t[nil])