---@generic T
---@param object T
---@return T
function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function class(classname, super)
    local superType = type(super)
    local cls
    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end
    if superType == "function" or (super and super.__ctype == 1) then
        cls = {}
        if superType == "table" then
            for k, v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end
        cls.ctor = function() end
        cls.__cname = classname
        cls.__ctype = 1
        function cls.new(...)
            local instance = cls.__create(...)
            for k, v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    else
        if super then
            cls = clone(super)
            cls.super = super
        else
            cls = { ctor = function() end }
        end

        cls.__cname = classname
        cls.__ctype = 2
        cls.__index = cls
        function cls.new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    end
    return cls
end

-- function assert(value, expected)
--     local ta = type(value)
--     local tb = type(expected)
--     if value == expected then
--         print(string.format("[OK] %s(%s) is %s(%s)", value, type(value), expected, type(expected)))
--     else
--         print(string.format("[FAIL] %s(%s) is not %s(%s)", value, type(value), expected, type(expected)))
--     end
-- end

---@param obj any
---@param asStruct boolean true=return table false=return string rep
---@return ITypeParseSchema
function GetLuaType(obj, asStruct)
    ---@generic T
    ---@param object T
    ---@return T
    local function deepClone(object)
        local lookup_table = {}
        local function _copy(object)
            if type(object) ~= "table" then
                return object
            elseif lookup_table[object] then
                return lookup_table[object]
            end
            local new_table = {}
            lookup_table[object] = new_table
            for key, value in pairs(object) do
                new_table[_copy(key)] = _copy(value)
            end
            return setmetatable(new_table, getmetatable(object))
        end
        return _copy(object)
    end

    local function isArray(t)
        local maxIndex = 0
        local indexCount = 0
        for k, v in pairs(t) do
            if type(k) == "number" and math.floor(k) == k and k >= 1 then
                maxIndex = math.max(maxIndex, k)
                indexCount = indexCount + 1
            else
                return false, 0
            end
        end
        if maxIndex == indexCount then
            return true, maxIndex
        else
            return false, indexCount
        end
    end

    ---@class ITypeParseSchema
    ---@field prim number flags [0] primitive type [1] table<K,V> [2] array<V>
    ---@field typeName string string, number, boolean ...
    ---@field structName string IAutoName
    ---@field fields ITypeParseField[]
    ---@field arrayItem ITypeParseSchema

    ---@class ITypeParseField
    ---@field optional boolean is this field optional
    ---@field name string field name
    ---@field nameSchema ITypeParseSchema field name type
    ---@field typeSchema ITypeParseSchema field type

    ---@param a ITypeParseSchema
    ---@param b ITypeParseSchema
    ---@return number flags [-1] not same [0] exact same [1] partial compatible
    local function compareSchema(a, b)
        -- if a == nil or b == nil then
        --     return 1
        -- end
        -- if a.prim == 3 and b.prim == 3 then
        --     return 0
        -- end
        -- local function convertToTable(s)
        --     s.prim = 1
        --     s.structName = "empty"
        --     s.fields = {}
        -- end
        -- local function convertToArray(s)
        --     s.prim = 2
        -- end
        -- -- convert {} to table or array
        -- if a.prim == 3 then
        --     if b.prim == 1 then
        --         convertToTable(a)
        --     elseif b.prim == 2 then
        --         convertToArray(a)
        --     end
        -- end
        -- if b.prim == 3 then
        --     if a.prim == 1 then
        --         convertToTable(b)
        --     elseif a.prim == 2 then
        --         convertToArray(b)
        --     end
        -- end
        if a.prim ~= b.prim then
            return -1
        else
            if a.prim == 0 then
                if a.typeName == b.typeName then
                    return 0
                else
                    return -1
                end
            elseif a.prim == 1 then
                local added = {} ---@type table<string, ITypeParseField>
                local addedCount = #a.fields
                for _, field in pairs(a.fields) do
                    added[field.name] = field
                end
                local hasPartial = false
                for _, field in pairs(b.fields) do
                    local addedKV = added[field.name]
                    if addedKV then
                        local keySame = compareSchema(addedKV.nameSchema, field.nameSchema)
                        if keySame == -1 then
                            return -1
                        elseif keySame == 1 then
                            hasPartial = true
                        end
                        local valueSame = compareSchema(addedKV.typeSchema, field.typeSchema)
                        if valueSame == -1 then
                            return -1
                        elseif valueSame == 1 then
                            hasPartial = true
                        end
                        added[field.name] = nil
                        addedCount = addedCount - 1
                    else
                        hasPartial = true
                    end
                end
                if addedCount > 0 then
                    hasPartial = true
                elseif addedCount < 0 then
                    print("error, remove more keys")
                end
                if hasPartial then
                    return 1
                else
                    return 0
                end
            else
                return compareSchema(a.arrayItem, b.arrayItem)
            end
        end
    end

    ---@param a ITypeParseSchema
    ---@param b ITypeParseSchema
    ---@return ITypeParseSchema
    local function mergeSchema(a, b)
        local newSchema = {} ---@type ITypeParseSchema
        if a.prim == 0 then
            return {
                prim = 0,
                typeName = a.typeName,
            }
        elseif a.prim == 1 then
            newSchema.prim = 1
            newSchema.fields = {}
            local name2Index = {} ---@type table<string, number>
            for i, field in ipairs(a.fields) do
                local copiedField = deepClone(field)
                table.insert(newSchema.fields, copiedField)
                name2Index[field.name] = i
            end
            for _, field in pairs(b.fields) do
                local idx = name2Index[field.name]
                if idx then
                    local addedKV = newSchema.fields[idx]
                    addedKV.optional = addedKV.optional or field.optional
                    addedKV.nameSchema = mergeSchema(addedKV.nameSchema, field.nameSchema)
                    addedKV.typeSchema = mergeSchema(addedKV.typeSchema, field.typeSchema)
                    name2Index[field.name] = nil
                else
                    local copiedField = deepClone(field)
                    copiedField.optional = true
                    table.insert(newSchema.fields, copiedField)
                end
            end
            for _, idx in pairs(name2Index) do
                newSchema.fields[idx].optional = true
            end
        else
            newSchema.prim = 2
            newSchema.arrayItem = mergeSchema(a.arrayItem, b.arrayItem)
        end
        return newSchema
    end

    ---@return ITypeParseSchema
    local function getType(t)
        local tp = type(t)
        if tp == "table" then
            local isArr, arrCount = isArray(t)
            if isArr then
                if arrCount == 0 then
                    return {
                        prim = 2,
                        arrayItem = {
                            prim = 0,
                            typeName = "any",
                        }
                    }
                end
                local arrayGood = true
                local elemType = deepClone(getType(t[1]))
                for i = 2, arrCount do
                    local currentSchema = getType(t[i])
                    if compareSchema(elemType, currentSchema) == -1 then
                        arrayGood = false
                        break
                    else
                        elemType = mergeSchema(elemType, currentSchema)
                    end
                end
                if arrayGood then
                    return {
                        prim = 2,
                        arrayItem = elemType,
                    }
                end
            end
            local tabSchema = {
                prim = 1,
                structName = "IHola",
            }
            local allFields = {} ---@type ITypeParseField[]
            for k, v in pairs(t) do
                local currField = {
                    optional = false,
                    name = tostring(k),
                    nameSchema = getType(k),
                    typeSchema = getType(v),
                }
                table.insert(allFields, currField)
            end
            if #allFields == 0 then
                tabSchema.fields = {}
                return tabSchema
            end
            local mergeGood = true
            local finalField = allFields[1]
            for i = 2, #allFields do
                local currField = allFields[i]
                if finalField.nameSchema.prim == 0 and finalField.nameSchema.typeName == "string" then
                    mergeGood = false
                    break
                end
                if compareSchema(finalField.nameSchema, currField.nameSchema) == -1 then
                    mergeGood = false
                    break
                end
                if compareSchema(finalField.typeSchema, currField.typeSchema) == -1 then
                    mergeGood = false
                    break
                end
                finalField.nameSchema = mergeSchema(finalField.nameSchema, currField.nameSchema)
                finalField.typeSchema = mergeSchema(finalField.typeSchema, currField.typeSchema)
            end
            if mergeGood then
                tabSchema.fields = { finalField }
            else
                tabSchema.fields = allFields
            end
            return tabSchema
        else
            return {
                prim = 0,
                typeName = tp,
            }
        end
    end

    ---@param s ITypeParseSchema
    local function stringifyStruct(s)
        if s.prim == 0 then
            return s.typeName
        elseif s.prim == 1 then
            if #s.fields == 0 then
                return "{}"
            end
            if #s.fields == 1 then
                local field = s.fields[1]
                if field.nameSchema.prim == 0 and field.nameSchema.typeName == "number" then
                    return string.format("table<number, %s>", stringifyStruct(field.typeSchema))
                end
            end
            table.sort(s.fields, function(a, b)
                if a.optional ~= b.optional then
                    return b.optional
                end
                return a.name < b.name
            end)
            local sb = "{ "
            for i = 1, #s.fields do
                local field = s.fields[i]
                sb = sb .. string.format("%s%s: %s", field.name, field.optional and "?" or "", stringifyStruct(field.typeSchema))
                if i < #s.fields then
                    sb = sb .. ", "
                end
            end
            sb = sb .. " }"
            return sb
        else
            return string.format("%s[]", stringifyStruct(s.arrayItem))
        end
    end

    local struct = getType(obj)
    if asStruct then
        return struct
    else
        return stringifyStruct(struct)
    end
end

function SafeNumber(v)
    return v
end

function fts(fn)
    local info = debug.getinfo(fn, "S")
    return string.format("fn%s:%s-%s", info.source, info.linedefined, info.lastlinedefined)
end

local filter = {
    bind = 1,
    unbind = 1,
    unbindPaths = 1,
    unbindContext = 1,
    insert = 1,
    remove = 1,
    len = 1,
    pairs = 1,
    ipairs = 1,
}

function bountable2s(t)
    if type(t) == "table" then
        local tb = {}
        for key, value in pairs(t) do
            if not filter[key] then
                tb[key] = bountable2s(value)
            end
        end
        return tb
    else
        return t
    end
end
