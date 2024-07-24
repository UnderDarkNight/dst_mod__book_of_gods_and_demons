--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    玩家重选角色，则-10级别。

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPlayerPostInit(function(inst)


    if not TheWorld.ismastersim then
        return
    end

    local function GetIndex(inst)
        return "ms_playerreroll_level_"..tostring(inst.userid)        
    end



    inst:ListenForEvent("ms_playerreroll",function() --- 通过绚丽之门 重选角色
        if inst.components.bogd_com_level_sys.enable then
            local index = GetIndex(inst)
            local level = inst.components.bogd_com_level_sys:Level_Get()
            local body_type = inst.components.bogd_com_level_sys:GetBodyType()
            level = level - 10
            if level < 1 then
                level = 1
            end
            TheWorld.components.bogd_data:Set(index,{
                level = level,
                body_type = body_type,
            })
        end
    end)

    inst:DoTaskInTime(0,function() --- 角色重新生成的时候
        local index = GetIndex(inst)
        local save_data = TheWorld.components.bogd_data:Get(index)
        if save_data then
            local save_level = save_data.level - 1
            local body_type = save_data.body_type

            inst.components.bogd_com_level_sys:SetBodyType(body_type)
            inst.components.bogd_com_level_sys:SetEnable(true)
            inst.components.bogd_com_rpc_event:PushEvent("bogd_com_level_sys_enable")
            if save_level > 0 then
                inst.components.bogd_com_level_sys:Level_DoDelta(save_level,true)
            end
            --- 给回一半经验
            local max_exp = inst.components.bogd_com_level_sys.exp_max
            inst.components.bogd_com_level_sys:Exp_DoDelta(max_exp/2)
            --- 清掉储存在TheWorld里的数据
            TheWorld.components.bogd_data:Set(index,nil)
            ---- 通知一下
            inst.components.bogd_com_rpc_event:PushEvent("bogd_event.whisper",{
                m_colour = {255/255,100/255,100/255},
                message = TUNING.BOGD_FN:GetStrings("level","ms_playerreroll") or "角色更换、境界跌落",
                sender_name = "󰀒󰀒󰀒",
                -- icondata = "emoji_abigail",
            })
        end
    end)






end)