local NAME = "Store"

-- Generated by github.com/davyxu/tabtoy
-- Version: 2.9.1
local __meta__ = {
	__index = function(t, k)
		local val = rawget(t, '_' .. k)
		if not val then return nil end
		if type(val) == "string" then
			return GetLanguageText(val)
		elseif type(val) == "table" then
			local list = {}
			for i, v in ipairs(val) do
				list[i] = GetLanguageText(v)
			end
			return list
		else
			return val
		end
	end
}

local tab = {
	Store = {
		setmetatable({ ID = 1, MallID = 1, _Title = "Pile of Gems", IsValid = 1, Price = "99", DiscountDuration = 0, VideoParams = {  }, DropType = 0, FirstItems = {  }, Items = { [2]= 80 }, PreItemID = 0, ConditionType = 0, ConditionParam = "", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 0, Params = "icon,gems_01;color,00FF06", ShowPlace = 0, ShowParams = "category,gems", Unique = 1, ShowWeight = 300 	}, __meta__),
		setmetatable({ ID = 2, MallID = 2, _Title = "Heap of Gems", IsValid = 1, Price = "499", DiscountDuration = 0, VideoParams = {  }, DropType = 0, FirstItems = {  }, Items = { [2]= 500 }, PreItemID = 0, ConditionType = 0, ConditionParam = "", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 0, Params = "icon,gems_02;color,00FF06", ShowPlace = 0, ShowParams = "category,gems", Unique = 2, ShowWeight = 301 	}, __meta__),
		setmetatable({ ID = 3, MallID = 3, _Title = "Bucket of Gems", IsValid = 1, Price = "999", DiscountDuration = 0, VideoParams = {  }, DropType = 0, FirstItems = {  }, Items = { [2]= 1200 }, PreItemID = 0, ConditionType = 0, ConditionParam = "", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 0, Params = "icon,gems_03;color,00FF06", ShowPlace = 0, ShowParams = "category,gems", Unique = 3, ShowWeight = 302 	}, __meta__),
		setmetatable({ ID = 4, MallID = 4, _Title = "Barrel of Gems", IsValid = 1, Price = "1999", DiscountDuration = 0, VideoParams = {  }, DropType = 0, FirstItems = {  }, Items = { [2]= 2500 }, PreItemID = 0, ConditionType = 0, ConditionParam = "", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 0, Params = "icon,gems_04;color,00FF06", ShowPlace = 0, ShowParams = "category,gems", Unique = 4, ShowWeight = 303 	}, __meta__),
		setmetatable({ ID = 5, MallID = 5, _Title = "Chest of Gems", IsValid = 1, Price = "4999", DiscountDuration = 0, VideoParams = {  }, DropType = 0, FirstItems = {  }, Items = { [2]= 6500 }, PreItemID = 0, ConditionType = 0, ConditionParam = "", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 0, Params = "icon,gems_05;color,00FF06", ShowPlace = 0, ShowParams = "category,gems", Unique = 5, ShowWeight = 304 	}, __meta__),
		setmetatable({ ID = 6, MallID = 6, _Title = "Cart of Gems", IsValid = 1, Price = "9999", DiscountDuration = 0, VideoParams = {  }, DropType = 0, FirstItems = {  }, Items = { [2]= 14000 }, PreItemID = 0, ConditionType = 0, ConditionParam = "", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 0, Params = "icon,gems_06;color,00FF06", ShowPlace = 0, ShowParams = "category,gems", Unique = 6, ShowWeight = 305 	}, __meta__),
		setmetatable({ ID = 104, MallID = 104, _Title = "hero_104", IsValid = 1, Price = "99", DiscountDuration = 0, VideoParams = {  }, DropType = 0, FirstItems = {  }, Items = { [104]= 1 }, PreItemID = 0, ConditionType = 2, ConditionParam = "104", LimitCycle = 0, LimitTimes = 1, Duration = 0, ItemType = 2, Params = "", ShowPlace = 1, ShowParams = "", Unique = 104, ShowWeight = 0 	}, __meta__),
		setmetatable({ ID = 1001, MallID = 1001, _Title = "Novice Gift Pack", IsValid = 1, Price = "199", DiscountDuration = 0, VideoParams = {  }, DropType = 0, FirstItems = {  }, Items = { [2]= 300,[21113]= 1,[1]= 10000,[3]= 20 }, PreItemID = 0, ConditionType = 1, ConditionParam = "", LimitCycle = 0, LimitTimes = 1, Duration = 0, ItemType = 3, Params = "title,title_novice;desc,desc_novice;extra,extra_desc", ShowPlace = 2, ShowParams = "category,novice;icon,gift_novice", Unique = 1001, ShowWeight = 0 	}, __meta__),
		setmetatable({ ID = 1002, MallID = 1001, _Title = "Novice Gift Pack", IsValid = 1, Price = "199", DiscountDuration = 0, VideoParams = {  }, DropType = 0, FirstItems = {  }, Items = { [2]= 300,[21113]= 1,[1]= 10000,[3]= 20 }, PreItemID = 0, ConditionType = 1, ConditionParam = "", LimitCycle = 0, LimitTimes = 1, Duration = 0, ItemType = 3, Params = "title,title_novice;desc,desc_novice;extra,extra_desc", ShowPlace = 0, ShowParams = "category,packs", Unique = 1002, ShowWeight = 100 	}, __meta__),
		setmetatable({ ID = 1101, MallID = 1101, _Title = "gift_hero_101", IsValid = 1, Price = "99", DiscountDuration = 0, VideoParams = {  }, DropType = 0, FirstItems = {  }, Items = { [1]= 5000,[1001]= 50 }, PreItemID = 0, ConditionType = 3, ConditionParam = "101", LimitCycle = 0, LimitTimes = 1, Duration = 259200, ItemType = 4, Params = "desc,gift_hero_101;prefab,skin_101", ShowPlace = 3, ShowParams = "icon,giftbox", Unique = 1101, ShowWeight = 1 	}, __meta__),
		setmetatable({ ID = 1102, MallID = 1102, _Title = "gift_hero_102", IsValid = 1, Price = "499", DiscountDuration = 0, VideoParams = {  }, DropType = 0, FirstItems = {  }, Items = { [1]= 10000,[1002]= 60 }, PreItemID = 0, ConditionType = 3, ConditionParam = "102", LimitCycle = 0, LimitTimes = 1, Duration = 259200, ItemType = 4, Params = "desc,gift_hero_102;prefab,skin_102", ShowPlace = 3, ShowParams = "icon,giftbox", Unique = 1101, ShowWeight = 2 	}, __meta__),
		setmetatable({ ID = 1103, MallID = 1103, _Title = "gift_hero_103", IsValid = 1, Price = "999", DiscountDuration = 0, VideoParams = {  }, DropType = 0, FirstItems = {  }, Items = { [1]= 20000,[1003]= 70 }, PreItemID = 0, ConditionType = 3, ConditionParam = "103", LimitCycle = 0, LimitTimes = 1, Duration = 259200, ItemType = 4, Params = "desc,gift_hero_103;prefab,skin_103", ShowPlace = 3, ShowParams = "icon,giftbox", Unique = 1101, ShowWeight = 3 	}, __meta__),
		setmetatable({ ID = 1104, MallID = 1104, _Title = "gift_hero_104", IsValid = 1, Price = "1999", DiscountDuration = 0, VideoParams = {  }, DropType = 0, FirstItems = {  }, Items = { [1]= 30000,[1004]= 80 }, PreItemID = 0, ConditionType = 3, ConditionParam = "104", LimitCycle = 0, LimitTimes = 1, Duration = 259200, ItemType = 4, Params = "desc,gift_hero_104;prefab,skin_104", ShowPlace = 3, ShowParams = "icon,giftbox", Unique = 1101, ShowWeight = 4 	}, __meta__),
		setmetatable({ ID = 2001, MallID = 2001, _Title = "Piggy bank", IsValid = 1, Price = "499", DiscountDuration = 0, VideoParams = {  }, DropType = 0, FirstItems = {  }, Items = { [999]= 1 }, PreItemID = 0, ConditionType = 1, ConditionParam = "", LimitCycle = 0, LimitTimes = 1, Duration = 0, ItemType = 5, Params = "data,688:1|188:2|288:3|388:4|488:5|588:6|688:7;title,ui_piggybank_title;desc,ui_piggybank_desc;desc2,ui_piggybank_desc2;info,ui_piggybank_立即领取;info1,ui_piggybank_condition;info2,ui_piggybank_condition_1day;info2s,ui_piggybank_condition2", ShowPlace = 3, ShowParams = "icon,piggy_bank", Unique = 2001, ShowWeight = 0 	}, __meta__),
		setmetatable({ ID = 5001, MallID = 0, _Title = "Heap of Coins", IsValid = 1, Price = "2,10", DiscountDuration = 0, VideoParams = {  }, DropType = 1, FirstItems = {  }, Items = {  }, PreItemID = 0, ConditionType = 0, ConditionParam = "", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 1, Params = "mult,1;icon,coins_02;color,00FF06", ShowPlace = 0, ShowParams = "category,coins", Unique = 5001, ShowWeight = 401 	}, __meta__),
		setmetatable({ ID = 5002, MallID = 0, _Title = "Barrel of Coins", IsValid = 1, Price = "2,100", DiscountDuration = 0, VideoParams = {  }, DropType = 1, FirstItems = {  }, Items = {  }, PreItemID = 0, ConditionType = 0, ConditionParam = "", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 1, Params = "mult,1.1;icon,coins_04;color,00FF06", ShowPlace = 0, ShowParams = "category,coins", Unique = 5002, ShowWeight = 402 	}, __meta__),
		setmetatable({ ID = 5003, MallID = 0, _Title = "Cart of Coins", IsValid = 1, Price = "2,1000", DiscountDuration = 0, VideoParams = {  }, DropType = 1, FirstItems = {  }, Items = {  }, PreItemID = 0, ConditionType = 0, ConditionParam = "", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 1, Params = "mult,1.2;icon,coins_06;color,00FF06", ShowPlace = 0, ShowParams = "category,coins", Unique = 5003, ShowWeight = 403 	}, __meta__),
		setmetatable({ ID = 6001, MallID = 0, _Title = "黄金宝箱", IsValid = 1, Price = "10000001,1", DiscountDuration = 0, VideoParams = { limit= 5,cd= 120 }, DropType = 2, FirstItems = {  }, Items = { [1]= 201,[10]= 202,[20]= 203,[30]= 204,[40]= 205 }, PreItemID = 0, ConditionType = 4, ConditionParam = "1,9", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 6, Params = "icon,icon_chest01_c;iconOpen,icon_chest01;bg,itemcard01;effect,chest1;desc,黄金宝箱描述", ShowPlace = 0, ShowParams = "category,chests;size,1", Unique = 6001, ShowWeight = 200 	}, __meta__),
		setmetatable({ ID = 6002, MallID = 0, _Title = "黄金宝箱", IsValid = 1, Price = "11,1;2,60", DiscountDuration = 0, VideoParams = {  }, DropType = 2, FirstItems = {  }, Items = { [1]= 201,[10]= 202,[20]= 203,[30]= 204,[40]= 205 }, PreItemID = 0, ConditionType = 4, ConditionParam = "1,9", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 6, Params = "icon,icon_chest01_c;iconOpen,icon_chest01;bg,itemcard01;effect,chest1;desc,黄金宝箱描述", ShowPlace = 0, ShowParams = "category,chests;size,1", Unique = 6002, ShowWeight = 201 	}, __meta__),
		setmetatable({ ID = 6003, MallID = 0, _Title = "装备宝箱", IsValid = 1, Price = "12,1;10000001,1;2,300,270", DiscountDuration = 1800, VideoParams = { cd= 259200 }, DropType = 2, FirstItems = { [1]= 102 }, Items = { [1]= 101 }, PreItemID = 0, ConditionType = 4, ConditionParam = "1,9", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 7, Params = "icon,icon_chest02_c;iconOpen,icon_chest02;bg,itemcard03;effect,chest2;desc,装备宝箱描述", ShowPlace = 0, ShowParams = "category,chests;size,2", Unique = 6003, ShowWeight = 202 	}, __meta__),
		setmetatable({ ID = 6101, MallID = 0, _Title = "商城部件宝箱", IsValid = 1, Price = "13,1;2,300,270", DiscountDuration = 1800, VideoParams = {  }, DropType = 3, FirstItems = {  }, Items = { [1100]= 400,[1103]= 10,[1203]= 6,[1303]= 3,[1403]= 1 }, PreItemID = 0, ConditionType = 4, ConditionParam = "3,0", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 8, Params = "icon,chest_4;iconOpen,chest_4open;bg,itemcard03;effect,chest2;desc,部件宝箱4描述", ShowPlace = 0, ShowParams = "category,chests;size,2", Unique = 3101, ShowWeight = 211 	}, __meta__),
		setmetatable({ ID = 6102, MallID = 0, _Title = "商城部件宝箱", IsValid = 1, Price = "13,1;2,300,270", DiscountDuration = 1800, VideoParams = {  }, DropType = 3, FirstItems = {  }, Items = { [1100]= 400,[1104]= 10,[1204]= 6,[1304]= 3,[1404]= 1 }, PreItemID = 0, ConditionType = 4, ConditionParam = "4,0", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 8, Params = "icon,chest_4;iconOpen,chest_4open;bg,itemcard03;effect,chest2;desc,部件宝箱4描述", ShowPlace = 0, ShowParams = "category,chests;size,2", Unique = 3101, ShowWeight = 212 	}, __meta__),
		setmetatable({ ID = 6103, MallID = 0, _Title = "商城部件宝箱", IsValid = 1, Price = "13,1;2,300,270", DiscountDuration = 1800, VideoParams = {  }, DropType = 3, FirstItems = {  }, Items = { [1100]= 400,[1105]= 10,[1205]= 6,[1305]= 3,[1405]= 1 }, PreItemID = 0, ConditionType = 4, ConditionParam = "5,0", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 8, Params = "icon,chest_4;iconOpen,chest_4open;bg,itemcard03;effect,chest2;desc,部件宝箱4描述", ShowPlace = 0, ShowParams = "category,chests;size,2", Unique = 3101, ShowWeight = 213 	}, __meta__),
		setmetatable({ ID = 6104, MallID = 0, _Title = "商城部件宝箱", IsValid = 1, Price = "13,1;2,300,270", DiscountDuration = 1800, VideoParams = {  }, DropType = 3, FirstItems = {  }, Items = { [1100]= 400,[1106]= 10,[1206]= 6,[1306]= 3,[1406]= 1 }, PreItemID = 0, ConditionType = 4, ConditionParam = "6,0", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 8, Params = "icon,chest_4;iconOpen,chest_4open;bg,itemcard03;effect,chest2;desc,部件宝箱4描述", ShowPlace = 0, ShowParams = "category,chests;size,2", Unique = 3101, ShowWeight = 214 	}, __meta__),
		setmetatable({ ID = 6105, MallID = 0, _Title = "商城部件宝箱", IsValid = 1, Price = "13,1;2,300,270", DiscountDuration = 1800, VideoParams = {  }, DropType = 3, FirstItems = {  }, Items = { [1100]= 400,[1107]= 10,[1207]= 6,[1307]= 3,[1407]= 1 }, PreItemID = 0, ConditionType = 4, ConditionParam = "7,0", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 8, Params = "icon,chest_4;iconOpen,chest_4open;bg,itemcard03;effect,chest2;desc,部件宝箱4描述", ShowPlace = 0, ShowParams = "category,chests;size,2", Unique = 3101, ShowWeight = 215 	}, __meta__),
		setmetatable({ ID = 6106, MallID = 0, _Title = "商城部件宝箱", IsValid = 1, Price = "13,1;2,300,270", DiscountDuration = 1800, VideoParams = {  }, DropType = 3, FirstItems = {  }, Items = { [1100]= 400,[1108]= 10,[1208]= 6,[1308]= 3,[1408]= 1 }, PreItemID = 0, ConditionType = 4, ConditionParam = "8,0", LimitCycle = 0, LimitTimes = 0, Duration = 0, ItemType = 8, Params = "icon,chest_4;iconOpen,chest_4open;bg,itemcard03;effect,chest2;desc,部件宝箱4描述", ShowPlace = 0, ShowParams = "category,chests;size,2", Unique = 3101, ShowWeight = 216 	}, __meta__)
	}

}


