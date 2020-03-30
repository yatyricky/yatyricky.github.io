math.clamp = function(value, min, max)
    return math.min(math.max(min, value), max)
end
