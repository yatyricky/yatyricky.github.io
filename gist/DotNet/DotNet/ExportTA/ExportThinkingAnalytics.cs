using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Excel4Unity;

namespace EditorTools
{
    public class ExportThinkingAnalytics
    {
        private struct EnumPair
        {
            public string Name;
            public int Value;
        }

        private class Param
        {
            public string Name;
            public string Type;
            public string DisplayName;
            public string Comment;
            public int EnumType; // 0 no enum; 1 string enum; 2 mapped enum
            public List<EnumPair> Enums;
            public int EnumIndex;
        }

        private struct UserInfo
        {
            public string ParamName;
            public bool Resend;
            public string LuaCode;
        }

        private class EventParam : Param
        {
            public string OverrideComment;

            public EventParam(Param param)
            {
                Name = param.Name;
                Type = param.Type;
                DisplayName = param.DisplayName;
                Comment = param.Comment;
                EnumType = param.EnumType;
                Enums = param.Enums;
                EnumIndex = param.EnumIndex;
            }
        }

        private class Event
        {
            public string Name;
            public string DisplayName;
            public List<EventParam> Params = new List<EventParam>();
        }

        private static readonly Dictionary<string, int> LocalVarStatistics = new Dictionary<string, int>
        {
            {"udm", 0},
            {"cls", 0},
            {"funcCache", 0},
            {"strcat", 0},
            {"report", 0},
            {"emptyStr", 0},
            {"primitiveTypeStr", 0},
            {"checkFuncs", 0},
            {"otherScope", 0},
            {"enums", 0},
            {"enumMaps", 0},
            {"strings", 0}
        };

        private static readonly HashSet<string> LuaKeywords = new HashSet<string> { "local" };

        private static readonly Regex RegexIdentifier = new Regex("^[a-zA-Z_][a-zA-Z_0-9]*", RegexOptions.Compiled);
        private static readonly Regex RegexEnums = new Regex(@"\[([a-zA-Z_0-9]+)\]", RegexOptions.Compiled | RegexOptions.Multiline);
        private static readonly Regex RegexMappedEnums = new Regex(@"\[([a-zA-Z_0-9]+)=([\d\-]+)\]", RegexOptions.Compiled | RegexOptions.Multiline);

        private static List<Param> Params;
        private static List<UserInfo> UserInfos;
        private static List<Event> Events;

        private static string EscapeLuaKeyword(string str)
        {
            return LuaKeywords.Contains(str) ? $"[\"{str}\"]" : str;
        }

        private static void ParseParams(Workbook wb)
        {
            var ws = wb.GetSheet("Params");
            Params = new List<Param>();
            var enumCount = 0;
            for (var r = 2; r <= ws.RowsCount; r++)
            {
                var name = ws["A", r];
                if (!RegexIdentifier.IsMatch(name))
                {
                    throw new Exception($"Params A{r} {name} 为不合法的标识符");
                }

                var type = ws["B", r];
                var displayName = ws["C", r];
                var comment = ws["D", r];
                var enumeration = new List<EnumPair>();
                var enumMatches = RegexEnums.Matches(comment);
                var mappedEnumMatches = RegexMappedEnums.Matches(comment);
                var enumType = 0;
                var enumIndex = 0;
                if (enumMatches.Count > 0 && mappedEnumMatches.Count > 0)
                {
                    throw new Exception($"Params A{r} {comment} 格式模糊，要么只定义 [name=1] 要么只定义 [name]");
                }

                if (enumMatches.Count > 0 || mappedEnumMatches.Count > 0)
                {
                    if (enumMatches.Count > 0)
                    {
                        enumType = 1;
                        foreach (Match match in enumMatches)
                        {
                            var matchName = match.Groups[1].Value;
                            enumeration.Add(new EnumPair
                            {
                                Name = matchName,
                                Value = 0
                            });
                        }
                    }

                    if (mappedEnumMatches.Count > 0)
                    {
                        enumType = 2;
                        foreach (Match match in mappedEnumMatches)
                        {
                            var matchName = match.Groups[1].Value;
                            var matchValue = match.Groups[2].Value;
                            enumeration.Add(new EnumPair
                            {
                                Name = matchName,
                                Value = int.Parse(matchValue)
                            });
                        }
                    }
                    enumIndex = enumCount++;
                }

                Params.Add(new Param
                {
                    Name = name,
                    Type = type,
                    DisplayName = displayName,
                    Comment = comment,
                    EnumType = enumType,
                    Enums = enumeration,
                    EnumIndex = enumIndex
                });
            }
        }

