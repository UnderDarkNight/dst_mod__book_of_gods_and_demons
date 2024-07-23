---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 统一注册 【 images\inventoryimages 】 里的所有图标
--- 每个 xml 里面 只有一个 tex

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if Assets == nil then
    Assets = {}
end

local files_name = {

	---------------------------------------------------------------------------------------
	-- 00_others
		-- "bogd_item_ice_core"	, 							--- 冰核心
	---------------------------------------------------------------------------------------
	-- 01_items
		"bogd_item_foundation_establishment_pill", 							--- 筑基丹
		"bogd_item_golden_core_pill", 										--- 金丹
		"bogd_item_spirit_infant_pill", 									--- 元婴丹
		"bogd_item_soul_formation_pill", 									--- 化神丹
		"bogd_item_soul_formation_pill_not_charged", 						--- 未充能的化神丹
		"bogd_item_body_integration_pill", 									--- 合体丹
		"bogd_item_great_vehicle_pill", 									--- 大乘丹
		"bogd_item_ascension_pill", 										--- 飞升丹
	---------------------------------------------------------------------------------------
	-- 04_treasure
		"bogd_treasure_excample", 									--- 示例灵宝
		"bogd_treasure_divine_punishment",							--- 灵·神罚
		"bogd_treasure_shadow_tentacle",							--- 灵·影鞭
		"bogd_treasure_magic_shield",								--- 灵·护体
		"bogd_treasure_map_blink", 									--- 灵·缩地
		"bogd_treasure_damage_enhancement",							--- 灵·强化
		"bogd_treasure_pet_summon",									--- 灵·神宠
		"bogd_treasure_treatment", 									--- 灵·妙手
		"bogd_treasure_frostfall", 									--- 灵·霜降
		"bogd_treasure_poison_ring",								--- 灵·流逝
		"bogd_treasure_meteorites",									--- 灵·天罚
	---------------------------------------------------------------------------------------
	-- 05_treasure_lv_up
		"bogd_treasure_lv_up_excample", 									--- 示例灵宝升级
	---------------------------------------------------------------------------------------

}

for k, name in pairs(files_name) do
    table.insert(Assets, Asset( "IMAGE", "images/inventoryimages/".. name ..".tex" ))
    table.insert(Assets, Asset( "ATLAS", "images/inventoryimages/".. name ..".xml" ))
	RegisterInventoryItemAtlas("images/inventoryimages/".. name ..".xml", name .. ".tex")
end


