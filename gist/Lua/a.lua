local a = true
local b = false

local function fun(a, b)
if a and b then
    return "both true"
elseif a then
    return "b false"
elseif b then
    return "a false"
else
    return "both false"
end
end

print(fun(true, true) == "both true")
print(fun(true, false) == "b false")
print(fun(false, true) == "a false")
print(fun(false, false) == "both false")