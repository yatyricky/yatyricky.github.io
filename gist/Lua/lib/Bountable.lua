--- Bountable - Boundable Table 可绑定数据变化事件的Table
--- 作者：Rick Sun
--- 日期：2022/8/4
--- 版权所有 © 2019-2022 武汉心驰神往科技有限公司

---@class Bountable
local _emmy = {}

---@param tab table
---@return Bountable
function _emmy.new(tab) end

---绑定
---@generic TContext
---@overload fun(paths: string[], callback: (fun(key: string, oldValue: any, newValue: any): void)): void
---@param paths string[] 需要绑定的路径，使用点.连接，可使用*来绑定任意。比如 "title", "attrs.stamina", "list.*", "list.*.name"
---@param callback (fun(key: string, oldValue: any, newValue: any): void) | (fun(context: TContext, key: string, oldValue: any, newValue: any): void)
---@param context TContext 上下文，如果指定，会作为回调的第一个参数
function _emmy:bind(paths, callback, context) end

---解除绑定
---@generic TContext
---@overload fun(paths: string[], callback: (fun(key: string, oldValue: any, newValue: any): void)): void
---@param paths string[]
---@param callback (fun(key: string, oldValue: any, newValue: any): void) | (fun(context: TContext, key: string, oldValue: any, newValue: any): void)
---@param context TContext
function _emmy:unbind(paths, callback, context) end

---解除指定路径下的所有绑定
---@param paths string[]
function _emmy:unbindPaths(paths) end

---解除指定上下文的所有绑定
---@param context any
function _emmy:unbindContext(context) end

---插入一个值，只能对列表类型的table使用，参数同table.insert
---@overload fun(value: any)
---@param pos number pos
---@param value any value
function _emmy:insert(pos, value) end

---移除一个值，只能对列表类型的table使用，参数同table.insert
---@overload fun()
---@param pos number pos
function _emmy:remove(pos) end

---获取列表长度，只能对列表类型的table使用
---@return number
function _emmy:len() end

---同pairs
---@generic K, V
---@return fun(t: table<K, V>): K, V
function _emmy:pairs() end

---同ipairs
---@generic V
---@return fun(t: V[], i: number): number, V, number
function _emmy:ipairs() end

--[[ example

local model = {
    title = "This is title",
    valid = false,
    list = {
        {
            name = "Alice",
            age = 15,
        },
        {
            name = "Bob",
            age = 7
        }
    },
    attrs = {
        stamina = 35,
        strength = 12
    },
    data = {
        1, 2, 3
    }
}

local context = {}

-- 从一个Table创建一个可绑定Table
local t = cls.new(model)

local function updateTitle(ctx, key, old, new)
    print("Update title changed", "dot", t.title, "key", key, "old", old, "new", new)
end

-- 绑定 title 字段的变化
t:bind({ "title" }, updateTitle, context)

-- 绑定 title或者valid 字段的变化
t:bind({ "title", "valid" }, function(key, old, new)
    print("Update", key, old, new)
end)

-- 绑定 attrs.strength 字段的变化，可指定未定义的字段
t:bind({ "attrs.strength" }, function(key, old, new)
    print("Update", key, old, new)
end)

-- 绑定 attrs 字段里面任意字段的变化 t.attrs.field = xxx 会触发
t:bind({ "attrs.*" }, function(key, old, new)
    print("Update attrs.*", key, old, new)
end)

-- 绑定 attrs 字段本身的变化 t.attrs = xxx 会触发
t:bind({ "attrs" }, function(key, old, new)
    print("Update attrs", key, old, new)
end)

t:bind({ "list.*" }, function(key, old, new)
    print("Update list", key, old, new)
end)

t:bind({ "list.*.name" }, function(key, old, new)
    print("update", key, old, new)
end)

t:bind({ "list.*.age" }, function(key, old, new)
    print("update", key, old, new)
end)

t:bind({ "data.*" }, function(key, old, new)
    print("update", key, old, new)
end)

t:bind({ "*" }, function(key, old, new)
    print("any changed", key, old, new)
end)

--]]

local ipairs = ipairs
local pairs = pairs
local type = type
local print = print
local next = next
local setmetatable = setmetatable
local t_insert = table.insert
local t_remove = table.remove
local s_format = string.format
local s_gmatch = string.gmatch

local str_table = "table"
local str_asterisk = "*"
local str_static = "s"
local str_period = "."
local str_split = "([^%s]+)"

