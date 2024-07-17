local assets =
{
    Asset("ANIM", "anim/cane.zip"),
    Asset("ANIM", "anim/swap_cane.zip"),
}
------------------------------------------------------------------------------------------------------
--- workable setup
    local function workable_setup(inst)
        inst:ListenForEvent("BOGD_OnEntityReplicated.bogd_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                return inst.replica.inventoryitem:IsGrandOwner(doer) or false                
            end)
            replica_com:SetSGAction("give")
            replica_com:SetText("exp_test","吸收经验")
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("bogd_com_workable")
            inst.components.bogd_com_workable:SetOnWorkFn(function(inst,doer)
                if not doer.replica.bogd_com_level_sys:GetLevelUpLock() then
                    return false
                end
                inst.components.stackable:Get():Remove()
                doer.components.bogd_com_level_sys:Level_Up_With_Lock_Break(true)
                TheNet:SystemMessage("强制突破")
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
    inst.components.inventoryitem:ChangeImageName("halloweenpotion_health_large")


    MakeHauntableLaunch(inst)

    return inst
end




return Prefab("bogd_other_force_level_up", fn)