        private static Param FindParam(string name)
        {
            return Params.FirstOrDefault(p => p.Name == name);
        }

        private static void ParseUser(Workbook wb)
        {
            var ws = wb.GetSheet("User");
            UserInfos = new List<UserInfo>();
            for (int c = 2; c <= ws.RowsCount; c++)
            {
                var name = ws["A", c];
                var param = FindParam(name);
                if (param == null)
                {
                    throw new Exception($"User A{c} 使用了未定义的参数 {name}");
                }
                var resend = ws["B", c] == "TRUE";
                var lua = ws["F", c];
                UserInfos.Add(new UserInfo
                {
                    ParamName = name,
                    Resend = resend,
                    LuaCode = lua
                });
            }
        }

        private static void ParseEvents(Workbook wb)
        {
            var ws = wb.GetSheet("Events");
            Events = new List<Event>();
            Event curr = null;
            for (int c = 2; c <= ws.RowsCount; c++)
            {
                var name = ws["A", c];
                if (!string.IsNullOrEmpty(name))
                {
                    if (curr != null)
                    {
                        Events.Add(curr);
                    }
                    curr = new Event();
                    curr.Name = name;
                }
                var displayName = ws["B", c];
                if (!string.IsNullOrEmpty(displayName))
                {
                    curr.DisplayName = displayName;
                }
                var paramName = ws["C", c];
                if (!string.IsNullOrEmpty(paramName))
                {
                    var param = FindParam(paramName);
                    if (param == null)
                    {
                        throw new Exception($"Events C{c} 使用了未定义的参数 {paramName}");
                    }
                    var comment = ws["F", c].Trim();
                    if (comment != param.Comment.Trim() && param.EnumType != 0)
                    {
                        throw new Exception($"Events F{c} 改写了定义在Params表中{paramName}字段的枚举类型");
                    }
                    curr.Params.Add(new EventParam(param)
                    {
                        OverrideComment = comment
                    });
                }
            }
            if (curr != null)
            {
                Events.Add(curr);
            }
        }

