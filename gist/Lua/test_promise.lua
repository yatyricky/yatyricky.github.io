function sleep(n)
    if n > 0 then
        os.execute("ping -n " .. tonumber(n + 1) .. " localhost > NUL")
    end
end

local function immediatex2(data, callback)
    -- print("immediatex2 will callback", data, data * 2)
    callback(data * 2)
end

local Promise = require("gist/Lua/lib/Promise")

-- local function promiseImmediatex2(data)
--     -- print("start promiseImmediatex2 with", data)
--     return Promise.New(function(resolve, reject)
--         -- print("start promiseImmediatex2 prom call")
--         immediatex2(data, function(resp)
--             -- print("start promiseImmediatex2 will resolve with", resp)
--             resolve(resp)
--         end)
--     end)
-- end

local function promiseImmediatex2(data)
    -- print("start promiseImmediatex2 with", data)
    return Promise.New(function(resolve, reject)
        if data % 2 == 1 then
            reject("Only works on even numbers")
        else
            resolve(data * 2)
        end
    end)
end

local function promiseSleep(sec)
    return Promise.New(function(resolve, reject)
        sleep(sec)
        resolve(sec)
    end)
end

-- promiseImmediatex2(1):Then(function(value)
--     print(value)
--     return promiseSleep(value)
-- end):Then(function(sec)
--     print("sleeped " .. tostring(sec))
-- end)

-- print("--------------------------------------------")

local p = promiseImmediatex2(2)
p:Then(function(value)
    print("1-1 " .. value)
    {}.a.b = 1
    return promiseImmediatex2(value)
end):Then(function(sec)
    print("1-2 " .. tostring(sec))
    return 55
end):Then(function (res)
    print("1-3 " .. tostring(res))
    return promiseImmediatex2(res)
end):Then(function (res)
    print("1-4 " .. tostring(res))
end, function (err)
    print("1-4' " .. tostring(err))
end)

p:Then(function (val)
    print("then-2 val " .. tostring(val))
    return promiseImmediatex2(val +2)
end):Then(function (res)
    print("final-2 " .. res)
end, function (err)
    print("2-3' " .. err)
end)

-- promiseSleep(1):Then(function ()
--     print("tick 1")
--     return promiseSleep(1)
-- end):Then(function ()
--     print("tick 2")
-- end)