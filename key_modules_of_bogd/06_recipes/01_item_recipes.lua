

--------------------------------------------------------------------------------------------------------------------------------------------
---- 金丹
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("bogd_item_golden_core_pill","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "bogd_item_golden_core_pill",            --  --  inst.prefab  实体名字
    { Ingredient("lavae_egg", 1),Ingredient("purplegem", 5),Ingredient("orangegem", 5),Ingredient("moonrocknugget", 10) }, 
    TECH.MAGIC_THREE, --- TECH.天体宝球
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
    TECH.CELESTIAL_ONE, --- TECH.天体宝球
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
    TECH.CELESTIAL_THREE, --- TECH.天体宝球
    {
        nounlock = true,
        -- no_deconstruction = false,
        atlas = "images/inventoryimages/bogd_item_ascension_pill.xml",
        image = "bogd_item_ascension_pill.tex",
    },
    {"CHARACTER","MAGIC"}
)
-- RemoveRecipeFromFilter("bogd_item_ascension_pill","MODS")                       -- -- 在【模组物品】标签里移除这个。
