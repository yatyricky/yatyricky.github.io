local Vector3 = require("gist.Lua.lib.Vector3")

local v1 = Vector3.new(3,1,4)
local norm = Vector3.new(0,0,1)

local proj = Vector3.Project(v1, norm)
local projPlane = Vector3.ProjectOnPlane(v1, norm)

print(proj:tostring())
print(projPlane:tostring())
