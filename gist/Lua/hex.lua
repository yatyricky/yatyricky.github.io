require('gist/Lua/lib/math_ext')
local ErrorCode = {}

local dictionary = "D948CSEHQZ5XBAJFM1PGK7UVT2WNYR36"
local dictionaryArr = {}
local dictionaryInv = {}
for i = 1, string.len(dictionary) do
    local c = string.sub(dictionary, i, i)
    dictionaryArr[i] = c
    dictionaryInv[c] = i
end

local codes = {
    200,
    20400,
    20401,
    20402,
    20403,
    20404,
    20405,
    20406,
    20407,
    20409,
    20408,
    20410,
    20411,
    20412,
    20413,
    20414,
    20415,
    20416,
    20417,
    20418,
    20419,
    20420,
    20421,
    20422,
    20423,
    20500,
    20501,
    20502,
    20601,
    20602,
    20603,
    20604,
    20605,
    20606,
    20607,
    20608,
    20701,
    20801,
    20810,
    20811,
    20812,
    20813,
    20814,
    20815,
    20901,
    20902,
    20950,
    20951,
    20952,
    20953,
    21000,
    21001,
    21002,
    21003,
    21004,
    21005,
    21100,
    21101,
    21201,
    21202,
    21250,
    21251,
    21252,
    21253,
    21254,
    21255,
    21256,
    21300,
    21301,
    21302,
    21350,
    21351,
    21352,
    21353,
    21354,
    21355,
    21400,
    21450,
    25000,
    1000,
    1001,
    1002,
    1003,
    1004,
    1005,
    1006,
    1007,
    2001,
    2002,
    2003,
    2004,
    2005,
    2006,
    2007,
    2008,
    2009,
    3000,
    3001,
    3002,
    3003,
    3004,
    3005,
    3006,
    3007,
    3008,
    4000,
    4001,
    4002,
    5000,
    5001,
    6001,
    6002,
    6003,
    6600,
    6601,
    6602,
    6603,
    6604,
    7100,
    7101,
    7102,
    7103,
    7201,
    7202,
    7203,
    7204,
    7205,
    7206,
    7207,
    7208,
    7226,
    7300,
    7301,
    7302,
    7303,
    7304,
    7305,
    7306,
    7307,
    7308,
    7400,
    7401,
    7402,
    7403,
    7404,
    7405,
    7406,
    7407,
    7408,
    7409,
    7410,
    7411,
    7412,
    7413,
    7414,
    7415,
    7416,
    7417,
    7418,
    7421,
    7422,
    7423,
    7424,
    7425,
    7426,
    7428,
    7429,
    7431,
    7440,
    7451,
    7500,
    7501,
    7502,
    7503,
    7504,
    7505,
    7506,
    7507,
    7508,
    7510,
    7511,
    10000,
    10001,
    10002,
    10003,
    10004,
    10005,
    10006,
    10007,
    10100,
    10101,
    10102,
    110000,
    110001,
    110002,
    110003,
    110004,
    110005,
    110006,
    110007,
}

function ErrorCode.ToDisplayCode(code)
    local s = ""
    local m = 32768
    local codeClamp = math.clamp(code, 0, 1048576)
    if codeClamp ~= code then
        logErrorCode(ErrorCode.CrashIllegalArguments, "error code out of bounds")
        code = codeClamp
    end
    while m > 0 do
        local d = math.floor(code / m)
        code = code - d * m
        s = s .. dictionaryArr[d + 1]
        m = math.floor(m / 32)
    end
    return s
end

function ErrorCode.ToRawCode(displayCode)
    local v = 0
    local m = 32768
    for i = 1, string.len(displayCode) do
        local c = string.sub(displayCode, i, i)
        v = v + (dictionaryInv[c] - 1) * m
        m = math.floor(m / 32)
    end
    return v
end

for i, v in ipairs(codes) do
    local enc = ErrorCode.ToDisplayCode(v)
    local dec = ErrorCode.ToRawCode(enc)
    print("Raw:" .. tostring(v) .. " Enc:" .. enc .. " Dec:" .. tostring(dec))
end



