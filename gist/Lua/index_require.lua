local configSelectorByModName = {
    ["gist.Lua.Conf"] = { ID = 1, Name = "Conf", en = "en", cn = "cn", bl = "cn" },
}

local cls = {}

local serverConfigId = "en"

local _require = require
local _configCache = {}
function require(modName)
    local cs = configSelectorByModName[modName]
    if cs then
        local cache = _configCache[modName]
        if not cache then
            cache = setmetatable({}, {
                __index = function(t, k)
                    local realModName = modName
                    local pathAffix = cs[serverConfigId]
                    if pathAffix then
                        if pathAffix == "en" then
                            realModName = modName .. "1"
                        elseif pathAffix == "cn" then
                            realModName = modName .. "2"
                        end
                    else
                        logErrorCode(ErrorCode.CrashAssertionFail, "unknown server config id " .. serverConfigId)
                    end
                    local tab = _require(realModName)
                    local v = tab[k]
                    print("real require", realModName)
                    rawset(t, k, v)
                    return v
                end
            })
            _configCache[modName] = cache
        end
        return cache
    else
        return _require(modName)
    end
end

function cls.ResetRequiredConfigs()
    for modName, cs in pairs(configSelectorByModName) do
        local cache = _configCache[modName]
        if cache then
            for k, _ in pairs(cache) do
                cache[k] = nil
            end
        end
    end
end

local conf = require("gist.Lua.Conf")
local config = require("gist.Lua.Config")

print(conf.Value, config.Value)
print(conf.Value, config.Value)

cls.ResetRequiredConfigs()
serverConfigId = "cn"

print(conf.Value, config.Value)
print(conf.Value, config.Value)

cls.ResetRequiredConfigs()
serverConfigId = "en"

print(conf.Value, config.Value)
print(conf.Value, config.Value)