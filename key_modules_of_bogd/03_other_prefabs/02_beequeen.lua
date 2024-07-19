--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

   蜂后掉落，掉落率2%  元婴丹

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit(
    "beequeen",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end


        if inst.components.lootdropper then

            local old_DropLoot = inst.components.lootdropper.DropLoot
            inst.components.lootdropper.DropLoot = function(self,...)
                if TUNING.BOGD_DEBUGGING_MODE or math.random(10000)/10000 <= 0.02 then
                    self:SpawnLootPrefab("bogd_item_spirit_infant_pill")
                end                
                return old_DropLoot(self,...)
            end
            
        end

    end)