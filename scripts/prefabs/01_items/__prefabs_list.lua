----------------------------------------------------
--- 本文件单纯返还路径
----------------------------------------------------

-- local function sum(a, b)
--     return a + b
-- end

-- local info = debug.getinfo(sum)

-- for k,v in pairs(info) do
--         print(k,':', info[k])
-- end

--------------------------------------------------------------------------
local addr_test = debug.getinfo(1).source           ---- 找到绝对路径

local temp_str_index = string.find(addr_test, "scripts/prefabs/")
local temp_addr = string.sub(addr_test,temp_str_index,-1)
-- print("fake error 6666666666666:",temp_addr)    ---- 找到本文件所处的相对路径

local temp_str_index2 = string.find(temp_addr,"/__prefabs_list.lua")

local Prefabs_addr_base = string.sub(temp_addr,1,temp_str_index2) .. "/"    --- 得到最终文件夹路径

---------------------------------------------------------------------------
-- local Prefabs_addr_base = "scripts/prefabs/01_bogd_items/"               --- 文件夹路径
local prefabs_name_list = {

    "01_foundation_establishment_pill",             -- 筑基丹
    "02_golden_core_pill",                          -- 金丹
    "03_spirit_infant_pill",                        -- 元婴丹
    "04_soul_formation_pill",                       -- 化神丹
    "05_soul_formation_pill_not_charged",           -- 未充能的化神丹
    "06_body_integration_pill",                     -- 合体丹
    "07_great_vehicle_pill",                        -- 大乘丹
    "08_ascension_pill",                            -- 飞升丹

    "09_shard_of_god",                              -- 神之碎片
    "10_shard_of_demon",                            -- 魔之碎片
    "11_blood_of_god",                              -- 神之血
    "12_blood_of_demon",                            -- 魔之血
    "13_ephemeral_life_stone",                      -- 浮生石

    "14_deification_pill",                          -- 化神丹
    "15_demonization_pill",                         -- 化魔丹

    "16_exp_pill",                                  -- 经验丹

    

    
}


---------------------------------------------------------------------------
---- 正在测试的物品
if TUNING.BOGD_DEBUGGING_MODE == true then
    local debugging_name_list = {



    }
    for k, temp in pairs(debugging_name_list) do
        table.insert(prefabs_name_list,temp)
    end
end
---------------------------------------------------------------------------












local ret_addrs = {}
for i, v in ipairs(prefabs_name_list) do
    table.insert(ret_addrs,Prefabs_addr_base..v..".lua")
end
return ret_addrs