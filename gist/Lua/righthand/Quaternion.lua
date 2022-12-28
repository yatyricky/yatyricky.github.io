local Pi = 3.1415927

local m_min = math.min
local m_sin = math.sin
local m_cos = math.cos
local m_asin = math.asin
local m_acos = math.acos
local m_atan2 = math.atan2
local m_sqrt = math.sqrt

local _next = { 2, 3, 1 }

---@class Quaternion
---@field w real
---@field x real
---@field y real
---@field z real
local cls = {}
Quaternion = cls

---@return Quaternion
function cls.new(x, y, z, w)
    return setmetatable({
        x = x or 0,
        y = y or 0,
        z = z or 0,
        w = w or 0,
    }, cls)
end

local new = cls.new

---@return Quaternion
function cls:SetNormalize()
    local n = self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w

    if n ~= 1 and n > 0 then
        n = 1 / m_sqrt(n)
        self.x = self.x * n
        self.y = self.y * n
        self.z = self.z * n
        self.w = self.w * n
    end

    return self
end

local negativeFlip = -0.0001
local positiveFlip = 2 * math.pi - 0.0001

local function SanitizeEuler(euler)
    if euler.x < negativeFlip then
        euler.x = euler.x + 2 * math.pi
    elseif euler.x > positiveFlip then
        euler.x = euler.x - 2 * math.pi
    end

    if euler.y < negativeFlip then
        euler.y = euler.y + 2 * math.pi
    elseif euler.y > positiveFlip then
        euler.y = euler.y - 2 * math.pi
    end

    if euler.z < negativeFlip then
        euler.z = euler.z + 2 * math.pi
    elseif euler.z > positiveFlip then
        euler.z = euler.z + 2 * math.pi
    end
end

function cls:eulerAngles()
    local x = self.x
    local y = self.y
    local z = self.z
    local w = self.w

    local check = 2 * (y * z - w * x)

    if check < 0.999 then
        if check > -0.999 then
            local v = Vector3.new(-m_asin(check),
                    m_atan2(2 * (x * z + w * y), 1 - 2 * (x * x + y * y)),
                    m_atan2(2 * (x * y + w * z), 1 - 2 * (x * x + z * z)))
            SanitizeEuler(v)
            return v
        else
            local v = Vector3.new(half_pi, m_atan2(2 * (x * y - w * z), 1 - 2 * (y * y + z * z)), 0)
            SanitizeEuler(v)
            return v
        end
    else
        local v = Vector3.new(-half_pi, m_atan2(-2 * (x * y - w * z), 1 - 2 * (y * y + z * z)), 0)
        SanitizeEuler(v)
        return v
    end
end

---Returns a rotation that rotates z radians around the z axis, x radians around the x axis, and y radians around the y axis; applied in that order.
---@param x real | Vector3
---@param y real | Nil
---@param z real | Nil
---@return Quaternion
function cls.Euler(x, y, z)
    if y == nil and z == nil then
        y = x.y
        z = x.z
        x = x.x
    end

    local sx = m_sin(x * 0.5)
    local cx = m_cos(x * 0.5)
    local sy = m_sin(y * 0.5)
    local cy = m_cos(y * 0.5)
    local sz = m_sin(z * 0.5)
    local cz = m_cos(z * 0.5)

    return new(
        sx * cy * cz - cx * sy * sz,
        cx * sy * cz + sx * cy * sz,
        cx * cy * sz - sx * sy * cz,
        cx * cy * cz + sx * sy * sz
    )
end

---The dot product between two rotations.
---@param a Quaternion
---@param b Quaternion
---@return real
function cls.Dot(a, b)
    return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
end

---Returns the angle in radians between two rotations a and b.
---Example: Think of two GameObjects (A and B) moving around a third GameObject (C). Lines from C to A and C to B create a triangle which can change over time. The angle between CA and CB is the value Quaternion.Angle provides.
---@param a Quaternion
---@param b Quaternion
---@return real
function cls.Angle(a, b)
    local dot = cls.Dot(a, b)
    if dot < 0 then
        dot = -dot
    end
    return m_acos(m_min(dot, 1)) * 2
end

