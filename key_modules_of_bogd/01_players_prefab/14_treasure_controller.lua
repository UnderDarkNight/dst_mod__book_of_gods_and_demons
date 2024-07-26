--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function active_fn(inst)

        -----------------------------------------------------------------------
        -- 获取装备
            local item = nil
            local equips = inst.replica.inventory:GetEquips()
            for k, temp in pairs(equips) do
                if temp and temp:HasTag("bogd_treasure") then
                    item = temp
                    break
                end
            end
            if item == nil then
                return
            end
        -----------------------------------------------------------------------
        -- 检查CD
            if item.replica.bogd_com_treasure:Is_CD_Started() and TheFocalPoint then
                TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative", nil, .4)
                return
            end
        -----------------------------------------------------------------------
        -- 通过RPC上传触发事件
           inst.replica.bogd_com_rpc_event:PushEvent("bogd_treasure_hotkey_press",{
                pt = TheInput:GetWorldPosition(),
           },item)
        -----------------------------------------------------------------------




    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function Add_KeyHandler(inst)
    local key_listener = TheInput:AddKeyHandler(function(key,down)
        if down == true and TUNING.BOGD_FN:IsKeyPressed(TUNING.BOGD_CONFIG.TREASURE_HOTKEY,key) then
            active_fn(inst)
        end
    end)
    inst:ListenForEvent("onremove",function()
        key_listener:Remove()
    end)
end
AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(1,function()
        if inst == ThePlayer and inst.HUD then
            Add_KeyHandler(inst)
        end
    end)
end)