require("gist/Lua/lib/global")
require("gist\\Lua\\lib\\table_ext")

local cls = {}

local id = "123456200712045531"

function cls.extractDOB(idText)
    local len = string.len(idText)
    if len == 15 then
        -- gen 1
        return tonumber("19" .. string.sub(idText, 7, 12))
    else
        -- gen 2
        return tonumber(string.sub(idText, 7, 14))
    end
end

assert(cls.extractDOB("123456200712045531"), 20071204)
assert(cls.extractDOB("123456198805075531"), 19880507)
assert(cls.extractDOB("123456920507531"), 19920507)

function cls.getAge(dob)
    local today = os.date("*t")
    local year = math.floor(dob / 10000)
    local month = math.floor(dob % 10000 / 100)
    local day = dob % 100
    local dayDiff = today.day - day
    local monthDiff = today.month - month
    local yearDiff = today.year - year
    if dayDiff < 0 then
        dayDiff = dayDiff + 31
        monthDiff = monthDiff - 1
    end
    if monthDiff < 0 then
        monthDiff = monthDiff + 12
        yearDiff = yearDiff - 1
    end
    return yearDiff + monthDiff / 12 + dayDiff / 365
end

print(cls.getAge(20190528))
print(cls.getAge(20190529))
print(cls.getAge(20190530))
print(cls.getAge(20190531))
print(cls.getAge(20190601))
print(cls.getAge(20190602))
print(cls.getAge(20190603))