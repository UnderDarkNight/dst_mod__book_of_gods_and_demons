--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    成魔后执行

    成魔，饱食度掉的更快，但是在战斗时候，有概率出现暴击。
    
    更具san来定暴击的概率，san越高，暴击越高

    但是出现一次暴击，就会掉-5点san

    伤害为输入的2倍

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPlayerPostInit(function(inst)


    if not TheWorld.ismastersim then
        return
    end

    local modifier_inst = CreateEntity()
    inst:ListenForEvent("onremove",function()
        modifier_inst:Remove()
    end)



    local dmg_modifier_fn = function(origin_damage)
        if inst.components.sanity then
            local sanity_percent =  inst.components.sanity:GetRealPercent()
            if math.random(1000)/1000 <= sanity_percent then -- 造成暴击
                inst.components.sanity:DoDelta(-5,true)
                -- if TUNING.BOGD_DEBUGGING_MODE then
                --     print("+++ 暴击 +++",math.random())
                -- end
                return origin_damage
            end        
        end
        return 0
    end

    inst:ListenForEvent("bogd_body_type_changed", function(inst)
        if inst.components.bogd_com_level_sys:IsDemon() then
            inst.components.bogd_com_combat_extra_damage:SetModifier(modifier_inst, dmg_modifier_fn)
            if inst.components.hunger then
                inst.components.hunger.burnratemodifiers:SetModifier(modifier_inst,2)
            end
        else
            inst.components.bogd_com_combat_extra_damage:RemoveModifier(modifier_inst)
            if inst.components.hunger then
                inst.components.hunger.burnratemodifiers:RemoveModifier(modifier_inst)
            end
        end
    end)

end)