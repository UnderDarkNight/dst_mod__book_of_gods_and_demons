--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/bogd_treasure_poison_ring.zip"),

    Asset( "IMAGE", "images/inventoryimages/bogd_treasure_poison_ring.tex" ),  -- 物品贴图
    Asset( "ATLAS", "images/inventoryimages/bogd_treasure_poison_ring.xml" ),  -- 物品贴图

    Asset( "IMAGE", "images/treasure/bogd_treasure_poison_ring.tex" ),         -- UI贴图
    Asset( "ATLAS", "images/treasure/bogd_treasure_poison_ring.xml" ),         -- UI贴图


}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- equippable 组件
    local function equippable_setup(inst)
        local function hook_IsRestricted(com)
            com.IsRestricted = function(self,player)    --- 是否被屏蔽，return false 才能穿戴
                --- client/server 统一在这里
                if not player.replica.bogd_com_level_sys:CheckCanEquipSpecialItem() then -- 没有开启修仙
                    return true
                end
                if player.replica.bogd_com_level_sys:IsGod() then -- 神 不能用
                    return true
                end
                return false
            end
        end
        local function death_event_in_player() -- 指定状态的玩家死后丟失
            local owner = inst.components.bogd_com_treasure.owner
            if owner.components.bogd_com_level_sys:IsHuman() then
                inst:Remove()
            end
        end
        inst:ListenForEvent("BOGD_OnEntityReplicated.equippable", function(inst, replica_com)
            -- replica_com.IsRestricted = function(self,player) end
            hook_IsRestricted(replica_com)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("equippable")
            -- inst.components.equippable.IsRestricted = function(self,player)  end
            hook_IsRestricted(inst.components.equippable)
            inst.components.equippable:SetOnEquip(function(inst, owner)
                inst:DoTaskInTime(0,function()
                    inst.components.bogd_com_treasure:OnEquipped(owner)
                    inst:ListenForEvent("death", death_event_in_player,owner)
                end)
            end)
            inst.components.equippable:SetOnUnequip(function(inst, owner) --- 加载的时候会执行一次 SetOnEquip 再 SetOnUnequip，会造成崩溃
                inst:DoTaskInTime(0,function()
                    inst.components.bogd_com_treasure:OnUnequipped(owner)
                    inst:Remove()  --- 脱下即消失
                    inst:RemoveEventCallback("death", death_event_in_player,owner)
                end)
            end)
            inst.components.equippable.equipslot = EQUIPSLOTS.TREASURE
            inst.components.equippable:SetPreventUnequipping(true)  --- 避免被脱下
        end
        ----------------------------------------------------------------------
        --- 玩家切换神魔状态
            inst:ListenForEvent("player_become_demon",inst.Remove)
        ----------------------------------------------------------------------
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- bogd_com_treasure 组件
    local function bogd_com_treasure_setup(inst)
        inst:ListenForEvent("BOGD_OnEntityReplicated.bogd_com_treasure",function(inst, replica_com)
        end)
        ------------------------------------------------------
        --- 指示圈圈
            inst:ListenForEvent("treasure_hud_created",function(inst,HUD)
                if not HUD then
                    return
                end
                if HUD.dotted_circle == nil and TUNING.BOGD_CONFIG.TREASURE_INDICATOR then
                    HUD.dotted_circle = SpawnPrefab("bogd_sfx_dotted_circle_client")
                    HUD.dotted_circle:PushEvent("Set",{
                        range = 4
                    })
                    HUD.inst:ListenForEvent("onremove",function()
                        HUD.dotted_circle:Remove()                            
                    end)
                    HUD.dotted_circle:DoPeriodicTask(FRAMES,function()
                        if inst.replica.bogd_com_treasure:Is_CD_Started() then
                            HUD.dotted_circle:Hide()
                        else
                            HUD.dotted_circle:Show()
                            local pt = TheInput:GetWorldPosition()
                            HUD.dotted_circle.Transform:SetPosition(pt.x,0,pt.z)
                        end
                    end)
                end
            end)
        ------------------------------------------------------

        if TheWorld.ismastersim then

            inst:AddComponent("bogd_com_treasure")
            inst.components.bogd_com_treasure:SetCDTime(5)     -- CD 时间
            inst.components.bogd_com_treasure:SetIcon("images/treasure/bogd_treasure_poison_ring.xml","bogd_treasure_poison_ring.tex") -- 图标贴图
            inst.components.bogd_com_treasure:SetSpellFn(function(inst,doer,pt)  -- 技能执行
                ------------------------------------------------------------------------------------------------------------
                --
                    if doer.components.hunger then                        
                        if doer.components.hunger.current < 20 then
                            doer.components.bogd_com_rpc_event:PushEvent("bogd_event.whisper",{
                                message = TUNING.BOGD_FN:GetStrings(inst.prefab,"spell_cost_fail"),
                            })
                            return
                        else
                            doer.components.hunger:DoDelta(-20)
                        end
                    end
                ------------------------------------------------------------------------------------------------------------
                ---
                    local level = inst.components.bogd_com_treasure:GetLevel()
                    local damage = 10 + level   -- 伤害

                    local fx = SpawnPrefab("sporecloud")
                    fx.Transform:SetPosition(pt.x,0,pt.z)
                    fx.components.combat:SetDefaultDamage(damage) -- 伤害
                    ------------------------------------------------------
                    --- 玩家不受到伤害
                        local old_IsValidTarget = fx.components.combat.IsValidTarget
                        fx.components.combat.IsValidTarget = function(self,target,...)
                            if target and target:HasTag("player") then
                                return false
                            end
                            return old_IsValidTarget(self,target,...)
                        end
                    ------------------------------------------------------
                    fx:DoTaskInTime(10,function()
                        fx:FinishImmediately()
                    end)
                ------------------------------------------------------------------------------------------------------------
                ---
                    if not TUNING.BOGD_DEBUGGING_MODE then
                        inst.components.bogd_com_treasure:SetCDStart()
                    end
                ------------------------------------------------------------------------------------------------------------
            end)

        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- workable 组件。方便替换掉已有的 灵宝
    local function workable_setup(inst)
        inst:ListenForEvent("BOGD_OnEntityReplicated.bogd_com_workable",function(inst, replica_com)
            replica_com:SetSGAction("give")
            replica_com:SetText("bogd_treasure",STRINGS.ACTIONS.EQUIP)
            replica_com:SetTestFn(function(inst,doer,right_click)
                if inst.replica.equippable:IsRestricted(doer) then
                    return false
                end
                if inst.replica.inventoryitem:IsGrandOwner(doer) then
                    local item = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.TREASURE)
                    if item then
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
                if item then
                    item:Remove()
                end
                doer.components.inventory:Equip(inst)
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

        inst.AnimState:SetBank("bogd_treasure_poison_ring")
        inst.AnimState:SetBuild("bogd_treasure_poison_ring")
        inst.AnimState:PlayAnimation("idle")

        inst:AddTag("bogd_treasure")  -- 用于快捷键标记识别

        inst.entity:SetPristine()
        ----------------------------------------------------------------------------------------------
        -- 显示文本颜色
            inst.level_str_color = {0/255,255/255,0/255,255/255}
            inst.level_str_offset = Vector3(0,0,0)
        ----------------------------------------------------------------------------------------------
        -- 修改穿戴组件，屏蔽指定玩家
            equippable_setup(inst)
        ----------------------------------------------------------------------------------------------
        --- 灵宝关键组件
            bogd_com_treasure_setup(inst)
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
            inst.components.inventoryitem.keepondeath = true        --- 死亡不掉落
            inst.components.inventoryitem:SetSinks(true) --- 落水消失
            inst.components.inventoryitem.imagename = "bogd_treasure_poison_ring"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/bogd_treasure_poison_ring.xml"
        ----------------------------------------------------------------------------------------------
        --- 
        ----------------------------------------------------------------------------------------------
        MakeHauntableLaunch(inst)

        return inst
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("bogd_treasure_poison_ring", fn, assets)
