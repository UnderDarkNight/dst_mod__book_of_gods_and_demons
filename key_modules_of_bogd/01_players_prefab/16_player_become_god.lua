--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    成神后执行

    每秒回复1点护盾

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPlayerPostInit(function(inst)


    if not TheWorld.ismastersim then
        return
    end

    
    local task = nil
    local fx_task = nil
    inst:ListenForEvent("bogd_body_type_changed", function(inst)
        if inst.components.bogd_com_level_sys:IsGod() then
            if task == nil then
                task = inst:DoPeriodicTask(1,function()
                    inst.components.bogd_com_level_sys:Shield_DoDelta(1)
                end)
                fx_task = inst:DoPeriodicTask(3,function()
                    local fx = inst:SpawnChild("winters_feast_food_depleted")
                    fx.Transform:SetPosition(0,-1.3,0)
                end)
            end
        else
            if task ~= nil then
                task:Cancel()
                task = nil
                fx_task:Cancel()
                fx_task = nil
            end
        end
    end)

end)