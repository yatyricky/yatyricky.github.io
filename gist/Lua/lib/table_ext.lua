require("gist/Lua/lib/global")

local t_insert = table.insert

function table.isEmpty(t)
    return next(t) == nil
end

function table.show(t, name, indent, nice)
    local cart     -- a container
    local autoref  -- for self references
    local eol = nice and "\n" or ";"
    local indentIncre = nice and (indent and indent or "  ") or ""

    -- (RiciLake) returns true if the table is empty
    local function isemptytable(t)
        return next(t) == nil
    end

    local function basicSerialize(o)
        local so = tostring(o)
        if type(o) == "function" then
            local info = debug.getinfo(o, "S")
            -- info.name is nil because o is not a calling level
            if info.what == "C" then
                return string.format("%q", so .. ":C function")
            else
                -- the information is defined through lines
                return string.format("%q", so .. ":(" .. info.linedefined .. "-" .. info.lastlinedefined .. ")" .. info.source)
            end
        elseif type(o) == "number" or type(o) == "boolean" then
            return so
        else
            return string.format("%q", so)
        end
    end

    local function addtocart(value, name, indent, saved, field)
        indent = indent or ""
        saved = saved or {}
        field = field or name

        cart = cart .. indent .. field

        if type(value) ~= "table" then
            cart = cart .. "=" .. basicSerialize(value) .. eol
        else
            if saved[value] then
                cart = cart .. "=(" .. saved[value] .. ")" .. eol
                autoref = autoref .. name .. "=" .. saved[value] .. eol
            else
                saved[value] = name

                if isemptytable(value) then
                    cart = cart .. "={(" .. tostring(value) .. ")}" .. eol
                else
                    cart = cart .. "={(" .. tostring(value) .. ")" .. eol
                    for k, v in pairs(value) do
                        k = basicSerialize(k)
                        local fname = string.format("%s[%s]", name, k)
                        field = string.format("[%s]", k)
                        -- three spaces between levels
                        addtocart(v, fname, indent .. indentIncre, saved, field)
                    end
                    cart = cart .. indent .. "}" .. eol
                end
            end
        end
    end

    name = name or "__root"
    if type(t) ~= "table" then
        return name .. "=" .. basicSerialize(t)
    end
    cart, autoref = "", ""
    addtocart(t, name, indent)
    return cart .. autoref
end

