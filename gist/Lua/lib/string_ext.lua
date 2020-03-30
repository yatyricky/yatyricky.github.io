function string.trim(s)
    return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

function string.split(inputstr, sep)
    if string.len(inputstr) == 0 then
        return {}
    end
    sep = sep or "%s"
    local t = {}
    for field, s in string.gmatch(inputstr, "([^" .. sep .. "]*)(" .. sep .. "?)") do
        table.insert(t, field)
        if s == "" then
            return t
        end
    end
    return t
end

function string.start_with(str1, str2)
    return string.sub(str1, 1, #str2) == str2
end
