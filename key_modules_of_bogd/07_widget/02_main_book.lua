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
--- 主按钮
    AddPlayerPostInit(function(inst)
        inst:DoTaskInTime(1,function()
            if ThePlayer == inst and inst.HUD then                
                local front_root = ThePlayer.HUD

                local root = front_root:AddChild(Widget())
                root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
                root:SetVAnchor(1) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
                root:SetPosition(80,-80)
                root:MoveToBack()
                root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC) --- 缩放模式
        
                local main_scale = 0.6
        
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
                        root:MoveToBack()
                        root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC) --- 缩放模式
                        local main_scale = 0.7
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
                        close_button:SetPosition(400,200)
                    ------------------------------------------------------------------------------------
                    --- 开始修仙按钮
                        local close_button = root:AddChild(ImageButton(
                            "images/book/book_of_gods_and_demons.xml",
                            "start.tex",
                            "start.tex",
                            "start.tex",
                            "start.tex",
                            "start.tex"
                        ))
                        close_button:SetScale(main_scale,main_scale,main_scale)
                        close_button:SetOnDown(function()
                            ThePlayer.replica.bogd_com_rpc_event:PushEvent("bogd_event.book_cmd_start")
                            root:Kill()
                        end)
                        close_button:SetPosition(-300,0)
                    ------------------------------------------------------------------------------------
                    --- 停止修仙按钮
                        local close_button = root:AddChild(ImageButton(
                            "images/book/book_of_gods_and_demons.xml",
                            "stop.tex",
                            "stop.tex",
                            "stop.tex",
                            "stop.tex",
                            "stop.tex"
                        ))
                        close_button:SetScale(main_scale,main_scale,main_scale)
                        close_button:SetOnDown(function()
                            ThePlayer.replica.bogd_com_rpc_event:PushEvent("bogd_event.book_cmd_stop")
                            root:Kill()
                        end)
                        close_button:SetPosition(300,0)
                    ------------------------------------------------------------------------------------
                    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                end)
            end
        end)
    end)