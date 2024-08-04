--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    灵宝绑定器，给某些意外状况 被弄脱落的灵宝绑定回来

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPlayerPostInit(function(inst)

    if not TheWorld.ismastersim then
        return
    end

    -- inst:ListenForEvent("dropitem",function(inst,_table)
    --     _table = _table or {}
    --     local item = _table.item
    --     print("++++dropitem",item)
    --     if item and item:HasTag("bogd_treasure") then
            
    --         inst:DoTaskInTime(0,function()
    --             if item:IsValid() then
    --                 inst.components.inventory:Equip(item)
    --             end
    --         end)

    --     end
    -- end)
    if inst.components.inventory then
        local old_DropItem = inst.components.inventory.DropItem
        inst.components.inventory.DropItem = function(self,item,...)
            if item and item:HasTag("bogd_treasure") then
                return
            end
            return old_DropItem(self,item,...)
        end
    end

end)