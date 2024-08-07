--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    护盾值 的基础模块 。 hook 进去 health/combat 模块

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 基础HOOK
    AddPlayerPostInit(function(inst)


        if not TheWorld.ismastersim then
            return
        end

        if inst.components.bogd_data == nil then
            inst:AddComponent("bogd_data")
        end
        if inst.components.bogd_com_combat_hook == nil then
            inst:AddComponent("bogd_com_combat_hook")
        end

        if inst.components.bogd_com_level_sys == nil then
            inst:AddComponent("bogd_com_level_sys")
        end

        ----------------------------------------------------------------------------------------------------
        --- hook 两个关键API
            if inst.components.combat then            
                local old_GetAttacked = inst.components.combat.GetAttacked
                inst.components.combat.GetAttacked = function(self,attacker, damage, weapon, stimuli, spdamage,...)
                    ------------------------------------------------------------------------------------
                    --- 通用屏蔽器
                        damage,spdamage = self.inst.components.bogd_com_combat_hook:GetAttackedHooked(attacker, damage, weapon, stimuli, spdamage)
                    ------------------------------------------------------------------------------------
                    --- 等级护盾
                        damage,spdamage = self.inst.components.bogd_com_level_sys:Shield_Cost_In_Combat_GetAttacked(attacker, damage, weapon, stimuli, spdamage)
                    ------------------------------------------------------------------------------------
                    return old_GetAttacked(self,attacker, damage, weapon, stimuli, spdamage,...)
                end
            end

            if inst.components.health then
                local old_DoDelta = inst.components.health.DoDelta
                inst.components.health.DoDelta = function(self, amount, overtime, cause, ...)
                    if amount < 0 then
                        -- print("++++++",cause)
                        amount = self.inst.components.bogd_com_level_sys:Shield_Cost_By_Health_Down(amount, cause)
                    else
                        if self.inst.components.bogd_com_level_sys:GetHealthUpBlocking() then --- 突破期间不允许恢复任何血量
                            amount = 0
                        end
                    end
                    -- print("+++ health.DoDelta +++",amount,inst.components.bogd_com_level_sys:GetHealthUpBlocking())
                    return old_DoDelta(self, amount, overtime, cause, ...)
                end
            end
        ----------------------------------------------------------------------------------------------------
        --- IsNearDanger
            local old_IsNearDanger = inst.IsNearDanger
            inst.IsNearDanger = function(self, ...)
                if self.components.bogd_com_level_sys:IsInDanger() then
                    return true
                end                
                return old_IsNearDanger(self, ...)
            end
        ----------------------------------------------------------------------------------------------------
        --- 护盾生效触发特效
            inst:ListenForEvent("bogd_shield_active",function()
            inst:SpawnChild("bogd_sfx_shadow_sheild"):PushEvent("Set",{

            })
            end)
        ----------------------------------------------------------------------------------------------------
        --- 护盾睡觉恢复
            if inst.components.sleepingbaguser then
                local old_SleepTick = inst.components.sleepingbaguser.SleepTick                
                inst.components.sleepingbaguser.SleepTick = function(self, ...)
                    if self.inst.components.bogd_com_level_sys.enable then
                        self.inst.components.bogd_com_level_sys:Shield_DoDelta(TUNING.SLEEP_HEALTH_PER_TICK/2)
                    end
                    return old_SleepTick(self, ...)
                end
            end
        ----------------------------------------------------------------------------------------------------

    end)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 等级锁
    AddPlayerPostInit(function(inst)


        if not TheWorld.ismastersim then
            return
        end

        if inst.components.bogd_com_level_sys == nil then
            inst:AddComponent("bogd_com_level_sys")
        end

        local locked_level = {19,29,39,49,59,69,79}  -- 需要进行突破的等级

        for k, level in pairs(locked_level) do
            inst.components.bogd_com_level_sys:Set_Level_Lock(level)
        end

        ------ 每次升级恢复满护盾
        inst:ListenForEvent("bogd_level_up",function()
           local max_sheild = inst.components.bogd_com_level_sys:Shield_Max_Get()
           inst.components.bogd_com_level_sys:Shield_Set(max_sheild)

        end)

        -- inst:DoTaskInTime(1,function()
        --     inst.components.inventory:GiveItem(SpawnPrefab("bogd_other_test_item_start_level"))
        -- end)


    end)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 启停总按钮
    AddPlayerPostInit(function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:ListenForEvent("bogd_event.book_cmd_start",function()
            if not inst.components.bogd_com_level_sys.enable then
                inst.components.bogd_com_level_sys:SetEnable(true)                
                inst.components.bogd_com_rpc_event:PushEvent("bogd_com_level_sys_enable")
                inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active") -- 音效
            end
        end)
        inst:ListenForEvent("bogd_event.book_cmd_stop",function()
            if inst.components.bogd_com_level_sys.enable then
                inst.components.bogd_com_level_sys:Reset()
                inst.components.bogd_com_rpc_event:PushEvent("bogd_com_level_sys_disable")
                inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active") -- 音效
            end
        end)

    end)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------