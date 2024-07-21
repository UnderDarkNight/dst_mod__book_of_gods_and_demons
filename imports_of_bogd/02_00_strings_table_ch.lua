----------------------------------------------------------------------------------------------------------------------------------
--[[

    中文文本
    
]]--
----------------------------------------------------------------------------------------------------------------------------------


local crrent_language = "ch"
if TUNING.BOGD_GET_LANGUAGE() ~= crrent_language then
    return
end

local strings = {   
    --------------------------------------------------------------------
    --- 正在debug 测试的
        ["bogd_skin_test_item"] = {
            ["name"] = "皮肤测试物品",
            ["inspect_str"] = "inspect单纯的测试皮肤",
            ["recipe_desc"] = "测试描述666",
        },
        ["bogd_other_test_item_start_level"] = {
            ["name"] = "开始修仙",
            ["inspect_str"] = "开始修仙",
            ["recipe_desc"] = "开始修仙",
        },
        ["bogd_other_test_item_stop_level"] = {
            ["name"] = "废除修为",
            ["inspect_str"] = "废除修为",
            ["recipe_desc"] = "废除修为",
        },
        ["bogd_other_force_level_up"] = {
            ["name"] = "强制突破丹",
            ["inspect_str"] = "强制突破丹",
            ["recipe_desc"] = "强制突破丹",
        },
    --------------------------------------------------------------------
    --- 00_others
        ["level"] = {
            ["level_up_succeed"] = "玩家境界提升",
            ["breakthrough_succeed"] = "突破成功",
            ["breakthrough_faild"] = "突破失败",
            ["ms_playerreroll"] = "角色更换、境界跌落",
        },
    --------------------------------------------------------------------
    --- 01_items
        ["bogd_item_foundation_establishment_pill"] = {
            ["name"] = "筑基丹",
            ["inspect_str"] = "先天期突破到筑基期使用",
            ["recipe_desc"] = "先天期突破到筑基期使用",
        },
        ["bogd_item_golden_core_pill"] = {
            ["name"] = "金丹",
            ["inspect_str"] = "筑基期突破到金丹期使用",
            ["recipe_desc"] = "筑基期突破到金丹期使用",
        },
        ["bogd_item_spirit_infant_pill"] = {
            ["name"] = "元婴丹",
            ["inspect_str"] = "金丹期突破到元婴期使用",
            ["recipe_desc"] = "金丹期突破到元婴期使用",
            ["shadow_fail_by_other_hit"] = "心魔只能自己破除，外人帮忙只会直接失败",
            ["shadow_task_timeout"] = "心魔存在太久，自己消散了",
            ["shadow_task_faild"] = "你没能战胜心魔",
            ["shadow_task_succeed"] = "你成功战胜了心魔",
        },
        ["bogd_item_soul_formation_pill"] = {
            ["name"] = "化神丹",
            ["inspect_str"] = "元婴期突破到化神期使用",
            ["recipe_desc"] = "元婴期突破到化神期使用",
        },
        ["bogd_item_soul_formation_pill_not_charged"] = {
            ["name"] = "未充能的化神丹",
            ["inspect_str"] = "需要使用"..STRINGS.NAMES.MOONGLASS_CHARGED,
            ["recipe_desc"] = "需要使用"..STRINGS.NAMES.MOONGLASS_CHARGED,
        },
        ["bogd_item_body_integration_pill"] = {
            ["name"] = "合体丹",
            ["inspect_str"] = "化神期突破到合体期使用",
            ["recipe_desc"] = "化神期突破到合体期使用",
        },
        ["bogd_item_body_integration_pill_building"] = {
            ["name"] = "通天印",
            ["inspect_str"] = "化神期突破到合体期使用",
            ["recipe_desc"] = "化神期突破到合体期使用",
            ["wrong_building"] = "这不是你的通天印",
            ["wrong_level"] = "未达到使用通天印的境界",
        },
        ["bogd_item_great_vehicle_pill"] = {
            ["name"] = "大乘丹",
            ["inspect_str"] = "合体期突破到大乘期使用",
            ["recipe_desc"] = "合体期突破到大乘期使用",
        },
        ["bogd_item_ascension_pill"] = {
            ["name"] = "飞升丹",
            ["inspect_str"] = "大乘期圆满后飞升使用",
            ["recipe_desc"] = "大乘期圆满后飞升使用",
            ["faild"] = "这个世界无法飞升",
        },
    --------------------------------------------------------------------
    --- 04_treasure
        ["bogd_treasure_excample"] = {
            ["name"] = "示例灵宝",
            ["inspect_str"] = "示例灵宝",
            ["recipe_desc"] = "示例灵宝",
        },
        ["bogd_treasure_divine_punishment"] = {
            ["name"] = "灵·神罚",
            ["inspect_str"] = "召唤闪电，魔不能使用",
        },
        ["bogd_treasure_shadow_tentacle"] = {
            ["name"] = "灵·影鞭",
            ["inspect_str"] = "召唤触手，神不能使用",
        },
        ["bogd_treasure_magic_shield"] = {
            ["name"] = "灵·护体",
            ["inspect_str"] = "给自己套个护盾",
        },
        ["bogd_treasure_map_blink"] = {
            ["name"] = "灵·缩地",
            ["inspect_str"] = "传送到地图指定位置",
        },
        ["bogd_treasure_damage_enhancement"] = {
            ["name"] = "灵·强化",
            ["inspect_str"] = "增加自身攻击力",
        },
        ["bogd_treasure_pet_summon"] = {
            ["name"] = "灵·神宠",
            ["inspect_str"] = "召唤宠物，魔不能使用",
        },
        ["bogd_treasure_treatment"] = {
            ["name"] = "灵·妙手",
            ["inspect_str"] = "恢复血量和精神，魔不能使用",
        },
        ["bogd_treasure_frostfall"] = {
            ["name"] = "灵·霜降",
            ["inspect_str"] = "冰冻范围内怪物",
        },
        ["bogd_treasure_poison_ring"] = {
            ["name"] = "灵·流逝",
            ["inspect_str"] = "创造个毒圈",
        },
        ["bogd_treasure_meteorites"] = {
            ["name"] = "灵·天罚",
            ["inspect_str"] = "召唤陨石",
        },
    --------------------------------------------------------------------
}

----------------------------------------------------------------------------------------------------------------------------------------
    local exps = {50,100,200,300,400,500,600,700,800,900,1000,5000,10000,15000, 20000,25000,30000,35000,40000,45000,50000,55000,60000,65000,70000,75000,80000,85000,90000,95000,100000}
    for k, num in pairs(exps) do
        strings["bogd_other_exp_"..num] = {
            ["name"] = num.."经验",
            ["inspect_str"] = num.."经验",
            ["recipe_desc"] = num.."经验",
        }
    end
----------------------------------------------------------------------------------------------------------------------------------------

TUNING.BOGD_GET_STRINGS = function(prefab_name1,prefab_name2)
    local prefab_name = "nil"
    if type(prefab_name1) == "string" then
        prefab_name = prefab_name1
    elseif type(prefab_name2) == "string" then
        prefab_name = prefab_name2
    end            
    return strings[prefab_name] or {}
end

TUNING.BOGD_GET_ALL_STRINGS = function()
    return strings
end