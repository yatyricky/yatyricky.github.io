require("gist/Lua/lib/global")
require("gist/Lua/lib/table_ext")

local t_nil = nil
local t_undef
local t_number = 12
local t_string = "str"
local t_bool = true
local t_func = function() end
local t_tab = {
    a = 1,
    b = 2,
    c = 3,
}
local t_arr = {
    "alice",
    "bob",
    "chris",
    [6] = "xc"
}

local config = {
    { ID = 1, Drop = { { ItemID = 1, Weight = 1, Amount = 1 } }, ProbBase = 1    },
    { ID = 2, Drop = { { ItemID = 2, Weight = 1, Amount = 1 } }, ProbBase = 1    },
    { ID = 5, Drop = { { ItemID = 1, Weight = 1, Amount = 5 } }, ProbBase = 1    },
    { ID = 10, Drop = { { ItemID = 1, Weight = 1, Amount = 10 } }, ProbBase = 1    },
    { ID = 11, Drop = { { ItemID = 30001, Weight = 1, Amount = 1 } }, ProbBase = 5    },
    { ID = 12, Drop = { { ItemID = 30001, Weight = 1, Amount = 1 } }, ProbBase = 1    },
    { ID = 13, Drop = { { ItemID = 30001, Weight = 1, Amount = 1 } }, ProbBase = 20    },
    { ID = 21, Drop = { { ItemID = 100001, Weight = 1, Amount = 1 }, { ItemID = 100002, Weight = 1, Amount = 1 }, { ItemID = 100003, Weight = 1, Amount = 1 }, { ItemID = 100004, Weight = 1, Amount = 1 }, { ItemID = 100005, Weight = 1, Amount = 1 }, { ItemID = 100006, Weight = 1, Amount = 1 } }, ProbBase = 120    },
    { ID = 22, Drop = { { ItemID = 100001, Weight = 1, Amount = 1 }, { ItemID = 100002, Weight = 1, Amount = 1 }, { ItemID = 100003, Weight = 1, Amount = 1 }, { ItemID = 100004, Weight = 1, Amount = 1 }, { ItemID = 100005, Weight = 1, Amount = 1 }, { ItemID = 100006, Weight = 1, Amount = 1 } }, ProbBase = 6    },
    { ID = 31, Drop = { { ItemID = 21110, Weight = 1, Amount = 1 }, { ItemID = 21120, Weight = 1, Amount = 1 }, { ItemID = 21130, Weight = 1, Amount = 1 }, { ItemID = 21140, Weight = 1, Amount = 1 }, { ItemID = 21210, Weight = 1, Amount = 1 }, { ItemID = 21220, Weight = 1, Amount = 1 }, { ItemID = 21230, Weight = 1, Amount = 1 }, { ItemID = 21240, Weight = 1, Amount = 1 }, { ItemID = 21310, Weight = 1, Amount = 1 }, { ItemID = 21320, Weight = 1, Amount = 1 }, { ItemID = 21330, Weight = 1, Amount = 1 }, { ItemID = 21340, Weight = 1, Amount = 1 }, { ItemID = 21410, Weight = 1, Amount = 1 }, { ItemID = 21420, Weight = 1, Amount = 1 }, { ItemID = 21430, Weight = 1, Amount = 1 }, { ItemID = 21440, Weight = 1, Amount = 1 }, { ItemID = 21510, Weight = 1, Amount = 1 }, { ItemID = 21520, Weight = 1, Amount = 1 }, { ItemID = 21530, Weight = 1, Amount = 1 }, { ItemID = 21540, Weight = 1, Amount = 1 }, { ItemID = 21610, Weight = 1, Amount = 1 }, { ItemID = 21620, Weight = 1, Amount = 1 }, { ItemID = 21630, Weight = 1, Amount = 1 }, { ItemID = 21640, Weight = 1, Amount = 1 } }, ProbBase = 2400    },
    { ID = 32, Drop = { { ItemID = 21110, Weight = 1, Amount = 1 }, { ItemID = 21120, Weight = 1, Amount = 1 }, { ItemID = 21130, Weight = 1, Amount = 1 }, { ItemID = 21140, Weight = 1, Amount = 1 }, { ItemID = 21210, Weight = 1, Amount = 1 }, { ItemID = 21220, Weight = 1, Amount = 1 }, { ItemID = 21230, Weight = 1, Amount = 1 }, { ItemID = 21240, Weight = 1, Amount = 1 }, { ItemID = 21310, Weight = 1, Amount = 1 }, { ItemID = 21320, Weight = 1, Amount = 1 }, { ItemID = 21330, Weight = 1, Amount = 1 }, { ItemID = 21340, Weight = 1, Amount = 1 }, { ItemID = 21410, Weight = 1, Amount = 1 }, { ItemID = 21420, Weight = 1, Amount = 1 }, { ItemID = 21430, Weight = 1, Amount = 1 }, { ItemID = 21440, Weight = 1, Amount = 1 }, { ItemID = 21510, Weight = 1, Amount = 1 }, { ItemID = 21520, Weight = 1, Amount = 1 }, { ItemID = 21530, Weight = 1, Amount = 1 }, { ItemID = 21540, Weight = 1, Amount = 1 }, { ItemID = 21610, Weight = 1, Amount = 1 }, { ItemID = 21620, Weight = 1, Amount = 1 }, { ItemID = 21630, Weight = 1, Amount = 1 }, { ItemID = 21640, Weight = 1, Amount = 1 } }, ProbBase = 240    },
    { ID = 41, Drop = { { ItemID = 1001, Weight = 25, Amount = 1 }, { ItemID = 1002, Weight = 25, Amount = 1 }, { ItemID = 1003, Weight = 25, Amount = 1 }, { ItemID = 1004, Weight = 25, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10000    },
    { ID = 42, Drop = { { ItemID = 1001, Weight = 25, Amount = 1 }, { ItemID = 1002, Weight = 25, Amount = 1 }, { ItemID = 1003, Weight = 25, Amount = 1 }, { ItemID = 1004, Weight = 25, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 1000    },
    { ID = 101, Drop = { { ItemID = 21111, Weight = 125, Amount = 1 }, { ItemID = 21121, Weight = 125, Amount = 1 }, { ItemID = 21131, Weight = 125, Amount = 1 }, { ItemID = 21141, Weight = 125, Amount = 1 }, { ItemID = 21211, Weight = 125, Amount = 1 }, { ItemID = 21221, Weight = 125, Amount = 1 }, { ItemID = 21231, Weight = 125, Amount = 1 }, { ItemID = 21241, Weight = 125, Amount = 1 }, { ItemID = 21311, Weight = 125, Amount = 1 }, { ItemID = 21321, Weight = 125, Amount = 1 }, { ItemID = 21331, Weight = 125, Amount = 1 }, { ItemID = 21341, Weight = 125, Amount = 1 }, { ItemID = 21411, Weight = 125, Amount = 1 }, { ItemID = 21421, Weight = 125, Amount = 1 }, { ItemID = 21431, Weight = 125, Amount = 1 }, { ItemID = 21441, Weight = 125, Amount = 1 }, { ItemID = 21511, Weight = 125, Amount = 1 }, { ItemID = 21521, Weight = 125, Amount = 1 }, { ItemID = 21531, Weight = 125, Amount = 1 }, { ItemID = 21541, Weight = 125, Amount = 1 }, { ItemID = 21611, Weight = 125, Amount = 1 }, { ItemID = 21621, Weight = 125, Amount = 1 }, { ItemID = 21631, Weight = 125, Amount = 1 }, { ItemID = 21641, Weight = 125, Amount = 1 }, { ItemID = 21112, Weight = 208, Amount = 1 }, { ItemID = 21122, Weight = 208, Amount = 1 }, { ItemID = 21132, Weight = 208, Amount = 1 }, { ItemID = 21142, Weight = 208, Amount = 1 }, { ItemID = 21212, Weight = 208, Amount = 1 }, { ItemID = 21222, Weight = 208, Amount = 1 }, { ItemID = 21232, Weight = 208, Amount = 1 }, { ItemID = 21242, Weight = 208, Amount = 1 }, { ItemID = 21312, Weight = 208, Amount = 1 }, { ItemID = 21322, Weight = 208, Amount = 1 }, { ItemID = 21332, Weight = 208, Amount = 1 }, { ItemID = 21342, Weight = 208, Amount = 1 }, { ItemID = 21412, Weight = 208, Amount = 1 }, { ItemID = 21422, Weight = 208, Amount = 1 }, { ItemID = 21432, Weight = 208, Amount = 1 }, { ItemID = 21442, Weight = 208, Amount = 1 }, { ItemID = 21512, Weight = 208, Amount = 1 }, { ItemID = 21522, Weight = 208, Amount = 1 }, { ItemID = 21532, Weight = 208, Amount = 1 }, { ItemID = 21542, Weight = 208, Amount = 1 }, { ItemID = 21612, Weight = 208, Amount = 1 }, { ItemID = 21622, Weight = 208, Amount = 1 }, { ItemID = 21632, Weight = 208, Amount = 1 }, { ItemID = 21642, Weight = 208, Amount = 1 }, { ItemID = 21113, Weight = 75, Amount = 1 }, { ItemID = 21123, Weight = 75, Amount = 1 }, { ItemID = 21133, Weight = 75, Amount = 1 }, { ItemID = 21143, Weight = 75, Amount = 1 }, { ItemID = 21213, Weight = 75, Amount = 1 }, { ItemID = 21223, Weight = 75, Amount = 1 }, { ItemID = 21233, Weight = 75, Amount = 1 }, { ItemID = 21243, Weight = 75, Amount = 1 }, { ItemID = 21313, Weight = 75, Amount = 1 }, { ItemID = 21323, Weight = 75, Amount = 1 }, { ItemID = 21333, Weight = 75, Amount = 1 }, { ItemID = 21343, Weight = 75, Amount = 1 }, { ItemID = 21413, Weight = 75, Amount = 1 }, { ItemID = 21423, Weight = 75, Amount = 1 }, { ItemID = 21433, Weight = 75, Amount = 1 }, { ItemID = 21443, Weight = 75, Amount = 1 }, { ItemID = 21513, Weight = 75, Amount = 1 }, { ItemID = 21523, Weight = 75, Amount = 1 }, { ItemID = 21533, Weight = 75, Amount = 1 }, { ItemID = 21543, Weight = 75, Amount = 1 }, { ItemID = 21613, Weight = 75, Amount = 1 }, { ItemID = 21623, Weight = 75, Amount = 1 }, { ItemID = 21633, Weight = 75, Amount = 1 }, { ItemID = 21643, Weight = 75, Amount = 1 }, { ItemID = 21114, Weight = 8, Amount = 1 }, { ItemID = 21124, Weight = 8, Amount = 1 }, { ItemID = 21134, Weight = 8, Amount = 1 }, { ItemID = 21144, Weight = 8, Amount = 1 }, { ItemID = 21214, Weight = 8, Amount = 1 }, { ItemID = 21224, Weight = 8, Amount = 1 }, { ItemID = 21234, Weight = 8, Amount = 1 }, { ItemID = 21244, Weight = 8, Amount = 1 }, { ItemID = 21314, Weight = 8, Amount = 1 }, { ItemID = 21324, Weight = 8, Amount = 1 }, { ItemID = 21334, Weight = 8, Amount = 1 }, { ItemID = 21344, Weight = 8, Amount = 1 }, { ItemID = 21414, Weight = 8, Amount = 1 }, { ItemID = 21424, Weight = 8, Amount = 1 }, { ItemID = 21434, Weight = 8, Amount = 1 }, { ItemID = 21444, Weight = 8, Amount = 1 }, { ItemID = 21514, Weight = 8, Amount = 1 }, { ItemID = 21524, Weight = 8, Amount = 1 }, { ItemID = 21534, Weight = 8, Amount = 1 }, { ItemID = 21544, Weight = 8, Amount = 1 }, { ItemID = 21614, Weight = 8, Amount = 1 }, { ItemID = 21624, Weight = 8, Amount = 1 }, { ItemID = 21634, Weight = 8, Amount = 1 }, { ItemID = 21644, Weight = 8, Amount = 1 }, { ItemID = 21115, Weight = 0, Amount = 1 }, { ItemID = 21125, Weight = 0, Amount = 1 }, { ItemID = 21135, Weight = 0, Amount = 1 }, { ItemID = 21145, Weight = 0, Amount = 1 }, { ItemID = 21215, Weight = 0, Amount = 1 }, { ItemID = 21225, Weight = 0, Amount = 1 }, { ItemID = 21235, Weight = 0, Amount = 1 }, { ItemID = 21245, Weight = 0, Amount = 1 }, { ItemID = 21315, Weight = 0, Amount = 1 }, { ItemID = 21325, Weight = 0, Amount = 1 }, { ItemID = 21335, Weight = 0, Amount = 1 }, { ItemID = 21345, Weight = 0, Amount = 1 }, { ItemID = 21415, Weight = 0, Amount = 1 }, { ItemID = 21425, Weight = 0, Amount = 1 }, { ItemID = 21435, Weight = 0, Amount = 1 }, { ItemID = 21445, Weight = 0, Amount = 1 }, { ItemID = 21515, Weight = 0, Amount = 1 }, { ItemID = 21525, Weight = 0, Amount = 1 }, { ItemID = 21535, Weight = 0, Amount = 1 }, { ItemID = 21545, Weight = 0, Amount = 1 }, { ItemID = 21615, Weight = 0, Amount = 1 }, { ItemID = 21625, Weight = 0, Amount = 1 }, { ItemID = 21635, Weight = 0, Amount = 1 }, { ItemID = 21645, Weight = 0, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 9984    },
    { ID = 102, Drop = { { ItemID = 21113, Weight = 417, Amount = 1 }, { ItemID = 21123, Weight = 417, Amount = 1 }, { ItemID = 21133, Weight = 417, Amount = 1 }, { ItemID = 21143, Weight = 417, Amount = 1 }, { ItemID = 21213, Weight = 417, Amount = 1 }, { ItemID = 21223, Weight = 417, Amount = 1 }, { ItemID = 21233, Weight = 417, Amount = 1 }, { ItemID = 21243, Weight = 417, Amount = 1 }, { ItemID = 21313, Weight = 417, Amount = 1 }, { ItemID = 21323, Weight = 417, Amount = 1 }, { ItemID = 21333, Weight = 417, Amount = 1 }, { ItemID = 21343, Weight = 417, Amount = 1 }, { ItemID = 21413, Weight = 417, Amount = 1 }, { ItemID = 21423, Weight = 417, Amount = 1 }, { ItemID = 21433, Weight = 417, Amount = 1 }, { ItemID = 21443, Weight = 417, Amount = 1 }, { ItemID = 21513, Weight = 417, Amount = 1 }, { ItemID = 21523, Weight = 417, Amount = 1 }, { ItemID = 21533, Weight = 417, Amount = 1 }, { ItemID = 21543, Weight = 417, Amount = 1 }, { ItemID = 21613, Weight = 417, Amount = 1 }, { ItemID = 21623, Weight = 417, Amount = 1 }, { ItemID = 21633, Weight = 417, Amount = 1 }, { ItemID = 21643, Weight = 417, Amount = 1 }, { ItemID = 21114, Weight = 0, Amount = 1 }, { ItemID = 21124, Weight = 0, Amount = 1 }, { ItemID = 21134, Weight = 0, Amount = 1 }, { ItemID = 21144, Weight = 0, Amount = 1 }, { ItemID = 21214, Weight = 0, Amount = 1 }, { ItemID = 21224, Weight = 0, Amount = 1 }, { ItemID = 21234, Weight = 0, Amount = 1 }, { ItemID = 21244, Weight = 0, Amount = 1 }, { ItemID = 21314, Weight = 0, Amount = 1 }, { ItemID = 21324, Weight = 0, Amount = 1 }, { ItemID = 21334, Weight = 0, Amount = 1 }, { ItemID = 21344, Weight = 0, Amount = 1 }, { ItemID = 21414, Weight = 0, Amount = 1 }, { ItemID = 21424, Weight = 0, Amount = 1 }, { ItemID = 21434, Weight = 0, Amount = 1 }, { ItemID = 21444, Weight = 0, Amount = 1 }, { ItemID = 21514, Weight = 0, Amount = 1 }, { ItemID = 21524, Weight = 0, Amount = 1 }, { ItemID = 21534, Weight = 0, Amount = 1 }, { ItemID = 21544, Weight = 0, Amount = 1 }, { ItemID = 21614, Weight = 0, Amount = 1 }, { ItemID = 21624, Weight = 0, Amount = 1 }, { ItemID = 21634, Weight = 0, Amount = 1 }, { ItemID = 21644, Weight = 0, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10008    },
    { ID = 201, Drop = { { ItemID = 21110, Weight = 125, Amount = 1 }, { ItemID = 21120, Weight = 125, Amount = 1 }, { ItemID = 21130, Weight = 125, Amount = 1 }, { ItemID = 21140, Weight = 125, Amount = 1 }, { ItemID = 21210, Weight = 125, Amount = 1 }, { ItemID = 21220, Weight = 125, Amount = 1 }, { ItemID = 21230, Weight = 125, Amount = 1 }, { ItemID = 21240, Weight = 125, Amount = 1 }, { ItemID = 21310, Weight = 125, Amount = 1 }, { ItemID = 21320, Weight = 125, Amount = 1 }, { ItemID = 21330, Weight = 125, Amount = 1 }, { ItemID = 21340, Weight = 125, Amount = 1 }, { ItemID = 21410, Weight = 125, Amount = 1 }, { ItemID = 21420, Weight = 125, Amount = 1 }, { ItemID = 21430, Weight = 125, Amount = 1 }, { ItemID = 21440, Weight = 125, Amount = 1 }, { ItemID = 21510, Weight = 125, Amount = 1 }, { ItemID = 21520, Weight = 125, Amount = 1 }, { ItemID = 21530, Weight = 125, Amount = 1 }, { ItemID = 21540, Weight = 125, Amount = 1 }, { ItemID = 21610, Weight = 125, Amount = 1 }, { ItemID = 21620, Weight = 125, Amount = 1 }, { ItemID = 21630, Weight = 125, Amount = 1 }, { ItemID = 21640, Weight = 125, Amount = 1 }, { ItemID = 21121, Weight = 42, Amount = 1 }, { ItemID = 21131, Weight = 42, Amount = 1 }, { ItemID = 21141, Weight = 42, Amount = 1 }, { ItemID = 21211, Weight = 42, Amount = 1 }, { ItemID = 21221, Weight = 42, Amount = 1 }, { ItemID = 21231, Weight = 42, Amount = 1 }, { ItemID = 21241, Weight = 42, Amount = 1 }, { ItemID = 21311, Weight = 42, Amount = 1 }, { ItemID = 21321, Weight = 42, Amount = 1 }, { ItemID = 21331, Weight = 42, Amount = 1 }, { ItemID = 21341, Weight = 42, Amount = 1 }, { ItemID = 21411, Weight = 42, Amount = 1 }, { ItemID = 21421, Weight = 42, Amount = 1 }, { ItemID = 21431, Weight = 42, Amount = 1 }, { ItemID = 21441, Weight = 42, Amount = 1 }, { ItemID = 21511, Weight = 42, Amount = 1 }, { ItemID = 21521, Weight = 42, Amount = 1 }, { ItemID = 21531, Weight = 42, Amount = 1 }, { ItemID = 21541, Weight = 42, Amount = 1 }, { ItemID = 21611, Weight = 42, Amount = 1 }, { ItemID = 21621, Weight = 42, Amount = 1 }, { ItemID = 21631, Weight = 42, Amount = 1 }, { ItemID = 21641, Weight = 42, Amount = 1 }, { ItemID = 21112, Weight = 42, Amount = 1 }, { ItemID = 1, Weight = 333, Amount = 1000 }, { ItemID = 1, Weight = 333, Amount = 1500 }, { ItemID = 1, Weight = 333, Amount = 2000 }, { ItemID = 100001, Weight = 167, Amount = 3 }, { ItemID = 100002, Weight = 167, Amount = 3 }, { ItemID = 100003, Weight = 167, Amount = 3 }, { ItemID = 100004, Weight = 167, Amount = 3 }, { ItemID = 100005, Weight = 167, Amount = 3 }, { ItemID = 100006, Weight = 167, Amount = 3 }, { ItemID = 100001, Weight = 167, Amount = 4 }, { ItemID = 100002, Weight = 167, Amount = 4 }, { ItemID = 100003, Weight = 167, Amount = 4 }, { ItemID = 100004, Weight = 167, Amount = 4 }, { ItemID = 100005, Weight = 167, Amount = 4 }, { ItemID = 100006, Weight = 167, Amount = 4 }, { ItemID = 100001, Weight = 167, Amount = 5 }, { ItemID = 100002, Weight = 167, Amount = 5 }, { ItemID = 100003, Weight = 167, Amount = 5 }, { ItemID = 100004, Weight = 167, Amount = 5 }, { ItemID = 100005, Weight = 167, Amount = 5 }, { ItemID = 100006, Weight = 167, Amount = 5 }, { ItemID = 1001, Weight = 167, Amount = 1 }, { ItemID = 1001, Weight = 167, Amount = 2 }, { ItemID = 1001, Weight = 167, Amount = 3 }, { ItemID = 1002, Weight = 167, Amount = 1 }, { ItemID = 1002, Weight = 167, Amount = 2 }, { ItemID = 1002, Weight = 167, Amount = 3 }, { ItemID = 1003, Weight = 167, Amount = 1 }, { ItemID = 1003, Weight = 167, Amount = 2 }, { ItemID = 1003, Weight = 167, Amount = 3 }, { ItemID = 1004, Weight = 167, Amount = 1 }, { ItemID = 1004, Weight = 167, Amount = 2 }, { ItemID = 1004, Weight = 167, Amount = 3 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10017    },
    { ID = 202, Drop = { { ItemID = 21110, Weight = 125, Amount = 1 }, { ItemID = 21120, Weight = 125, Amount = 1 }, { ItemID = 21130, Weight = 125, Amount = 1 }, { ItemID = 21140, Weight = 125, Amount = 1 }, { ItemID = 21210, Weight = 125, Amount = 1 }, { ItemID = 21220, Weight = 125, Amount = 1 }, { ItemID = 21230, Weight = 125, Amount = 1 }, { ItemID = 21240, Weight = 125, Amount = 1 }, { ItemID = 21310, Weight = 125, Amount = 1 }, { ItemID = 21320, Weight = 125, Amount = 1 }, { ItemID = 21330, Weight = 125, Amount = 1 }, { ItemID = 21340, Weight = 125, Amount = 1 }, { ItemID = 21410, Weight = 125, Amount = 1 }, { ItemID = 21420, Weight = 125, Amount = 1 }, { ItemID = 21430, Weight = 125, Amount = 1 }, { ItemID = 21440, Weight = 125, Amount = 1 }, { ItemID = 21510, Weight = 125, Amount = 1 }, { ItemID = 21520, Weight = 125, Amount = 1 }, { ItemID = 21530, Weight = 125, Amount = 1 }, { ItemID = 21540, Weight = 125, Amount = 1 }, { ItemID = 21610, Weight = 125, Amount = 1 }, { ItemID = 21620, Weight = 125, Amount = 1 }, { ItemID = 21630, Weight = 125, Amount = 1 }, { ItemID = 21640, Weight = 125, Amount = 1 }, { ItemID = 21121, Weight = 42, Amount = 1 }, { ItemID = 21131, Weight = 42, Amount = 1 }, { ItemID = 21141, Weight = 42, Amount = 1 }, { ItemID = 21211, Weight = 42, Amount = 1 }, { ItemID = 21221, Weight = 42, Amount = 1 }, { ItemID = 21231, Weight = 42, Amount = 1 }, { ItemID = 21241, Weight = 42, Amount = 1 }, { ItemID = 21311, Weight = 42, Amount = 1 }, { ItemID = 21321, Weight = 42, Amount = 1 }, { ItemID = 21331, Weight = 42, Amount = 1 }, { ItemID = 21341, Weight = 42, Amount = 1 }, { ItemID = 21411, Weight = 42, Amount = 1 }, { ItemID = 21421, Weight = 42, Amount = 1 }, { ItemID = 21431, Weight = 42, Amount = 1 }, { ItemID = 21441, Weight = 42, Amount = 1 }, { ItemID = 21511, Weight = 42, Amount = 1 }, { ItemID = 21521, Weight = 42, Amount = 1 }, { ItemID = 21531, Weight = 42, Amount = 1 }, { ItemID = 21541, Weight = 42, Amount = 1 }, { ItemID = 21611, Weight = 42, Amount = 1 }, { ItemID = 21621, Weight = 42, Amount = 1 }, { ItemID = 21631, Weight = 42, Amount = 1 }, { ItemID = 21641, Weight = 42, Amount = 1 }, { ItemID = 21112, Weight = 42, Amount = 1 }, { ItemID = 1, Weight = 333, Amount = 1500 }, { ItemID = 1, Weight = 333, Amount = 2000 }, { ItemID = 1, Weight = 333, Amount = 2500 }, { ItemID = 100001, Weight = 167, Amount = 4 }, { ItemID = 100002, Weight = 167, Amount = 4 }, { ItemID = 100003, Weight = 167, Amount = 4 }, { ItemID = 100004, Weight = 167, Amount = 4 }, { ItemID = 100005, Weight = 167, Amount = 4 }, { ItemID = 100006, Weight = 167, Amount = 4 }, { ItemID = 100001, Weight = 167, Amount = 5 }, { ItemID = 100002, Weight = 167, Amount = 5 }, { ItemID = 100003, Weight = 167, Amount = 5 }, { ItemID = 100004, Weight = 167, Amount = 5 }, { ItemID = 100005, Weight = 167, Amount = 5 }, { ItemID = 100006, Weight = 167, Amount = 5 }, { ItemID = 100001, Weight = 167, Amount = 6 }, { ItemID = 100002, Weight = 167, Amount = 6 }, { ItemID = 100003, Weight = 167, Amount = 6 }, { ItemID = 100004, Weight = 167, Amount = 6 }, { ItemID = 100005, Weight = 167, Amount = 6 }, { ItemID = 100006, Weight = 167, Amount = 6 }, { ItemID = 1001, Weight = 167, Amount = 1 }, { ItemID = 1001, Weight = 167, Amount = 2 }, { ItemID = 1001, Weight = 167, Amount = 3 }, { ItemID = 1002, Weight = 167, Amount = 1 }, { ItemID = 1002, Weight = 167, Amount = 2 }, { ItemID = 1002, Weight = 167, Amount = 3 }, { ItemID = 1003, Weight = 167, Amount = 1 }, { ItemID = 1003, Weight = 167, Amount = 2 }, { ItemID = 1003, Weight = 167, Amount = 3 }, { ItemID = 1004, Weight = 167, Amount = 1 }, { ItemID = 1004, Weight = 167, Amount = 2 }, { ItemID = 1004, Weight = 167, Amount = 3 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10017    },
    { ID = 203, Drop = { { ItemID = 21110, Weight = 125, Amount = 1 }, { ItemID = 21120, Weight = 125, Amount = 1 }, { ItemID = 21130, Weight = 125, Amount = 1 }, { ItemID = 21140, Weight = 125, Amount = 1 }, { ItemID = 21210, Weight = 125, Amount = 1 }, { ItemID = 21220, Weight = 125, Amount = 1 }, { ItemID = 21230, Weight = 125, Amount = 1 }, { ItemID = 21240, Weight = 125, Amount = 1 }, { ItemID = 21310, Weight = 125, Amount = 1 }, { ItemID = 21320, Weight = 125, Amount = 1 }, { ItemID = 21330, Weight = 125, Amount = 1 }, { ItemID = 21340, Weight = 125, Amount = 1 }, { ItemID = 21410, Weight = 125, Amount = 1 }, { ItemID = 21420, Weight = 125, Amount = 1 }, { ItemID = 21430, Weight = 125, Amount = 1 }, { ItemID = 21440, Weight = 125, Amount = 1 }, { ItemID = 21510, Weight = 125, Amount = 1 }, { ItemID = 21520, Weight = 125, Amount = 1 }, { ItemID = 21530, Weight = 125, Amount = 1 }, { ItemID = 21540, Weight = 125, Amount = 1 }, { ItemID = 21610, Weight = 125, Amount = 1 }, { ItemID = 21620, Weight = 125, Amount = 1 }, { ItemID = 21630, Weight = 125, Amount = 1 }, { ItemID = 21640, Weight = 125, Amount = 1 }, { ItemID = 21121, Weight = 42, Amount = 1 }, { ItemID = 21131, Weight = 42, Amount = 1 }, { ItemID = 21141, Weight = 42, Amount = 1 }, { ItemID = 21211, Weight = 42, Amount = 1 }, { ItemID = 21221, Weight = 42, Amount = 1 }, { ItemID = 21231, Weight = 42, Amount = 1 }, { ItemID = 21241, Weight = 42, Amount = 1 }, { ItemID = 21311, Weight = 42, Amount = 1 }, { ItemID = 21321, Weight = 42, Amount = 1 }, { ItemID = 21331, Weight = 42, Amount = 1 }, { ItemID = 21341, Weight = 42, Amount = 1 }, { ItemID = 21411, Weight = 42, Amount = 1 }, { ItemID = 21421, Weight = 42, Amount = 1 }, { ItemID = 21431, Weight = 42, Amount = 1 }, { ItemID = 21441, Weight = 42, Amount = 1 }, { ItemID = 21511, Weight = 42, Amount = 1 }, { ItemID = 21521, Weight = 42, Amount = 1 }, { ItemID = 21531, Weight = 42, Amount = 1 }, { ItemID = 21541, Weight = 42, Amount = 1 }, { ItemID = 21611, Weight = 42, Amount = 1 }, { ItemID = 21621, Weight = 42, Amount = 1 }, { ItemID = 21631, Weight = 42, Amount = 1 }, { ItemID = 21641, Weight = 42, Amount = 1 }, { ItemID = 21112, Weight = 42, Amount = 1 }, { ItemID = 1, Weight = 333, Amount = 2000 }, { ItemID = 1, Weight = 333, Amount = 2500 }, { ItemID = 1, Weight = 333, Amount = 3000 }, { ItemID = 100001, Weight = 167, Amount = 5 }, { ItemID = 100002, Weight = 167, Amount = 5 }, { ItemID = 100003, Weight = 167, Amount = 5 }, { ItemID = 100004, Weight = 167, Amount = 5 }, { ItemID = 100005, Weight = 167, Amount = 5 }, { ItemID = 100006, Weight = 167, Amount = 5 }, { ItemID = 100001, Weight = 167, Amount = 6 }, { ItemID = 100002, Weight = 167, Amount = 6 }, { ItemID = 100003, Weight = 167, Amount = 6 }, { ItemID = 100004, Weight = 167, Amount = 6 }, { ItemID = 100005, Weight = 167, Amount = 6 }, { ItemID = 100006, Weight = 167, Amount = 6 }, { ItemID = 100001, Weight = 167, Amount = 7 }, { ItemID = 100002, Weight = 167, Amount = 7 }, { ItemID = 100003, Weight = 167, Amount = 7 }, { ItemID = 100004, Weight = 167, Amount = 7 }, { ItemID = 100005, Weight = 167, Amount = 7 }, { ItemID = 100006, Weight = 167, Amount = 7 }, { ItemID = 1001, Weight = 167, Amount = 1 }, { ItemID = 1001, Weight = 167, Amount = 2 }, { ItemID = 1001, Weight = 167, Amount = 3 }, { ItemID = 1002, Weight = 167, Amount = 1 }, { ItemID = 1002, Weight = 167, Amount = 2 }, { ItemID = 1002, Weight = 167, Amount = 3 }, { ItemID = 1003, Weight = 167, Amount = 1 }, { ItemID = 1003, Weight = 167, Amount = 2 }, { ItemID = 1003, Weight = 167, Amount = 3 }, { ItemID = 1004, Weight = 167, Amount = 1 }, { ItemID = 1004, Weight = 167, Amount = 2 }, { ItemID = 1004, Weight = 167, Amount = 3 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10017    },
    { ID = 204, Drop = { { ItemID = 21110, Weight = 125, Amount = 1 }, { ItemID = 21120, Weight = 125, Amount = 1 }, { ItemID = 21130, Weight = 125, Amount = 1 }, { ItemID = 21140, Weight = 125, Amount = 1 }, { ItemID = 21210, Weight = 125, Amount = 1 }, { ItemID = 21220, Weight = 125, Amount = 1 }, { ItemID = 21230, Weight = 125, Amount = 1 }, { ItemID = 21240, Weight = 125, Amount = 1 }, { ItemID = 21310, Weight = 125, Amount = 1 }, { ItemID = 21320, Weight = 125, Amount = 1 }, { ItemID = 21330, Weight = 125, Amount = 1 }, { ItemID = 21340, Weight = 125, Amount = 1 }, { ItemID = 21410, Weight = 125, Amount = 1 }, { ItemID = 21420, Weight = 125, Amount = 1 }, { ItemID = 21430, Weight = 125, Amount = 1 }, { ItemID = 21440, Weight = 125, Amount = 1 }, { ItemID = 21510, Weight = 125, Amount = 1 }, { ItemID = 21520, Weight = 125, Amount = 1 }, { ItemID = 21530, Weight = 125, Amount = 1 }, { ItemID = 21540, Weight = 125, Amount = 1 }, { ItemID = 21610, Weight = 125, Amount = 1 }, { ItemID = 21620, Weight = 125, Amount = 1 }, { ItemID = 21630, Weight = 125, Amount = 1 }, { ItemID = 21640, Weight = 125, Amount = 1 }, { ItemID = 21121, Weight = 42, Amount = 1 }, { ItemID = 21131, Weight = 42, Amount = 1 }, { ItemID = 21141, Weight = 42, Amount = 1 }, { ItemID = 21211, Weight = 42, Amount = 1 }, { ItemID = 21221, Weight = 42, Amount = 1 }, { ItemID = 21231, Weight = 42, Amount = 1 }, { ItemID = 21241, Weight = 42, Amount = 1 }, { ItemID = 21311, Weight = 42, Amount = 1 }, { ItemID = 21321, Weight = 42, Amount = 1 }, { ItemID = 21331, Weight = 42, Amount = 1 }, { ItemID = 21341, Weight = 42, Amount = 1 }, { ItemID = 21411, Weight = 42, Amount = 1 }, { ItemID = 21421, Weight = 42, Amount = 1 }, { ItemID = 21431, Weight = 42, Amount = 1 }, { ItemID = 21441, Weight = 42, Amount = 1 }, { ItemID = 21511, Weight = 42, Amount = 1 }, { ItemID = 21521, Weight = 42, Amount = 1 }, { ItemID = 21531, Weight = 42, Amount = 1 }, { ItemID = 21541, Weight = 42, Amount = 1 }, { ItemID = 21611, Weight = 42, Amount = 1 }, { ItemID = 21621, Weight = 42, Amount = 1 }, { ItemID = 21631, Weight = 42, Amount = 1 }, { ItemID = 21641, Weight = 42, Amount = 1 }, { ItemID = 21112, Weight = 42, Amount = 1 }, { ItemID = 1, Weight = 333, Amount = 2500 }, { ItemID = 1, Weight = 333, Amount = 3000 }, { ItemID = 1, Weight = 333, Amount = 3500 }, { ItemID = 100001, Weight = 167, Amount = 6 }, { ItemID = 100002, Weight = 167, Amount = 6 }, { ItemID = 100003, Weight = 167, Amount = 6 }, { ItemID = 100004, Weight = 167, Amount = 6 }, { ItemID = 100005, Weight = 167, Amount = 6 }, { ItemID = 100006, Weight = 167, Amount = 6 }, { ItemID = 100001, Weight = 167, Amount = 7 }, { ItemID = 100002, Weight = 167, Amount = 7 }, { ItemID = 100003, Weight = 167, Amount = 7 }, { ItemID = 100004, Weight = 167, Amount = 7 }, { ItemID = 100005, Weight = 167, Amount = 7 }, { ItemID = 100006, Weight = 167, Amount = 7 }, { ItemID = 100001, Weight = 167, Amount = 8 }, { ItemID = 100002, Weight = 167, Amount = 8 }, { ItemID = 100003, Weight = 167, Amount = 8 }, { ItemID = 100004, Weight = 167, Amount = 8 }, { ItemID = 100005, Weight = 167, Amount = 8 }, { ItemID = 100006, Weight = 167, Amount = 8 }, { ItemID = 1001, Weight = 167, Amount = 1 }, { ItemID = 1001, Weight = 167, Amount = 2 }, { ItemID = 1001, Weight = 167, Amount = 3 }, { ItemID = 1002, Weight = 167, Amount = 1 }, { ItemID = 1002, Weight = 167, Amount = 2 }, { ItemID = 1002, Weight = 167, Amount = 3 }, { ItemID = 1003, Weight = 167, Amount = 1 }, { ItemID = 1003, Weight = 167, Amount = 2 }, { ItemID = 1003, Weight = 167, Amount = 3 }, { ItemID = 1004, Weight = 167, Amount = 1 }, { ItemID = 1004, Weight = 167, Amount = 2 }, { ItemID = 1004, Weight = 167, Amount = 3 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10017    },
    { ID = 205, Drop = { { ItemID = 21110, Weight = 125, Amount = 1 }, { ItemID = 21120, Weight = 125, Amount = 1 }, { ItemID = 21130, Weight = 125, Amount = 1 }, { ItemID = 21140, Weight = 125, Amount = 1 }, { ItemID = 21210, Weight = 125, Amount = 1 }, { ItemID = 21220, Weight = 125, Amount = 1 }, { ItemID = 21230, Weight = 125, Amount = 1 }, { ItemID = 21240, Weight = 125, Amount = 1 }, { ItemID = 21310, Weight = 125, Amount = 1 }, { ItemID = 21320, Weight = 125, Amount = 1 }, { ItemID = 21330, Weight = 125, Amount = 1 }, { ItemID = 21340, Weight = 125, Amount = 1 }, { ItemID = 21410, Weight = 125, Amount = 1 }, { ItemID = 21420, Weight = 125, Amount = 1 }, { ItemID = 21430, Weight = 125, Amount = 1 }, { ItemID = 21440, Weight = 125, Amount = 1 }, { ItemID = 21510, Weight = 125, Amount = 1 }, { ItemID = 21520, Weight = 125, Amount = 1 }, { ItemID = 21530, Weight = 125, Amount = 1 }, { ItemID = 21540, Weight = 125, Amount = 1 }, { ItemID = 21610, Weight = 125, Amount = 1 }, { ItemID = 21620, Weight = 125, Amount = 1 }, { ItemID = 21630, Weight = 125, Amount = 1 }, { ItemID = 21640, Weight = 125, Amount = 1 }, { ItemID = 21121, Weight = 42, Amount = 1 }, { ItemID = 21131, Weight = 42, Amount = 1 }, { ItemID = 21141, Weight = 42, Amount = 1 }, { ItemID = 21211, Weight = 42, Amount = 1 }, { ItemID = 21221, Weight = 42, Amount = 1 }, { ItemID = 21231, Weight = 42, Amount = 1 }, { ItemID = 21241, Weight = 42, Amount = 1 }, { ItemID = 21311, Weight = 42, Amount = 1 }, { ItemID = 21321, Weight = 42, Amount = 1 }, { ItemID = 21331, Weight = 42, Amount = 1 }, { ItemID = 21341, Weight = 42, Amount = 1 }, { ItemID = 21411, Weight = 42, Amount = 1 }, { ItemID = 21421, Weight = 42, Amount = 1 }, { ItemID = 21431, Weight = 42, Amount = 1 }, { ItemID = 21441, Weight = 42, Amount = 1 }, { ItemID = 21511, Weight = 42, Amount = 1 }, { ItemID = 21521, Weight = 42, Amount = 1 }, { ItemID = 21531, Weight = 42, Amount = 1 }, { ItemID = 21541, Weight = 42, Amount = 1 }, { ItemID = 21611, Weight = 42, Amount = 1 }, { ItemID = 21621, Weight = 42, Amount = 1 }, { ItemID = 21631, Weight = 42, Amount = 1 }, { ItemID = 21641, Weight = 42, Amount = 1 }, { ItemID = 21112, Weight = 42, Amount = 1 }, { ItemID = 1, Weight = 333, Amount = 3000 }, { ItemID = 1, Weight = 333, Amount = 3500 }, { ItemID = 1, Weight = 333, Amount = 4000 }, { ItemID = 100001, Weight = 167, Amount = 7 }, { ItemID = 100002, Weight = 167, Amount = 7 }, { ItemID = 100003, Weight = 167, Amount = 7 }, { ItemID = 100004, Weight = 167, Amount = 7 }, { ItemID = 100005, Weight = 167, Amount = 7 }, { ItemID = 100006, Weight = 167, Amount = 7 }, { ItemID = 100001, Weight = 167, Amount = 8 }, { ItemID = 100002, Weight = 167, Amount = 8 }, { ItemID = 100003, Weight = 167, Amount = 8 }, { ItemID = 100004, Weight = 167, Amount = 8 }, { ItemID = 100005, Weight = 167, Amount = 8 }, { ItemID = 100006, Weight = 167, Amount = 8 }, { ItemID = 100001, Weight = 167, Amount = 9 }, { ItemID = 100002, Weight = 167, Amount = 9 }, { ItemID = 100003, Weight = 167, Amount = 9 }, { ItemID = 100004, Weight = 167, Amount = 9 }, { ItemID = 100005, Weight = 167, Amount = 9 }, { ItemID = 100006, Weight = 167, Amount = 9 }, { ItemID = 1001, Weight = 167, Amount = 1 }, { ItemID = 1001, Weight = 167, Amount = 2 }, { ItemID = 1001, Weight = 167, Amount = 3 }, { ItemID = 1002, Weight = 167, Amount = 1 }, { ItemID = 1002, Weight = 167, Amount = 2 }, { ItemID = 1002, Weight = 167, Amount = 3 }, { ItemID = 1003, Weight = 167, Amount = 1 }, { ItemID = 1003, Weight = 167, Amount = 2 }, { ItemID = 1003, Weight = 167, Amount = 3 }, { ItemID = 1004, Weight = 167, Amount = 1 }, { ItemID = 1004, Weight = 167, Amount = 2 }, { ItemID = 1004, Weight = 167, Amount = 3 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10017    },
    { ID = 301, Drop = { { ItemID = 201, Weight = 1, Amount = 1 } }, ProbBase = 1    },
    { ID = 302, Drop = { { ItemID = 202, Weight = 1, Amount = 1 } }, ProbBase = 1    },
    { ID = 303, Drop = { { ItemID = 201, Weight = 1, Amount = 1 } }, ProbBase = 100    },
    { ID = 1100, Drop = { { ItemID = 1, Weight = 1, Amount = 20 } }, ProbBase = 2    },
    { ID = 1103, Drop = { { ItemID = 120031, Weight = 5882, Amount = 1 }, { ItemID = 120032, Weight = 2941, Amount = 1 }, { ItemID = 120033, Weight = 1176, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 9999    },
    { ID = 1203, Drop = { { ItemID = 120031, Weight = 5609, Amount = 1 }, { ItemID = 120032, Weight = 2805, Amount = 1 }, { ItemID = 120033, Weight = 1586, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10000    },
    { ID = 1303, Drop = { { ItemID = 120031, Weight = 5136, Amount = 1 }, { ItemID = 120032, Weight = 2568, Amount = 1 }, { ItemID = 120033, Weight = 2297, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10001    },
    { ID = 1403, Drop = { { ItemID = 120031, Weight = 4689, Amount = 1 }, { ItemID = 120032, Weight = 2345, Amount = 1 }, { ItemID = 120033, Weight = 2966, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10000    },
    { ID = 1104, Drop = { { ItemID = 120031, Weight = 5882, Amount = 1 }, { ItemID = 120032, Weight = 2941, Amount = 1 }, { ItemID = 120033, Weight = 1176, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 9999    },
    { ID = 1204, Drop = { { ItemID = 120031, Weight = 5609, Amount = 1 }, { ItemID = 120032, Weight = 2805, Amount = 1 }, { ItemID = 120033, Weight = 1586, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10000    },
    { ID = 1304, Drop = { { ItemID = 120031, Weight = 5136, Amount = 1 }, { ItemID = 120032, Weight = 2568, Amount = 1 }, { ItemID = 120033, Weight = 2297, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10001    },
    { ID = 1404, Drop = { { ItemID = 120031, Weight = 4689, Amount = 1 }, { ItemID = 120032, Weight = 2345, Amount = 1 }, { ItemID = 120033, Weight = 2966, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10000    },
    { ID = 1105, Drop = { { ItemID = 120031, Weight = 5882, Amount = 1 }, { ItemID = 120032, Weight = 2941, Amount = 1 }, { ItemID = 120033, Weight = 1176, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 9999    },
    { ID = 1205, Drop = { { ItemID = 120031, Weight = 5609, Amount = 1 }, { ItemID = 120032, Weight = 2805, Amount = 1 }, { ItemID = 120033, Weight = 1586, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10000    },
    { ID = 1305, Drop = { { ItemID = 120031, Weight = 5136, Amount = 1 }, { ItemID = 120032, Weight = 2568, Amount = 1 }, { ItemID = 120033, Weight = 2297, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10001    },
    { ID = 1405, Drop = { { ItemID = 120031, Weight = 4689, Amount = 1 }, { ItemID = 120032, Weight = 2345, Amount = 1 }, { ItemID = 120033, Weight = 2966, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10000    },
    { ID = 1106, Drop = { { ItemID = 120031, Weight = 5882, Amount = 1 }, { ItemID = 120032, Weight = 2941, Amount = 1 }, { ItemID = 120033, Weight = 1176, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 9999    },
    { ID = 1206, Drop = { { ItemID = 120031, Weight = 5609, Amount = 1 }, { ItemID = 120032, Weight = 2805, Amount = 1 }, { ItemID = 120033, Weight = 1586, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10000    },
    { ID = 1306, Drop = { { ItemID = 120031, Weight = 5136, Amount = 1 }, { ItemID = 120032, Weight = 2568, Amount = 1 }, { ItemID = 120033, Weight = 2297, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10001    },
    { ID = 1406, Drop = { { ItemID = 120031, Weight = 4689, Amount = 1 }, { ItemID = 120032, Weight = 2345, Amount = 1 }, { ItemID = 120033, Weight = 2966, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10000    },
    { ID = 1107, Drop = { { ItemID = 120031, Weight = 5882, Amount = 1 }, { ItemID = 120032, Weight = 2941, Amount = 1 }, { ItemID = 120033, Weight = 1176, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 9999    },
    { ID = 1207, Drop = { { ItemID = 120031, Weight = 5609, Amount = 1 }, { ItemID = 120032, Weight = 2805, Amount = 1 }, { ItemID = 120033, Weight = 1586, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10000    },
    { ID = 1307, Drop = { { ItemID = 120031, Weight = 5136, Amount = 1 }, { ItemID = 120032, Weight = 2568, Amount = 1 }, { ItemID = 120033, Weight = 2297, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10001    },
    { ID = 1407, Drop = { { ItemID = 120031, Weight = 4689, Amount = 1 }, { ItemID = 120032, Weight = 2345, Amount = 1 }, { ItemID = 120033, Weight = 2966, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10000    },
    { ID = 1108, Drop = { { ItemID = 120031, Weight = 5882, Amount = 1 }, { ItemID = 120032, Weight = 2941, Amount = 1 }, { ItemID = 120033, Weight = 1176, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 9999    },
    { ID = 1208, Drop = { { ItemID = 120031, Weight = 5609, Amount = 1 }, { ItemID = 120032, Weight = 2805, Amount = 1 }, { ItemID = 120033, Weight = 1586, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10000    },
    { ID = 1308, Drop = { { ItemID = 120031, Weight = 5136, Amount = 1 }, { ItemID = 120032, Weight = 2568, Amount = 1 }, { ItemID = 120033, Weight = 2297, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10001    },
    { ID = 1408, Drop = { { ItemID = 120031, Weight = 4689 }, { ItemID = 120032, Weight = 2345, Amount = 1 }, { ItemID = 120033, Weight = 2966, Amount = 1 }, { ItemID = 0, Weight = 0, Amount = 1 } }, ProbBase = 10000    },
}

local optionalTest = {
    { id = 1, age = 15, name = "alice" },
    { id = 2, age = 32, name = "bob", address = "usa" },
    { id = 3, age = 45, name = "chris", address = "canada" },
}

-- print(table.show(GetLuaType(t_nil)))
-- print(table.show(GetLuaType(t_undef)))
-- print(table.show(GetLuaType(t_number)))
-- print(table.show(GetLuaType(t_string)))
-- print(table.show(GetLuaType(t_bool)))
-- print(table.show(GetLuaType(t_func)))
-- print(GetLuaType(t_arr))
-- print(GetLuaType(t_tab))
print(GetLuaType(config))
-- print(GetLuaType(optionalTest))