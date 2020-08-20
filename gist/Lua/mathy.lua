require("gist/Lua/lib/table_ext")

local function DivideIntoArray(dividend, divisor)
    divisor = math.floor(divisor + 0.5)
    if divisor <= 0 then
        return { dividend }
    end
    local ret = {}
    local quotient = math.floor(dividend / divisor)
    local reminder = dividend % divisor
    if quotient > 0 then
        for i = 1, divisor do
            if reminder > 0 then
                ret[i] = quotient + 1
                reminder = reminder - 1
            else
                ret[i] = quotient
            end
        end
    else
        for i = 1, reminder do
            ret[i] = 1
        end
    end
    return ret
end

-- print(table.show(DivideIntoArray(12.3, 3.77)))
-- print(table.show(DivideIntoArray(10, 3)))
-- print(table.show(DivideIntoArray(10, 2)))

local function mrandom(stdDev)
    local half = stdDev * 0.5
    return (math.random() * half  + math.random() * half) - half
end

local m = 1
for i = 1, 10 do
    print(m, mrandom(m))
end