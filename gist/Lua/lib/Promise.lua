require("gist/Lua/lib/table_ext")

local setmetatable = setmetatable
local error = error
local pcall = pcall
local type = type
local ipairs = ipairs
local t_insert = table.insert

local PENDING = 1
local FULFILLED = 2
local REJECTED = 3

local function defaultOnFulfilled(result)
    return result
end

local function defaultOnRejected(reason)
    error(reason)
end

local function printChain(root)
    local sb = tostring(root) .. "("
    for i, v in ipairs(root.next) do
        sb = sb .. printChain(v.promise) .. " "
    end
    sb = sb .. ")"
    return sb
end

local cls = {
    __isPromise = true
}

cls.__index = cls

function cls.New(func)
    local inst = setmetatable({}, cls)
    -- print("PROMISE:"..tostring(inst).." new")
    inst.state = PENDING
    inst.next = {}
    if func then
        -- print("PROMISE:"..tostring(inst).." new call func")
        local success, errMsg = pcall(func, function(result)
            -- print("PROMISE:"..tostring(inst).." will callback resolve with", result)
            inst:_resolve(result)
        end, function (err)
            -- print("PROMISE:"..tostring(inst).." will callback reject with", err)
            inst:_reject(err)
        end)
        if not success then
            -- print("PROMISE:"..tostring(inst).." will callback reject with exception", errMsg)
            inst:_reject(errMsg)
        end
    end
    return inst
end

function cls:_resolve(result)
    if self == result then
        self:_reject("TypeError: attempting to resolve with the promise itself")
        return
    end
    if self.state ~= PENDING then
        -- print("PROMISE:"..tostring(self).. " resolve again, skipping ...")
        return
    end
    -- print("PROMISE:"..tostring(self).. " will transite to fulfilled", result)
    self.state = FULFILLED
    self.result = result
    if type(result) == "table" and result.__isPromise then
        -- print("PROMISE:"..tostring(self).. " will resolve with new promise:" .. tostring(result))
        result.next = self.next
        self.next = {
            {
                promise = result,
                onFulfilled = function(_result)
                    result:_resolve(_result)
                end,
                onRejected = function(_reason)
                    result:_reject(_reason)
                end
            }
        }
        -- print(printChain(self))
        self.redirected = true
    end
    self:_run()
end

function cls:_reject(reason)
    if self.state ~= PENDING then
        return
    end
    -- print("PROMISE:"..tostring(self).. " will transit to rejected", reason)
    self.state = REJECTED
    self.reason = reason
    self:_run()
end

function cls:Then(onFulfilled, onRejected)
    local p = cls.New()
    -- print("PROMISE:"..tostring(self).. " Then, new promise=", tostring(p))
    local data = {
        promise = p,
        onFulfilled = type(onFulfilled) == "function" and onFulfilled or defaultOnFulfilled,
        onRejected = type(onRejected) == "function" and onRejected or defaultOnRejected
    }
    if self.redirected then
        t_insert(self.next[1].promise.next, data)
    else
        t_insert(self.next, data)
    end
    -- print("After then: " .. printChain(self))
    self:_run()
    return p
end

function cls:_run()
    -- print("PROMISE:"..tostring(self).." will run")
    -- print(printChain(self))
    for _, v in ipairs(self.next) do
        -- print("PROMISE:"..tostring(self).." running " .. tostring(v.promise))
        if self.state == PENDING then
            -- print("PROMISE:"..tostring(self).." pending, do nothing")
            break
        end
        local pState
        local pReturn
        if self.state == FULFILLED then
            -- print("PROMISE:"..tostring(self).." fulfilled:"..tostring(v.promise).." will call onFulfilled with", self.result)
            pState, pReturn = pcall(v.onFulfilled, self.result)
            if pState then
                -- print("PROMISE:"..tostring(self).." fulfilled:"..tostring(v.promise).." will resolve", pReturn)
                v.promise:_resolve(pReturn)
            end
        end
        if not pState or self.state == REJECTED then
            pState, pReturn = pcall(v.onRejected, pState and self.reason or pReturn)
            v.promise:_reject(pReturn)
        end
    end
end

return cls
