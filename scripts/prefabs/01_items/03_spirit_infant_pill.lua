----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    元婴丹

            -- ["shadowprotector"] = true,		--- 老麦的小人
            -- ["shadowduelist"] = true,		--- 老麦的小人

                            -- ["shadowdancer"] = true,		--- 老麦的小人
                            -- ["shadowworker"] = true,		--- 老麦的小人

                            -- ["shadowlumber"] = true,		--- 老麦的小人
                            -- ["shadowminer"] = true,			--- 老麦的小人
                            -- ["shadowdigger"] = true,		--- 老麦的小人

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local prefab_name = "bogd_item_spirit_infant_pill"

    local assets = {
        Asset("ANIM", "anim/bogd_item_spirit_infant_pill.zip"), 
        Asset( "IMAGE", "images/inventoryimages/bogd_item_spirit_infant_pill.tex" ),  -- 背包贴图
        Asset( "ATLAS", "images/inventoryimages/bogd_item_spirit_infant_pill.xml" ),
    }
------------------------------------------------------------------------------------------------------
--- 
    ----------------------------------------------------------
    --- 玩家死亡
        local function PlayerIsDead(doer)
            if doer:HasTag("playerghost") or (doer.components.health and doer.components.health:IsDead()) then
                return true
            end
            return false
        end
    ----------------------------------------------------------
    --- 失败密语
        local function fail_whisper(doer)
            doer.components.bogd_com_rpc_event:PushEvent("bogd_event.whisper",{
                m_colour = {255/255,100/255,100/255},
                message = TUNING.BOGD_FN:GetStrings("level","breakthrough_faild") or "突破失败",
                sender_name = "󰀒󰀒󰀒",
                -- icondata = "emoji_abigail",
            })
        end
    ----------------------------------------------------------
    --- 
        local function create_shadow_monster(doer)
            local x,y,z = doer.Transform:GetWorldPosition()
            local npc = SpawnPrefab("shadowprotector")
            npc.Transform:SetPosition(x,y,z)
            npc.linked_player = doer
            npc.fail_whisper = fail_whisper
            npc.PlayerIsDead = PlayerIsDead

            ---------------------------------------------------------------
            --- 使用while强制上buff
                local debuff_name = "bogd_debuff_spirit_infant_pill"
                while true do
                    local debuff = npc:GetDebuff(debuff_name)
                    if debuff then
                        return
                    end
                    npc:AddDebuff(debuff_name,debuff_name)
                end
            ---------------------------------------------------------------


        end
    ----------------------------------------------------------
------------------------------------------------------------------------------------------------------
--- workable setup
    local function workable_setup(inst)
        inst:ListenForEvent("BOGD_OnEntityReplicated.bogd_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                if inst.replica.inventoryitem:IsGrandOwner(doer) then
                    local level = doer.replica.bogd_com_level_sys:Level_Get()
                    local exp_percent = doer.replica.bogd_com_level_sys:Exp_Get_Percent()
                    if level == 39 and exp_percent == 1 then
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
                if not (level == 39 and exp_percent == 1 )then
                    return false
                end

                inst:Remove()        
                create_shadow_monster(doer)
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

    -- inst.AnimState:SetBank("bogd_item_spirit_infant_pill") -- 地上动画
    -- inst.AnimState:SetBuild("bogd_item_spirit_infant_pill") -- 材质包，就是anim里的zip包
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