----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    神之血

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local prefab_name = "bogd_item_blood_of_god"

    local assets = {
        Asset("ANIM", "anim/bogd_item_blood_of_god.zip"), 
        Asset( "IMAGE", "images/inventoryimages/bogd_item_blood_of_god.tex" ),  -- 背包贴图
        Asset( "ATLAS", "images/inventoryimages/bogd_item_blood_of_god.xml" ),
    }
------------------------------------------------------------------------------------------------------
--- workable setup
    local function workable_setup(inst)
        inst:ListenForEvent("BOGD_OnEntityReplicated.bogd_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                if inst.replica.inventoryitem:IsGrandOwner(doer) then
                    return true
                end
                return false            
            end)
            replica_com:SetSGAction("bogd_special_eat")
            replica_com:SetText(prefab_name,STRINGS.ACTIONS.EAT)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("bogd_com_workable")
            inst.components.bogd_com_workable:SetOnWorkFn(function(inst,doer)
                inst.components.stackable:Get():Remove()
                if doer.components.hunger then
                    doer.components.hunger:DoDelta(0)
                end
                if doer.components.sanity then
                    doer.components.sanity:DoDelta(30)
                end
                if doer.components.health then
                    doer.components.health:DoDelta(0)
                end
                return true
            end)
        end
    end
------------------------------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    -- inst.AnimState:SetBank("bogd_item_blood_of_god") -- 地上动画
    -- inst.AnimState:SetBuild("bogd_item_blood_of_god") -- 材质包，就是anim里的zip包
    -- inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画
    inst.AnimState:SetBank(prefab_name) -- 地上动画
    inst.AnimState:SetBuild(prefab_name) -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画

    MakeInventoryFloatable(inst)

    workable_setup(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = prefab_name
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..prefab_name..".xml"

    --------------------------------------------------------------------------
    -- 叠堆
        inst:AddComponent("stackable")
        inst.components.stackable:SetStackSize(TUNING.STACK_SIZE_TINYITEM)
    --------------------------------------------------------------------------
    -- 可烧毁
        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    --------------------------------------------------------------------------

    MakeHauntableLaunch(inst)
    --------------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                inst.AnimState:Hide("SHADOW")
            else                                
                inst.AnimState:Show("SHADOW")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    --------------------------------------------------------------------------
    
    return inst
end

return Prefab(prefab_name, fn, assets)