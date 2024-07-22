----------------------------------------------------------------------------------------------------------------------------------
--[[

    灵宝系统的数据

     
]]--
----------------------------------------------------------------------------------------------------------------------------------
--  
    local function GetReplicaCom(self)
        return self.inst.replica.bogd_com_treasure or self.inst.replica._.bogd_com_treasure
    end
    local set_owner = function(self, owner)
        local replica_com = GetReplicaCom(self)
        if replica_com then
            replica_com:OnEquipped(owner)
        end
    end
    local set_level = function(self, level)
        local replica_com = GetReplicaCom(self)
        if replica_com then
            replica_com:SetLevel(level)
        end
    end
    local set_cd_time = function(self, cd_time)
        local replica_com = GetReplicaCom(self)
        if replica_com then
            replica_com:SetCDTime(cd_time)
        end
    end
    local set_cd_started = function(self,flag)
        local replica_com = GetReplicaCom(self)
        if replica_com then
            replica_com:Set_CD_Start(flag)
        end
    end
    local set_cd_time_left = function(self,cd_time_left)
        local replica_com = GetReplicaCom(self)
        if replica_com then
            replica_com:SetCDTimeLeft(cd_time_left)
        end
    end

    local set_icon = function(self)
        local replica_com = GetReplicaCom(self)
        if replica_com then
            if self.icon_atlas and self.icon then
                replica_com:SetIcon(self.icon_atlas,self.icon)
            end
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
local bogd_com_treasure = Class(function(self, inst)
    self.inst = inst

    self.level = 1
    self.max_level = 100

    self.owner = nil

    self.cd_time = 100
    self.cd_started = false
    self.cd_time_left = 0   -- 剩余CD时间

    self.icon_atlas = nil
    self.icon = nil

    -----------------------------------------------
    -- 外部激活
        inst:ListenForEvent("bogd_treasure_hotkey_press",function(_,_table)
            _table = _table or {}
            if self.owner and self.owner:HasTag("player") then
                self:CastSpell(self.owner,_table.pt)
            end
        end)
    -----------------------------------------------

end,
nil,
{
    owner = set_owner,
    cd_time = set_cd_time,
    cd_started = set_cd_started,
    cd_time_left = set_cd_time_left,
    icon_atlas = set_icon,
    icon = set_icon,
})
------------------------------------------------------------------------
-- 穿脱
    function bogd_com_treasure:OnEquipped(doer)
        self.inst:DoTaskInTime(0,function()
            if doer and doer:HasTag("player") then
                self.owner = doer
            else
                self.owner = self.inst
            end    
        end)
    end
    function bogd_com_treasure:OnUnequipped()
        self:OnEquipped(nil)
    end
------------------------------------------------------------------------
-- CD相关
    function bogd_com_treasure:SetCDTime(num)
        self.cd_time = num
    end
    function bogd_com_treasure:SetCDStart()
        if not self.cd_started then
            self.cd_started = true
            -- self.inst:DoTaskInTime(self.cd_time,function()
            --     self.cd_started = false
            -- end)
            self.cd_time_left = self.cd_time
            self.__cd_task = self.inst:DoPeriodicTask(1,function()
                self.cd_time_left = self.cd_time_left - 1
                if self.cd_time_left <= 0 then
                    self.cd_time_left = 0
                    self.cd_started = false
                    self.__cd_task:Cancel()
                end
            end)
        end
    end
    function bogd_com_treasure:CD_Onload() -- 加载的时候检查CD
        self.inst:DoTaskInTime(0,function()            
            if self.cd_started then
                self.__cd_task = self.inst:DoPeriodicTask(1,function()
                    self.cd_time_left = self.cd_time_left - 1
                    if self.cd_time_left <= 0 then
                        self.cd_time_left = 0
                        self.cd_started = false
                        self.__cd_task:Cancel()
                    end
                end)
            end
        end)
    end
------------------------------------------------------------------------
-- icon
    function bogd_com_treasure:SetIcon(atlas,icon)
        self.icon_atlas = atlas
        self.icon = icon
    end
------------------------------------------------------------------------
-- spell
    function bogd_com_treasure:SetSpellFn(fn)
        if type(fn) == "function" then
            self.spell_fn = fn
        end
    end
    function bogd_com_treasure:CastSpell(doer,pt)
        self.inst:DoTaskInTime(0,function()            
            if self.spell_fn and not doer:HasTag("playerghost") and not self.cd_started then
                self.spell_fn(self.inst,doer,pt)
            end
        end)
    end
------------------------------------------------------------------------
-- level 相关
    function bogd_com_treasure:SetLevel(num)
        self.level = math.clamp(num,1,self.max_level)
        self:LevelUpdate()
    end
    function bogd_com_treasure:LevelDoDelta(num)
        local old_level = self.level
        self:SetLevel(self.level + num)
    end
    function bogd_com_treasure:SetLevelUpdateFn(fn)
        if type(fn) == "function" then
            self.level_update_fn = fn
        end
    end
    function bogd_com_treasure:LevelUpdate()
        if self.level_update_fn then
            self.level_update_fn(self.inst,self.level)
        end
    end
------------------------------------------------------------------------
-- 储存/读取
    function bogd_com_treasure:OnSave()
        local data =
        {
            level = self.level,
            cd_time_left = self.cd_time_left,
            cd_started = self.cd_started,
        }
        return next(data) ~= nil and data or nil
    end

    function bogd_com_treasure:OnLoad(data)
        data = data or {}
        if data.level then
            self.level = data.level
        end
        if data.cd_time_left then
            self.cd_time_left = data.cd_time_left
        end
        if data.cd_started then
            self.cd_started = data.cd_started
        end

        self:CD_Onload()
        self:LevelUpdate()
    end
------------------------------------------------------------------------
return bogd_com_treasure