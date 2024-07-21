----------------------------------------------------------------------------------------------------------------------------------
--[[

    灵宝系统的数据

     
]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"
    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local TextButton = require "widgets/textbutton"
    local UIAnimButton = require "widgets/uianimbutton"
    local Button = require "widgets/button"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
----------------------------------------------------------------------------------------------------------------------------------
--- 创建HUD
    local function GetHUDLoation()
        local data = TUNING.BOGD_FN:Get_ThePlayer_Cross_Archived_Data("treasure_location")
        if data == nil then
            return 0.5,0.5
        else
            return data.x,data.y
        end
    end
    local function SetHUDLoation(x,y)
        TUNING.BOGD_FN:Set_ThePlayer_Cross_Archived_Data("treasure_location",{x = x,y = y})
    end
    local function CreateHud(inst)
        local front_root = ThePlayer.HUD.controls.status
        -----------------------------------------------------------------------------
        --- 参数表
            local level = inst.replica.bogd_com_treasure:GetLevel()
            local name = inst:GetDisplayName()
            local icon_atlas,icon = inst.replica.bogd_com_treasure:GetIcon()
            local main_scale = 0.4
        -----------------------------------------------------------------------------
        --- root 节点
            local root = front_root:AddChild(Widget())
            root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetPosition(1000,500)
            root:MoveToBack()
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC) --- 缩放模式
        -----------------------------------------------------------------------------
        -------- 启动坐标跟随缩放循环任务，缩放的时候去到指定位置。官方好像没预留这类API，或者暂时找不到方法
            function root:LocationScaleFix()
                if self.x_percent and not self.__mouse_holding  then
                    local scrnw, scrnh = TheSim:GetScreenSize()
                    if self.____last_scrnh ~= scrnh then
                        local tarX = self.x_percent * scrnw
                        local tarY = self.y_percent * scrnh
                        self:SetPosition(tarX,tarY)
                    end
                    self.____last_scrnh = scrnh
                end
            end
            
            root.x_percent,root.y_percent = GetHUDLoation()
            root:LocationScaleFix()

            root.inst:DoPeriodicTask(2,function()
                root:LocationScaleFix()
            end)
        -----------------------------------------------------------------------------
        ---- 鼠标拖动
            local old_OnMouseButton = root.OnMouseButton
            root.OnMouseButton = function(self,button, down, x, y)
                if down then

                    if not root.__mouse_holding  then
                        root.__mouse_holding = true      --- 上锁
                            --------- 添加鼠标移动监听任务
                            root.___follow_mouse_event = TheInput:AddMoveHandler(function(x, y)  
                                root:SetPosition(x,y,0)
                            end)
                            --------- 添加鼠标按钮监听
                            root.___mouse_button_up_event = TheInput:AddMouseButtonHandler(function(button, down, x, y) 
                                if button == MOUSEBUTTON_LEFT and down == false then    ---- 左键被抬起来了
                                    root.___mouse_button_up_event:Remove()       ---- 清掉监听
                                    root.___mouse_button_up_event = nil

                                    root.___follow_mouse_event:Remove()          ---- 清掉监听
                                    root.___follow_mouse_event = nil

                                    root:SetPosition(x,y,0)                      ---- 设置坐标
                                    root.__mouse_holding = false                 ---- 解锁

                                    local scrnw, scrnh = TheSim:GetScreenSize()
                                    root.x_percent = x/scrnw
                                    root.y_percent = y/scrnh

                                    -- owner:PushEvent("bogd_wellness_bars.save_cmd",{    --- 发送储存坐标。
                                    --     pt = {x_percent = root.x_percent,y_percent = root.y_percent},
                                    -- })
                                    SetHUDLoation(root.x_percent,root.y_percent)

                                end
                            end)
                    end

                end
                return old_OnMouseButton(self,button, down, x, y)
            end
        -----------------------------------------------------------------------------
        --- 图标
            if icon_atlas ~= nil and icon ~= nil then
                local background = root:AddChild(Image(icon_atlas,icon))
                background:SetScale(main_scale,main_scale,main_scale)
            end
        -----------------------------------------------------------------------------
        --- 名字
            local DisplayName = root:AddChild(Text(TITLEFONT,25,"3000/3000",{ 255/255 , 255/255 ,255/255 , 1}))
            DisplayName:SetPosition(0,45)
            DisplayName:SetString(tostring(name))
        -----------------------------------------------------------------------------
        --- 等级
            local DisplayLevel = root:AddChild(Text(TITLEFONT,25,"3000/3000",{ 0/255 , 0/255 ,0/255 , 1}))
            DisplayLevel:SetPosition(0,0)
            DisplayLevel:SetString("Lv."..tostring(level))
        -----------------------------------------------------------------------------
        --- CD 
            local DisplayCD = root:AddChild(Text(TITLEFONT,20,"3000/3000",{ 255/255 , 255/255 ,255/255 , 1}))
            DisplayCD:SetPosition(0,-45)
            -- DisplayCD:SetString("CD:"..tostring(cd_time))
            DisplayCD:Hide()
        -----------------------------------------------------------------------------
        --- CD
            root.inst:ListenForEvent("treasure_hud_update",function()
                -- local cd_time = inst.replica.bogd_com_treasure:GetCDTime()
                local cd_time_left = inst.replica.bogd_com_treasure:GetCDTimeLeft()
                if cd_time_left > 0 then
                    DisplayCD:Show()
                    DisplayCD:SetString("CD : "..tostring(cd_time_left))
                else
                    DisplayCD:Hide()
                end
            end,inst)
        -----------------------------------------------------------------------------
        --- 其他显示参数
            root.inst:ListenForEvent("update",function()
                level = inst.replica.bogd_com_treasure:GetLevel()
                DisplayLevel:SetString("Lv."..tostring(level))    
            end)
        -----------------------------------------------------------------------------
        return root
    end
