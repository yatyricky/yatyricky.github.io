function GetLanguageText(any)
    return any
end

local _require = require
function require(mod)
    if mod == "MemorySafe.SafeNumber" then
        return GetLanguageText
    else
        return _require(mod)
    end
end
