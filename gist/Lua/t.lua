require("gist/Lua/lib/string_ext")

local map = {"K","M","B","T"}

local function toKMBT(v)
    local sign
    if v >= 0 then
        sign = 1
    else
        sign = -1
        v = -v
    end
    v = math.floor(v)


end

local function VExp(v)
    local exps = {}
    local sum = 0
    local runningSums = {}
    local frags = 2 * v
    local ei = 1
    local expectations = {}
    local slices = {}
    local map = {"1,1"}
    for i = v, 1, -1 do
        local exp = 2 ^ (i - 1)
        table.insert(exps, exp)
        sum = sum + exp
        table.insert(runningSums, sum)
        table.insert(expectations, ei / frags)
        ei = ei + 2
    end
    local weights = {}
    local r = 100 / sum
    local e = 0
    for i, vv in ipairs(exps) do
        slices[i] = i * 100 / v
        weights[i] = vv * r
        runningSums[i] = runningSums[i] * r
        table.insert(map, tostring(runningSums[i]) .. "," .. tostring(slices[i]))
        e = e + weights[i] * expectations[i]
    end
    print("exps: " .. table.concat(exps, ","))
    print("weights: " .. table.concat(weights, ","))
    print("runningSums: " .. table.concat(runningSums, ","))
    print("slices: " .. table.concat(slices, ","))
    print("expectations: " .. table.concat(expectations, ","))
    print(table.concat(map, ";"))
    print(e)
end

VExp(tonumber(arg[1]))
