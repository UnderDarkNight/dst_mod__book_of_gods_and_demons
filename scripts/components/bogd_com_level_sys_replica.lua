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
            -- self.classified.bogd_enable:push()
        end
        self:EnableBroadcast()
    end
    function bogd_com_level_sys:GetEnable()
        if self.inst.components.bogd_com_level_sys then
            return self.inst.components.bogd_com_level_sys.enable
        elseif self.classified then
            return self.classified.bogd_enable:value()
        end
        return false
    end
    function bogd_com_level_sys:CheckCanEquipSpecialItem() --- 初始化加载存档的时候 GetEnable 调用错误
        if self.CheckCanEquipSpecialItemFlag == nil then
            self.inst:DoTaskInTime(0,function()
                self.CheckCanEquipSpecialItemFlag = true
            end)
            return true
        else
            return self:GetEnable()
        end
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
--- 神魔系统
    function bogd_com_level_sys:SetBodyType(value)
        if self.classified then
            self.classified.bogd_body_type:set(value)
        end
    end
    function bogd_com_level_sys:GetBodyType()
        if self.inst.components.bogd_com_level_sys ~= nil then
            return self.inst.components.bogd_com_level_sys.body_type
        elseif self.classified ~= nil then
            return self.classified.bogd_body_type:value()
        else
            return "human"
        end
    end
    function bogd_com_level_sys:IsGod()
        return self:GetBodyType() == "god"
    end
    function bogd_com_level_sys:IsDemon()
        return self:GetBodyType() == "demon"
    end
    function bogd_com_level_sys:IsHuman()
        return self:GetBodyType() == "human"
    end
    function bogd_com_level_sys:IsNotGod()
        return self:GetBodyType() ~= "god"
    end
    function bogd_com_level_sys:IsNotDemon()
        return self:GetBodyType() ~= "demon"
    end
    function bogd_com_level_sys:IsNotHuman()
        return self:GetBodyType() ~= "human"
    end
---------------------------------------------------------------------------------------------------
--- 灵宝相关API
    function bogd_com_level_sys:GetTreasureItem()
        return self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.TREASURE)
    end
---------------------------------------------------------------------------------------------------
return bogd_com_level_sys







