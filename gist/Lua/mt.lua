local I18N_TO_LANG_KEY = setmetatable({
    zh_CN = "Chinese",
    zh_TW = "ChineseTraditional",
}, {
    __index = function(t, k)
        return "English"
    end,
})

print(I18N_TO_LANG_KEY.zh_CN)
print(I18N_TO_LANG_KEY.zh_TW)
print(I18N_TO_LANG_KEY.en)
print(I18N_TO_LANG_KEY.en_US)
print(I18N_TO_LANG_KEY.vi)