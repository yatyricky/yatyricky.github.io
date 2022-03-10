require("gist/Lua/lib/table_ext")
local bit = require("bit")

local define = {}

define.AlignmentNeutral = bit.lshift(1, 0) ---中立
define.AlignmentFriendly = bit.lshift(1, 1) ---友善
define.AlignmentHostile = bit.lshift(1, 2) ---敌对
local alignmentsCombinations = 7 --阵营组合数量 2^n-1，增加上面的枚举需要也修改这个值

define.FactionPlayer = bit.lshift(1, 0) ---玩家阵营
define.FactionMonster = bit.lshift(1, 1) ---怪物阵营
define.FactionMerchant = bit.lshift(1, 2) ---商人阵营

define.Alignment = {
    [define.FactionPlayer] = {
        [define.FactionPlayer] = define.AlignmentFriendly,
        [define.FactionMonster] = define.AlignmentHostile,
        [define.FactionMerchant] = define.AlignmentNeutral,
    },
    [define.FactionMonster] = {
        [define.FactionPlayer] = define.AlignmentHostile,
        [define.FactionMonster] = define.AlignmentFriendly,
        [define.FactionMerchant] = define.AlignmentNeutral,
    },
    [define.FactionMerchant] = {
        [define.FactionPlayer] = define.AlignmentNeutral,
        [define.FactionMonster] = define.AlignmentNeutral,
        [define.FactionMerchant] = define.AlignmentNeutral,
    },
}

define.AlignmentByFaction = {}
for faction, alignmentMap in pairs(define.Alignment) do
    local map = {}
    local a2f = {}
    local allF = 0
    for f, a in pairs(alignmentMap) do
        if a2f[a] == nil then
            a2f[a] = 0
        end
        a2f[a] = bit.bor(a2f[a], f)
        allF = bit.bor(allF, f)
    end
    -- a2f: {Alignment=Faction...}
    local as = table.keys(a2f) -- [Alignment...]
    local combs = table.allCombinations(as)
    for _, comb in ipairs(combs) do
        local mask = 0
        local fac = 0
        for _, a in pairs(comb) do
            local f = a2f[a]
            mask = bit.bor(mask, a)
            fac = bit.bor(fac, f)
        end
        map[mask] = fac
    end
    -- -1
    map[-1] = allF
    -- rest
    for i = 0, alignmentsCombinations do
        if map[i] == nil then
            map[i] = 0
        end
    end
    define.AlignmentByFaction[faction] = map
end

print(table.toJSON(define.AlignmentByFaction ))
