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

------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.target = target
    -----------------------------------------------------
    ---
        local linked_player = target.linked_player
    -----------------------------------------------------
    --- 没有链接到玩家，移除NPC
        if linked_player == nil then    
            target:Remove()
            inst:Remove()
            return
        end
    -----------------------------------------------------
    --- 是否允许玩家回血
        linked_player.components.bogd_com_level_sys:SetHealthUpBlocking(true) -- 禁止回血
        target:ListenForEvent("onremove",function()
            linked_player.components.bogd_com_level_sys:SetHealthUpBlocking(false) -- 恢复玩家回血
        end)
    -----------------------------------------------------
    --- 复制玩家外观
        if target.components.skinner == nil then
            target:AddComponent("skinner")
        end
        target.components.skinner:CopySkinsFromPlayer(linked_player)
        target.AnimState:SetMultColour(0.2,0.2,0.2,0.8)
    -----------------------------------------------------
    --- 配置武器外观
        if target.components.inventory == nil then
            target:AddComponent("inventory")
        end
        local weapon = SpawnPrefab("voidcloth_scythe")
        weapon.components.finiteuses.Use = function(self,...)  end
        target.components.inventory:Equip(weapon)
        target:ListenForEvent("onremove",function() weapon:Remove() end)
        target:ListenForEvent("death",function() weapon:Remove() end)
    -----------------------------------------------------
    --- 配置血量
        local max_health = 10000
        if TUNING.BOGD_DEBUGGING_MODE then
            max_health = 100
        end
        target.components.health:SetMaxHealth(max_health)
    -----------------------------------------------------    
    --- 被攻击 inst:PushEvent("attacked", { attacker = attacker,
        target:ListenForEvent("attacked", function(_,_table)
            local attacker = _table and _table.attacker
            if attacker and attacker ~= linked_player then
                ----- 非链接玩家攻击，移除
                SpawnPrefab("shadow_puff_solid").Transform:SetPosition(target.Transform:GetWorldPosition()) --- 消失特效
                target:Remove()
                linked_player.components.bogd_com_rpc_event:PushEvent("bogd_event.whisper",{
                    m_colour = {255/255,50/255,50/255},
                    message = TUNING.BOGD_FN:GetStrings("bogd_item_spirit_infant_pill","shadow_fail_by_other_hit") or "nil",
                    sender_name = "󰀉󰀉󰀉",
                })
                inst:Remove()
                return
            end
        end)
    -----------------------------------------------------
    --- 在加载范围外，直接移除
        target:ListenForEvent("entitysleep",function()
            target:Remove()
            inst:Remove()
        end)
    -----------------------------------------------------
    --- 怪物死亡，成功击杀,触发突破
        target:ListenForEvent("death",function()
            if not target.PlayerIsDead(linked_player) then
                linked_player.components.bogd_com_rpc_event:PushEvent("bogd_event.whisper",{
                    m_colour = {255/255,255/255,255/255},
                    message = TUNING.BOGD_FN:GetStrings("bogd_item_spirit_infant_pill","shadow_task_succeed") or "nil",
                    sender_name = "󰀭󰀭󰀭",
                })
                linked_player.components.bogd_com_level_sys:Level_Up_With_Lock_Break()
            end
        end)
    -----------------------------------------------------
    --- 屏蔽一些非玩家目标的API
        local old_SetTarget = target.components.combat.SetTarget
        target.components.combat.SetTarget = function(self, tar,...)
            if tar ~= linked_player then
                return
            end
            return old_SetTarget(self, tar,...)
        end
        local old_SuggestTarget = target.components.combat.SuggestTarget
        target.components.combat.SuggestTarget = function(self,tar,...)
            if tar ~= linked_player then
                return
            end
            return old_SuggestTarget(self,tar,...)
        end
    -----------------------------------------------------
    --- 定期循环检查
        local TIMER = 180
        target:DoPeriodicTask(1,function()
            -----------------------------------------------------
            --- 玩家穿越走
                if not linked_player:IsValid() then
                    target:Remove()
                    inst:Remove()
                    return
                end
            -----------------------------------------------------
            --- 检查玩家是否死亡
                if target.PlayerIsDead(linked_player) then
                    SpawnPrefab("shadow_puff_solid").Transform:SetPosition(target.Transform:GetWorldPosition()) --- 消失特效
                    target:Remove()
                    linked_player.components.bogd_com_rpc_event:PushEvent("bogd_event.whisper",{
                        m_colour = {255/255,50/255,50/255},
                        message = TUNING.BOGD_FN:GetStrings("bogd_item_spirit_infant_pill","shadow_task_faild") or "nil",
                        sender_name = "󰀉󰀉󰀉",
                    })
                    inst:Remove()
                    return
                end
            -----------------------------------------------------
            --- 检查超时
                TIMER = TIMER - 1
                if TIMER <= 0 then
                    SpawnPrefab("shadow_puff_solid").Transform:SetPosition(target.Transform:GetWorldPosition()) --- 消失特效
                    target:Remove()
                    linked_player.components.bogd_com_rpc_event:PushEvent("bogd_event.whisper",{
                        m_colour = {255/255,50/255,50/255},
                        message = TUNING.BOGD_FN:GetStrings("bogd_item_spirit_infant_pill","shadow_task_timeout") or "nil",
                        sender_name = "󰀉󰀉󰀉",
                    })
                    inst:Remove()
                    return
                end
            -----------------------------------------------------
            --- 锁定追杀玩家
                target.components.combat:SuggestTarget(linked_player)
                target.components.combat:SetTarget(linked_player)
            -----------------------------------------------------
            --- 不允许玩家回血
                linked_player.components.bogd_com_level_sys:SetHealthUpBlocking(true) -- 禁止回血
            -----------------------------------------------------

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

return Prefab("bogd_debuff_spirit_infant_pill", fn)
