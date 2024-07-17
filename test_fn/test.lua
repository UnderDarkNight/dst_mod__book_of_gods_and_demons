--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 界面调试
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

    local SkinsPuppet = require "widgets/skinspuppet"

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local flg,error_code = pcall(function()
    print("WARNING:PCALL START +++++++++++++++++++++++++++++++++++++++++++++++++")
    local x,y,z =    ThePlayer.Transform:GetWorldPosition()  
    ----------------------------------------------------------------------------------------------------------------
    ----



        -- local front_root = ThePlayer.HUD.controls.status

        -- local hunger_root = front_root.stomach
        -- -- local temp_pt = hunger_root:GetPosition()
        -- print(ThePlayer.HUD.controls.status:GetScale())


        -- if front_root.__test_badge then
        --     front_root.__test_badge:Kill()
        --     front_root.__test_badge = nil
        -- end


        -------------------------------------------------------------
        ---
            -- local root = front_root:AddChild(Widget())
            -- root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            -- root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            -- root:SetPosition(1000,500)
            -- root:MoveToBack()
            -- root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC) --- 缩放模式
        -------------------------------------------------------------

        -- local anim = nil
        -- local owner = ThePlayer
        -- local tint = { 255 / 255, 255 / 255, 255 / 255, 1 }
        -- local iconbuild = nil
        -- local circular_meter = true
        -- local use_clear_bg = true
        -- local dont_update_while_paused = true
        -- local sheild_badge = root:AddChild(Badge(anim, owner, tint, iconbuild, circular_meter, use_clear_bg, dont_update_while_paused))


        -- root:SetPosition(temp_pt.x-50, temp_pt.y, temp_pt.z)
        -- sheild_badge:SetPosition(0,0,0)

        

        -- front_root.__test_badge = root
    ----------------------------------------------------------------------------------------------------------------
    --- 
            -- ThePlayer.components.bogd_com_level_sys:SetEnable(true)
        -- print(ThePlayer.components.bogd_com_level_sys)
        -- ThePlayer.components.bogd_com_level_sys:Shield_DoDelta(100)
        -- print(ThePlayer.replica.bogd_com_level_sys:Shield_Get())
        -- print(ThePlayer.replica.bogd_com_level_sys.classified)
    ----------------------------------------------------------------------------------------------------------------
    --- 经验条
        -- local front_root = ThePlayer.HUD.controls.status


        -- if front_root.__exp_bar then
        --     front_root.__exp_bar:Kill()
        --     front_root.__exp_bar = nil
        -- end

        -- ----------------------------------------------------------------------------------
        -- --- 
        --     local main_scale = 0.7
        -- ----------------------------------------------------------------------------------
        -- --- 
        --     local root = front_root:AddChild(Widget())
        --     root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
        --     root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
        --     root:SetPosition(1000,500)
        --     root:MoveToBack()
        --     root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC) --- 缩放模式
        -- ----------------------------------------------------------------------------------
        -- ---
        --     local exp_bar = root:AddChild(UIAnim())
        --     exp_bar:SetScale(main_scale,main_scale,main_scale)
        --     local exp_bar_anim = exp_bar:GetAnimState()
        --     exp_bar_anim:SetBank("bogd_hud_exp_bar")
        --     exp_bar_anim:SetBuild("bogd_hud_exp_bar")
        --     exp_bar_anim:PlayAnimation("idle",true)
        -- ----------------------------------------------------------------------------------
        -- --- 
        --     local text = root:AddChild(Text(TITLEFONT,30,"3000/3000",{ 255/255 , 255/255 ,255/255 , 1}))
        --     text:SetPosition(25,30)
        --     text:SetString("筑基中期")
        -- ----------------------------------------------------------------------------------
        -- --- 
        --     local level_text = root:AddChild(Text(TITLEFONT,20,"3000/3000",{ 255/255 , 255/255 ,255/255 , 1}))
        --     level_text:SetPosition(-40,28)
        --     level_text:SetString("Lv.01")
        -- ----------------------------------------------------------------------------------
        -- --- 
        --     local exp_text = root:AddChild(Text(CODEFONT,25,"3000/3000",{ 0/255 , 0/255 ,0/255 , 0.5}))
        --     exp_text:SetPosition(0,0)
        --     exp_text:SetString("1500/3000")
        -- ----------------------------------------------------------------------------------
        -- --- warning flag
        --     local warning = root:AddChild(UIAnim())
        --     local warning_anim = warning:GetAnimState()
        --     warning_anim:SetBank("bogd_hud_exp_bar")
        --     warning_anim:SetBuild("bogd_hud_exp_bar")
        --     warning_anim:PlayAnimation("warning",true)
        --     warning:SetScale(main_scale,main_scale,main_scale)
        --     warning:SetPosition(0,-50)
        --     warning:Hide()
        -- ----------------------------------------------------------------------------------






        -- front_root.__exp_bar = root
    ----------------------------------------------------------------------------------------------------------------
    ---
        print(ThePlayer.replica.bogd_com_level_sys.classified)
        print(ThePlayer.player_classified)
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))