--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    护盾值的界面

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
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

    local Badge = require "widgets/badge"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 坐标读取
    local function GetBadgeLoation()
        local data = TUNING.BOGD_FN:Get_ThePlayer_Cross_Archived_Data("sheild_badge_location")
        if data == nil then
            return 0.5,0.5
        else
            return data.x,data.y
        end
    end
    local function SetBadgeLoation(x,y)
        TUNING.BOGD_FN:Set_ThePlayer_Cross_Archived_Data("sheild_badge_location",{x = x,y = y})
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function badge_setup(inst)
        local front_root = inst.HUD.controls.status

        if front_root.bogd_shield_badge_root then
            return
        end
        ----------------------------------------------------------------------------------------------------------------
        --- 创建根节点
            local root = front_root:AddChild(Widget())
            root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetPosition(1000,500)
            root:MoveToBack()
            -- root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC) --- 缩放模式
            -- root:SetScaleMode(SCALEMODE_FILLSCREEN) --- 缩放模式
        ----------------------------------------------------------------------------------------------------------------
        --- 创建盾牌图标
            local anim = nil
            local owner = ThePlayer
            local tint = { 255 / 255, 255 / 255, 255 / 255, 1 }
            local iconbuild = nil
            local circular_meter = true
            local use_clear_bg = true
            local dont_update_while_paused = true
            local sheild_badge = root:AddChild(Badge(anim, owner, tint, iconbuild, circular_meter, use_clear_bg, dont_update_while_paused))
            sheild_badge.circular_meter:GetAnimState():Pause() -- 暂停动画

        ----------------------------------------------------------------------------------------------------------------
        --- 图标缩放（未完成）
            function sheild_badge:RefreshScale()
                -- if TheFrontEnd then
                --     local scale = TheFrontEnd:GetHUDScale()

                --     -- local reference_badge = front_root.brain or front_root.stomach or front_root.heart
                --     -- if reference_badge then
                --     --     local temp_scale = reference_badge:GetScale()
                --     --     scale = scale*temp_scale.x
                --     -- end
                --     -- local front_root_sacle = front_root:GetScale()
                --     -- scale = scale*front_root_sacle.x

                --     sheild_badge:SetScale(scale,scale,scale)
                -- end

                -- local scale = TheFrontEnd and TheFrontEnd:GetHUDScale() or 1
                -- local front_root_sacle = front_root:GetScale()
                -- scale = scale*front_root_sacle.x
                -- sheild_badge:SetScale(scale,scale,scale)


                local reference_badge = front_root.brain or front_root.stomach or front_root.heart
                if reference_badge then
                    local scale = reference_badge.inst.UITransform:GetScale()

                    local temp_scale = TheFrontEnd and TheFrontEnd:GetHUDScale() or 1
                    scale = scale*temp_scale

                    sheild_badge:SetScale(scale,scale,scale)
                end

            end
            sheild_badge:RefreshScale()


        ----------------------------------------------------------------------------------------------------------------
        -------- 启动坐标跟随缩放循环任务，缩放的时候去到指定位置。官方好像没预留这类API，或者暂时找不到方法
            function root:LocationScaleFix()
                if self.x_percent and not self.__mouse_holding  then
                    local scrnw, scrnh = TheSim:GetScreenSize()
                    if self.____last_scrnh ~= scrnh then
                        local tarX = self.x_percent * scrnw
                        local tarY = self.y_percent * scrnh
                        self:SetPosition(tarX,tarY)

                        sheild_badge:RefreshScale()

                    end
                    self.____last_scrnh = scrnh
                end
            end
            
            root.x_percent,root.y_percent = GetBadgeLoation()
            root:LocationScaleFix()

            owner:DoPeriodicTask(2,function()
                root:LocationScaleFix()
            end)
        ----------------------------------------------------------------------------------------------------------------
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
                                    SetBadgeLoation(root.x_percent,root.y_percent)

                                end
                            end)
                    end

                end
                return old_OnMouseButton(self,button, down, x, y)
            end
        ----------------------------------------------------------------------------------------------------------------
        ---- 设置数值
            local function value_refresh()
                local current_value = inst.replica.bogd_com_level_sys:Shield_Get()
                local max_value = inst.replica.bogd_com_level_sys:Shield_Max_Get()
                sheild_badge:SetPercent(current_value/max_value,max_value)
            end
            value_refresh()
            -- inst:ListenForEvent("bogd_shield_dirty",value_refresh)
            if inst.replica.bogd_com_level_sys.classified then
                inst.replica.bogd_com_level_sys.classified:ListenForEvent("bogd_shield_dirty",value_refresh)
            end
        ----------------------------------------------------------------------------------------------------------------
        ---
            front_root.bogd_shield_badge_root = root
        ----------------------------------------------------------------------------------------------------------------

    end
    local function uninstall(inst)
        local front_root = inst.HUD.controls.status         
        if front_root.bogd_shield_badge_root then
            front_root.bogd_shield_badge_root:Kill()
            front_root.bogd_shield_badge_root = nil
            return
        end
    end
    AddPlayerPostInit(function(inst)
        -- inst:DoTaskInTime(0,function()
        --     if inst == ThePlayer and ThePlayer.HUD then
        --         badge_setup(inst)
        --     end
        -- end)
        if not TheNet:IsDedicated() then
            inst:ListenForEvent("bogd_com_level_sys_enable",function()
                if ThePlayer and ThePlayer.HUD and ThePlayer == inst then
                    badge_setup(inst)
                end
            end)
            inst:ListenForEvent("bogd_com_level_sys_disable",function()
                if ThePlayer and ThePlayer.HUD and ThePlayer == inst then
                    uninstall(inst)
                end
            end)
        end
    end)

