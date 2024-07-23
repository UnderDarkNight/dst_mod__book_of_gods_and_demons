--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/bogd_treasure_lv_up_poison_ring.zip"),

    Asset( "IMAGE", "images/inventoryimages/bogd_treasure_lv_up_poison_ring.tex" ),  -- 物品贴图
    Asset( "ATLAS", "images/inventoryimages/bogd_treasure_lv_up_poison_ring.xml" ),  -- 物品贴图

}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- workable 组件。方便替换掉已有的 灵宝
    local target_prefab = "bogd_treasure_poison_ring"
    local function workable_setup(inst)
        inst:ListenForEvent("BOGD_OnEntityReplicated.bogd_com_workable",function(inst, replica_com)
            replica_com:SetSGAction("dolongaction")
            replica_com:SetText("bogd_treasure_lv_up",STRINGS.ACTIONS.BUNDLE)
            replica_com:SetTestFn(function(inst,doer,right_click)
                if inst.replica.inventoryitem:IsGrandOwner(doer) then
                    local item = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.TREASURE)
                    if item and item.prefab == target_prefab then
                        return true
                    end
                end
                return false
            end)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("bogd_com_workable")
            inst.components.bogd_com_workable:SetOnWorkFn(function(inst,doer)
                local item = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.TREASURE)
                if not item then
                    return
                end
                item.components.bogd_com_treasure:LevelDoDelta(1)
                inst:Remove()
                return true
            end)
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 主函数
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("bogd_treasure_lv_up_poison_ring")
        inst.AnimState:SetBuild("bogd_treasure_lv_up_poison_ring")
        inst.AnimState:PlayAnimation("idle")

        inst.entity:SetPristine()

        ----------------------------------------------------------------------------------------------
        --- 通用交互组件
            workable_setup(inst)
        ----------------------------------------------------------------------------------------------

        if not TheWorld.ismastersim then
            return inst
        end



        ----------------------------------------------------------------------------------------------
        --- 标准物品库
            inst:AddComponent("inspectable")
            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem:SetSinks(true) --- 落水消失
            inst.components.inventoryitem.imagename = "bogd_treasure_lv_up_poison_ring"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/bogd_treasure_lv_up_poison_ring.xml"
        ----------------------------------------------------------------------------------------------
        --- 
        ----------------------------------------------------------------------------------------------
        MakeHauntableLaunch(inst)

        return inst
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("bogd_treasure_lv_up_poison_ring", fn, assets)
