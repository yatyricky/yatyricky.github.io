require("gist/Lua/lib/string_ext")

local function min0(v)
    return v < 0 and 0 or v
end

print(string.splitFirst("65535_adf", "_"))
print(string.splitFirst("", "_"))
print(string.splitFirst("65535_adf_zzz", "_"))
print(string.splitFirst("65535", "_"))
print(string.splitFirst("766_", "_"))
print(string.splitFirst("-65535", "_"))
print(string.splitFirst("-766_", "_"))
print(string.splitFirst("_999_", "_"))
print(string.splitFirst("itemset", "_"))

-- print(min0(-1))
-- print(min0(-0))
-- print(min0(0))
-- print(min0(1))