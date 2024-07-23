--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    AddPlayerPostInit(function(inst)

        if not TheWorld.ismastersim then
            return
        end

        inst:ListenForEvent("bogd_become_god",function()
            local x,y,z = inst.Transform:GetWorldPosition()
            SpawnPrefab("moonpulse_fx").Transform:SetPosition(x,y,z)
            -- SpawnPrefab("cavehole_flick").Transform:SetPosition(x,y,z)
            SpawnPrefab("moon_geyser_explode").Transform:SetPosition(x,y,z)
        end)
        inst:ListenForEvent("bogd_become_demon",function()
            local x,y,z = inst.Transform:GetWorldPosition()
            SpawnPrefab("moonpulse2_fx").Transform:SetPosition(x,y,z)
            SpawnPrefab("cavehole_flick").Transform:SetPosition(x,y,z)
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

                    inst.components.inventory:GiveItem(SpawnPrefab("bogd_item_ephemeral_life_stone"))
                ------------------------------------------------------------------------------
            end
        end)

        -- inst:ListenForEvent("bogd_level_up_with_lock_break",function()


        -- end)



    end)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------