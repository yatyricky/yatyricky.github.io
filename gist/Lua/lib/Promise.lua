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

local function cancelPromises(promises)
    for _, v in ipairs(promises) do
        v:_cancel("cancelled")
    end
end

---@class Promise
local cls = {
    __isPromise = true
}

cls.__index = cls

---@generic T
---@param executor fun(resolve: (fun(result: T): void), reject: (fun(reason: string): void))
---@return Promise<T>
function cls.New(executor)
    local inst = setmetatable({}, cls)
    inst.state = PENDING
    inst.next = {}
    inst.parent = nil
    if executor then
        local success, errMsg = pcall(executor, function(result)
            inst:_resolve(result)
        end, function(reason)
            inst:_reject(reason)
        end)
        if not success then
            inst:_reject(errMsg)
        end
    end
    return inst
end

---@param promises Promise[]
---@return Promise
function cls.All(promises)
    local remaining = #promises
    local results = {}
    local p = cls.New()

    local checkFinished = function()
        if remaining > 0 then
            return
        end
        p:_resolve(results)
    end

    for i, v in ipairs(promises) do
        v:Then(function(result)
            results[i] = result
            remaining = remaining - 1
            checkFinished()
        end, function(reason)
            p:_reject(reason)
            cancelPromises(promises)
        end)
    end
    checkFinished()

    return p
end

---@param promises Promise[]
---@return Promise
function cls.Race(promises)
    local p = cls.New()
    if #promises == 0 then
        p:_resolve()
    end

    for _, v in ipairs(promises) do
        v:Then(function(result)
            p:_resolve(result)
            cancelPromises(promises)
        end, function(reason)
            p:_reject(reason)
            cancelPromises(promises)
        end)
    end

    return p
end

---@generic T
---@param onFulfilled (fun(result: T): void) | nil
---@param onRejected (fun(reason: string): void) | nil
---@return Promise<T>
function cls:Then(onFulfilled, onRejected)
    local p = cls.New()
    local data = {
        promise = p,
        onFulfilled = type(onFulfilled) == "function" and onFulfilled or defaultOnFulfilled,
        onRejected = type(onRejected) == "function" and onRejected or defaultOnRejected
    }
    if self.redirected then
        t_insert(self.redirected.next, data)
        p.parent = self.redirected
        self.redirected:_run()
    else
        t_insert(self.next, data)
        p.parent = self
        self:_run()
    end

    return p
end

---@param onRejected (fun(reason: string): void)
---@return Promise
function cls:Catch(onRejected)
    return self:Then(nil, onRejected)
end

function cls:Finally(onFinally)
    return self:Then(function (result)
        return onFinally(true, result)
    end, function (reason)
        return onFinally(false, reason)
    end)
end

function cls:_run()
    if self.state == PENDING then
        return
    end

    for i, v in ipairs(self.next) do
        local pState
        local pReturn
        if self.state == FULFILLED then
            pState, pReturn = pcall(v.onFulfilled, self.result)
            if pState then
                v.promise:_resolve(pReturn)
            end
        end
        if not pState or self.state == REJECTED then
            pState, pReturn = pcall(v.onRejected, pReturn and pReturn or self.reason)
            v.promise:_reject(pReturn and pReturn or self.reason)
        end
        self.next[i] = nil
    end
end

function cls:_resolve(result)
    if self.state ~= PENDING then
        return
    end

    if self == result then
        self:_reject("Attempting to resolve with the promise itself")
        return
    end

    self.state = FULFILLED
    self.result = result
    if type(result) == "table" and result.__isPromise then
        result.next = self.next
        for _, v in pairs(self.next) do
            v.promise.parent = result
        end
        result:_run()
        self.redirected = result
    else
        self:_run()
    end
end

function cls:_reject(reason)
    if self.state ~= PENDING then
        return
    end

    self.state = REJECTED
    self.reason = reason
    self:_run()
end

function cls:_cancel(reason)
    if self.state ~= PENDING then
        return
    end
    local curr = self
    while curr.parent ~= nil and curr.parent.state == PENDING do
        curr = curr.parent
    end
    curr:_reject(reason)
end

return cls
