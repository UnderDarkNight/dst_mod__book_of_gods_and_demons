----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    飞升丹

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local prefab_name = "bogd_item_ascension_pill"

    local assets = {
        Asset("ANIM", "anim/bogd_item_ascension_pill.zip"), 
        Asset( "IMAGE", "images/inventoryimages/bogd_item_ascension_pill.tex" ),  -- 背包贴图
        Asset( "ATLAS", "images/inventoryimages/bogd_item_ascension_pill.xml" ),
    }
------------------------------------------------------------------------------------------------------
--- 闪电击中
    local function thunder_with_dmg(doer,dmg)
        local lightning_fx = SpawnPrefab("lightning")
        lightning_fx.Transform:SetPosition(doer.Transform:GetWorldPosition())
        doer:DoTaskInTime(0.1,function()
            if doer and doer.sg and doer.sg.GoToState then
                doer.sg:GoToState("electrocute")
            end
            if doer.components.health then
                doer.components.health:DoDelta(-dmg,nil,"lightning")
            end
        end)
    end
------------------------------------------------------------------------------------------------------
--- workable setup
    local function workable_setup(inst)
        inst:ListenForEvent("BOGD_OnEntityReplicated.bogd_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                if inst.replica.inventoryitem:IsGrandOwner(doer) then
                    local level = doer.replica.bogd_com_level_sys:Level_Get()
                    local exp_percent = doer.replica.bogd_com_level_sys:Exp_Get_Percent()
                    if level == 79 and exp_percent == 1 then
                        return true
                    end
                end
                return false            
            end)
            replica_com:SetSGAction("give")
            replica_com:SetText(prefab_name,STRINGS.ACTIONS.EAT)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("bogd_com_workable")
            inst.components.bogd_com_workable:SetOnWorkFn(function(inst,doer)
                local level = doer.replica.bogd_com_level_sys:Level_Get()
                local exp_percent = doer.replica.bogd_com_level_sys:Exp_Get_Percent()
                if not (level == 79 and exp_percent == 1 )then
                    return false
                end

                -- doer:DoTaskInTime(0.1,function()
                --     if doer.components.talker then
                --         doer.components.talker:Say(TUNING.BOGD_FN:GetStrings(inst.prefab,"faild"))
                --     end
                -- end)
                if doer.components.combat then
                    local task = doer:DoPeriodicTask(0.3,function()
                        doer.components.combat:GetAttacked(inst,10000)
                    end)
                    doer.bogd_item_ascension_pill_player_death_event = function()
                        task:Cancel()
                        doer:RemoveEventCallback("death",doer.bogd_item_ascension_pill_player_death_event)
                        doer.bogd_item_ascension_pill_player_death_event = nil
                    end
                    doer:ListenForEvent("death",doer.bogd_item_ascension_pill_player_death_event)
                end
                doer:PushEvent("bogd_level_breakthrough_strings_display","ascension")
                inst:Remove()
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

    -- inst.AnimState:SetBank("bogd_item_ascension_pill") -- 地上动画
    -- inst.AnimState:SetBuild("bogd_item_ascension_pill") -- 材质包，就是anim里的zip包
    -- inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画
    inst.AnimState:SetBank(prefab_name) -- 地上动画
    inst.AnimState:SetBuild(prefab_name) -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画

    MakeInventoryFloatable(inst)


    inst.entity:SetPristine()
    workable_setup(inst)
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