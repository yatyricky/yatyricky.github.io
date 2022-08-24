local mapdb = require("client.Assets.LuaFramework.config.ExportData.Config.MapDB")

local function serializePos(pos)
    return table.concat(pos, ",")
end

local mapPos = {}
local posCount = 0

local function countPos(pos)
    local ser = serializePos(pos)
    mapPos[ser] = 1
    posCount = posCount + 1
end

local function serializeEId(eId)
    table.sort(eId)
    return table.concat(eId, ",")
end

local mapEid = {}
local eIdCount = 0

local function countEId(pos)
    local ser = serializeEId(pos)
    mapEid[ser] = 1
    eIdCount = eIdCount + 1
end

local function counttable(tab)
    local c = 0
    for k, v in pairs(tab) do
        c = c + 1
    end
    return c
end

print(mapdb.data.distortion[2])

mapdb.data = nil

for theme, themeData in pairs(mapdb) do
    for folder, folderData in pairs(themeData) do
        for mapName, mapData in pairs(folderData) do
            for i, waveData in ipairs(mapData.waves) do
                for ii, pointData in ipairs(waveData) do
                    countPos(pointData.pos)
                    countEId(pointData.eId)
                end
            end
        end
    end
end

print("pos", counttable(mapPos), posCount)
print("eid", counttable(mapEid), eIdCount)
