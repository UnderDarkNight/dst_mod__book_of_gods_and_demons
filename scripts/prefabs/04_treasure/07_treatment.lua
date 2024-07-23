--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/bogd_treasure_treatment.zip"),

    Asset( "IMAGE", "images/inventoryimages/bogd_treasure_treatment.tex" ),  -- 物品贴图
    Asset( "ATLAS", "images/inventoryimages/bogd_treasure_treatment.xml" ),  -- 物品贴图

    Asset( "IMAGE", "images/treasure/bogd_treasure_treatment.tex" ),         -- UI贴图
    Asset( "ATLAS", "images/treasure/bogd_treasure_treatment.xml" ),         -- UI贴图


}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local DAMAGE_RADIUS = 5
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- equippable 组件
    local function equippable_setup(inst)
        local function hook_IsRestricted(com)
            com.IsRestricted = function(self,player)    --- 是否被屏蔽，return false 才能穿戴
                --- client/server 统一在这里
                if not player.replica.bogd_com_level_sys:CheckCanEquipSpecialItem() then -- 没有开启修仙
                    return true
                end
                if player.replica.bogd_com_level_sys:IsDemon() then -- 魔 不能用
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
                if HUD.dotted_circle == nil then
                    HUD.dotted_circle = SpawnPrefab("bogd_sfx_dotted_circle_client")
                    HUD.dotted_circle:PushEvent("Set",{
                        range = DAMAGE_RADIUS,
                        -- MultColour_Flag = true,
                        color = Vector3(0,255,0),
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
            inst.components.bogd_com_treasure:SetCDTime(8)     -- CD 时间
            inst.components.bogd_com_treasure:SetIcon("images/treasure/bogd_treasure_treatment.xml","bogd_treasure_treatment.tex") -- 图标贴图
            inst.components.bogd_com_treasure:SetSpellFn(function(inst,doer,pt)  -- 技能执行
                -- print("灵宝触发",pt)
                -- SpawnPrefab("log").Transform:SetPosition(pt.x,0,pt.z)

                local level = inst.components.bogd_com_treasure:GetLevel()
                local treatment_health = 30 + level  -- 恢复的血量
                local treatment_sanity = 30 + level -- 恢复的San

                local ents = TheSim:FindEntities(pt.x, 0, pt.z, DAMAGE_RADIUS, {"player"}, {"playerghost"}, nil)
                for k, temp_player in pairs(ents) do
                    local fx = temp_player:SpawnChild("bogd_sfx_green_snap")
                    fx:PushEvent("Set",{
                        pt = Vector3(0,4.5,0),
                        color = Vector3(1,1,1),
                        a = 0.8,
                        MultColour_Flag = true,
                        fn = function()
                            if temp_player:HasTag("playerghost") then
                                return
                            end
                            if temp_player.components.health then
                                temp_player.components.health:DoDelta(treatment_health)
                            end
                            if temp_player.components.sanity then
                                temp_player.components.sanity:DoDelta(treatment_sanity)
                            end
                        end   
                    })
                end
                if #ents == 0 then
                    return
                end
                if not TUNING.BOGD_DEBUGGING_MODE then
                    inst.components.bogd_com_treasure:SetCDStart()
                end
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

        inst.AnimState:SetBank("bogd_treasure_treatment")
        inst.AnimState:SetBuild("bogd_treasure_treatment")
        inst.AnimState:PlayAnimation("idle")

        inst:AddTag("bogd_treasure")  -- 用于快捷键标记识别

        inst.entity:SetPristine()
        ----------------------------------------------------------------------------------------------
        -- 显示文本颜色
            inst.level_str_color = {255/255,255/255,255/255,255/255}
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
            inst.components.inventoryitem.imagename = "bogd_treasure_treatment"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/bogd_treasure_treatment.xml"
        ----------------------------------------------------------------------------------------------
        --- 
        ----------------------------------------------------------------------------------------------
        MakeHauntableLaunch(inst)

        return inst
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("bogd_treasure_treatment", fn, assets)