----------------------------------------------------------------------------------------------------------------------------------
local bogd_com_treasure = Class(function(self, inst)
    self.inst = inst

    self.level = 1
    self.owner = nil
    
    self.cd_time = 100
    self.cd_started = false
    self.cd_time_left = 0

    self.HUD = nil

    self.icon_atlas = nil
    self.icon = nil

    -----------------------------------------------------------
    -- net_vars
        self.__level = net_ushortint(inst.GUID, "treasure_level","treasure_dirty")
        self.__owner = net_entity(inst.GUID, "treasure_owner","treasure_dirty")
        self.__cd_time = net_ushortint(inst.GUID, "treasure_cd_time","treasure_dirty")
        self.__cd_started = net_bool(inst.GUID, "treasure_cd_started","treasure_dirty")
        self.__cd_time_left = net_ushortint(inst.GUID, "treasure_cd_time_left","treasure_dirty")

        self.__icon_atlas = net_string(inst.GUID, "treasure_icon_atlas","treasure_dirty")
        self.__icon = net_string(inst.GUID, "treasure_icon","treasure_dirty")
    -----------------------------------------------------------
    -- 数据同步
        inst:ListenForEvent("treasure_dirty",function()
            self.level = self.__level:value()

            -----------------------------------------------
            --
                local temp_owner = self.__owner:value()
                if temp_owner == nil or temp_owner == self.inst then
                    self.inst:PushEvent("treasure_unequipped")

                    if ThePlayer and ThePlayer.HUD and ThePlayer == self.owner then
                        self.inst:PushEvent("treasure_unequipped_client")                        
                    end

                    self.owner = nil

                elseif temp_owner and temp_owner:HasTag("player") and self.owner ~= temp_owner then
                    self.inst:PushEvent("trueasure_equipped",temp_owner)
                    self.owner = temp_owner

                    if ThePlayer and ThePlayer.HUD and ThePlayer == temp_owner then
                        self.inst:DoTaskInTime(0,function()
                            self.inst:PushEvent("trueasure_equipped_client",temp_owner)                            
                        end)
                    end
                end
            -----------------------------------------------
            -- cd
                self.cd_time = self.__cd_time:value()
                self.cd_time_left = self.__cd_time_left:value()
                local temp_cd_started = self.__cd_started:value()
                if self.cd_started ~= temp_cd_started and temp_cd_started == true then
                    self.inst:PushEvent("cd_start",self.cd_time)
                end
                self.cd_started = temp_cd_started
            -----------------------------------------------
            -- icon
                self.icon_atlas = self.__icon_atlas:value()
                self.icon = self.__icon:value()
            -----------------------------------------------
            -- 刷新界面
                if ThePlayer and ThePlayer.HUD and self.HUD then
                    self.inst:PushEvent("treasure_hud_update")
                end
            -----------------------------------------------
        end)
    -----------------------------------------------------------
    -- UI 安装
        self.inst:ListenForEvent("trueasure_equipped_client",function(_,owner)
            -- if owner.__test_fn then
            --     self.HUD = owner.__test_fn(self.inst)
            -- end
            self.HUD = CreateHud(self.inst)
            if self.HUD then
                self.inst:PushEvent("treasure_hud_created",self.HUD)
            end
        end)
        self.inst:ListenForEvent("treasure_unequipped_client",function()
            if self.HUD then
                self.HUD:Kill()
            end
        end)
        self.inst:ListenForEvent("onremove",function()
            if self.HUD then
                self.HUD:Kill()
            end
        end)
    -----------------------------------------------------------

end)
------------------------------------------------------------------------
-- 等级
    function bogd_com_treasure:SetLevel(num)
        self.__level:set(num)
        -- self.__level:push()
    end
    function bogd_com_treasure:GetLevel()
        return self.level
    end
------------------------------------------------------------------------
-- 穿脱
    function bogd_com_treasure:OnEquipped(doer)
        self.inst:DoTaskInTime(0,function()
            if doer and doer:HasTag("player") then
                self.__owner:set(doer)
                -- self.__owner:push()
            else
                self.__owner:set(self.inst) -- 释放
                -- self.__owner:push()
            end            
        end)
    end
    function bogd_com_treasure:OnUnequipped()
        self:OnEquipped(nil)
    end
------------------------------------------------------------------------
--- CD
    function bogd_com_treasure:SetCDTime(num)
        self.__cd_time:set(num)
    end
    function bogd_com_treasure:Set_CD_Start(flag)
        self.__cd_started:set(flag)
        -- self.__cd_started:push()
    end
    function bogd_com_treasure:Is_CD_Started()
        return self.cd_started
    end
    function bogd_com_treasure:GetCDTime()
        return self.cd_time
    end
    function bogd_com_treasure:SetCDTimeLeft(num)
        self.__cd_time_left:set(num)
    end
    function bogd_com_treasure:GetCDTimeLeft()
        return self.cd_time_left
    end
------------------------------------------------------------------------
--- icon
    function bogd_com_treasure:SetIcon(atlas,icon)
        self.__icon_atlas:set(atlas)
        self.__icon:set(icon)
        if atlas and icon then
            -- self.__icon:push()
            -- self.__icon_atlas:push()
        end
    end
    function bogd_com_treasure:GetIcon()
        if self.__icon_atlas and self.__icon then
            return self.icon_atlas,self.icon
        end
        return nil,nil
    end
------------------------------------------------------------------------

return bogd_com_treasure