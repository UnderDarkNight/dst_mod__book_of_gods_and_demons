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
                if not doer.components.bogd_com_level_sys.enable then
                    return false
                end
                inst.components.stackable:Get():Remove()
                doer.components.bogd_com_level_sys:Exp_DoDelta(inst.exp or 1)
                return true
            end)
        end
    end
------------------------------------------------------------------------------------------------------

local function common()
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
    inst.components.inventoryitem:ChangeImageName("hermit_pearl")


    MakeHauntableLaunch(inst)

    return inst
end


-- local exp_fn_50 = function()
--     local inst = common()
--     inst.exp = 50
--     return inst
-- end

local exps = {50,100,200,300,400,500,600,700,800,900,1000,5000,10000,15000, 20000,25000,30000,35000,40000,45000,50000,55000,60000,65000,70000,75000,80000,85000,90000,95000,100000}

local ret_prefabs = {}

for k, num in pairs(exps) do
    local exp_fn = function()
        local inst = common()
        inst.exp = num        
        return inst
    end

    table.insert(ret_prefabs, Prefab("bogd_other_exp_"..num, exp_fn))
end


-- return Prefab("bogd_other_exp_50", exp_fn_50)
return unpack(ret_prefabs)

