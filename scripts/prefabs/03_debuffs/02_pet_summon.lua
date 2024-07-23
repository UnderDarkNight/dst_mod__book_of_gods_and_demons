------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【老麦影子10000血（npc啤酒瓶子那个）增加一些技能，
其他玩家不能帮助攻击。如果有其他玩家帮忙攻击，
需要做出一些反馈。比如影子消失，玩家突破失败，
原因是来自外来伤害，心魔只能自己打过，
或者，心魔变异，20万血的心魔，也会出现。直接给队友秒了，然后消失。突破失败】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
TheSim:LoadPrefabs({ "quagmire_swampig" })

------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.target = target
    -----------------------------------------------------
    ---
        local linked_player = target.linked_player
        local linked_item = target.linked_item
    -----------------------------------------------------
    ---
        local function refresh_param_by_level(update_flag)
            local level = linked_item.components.bogd_com_treasure:GetLevel()
            local base_max_health = 500
            local base_damage = 60

            local ret_health = base_max_health + level*20
            local ret_damage = base_damage + level*1

            if update_flag then
                target.components.health.maxhealth = ret_health
            else
                target.components.health:SetMaxHealth(ret_health)
            end
            target.components.combat:SetDefaultDamage(ret_damage)
        end
    -----------------------------------------------------
    --- 没有链接到玩家，移除NPC
        if linked_player == nil then    
            target:Remove()
            inst:Remove()
            return
        end
    -----------------------------------------------------
    --- 
        target.AnimState:SetBank("pigman")
        target.AnimState:SetBuild("quagmire_swampig_build")
    -----------------------------------------------------
    --- 屏蔽变疯猪
        if target.components.werebeast ~= nil then
            target.components.werebeast.SetWere = function(...)
            end
            target.components.werebeast.TriggerDelta = function(...)
            end
            target.components.werebeast.SetWere = function(...)
            end
        end
    -----------------------------------------------------
    --- 配置血量和伤害
        -- target.components.health:SetMaxHealth(500)
        -- target.components.combat:SetDefaultDamage(60)
        refresh_param_by_level()
    -----------------------------------------------------
    --- 穿戴装备
        local hat = SpawnPrefab("ruinshat")
        target.components.inventory:Equip(hat)
        -- target.AnimState:Show("hat")
        target.AnimState:Hide("hat")

        -- target.AnimState:ClearOverrideSymbol("swap_hat")
        -- target.AnimState:Hide("HAT")
        -- target.AnimState:Hide("HAIR_HAT")
        -- target.AnimState:Show("HAIR_NOHAT")
        -- target.AnimState:Show("HAIR")

        target:ListenForEvent("death",function() hat:Remove() end)
    -----------------------------------------------------
    ---
        if linked_player.components.minigame_participator == nil then
            linked_player:PushEvent("makefriend")
            linked_player.components.leader:AddFollower(target)
        end
        target.components.follower:AddLoyaltyTime(10)
        target.components.follower.maxfollowtime = 10
    -----------------------------------------------------
    --- 屏蔽跟随时间
        target.components.follower.StopFollowing = function() end
        target.components.follower.LongUpdate = function() end
    -----------------------------------------------------
    --- 距离检查
        target:ListenForEvent("entitysleep",function()
            if linked_player:IsValid() then
                target:DoTaskInTime(1,function()
                    target:RestartBrain()                    
                end)
                target.Transform:SetPosition(linked_player.Transform:GetWorldPosition())
                target:SpawnChild("spawn_fx_tiny")
            else
                target:Remove()
            end
        end)
    -----------------------------------------------------
    --- 处理夜间问题
        -- local light_fx = target:SpawnChild("minerhatlight")
        -- light_fx.Light:SetRadius(0.3)
    -----------------------------------------------------
    --- 定时检查
        inst:DoPeriodicTask(1,function()
            ------------------------------------------------------
            --- 检查玩家存在
                if not linked_player:IsValid() then
                    target:Remove()
                    inst:Remove()
                    return
                end
            ------------------------------------------------------
            ---
                if target.components.follower.task then
                    target.components.follower.task:Cancel()
                end
            ------------------------------------------------------
            --- 更新参数
                refresh_param_by_level(true)
            ------------------------------------------------------
        end)
    -----------------------------------------------------
end

local function OnDetached(inst) -- 被外部命令  inst:RemoveDebuff 移除debuff 的时候 执行
    local target = inst.target
end

local function OnUpdate(inst)
    local target = inst.target

end

local function ExtendDebuff(inst)
    -- inst.countdown = 3 + (inst._level:value() < CONTROL_LEVEL and EXTEND_TICKS or math.floor(TUNING.STALKER_MINDCONTROL_DURATION / FRAMES + .5))
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    -- inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetDetachedFn(OnDetached)
    -- inst.components.debuff:SetExtendedFn(ExtendDebuff)
    -- ExtendDebuff(inst)

    inst:DoPeriodicTask(1, OnUpdate, nil, TheWorld.ismastersim)  -- 定时执行任务


    return inst
end

return Prefab("bogd_debuff_pet_summon", fn)