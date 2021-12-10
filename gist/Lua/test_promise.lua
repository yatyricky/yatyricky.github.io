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

local function promiseImmediatex2(data)
    -- print("start promiseImmediatex2 with", data)
    return Promise.New(function(resolve, reject)
        -- print("start promiseImmediatex2 prom call")
        immediatex2(data, function(resp)
            -- print("start promiseImmediatex2 will resolve with", resp)
            resolve(resp)
        end)
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

promiseImmediatex2(1):Then(function(value)
    print("then val " .. value)
    -- return "zxc"
    return promiseImmediatex2(value)
end):Then(function(sec)
    print("sleeped " .. tostring(sec))
end)

--local p1 = Promise.New(function(resolve, reject)
--    doStaff(function(successCall)
--        resolve()
--    end, function(failCall)
--        reject()
--    end)
--end)
--local p2 = Promise.New()
--p1:Then(function(val)
--    return p2
--end)
--p1:Then()