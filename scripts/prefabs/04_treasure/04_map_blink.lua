--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/bogd_treasure_map_blink.zip"),

    Asset( "IMAGE", "images/inventoryimages/bogd_treasure_map_blink.tex" ),  -- 物品贴图
    Asset( "ATLAS", "images/inventoryimages/bogd_treasure_map_blink.xml" ),  -- 物品贴图

    Asset( "IMAGE", "images/treasure/bogd_treasure_map_blink.tex" ),         -- UI贴图
    Asset( "ATLAS", "images/treasure/bogd_treasure_map_blink.xml" ),         -- UI贴图


}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 激活跳图相关的操作
    local function unistall_replica_map_jump(inst,doer)
        doer.replica.bogd_com_map_jumper:SetTestFn(nil)        
    end
    local function install_replica_map_jump(inst,doer)
        doer.replica.bogd_com_map_jumper:SetTestFn(function(doer,pt)
            ----------------------------------------------------------------------------------
            -- 

            ----------------------------------------------------------------------------------
            --- 物品失效
                if not inst:IsValid() then
                    unistall_replica_map_jump(inst,doer)
                    return false
                end
            ----------------------------------------------------------------------------------
            --- 死了不能用
                if doer:HasTag("playerghost") then
                    return false
                end
            ----------------------------------------------------------------------------------
            --- 符合条件才能用
                if inst.replica.bogd_com_treasure:Is_CD_Started() then
                    return false
                end
                return TheWorld.Map:IsAboveGroundAtPoint(pt.x,0,pt.z)
            ----------------------------------------------------------------------------------
        end)
        inst:ListenForEvent("onremove",function()
            doer.replica.bogd_com_map_jumper:SetTestFn(nil)
        end)
    end


    local function map_jump_onequip(inst,doer)
        doer.components.bogd_com_map_jumper:SetPreSpellFn(function(doer,pt)
            doer.components.bogd_com_rpc_event:PushEvent("bogd_event.ToggleMap") -- 下发关闭地图命令
        end)
        doer.components.bogd_com_map_jumper:SetSpellFn(function(doer,pt)
            ----------------------------------------------------------------------------------
            --- 物品失效
                if not inst:IsValid() then
                    unistall_replica_map_jump(inst,doer)
                    doer.components.bogd_com_map_jumper:SetPreSpellFn(nil)
                    doer.components.bogd_com_map_jumper:SetSpellFn(nil)
                    return
                end
            ----------------------------------------------------------------------------------
            --- 
                -- if doer.components.hunger then                        
                --     if doer.components.hunger.current < 20 then
                --         doer.components.bogd_com_rpc_event:PushEvent("bogd_event.whisper",{
                --             message = TUNING.BOGD_FN:GetStrings(inst.prefab,"spell_cost_fail"),
                --         })
                --         return
                --     else
                --         doer.components.hunger:DoDelta(-20)
                --     end
                -- end
            ----------------------------------------------------------------------------------
            --- 执行传送
                if doer.components.playercontroller ~= nil then
                    doer.components.playercontroller:RemotePausePrediction(5)   --- 暂停远程预测。  --- 暂停10帧预测
                    doer.components.playercontroller:Enable(false)
                end
                local function trans2pt(inst,pt)
                    if inst.Physics then
                        inst.Physics:Teleport(pt.x,pt.y,pt.z)
                    else
                        inst.Transform:SetPosition(pt.x,pt.y,pt.z)
                    end
                end
                trans2pt(doer,pt)
                doer:DoTaskInTime(0,function()
                    if doer.components.playercontroller ~= nil then
                        doer.components.playercontroller:Enable(true)
                    end
                end)
            ----------------------------------------------------------------------------------
            --- 让物品CD开始计时
                inst.components.bogd_com_treasure:SetCDStart()
            ----------------------------------------------------------------------------------
        end)
        install_replica_map_jump(inst,doer)
    end
    local function map_jump_unequip(inst,doer)
        doer.components.bogd_com_map_jumper:SetPreSpellFn(nil)
        doer.components.bogd_com_map_jumper:SetSpellFn(nil)
        unistall_replica_map_jump(inst,doer)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- equippable 组件

    local function equippable_setup(inst)
        local function hook_IsRestricted(com)
            com.IsRestricted = function(self,player)    --- 是否被屏蔽，return false 才能穿戴
                --- client/server 统一在这里
                if not player.replica.bogd_com_level_sys:CheckCanEquipSpecialItem() then -- 没有开启修仙
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
                    map_jump_onequip(inst,owner)
                end)
            end)
            inst.components.equippable:SetOnUnequip(function(inst, owner) --- 加载的时候会执行一次 SetOnEquip 再 SetOnUnequip，会造成崩溃
                inst:DoTaskInTime(0,function()
                    inst.components.bogd_com_treasure:OnUnequipped(owner)
                    inst:Remove()  --- 脱下即消失
                    inst:RemoveEventCallback("death", death_event_in_player,owner)
                    map_jump_unequip(inst,owner)
                end)
            end)
            inst.components.equippable.equipslot = EQUIPSLOTS.TREASURE
            inst.components.equippable:SetPreventUnequipping(true)  --- 避免被脱下
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- bogd_com_treasure 组件
    local function bogd_com_treasure_setup(inst)
        inst:ListenForEvent("BOGD_OnEntityReplicated.bogd_com_treasure",function(inst, replica_com)
        end)
        ------------------------------------------------------
        --- 图标创建后，往玩家身上套 函数
            inst:ListenForEvent("treasure_hud_created",function(inst,HUD)
                if not HUD then
                    return
                end
                install_replica_map_jump(inst,ThePlayer)
            end)
        ------------------------------------------------------

        if TheWorld.ismastersim then

            inst:AddComponent("bogd_com_treasure")
            local cd_time = 120
            if TUNING.BOGD_DEBUGGING_MODE then
                cd_time = 10
            end
            inst.components.bogd_com_treasure:SetCDTime(cd_time)     -- CD 时间
            inst.components.bogd_com_treasure:SetIcon("images/treasure/bogd_treasure_map_blink.xml","bogd_treasure_map_blink.tex") -- 图标贴图
            inst.components.bogd_com_treasure:SetSpellFn(function(inst,doer,pt)  -- 技能执行
                -- inst.components.bogd_com_treasure:SetCDStart()
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

        inst.AnimState:SetBank("bogd_treasure_map_blink")
        inst.AnimState:SetBuild("bogd_treasure_map_blink")
        inst.AnimState:PlayAnimation("idle")

        inst:AddTag("bogd_treasure")  -- 用于快捷键标记识别

        inst.entity:SetPristine()
        ----------------------------------------------------------------------------------------------
        -- 显示文本颜色
            inst.level_str_color = {0/255,0/255,0/255,255/255}
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
            inst.components.inventoryitem.imagename = "bogd_treasure_map_blink"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/bogd_treasure_map_blink.xml"
        ----------------------------------------------------------------------------------------------
        --- 
        ----------------------------------------------------------------------------------------------
        MakeHauntableLaunch(inst)

        return inst
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("bogd_treasure_map_blink", fn, assets)
