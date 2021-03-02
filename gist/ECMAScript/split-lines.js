const regex = /function +(?<funcName>\w+) *\((?<paramList>[\w\,]+)?\)\s*logEvent\((?<eventVar>\w+)\)/g;
const str = `-- 统计竞技场的活跃人数
function ReportArenaActive()
    logEvent(Event_PositionActive, {
        [Params_PostionName] = PositionType_Arena
    })
end

-- 统计副本的活跃人数
function ReportFbActive()
    logEvent(Event_PositionActive, {
        [Params_PostionName] = PositionType_Fb
    })
end

-- 统计许愿池的活跃人数
function ReportMagicHouseActive()
    logEvent(Event_PositionActive, {
        [Params_PostionName] = PositionType_MagicHouse
    })
end

-- 统计通过指定关数的活跃人数
function ReportPassActive(pass)
    logEvent(Event_PositionActive, {
        [Params_PostionName] = pass
    })
end

-- 统计转盘等级
function ReportTurnTableLv(lv)
    logEvent(Event_TurnTableLv, {
        [Params_Level] = lv,
    })
end

-- 统计点击转盘按钮
function ReportClickTurnTable()
    logEvent(Event_ClickTurnTable)
end

-- 统计天赋多档选择
function ReportEnterTalent(index, cost)
    logEvent(Event_EnterTalent,{
        [Params_Value] = index,
        [Params_Amount] = cost
    })
end

-- 统计扭蛋机次数和消耗钻石数量
function ReportCapsulemachineInfo(times, diamond)
    logEvent(Event_CapsulemachineInfo,{
        [Params_Value] = times,
        [Params_Amount] = diamond
    })
end

-- 统计点击扭蛋机按钮
function ReportClickCapsulemachine()
    logEvent(Event_ClickCapsulemachine)
end

-- 统计进入扭蛋机累充界面
function ReportEnterCapsulemachineTotal()
    logEvent(Event_CapsulemachineTotal)
end

-- 统计扭蛋机累充领取每档奖励
function ReportCapsulemachineTotalReward(id)
    logEvent(Event_CapsulemachineTotalReward, {
        [Params_Value] = id
    })
end

-- 统计进入七日签到界面
function ReportEnterSevenDay()
    logEvent(Event_SevenDaySign,{
        [Params_Value] = 0
    })
end

-- 统计领取七日签到奖励
function ReportSevenDayReward()
    logEvent(Event_SevenDaySign,{
        [Params_Value] = 1
    })
end

-- 统计点击关注奖励
function ReportClickFollowReward()
    logEvent(Event_ClickFollowReward,{
        [Params_Value] = 1
    })
end

-- 统计点击商店里的关注
function ReportClickShopFollow()
    logEvent(Event_ClickFollowReward,{
        [Params_Value] = 0
    })
end

-- 统计进入商店次数
function ReportEnterShop()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Shop,
        [Params_OutFlowStep] = OutFlowStep_EnterShop
    })
end

-- 统计点击商店新手礼包次数
function ReportClickNovicePack()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Shop,
        [Params_OutFlowStep] = OutFlowStep_NovicePack
    })
end

-- 统计点击商店移除广告次数
function ReportClickRemoveAds()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Shop,
        [Params_OutFlowStep] = OutFlowStep_RemoveAds
    })
end

-- 统计点击钻石次数
function ReportClickGem(id)
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Shop,
        [Params_OutFlowStep] = OutFlowStep_Gem,
        [Params_Value] = id
    })
end

-- 统计点击金币次数
function ReportClickCoin(id)
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Shop,
        [Params_OutFlowStep] = OutFlowStep_Coin,
        [Params_Value] = id
    })
end

-- 统计点击黄金宝箱次数
function ReportClickGoldenChest()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Shop,
        [Params_OutFlowStep] = OutFlowStep_GoldenChest
    })
end

-- 统计点击免费黄金宝箱次数
function ReportClickFreeGoldenChest()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Shop,
        [Params_OutFlowStep] = OutFlowStep_GoldenChest_Free
    })
end

-- 统计点击钻石宝箱次数
function ReportClickDiamondChest()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Shop,
        [Params_OutFlowStep] = OutFlowStep_Diamond_Chest
    })
end

-- 统计点击皇冠宝箱次数
function ReportClickCrownChest()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Shop,
        [Params_OutFlowStep] = OutFlowStep_Crown_Chest
    })
end

-- 统计点击基础锻造次数
function ReportClickFoundationForge()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Shop,
        [Params_OutFlowStep] = OutFlowStep_Foundation_Forge
    })
end

-- 统计点击大师锻造次数
function ReportClickMasterForge()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Shop,
        [Params_OutFlowStep] = OutFlowStep_Master_Forge
    })
end

-- 统计点击存钱罐按钮次数
function ReportClickPiggyBank()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Main,
        [Params_OutFlowStep] = OutFlowStep_PiggyBank
    })
end

-- 统计点击购买每日角色礼包次数
function ReportClickHeroDailyPack(id)
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Main,
        [Params_OutFlowStep] = OutFlowStep_HeroPack,
        [Params_Value] = id
    })
end

-- 统计点击购买每日强化礼包次数
function ReportClickEnhanceDailyPack(id)
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Main,
        [Params_OutFlowStep] = OutFlowStep_EnhancePack,
        [Params_Value] = id
    })
end

-- 统计点击累计充值次数
function ReportClickTotalTopup()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Main,
        [Params_OutFlowStep] = OutFlowStep_TotalTopup
    })
end

-- 统计点击BattlePass次数
function ReportBuyBattlePass()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Main,
        [Params_OutFlowStep] = OutFlowStep_BuyBattlePassView
    })
end

-- 统计点击购买BattlePass按钮次数
function ReportClickBattlePass()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Main,
        [Params_OutFlowStep] = OutFlowStep_ClickBattlePass
    })
end

-- 统计显示装备页面次数
function ReportShowEquipView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_HeroEquip,
        [Params_OutFlowStep] = OutFlowStep_Equip
    })
end

-- 统计显示装备详情页面次数
function ReportShowEquipDetailView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_HeroEquip,
        [Params_OutFlowStep] = OutFlowStep_EquipDetail
    })
end

-- 统计显示合成页面次数
function ReportShowFuseView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_HeroEquip,
        [Params_OutFlowStep] = OutFlowStep_Fuse
    })
end

-- 统计显示角色页面次数
function ReportShowHeroView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_HeroEquip,
        [Params_OutFlowStep] = OutFlowStep_Hero
    })
end

-- 统计显示角色详情页面次数
function ReportShowHeroDetailView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_HeroEquip,
        [Params_OutFlowStep] = OutFlowStep_HeroDetail
    })
end

-- 统计点击灰色角色升级按钮
function ReportClickHeroUpgradeGray()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_HeroEquip,
        [Params_OutFlowStep] = OutFlowStep_HeroUpgradeGray
    })
end

-- 统计点击灰色强化按钮
function ReportClickEnhanceGray()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_HeroEquip,
        [Params_OutFlowStep] = OutFlowStep_EnhanceGray
    })
end

-- 统计显示收藏品页面次数
function ReportShowCollectionView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Collection,
        [Params_OutFlowStep] = OutFlowStep_CollectionMain
    })
end

-- 统计显示收藏品详情页面次数
function ReportShowCollectionDetailView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Collection,
        [Params_OutFlowStep] = OutFlowStep_CollectionDetail
    })
end

-- 统计显示收藏品部件页面次数
function ReportShowCollectionPartView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_Collection,
        [Params_OutFlowStep] = OutFlowStep_CollectionPart
    })
end

-- 统计显示超级武器页面次数
function ReportShowSuperWeaponView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_SuperWeapon,
        [Params_OutFlowStep] = OutFlowStep_SuperWeaponMain
    })
end

-- 统计显示超级武器升星页面次数
function ReportShowSuperWeaponStarView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_SuperWeapon,
        [Params_OutFlowStep] = OutFlowStep_SuperWeaponStar
    })
end

-- 统计显示超级武器升级页面次数
function ReportShowSuperWeaponUpgradeView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_SuperWeapon,
        [Params_OutFlowStep] = OutFlowStep_SuperWeaponUpgrade
    })
end

-- 统计显示启动加载页面次数
function ReportShowLoadingLaunchView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_LoadingPage,
        [Params_OutFlowStep] = OutFlowStep_LoadingLaunch
    })
end

-- 统计显示进入关卡加载页面次数
function ReportShowLoadingPassView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_LoadingPage,
        [Params_OutFlowStep] = OutFlowStep_LoadingPass
    })
end

-- 统计显示返回大厅加载页面次数
function ReportShowLoadingBackView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_LoadingPage,
        [Params_OutFlowStep] = OutFlowStep_LoadingBack
    })
end

-- 统计进入正常游戏模式的次数
function ReportShowNormalGameMode()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_MainPage,
        [Params_OutFlowStep] = OutFlowStep_NormalMode
    })
end

-- 统计进入英雄游戏模式的次数
function ReportShowHeroGameMode()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_MainPage,
        [Params_OutFlowStep] = OutFlowStep_HeroMode
    })
end

-- 统计显示签到页面次数
function ReportShowSignView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_MainPage,
        [Params_OutFlowStep] = OutFlowStep_SignView
    })
end

-- 统计显示许愿页面次数
function ReportShowMagicView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_MainPage,
        [Params_OutFlowStep] = OutFlowStep_MagicView
    })
end

-- 统计显示切换关卡页面次数
function ReportShowChangeView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_MainPage,
        [Params_OutFlowStep] = OutFlowStep_ChangeView
    })
end

-- 统计显示切换关卡页面次数
function ReportShowNovicePackView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_MainPage,
        [Params_OutFlowStep] = OutFlowStep_NovicePackView
    })
end

-- 统计显示普通关卡奖励页面次数
function ReportShowNormalPassRewardView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_MainPage,
        [Params_OutFlowStep] = OutFlowStep_NormalPassRewardView
    })
end

-- 统计显示英雄关卡奖励页面次数
function ReportShowHeroPassRewardView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_MainPage,
        [Params_OutFlowStep] = OutFlowStep_HeroPassRewardView
    })
end

-- 统计点击进入游戏按钮次数
function ReportClickEnterGame()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_MainPage,
        [Params_OutFlowStep] = OutFlowStep_EnterGame
    })
end

-- 统计显示竞技场页面次数
function ReportShowArenaView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_PlayWay,
        [Params_OutFlowStep] = OutFlowStep_ArenaView
    })
end

-- 统计显示副本页面次数
function ReportShowFbView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_PlayWay,
        [Params_OutFlowStep] = OutFlowStep_FbView
    })
end

-- 统计显示BattlePass页面次数
function ReportShowBattlePassView()
    logEvent(Event_OutFlow, {
        [Params_OutFlowType] = OutFlowType_PlayWay,
        [Params_OutFlowStep] = OutFlowStep_BattlePassView
    })
end

function ReportError(error)
    logEvent(Event_Login, {
        [Params_Error] = error
    })
end

function ReportUserLogin(method)
    logEvent(Event_Login, {
        [Params_Method] = method
    })
end

function ReportUserLevelUp(level)
    logEvent(Event_LevelUp, {
        [Params_Level] = level
    })
end

function ReportResourcesUpdateCompleted(success, error)
    logEvent(Event_ResoucesUpdate, {
        [Params_Success] = success and 1 or 0,
        [Params_Error]   = error,
    })
end

function ReportLaunchGame()
    logEvent(Event_LaunchGame)
end

function ReportEnterHome()
    logEvent(Event_EnterHome)
end

local function reportSelectContent(typ, id)
    logEvent(Event_SelectContent, {
        [Params_ContentType] = typ,
        [Params_ItemId]      = tostring(id)
    })
end
function ReportLevelStart(gameMode, difficult, gameId, chapter, character, weapon, hat, gloves, clothes, shoes, pants, isReEnter)
    logEvent(Event_LevelStart, {
        [Params_GameMode]        = gameMode,
        [Params_ChapterDiffcult] = difficult,
        [Params_GameId]          = gameId,
        [Params_LevelName]       = chapter,
        [Params_Character]       = character,
        [Params_Weapon]          = weapon,
        [Params_Hat]             = hat,
        [Params_Gloves]          = gloves,
        [Params_Clothes]         = clothes,
        [Params_Shoes]           = shoes,
        [Params_Pants]           = pants,
        [Params_Value]           = isReEnter and 1 or 0,
    })
    reportSelectContent(ContentType_Weapon    , weapon)
    reportSelectContent(ContentType_Hat       , hat)
    reportSelectContent(ContentType_Gloves    , gloves)
    reportSelectContent(ContentType_Clothes   , clothes)
    reportSelectContent(ContentType_Shoes     , shoes)
    reportSelectContent(ContentType_Pants     , pants)
    reportSelectContent(ContentType_Hero      , character)
end

---ReportLevelEnded
---@param gameMode number
---@param difficult number
---@param gameId string
---@param chapter number
---@param chapterLevel number
---@param wave number
---@param level number
---@param reviveTimes number
---@param success boolean
---@param error string
---@param gameTime number
---@param replayTimes number
---@param statics FightStatics
function ReportLevelEnded(gameMode, difficult, gameId, chapter, chapterLevel, wave, level, reviveTimes, success, error, gameTime, replayTimes, statics)
    logEvent(Event_LevelEnd, {
        [Params_GameMode]        = gameMode,
        [Params_ChapterDiffcult] = difficult,
        [Params_GameId]          = gameId,
        [Params_LevelName]       = chapter,
        [Params_ChapterLevel]    = chapterLevel,
        [Params_ChapterWave]     = wave,
        [Params_Level]           = level,
        [Params_ReviveTimes]     = reviveTimes,
        [Params_Success]         = success and 1 or 0,
        [Params_Error]           = error,
        [Params_GameTime]        = gameTime,
        [Params_RelayTimes]      = replayTimes,
        [Params_AdRelayTimes]    = statics.adRelay,
        [Params_GemRelayTimes]   = statics.gemRelay,
        [Params_AdReviveTimes]   = statics.adRevive,
        [Params_GemReviveTimes]  = statics.gemRevive,
    })
end

function ReportLevelState(gameMode, difficult, gameId, chapter, chapterLevel, monsterType, wave, name, level, reviveTimes, state, progress)
    logEvent(Event_LevelState, {
        [Params_GameMode]        = gameMode,
        [Params_ChapterDiffcult] = difficult,
        [Params_GameId]          = gameId,
        [Params_Chapter]         = chapter,
        [Params_ChapterLevel]    = chapterLevel,
        [Params_ChapterWave]     = wave,
        [Params_ChapterType]     = monsterType,
        [Params_LevelName]       = name,
        [Params_Level]           = level,
        [Params_ReviveTimes]     = reviveTimes,
        [Params_Value]           = progress,
        [Params_Error]           = state,
    })
end

function ReportSelectTalent(chapter, chapterLevel, level, talentId, talentType, state, index, choice1, choice2, choice3)
    logEvent(Event_SelectTalent, {
        [Params_LevelName]    = chapter,
        [Params_ChapterLevel] = chapterLevel,
        [Params_Level]        = level,
        [Params_Value]        = talentId,
        [Params_ItemName]     = tostring(talentType),
        [Params_Extra_Value1] = choice1,
        [Params_Extra_Value2] = choice2,
        [Params_Extra_Value3] = choice3,
    })
    reportSelectContent(ContentType_Talent, tostring(talentId))
    reportSelectContent(ContentType_TalentChoice, tostring(choice1))
    reportSelectContent(ContentType_TalentChoice, tostring(choice2))
    reportSelectContent(ContentType_TalentChoice, tostring(choice3))
end

function ReportUpgradeEquip(equipId, level)
    logEvent(Event_UpgradeEquip, {
        [Params_EquipId] = equipId,
        [Params_Level]   = level,
    })
end

function ReportComposeEquip(configId)
    logEvent(Event_ComposeEquip, {
        [Params_ConfigId] = configId,
    })
end

function ReportNetDelay(method, delay, error)
    logEvent(Event_NetDelay, {
        [Params_Method] = method,
        [Params_Delay]  = tostring(delay),
        [Params_Error]  = error,
    })
end

function ReportGainCurrency(name, change, reason, oldValue, newValue)
    logEvent(Event_GainCurrency, {
        [Params_CurrencyName]   = name,
        [Params_Value]          = change,
        [Params_Error]          = reason,
        [Params_From]           = oldValue,
        [Params_To]             = newValue,
    })
end

function ReportCostCurrency(name, change, reason, oldValue, newValue)
    logEvent(Event_CostCurrency, {
        [Params_CurrencyName]   = name,
        [Params_Value]          = change,
        [Params_ItemName]       = reason,
        [Params_From]           = oldValue,
        [Params_To]             = newValue,
    })
end

---@param name string 广告位名称
function ReportAdStart(name)
    logEvent(Event_AdState, {
        [Params_Name]           = name,
        [Params_State]          = "Start",
    })
end

---@param name string 广告位名称
---@param duration integer 时长
function ReportAdSuccess(name, duration)
    logEvent(Event_AdState, {
        [Params_Name]           = name,
        [Params_State]          = "Success",
        [Params_Duration]       = tostring(duration),
    })
end

---@param name string 广告位名称
---@param duration integer 时长
---@param error string 失败原因
function ReportAdFail(name, duration, error)
    logEvent(Event_AdState, {
        [Params_Name]           = name,
        [Params_State]          = "Fail",
        [Params_Value]          = tostring(error),
        [Params_Duration]       = tostring(duration),
    })
end

---@param name string 广告位名称
---@param duration integer 时长
function ReportAdCancel(name, duration)
    logEvent(Event_AdState, {
        [Params_Name]           = name,
        [Params_State]          = "Cancel",
        [Params_Duration]       = tostring(duration),
    })
end

function ReportUpdateDownloadStart(taskCount, fileSize)
    logEvent(Event_UpdateDownload_Start, {
        [Params_Amount] = taskCount,
        [Params_Value]  = fileSize,
    })
end

function ReportUpdateDownloadEnded(taskCount, fileSize, duraion)
    logEvent(Event_UpdateDownload_Ended, {
        [Params_Amount]   = taskCount,
        [Params_Value]    = fileSize,
        [Params_Duration] = duraion,
    })
end

function ReportUpdateMoveCacheStart()
    logEvent(Event_UpdateMoveCache_Start)
end

function ReportUpdateMoveCacheEnded(duration)
    logEvent(Event_UpdateMoveCache_Ended, {
        [Params_Duration] = duration
    })
end

function ReportUnlockHero(id, source, result)
    logEvent(Event_UnlockHero, {
        [Params_ItemId] = id,
        [Params_Value]  = source,
        [Params_Error]  = result,
    })
end

function ReportUpgradeHero(id, from, to)
    logEvent(Event_UpgradeHero, {
        [Params_ItemId] = id,
        [Params_From]   = from,
        [Params_To]     = to,
    })
end

function ReportTryHeroShow(id, times)
    logEvent(Event_TryHero, {
        [Params_ItemId] = id,
        [Params_Value]  = times,
        [Params_Error]  = "Show"
    })
end

function ReportTryHeroUse(id, times)
    logEvent(Event_TryHero, {
        [Params_ItemId] = id,
        [Params_Value]  = times,
        [Params_Error]  = "Use"
    })
end

function ReportTryHeroRefuse(id, times)
    logEvent(Event_TryHero, {
        [Params_ItemId] = id,
        [Params_Value]  = times,
        [Params_Error]  = "Refuse"
    })
end

function ReportTryHeroAdFail(id, times)
    logEvent(Event_TryHero, {
        [Params_ItemId] = id,
        [Params_Value]  = times,
        [Params_Error]  = "AdFail"
    })
end

function ReportReviveViewState(state, chapter, level, reason, clickedAd)
    logEvent(Event_ReviveViewState, {
        [Params_State] = state,
        [Params_Chapter] = chapter,
        [Params_ChapterLevel] = level,
        [Params_Error] = reason,
        [Params_Value] = clickedAd and 1 or 0,
    })
end

-- 暂缺少OrderId进行筛选漏斗分析
-- function ReportStartPurchase(productId, orderId)
--     logEvent(Event_StartPurchase, {
--         [Params_ItemId] = productId,
--         [Params_Value]  = orderId
--     })
-- end

-- 暂缺少OrderId进行筛选漏斗分析
-- function ReportCompletedPurchase(productId, orderId)
--     logEvent(Event_CompletedPurchase, {
--         [Params_ItemId] = productId,
--         [Params_Value]  = orderId
--     })
-- end

function ReportCompletePayment(productId, title, price)
    logEvent(Event_CompletedPayment, {
        [Params_ItemId] = productId,
        [Params_Name]   = title,
        [Params_Value]  = price,
    })
end

---@param chestId any         宝箱唯一ID
---@param openType any        宝箱开启方式
---@param isContinue boolean  是否为连续开箱
function ReportOpenChest(chestId, openType, isContinue)
    local times = LocalData.chestOpenTimes or { total = {}, continue = {} }
    local key = string.format("%s_%s", tostring(chestId), tostring(openType))
    local totalTimes = (times.total[key] or 0) + 1
    local contiTimes = isContinue and ((times.continue[key] or 0) + 1) or 0

    logEvent(Event_OpenChest, {
        [Params_ItemId] = chestId,
        [Params_State]  = openType,
        [Params_Extra_Value1] = totalTimes,
        [Params_Extra_Value2] = contiTimes,
    })

    times.total[key] = totalTimes
    times.continue[key] = contiTimes
    LocalData.chestOpenTimes = times
    LocalDataManager.Save()
end

function ReportNPCState(chapter, chpaterLevel, npcId, state)
    logEvent(Event_NpcState, {
        [Params_Chapter]      = chapter,
        [Params_ChapterLevel] = chpaterLevel,
        [Params_ItemId]       = npcId,
        [Params_State]        = state,
    })
end

function ReportTimeChsetOperation(chestId, quality, operation)
    logEvent(Event_TimeChest, {
        [Params_ItemId]       = chestId,
        [Params_Level]        = quality,
        [Params_State]        = operation,
    })
end

function ReportBindInviteCode(inviteCode)
    logEvent(Event_BindInviteCode,{
        [Params_Invite_Code] = inviteCode
    })
end

function ReportShareSuccess(inviteCode)
    logEvent(Event_ShareSuccess,{
        [Params_Invite_Code] = inviteCode
    })
end

function ReportActivityLevel(chapteId, source)
    logEvent(Event_ActivityLevel, {
        [Params_Chapter] = chapteId,
        [Params_State]   = source,
    })
end

function ReportBattlePass(seasonId, level, event, hasToken, rewardIndex)
    logEvent(Event_BattlePassEvent, {
        [Params_GameId] = seasonId,
        [Params_Level]  = level,
        [Params_State]  = event,
        [Params_Value]  = hasToken and 1 or 0,
        [Params_ItemId] = rewardIndex,
    })
end

function ReportWishPond(event , select)
    logEvent(Event_WishPond , {
        [Params_State]  = event,
        [Params_Value] = select
    })
end

---@param type int types 1=用户看到功能，2=用户免费领取，3=用户付费购买
function ReportUserRecall(type)
    logEvent(Event_UserRecall, {
        [Params_ChapterType] = type,
    })
end

function ReportGuideFirst(name,state)
    logEvent(Event_GuideFirst,{
        [Params_Name]  = name,
        [Params_State] = state,
    })
end

function EnterArenaView(seasonId, selfRank)
    logEvent(Event_EnterArenaView, {
        [Params_Season] = seasonId,
        [Params_SelfRank]  = selfRank,
    })
end

function AcceptDailyTask(taskId, isHidden)
    logEvent(Event_AcceptDailyTask, {
        [Params_TaskId] = taskId,
        [Params_State] = isHidden and 1 or 0,
    })
end

function CompleteDailyTask(taskId, step)
    logEvent(Event_CompleteDailyTask, {
        [Params_TaskId] = taskId,
        [Params_Step] = step,
    })
end`;
let m;

while ((m = regex.exec(str)) !== null) {
    // This is necessary to avoid infinite loops with zero-width matches
    if (m.index === regex.lastIndex) {
        regex.lastIndex++;
    }
    
    // The result can be accessed through the `m`-variable.
    // m.forEach((match, groupIndex) => {
    //     console.log(`Found match, group ${groupIndex}: ${match}`);
    // });

    const g = m.groups
    console.log(`${g.funcName}|${g.eventVar}`)
}
