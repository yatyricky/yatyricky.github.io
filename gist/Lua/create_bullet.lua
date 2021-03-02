require("gist.Lua.lib.table_ext")
local tab = require("gist.Lua.Bullet").Bullet

local sb = ""

local function s(any)
    local t = type(any)
    if t == "string" then
        return '"' .. any .. '"'
    end
    if t == "number" then
        if math.floor(any) == any then
            return tostring(any)
        else
            return any .. "f"
        end
    end
    if t == "boolean" then
        if any then
            return "true"
        else
            return "false"
        end
    end
    return tostring(any)
end

local function v(vec)
    return string.format('new Vector3(%sf, %sf, %sf)', vec.x, vec.y, vec.z)
end

local function a_i(a)
    if table.count(a) == 0 then
        return "new int[0]"
    end
    return string.format('new int[%s]{%s}', table.count(a), table.concat(a, ","))
end

for _, e in pairs(tab) do
    sb = sb .. 'asset = CreateInstance<Bullet>();\n'
    sb = sb .. 'asset.ID = '..s(e.ID)..';\n' -- number
    sb = sb .. 'asset.Name = '..s(e.Name)..';\n' -- string
    sb = sb .. 'asset.Prefab = '..s(e.Prefab)..';\n' -- string
    sb = sb .. 'asset.Shape = (Bullet.TBulletShape)'..s(e.Shape)..';\n' -- number
    sb = sb .. 'asset.ShapeSize = '..v(e.ShapeSize)..';\n' -- TVector3
    sb = sb .. 'asset.HitEffects = '..a_i(e.HitEffects)..';\n' -- number[]
    sb = sb .. 'asset.UpdateEffects = '..a_i(e.UpdateEffects)..';\n' -- number[]
    sb = sb .. 'asset.RemoveEffects = '..a_i(e.RemoveEffects)..';\n' -- number[]
    sb = sb .. 'asset.EnterAnim = '..s(e.EnterAnim)..';\n' -- string
    sb = sb .. 'asset.HitAnim = '..s(e.HitAnim)..';\n' -- string
    sb = sb .. 'asset.HitSound = '..s(e.HitSound)..';\n' -- string
    sb = sb .. 'asset.RemoveAnim = '..s(e.RemoveAnim)..';\n' -- string
    sb = sb .. 'asset.HitWallAnim = '..s(e.HitWallAnim)..';\n' -- string
    sb = sb .. 'asset.RemoveSound = '..s(e.RemoveSound)..';\n' -- string
    sb = sb .. 'asset.MoveType = (Bullet.TBulletMoveType)'..s(e.MoveType)..';\n' -- number
    sb = sb .. 'asset.WarnAnim = '..s(e.WarnAnim)..';\n' -- string
    sb = sb .. 'asset.Speed = '..s(e.Speed)..';\n' -- number
    sb = sb .. 'asset.MaxDistance = '..s(e.MaxDistance)..';\n' -- number
    sb = sb .. 'asset.MaxHurtTimes = '..s(e.MaxHurtTimes)..';\n' -- number

    sb = sb .. 'tab = new Table();\n'
    for key, value in pairs(e.ExtraMoveParam) do
        sb = sb .. 'tab.Set('..s(key)..', '..s(value)..');\n'
    end
    sb = sb .. 'asset.ExtraMoveParam = tab;\n'

    sb = sb .. 'asset.RemoveType = (Bullet.TBulletRemoveType)'..s(e.RemoveType)..';\n' -- number
    sb = sb .. 'asset.HurtCd = '..s(e.HurtCd)..';\n' -- number
    sb = sb .. 'asset.UpdateCD = '..s(e.UpdateCD)..';\n' -- number
    sb = sb .. 'asset.MaxDuration = '..s(e.MaxDuration)..';\n' -- number
    sb = sb .. 'asset.PierceKeepDamage = '..s(e.PierceKeepDamage)..';\n' -- boolean
    sb = sb .. 'asset.IsThroughWall = '..s(e.IsThroughWall)..';\n' -- boolean
    sb = sb .. 'asset.Pierce = '..s(e.Pierce)..';\n' -- number
    sb = sb .. 'asset.Reflect = '..s(e.Reflect)..';\n' -- number
    sb = sb .. 'asset.Transmit = '..s(e.Transmit)..';\n' -- number
    sb = sb .. 'asset.Split = '..s(e.Split)..';\n' -- number

    sb = sb .. 'AssetDatabase.CreateAsset(asset, "Assets/Editor/GameConfig/Bullets/'..e.ID..'.asset");\n'
end

print(sb)
