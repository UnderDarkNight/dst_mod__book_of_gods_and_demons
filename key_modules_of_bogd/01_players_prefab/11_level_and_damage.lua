--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    等级和  伤害

    人物达到50级，攻击增加10点
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
    ---- 倍增器
        local mult_inst = CreateEntity()
        inst:ListenForEvent("onremove",function()
            mult_inst:Remove()
        end)
    ---------------------------------------------------------------------------------------------------
    ----
        local extra_damage = 0   -- 额外伤害加成
        local function refresh_param(inst)
            local level = inst.components.bogd_com_level_sys.level

            ------------------------------------------
            --- 伤害
                if level >= 50 then
                    extra_damage = 10
                else
                    extra_damage = 0
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
        inst.components.combat.CalcDamage = function(...)
            local old_ret = {old_CalcDamage(...)}
            if type(old_ret[1]) == "number" then
                old_ret[1] = old_ret[1] + extra_damage
            end
            return unpack(old_ret)
        end
    ---------------------------------------------------------------------------------------------------
    --- 初始化、等级变更
        inst:DoTaskInTime(1,refresh_param)
        inst:ListenForEvent("bogd_level_delta",refresh_param)
    ---------------------------------------------------------------------------------------------------


    



end)