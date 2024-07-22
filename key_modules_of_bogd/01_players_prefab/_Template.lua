--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPlayerPostInit(function(inst)

    if not TheWorld.ismastersim then
        return
    end

    local current_indicator = nil
    inst:ListenForEvent("player_enter_map_room",function(_,Indicator)
        if Indicator ~= current_indicator then
            current_indicator = Indicator
            print("player enter new room",current_indicator:GetType())
        end
    end)

end)