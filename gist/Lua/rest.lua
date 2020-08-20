require("gist/Lua/lib/table_ext")

local function concatList(list)
    local tokens = {}
    for _, v in ipairs(list) do
        local str
        local t = type(v)
        if t == "table" then
            str = table.show(v)
        else
            str = tostring(v)
        end
        table.insert(tokens, str)
    end
    return table.concat(tokens, ", ")
end

local function extractErrCode(...)
    local params = {...}
    local count = #params
    local errCode = 200000
    if count > 1 then
        local last = params[count]
        if type(last) == "number" then
            errCode = last
            table.remove(params, count)
        end
    end
    return concatList(params), errCode
end

-- local a, b = extractErrCode()
-- print(type(a)..">"..a.."<"..b)

-- a, b = extractErrCode(150)
-- print(type(a)..">"..a.."<"..b)

-- a, b = extractErrCode("a")
-- print(type(a)..">"..a.."<"..b)

-- a, b = extractErrCode("a", "b")
-- print(type(a)..">"..a.."<"..b)

-- a, b = extractErrCode("a", 100)
-- print(type(a)..">"..a.."<"..b)

-- a, b = extractErrCode("a", "b", 200)
-- print(type(a)..">"..a.."<"..b)

-- a, b = extractErrCode({{},{}}, {}, 400, "c")
-- print(type(a)..">"..a.."<"..b)

local function firstAndRest(first, ...)
    print(first .. ">>>" .. concatList({...}))
end

firstAndRest(12, "zxc")

firstAndRest(12, 55)

firstAndRest(12,"azxc", 55)
