--nil, boolean, number, string, function, userdata, thread, and table
local function get_schema(any)
    if any == nil then
        return "nil"
    end
    local t = type(any)
    if t == "string" then
        return "string"
    end
    if t == "number" then
        return "number"
    end
    if t == "function" then
        return "function"
    end
    if t == "nil" then
        return "nil"
    end
    if t == "boolean" then
        return "boolean"
    end
    if t == "userdata" then
        return "userdata"
    end
    if t == "thread" then
        return "thread"
    end
    for key, value in pairs(any) do
        
    end
end

-- primitive type

-- table
-- field1: string
-- field2: number
-- field3?: table