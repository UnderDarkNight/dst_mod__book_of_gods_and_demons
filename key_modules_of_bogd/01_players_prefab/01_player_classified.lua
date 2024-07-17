--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    player_classified

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit(
    "player_classified",
    function(inst)

        ------------------------------------------------------------------------------------------------------
        ---- 总体启动
            inst.bogd_enable = net_bool(inst.GUID, "bogd_enable", "bogd_enable_dirty")
        ------------------------------------------------------------------------------------------------------
        ---- 护盾值
            inst.bogd_shield_current = net_uint(inst.GUID, "bogd_shield_current", "bogd_shield_dirty")
            inst.bogd_shield_max = net_uint(inst.GUID, "bogd_shield_max", "bogd_shield_dirty")
        ------------------------------------------------------------------------------------------------------
        ---- 经验值
            inst.bogd_exp_current = net_uint(inst.GUID, "bogd_exp_current", "bogd_exp_dirty")
            inst.bogd_exp_max = net_uint(inst.GUID, "bogd_exp_max", "bogd_exp_dirty")
            inst.bogd_exp_level_up_lock = net_bool(inst.GUID, "bogd_exp_level_up_lock", "bogd_exp_dirty") -- 等级锁
        ------------------------------------------------------------------------------------------------------
        ---- 等级
            inst.bogd_level = net_ushortint(inst.GUID, "bogd_level", "bogd_level_dirty")
        ------------------------------------------------------------------------------------------------------




        if not TheWorld.ismastersim then

            local old_OnEntityReplicated = inst.OnEntityReplicated            
            inst.OnEntityReplicated = function(inst,...)
                old_OnEntityReplicated(inst,...)
                -- inst._parent:AttachClassified(inst)
                if inst._parent ~= nil then
                    for i, v in ipairs({"bogd_com_level_sys"}) do
                        inst._parent:TryAttachClassifiedToReplicaComponent(inst, v)
                    end
                else
                    print("Unable to initialize classified data for player")
                end
            end
            return
        end

    end)