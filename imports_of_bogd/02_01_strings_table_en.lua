----------------------------------------------------------------------------------------------------------------------------------
--[[

    英文文本
    
]]--
----------------------------------------------------------------------------------------------------------------------------------


local crrent_language = "en"
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
    --------------------------------------------------------------------
    --- other
        ["level_name"] = {
            ["练气前期"] = "Early Qi Cultivation",
            ["练气中期"] = "Mid Qi Cultivation",
            ["练气后期"] = "Late Qi Cultivation",
            ["先天前期"] = "Early Prenatal Stage",
            ["先天中期"] = "Mid Prenatal Stage",
            ["先天后期"] = "Late Prenatal Stage",
            ["筑基前期"] = "Early Foundation Establishment",
            ["筑基中期"] = "Mid Foundation Establishment",
            ["筑基后期"] = "Late Foundation Establishment",
            ["金丹前期"] = "Early Golden Core",
            ["金丹中期"] = "Mid Golden Core",
            ["金丹后期"] = "Late Golden Core",
            ["元婴前期"] = "Early Spirit Infant",
            ["元婴中期"] = "Mid Spirit Infant",
            ["元婴后期"] = "Late Spirit Infant",
            ["化神期"] = "Soul Formation",
            ["合体期"] = "Body Integration",
            ["大乘期"] = "Great Vehicle",

            ["需要突破"] = "Require A Breakthrough",
        }
    --------------------------------------------------------------------
    --------------------------------------------------------------------
}

----------------------------------------------------------------------------------------------------------------------------------------
local exps = {50,100,200,300,400,500,600,700,800,900,1000,5000,10000,15000, 20000,25000,30000,35000,40000,45000,50000,55000,60000,65000,70000,75000,80000,85000,90000,95000,100000}
for k, num in pairs(exps) do
    strings["bogd_other_exp_"..num] = {
        ["name"] = num.." EXP",
        ["inspect_str"] = num.." EXP",
        ["recipe_desc"] = num.." EXP",
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