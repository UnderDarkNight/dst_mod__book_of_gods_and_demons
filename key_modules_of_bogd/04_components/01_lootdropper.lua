--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    物品掉落组件

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddComponentPostInit("lootdropper", function(self)

    local old_DropLoot = self.DropLoot
    self.DropLoot = function(self,pt,...)
        return old_DropLoot(self,pt,...)
    end
end)