local function isEmpty(t)
    return t == nil or next(t) == nil
end

local function shallow(tab)
    local t = {}
    for key, value in pairs(tab) do
        t[key] = value
    end
    return t
end

local function split(inputstr, sep)
    local t = {}
    for str in s_gmatch(inputstr, s_format(str_split, sep)) do
        t_insert(t, str)
    end
    return t
end

---@type Bountable
local cls = {}
local mt = {}

function mt.__index(t, k)
    return t.__d[k]
end

local function mtLen(t)
    return #t.__d
end

local function mtPairs(t)
    return pairs(t.__d)
end

local function mtIpairs(t)
    return ipairs(t.__d)
end

local function emit(t, k, v, old)
    local tab = t.__l[k]
    if tab then
        for func, contexts in pairs(tab) do
            for ctx, _ in pairs(contexts) do
                if ctx == str_static then
                    func(k, old, v)
                else
                    func(ctx, k, old, v)
                end
            end
        end
    end
end

--region bind

local function doBind(listeners, key, call, ctx)
    local tab = listeners[key]
    if not tab then
        tab = {}
        listeners[key] = tab
    end
    local contexts = tab[call]
    if not contexts then
        contexts = {}
        tab[call] = contexts
    end
    if contexts[ctx] then
        print("Double binding")
    end
    contexts[ctx] = 1
end

local function bindRecursive(this, ps, call, ctx)
    local old = shallow(ps)
    local p = t_remove(ps, 1)
    if #ps == 0 then
        if p == str_asterisk then
            for k, _ in pairs(this.__d) do
                doBind(this.__l, k, call, ctx)
            end
            t_insert(this.__b, { old, call, ctx })
        else
            doBind(this.__l, p, call, ctx)
        end
    else
        if p == str_asterisk then
            for _, v in pairs(this.__d) do
                bindRecursive(v, shallow(ps), call, ctx)
            end
            t_insert(this.__b, { old, call, ctx })
        else
            bindRecursive(this.__d[p], shallow(ps), call, ctx)
        end
    end
end

local function bind(this, paths, call, context)
    local ctx = context or str_static
    for _, path in pairs(paths) do
        local p = split(path, str_period)
        bindRecursive(this, p, call, ctx)
    end
end

--endregion

--region unbind full

local function doUnbind(listeners, key, call, ctx)
    local tab = listeners[key]
    if not tab then
        print("Cannot unbind key", key)
        return
    end
    local contexts = tab[call]
    if not contexts then
        print("Cannot unbind callback", call)
        return
    end
    if not contexts[ctx] then
        print("Cannot unbind context", ctx)
        return
    end
    contexts[ctx] = nil
    if isEmpty(contexts) then
        tab[call] = nil
        if isEmpty(tab) then
            listeners[key] = nil
        end
    end
end

local function seqEqual(seq1, seq2)
    if seq1 == nil and seq2 == nil then
        return true
    end
    if seq1 == nil or seq2 == nil then
        return false
    end
    local len = #seq1
    if len ~= #seq2 then
        return false
    end
    for i = 1, len do
        if seq1[i] ~= seq2[i] then
            return false
        end
    end
    return true
end

local function unbindArgs(this, old, call, ctx)
    local b = this.__b
    for i = #b, 1, -1 do
        local it = b[i]
        if seqEqual(it[1], old) and it[2] == call and it[3] == ctx then
            t_remove(b, i)
        end
    end
end

local function unbindRecursive(this, ps, call, ctx)
    local old = shallow(ps)
    local p = t_remove(ps, 1)
    if #ps == 0 then
        if p == str_asterisk then
            for k, _ in pairs(this.__d) do
                doUnbind(this.__l, k, call, ctx)
            end
            unbindArgs(this, old, call, ctx)
        else
            doUnbind(this.__l, p, call, ctx)
        end
    else
        if p == str_asterisk then
            for _, v in pairs(this.__d) do
                unbindRecursive(v, shallow(ps), call, ctx)
            end
            unbindArgs(this, old, call, ctx)
        else
            unbindRecursive(this.__d[p], shallow(ps), call, ctx)
        end
    end
end

local function unbind(this, paths, call, context)
    local ctx = context or str_static
    for _, path in pairs(paths) do
        local p = split(path, str_period)
        unbindRecursive(this, p, call, ctx)
    end
end

--endregion

--region unbind paths

