local cls = {}

function cls.GetCSTDaySinceEpoch(time)
    return math.floor(cls.GetCSTSeconds(time) / 86400)
end

function cls.GetCSTHourOfDay(time)
    return math.floor((cls.GetCSTSeconds(time) - cls.GetCSTDaySinceEpoch(time) * 86400) / 3600)
end

function cls.getDayOfWeek(timestamp)
    local date = os.date("!*t", timestamp)
    return date.wday
end

function cls.GetCSTDayOfWeek(time)
    return cls.getDayOfWeek(cls.GetCSTSeconds(time))
end

function cls.GetCSTSeconds(time)
    return time + 8 * 3600
end

function cls:IsCurfew(sTime)
    if not sTime then
        sTime = UserDataManager.GetInstance():GetServerTime()
        if not sTime then
            return true
        end
    end
    local dow = cls.GetCSTDayOfWeek(sTime)
    local hod = cls.GetCSTHourOfDay(sTime)
    return tostring(not ((5 <= dow and dow <= 7) and (20 <= hod and hod <=21))) .. " dow=" .. dow .. " hod=" .. hod
end

for i = 1630281600, 1630972800, 1234 do
    print(os.date("%Y-%m-%d %H:%M:%S", i) .. " is curfew: " .. tostring(cls:IsCurfew(i)))
end


print(os.date("%Y-%m-%d %H:%M:%S", 1630489781) .. " is curfew: " .. tostring(cls:IsCurfew(1630489781)))