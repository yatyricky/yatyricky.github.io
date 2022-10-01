local t = setmetatable({}, {
    __index = function (t, k)
        print("indexed")
        return 3
    end
})

for i = 1, t.len, 1 do
    print("iter" .. tostring(i))
end
end