-- ID
tab.StoreByID = {}
for _, rec in pairs(tab.Store) do
	tab.StoreByID[rec.ID] = rec
end

tab.Enum = {
	DropType = {
		Items = 0,
		Coins = 1,
		DropOneByLevel = 2,
		DropGroupMany = 3,
	},
	ConditionType = {
		None = 0,
		UnlockMall = 1,
		NoHero = 2,
		HasHero = 3,
		UnlockLevel = 4,
	},
	ItemType = {
		Gem = 0,
		Coin = 1,
		Hero = 2,
		NovicePack = 3,
		HeroPack = 4,
		PiggyBank = 5,
		GoldenChest = 6,
		DiamondChest = 7,
		CrownChest = 8,
	},
	ShowPlace = {
		Mall = 0,
		Hero = 1,
		HomePacks = 2,
		HomeFloat = 3,
		DailyShop = 4,
	},
}

local function table_join(t, delimeter, formatter)
    local res = ""
    for i = 1, #t do
        if formatter then
            res = res .. formatter(t[i])
        else
            res = res .. tostring(t[i])
        end
        if i < #t then
            res = res .. delimeter
        end
    end
    return res
end

local function string_start_with(str1, str2)
    return string.sub(str1, 1, #str2) == str2
    -- body
end

local function table_isEmpty(t)
    return next(t) == nil
end

local function table_count(t)
    local count = 0
    for _, _ in pairs(t) do
        count = count + 1
    end
    return count
end

local classes = {}

local rootClass = {
    name = NAME .. "Config",
    fields = {}
}

-- number, string
-- { a = "string", b = "number", c = { d = "boolean" }}
local function merge(a, b)
    local ta = type(a)
    local tb = type(b)
    if ta == tb then
        if ta == "table" then
            local new = {}
            for key, value in pairs(a) do
                new[key] = value
            end
            for key, value in pairs(b) do
                if new[key] ~= nil then
                    local res = merge(new[key], value)
                    if not res then
                        return false
                    end
                    new[key] = res
                else
                    new[key] = value
                end
            end
            return new
        else
            return a
        end
    else
        return false
    end
end

local function parseType(data)
    local dt = type(data)
    if dt == "table" then
        if table_isEmpty(data) then
            return {}
        else
            local sb = {}
            local kType = nil
            local vType = nil
            for key, value in pairs(data) do
                local ckType = parseType(key)
                if kType ~= false then
                    if kType == nil then
                        kType = ckType
                    end
                    kType = merge(kType, ckType)
                end
                local cvType = parseType(value)
                if vType ~= false then
                    if vType == nil then
                        vType = cvType
                    end
                    vType = merge(vType, cvType)
                end
                sb[key] = cvType
            end
            if kType == "number" and vType then
                sb = {
                    ["*"] = vType
                }
            end
            return sb
        end
    else
        return dt
    end
end

local function escapeKey(name)
    if string_start_with(name, "_") then
        return string.sub(name, 2)
    end
    return name
end

local function stringifyType(typeTab)
    if type(typeTab) == "table" then
        if table_count(typeTab) == 1 and next(typeTab) == "*" then
            local k, v = next(typeTab)
            return "table<number, "..stringifyType(v)..">"
        end
        local kvs = {}
        for k, v in pairs(typeTab) do
            table.insert(kvs, escapeKey( k)..": "..stringifyType(v))
        end
        return "{ "..table_join(kvs,", ").." }"
    else
        return typeTab
    end
end

local function stringifyClass(cls)
    local sb = "---@class "..cls.name.."\n"
    local vs = {}
    for key, value in pairs(cls.fields) do
        table.insert(vs, "---@field "..value.name.." "..value.type)
    end
    table.sort(vs)
    return sb..table_join(vs,"\n").."\n"
end

table.insert(classes, rootClass)

local elemName = NAME .. "ConfigItem"
local export = ""

for key, value in pairs(tab) do
    local secondaryClass = nil
    if key == NAME then
        local typeName = elemName
        secondaryClass = {
            name = typeName,
            fields = {}
        }
        table.insert(rootClass.fields, {
            name = key,
            type = "table<number, " ..typeName .. ">",
        })

        local vt = parseType(value)
        if type(vt) == "table" then
            if table_count(vt) == 1 and next(vt) == "*" then
                local k, v = next(vt)
                export = export.."---@class "..elemName.."\n"
                local vs = {}
                for vk, vv in pairs(v) do
                    table.insert(vs,"---@field "..escapeKey( vk).." "..stringifyType(vv))
                end
                table.sort(vs)
                export = export..table_join(vs,"\n").."\n"
            else
                export = export.."---@alias " ..elemName .." " .. stringifyType(vt)
            end
        else
            export = export.."---@alias " ..elemName .." " .. stringifyType(vt)
        end

    elseif string_start_with(key, NAME.."By") then
        local typeName = elemName
        secondaryClass = {
            name = NAME .. key,
            fields = {}
        }
        local k, v = next(value)
        table.insert(rootClass.fields, {
            name = key,
            type = "table<" .. type(k)..", "..typeName..">",
        })
    end
end

-- print("---@alias " .. NAME .. "ConfigItem " .. parseType(t[NAME]))

for key, value in pairs(classes) do
    export = export .. "\n".. stringifyClass(value)
end

return export
