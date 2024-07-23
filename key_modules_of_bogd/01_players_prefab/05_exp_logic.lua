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
