----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local prefab_name = "bogd_item_foundation_establishment_pill"

    local assets = {
        Asset("ANIM", "anim/bogd_item_foundation_establishment_pill.zip"), 
        Asset( "IMAGE", "images/inventoryimages/bogd_item_foundation_establishment_pill.tex" ),  -- 背包贴图
        Asset( "ATLAS", "images/inventoryimages/bogd_item_foundation_establishment_pill.xml" ),
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
                    if level == 19 and exp_percent == 1 then
                        return true
                    end
                end
                return false            
            end)
            replica_com:SetSGAction("bogd_special_eat")
            replica_com:SetText(prefab_name,STRINGS.ACTIONS.EAT)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("bogd_com_workable")
            inst.components.bogd_com_workable:SetOnWorkFn(function(inst,doer)
                local level = doer.replica.bogd_com_level_sys:Level_Get()
                local exp_percent = doer.replica.bogd_com_level_sys:Exp_Get_Percent()
                if not (level == 19 and exp_percent == 1 )then
                    return false
                end

                if doer[inst.prefab] then   --- 已经有任务了
                    return false
                end

                inst:Remove()

                doer[inst.prefab] = {}
                ----------------------------------------------------------
                --- -- 取消所有任务
                    local function Cancel_All_Tasks(doer) 
                        for i, temp_task in ipairs(doer[inst.prefab]) do
                            temp_task:Cancel()                        
                        end
                        doer[inst.prefab] = nil
                        doer.components.bogd_com_level_sys:SetLevelUpBreaking(false) -- 恢复回血
                        doer.components.bogd_com_rpc_event:PushEvent("bogd_event.level_strom",{trun_on = false}) -- 关闭特效
                    end
                ----------------------------------------------------------
                --- 
                    local function fail_whisper(doer)
                        doer.components.bogd_com_rpc_event:PushEvent("bogd_event.whisper",{
                            m_colour = {255/255,100/255,100/255},
                            message = TUNING.BOGD_FN:GetStrings("level","breakthrough_faild") or "突破失败",
                            sender_name = "󰀒󰀒󰀒",
                            -- icondata = "emoji_abigail",
                        })
                    end
                ----------------------------------------------------------
                --- 开始执行渡劫 对玩家进行16次闪电攻击，一道闪电攻击20点真伤，间隔2秒
                    doer.components.bogd_com_level_sys:SetLevelUpBreaking(true) -- 期间不允许回血
                    doer:DoTaskInTime(1,function()
                        doer.components.bogd_com_rpc_event:PushEvent("bogd_event.level_strom",{trun_on = true,color = {1,0,0,1},}) --- 风暴特效                        
                    end)

                    for i = 1, 17, 1 do -- 创建系列任务
                        local task = doer:DoTaskInTime(i*2, function(doer)
                            if i <= 16 then -- 前面16次造成伤害
                                if doer:HasTag("playerghost") or (doer.components.health and doer.components.health:IsDead()) then                            
                                    Cancel_All_Tasks(doer)                                    
                                    fail_whisper(doer)
                                    return
                                end      
                                thunder_with_dmg(doer,20)
                                if i == 16 then
                                    doer:DoTaskInTime(0.5,function()
                                        doer.components.bogd_com_rpc_event:PushEvent("bogd_event.level_strom",{trun_on = false}) -- 关闭特效
                                    end)
                                end
                            else
                                Cancel_All_Tasks(doer)
                                if doer:HasTag("playerghost") or (doer.components.health and doer.components.health:IsDead()) then
                                    fail_whisper(doer)                                    
                                else
                                    doer.components.bogd_com_level_sys:Level_Up_With_Lock_Break()
                                end
                            end
                        end)
                        table.insert(doer[inst.prefab],task)
                    end
                ----------------------------------------------------------
                -- thunder_with_dmg(doer,20)



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

    -- inst.AnimState:SetBank("bogd_item_foundation_establishment_pill") -- 地上动画
    -- inst.AnimState:SetBuild("bogd_item_foundation_establishment_pill") -- 材质包，就是anim里的zip包
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