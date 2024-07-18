----------------------------------------------------------------------------------------------------------------------------------
--[[

    等级系统

    护盾值
    经验值


]]--
----------------------------------------------------------------------------------------------------------------------------------
local bogd_com_level_sys = Class(function(self, inst)
    self.inst = inst
    self.classified = nil

    if TheWorld.ismastersim then
        self.classified = inst.player_classified
    elseif self.classified == nil then
        if inst.player_classified ~= nil then
            self:AttachClassified(inst.player_classified)
        end
    end    

end)
---------------------------------------------------------------------------------------------------
---
    function bogd_com_level_sys:AttachClassified(classified)
        self.classified = classified
        self.ondetachclassified = function() self:DetachClassified() end
        self.inst:ListenForEvent("onremove", self.ondetachclassified, classified)

        self.inst:PushEvent("bogd_com_level_sys_client_side_inited")
        self:EnableBroadcast()

    end

    function bogd_com_level_sys:DetachClassified()
        self.classified = nil
        self.ondetachclassified = nil
    end
---------------------------------------------------------------------------------------------------
--- 开启修仙后 触发界面
    function bogd_com_level_sys:EnableBroadcast()
        self.inst:DoTaskInTime(0.5,function()
            if self.classified then                
                if self.classified.bogd_enable:value() then
                    self.inst:PushEvent("bogd_com_level_sys_enable")
                else
                    self.inst:PushEvent("bogd_com_level_sys_disable")
                end
            end
        end)
    end
    function bogd_com_level_sys:Enable(flag)
        if self.classified then
            self.classified.bogd_enable:set(flag)
        end
        self:EnableBroadcast()
    end
---------------------------------------------------------------------------------------------------
--- 等级锁激活
    function bogd_com_level_sys:SetLevelUpLock(flag)
        if self.classified then
            self.classified.bogd_exp_level_up_lock:set(flag)
        end
    end
    function bogd_com_level_sys:GetLevelUpLock()
        if self.inst.components.bogd_com_level_sys ~= nil then
            return self.inst.components.bogd_com_level_sys.level_up_lock_flag
        elseif self.classified ~= nil then
            return self.classified.bogd_exp_level_up_lock:value()
        else
            return false
        end
    end
---------------------------------------------------------------------------------------------------
--- 通用显示刷新
    -- function bogd_com_level_sys:RefreshDisplay()
    --     if not TheNet:IsDedicated() then
    --         self.inst:PushEvent("bogd_com_level_sys_refresh_display")
    --     end
    -- end
---------------------------------------------------------------------------------------------------
--- 护盾值
    function bogd_com_level_sys:Shield_Set(value)
        if self.classified then
            self.classified.bogd_shield_current:set(value)
        end
    end
    function bogd_com_level_sys:Shield_Get()
        if self.inst.components.bogd_com_level_sys ~= nil then
            return self.inst.components.bogd_com_level_sys.shield_current
        elseif self.classified ~= nil then
            return self.classified.bogd_shield_current:value()
        else
            return 0
        end
    end
    function bogd_com_level_sys:Shield_Max_Set(value)
        if self.classified then
            self.classified.bogd_shield_max:set(value)
        end
    end
    function bogd_com_level_sys:Shield_Max_Get()
        if self.inst.components.bogd_com_level_sys ~= nil then
            return self.inst.components.bogd_com_level_sys.shield_max
        elseif self.classified ~= nil then
            return self.classified.bogd_shield_max:value()
        else
            return 0
        end
    end
---------------------------------------------------------------------------------------------------
--- 经验值
    function bogd_com_level_sys:Exp_Set(value)
        if self.classified then
            self.classified.bogd_exp_current:set(value)
        end
    end
    function bogd_com_level_sys:Exp_Get()
        if self.inst.components.bogd_com_level_sys ~= nil then
            return self.inst.components.bogd_com_level_sys.exp_current
        elseif self.classified ~= nil then
            return self.classified.bogd_exp_current:value()
        else
            return 0
        end
    end
    function bogd_com_level_sys:Exp_Max_Set(value)
        if self.classified then
            self.classified.bogd_exp_max:set(value)
        end
    end
    function bogd_com_level_sys:Exp_Max_Get()
        if self.inst.components.bogd_com_level_sys ~= nil then
            return self.inst.components.bogd_com_level_sys.exp_max
        elseif self.classified ~= nil then
            return self.classified.bogd_exp_max:value()
        else
            return 100
        end
    end

    function bogd_com_level_sys:Exp_Get_Percent()
        return self:Exp_Get() / self:Exp_Max_Get()
    end
---------------------------------------------------------------------------------------------------
--- 等级系统
    function bogd_com_level_sys:Level_Set(value)
        if self.classified then
            self.classified:SetValue("bogd_level", value)
        end
    end

    function bogd_com_level_sys:Level_Get()
        if self.inst.components.bogd_com_level_sys ~= nil then
            return self.inst.components.bogd_com_level_sys.level
        elseif self.classified ~= nil then
            return self.classified.bogd_level:value()
        else
            return 1
        end
    end
---------------------------------------------------------------------------------------------------
return bogd_com_level_sys







