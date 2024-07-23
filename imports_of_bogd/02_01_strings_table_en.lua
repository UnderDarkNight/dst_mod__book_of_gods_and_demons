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

            ["神"] = "GOD",
            ["魔"] = "DEMON",
            ["人"] = "HUMAN",

            ["需要突破"] = "Require A Breakthrough",
        },
        ["level"] = {
            ["level_up_succeed"] = "Player's cultivation realm advancement",
            ["breakthrough_succeed"] = "Breakthrough Succeed",
            ["breakthrough_faild"] = "Breakthrough Failed",
            ["ms_playerreroll"] = "Character change, resulting in a drop in cultivation realm.",

        },
    --------------------------------------------------------------------
    --- 01_items
        ["bogd_item_foundation_establishment_pill"] = {
            ["name"] = "Foundation Establishment Pill",
            ["inspect_str"] = "Used for breaking through from the Prenatal Stage to the Foundation Establishment Stage.",
            ["recipe_desc"] = "Used for breaking through from the Prenatal Stage to the Foundation Establishment Stage.",
        },
        ["bogd_item_golden_core_pill"] = {
            ["name"] = "Golden Core Pill",
            ["inspect_str"] = "Used for breaking through from the Foundation Establishment Stage to the Golden Core Stage.",
            ["recipe_desc"] = "Used for breaking through from the Foundation Establishment Stage to the Golden Core Stage.",
        },
        ["bogd_item_spirit_infant_pill"] = {
            ["name"] = "Spirit Infant Pill",
            ["inspect_str"] = "Used for breaking through from the Golden Core Stage to the Spirit Infant Stage.",
            ["recipe_desc"] = "Used for breaking through from the Golden Core Stage to the Spirit Infant Stage.",
            ["shadow_fail_by_other_hit"] = "The inner demon can only be overcome by oneself; help from others leads to instant failure.",
            ["shadow_task_timeout"] = "The inner demon dissipates after lingering for too long.",
            ["shadow_task_faild"] = "You failed to conquer the inner demon.",
            ["shadow_task_succeed"] = "You successfully overcame the inner demon.",
        },
        ["bogd_item_soul_formation_pill"] = {
            ["name"] = "Soul Formation Pill",
            ["inspect_str"] = "Used for breaking through from the Spirit Infant Stage to the Soul Formation Stage.",
            ["recipe_desc"] = "Used for breaking through from the Spirit Infant Stage to the Soul Formation Stage.",
        },
        ["bogd_item_soul_formation_pill_not_charged"] = {
            ["name"] = "Uncharged Soul Formation Pill",
            ["inspect_str"] = "Requires using "..STRINGS.NAMES.MOONGLASS_CHARGED,
            ["recipe_desc"] = "Requires using "..STRINGS.NAMES.MOONGLASS_CHARGED,
        },
        ["bogd_item_body_integration_pill"] = {
            ["name"] = "Body Integration Pill",
            ["inspect_str"] = "Used for breaking through from the Soul Formation Stage to the Body Integration Stage.",
            ["recipe_desc"] = "Used for breaking through from the Soul Formation Stage to the Body Integration Stage.",
        },
        ["bogd_item_body_integration_pill_building"] = {
            ["name"] = "Promotion Stamp",
            ["inspect_str"] = "Used for breaking through from the Soul Formation Stage to the Body Integration Stage.",
            ["recipe_desc"] = "Used for breaking through from the Soul Formation Stage to the Body Integration Stage.",
            ["wrong_building"] = "This is not your Stamp",
            ["wrong_level"] = "The cultivation realm has not been reached to use the Stamp",
        },
        ["bogd_item_great_vehicle_pill"] = {
            ["name"] = "Great Vehicle Pill",
            ["inspect_str"] = "Used for breaking through from the Body Integration Stage to the Great Vehicle Stage.",
            ["recipe_desc"] = "Used for breaking through from the Body Integration Stage to the Great Vehicle Stage.",
        },
        ["bogd_item_ascension_pill"] = {
            ["name"] = "Ascension Pill",
            ["inspect_str"] = "Used upon the completion of the Great Vehicle Stage for Ascension.",
            ["recipe_desc"] = "Used upon the completion of the Great Vehicle Stage for Ascension.",
            ["faild"] = "The world does not permit ascension.",
        },
        ["bogd_item_shard_of_god"] = {
            ["name"] = "Shard of God",
            ["inspect_str"] = "Shard of God",
            ["recipe_desc"] = "Shard of God",
        },
        ["bogd_item_shard_of_demon"] = {
            ["name"] = "Shard of Demon",
            ["inspect_str"] = "Shard of Demon",
            ["recipe_desc"] = "Shard of Demon",
        },
        ["bogd_item_blood_of_god"] = {
            ["name"] = "Blood of God",
            ["inspect_str"] = "Blood of God",
            ["recipe_desc"] = "Blood of God",
        },
        ["bogd_item_blood_of_demon"] = {
            ["name"] = "Blood of Demon",
            ["inspect_str"] = "Blood of Demon",
            ["recipe_desc"] = "Blood of Demon",
        },
        ["bogd_item_ephemeral_life_stone"] = {
            ["name"] = "Ephemeral Life Stone",
            ["inspect_str"] = "Having chronicled the sorrows of my past, I exist in a state beyond human or beast! A dream, fleeting and ephemeral, is this life ~",
            ["recipe_desc"] = "Ephemeral Life Stone",
        },
    --------------------------------------------------------------------
    --- 04_treasure
        ["bogd_treasure_excample"] = {
            ["name"] = "示例灵宝",
            ["inspect_str"] = "示例灵宝",
            ["recipe_desc"] = "示例灵宝",
        },
        ["bogd_treasure_divine_punishment"] = {
            ["name"] = "Spirit Divine Punishment",
            ["inspect_str"] = "Summons lightning, cannot be used by demons.",
        },
        
        ["bogd_treasure_shadow_tentacle"] = {
            ["name"] = "Spirit Shadow Whip",
            ["inspect_str"] = "Summons tentacles, cannot be used by gods.",
        },
        
        ["bogd_treasure_magic_shield"] = {
            ["name"] = "Spirit Protective Shield",
            ["inspect_str"] = "Casts a protective shield around oneself.",
        },
        
        ["bogd_treasure_map_blink"] = {
            ["name"] = "Spirit Ground Shrinking",
            ["inspect_str"] = "Teleports to a designated location on the map.",
        },
        
        ["bogd_treasure_damage_enhancement"] = {
            ["name"] = "Spirit Enhancement",
            ["inspect_str"] = "Increases one's own attack power.",
        },
        
        ["bogd_treasure_pet_summon"] = {
            ["name"] = "Spirit Divine Pet",
            ["inspect_str"] = "Summons a pet, cannot be used by demons.",
        },
        
        ["bogd_treasure_treatment"] = {
            ["name"] = "Spirit Healing Touch",
            ["inspect_str"] = "Restores health and spirit, cannot be used by demons.",
        },
        
        ["bogd_treasure_frostfall"] = {
            ["name"] = "Spirit Frostfall",
            ["inspect_str"] = "Freezes monsters within range.",
        },
        
        ["bogd_treasure_poison_ring"] = {
            ["name"] = "Spirit Flowing Away",
            ["inspect_str"] = "Creates a poisonous circle.",
        },
        
        ["bogd_treasure_meteorites"] = {
            ["name"] = "Spirit Heavenly Punishment",
            ["inspect_str"] = "Summons meteors.",
        },
    --------------------------------------------------------------------
    -- 05_treasure_lv_up
        ["bogd_treasure_lv_up_excample"] = {
            ["name"] = "Essence Example",
            ["inspect_str"] = "General Spirit Treasure upgrade item",
            ["recipe_desc"] = "General Spirit Treasure upgrade item",
        },
        ["bogd_treasure_lv_up_divine_punishment"] = {
            ["name"] = "Essence of Divine Punishment",
            ["inspect_str"] = "Upgrades the Spirit Divine Punishment , Only usable after becoming God.",
            ["recipe_desc"] = "Upgrades the Spirit Divine Punishment , Only usable after becoming God.",
        },
        ["bogd_treasure_lv_up_shadow_tentacle"] = {
            ["name"] = "Essence of Shadow Tentacle",
            ["inspect_str"] = "Upgrades the Spirit Shadow Whip , Only usable after becoming Demon.",
            ["recipe_desc"] = "Upgrades the Spirit Shadow Whip , Only usable after becoming Demon.",
        },
        ["bogd_treasure_lv_up_magic_shield"] = {
            ["name"] = "Essence of Magic Shield",
            ["inspect_str"] = "Upgrades the Spirit Protective Shield , Only usable after becoming God or Demon.",
            ["recipe_desc"] = "Upgrades the Spirit Protective Shield , Only usable after becoming God or Demon.",
        },
        ["bogd_treasure_lv_up_damage_enhancement"] = {
            ["name"] = "Essence of Damage Enhancement",
            ["inspect_str"] = "Upgrades the Spirit Enhancement , Only usable after becoming God or Demon.",
            ["recipe_desc"] = "Upgrades the Spirit Enhancement , Only usable after becoming God or Demon.",
        },
        ["bogd_treasure_lv_up_pet_summon"] = {
            ["name"] = "Essence of Pet Summoning",
            ["inspect_str"] = "Upgrades the Spirit Divine Pet , Only usable after becoming God.",
            ["recipe_desc"] = "Upgrades the Spirit Divine Pet , Only usable after becoming God.",
        },
        ["bogd_treasure_lv_up_treatment"] = {
            ["name"] = "Essence of Treatment",
            ["inspect_str"] = "Upgrades the Spirit Healing Touch , Only usable after becoming God.",
            ["recipe_desc"] = "Upgrades the Spirit Healing Touch , ,Only usable after becoming God.",
        },
        ["bogd_treasure_lv_up_poison_ring"] = {
            ["name"] = "Essence of Poison Ring",
            ["inspect_str"] = "Upgrades the Spirit Flowing Away , Only usable after becoming God.",
            ["recipe_desc"] = "Upgrades the Spirit Flowing Away , Only usable after becoming God.",
        },
        ["bogd_treasure_lv_up_meteorites"] = {
            ["name"] = "Essence of Meteorites",
            ["inspect_str"] = "Upgrades the Spirit Heavenly Punishment , Only usable after becoming God or Demon.",
            ["recipe_desc"] = "Upgrades the Spirit Heavenly Punishment , Only usable after becoming God or Demon.",
        },
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