        private static void EmitCode()
        {
            var sb = new StringBuilder();
            sb.Append(@"--================WARNING================
--This code is generated by thinking-analytics-code-gen/run.js
--Do not modify it manually!
--$ cd thinking-analytics-code-gen
--$ npm install
--$ node run
--================WARNING================
");
            // enum maps
            for (int i = 0; i < Params.Count; i++)
            {
                var param = Params[i];
                if (param.EnumType != 0)
                {
                    if (param.EnumType == 2)
                    {
                        sb.Append($"local enum{param.EnumIndex}_map = {{ {string.Join(", ", from pair in param.Enums select $"[{pair.Value}] = \"{pair.Name}\"")} }}\n");
                    }
                }
            }
            // const
            sb.Append(@"local strcat_enum = { ""ENUM_"", 0 }
local strcat_err = { ""ThinkingAnalytics SDK: expect "", 0, ""."", 0, "" to be "", 0, "", got "", 0, "" insead."" }
local t_concat = table.concat
local d_traceback = debug.traceback

local cls = {}
SDK_TA = cls

");

            // set user data
            sb.Append(@"local prevUserData = {}
local function userSetWhenChanged(life_time, rec_chapter, rec_level, rec_chapter2, rec_level2, level, diamond, coins, first_dt_lobby, last_dt_event, total_recharged, total_recharge_count, first_dt_recharge, last_dt_recharge, invite_from, invite_num, invite_code, is_verified, ab_pack, channel)
    local changed = false
");
            foreach (var userInfo in UserInfos)
            {
                if (userInfo.Resend)
                {
                    sb.Append($"    if prevUserData.{userInfo.ParamName} ~= {userInfo.ParamName} then\n");
                    sb.Append($"        log(\"SDK_TA {userInfo.ParamName}\", prevUserData.{userInfo.ParamName}, \"=>\", {userInfo.ParamName}, \"eol\")\n");
                    sb.Append($"        prevUserData.{userInfo.ParamName} = {userInfo.ParamName}\n");
                    sb.Append($"        changed = true\n");
                    sb.Append($"    end\n");
                }
                else
                {
                    sb.Append($"    -- {userInfo.ParamName} doesn't matter\n");
                }
            }
            sb.Append(@"    if changed then
        log(""SDK_TA user data changed, report:"", prevUserData)
        SDK.SetUserThinkingAnalytics(
");
            for (int i = 0; i < UserInfos.Count; i++)
            {
                var userInfo = UserInfos[i];
                sb.Append($"            \"{userInfo.ParamName}\", {userInfo.ParamName}{(i < UserInfos.Count - 1 ? "," : string.Empty)}\n");
            }
            sb.Append(@"        )
    else
        log(""SDK_TA user data not changed, ignore."")
    end
end
");
            // common funcs
            sb.Append(@"
local logEvent = SDK.LogEventThinkingAnalytics
local superPropertiesEvent = SDK.SetThinkingSuperProperties
local superPropertiesData = {}
---设置事件公共属性 目前只有1个公共属性 先这样写死 后续改成读配置的 不要介意
---@param local_deviceId string 游戏使用的设备号
local function userSetSuperProperties(local_deviceId,OAId)
    local changed = false
    if superPropertiesData.local_deviceId ~= local_deviceId then
        log(""SDK_TA rec_chapter"", superPropertiesData.local_deviceId, ""=>"", local_deviceId, ""eol"")
        superPropertiesData.local_deviceId = local_deviceId
        changed = true
    end
    if superPropertiesData.OAId ~= OAId then
        log(""SDK_TA rec_chapter"", superPropertiesData.OAId, ""=>"", OAId, ""eol"")
        superPropertiesData.OAId = OAId
        changed = true
    end

    if changed then
        superPropertiesEvent(""local_deviceId"", local_deviceId, ""OAId"", OAId)
    end
end
");
            // report
            sb.Append(@"
---游戏本地使用的设备id
local local_deviceId = """"
local function report(...)
    local udm = require(""Manager.UserDataManager"").GetInstance() ---@type UserDataManagerAnnotated
    local bm = require(""Manager.BagManager"").GetInstance() ---@type BagManager
    local userInfo = udm:GetUserData().userInfo
    local antiAddiction = udm:GetUserData().extension.antiAddiction
    local chapterProg = userInfo.chapterProgress[1] or {}
    local chapterProg2 = userInfo.chapterProgress[2] or {}
    udm:sdkReportUserId()
    local now = udm:GetServerTime()
    local nowDateTime
    if now then
        nowDateTime = CSUtil.GetDateTime(now)
    else
        nowDateTime = DateTime.Now
    end
    if local_deviceId == """" then
        local_deviceId = AppConst.Access_info
    end
    userSetSuperProperties(local_deviceId,SDK.OAId)
    userSetWhenChanged(
");
            for (int i = 0; i < UserInfos.Count; i++)
            {
                var userInfo = UserInfos[i];
                sb.Append($"        {userInfo.LuaCode}{(i < UserInfos.Count - 1 ? "," : string.Empty)}\n");
            }
            // common
            sb.Append(@"    )
    logEvent(...)
end

local stringEmpty = """"

local function checkNumber(var, evt, prm)
    local t = type(var)
    if t == ""number"" then
        return var
    else
        strcat_err[2] = evt
        strcat_err[4] = prm
        strcat_err[6] = ""number""
        strcat_err[8] = t
        logError(t_concat(strcat_err), d_traceback())
        return 0
    end
end

local function checkBoolean(var, evt, prm)
    local t = type(var)
    if t == ""boolean"" then
        return var
    else
        strcat_err[2] = evt
        strcat_err[4] = prm
        strcat_err[6] = ""boolean""
        strcat_err[8] = t
        logError(t_concat(strcat_err), d_traceback())
        return false
    end
end

local function checkString(var, evt, prm)
    local t = type(var)
    if t == ""string"" then
        return var
    else
        strcat_err[2] = evt
        strcat_err[4] = prm
        strcat_err[6] = ""string""
        strcat_err[8] = t
        logError(t_concat(strcat_err), d_traceback())
        return tostring(var)
    end
end

");
            // enums
            for (int i = 0; i < Params.Count; i++)
            {
                var param = Params[i];
                if (param.EnumType != 0)
                {
                    sb.Append($"local enum{param.EnumIndex} = {{ [stringEmpty] = 1, {string.Join(", ", from pair in param.Enums select $"{EscapeLuaKeyword(pair.Name)} = 1")} }}\n");
                }
            }
            // common
            sb.Append(@"
local function checkEnum(var, evt, prm, whichEnum)
    if whichEnum[var] == 1 then
        return var
    else
        strcat_err[2] = evt
        strcat_err[4] = prm
        strcat_err[6] = t_concat(table.keys(whichEnum), "","")
        strcat_err[8] = tostring(var)
        logError(t_concat(strcat_err), d_traceback())
        return stringEmpty
    end
end
");
            // event funcs
            foreach (var @event in Events)
            {
                // comment
                sb.Append($"\n---{@event.DisplayName}\n");
                for (int i = 0; i < @event.Params.Count; i++)
                {
                    var param = @event.Params[i];
                    sb.Append($"---@param {param.Name} {(param.EnumType == 2 ? "number" : param.Type)} 参数-{i + 1} {param.DisplayName}{(string.IsNullOrEmpty(param.OverrideComment) ? "" : $" {param.OverrideComment}")}\n");
                }
                sb.Append($"function cls.Report_{@event.Name}({string.Join(", ", from e in @event.Params select e.Name)})\n");
                // convert numbered enum to string
                foreach (var param in @event.Params)
                {
                    if (param.EnumType == 2)
                    {
                        sb.Append($"    strcat_enum[2] = {param.Name}\n");
                        sb.Append($"    {param.Name} = enum{param.EnumIndex}_map[{param.Name}] or t_concat(strcat_enum) -- convert numbered enum to string\n");
                    }
                }
                // check data type
                foreach (var param in @event.Params)
                {
                    if (param.EnumType != 0)
                    {
                        sb.Append($"    {param.Name} = checkEnum({param.Name}, \"{@event.Name}\", \"{param.Name}\", enum{param.EnumIndex})\n");
                    }
                    else if (param.Type == "string")
                    {
                        sb.Append($"    {param.Name} = checkString({param.Name}, \"{@event.Name}\", \"{param.Name}\")\n");
                    }
                    else if (param.Type == "number")
                    {
                        sb.Append($"    {param.Name} = checkNumber({param.Name}, \"{@event.Name}\", \"{param.Name}\")\n");
                    }
                    else if (param.Type == "bool")
                    {
                        sb.Append($"    {param.Name} = checkBoolean({param.Name}, \"{@event.Name}\", \"{param.Name}\")\n");
                    }
                }
                // exec
                sb.Append($"    report(\"{@event.Name}\"");//, "chapter_type", chapter_type, "difficulty", difficulty, "game_id", game_id, "chapter", chapter, "hero_id", hero_id, "pauldrons_id", pauldrons_id, "hat_id", hat_id, "gloves_id", gloves_id, "clothes_id", clothes_id, "shoes_id", shoes_id, "pants_id", pants_id, "pauldrons_level", pauldrons_level, "hat_level", hat_level, "gloves_level", gloves_level, "clothes_level", clothes_level, "shoes_level", shoes_level, "pants_level", pants_level, "superweapon_id", superweapon_id, "is_reconnect", is_reconnect, "level", level, "superweapon_level", superweapon_level, "superweapon_star", superweapon_star)");
                if (@event.Params.Count > 0)
                {
                    sb.Append(", ");
                    sb.Append(string.Join(", ", from e in @event.Params select ($"\"{e.Name}\", {e.Name}")));
                }
                sb.Append(@")
end
");
            }
            sb.Append(@"
return cls
");
            File.WriteAllText(@"C:\Users\yatyr\workspace\barrett-client\client\Assets\LuaFramework\Lua\ReportThinkingAnalytics.lua", sb.ToString());
        }

        //[MenuItem("Tools/手动导出/数数Lua代码", false, 102)]
        public static void LuaCodeGen()
        {
            var wb = Workbook.LoadFrom(@"C:\Users\yatyr\workspace\barrett-client\thinking-analytics-code-gen\GS数数埋点.xlsx");
            ParseParams(wb);
            ParseUser(wb);
            ParseEvents(wb);
            EmitCode();
        }
    }
}
