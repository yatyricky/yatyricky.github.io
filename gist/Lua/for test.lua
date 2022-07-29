local t = setmetatable({}, {
    __index = function ()
        print("Access!")
        return 5
    end
})

for i = 1, t.len do
    print("loop " .. tostring(i))
end