local function unbindArgsPaths(this, old)
    local b = this.__b
    for i = #b, 1, -1 do
        local it = b[i]
        if seqEqual(it[1], old) then
            t_remove(b, i)
        end
    end
end

local function doUnbindPaths(listeners, key)
    local tab = listeners[key]
    if not tab then
        print("Cannot unbind key", key)
        return
    end
    listeners[key] = nil
end

local function unbindPathsRecursive(this, ps)
    local old = shallow(ps)
    local p = t_remove(ps, 1)
    if #ps == 0 then
        if p == str_asterisk then
            for k, _ in pairs(this.__d) do
                doUnbindPaths(this.__l, k)
            end
            unbindArgsPaths(this, old)
        else
            doUnbindPaths(this.__l, p)
        end
    else
        if p == str_asterisk then
            for _, v in pairs(this.__d) do
                unbindPathsRecursive(v, shallow(ps))
            end
            unbindArgsPaths(this, old)
        else
            unbindPathsRecursive(this.__d[p], shallow(ps))
        end
    end
end

local function unbindPaths(this, paths)
    for _, path in pairs(paths) do
        local p = split(path, str_period)
        unbindPathsRecursive(this, p)
    end
end

--endregion

--region unbind context

local function unbindContext(this, context)
    context = context or str_static
    local l = this.__l
    for key, tab in pairs(l) do
        for call, contexts in pairs(tab) do
            contexts[context] = nil
            if isEmpty(contexts) then
                tab[call] = nil
            end
        end
        if isEmpty(tab) then
            l[key] = nil
        end
    end
    for _, value in pairs(this.__d) do
        if type(value) == str_table then
            unbindContext(value, context)
        end
    end
    local b = this.__b
    for i = #b, 1, -1 do
        local it = b[i]
        if it[3] == context then
            t_remove(b, i)
        end
    end
end

--endregion

mt.__newindex = function(t, k, v)
    local d = t.__d
    local old = d[k]
    if v == old then
        return
    end

    local l = t.__l
    if v == nil then
        -- delete
        d[k] = nil
        l[k] = nil
        emit(t, k, d[k], old)
    else
        local tp = type(v)
        if old == nil then
            d[k] = tp == str_table and cls.new(v) or v
            for _, args in ipairs(t.__b) do
                local newPs = shallow(args[1])
                newPs[1] = k
                bindRecursive(t, newPs, args[2], args[3])
            end
            emit(t, k, d[k], old)
        else
            if tp == str_table then
                for kk, vv in pairs(v) do
                    mt.__newindex(d[k], kk, vv)
                end
            else
                d[k] = v
                emit(t, k, d[k], old)
            end
        end
    end
end

local function insert(this, arg1, arg2)
    local d = this.__d
    local key
    local item
    if arg2 == nil then
        key = #d + 1
        item = arg1
    else
        key = arg1
        item = arg2
    end

    local old = d[key]
    local tp = type(item)
    t_insert(this.__l, key, nil)
    if tp == str_table then
        t_insert(d, key, cls.new(item))
        for _, args in ipairs(this.__b) do
            local newPs = shallow(args[1])
            newPs[1] = key
            bindRecursive(this, newPs, args[2], args[3])
        end
    else
        t_insert(d, key, item)
        for _, args in ipairs(this.__b) do
            doBind(this.__l, key, args[2], args[3])
        end
    end
    emit(this, key, d[key], old)
end

local function remove(this, arg1)
    local d = this.__d
    local key
    if arg1 == nil then
        key = #d
    else
        key = arg1
    end

    local removed = t_remove(d, key)
    emit(this, key, d[key], removed)
    t_remove(this.__l, key)
end

local template = {
    bind = bind,
    unbind = unbind,
    unbindPaths = unbindPaths,
    unbindContext = unbindContext,
    insert = insert,
    remove = remove,
    len = mtLen,
    pairs = mtPairs,
    ipairs = mtIpairs,
}

local function clone(tab)
    local t = {}
    for key, value in pairs(tab) do
        if template[key] then
            print("Warn: Bountable can't use key", key)
        else
            local tp = type(value)
            if tp == str_table then
                t[key] = cls.new(value)
            else
                t[key] = value
            end
        end
    end
    return t
end

function cls.new(model)
    local inst = shallow(template)
    inst.__l = {} -- listeners
    inst.__b = {} -- binding args
    inst.__d = clone(model) -- raw data
    return setmetatable(inst, mt)
end

return cls
