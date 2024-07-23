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
--- 文本通告
    AddPlayerPostInit(function(inst)

        if not TheWorld.ismastersim then
            return
        end

        inst:ListenForEvent("bogd_level_breakthrough_strings_display",function(inst,index)
            local strings_table = TUNING.BOGD_FN:GetStrings("level_break_through_world_annoucne",index) or {}
            if #strings_table == 0 then
                return
            end


            for i = 1, #strings_table, 1 do
                inst:DoTaskInTime(i*3,function()
                    local temp_str_data = strings_table[i]
                    local name = temp_str_data.name
                    local str = temp_str_data.str
                    local talker = temp_str_data.type

                    local colors = {
                        ["world"] = {0/255,245/255,255/255},    -- 天蓝色
                        ["god"] = {255/255,255/255,0/255},      -- 黄色
                        ["demon"] = {255/255,0/255,0/255},  --  红色
                    }
                    inst.components.bogd_com_rpc_event:PushEvent("bogd_event.whisper",{
                        m_colour = colors[talker] or {200/255,255/255,200/255},
                        s_colour = colors[talker] or {200/255,255/255,200/255},
                        message = str,
                        sender_name = name,
                        icondata = "default",
                    })
                end)
            end

        end)


        inst:ListenForEvent("bogd_level_up",function(inst,_table)
            -- _table = _table or {
            --     level = self.level,
            --     last_level = current_level,
            --     with_lock = with_lock,
            -- }
            local with_lock = _table and _table.with_lock or false
            if not with_lock then
                return
            end
            local level = _table and _table.level or 0
            local string_index_with_level = {
                [20] = "foundation_establishment",
                [40] = "foundation_establishment",
                [80] = "ascension",
            }
            --------------------------------------------------
            -- 刚突破到筑基 foundation_establishment
                local string_index = string_index_with_level[level]
                if string_index then
                    inst:PushEvent("bogd_level_breakthrough_strings_display",string_index)
                end
            --------------------------------------------------
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