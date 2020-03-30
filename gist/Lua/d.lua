require("common")

local map = function (t,f)
    local ret = {}
    for k, v in pairs(t) do
        table.insert(ret,f(v))
    end
    return ret
end

local tab = {1,2,3,4}

print(table.show(map(tab, function (arg1, arg2, arg3)
    return arg1 * 2
end)))