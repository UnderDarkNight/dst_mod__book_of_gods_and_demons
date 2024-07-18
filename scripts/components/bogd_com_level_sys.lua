----------------------------------------------------------------------------------------------------------------------------------
--[[

    等级系统

    护盾值
    经验值


]]--
----------------------------------------------------------------------------------------------------------------------------------
----
    local function GetReplicaCom(self)
        return self.inst.replica.bogd_com_level_sys or self.inst.replica._.bogd_com_level_sys
    end
    local function enable(self,flag)
        local replica_com = GetReplicaCom(self)
        if replica_com then
            replica_com:Enable(flag)
        end
    end
    local function shield_current(self,value)
        local replica_com = GetReplicaCom(self)
        if replica_com then
            replica_com:Shield_Set(value)
        end
    end
    local function shield_max(self,value)        
        local replica_com = GetReplicaCom(self)        
        if replica_com then
            replica_com:Shield_Max_Set(value)
        end
    end
    local function exp_current(self,value)        
        local replica_com = GetReplicaCom(self)        
        if replica_com then            
            replica_com:Exp_Set(value)
        end
    end
    local function exp_max(self,value)        
        local replica_com = GetReplicaCom(self)        
        if replica_com then
            replica_com:Exp_Max_Set(value)
        end
    end
    local function level(self,value)        
        local replica_com = GetReplicaCom(self)        
        if replica_com then
            replica_com:Level_Set(value)
        end
    end
    local function level_up_lock_flag(self,value)
        local replica_com = GetReplicaCom(self)
        if replica_com then
            replica_com:SetLevelUpLock(value)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
---- 根据等级，生成下一级需要的经验
    --[[
        初始等级1，初始最大经验200，每升一级按照倍率1.12倍提高最大经验
    ]]--
    local function level_up_exp_init(self)
        local current_level = self.level
        local base_exp = 200
        local ret_max_exp = 0
        for i = 1, current_level, 1 do
            if i == 1 then
                ret_max_exp = base_exp
            else
                ret_max_exp = ret_max_exp * 1.12
            end
        end
        self.exp_max = math.ceil(ret_max_exp)
    end
----------------------------------------------------------------------------------------------------------------------------------
---- 根据等级，初始化护盾值
    --[[
        1级50点护盾
        每级别+1点。突破等级锁的时候 +15点
    ]]
    local function shield_init(self)
        -- self.shield_max = self.shield_base + (self.level - 1)
        local ret_shield = self.shield_base + (self.level - 1)
        for i = 1, self.level, 1 do
            if self.level_up_locks[i] then
                ret_shield = ret_shield + 15
            end
        end        
        self.shield_max = ret_shield
    end
----------------------------------------------------------------------------------------------------------------------------------
local bogd_com_level_sys = Class(function(self, inst)
    self.inst = inst

    ---------------------------------------
    --- 初始化
        self.enable = false
    ---------------------------------------
    --- 通用数据
        self.DataTable = {}
        self.TempTable = {}
        self._onload_fns = {}
        self._onsave_fns = {}
    ---------------------------------------
    --- 护盾值
        self.shield_base = 50
        self.shield_current = 50
        self.shield_max = 50
    ---------------------------------------
    --- 经验、等级
        self.exp_current = 0
        self.exp_max = 100
        self.level = 1
        self.level_max = 79
        self.level_up_lock_flag = false
        self.level_up_locks = {}
    ---------------------------------------




end,
nil,
{
    enable = enable,
    shield_current = shield_current,
    shield_max = shield_max,
    exp_current = exp_current,
    exp_max = exp_max,
    level = level,
    level_up_lock_flag = level_up_lock_flag,

})
---------------------------------------------------------------------------------------------------
---- 总体启动
    function bogd_com_level_sys:SetEnable(flag)
        self.enable = flag
    end
    function bogd_com_level_sys:Reset() -- 重置
        local current_level = self.level

        self.enable = false
        self.shield_current = self.shield_base
        self.shield_max = self.shield_base
        self.exp_current = 0
        self.exp_max = 100
        self.level = 1
        self.level_up_lock_flag = false

        self.inst:PushEvent("bogd_level_delta",{
            old = current_level,
            new  = 1,
        })
    end
