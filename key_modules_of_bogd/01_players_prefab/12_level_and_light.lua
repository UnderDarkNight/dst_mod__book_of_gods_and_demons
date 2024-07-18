--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    等级和  灯光

    人物达到30级，范围发光（矿工帽那么大）

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPlayerPostInit(function(inst)


    if not TheWorld.ismastersim then
        return
    end

    ---------------------------------------------------------------------------------------------------
    ----
        local light_fx = nil
        local light_flag = false
    ---------------------------------------------------------------------------------------------------
    ---- light
        local function light_refresh(inst)
            local need_2_trun_on_light = false
            if TheWorld.state.isdusk or TheWorld.state.isnight or TheWorld:HasTag("cave") then
                need_2_trun_on_light = true
            end

            ---- 关灯
            if not need_2_trun_on_light and light_fx then
                light_fx:DoTaskInTime(3,function()
                    light_fx:Remove()                
                    light_fx = nil
                end)
                return
            end


            --- 开灯
            if light_flag and need_2_trun_on_light and not light_fx then
                light_fx = inst:SpawnChild("minerhatlight")
            end

        end
    ---------------------------------------------------------------------------------------------------
    ----
        local function refresh_param(inst)
            local level = inst.components.bogd_com_level_sys.level
            if level >= 30 then
                light_flag = true
            else
                light_flag = false
            end

            inst:DoTaskInTime(1,light_refresh)
        end
    ---------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------
    --- 初始化、等级变更
        inst:DoTaskInTime(1,refresh_param)
        inst:ListenForEvent("bogd_level_delta",refresh_param)
        inst:WatchWorldState("isdusk",refresh_param)
        inst:WatchWorldState("isday",refresh_param)
        inst:WatchWorldState("isnight",refresh_param)
    ---------------------------------------------------------------------------------------------------


    



end)