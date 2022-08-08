require("gist/Lua/lib/class")

-- https://www.lua.org/pil/11.4.html
local cls = class("PILQueue")

function cls:ctor(cap)
    self.cap = cap
    self.tab = {}
    self.first = 0
    self.last = -1
end

function cls:pushleft(value)
    local first = self.first - 1
    self.first = first
    self.tab[first] = value
    if self.cap and self:size() > self.cap then
        self:popright()
    end
end

function cls:pushright(value)
    local last = self.last + 1
    self.last = last
    self.tab[last] = value
    if self.cap and self:size() > self.cap then
        self:popleft()
    end
end

function cls:popleft()
    local first = self.first
    if first > self.last then
        error("queue is empty")
    end
    local value = self.tab[first]
    self.tab[first] = nil -- to allow garbage collection
    self.first = first + 1
    return value
end

function cls:popright()
    local last = self.last
    if self.first > last then
        error("self is empty")
    end
    local value = self.tab[last]
    self.tab[last] = nil -- to allow garbage collection
    self.last = last - 1
    return value
end

function cls:peekleft()
    return self.tab[self.first]
end

function cls:peekright()
    return self.tab[self.last]
end

function cls:size()
    return self.last - self.first + 1
end

function cls:tostring()
    local sb = ""
    for i = self.first, self.last do
        sb = sb .. tostring(self.tab[i]) .. " "
    end
    sb = sb .. "size:" .. self:size()
    return sb
end

function cls:totable()
    local t = {}
    for i = self.first, self.last do
        table.insert(t, self.tab[i])
    end
    return t
end

return cls
