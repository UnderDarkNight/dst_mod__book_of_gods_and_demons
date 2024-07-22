--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    地图跳跃

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPlayerPostInit(function(inst)
    ---------------------------------------------------------------------------------------
    --- 远程控制地图关闭/开启
        inst:ListenForEvent("bogd_event.ToggleMap",function()
            if inst.HUD then
                inst.HUD.controls:ToggleMap()
            end
        end)
    ---------------------------------------------------------------------------------------
    --- 上test
        -- inst:ListenForEvent("BOGD_OnEntityReplicated.bogd_com_map_jumper", function(inst, replica_com)
        --     replica_com:SetTestFn(function(inst,pt)
        --         print("test++++++",math.random())
        --         return TheWorld.Map:IsAboveGroundAtPoint(pt.x,0,pt.z)
        --     end)
        -- end)
    ---------------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return
    end

    ---------------------------------------------------------------------------------------
    --- 上核心函数
        inst:AddComponent("bogd_com_map_jumper")
        -- inst.components.bogd_com_map_jumper:SetPreSpellFn(function(inst,pt)
        --     inst.components.bogd_com_rpc_event:PushEvent("bogd_event.ToggleMap")
        -- end)
        -- inst.components.bogd_com_map_jumper:SetSpellFn(function(inst,pt)
        --     if inst.components.playercontroller ~= nil then
        --         inst.components.playercontroller:RemotePausePrediction(10)   --- 暂停远程预测。  --- 暂停10帧预测
        --         inst.components.playercontroller:Enable(false)
        --     end
        --     local function trans2pt(inst,pt)
        --         if inst.Physics then
        --             inst.Physics:Teleport(pt.x,pt.y,pt.z)
        --         else
        --             inst.Transform:SetPosition(pt.x,pt.y,pt.z)
        --         end
        --     end
        --     trans2pt(inst,pt)
        --     inst:DoTaskInTime(0,function()
        --         if inst.components.playercontroller ~= nil then
        --             inst.components.playercontroller:Enable(true)
        --         end
        --     end)
        -- end)
    ---------------------------------------------------------------------------------------

end)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- hook 进 玩家控制器
AddPlayerPostInit(function(inst)

    inst:DoTaskInTime(0,function()
        


        if inst.components.playercontroller == nil then
            return
        end



        local old_GetMapActions_fn = inst.components.playercontroller.GetMapActions
        inst.components.playercontroller.GetMapActions = function(self,position)
            local LMBaction, RMBaction = old_GetMapActions_fn(self, position)

            ----------------------------------------------------------------------------------------
                    -- local inventory = self.inst.components.inventory or self.inst.replica.inventory
                    -- if inventory and inventory:EquipHasTag("mms_scroll_blink_map") then
                    --     local equipments = self.inst.replica.inventory and self.inst.replica.inventory:GetEquips() or {}
    
                    --     -------- 获取装备，用于放到 act.invobject 里
                    --         local invobject = nil
                    --         for e_slot, e_item in pairs(equipments) do
                    --             if e_item and e_item:HasTag("mms_scroll_blink_map") then
                    --                 invobject = e_item
                    --                 break
                    --             end
                    --         end
    
                        
                    -- end
            ----------------------------------------------------------------------------------------
                    if RMBaction == nil then
                        local act = BufferedAction(self.inst, nil, ACTIONS.BOGD_BLINK_MAP)
                        RMBaction = self:RemapMapAction(act, position)
                    end
            ----------------------------------------------------------------------------------------
    
    
            return LMBaction, RMBaction    
        end

        local old_OnMapAction_fn = inst.components.playercontroller.OnMapAction
        inst.components.playercontroller.OnMapAction = function(self,actioncode, position)
            old_OnMapAction_fn(self,actioncode, position)

            if self.inst.replica.bogd_com_map_jumper and self.inst.replica.bogd_com_map_jumper:Test(position) then

                local act = MOD_ACTIONS_BY_ACTION_CODE[STRINGS.BOGD_BLINK_MAP][actioncode]
                if act == nil or not act.map_action then
                    return
                end
                if self.ismastersim then

                            local LMBaction, RMBaction = self:GetMapActions(position)
                            if act.rmb and RMBaction then ---- 右键
                                RMBaction:Do()
                            end

                else
                            SendRPCToServer(RPC.DoActionOnMap, actioncode, position.x, position.z)
                            -- print("发送了 RPC.DoActionOnMap")
                end
                
            end

        end

    end)


    

end)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------