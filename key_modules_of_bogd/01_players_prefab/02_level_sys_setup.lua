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

        if inst.components.bogd_com_level_sys == nil then
            inst:AddComponent("bogd_com_level_sys")
        end

        ----------------------------------------------------------------------------------------------------
        --- hook 两个关键API
            if inst.components.combat then            
                local old_GetAttacked = inst.components.combat.GetAttacked
                inst.components.combat.GetAttacked = function(self,attacker, damage, weapon, stimuli, spdamage,...)
                    damage,spdamage = self.inst.components.bogd_com_level_sys:Shield_Cost_In_Combat_GetAttacked(attacker, damage, weapon, stimuli, spdamage)
                    return old_GetAttacked(self,attacker, damage, weapon, stimuli, spdamage,...)
                end
            end

            if inst.components.health then
                local old_DoDelta = inst.components.health.DoDelta
                inst.components.health.DoDelta = function(self, amount, overtime, cause, ...)
                    if amount < 0 then
                        -- print("++++++",cause)
                        amount = self.inst.components.bogd_com_level_sys:Shield_Cost_By_Health_Down(amount, cause)
                    end
                    return old_DoDelta(self, amount, overtime, cause, ...)
                end
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

        local locked_level = {19,29,39,49}  -- 需要进行突破的等级

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