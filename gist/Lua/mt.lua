require("gist/Lua/lib/table_ext")

-- local I18N_TO_LANG_KEY = setmetatable({
--     zh_CN = "Chinese",
--     zh_TW = "ChineseTraditional",
-- }, {
--     __index = function(t, k)
--         return "English"
--     end,
-- })

-- print(I18N_TO_LANG_KEY.zh_CN)
-- print(I18N_TO_LANG_KEY.zh_TW)
-- print(I18N_TO_LANG_KEY.en)
-- print(I18N_TO_LANG_KEY.en_US)
-- print(I18N_TO_LANG_KEY.vi)

-- local function isSafeValue(t)
--     local tp = type(t)
--     print("working with " .. table.show(t) .. " " .. tp)
--     return type(t) == "table"
-- end

-- local mt = {
--     __lt = function(va, vb)
--         local a = isSafeValue(va) and va.v or va
--         local b = isSafeValue(vb) and vb.v or vb
--         return a < b
--     end,
--     __le = function(va, vb)
--         local a = isSafeValue(va) and va.v or va
--         local b = isSafeValue(vb) and vb.v or vb
--         return a <= b
--     end
-- }

-- local a = setmetatable({v=2},mt)
-- local b = setmetatable({v=1},mt)

-- print(a<b)

local t = setmetatable({}, {
    __newindex = function(t,k,v)
        rawset(t, "dirty", true)
        rawset(t, k, v)
    end
})

print(table.show(t))
t.asd = 1
t.dirty = false
print(table.show(t))
t.blah = "blah"
print(table.show(t))