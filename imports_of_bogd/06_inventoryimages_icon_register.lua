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
		-- "fwd_in_pdt_item_ice_core"	, 							--- 冰核心
	---------------------------------------------------------------------------------------
	-- 01_items
		"bogd_item_foundation_establishment_pill", 							--- 筑基丹
		"bogd_item_golden_core_pill", 										--- 金丹
		"bogd_item_spirit_infant_pill", 									--- 元婴丹
		"bogd_item_soul_formation_pill", 									--- 化神丹
		"bogd_item_soul_formation_pill_not_charged", 						--- 未充能的化神丹
	---------------------------------------------------------------------------------------

}

for k, name in pairs(files_name) do
    table.insert(Assets, Asset( "IMAGE", "images/inventoryimages/".. name ..".tex" ))
    table.insert(Assets, Asset( "ATLAS", "images/inventoryimages/".. name ..".xml" ))
	RegisterInventoryItemAtlas("images/inventoryimages/".. name ..".xml", name .. ".tex")
end


