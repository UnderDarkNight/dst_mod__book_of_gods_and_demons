----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    未充能的化神丹

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local prefab_name = "bogd_item_soul_formation_pill_not_charged"

    local assets = {
        Asset("ANIM", "anim/bogd_item_soul_formation_pill_not_charged.zip"), 
        Asset( "IMAGE", "images/inventoryimages/bogd_item_soul_formation_pill_not_charged.tex" ),  -- 背包贴图
        Asset( "ATLAS", "images/inventoryimages/bogd_item_soul_formation_pill_not_charged.xml" ),
    }
------------------------------------------------------------------------------------------------------
--- 物品接受
    local function acceptable_setup(inst)
        inst:ListenForEvent("BOGD_OnEntityReplicated.bogd_com_acceptable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,item,doer,right_click)
                if inst.replica.inventoryitem:IsGrandOwner(doer) then
                    if item and item.prefab == "moonglass_charged" then
                        return true
                    end
                end
                return false
            end)
            replica_com:SetSGAction("dolongaction")
            replica_com:SetText(prefab_name,STRINGS.ACTIONS.CHARGE_FROM)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("bogd_com_acceptable")
            inst.components.bogd_com_acceptable:SetOnAcceptFn(function(inst,item,doer)

                item.components.stackable:Get():Remove()
                inst.components.finiteuses:Use(-(100/20))

                if inst.components.finiteuses:GetPercent() >= 1 then
                    inst:Remove()
                    doer.components.inventory:GiveItem(SpawnPrefab("bogd_item_soul_formation_pill"))
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

    -- inst.AnimState:SetBank("bogd_item_soul_formation_pill_not_charged") -- 地上动画
    -- inst.AnimState:SetBuild("bogd_item_soul_formation_pill_not_charged") -- 材质包，就是anim里的zip包
    -- inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画
    inst.AnimState:SetBank(prefab_name) -- 地上动画
    inst.AnimState:SetBuild(prefab_name) -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画

    MakeInventoryFloatable(inst)


    inst.entity:SetPristine()
    acceptable_setup(inst)
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
    -- 可烧毁
        inst:AddComponent("bogd_data")
    --------------------------------------------------------------------------
    -- 可烧毁
        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    --------------------------------------------------------------------------
    --- 能量
        inst:AddComponent("finiteuses")
        -- inst.components.finiteuses:SetPercent(0)
        inst:DoTaskInTime(0,function()
            if not inst.components.bogd_data:Get("inited") then
                -- inst.components.finiteuses:SetUses(0)
                inst.components.finiteuses:SetPercent(0)
                inst.components.bogd_data:Set("inited",true)
            end
        end)
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