---@generic T
---@param tab T[]
---@param from number Optional One-based index at which to begin extraction.
---@param to number Optional One-based index before which to end extraction.
---@param shallow boolean Optional Performs shallow copy on table or not.
---@return T[]
function table.slice(tab, from, to, shallow)
    from = from and math.clamp(from, 1, #tab + 1) or 1
    to = to and math.clamp(to, 1, #tab) or #tab
    local result = {}
    for i = from, to, 1 do
        if tab[i] then
            if type(tab[i]) ~= "table" or shallow then
                table.insert(result, tab[i])
            else
                table.insert(result, clone(tab[i]))
            end
        end
    end
    return result
end

function table.count(t)
    local count = 0
    for _, _ in pairs(t) do
        count = count + 1
    end
    return count
end

---@generic T
---@param t T[]
---@param delimeter string
---@param formatter fun(elem: T):string default=tostring(T)
---@return string
function table.join(t, delimeter, formatter)
    local res = ""
    for i = 1, #t do
        if formatter then
            res = res .. formatter(t[i])
        else
            res = res .. tostring(t[i])
        end
        if i < #t then
            res = res .. delimeter
        end
    end
    return res
end

function table.query(data, opts)
    -- parse opts
    opts = opts or {}
    local select = opts.select
    local where = opts.where
    local any = opts.any
    local all = opts.all
    local sort = opts.sort
    local distinct = opts.distinct
    local groupBy = opts.groupBy
    local asList = opts.asList or (sort ~= nil)
    local returnTable = (any == nil and all == nil) -- return type is table or bool
    local count = 0
    local _insert = table.insert

    local ret = {}

    local function iterate(k, v)
        local s
        if select then
            s = select(k, v)
        else
            s = v
        end
        if returnTable then
            if asList then
                _insert(ret, s)
            else
                ret[k] = s
            end
        else
            if any then
                if any(k, v, s) then
                    return true, true
                end
            elseif all then
                if not all(k, v, s) then
                    return true, false
                end
            end
        end
        count = count + 1
        return false, false
    end

    if where == nil then
        if distinct == nil then
            -- both nil
            for k, v in pairs(data) do
                local directReturn, returnValue = iterate(k, v)
                if directReturn then
                    return returnValue
                end
            end
        else
            -- only distinct
            local filter1Distinct = {}
            for k, v in pairs(data) do
                local dk, dw = distinct(k, v)
                if filter1Distinct[dk] == nil or filter1Distinct[dk].w > dw then
                    filter1Distinct[dk] = {
                        w = dw,
                        k = k,
                        v = v,
                    }
                end
            end
            for _, d in pairs(filter1Distinct) do
                local directReturn, returnValue = iterate(d.k, d.v)
                if directReturn then
                    return returnValue
                end
            end
        end
    else
        if distinct == nil then
            -- only where
            for k, v in pairs(data) do
                if where(k, v) then
                    local directReturn, returnValue = iterate(k, v)
                    if directReturn then
                        return returnValue
                    end
                end
            end
        else
            -- both where and distinct
            local filter1Distinct = {}
            for k, v in pairs(data) do
                if where(k, v) then
                    local dk, dw = distinct(k, v)
                    if filter1Distinct[dk] == nil or filter1Distinct[dk].w > dw then
                        filter1Distinct[dk] = {
                            w = dw,
                            k = k,
                            v = v,
                        }
                    end
                end
            end
            for _, d in pairs(filter1Distinct) do
                local directReturn, returnValue = iterate(d.k, d.v)
                if directReturn then
                    return returnValue
                end
            end
        end
    end

    if returnTable then
        if sort then
            table.sort(ret, sort)
        end
        if groupBy then
            local groupRet = {}
            if asList then
                for i, v in ipairs(ret) do
                    local groupKey = groupBy(i, v)
                    local groupTab = groupRet[groupKey]
                    if groupTab == nil then
                        groupTab = {}
                        groupRet[groupKey] = groupTab
                    end
                    _insert(groupTab, v)
                end
            else
                for k, v in pairs(ret) do
                    local groupKey = groupBy(k, v)
                    local groupTab = groupRet[groupKey]
                    if groupTab == nil then
                        groupTab = {}
                        groupRet[groupKey] = groupTab
                    end
                    groupTab[k] = v
                end
            end
            return groupRet
        else
            return ret
        end
    else
        if any then
            return false
        elseif all then
            if count > 0 then
                return true
            else
                return false
            end
        end
    end
end

function table.randomSubset(tab, n)
    local result = {}
    local c = 0
    for k, item in pairs(tab) do
        c = c + 1
        if #result < n then
            table.insert(result, item)
        else
            local s = math.floor(math.random() * c)
            if s < n then
                result[s + 1] = item
            end
        end
    end
    return result
end

function table.equals(a, b, path)
    path = path or "/"
    local ta = type(a)
    local tb = type(b)
    if ta ~= tb then
        return false, path
    end
    if ta ~= "table" then
        if a == b then
            return true
        else
            return false, path
        end
    end
    for k, v in pairs(a) do
        if not table.equals(v, b[k], path .. tostring(k) .. "/") then
            return false, path .. tostring(k) .. "/"
        end
    end
    for k, v in pairs(b) do
        if a[k] == nil then
            return false, path .. tostring(k) .. "/"
        end
    end
    return true
end

function table.compare(a, b, info)
    info = info or { path = { "" }, left = nil, right = nil }
    local ta = type(a)
    local tb = type(b)
    if ta ~= tb then
        print(table.concat(info.path, "/"), ta, table.toJSON(a), tb, table.toJSON(b))
    else
        if ta ~= "table" then
            if a == b then
                return true
            else
                print(table.concat(info.path, "/"), ta, table.toJSON(a), tb, table.toJSON(b))
            end
        else
            local bKeys = {}
            for k, _ in pairs(b) do
                bKeys[k] = 1
            end
            for k, v in pairs(a) do
                bKeys[k] = nil
                table.insert(info.path, tostring(k))
                table.compare(v, b[k], info)
                table.remove(info.path, #info.path)
            end
            for k, _ in pairs(bKeys) do
                table.insert(info.path, tostring(k))
                table.compare(a[k], b[k], info)
                table.remove(info.path, #info.path)
            end
        end
    end
end

-- function table.equals2(o1, o2, ignore_mt)
--     if o1 == o2 then return true end
--     local o1Type = type(o1)
--     local o2Type = type(o2)
--     if o1Type ~= o2Type then return false end
--     if o1Type ~= 'table' then return false end

--     if not ignore_mt then
--         local mt1 = getmetatable(o1)
--         if mt1 and mt1.__eq then
--             --compare using built in method
--             return o1 == o2
--         end
--     end

--     local keySet = {}

--     for key1, value1 in pairs(o1) do
--         local value2 = o2[key1]
--         if value2 == nil or table.equals2(value1, value2, ignore_mt) == false then
--             return false
--         end
--         keySet[key1] = true
--     end

--     for key2, _ in pairs(o2) do
--         if not keySet[key2] then return false end
--     end
--     return true
-- end

function table.removeItem(tab, item)
    local c = #tab
    local i = 1
    local d = 0
    while i <= c do
        local it = tab[i]
        if it == item then
            d = d + 1
        else
            if d > 0 then
                tab[i - d] = it
            end
        end
        i = i + 1
    end
    for i = 0, d - 1 do
        tab[c - i] = nil
    end
end

---Checks if a table is used as an array. That is: the keys start with one and are sequential numbers
---NOTE: it returns true for an empty table
---@param t table
---@return bool
function table.isArray(t)
    if type(t) ~= "table" then
        return false
    end
    --check if all the table keys are numerical and count their number
    local count = 0
    for k, v in pairs(t) do
        if type(k) ~= "number" then
            return false
        else
            count = count + 1
        end
    end
    --all keys are numerical. now let's see if they are sequential and start with 1
    for i = 1, count do
        --Hint: the VALUE might be "nil", in that case "not t[i]" isn't enough, that's why we check the type
        if not t[i] and type(t[i]) ~= "nil" then
            return false
        end
    end
    return true
end

---@param t table
---@param indent string
---@return string
function table.toJSON(tab)
    local function parsePrimitive(o)
        local to = type(o)
        if to == "string" then
            return '"' .. o .. '"'
        end
        local so = tostring(o)
        if to == "function" then
            return '"' .. so .. '"'
        else
            return so
        end
    end
    local function parseTable(t, cached)
        if type(t) ~= "table" then
            return parsePrimitive(t)
        end
        cached = cached or {}
        local str = tostring(t)
        if cached[str] then
            return '"_ ref ' .. str .. '"'
        end
        cached[str] = true
        local items = {}
        for k, v in pairs(t) do
            local ks
            if type(k) == "number" then
                ks = "[" .. k .. "]"
            else
                ks = tostring(k)
            end
            table.insert(items, ks .. "=" .. parseTable(v, cached))
        end
        return "{" .. table.concat(items, ",") .. "}"
    end
    return parseTable(tab)
end

---@generic V
---@param tab V[]
---@param filter fun(item: V): bool
---@return V[] removed items
function table.filterInPlace(tab, filter)
    local ret = {}
    local c = #tab
    local i = 1
    local d = 0
    while i <= c do
        local it = tab[i]
        if filter(it) then
            if d > 0 then
                tab[i - d] = it
            end
        else
            t_insert(ret, it)
            d = d + 1
        end
        i = i + 1
    end
    for i = 0, d - 1 do
        tab[c - i] = nil
    end
    return ret
end


---@generic T, V
---@param t table<T, V>
---@return T[]
function table.keys(t)
    local keys = {}
    for k, _ in pairs(t) do
        keys[#keys + 1] = k
    end
    return keys
end

---@generic TKey, TValue, T
---@param t table<TKey, TValue> | TValue[]
---@param func fun(key: TKey, value: TValue): T
---@return T[]
function table.map(t, func)
    local ret = {}
    if type(t) == "table" then
        for k, v in pairs(t) do
            local res = func(k, v)
            if res ~= nil then
                ret[#ret + 1] = res
            end
        end
    end
    return ret
end

function table.concatMap(t, keyName)
    if type(t) == "table" then
        return table.concat(table.map(t, function(k, v)
            return v[keyName] or "NIL"
        end), ",")
    else
        return t
    end
end

function _arrayIter(a, i)
    local v = a[i]
    if v then
        return i, v
    end
end

function each(a)
    return _arrayIter, a, 0
end

function table.getOrCreateTable(t, k)
    local v = t[k]
    if not v then
        v = {}
        t[k] = v
    end
    return v
end

function table.getOrCreateTableByPath(t, ...)
    local a = table.getOrCreateTable
    local c = t
    for _, k in pairs({ ... }) do
        c = a(c, k)
    end
    return c
end

function table.access(t, ...)
    local p = { ... }
    local c = t
    for _, v in ipairs(p) do
        if type(c) == "table" then
            c = c[v]
        else
            return nil
        end
    end
    return c
end

---@generic K, V
---@param tab table<K, V>
---@return table<V, K>
function table.k2v(tab)
    local result = {}
    for k, v in pairs(tab) do
        result[v] = k
    end
    return result
end

function table.stringify(tab)
    local function parsePrimitive(o)
        local to = type(o)
        if to == "string" then
            return '"' .. o .. '"'
        end
        local so = tostring(o)
        if to == "function" then
            return '"' .. so .. '"'
        else
            return so
        end
    end
    local function parseTable(t, cached)
        if type(t) ~= "table" then
            return parsePrimitive(t)
        end
        cached = cached or {}
        local str = tostring(t)
        if cached[str] then
            return '"_ ref ' .. str .. '"'
        end
        cached[str] = true
        local items = {}
        for k, v in pairs(t) do
            local ks
            if type(k) == "number" then
                ks = "[" .. k .. "]"
            else
                ks = tostring(k)
            end
            table.insert(items, ks .. "=" .. parseTable(v, cached))
        end
        return "{" .. table.concat(items, ",") .. "}"
    end
    return parseTable(tab)
end

---从list中获得数量为N的组合
---@generic T
---@param list T[]
---@param n int
---@return T[][]
function table.combination(list, n)
    if n <= 0 then
        return {}
    end
    local len = #list
    n = math.min(len, n)
    local ptrs = {}
    for i = 1, n do
        table.insert(ptrs, i)
    end
    local result = {}
    while true do
        local one = {}
        for i = 1, n do
            local p = ptrs[i]
            table.insert(one, list[p])
        end
        table.insert(result, one)
        -- cant move
        if ptrs[1] > len - n then
            break
        end
        -- move ptr
        for i = n, 1, -1 do
            if ptrs[i] < len - (n - i) then
                ptrs[i] = ptrs[i] + 1
                for j = i + 1, n do
                    ptrs[j] = ptrs[i] + j - i
                end
                break
            end
        end
    end
    return result
end

---从list中获得所有组合
---@generic T
---@param list T[]
---@return T[][]
function table.allCombinations(list)
    local result = {}
    for i = 1, #list do
        for _, v in ipairs(table.combination(list, i)) do
            table.insert(result, v)
        end
    end
    return result
end
