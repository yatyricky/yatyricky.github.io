function table.isEmpty(t)
    return next(t) == nil
end

function table.show(t, name, indent)
    local cart     -- a container
    local autoref  -- for self references

    -- (RiciLake) returns true if the table is empty
    local function isemptytable(t) return next(t) == nil end

    local function basicSerialize(o)
        local so = tostring(o)
        if type(o) == "function" then
            local info = debug.getinfo(o, "S")
            -- info.name is nil because o is not a calling level
            if info.what == "C" then
                return string.format("%q", so .. ", C function")
            else
                -- the information is defined through lines
                return string.format("%q", so .. ", defined in (" ..
                info.linedefined .. "-" .. info.lastlinedefined ..
                ")" .. info.source)
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
            cart = cart .. " = " .. basicSerialize(value) .. ";\n"
        else
            if saved[value] then
                cart = cart .. " = {}; -- " .. saved[value]
                .. " (self reference)\n"
                autoref = autoref .. name .. " = " .. saved[value] .. ";\n"
            else
                saved[value] = name

                if isemptytable(value) then
                    cart = cart .. " = {}; (" .. tostring(value) .. ")\n"
                else
                    cart = cart .. " = { (" .. tostring(value) .. ")\n"
                    for k, v in pairs(value) do
                        k = basicSerialize(k)
                        local fname = string.format("%s[%s]", name, k)
                        field = string.format("[%s]", k)
                        -- three spaces between levels
                        addtocart(v, fname, indent .. "   ", saved, field)
                    end
                    cart = cart .. indent .. "};\n"
                end
            end
        end
    end

    name = name or "__unnamed__"
    if type(t) ~= "table" then
        return name .. " = " .. basicSerialize(t)
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

---@generic K, V, T, U, W
---@param data table<K, V> | V[]
---@param opts { select: (fun(k: K, v: V): T), where: (fun(k: K, v: V): boolean), any: (fun(k: K, v: V): boolean), all: (fun(k: K, v: V): boolean), sort: (fun(a: T | V, b: T | V): boolean), distinct: (fun(k: K, v: V): U), groupBy: (fun(k: K, v: V): W), asList: boolean }
---@param opts.select (fun(k: K, v: V): T) K is key, V is value.
---@param opts.where (fun(k: K, v: V): boolean) Condition.
---@param opts.sort (fun(a: T | V, b: T | V): boolean) If select is present, use select's return value, otherwise use V.
---@param opts.distinct (fun(k: K, v: V): U) The first of those who return the same U will be used. After sort.
---@param opts.groupBy (fun(k: K, v: V): W) All those who return the same W will be grouped. After sort.
---@param opts.asList boolean Ignore table's key, use 1, 2, 3... instead.
---@param opts.all (fun(k: K, v: V): boolean) table.query returns boolean. Ignores select.
---@param opts.any (fun(k: K, v: V): boolean) table.query returns boolean. Ignores select and all.
---@return table<K, V> | T[] | boolean
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

    local bst = nil
    local function bstAdd(data)
        local newNode = { v = data, l = nil, r = nil }
        if bst == nil then
            bst = newNode
        else
            local cursor = bst
            local prev
            local isl = true
            while cursor ~= nil do
                prev = cursor
                if sort(data, cursor.v) then
                    cursor = cursor.l
                    isl = true
                else
                    cursor = cursor.r
                    isl = false
                end
            end
            if isl then
                prev.l = newNode
            else
                prev.r = newNode
            end
        end
    end

    local returnTable = select or (any == nil and all == nil) -- return type is table or bool
    local ret = {}
    local key
    local value
    for k, v in pairs(data) do
        if where then
            if where(k, v) then
                if returnTable then
                    if asList then
                        key = #ret + 1
                    else
                        key = k
                    end
                    if select then
                        value = select(k, v)
                    else
                        value = v
                    end
                    if sort then
                        bstAdd(value)
                    end
                    ret[key] = value
                else
                    if any then
                        if any(k, v) then
                            return true
                        end
                    elseif all then
                        if not all(k, v) then
                            return false
                        end
                    end
                end
            end
        else
            if returnTable then
                if asList then
                    key = #ret + 1
                else
                    key = k
                end
                if select then
                    value = select(k, v)
                else
                    value = v
                end
                if sort then
                    bstAdd(value)
                end
                ret[key] = value
            else
                if any then
                    if any(k, v) then
                        return true
                    end
                elseif all then
                    if not all(k, v) then
                        return false
                    end
                end
            end
        end
    end
    if returnTable then
        local distinctRet
        local groupRet
        if sort then
            local obst = {}
            local function bstOut(node)
                if node == nil then
                    return
                end
                bstOut(node.l)
                obst[#obst + 1] = node.v
                bstOut(node.r)
            end
            bstOut(bst)
            distinctRet = obst
        else
            distinctRet = ret
        end
        if distinct then
            ret = {}
            local distinctMap = {}
            for k, v in pairs(distinctRet) do
                local distinctKey = distinct(k, v)
                if distinctMap[distinctKey] == nil then
                    distinctMap[distinctKey] = 1
                    ret[k] = v
                end
            end
            groupRet = ret
        else
            groupRet = distinctRet
        end
        if groupBy then
            ret = {}
            for k, v in pairs(groupRet) do
                local groupKey = groupBy(k, v)
                if not ret[groupKey] then
                    ret[groupKey] = {}
                end
                if asList then
                    table.insert(ret[groupKey], v)
                else
                    ret[groupKey][k] = v
                end
            end
            return ret
        else
            return groupRet
        end
    else
        if any then
            return false
        elseif all then
            return true
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
        if not table.equals(v, b[k], path ..tostring(k).."/") then
            return false, path..tostring(k).."/"
        end
    end
    for k, v in pairs(b) do
        if a[k] == nil then
            return false, path..tostring(k).."/"
        end
    end
    return true
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

function table.filterInPlace(tab, filter)
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
            d = d + 1
        end
        i = i + 1
    end
    for i = 0, d - 1 do
        tab[c - i] = nil
    end
end