---------------------------------------------------------------------------------------------------
---- 护盾值
    function bogd_com_level_sys:Shield_DoDelta(value)
        if not self.enable then
            return
        end
        if type(value) == "number" then
            self.shield_current = math.clamp(self.shield_current + value, 0, self.shield_max)
        end
    end
    function bogd_com_level_sys:Shield_Set(value)
        if not self.enable then
            return
        end
       self.shield_current = math.clamp(value, 0, self.shield_max)
    end
    function bogd_com_level_sys:Shield_Get()
        return self.shield_current
    end
    function bogd_com_level_sys:Shield_Max_Get()
        return self.shield_max
    end
    function bogd_com_level_sys:Shield_Max_Set(value)
        if not self.enable then
            return
        end
        self.shield_max = value
    end
    -------------------------------------------------------------------------------------------
    -- ---- health value count by shield . 计算扣血量并且屏蔽
        function bogd_com_level_sys:Shield_Cost_By_Health_Down(delta_health,cause)
            if self.shield_current == 0 or delta_health >= 0 or not self.enable then
                return delta_health
            end
            --------------------------------------------------
            ---- 指定伤害类型、prefab 进行屏蔽
                local delata_reasons = {
                    ["lightning"] = true
                }
                if not delata_reasons[cause] then
                    return delta_health
                end
            --------------------------------------------------


            delta_health = math.abs(delta_health)

            ---- 如果护盾值大于等于扣血量，则扣血量全部由护盾值承担
            if self.shield_current >= delta_health then
                -- self.shield_current = self.shield_current - delta_health
                self:Shield_Set(self.shield_current - delta_health)
                self.inst:PushEvent("bogd_shield_active")
                return 0
            end

            ---- 如果护盾值小于扣血量，则扣血量由护盾值和血量共同承担
            delta_health = delta_health - self.shield_current        
            -- self.shield_current = 0
            self:Shield_Set(0)
            self.inst:PushEvent("bogd_shield_active")            
            return delta_health
        end
    -------------------------------------------------------------------------------------------
    ---- combat damage block by shield 被伤害的时候进行屏蔽
        function bogd_com_level_sys:Shield_Cost_In_Combat_GetAttacked(attacker, damage, weapon, stimuli, spdamage)
            if self.shield_current == 0 or damage <= 0 or not self.enable then
                return damage,spdamage
            end
            --- 
                -- print("+++ Shield_Cost_In_Combat_GetAttacked",attacker)
            --- 如果护盾值大于等于伤害值，则伤害值全部由护盾值承担
            if self.shield_current >= damage then
                -- self.shield_current = self.shield_current - damage
                self:Shield_Set(self.shield_current - damage)
                self.inst:PushEvent("bogd_shield_active")
                return 0,spdamage
            end
            --- 如果护盾值小于伤害值，则伤害值由护盾值和血量共同承担            
            damage = damage - self.shield_current
            -- self.shield_current = 0
            self:Shield_Set(0)
            self.inst:PushEvent("bogd_shield_active")
            return damage,spdamage
        end
    -------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---- 经验值
    function bogd_com_level_sys:Exp_DoDelta(value)
        if not self.enable then
            return
        end
        value = math.ceil(value) -- 向上取整
        local current_exp = self.exp_current
        local max_exp = self.exp_max

        local ret_exp = current_exp + value
        --- 如果没到达升级经验
        if ret_exp < max_exp then
            self.exp_current = ret_exp
            self.level_up_lock_flag = false --- 提示标记位
            return
        end
        ---- 如果到达升级经验，检查等级锁
        if not self.level_up_locks[self.level] then -- 如果没有锁
            self.exp_current = ret_exp - max_exp
            self:Level_DoDelta(1)
            if self.exp_current > self.exp_max then
                self:Exp_DoDelta(0)
            end
            return
        else                                        -- 如果锁了
            self.exp_current = self.exp_max
            self.level_up_lock_flag = true --- 提示标记位
            return
        end
    end
