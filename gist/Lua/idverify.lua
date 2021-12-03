local cls = {}

---@param icNumber string
function cls.ICNumberVerification(icNumber)
    if type(icNumber) ~= "string" then
        return false
    end
    local len = #icNumber
    if len == 15 then
        return string.match(icNumber, "%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d") ~= nil
    end
    if not string.match(icNumber, "%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d[0-9xX]") then
        return false
    end
    local factors = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 }
    local reminders = { 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 }
    local sum = 0
    for i = 1, 17 do
        sum = sum + tonumber(string.sub(icNumber, i, i)) * factors[i]
    end
    local reminder = sum % 11
    local calculatedCheckNumber = reminders[reminder + 1]
    local checkDigit = string.sub(icNumber, 18, 18)
    local checkNumber
    if checkDigit == "x" or checkDigit == "X" then
        checkNumber = 10
    else
        checkNumber = tonumber(checkDigit)
    end
    return checkNumber == calculatedCheckNumber
end

-- assert true
print(cls.ICNumberVerification("429006198911085131"))
print(cls.ICNumberVerification("440524188001010014"))
print(cls.ICNumberVerification("11010519491231002x"))
print(cls.ICNumberVerification("11010519491231002X"))
print(cls.ICNumberVerification("420684198609284037"))
print(cls.ICNumberVerification("652101199007041020"))
print(cls.ICNumberVerification("659001197906240631"))
print(cls.ICNumberVerification("130701199310302288"))
print(cls.ICNumberVerification("52030219891209794X"))
print(cls.ICNumberVerification("130701199310302"))
print(cls.ICNumberVerification("520302198912097"))
print("--------")
-- assert false
print(cls.ICNumberVerification("520302198912097946"))
print(cls.ICNumberVerification("52030219891209794Y"))
print(cls.ICNumberVerification("5203021989120994Y"))
print(cls.ICNumberVerification("52030z198912099333"))
print(cls.ICNumberVerification("659001198006240631"))
print(cls.ICNumberVerification("52030219891a097"))