--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    两种树精掉落掉落率10%  筑基丹

    leif
    leif_sparse

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function upgrade_fn(inst)
    if not TheWorld.ismastersim then
        return
    end
    if inst.components.lootdropper then

        local old_DropLoot = inst.components.lootdropper.DropLoot
        inst.components.lootdropper.DropLoot = function(self,...)
            if TUNING.BOGD_DEBUGGING_MODE or math.random(10000)/10000 <= (TUNING.BOGD_CONFIG.PILL_DROP_RATE or 10/100) then
                self:SpawnLootPrefab("bogd_item_foundation_establishment_pill")
            end                
            return old_DropLoot(self,...)
        end
        
    end
end
local boss_prefab = {"leif","leif_sparse"}

for k, temp_prefab in pairs(boss_prefab) do
    AddPrefabPostInit(temp_prefab,upgrade_fn)
end
