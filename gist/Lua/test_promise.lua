require("gist/Lua/lib/table_ext")

local Promise = require("gist/Lua/lib/Promise")

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

-- promiseImmediatex2(1):Then(function(value)
--     print(value)
--     return promiseSleep(value)
-- end):Then(function(sec)
--     print("sleeped " .. tostring(sec))
-- end)

-- print("--------------------------------------------")

-- local p = promiseImmediatex2(2)
-- p:Then(function(value)
--     print("1-1 " .. value)
--     {}.a.b = 1
--     return promiseImmediatex2(value)
-- end):Then(function(sec)
--     print("1-2 " .. tostring(sec))
--     return 55
-- end):Then(function (res)
--     print("1-3 " .. tostring(res))
--     return promiseImmediatex2(res)
-- end):Then(function (res)
--     print("1-4 " .. tostring(res))
-- end, function (err)
--     print("1-4' " .. tostring(err))
-- end)

-- p:Then(function (val)
--     print("then-2 val " .. tostring(val))
--     return promiseImmediatex2(val +2)
-- end):Then(function (res)
--     print("final-2 " .. res)
-- end, function (err)
--     print("2-3' " .. err)
-- end)

-- promiseSleep(1):Then(function ()
--     print("tick 1")
--     return promiseSleep(1)
-- end):Then(function ()
--     print("tick 2")
-- end)

-- local function checkSuccess(delay)
--     return Promise.New(function (resolve, reject)
--         print("exec ", delay)
--         if delay < 3 then
--             resolve(delay)
--         else
--             -- resolve(delay*2)
--             reject("big")
--         end
--     end)
-- end

-- Promise.All(table.map(table.range(5), function (key, value)
--     return checkSuccess(value)
-- end)):Then(function (res)
--     print("success @",table.show(res))
--     return res
-- end):Catch(function (reason)
--     print("rejected", reason)
-- end):Finally(function (isResolved, data)
--     print("finally", isResolved, table.show(data))
--     if isResolved then
--         return data
--     else
--         return {1,1,1,1,1}
--     end
-- end):Then(function (res)
--     print("fixed", table.show(res))
-- end, function (resp)
--     print("fixed", table.show(resp))
-- end)

local pass = function (res)
    return res
end
promiseImmediatex2(2):Then(pass):Then(pass):Then(pass):Then(function (res)
    print(res)
end)