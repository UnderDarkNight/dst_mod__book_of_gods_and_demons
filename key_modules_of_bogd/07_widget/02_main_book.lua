------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 坐标读取
    local function GetBadgeLoation()
        local data = TUNING.BOGD_FN:Get_ThePlayer_Cross_Archived_Data("main_book_location")
        if data == nil then
            return 0.05,0.93
        else
            return data.x,data.y
        end
    end
    local function SetBadgeLoation(x,y)
        TUNING.BOGD_FN:Set_ThePlayer_Cross_Archived_Data("main_book_location",{x = x,y = y})
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 主按钮
    AddPlayerPostInit(function(inst)
        inst:DoTaskInTime(1,function()
            if ThePlayer == inst and inst.HUD then                
                local front_root = ThePlayer.HUD
                ----------------------------------------------------------------------
                --- 根节点
                    local root = front_root:AddChild(Widget())
                    root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
                    root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
                    root:SetPosition(50,50)
                    -- root:MoveToBack()
                    root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC) --- 缩放模式
                ----------------------------------------------------------------------
                --- 按钮
                    local main_scale = 0.5
            
                    local main_button = root:AddChild(ImageButton(
                        "images/book/book_of_gods_and_demons.xml",
                        "main.tex",
                        "main.tex",
                        "main.tex",
                        "main.tex",
                        "main.tex"
                    ))
                    main_button:SetScale(main_scale,main_scale,main_scale)
                    main_button:SetOnDown(function()
                        ThePlayer:PushEvent("bogd_event.book_open")
                    end)
                ----------------------------------------------------------------------
                --- 缩放控制
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
                    
                    root.x_percent,root.y_percent = GetBadgeLoation()
                    root:LocationScaleFix()
        
                    root.inst:DoPeriodicTask(2,function()
                        root:LocationScaleFix()
                    end)
                ----------------------------------------------------------------------
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
                ----------------------------------------------------------------------
            end
        end)
    end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    AddPlayerPostInit(function(inst)
        inst:DoTaskInTime(1,function()
            if ThePlayer == inst and inst.HUD then                
                inst:ListenForEvent("bogd_event.book_open",function()
                    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                        local front_root = ThePlayer.HUD
                    ------------------------------------------------------------------------------------
                    --- 主节点
                        local root = front_root:AddChild(Widget())
                        root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
                        root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
                        root:SetPosition(0,0)
                        -- root:MoveToBack()
                        root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC) --- 缩放模式
                        local main_scale = 0.6
                    ------------------------------------------------------------------------------------
                    --- 背景
                        local bg = root:AddChild(Image())
                        bg:SetTexture("images/book/book_of_gods_and_demons.xml","background.tex")
                        bg:SetScale(main_scale,main_scale,main_scale)

                    ------------------------------------------------------------------------------------
                    --- 关闭按钮
                        local close_button = root:AddChild(ImageButton(
                            "images/book/book_of_gods_and_demons.xml",
                            "close.tex",
                            "close.tex",
                            "close.tex",
                            "close.tex",
                            "close.tex"
                        ))
                        close_button:SetScale(main_scale,main_scale,main_scale)
                        close_button:SetOnDown(function()
                            root:Kill()
                        end)
                        close_button:SetPosition(500,200)
                    ------------------------------------------------------------------------------------
                    --- 开始修仙按钮
                        local start_button = root:AddChild(ImageButton(
                            "images/book/book_of_gods_and_demons.xml",
                            "start.tex",
                            "start.tex",
                            "start.tex",
                            "start.tex",
                            "start.tex"
                        ))
                        start_button:SetScale(main_scale,main_scale,main_scale)
                        start_button:SetOnDown(function()
                            ThePlayer.replica.bogd_com_rpc_event:PushEvent("bogd_event.book_cmd_start")
                            root:Kill()
                        end)
                        start_button:SetPosition(-275,158)
                    ------------------------------------------------------------------------------------
                    --- 停止修仙按钮
                        local stop_button = root:AddChild(ImageButton(
                            "images/book/book_of_gods_and_demons.xml",
                            "stop.tex",
                            "stop.tex",
                            "stop.tex",
                            "stop.tex",
                            "stop.tex"
                        ))
                        stop_button:SetScale(main_scale,main_scale,main_scale)
                        stop_button:SetOnDown(function()
                            ThePlayer.replica.bogd_com_rpc_event:PushEvent("bogd_event.book_cmd_stop")
                            root:Kill()
                        end)
                        stop_button:SetPosition(280,158)
                    ------------------------------------------------------------------------------------
                    --- 二维码
                        local qrcode_base_scale = 0.4
                        local qrcode_scale = qrcode_base_scale * main_scale
                        local qrcode = root:AddChild(Image())
                        qrcode:SetTexture("images/book/book_of_gods_and_demons.xml","qrcode.tex")
                        qrcode:SetScale(qrcode_scale,qrcode_scale,qrcode_scale)
                        qrcode:SetPosition(460,-200)
                        qrcode.OnGainFocus = function()
                            qrcode:SetScale(main_scale,main_scale,main_scale)
                            qrcode:SetPosition(440,-130)
                        end
                        qrcode.OnLoseFocus = function()
                            qrcode:SetScale(qrcode_scale,qrcode_scale,qrcode_scale)
                            qrcode:SetPosition(460,-200)
                        end
                    ------------------------------------------------------------------------------------
                    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                end)
            end
        end)
    end)