---Creates a rotation which rotates angle radians around axis.
---@param angle real
---@param axis Vector3
---@return Quaternion
function cls.AngleAxis(angle, axis)
    local normAxis = axis:Normalized()
    angle = angle * 0.5
    local s = m_sin(angle)

    local w = m_cos(angle)
    local x = normAxis.x * s
    local y = normAxis.y * s
    local z = normAxis.z * s

    return new(x, y, z, w)
end

---Creates a rotation with the specified forward and upwards directions.
---Z axis will be aligned with forward, X axis aligned with cross product between forward and upwards, and Y axis aligned with cross product between Z and X.
---Returns identity if the magnitude of forward is zero.
---If forward and upwards are colinear, or if the magnitude of upwards is zero, the result is the same as Quaternion.FromToRotation with fromDirection set to the positive Z-axis (0, 0, 1) and toDirection set to the normalized forwards direction.
---@param rForward Vector3
---@param rUp Vector3
---@return Quaternion | Nil
function cls.LookRotation(rForward, rUp)
    local forward = Vector3.new(rForward.x, rForward.z, rForward.y)
    local up = Vector3.new(rUp.x, rUp.z, rUp.y)

    local mag = forward:Magnitude()
    if mag < 0.00001 then
        error("error input forward to Quaternion.LookRotation " .. forward:tostring())
        return nil
    end

    forward = forward / mag
    up = up or Vector3.up()
    local right = Vector3.Cross(up, forward)
    right:SetNormalize()
    up = Vector3.Cross(forward, right)
    right = Vector3.Cross(up, forward)

    local t = right.x + up.y + forward.z

    local qr
    if t > 0 then
        local x, y, z, w
        t = t + 1
        local s = 0.5 / m_sqrt(t)
        w = s * t
        x = (up.z - forward.y) * s
        y = (forward.x - right.z) * s
        z = (right.y - up.x) * s

        qr = new(x, y, z, w):SetNormalize()
    else
        local rot = {
            { right.x, up.x, forward.x },
            { right.y, up.y, forward.y },
            { right.z, up.z, forward.z },
        }

        local q = { 0, 0, 0 }
        local i = 1

        if up.y > right.x then
            i = 2
        end

        if forward.z > rot[i][i] then
            i = 3
        end

        local j = _next[i]
        local k = _next[j]

        local t1 = rot[i][i] - rot[j][j] - rot[k][k] + 1
        local s = 0.5 / m_sqrt(t1)
        q[i] = s * t1
        local w = (rot[k][j] - rot[j][k]) * s
        q[j] = (rot[j][i] + rot[i][j]) * s
        q[k] = (rot[k][i] + rot[i][k]) * s

        qr = new(q[1], q[2], q[3], w):SetNormalize()
    end

    return new(-qr.x, -qr.z, -qr.y, qr.w)
end

local function UnclampedSlerp(q1, q2, t)
    local dot = q1.x * q2.x + q1.y * q2.y + q1.z * q2.z + q1.w * q2.w

    if dot < 0 then
        dot = -dot
        q2 = setmetatable({ x = -q2.x, y = -q2.y, z = -q2.z, w = -q2.w }, cls)
    end

    if dot < 0.95 then
        local angle = acos(dot)
        local invSinAngle = 1 / sin(angle)
        local t1 = sin((1 - t) * angle) * invSinAngle
        local t2 = sin(t * angle) * invSinAngle
        q1 = { x = q1.x * t1 + q2.x * t2, y = q1.y * t1 + q2.y * t2, z = q1.z * t1 + q2.z * t2, w = q1.w * t1 + q2.w * t2 }
        setmetatable(q1, cls)
        return q1
    else
        q1 = { x = q1.x + t * (q2.x - q1.x), y = q1.y + t * (q2.y - q1.y), z = q1.z + t * (q2.z - q1.z),
            w = q1.w + t * (q2.w - q1.w) }
        cls.SetNormalize(q1)
        setmetatable(q1, cls)
        return q1
    end
end

function cls.Slerp(from, to, t)
    if t < 0 then
        t = 0
    elseif t > 1 then
        t = 1
    end

    return UnclampedSlerp(from, to, t)
end

function cls.__index(_, k)
    return rawget(cls, k)
end

setmetatable(cls, cls)

return cls
