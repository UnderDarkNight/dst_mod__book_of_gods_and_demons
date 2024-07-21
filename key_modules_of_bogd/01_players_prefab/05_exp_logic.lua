--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    经验值获取逻辑

    经验获取方式：击杀怪物，按照血量的三分之一。

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 经验获取计算
    AddPlayerPostInit(function(inst)


        if not TheWorld.ismastersim then
            return
        end

        local function computational_experience(max_health)
            if inst.components.bogd_com_level_sys.enable then
                local exp = math.floor(max_health/3) * TUNING.BOGD_CONFIG.EXP_MULT
                if exp >= 1 then
                    inst.components.bogd_com_level_sys:Exp_DoDelta(exp)
                end
            end
        end


        inst:ListenForEvent("onhitother",function(inst,_table)
            local target = _table and _table.target
            if not target then
                return
            end

            if target.components.health then
                if target.components.health:IsDead() then
                    computational_experience(target.components.health.maxhealth)
                elseif target.components.health:GetPercent() < 0.001 and not target:HasTag("bogd_exp_flag") then -- 某些击杀不死的怪物
                    target:AddTag("bogd_exp_flag")
                    computational_experience(target.components.health.maxhealth)
                end
                        

            end


        end)



    end)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 升级特效
    AddPlayerPostInit(function(inst)


        if not TheWorld.ismastersim then
            return
        end

        local lock_task = nil -- 为了避免连续升级造成多次特效播放
        inst:ListenForEvent("bogd_level_up",function(inst,_table)
            local level_up_with_lock_break = _table and _table.with_lock
            if not level_up_with_lock_break then
                ------------------------------------------------------------------------------
                    if lock_task == nil then
                        lock_task = inst:DoTaskInTime(1,function()
                            lock_task = nil
                        end)
                        inst:SpawnChild("halloween_moonpuff")            
                    end
                    inst.components.bogd_com_rpc_event:PushEvent("bogd_event.whisper",{
                        m_colour = {200/255,255/255,200/255},
                        message = TUNING.BOGD_FN:GetStrings("level","level_up_succeed") or "玩家境界提升",
                        sender_name = "󰀏󰀏󰀏",
                        -- icondata = "emoji_abigail",
                    })
                ------------------------------------------------------------------------------
            else
                ------------------------------------------------------------------------------
                    if lock_task == nil then
                        lock_task = inst:DoTaskInTime(1,function()
                            lock_task = nil
                        end)
                        inst:SpawnChild("wathgrithr_spirit")
                        inst:SpawnChild("halloween_firepuff_cold_1")
                        inst:SpawnChild("moonpulse_fx")
                    end
                    inst.components.bogd_com_rpc_event:PushEvent("bogd_event.whisper",{
                        m_colour = {255/255,100/255,100/255},
                        message = TUNING.BOGD_FN:GetStrings("level","breakthrough_succeed") or "玩家突破",
                        sender_name = "󰀒󰀒󰀒",
                        -- icondata = "emoji_abigail",
                    })
                    inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active") -- 音效
                    inst.components.bogd_com_rpc_event:PushEvent("bogd_exp_bar_drop") -- 下发掉落动画
                ------------------------------------------------------------------------------
            end
        end)

        -- inst:ListenForEvent("bogd_level_up_with_lock_break",function()


        -- end)



    end)