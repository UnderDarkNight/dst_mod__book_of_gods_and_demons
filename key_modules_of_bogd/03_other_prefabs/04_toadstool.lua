--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

   蟾蜍，掉落率5%  化神丹

   悲惨的蟾蜍 100%掉落 化神丹

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit(
    "toadstool",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end


        if inst.components.lootdropper then

            local old_DropLoot = inst.components.lootdropper.DropLoot
            inst.components.lootdropper.DropLoot = function(self,...)
                if TUNING.BOGD_DEBUGGING_MODE or math.random(10000)/10000 <= 5/100 then
                    self:SpawnLootPrefab("bogd_item_soul_formation_pill_not_charged")
                end                
                return old_DropLoot(self,...)
            end
            
        end

    end)
AddPrefabPostInit(
    "toadstool_dark",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end


        if inst.components.lootdropper then

            local old_DropLoot = inst.components.lootdropper.DropLoot
            inst.components.lootdropper.DropLoot = function(self,...)
                if TUNING.BOGD_DEBUGGING_MODE or math.random(10000)/10000 <= 1 then
                    self:SpawnLootPrefab("bogd_item_soul_formation_pill_not_charged")
                end                
                return old_DropLoot(self,...)
            end
            
        end

    end)