---------------------------------------------------------------------------------------------------
---- 等级系统、升级、降级、重置经验、
    function bogd_com_level_sys:Level_DoDelta(value,skip_event)
        local current_level = self.level
        self.level = math.clamp(current_level + value, 1, self.level_max)
        if value <= 0 then
            self.exp_current = 0
        end
        level_up_exp_init(self)
        shield_init(self)
        self.level_up_lock_flag = false --- 提示标记位
        ---------------------------------------------------------
        --- 发送升级事件
            if not skip_event then
                self.inst:PushEvent("bogd_level_delta",{
                    old = current_level,
                    new  = self.level,
                })
                if value > 0 then
                    local with_lock = self.level_up_locks[current_level] or false -- 是否跨过锁
                    self.inst:PushEvent("bogd_level_up",{
                        level = self.level,
                        last_level = current_level,
                        with_lock = with_lock,
                    })
                end
            end
        ---------------------------------------------------------
    end
    function bogd_com_level_sys:Set_Level_Lock(level)
        self.level_up_locks[level] = true
    end
    function bogd_com_level_sys:Level_Up_With_Lock_Break() -- 突破等级锁直接升级
        if self.level_up_locks[self.level] then
            self.exp_current = 0
            self:Level_DoDelta(1)
            self.inst:PushEvent("bogd_level_up_with_lock_break")
        end
    end
    function bogd_com_level_sys:Level_Locking_Warning() -- 等级锁警告
        return self.level_up_lock_flag[self.level] or false
    end
---------------------------------------------------------------------------------------------------
---- 正在渡劫标记位
    function bogd_com_level_sys:SetHealthUpBlocking(flag) -- 屏蔽回血
        self.health_up_blocking = flag
    end
    function bogd_com_level_sys:GetHealthUpBlocking() -- 是否屏蔽回血
        return self.health_up_blocking or false
    end
    function bogd_com_level_sys:SetInDanger(flag)
        self.is_in_danger = flag
    end
    function bogd_com_level_sys:IsInDanger() -- 获取是否处于危险状态
        return self.is_in_danger or false
    end
---------------------------------------------------------------------------------------------------
---- 各种参数的Get
    function bogd_com_level_sys:Shield_Get()
        return self.shield_current
    end
    function bogd_com_level_sys:Shield_Max_Get()
        return self.shield_max
    end
    function bogd_com_level_sys:Exp_Get()
        return self.exp_current
    end
    function bogd_com_level_sys:Exp_Max_Get()
        return self.exp_max
    end
    function bogd_com_level_sys:Exp_Get_Percent()
        return self.exp_current / self.exp_max
    end
    function bogd_com_level_sys:Level_Get()
        return self.level
    end
---------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function bogd_com_level_sys:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function bogd_com_level_sys:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function bogd_com_level_sys:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function bogd_com_level_sys:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
---------------------------------------------------------------------------------------------------
----- 数据读取/储存
    function bogd_com_level_sys:Get(index)
        if index then
            return self.DataTable[index]
        end
        return nil
    end
    function bogd_com_level_sys:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function bogd_com_level_sys:Add(index,num)
        if index then
            self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
            return self.DataTable[index]
        end
        return 0
    end


---------------------------------------------------------------------------------------------------
----- 数据储存到存档
    function bogd_com_level_sys:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable,
            shield_current = self.shield_current,
            shield_max = self.shield_max,
            exp_current = self.exp_current,            
            level = self.level,
            enable = self.enable,

            level_up_lock_flag = self.level_up_lock_flag,
            
        }
        return next(data) ~= nil and data or nil
    end

    function bogd_com_level_sys:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end        
        if data.shield_current then
           self.shield_current = data.shield_current
        end        
        if data.shield_max then
            self.shield_max = data.shield_max
        end        
        if data.exp_current then
            self.exp_current = data.exp_current
        end
        if data.level then
            self.level = data.level
        end
        if data.enable then
            self.enable = data.enable
        end
        if data.level_up_lock_flag then
            self.level_up_lock_flag = data.level_up_lock_flag
        end
        level_up_exp_init(self)
        self:ActiveOnLoadFns()
    end
---------------------------------------------------------------------------------------------------
-----
---------------------------------------------------------------------------------------------------
return bogd_com_level_sys







