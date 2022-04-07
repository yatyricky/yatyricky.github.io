-- begin poly fill
function SafeNumber(any)
    return any
end

function GetLanguageText(any)
    return any
end

function setmetatable(t, mt)
    return t
end

local config = require("gist/Lua/config")
local tabName = "Language"

local function TableToJSON(t)
    local function escapeString(s)
        s = string.gsub(s, '\\', '\\\\')
        s = string.gsub(s, "\n", "\\n")
        s = string.gsub(s, "\r", "\\r")
        s = string.gsub(s, '"', '\\"')
        return s
    end
    local function parsePrimitive(o)
        local to = type(o)
        if to == "string" then
            return '"' .. escapeString(o) .. '"'
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
            return '"__ref:' .. str .. '"'
        end
        cached[str] = true
        local kvs = {}
        for k, v in pairs(t) do
            table.insert(kvs, '"' .. tostring(k) .. '":' .. parseTable(v, cached))
        end
        return "{" .. table.concat(kvs, ",") .. "}"
    end
    return parseTable(t)
end

-- end poly fill

local json = TableToJSON(config[tabName])

local file = io.open("config.json", "w")
io.output(file)
io.write(json)
io.close(file)
