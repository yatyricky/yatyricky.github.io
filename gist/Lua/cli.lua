--region ext funcs

function table.keys(t)
    local keys = {}
    for k, _ in pairs(t) do
        keys[#keys + 1] = k
    end
    return keys
end

function string.start_with(str1, str2)
    return string.sub(str1, 1, #str2) == str2
end

function string.isNilOrEmpty(str)
    return str == nil or str == ""
end

function table.isSubsetOf(a, b, info)
    info = info or { path = { "" }, left = nil, right = nil }
    local ta = type(a)
    local tb = type(b)
    if ta ~= tb then
        -- info.left = string.format("Left=[%s]%s", ta, tostring(a))
        -- info.right = string.format("Right=[%s]%s", tb, tostring(b))
        print(table.concat(info.path, "/"), ta, tostring(a), tb, tostring(b))
    else
        if ta ~= "table" then
            if a == b then
                return true
            else
                -- info.left = string.format("Left=[%s]%s", ta, tostring(a))
                -- info.right = string.format("Right=[%s]%s", tb, tostring(b))
                print(table.concat(info.path, "/"), ta, tostring(a), tb, tostring(b))
            end
        else
            for k, v in pairs(a) do
                table.insert(info.path, tostring(k))
                if b then
                    table.isSubsetOf(v, b[k], info)
                end
                table.remove(info.path, #info.path)
            end
        end
    end
end

--endregion

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

local h = io.popen("cd")
local cd = h:read("*a")
h:close()

-- print(cd)

-- $path $filepath $SHA

local path = string.gsub(arg[1], "\\", "/")
local file = string.gsub(arg[2], "\\", "/")
local sha = arg[3]

local before
local after

local git = string.format("git --git-dir=%s/.git --work-tree=%s", path, path)

if sha == "$SHA" then
    -- unversioned
    -- before
    local cmd = string.format("%s --no-pager show HEAD:%s", git, file)
    local handle = io.popen(cmd)
    before = handle:read("*a")
    handle:close()
    -- after
    local f = io.open(path .. "/" .. file, "r")
    after = f:read("*all")
    f:close()
else
    -- committed
    -- before
    local cmd = string.format("%s --no-pager show %s~1:%s", git, sha, file)
    local handle = io.popen(cmd)
    before = handle:read("*a")
    handle:close()
    -- after
    cmd = string.format("%s --no-pager show %s:%s", git, sha, file)
    handle = io.popen(cmd)
    after = handle:read("*a")
    handle:close()
end

local fh = io.open("before.lua", "w")
io.output(fh)
io.write(before)
io.close(fh)

fh = io.open("after.lua", "w")
io.output(fh)
io.write(after)
io.close(fh)

local function findMainTab(tab)
    local keys = {}
    for k, _ in pairs(tab) do
        if k ~= "Enum" then
            keys[#keys + 1] = k
        end
    end
    table.sort(keys)
    for _, k in ipairs(keys) do
        if string.find(k, "By") then
            return k
        end
    end
    return keys[1]
end

local function exec()
    local Before = require("before")
    local After = require("after")

    local beforeKey = findMainTab(Before)
    local afterKey = findMainTab(After)

    if beforeKey == afterKey and beforeKey ~= nil then
        print("开始比对这张表")
        print(beforeKey)
        print("路径","左类型","左值","右类型","右值")
        local ta = Before[beforeKey]
        local tb = After[beforeKey]
        table.isSubsetOf(ta, tb)
    else
        print("没找到配置里面需要比对的表")
        print(beforeKey)
        print(afterKey)
    end
end

if not pcall(exec) then
    print("你选的应该不是配置")
end

os.remove("before.lua")
os.remove("after.lua")
