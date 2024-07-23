

--------------------------------------------------------------------------------------------------------------------------------------------
---- 金丹
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("bogd_item_golden_core_pill","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "bogd_item_golden_core_pill",            --  --  inst.prefab  实体名字
    { Ingredient("lavae_egg", 1),Ingredient("purplegem", 5),Ingredient("orangegem", 5),Ingredient("moonrocknugget", 10) }, 
    TECH.MAGIC_THREE, --- TECH.NONE
    {
        nounlock = true,
        no_deconstruction = false,
        atlas = "images/inventoryimages/bogd_item_golden_core_pill.xml",
        image = "bogd_item_golden_core_pill.tex",
    },
    {"CHARACTER","MAGIC"}
)
-- RemoveRecipeFromFilter("bogd_item_golden_core_pill","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 合体丹
--------------------------------------------------------------------------------------------------------------------------------------------

AddRecipeToFilter("bogd_item_body_integration_pill","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "bogd_item_body_integration_pill",            --  --  inst.prefab  实体名字
    { Ingredient("moonglass", 20),Ingredient("greengem", 5),Ingredient("moon_tree_blossom", 20),Ingredient("driftwood_log", 5) }, 
    TECH.CELESTIAL_ONE, --- TECH.NONE
    {
        nounlock = true,
        -- no_deconstruction = false,
        atlas = "images/inventoryimages/bogd_item_body_integration_pill.xml",
        image = "bogd_item_body_integration_pill.tex",
    },
    {"CHARACTER","MAGIC"}
)
-- RemoveRecipeFromFilter("bogd_item_body_integration_pill","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 飞升丹
--------------------------------------------------------------------------------------------------------------------------------------------

AddRecipeToFilter("bogd_item_ascension_pill","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "bogd_item_ascension_pill",            --  --  inst.prefab  实体名字
    { Ingredient("opalpreciousgem", 2),Ingredient("hermit_pearl", 1),Ingredient("purebrilliance", 20),Ingredient("shadowheart", 1) }, 
    TECH.CELESTIAL_THREE, --- TECH.NONE
    {
        nounlock = true,
        -- no_deconstruction = false,
        atlas = "images/inventoryimages/bogd_item_ascension_pill.xml",
        image = "bogd_item_ascension_pill.tex",
    },
    {"CHARACTER","MAGIC"}
)
-- RemoveRecipeFromFilter("bogd_item_ascension_pill","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 蕴.神罚 【神格碎片】20个，活木10个，蓝宝石3个
--------------------------------------------------------------------------------------------------------------------------------------------

AddRecipeToFilter("bogd_treasure_lv_up_divine_punishment","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "bogd_treasure_lv_up_divine_punishment",            --  --  inst.prefab  实体名字
    { Ingredient("bogd_item_shard_of_god", 20),Ingredient("livinglog", 10),Ingredient("bluegem", 3) }, 
    TECH.CELESTIAL_ONE, --- TECH.NONE
    {
        nounlock = true,
        -- no_deconstruction = false,
        atlas = "images/inventoryimages/bogd_treasure_lv_up_divine_punishment.xml",
        image = "bogd_treasure_lv_up_divine_punishment.tex",
    },
    {"CHARACTER","MAGIC"}
)
-- RemoveRecipeFromFilter("bogd_item_body_integration_pill","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 蕴.影鞭，【魔化碎片】20个，触手皮5个，红宝石3个
--------------------------------------------------------------------------------------------------------------------------------------------

AddRecipeToFilter("bogd_treasure_lv_up_shadow_tentacle","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "bogd_treasure_lv_up_shadow_tentacle",            --  --  inst.prefab  实体名字
    { Ingredient("bogd_item_shard_of_demon", 20),Ingredient("tentaclespots", 5),Ingredient("redgem", 3) }, 
    TECH.CELESTIAL_ONE, --- TECH.NONE
    {
        nounlock = true,
        -- no_deconstruction = false,
        atlas = "images/inventoryimages/bogd_treasure_lv_up_shadow_tentacle.xml",
        image = "bogd_treasure_lv_up_shadow_tentacle.tex",
    },
    {"CHARACTER","MAGIC"}
)
-- RemoveRecipeFromFilter("bogd_item_body_integration_pill","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 蕴.护体，【神格碎片】20个，魔化碎片20个，紫宝石1个，龙鳞皮3个
--------------------------------------------------------------------------------------------------------------------------------------------

AddRecipeToFilter("bogd_treasure_lv_up_magic_shield","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "bogd_treasure_lv_up_magic_shield",            --  --  inst.prefab  实体名字
    { Ingredient("bogd_item_shard_of_god", 20),Ingredient("dragon_scales", 3),Ingredient("purplegem", 1) }, 
    TECH.CELESTIAL_ONE, --- TECH.NONE
    {
        nounlock = true,
        -- no_deconstruction = false,
        atlas = "images/inventoryimages/bogd_treasure_lv_up_magic_shield.xml",
        image = "bogd_treasure_lv_up_magic_shield.tex",
    },
    {"CHARACTER","MAGIC"}
)
-- RemoveRecipeFromFilter("bogd_item_body_integration_pill","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 蕴.强化，攻 【神格碎片】20个，魔化碎片20个，红宝石3个，狗牙20个
--------------------------------------------------------------------------------------------------------------------------------------------

AddRecipeToFilter("bogd_treasure_lv_up_damage_enhancement","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "bogd_treasure_lv_up_damage_enhancement",            --  --  inst.prefab  实体名字
    { Ingredient("bogd_item_shard_of_god", 20),Ingredient("bogd_item_shard_of_demon", 20),Ingredient("redgem", 3),Ingredient("houndstooth", 20) }, 
    TECH.CELESTIAL_ONE, --- TECH.NONE
    {
        nounlock = true,
        -- no_deconstruction = false,
        atlas = "images/inventoryimages/bogd_treasure_lv_up_damage_enhancement.xml",
        image = "bogd_treasure_lv_up_damage_enhancement.tex",
    },
    {"CHARACTER","MAGIC"}
)
-- RemoveRecipeFromFilter("bogd_item_body_integration_pill","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 蕴.神宠，【神格碎片】20个，大肉20个，红宝石5个
--------------------------------------------------------------------------------------------------------------------------------------------

AddRecipeToFilter("bogd_treasure_lv_up_pet_summon","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "bogd_treasure_lv_up_pet_summon",            --  --  inst.prefab  实体名字
    { Ingredient("bogd_item_shard_of_god", 20),Ingredient("redgem", 5),Ingredient("meat", 20) }, 
    TECH.CELESTIAL_ONE, --- TECH.NONE
    {
        nounlock = true,
        -- no_deconstruction = false,
        atlas = "images/inventoryimages/bogd_treasure_lv_up_pet_summon.xml",
        image = "bogd_treasure_lv_up_pet_summon.tex",
    },
    {"CHARACTER","MAGIC"}
)
-- RemoveRecipeFromFilter("bogd_item_body_integration_pill","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 蕴.妙手，【神格碎片】20个，火龙果20个，绿宝石3个
--------------------------------------------------------------------------------------------------------------------------------------------

AddRecipeToFilter("bogd_treasure_lv_up_treatment","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "bogd_treasure_lv_up_treatment",            --  --  inst.prefab  实体名字
    { Ingredient("bogd_item_shard_of_god", 20),Ingredient("greengem", 3),Ingredient("dragonfruit", 20) }, 
    TECH.CELESTIAL_ONE, --- TECH.NONE
    {
        nounlock = true,
        -- no_deconstruction = false,
        atlas = "images/inventoryimages/bogd_treasure_lv_up_treatment.xml",
        image = "bogd_treasure_lv_up_treatment.tex",
    },
    {"CHARACTER","MAGIC"}
)
-- RemoveRecipeFromFilter("bogd_item_body_integration_pill","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 蕴.流逝，【魔化碎片】20个，红蘑菇20个，橙宝石3个
--------------------------------------------------------------------------------------------------------------------------------------------

AddRecipeToFilter("bogd_treasure_lv_up_poison_ring","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "bogd_treasure_lv_up_poison_ring",            --  --  inst.prefab  实体名字
    { Ingredient("bogd_item_shard_of_demon", 20),Ingredient("orangegem", 3),Ingredient("red_cap", 20) }, 
    TECH.CELESTIAL_ONE, --- TECH.NONE
    {
        nounlock = true,
        -- no_deconstruction = false,
        atlas = "images/inventoryimages/bogd_treasure_lv_up_poison_ring.xml",
        image = "bogd_treasure_lv_up_poison_ring.tex",
    },
    {"CHARACTER","MAGIC"}
)
-- RemoveRecipeFromFilter("bogd_item_body_integration_pill","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 蕴.天罚，合成材料，【神魔碎片】各20个，月岩20个，月亮碎片10个
--------------------------------------------------------------------------------------------------------------------------------------------

AddRecipeToFilter("bogd_treasure_lv_up_poison_ring","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "bogd_treasure_lv_up_poison_ring",            --  --  inst.prefab  实体名字
    { Ingredient("bogd_item_shard_of_god", 20),Ingredient("bogd_item_shard_of_demon", 20),Ingredient("moonrocknugget", 20),Ingredient("moonglass", 20) }, 
    TECH.CELESTIAL_ONE, --- TECH.NONE
    {
        nounlock = true,
        -- no_deconstruction = false,
        atlas = "images/inventoryimages/bogd_treasure_lv_up_poison_ring.xml",
        image = "bogd_treasure_lv_up_poison_ring.tex",
    },
    {"CHARACTER","MAGIC"}
)
-- RemoveRecipeFromFilter("bogd_item_body_integration_pill","MODS")                       -- -- 在【模组物品】标签里移除这个。
