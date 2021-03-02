-- require("common")

-- local tab = {
--     [12] = 5,
--     [13] = 12,
--     [17] = 33,
--     [20] = 10,
-- }

-- local displayItems = table.query(tab, {
--     where = function(k, v)
--         return k < 15 and v < 10
--     end,
-- })

-- print(table.show(displayItems))

local function func(str, ...)
    print('------')
    print(str)
    for key, value in pairs({...}) do
        print(value)
    end
end

func("abc", 1, 2, 3)
func("abc", 1, nil, 3)
