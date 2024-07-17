----------------------------------------------------------------------------------------------------------------------------------
--[[

    英文文本
    
]]--
----------------------------------------------------------------------------------------------------------------------------------

local all_strings = TUNING.BOGD_GET_ALL_STRINGS()
for prefab_name, ret_table in pairs(all_strings) do
    if ret_table.name then -- 如果有名字
        STRINGS.NAMES[string.upper(prefab_name)] = ret_table.name
    end
    if ret_table.inspect_str then   -- 检查名字
        STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(prefab_name)] = ret_table.inspect_str
    end
    if ret_table.recipe_desc then   -- 制作栏描述
        STRINGS.RECIPE_DESC[string.upper(prefab_name)] = ret_table.recipe_desc
    end
end