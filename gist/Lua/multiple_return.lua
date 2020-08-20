local function f1()
    return 1,2,3
end

local function f2()
    return f1()
end

print(f2())