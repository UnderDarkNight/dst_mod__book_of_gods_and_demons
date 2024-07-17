--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPlayerPostInit(function(inst)


    if not TheWorld.ismastersim then
        return
    end

    if inst.components.bogd_data == nil then
        inst:AddComponent("bogd_data")
    end

    if inst.components.bogd_com_rpc_event == nil then
        inst:AddComponent("bogd_com_rpc_event")
    end

end)