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
        ["bogd_other_start_level"] = {
            ["name"] = "开始修仙",
            ["inspect_str"] = "开始修仙",
            ["recipe_desc"] = "开始修仙",
        },
        ["bogd_other_force_level_up"] = {
            ["name"] = "突破丹",
            ["inspect_str"] = "突破丹",
            ["recipe_desc"] = "突破丹",
        },
    --------------------------------------------------------------------
    --- 01_items
        ["bogd_item_cleaning_broom"] = {
            ["name"] = "清洁扫把 测试",
            ["inspect_str"] = "清洁扫把 测试",
            ["recipe_desc"] = "清洁扫把 测试",
        },
    --------------------------------------------------------------------
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