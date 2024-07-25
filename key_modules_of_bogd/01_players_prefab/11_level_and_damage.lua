--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    等级和  伤害

    每升1级，+0.5，突破大境界+5点。

    人物达到60级，防御增加5%

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPlayerPostInit(function(inst)


    if not TheWorld.ismastersim then
        return
    end
    if inst.components.combat== nil then
        return
    end

    ---------------------------------------------------------------------------------------------------
    ---- 独立的伤害增加组件
        if inst.components.bogd_com_combat_extra_damage == nil then
            inst:AddComponent("bogd_com_combat_extra_damage")
        end
    ---------------------------------------------------------------------------------------------------
    ---- 倍增器
        local mult_inst = CreateEntity()
        inst:ListenForEvent("onremove",function()
            mult_inst:Remove()
        end)
    ---------------------------------------------------------------------------------------------------
    ----
        local extra_damage = 0   -- 额外伤害加成
        local function refresh_param(inst)
            local level = inst.components.bogd_com_level_sys:Level_Get()
            local level_up_locks = inst.components.bogd_com_level_sys.level_up_locks

            ------------------------------------------
            --- 伤害
                extra_damage = 0
                extra_damage = extra_damage + (level - 1) * 0.5
                for i = 1,level, 1 do
                    if level_up_locks[i-1] then
                        extra_damage = extra_damage + 5
                    end
                end
            ------------------------------------------
            --- 防御
                if level >= 60 then
                    inst.components.combat.externaldamagetakenmultipliers:SetModifier(mult_inst, 0.95)
                else
                    inst.components.combat.externaldamagetakenmultipliers:SetModifier(mult_inst, 1 )
                end
            ------------------------------------------

        end
    ---------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------
    --- hook 进官方的伤害计算函数
        local old_CalcDamage = inst.components.combat.CalcDamage
        inst.components.combat.CalcDamage = function(self,...)
            local old_ret = {old_CalcDamage(self,...)}
            if type(old_ret[1]) == "number" then
                ----------------------------------------------------
                -- 神魔等级系统的伤害加成
                    old_ret[1] = old_ret[1] + extra_damage
                ----------------------------------------------------
                -- 额外的等级系统的伤害加成
                    if self.inst.components.bogd_com_combat_extra_damage ~= nil then
                        old_ret[1] = old_ret[1] + self.inst.components.bogd_com_combat_extra_damage:GetDamage()
                    end
                ----------------------------------------------------
                --- 额外的自定义控制器伤害加成
                    if self.inst.components.bogd_com_combat_extra_damage ~= nil then
                        old_ret[1] = old_ret[1] + self.inst.components.bogd_com_combat_extra_damage:GetModifierDMG(old_ret[1])
                    end
                ----------------------------------------------------
            end
            return unpack(old_ret)
        end
    ---------------------------------------------------------------------------------------------------
    --- 初始化、等级变更
        inst:DoTaskInTime(1,refresh_param)
        inst:ListenForEvent("bogd_level_delta",refresh_param)
    ---------------------------------------------------------------------------------------------------


    



end)