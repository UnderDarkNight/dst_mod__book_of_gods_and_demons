local assets =
{
    -- Asset("ANIM", "anim/cane.zip"),
    -- Asset("ANIM", "anim/swap_cane.zip"),
}
------------------------------------------------------------------------------------------------------
--- workable setup
    local function workable_setup(inst)
        inst:ListenForEvent("BOGD_OnEntityReplicated.bogd_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                return inst.replica.inventoryitem:IsGrandOwner(doer) or false                
            end)
            replica_com:SetSGAction("give")
            replica_com:SetText("exp_test66","开始修仙")
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("bogd_com_workable")
            inst.components.bogd_com_workable:SetOnWorkFn(function(inst,doer)
                if doer.components.bogd_com_level_sys.enable then
                    return false
                end
                inst.components.stackable:Get():Remove()
                TheNet:SystemMessage("玩家手动开启修仙")
                doer.components.bogd_com_level_sys:SetEnable(true)
                
                doer.components.bogd_com_rpc_event:PushEvent("bogd_com_level_sys_enable")

                return true
            end)
        end
    end
------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hermit_pearl")
    inst.AnimState:SetBuild("hermit_pearl")
    inst.AnimState:PlayAnimation("idle")


    inst.entity:SetPristine()
    --------------------------------------------------
    ---
        workable_setup(inst)
    --------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("moonrockseed")


    MakeHauntableLaunch(inst)

    return inst
end




return Prefab("bogd_other_test_item_start_level", fn)

