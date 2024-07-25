--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    蜘蛛女王掉落掉落率10%  筑基丹

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit(
    "spiderqueen",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end


        if inst.components.lootdropper then

            local old_DropLoot = inst.components.lootdropper.DropLoot
            inst.components.lootdropper.DropLoot = function(self,...)
                if TUNING.BOGD_DEBUGGING_MODE or math.random(10000)/10000 <= 10/100 then
                    self:SpawnLootPrefab("bogd_item_foundation_establishment_pill")
                end                
                return old_DropLoot(self,...)
            end
            
        end

    end)