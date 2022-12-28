---@alias real number

local deg2rad = math.pi / 180
local rad2deg = 180 / math.pi

require("Vector3")
require("Quaternion")

local forward = Vector3.forward()

local r = Quaternion.LookRotation(Vector3.new(1,0,0), Vector3.up())
local v = forward * r

print((r:eulerAngles() * rad2deg):tostring())
