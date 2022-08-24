local old_require = require

function require(mod)
    if mod == "MemorySafe.SafeNumber" then
        return function (val)
            return {
                _is_safe = true,
                _value = val
            }
        end
    end

    return old_require(mod)
end

-- string:      stext
-- bool:        b1
-- number:      n2.5
-- table:       t123
-- safe number: e2.5

local store = {}
local to_restore = {}
local count = 0

local function is_primitive_type(val)
    local tt = type(val)
    if tt == "number" or tt == "boolean" or tt == "string" then
        return true
    end

    return false
end

local function is_primitive_table(tab)
    if next(tab) == nil then
        return true
    else
        for k, v in pairs(tab) do
            if not is_primitive_type(k) or not is_primitive_type(v) then
                return false
            end
        end
        return true
    end
end

local function get_signature_primitive(val)
    local tt = type(val)
    if tt == "number" then
        return "___n" .. tostring(val)
    elseif tt == "boolean" then
        return val and  "___b1"  or "___b0"
    elseif tt == "string" then
        if string.sub(val, 1, 3) == "___" then
            return val
        else
            return "___s" .. val
        end
    else
        error("holy shit!")
    end
end

local function get_signature_simple_table(tab)
    local items = {}
    for k, v in pairs(tab) do
        table.insert(items, {
            k = get_signature_primitive(k),
            v = get_signature_primitive(v)
        })
    end
    table.sort(items, function(a, b)
        return a.k < b.k
    end)
    local vs = {}
    for i, v in ipairs(items) do
        table.insert(vs, v.k .. "=" .. v.v)
    end
    local tabRef = "{" .. table.concat(vs, ",") .. "}"
    if not store[tabRef] then
        count = count + 1
        store[tabRef] = "___t" .. tostring(count)
        to_restore[count] = items
    end
    return store[tabRef]
end

local function convert(tab)
    if type(tab) == "table" then
        for k, v in pairs(tab) do
            if type(v) == "table" then
                if is_primitive_table(v) then
                    v = get_signature_simple_table(v)
                else
                    v = convert(v)
                end
            end

            if type(k) == "table" then
                tab[k] = nil
                if is_primitive_table(k) then
                    v = get_signature_simple_table(k)
                else
                    v = convert(k)
                end
            end
            tab[k] = v
        end
        return get_signature_simple_table(tab)
    end
end

local was_meta = {}

function setmetatable(any)
    was_meta[convert(any)] = 1
    return any
end

local t = require("big_config")

convert(t.Item)

local k2v = {}
local keys = {}

for key, value in pairs(store) do
    k2v[value] = key
    table.insert(keys, value)
end

table.sort(keys, function(a, b)
    return tonumber(string.sub(a, 5)) < tonumber(string.sub(b, 5))
end)

local function restore_base(val)
    if string.sub(val, 1, 3) == "___" then
        local c = string.sub(val, 4, 4)
        local raw = string.sub(val, 5)
        if c == "n" then
            return tonumber(raw)
        elseif c == "b" then
            return raw == "1"
        elseif c == "s" then
            return raw
        elseif c == "t" then
            return val
        else
            error("????")
        end
    else
        return val
    end
end

local function format_key(k)
    if type(k) == "number" then
        return string.format("[%s]", k)
    else
        return tostring(k)
    end
end

local function format_value(v)
    local tv = type(v)
    if tv == "string" then
        if string.sub(v, 1, 4) == "___t" then
            return string.format("t[%s]", string.sub(v, 5))
        else
            return string.format('"%s"', v)
        end
    elseif tv == "boolean" then
        return v and "true" or "false"
    else
        return tostring(v)
    end
end

local function restore(kv)
    local rest = {}
    for _, kvp in ipairs(kv) do
        local k = restore_base(kvp.k)
        local v = restore_base(kvp.v)
        table.insert(rest, string.format("%s = %s", format_key(k), format_value(v)))
    end
    return "{ " .. table.concat(rest, ", ") .. " }"
end

-- emit code
print("local t = {}")
for i, to_rest in ipairs(to_restore) do
    local expr = restore(to_rest)
    if was_meta["___t" .. tostring(i)] then
        expr = "setmetatable(" .. expr .. ", __meta__)"
    end
    print("t[" .. tostring(i) .. "] = " .. expr)
end

for key, value in pairs(was_meta) do
    print(key, value)
end

-- print(get_signature(t))
-- print(get_signature(t.config[3].map))
