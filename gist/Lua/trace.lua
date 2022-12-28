---Returns the stack trace at the code position where this function is called.
---The returned string includes war3map.lua/blizzard.j.lua code positions of all functions from the stack trace in the order of execution (most recent call last). It does NOT include function names.
---Credits to: https://www.hiveworkshop.com/threads/getstacktrace.340841/
---@return string stracktrace
function traceback()
    local trace, lastMsg, i, separator = "", "", 5, "\n"
    local function store(msg)
        lastMsg = msg:sub(1, -3)
    end --Passed to xpcall to handle the error message. Message is being saved to lastMsg for further use, excluding trailing space and colon.
    xpcall(error, store, "", 4) --starting at position 4 ensures that the functions "error", "xpcall" and "GetStackTrace" are not included in the trace.
    -- while lastMsg:sub(1, 11) == "war3map.lua" or lastMsg:sub(1, 14) == "blizzard.j.lua" do
    while lastMsg:sub(1, 18) == "gist\\Lua\\trace.lua" do
        trace = trace .. separator .. lastMsg
        xpcall(error, store, "", i)
        i = i + 1
    end
    return "Traceback (most recent call last)" .. trace
end

local function called()
    print("im callbed by", traceback())
end

local function f1()
    called()
end

local function f2()
    called()
end

f2()
