local function nullify(any)
    return any
end

GetLanguageText = nullify
setmetatable = nullify
SafeNumber = nullify

local requireNone = {
    ["MemorySafe.SafeNumber"] = nullify
}

local _require = require
function require(mod)
    if requireNone[mod] ~= nil then
        return requireNone[mod]
    else
        return _require(mod)
    end
end
