--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/bogd_treasure_divine_punishment.zip"),

    Asset( "IMAGE", "images/inventoryimages/bogd_treasure_divine_punishment.tex" ),  -- 物品贴图
    Asset( "ATLAS", "images/inventoryimages/bogd_treasure_divine_punishment.xml" ),  -- 物品贴图

    Asset( "IMAGE", "images/treasure/bogd_treasure_divine_punishment.tex" ),         -- UI贴图
    Asset( "ATLAS", "images/treasure/bogd_treasure_divine_punishment.xml" ),         -- UI贴图


}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local DAMAGE_RADIUS = 3
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
                    owner:SpawnChild("channel_absorb_smoulder")
                    owner:SpawnChild("bogd_sfx_elect_shock"):PushEvent("Set",{})
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
                        range = DAMAGE_RADIUS
                    })
                    HUD.inst:ListenForEvent("onremove",function()
                        HUD.dotted_circle:Remove()                            
                    end)
                    HUD.dotted_circle:DoPeriodicTask(FRAMES,function()
                        if inst.replica.bogd_com_treasure:Is_CD_Started() or (ThePlayer and ThePlayer:HasTag("playerghost") )then
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
            inst.components.bogd_com_treasure:SetIcon("images/treasure/bogd_treasure_divine_punishment.xml","bogd_treasure_divine_punishment.tex") -- 图标贴图
            inst.components.bogd_com_treasure:SetSpellFn(function(inst,doer,pt)  -- 技能执行                        
                -- print("灵宝触发",pt)
                -- SpawnPrefab("log").Transform:SetPosition(pt.x,0,pt.z)
                ----------------------------------------------------------------------------------------------
                --- 寻找合适的目标
                    local musthavetags = { "_combat" }
                    local canthavetags = { "INLIMBO", "notarget", "noattack", "invisible", "wall", "player", "companion" }
                    local musthaveoneoftags = {}
                    local ents = TheSim:FindEntities(pt.x, 0, pt.z, DAMAGE_RADIUS, musthavetags, canthavetags, musthaveoneoftags)
                    local ret_targets = {}
                    for k, temp in pairs(ents) do
                        if temp and temp.components.combat and temp.components.combat:CanBeAttacked(doer)  then
                            if temp.components.health and not temp.components.health:IsDead() then
                                table.insert(ret_targets,temp)
                            end
                        end
                    end
                    local fx = SpawnPrefab("lightning")
                    fx.Transform:SetPosition(pt.x,0,pt.z)
                    for k, temp in ipairs(ret_targets) do
                        temp.components.combat:GetAttacked(doer, 100, inst)
                        -- print("attacked",temp)
                        -- doer.components.combat:DoAttack(temp,inst)
                        SpawnPrefab("bogd_sfx_elect_shock"):PushEvent("Set",{
                            pt = Vector3(temp.Transform:GetWorldPosition()),
                        })
                    end
                ----------------------------------------------------------------------------------------------
                --- 开始CD
                    if not TUNING.BOGD_DEBUGGING_MODE then
                        inst.components.bogd_com_treasure:SetCDStart()
                    end
                ----------------------------------------------------------------------------------------------
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

        inst.AnimState:SetBank("bogd_treasure_divine_punishment")
        inst.AnimState:SetBuild("bogd_treasure_divine_punishment")
        inst.AnimState:PlayAnimation("idle")

        inst:AddTag("bogd_treasure")  -- 用于快捷键标记识别

        inst.entity:SetPristine()

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
            inst.components.inventoryitem.imagename = "bogd_treasure_divine_punishment"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/bogd_treasure_divine_punishment.xml"
        ----------------------------------------------------------------------------------------------
        --- 
            inst:AddComponent("weapon")
            inst.components.weapon:SetDamage(100)
            inst.components.weapon:SetElectric()
        ----------------------------------------------------------------------------------------------
        MakeHauntableLaunch(inst)

        return inst
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("bogd_treasure_divine_punishment", fn, assets)
