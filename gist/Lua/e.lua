require("common")

local tab = {
    [12] = 5,
    [13] = 12,
    [17] = 33,
    [20] = 10,
}

local displayItems = table.query(tab, {
    where = function(k, v)
        return k < 15 and v < 10
    end,
})

print(table.show(displayItems))