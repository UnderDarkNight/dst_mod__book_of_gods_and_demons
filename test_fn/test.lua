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
        -- print(ThePlayer.replica.bogd_com_level_sys.classified)
        -- print(ThePlayer.player_classified)

        -- inst.components.lootdropper.GetFullRecipeLoot = function(...)
        --     return {}
        -- end
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- print(TheFrontEnd:GetHUDScale())
        -- print(TheFrontEnd:GetProportionalHUDScale())
        -- local front_root =  ThePlayer.HUD.controls.status
        -- print(front_root:GetScale())
        -- local reference_badge = front_root.brain or front_root.stomach or front_root.heart
        -- print(reference_badge:GetScale())
        -- -- print(reference_badge.inst.UITransform:GetScale())
        -- -- print(reference_badge.UITransform,type(reference_badge.UITransform))

        -- local temp_UITransform = getmetatable(reference_badge.inst.UITransform).__index
        -- print(temp_UITransform)
        -- for k, v in pairs(temp_UITransform) do
        --     print(k,v)
        -- end
    ----------------------------------------------------------------------------------------------------------------
    -- ---
        -- ThePlayer.components.bogd_com_rpc_event:PushEvent("bogd_event.whisper",{
        --     m_colour = {255/255,100/255,100/255},
        --     message = "玩家境界提升",
        --     sender_name = "󰀏󰀏󰀏",
        --     -- icondata = "emoji_abigail",
        -- })
    ----------------------------------------------------------------------------------------------------------------
    ---
            -- ThePlayer.components.bogd_com_level_sys:Level_DoDelta(41)
    ----------------------------------------------------------------------------------------------------------------
    --- 月亮风暴测试
            -- local MoonstormDustOver = require("widgets/moonstormdustover")

            -- if ThePlayer.test_hud then
            --     ThePlayer.test_hud:Kill()
            -- end
            -- local inst = ThePlayer


            -- local storm = inst.HUD:AddChild(MoonstormDustOver(inst))
            -- storm:MoveToBack()
            -- local fx = storm:AddChild(UIAnim())
            -- fx:GetAnimState():SetBank("moonstorm_over_static")
            -- fx:GetAnimState():SetBuild("moonstorm_over_static")
            -- fx:GetAnimState():PlayAnimation("static_loop",true)

            -- storm:GetAnimState():SetMultColour(255,0,0,1)

            -- ThePlayer.test_hud = storm
    ----------------------------------------------------------------------------------------------------------------
    --- 
        -- TheWorld:PushEvent("ms_sendlightningstrike",Vector3(x,y,z))
        -- ThePlayer:SpawnChild("bogd_sfx_terra_beam"):PushEvent("Set",{
        --     pt = Vector3(0,-1,0),
        --     end_time = 5,
        --     end_fn = function()
        --         print("info  beam fx end")
        --     end,
        -- })
    ----------------------------------------------------------------------------------------------------------------
    ----手册
        -- print(ThePlayer.entity:GetParent())
        -- local front_root = ThePlayer.HUD
        --------------------------------------------------------------
        -- if front_root.test_root then
        --     front_root.test_root:Kill()
        -- end

        -- local root = front_root:AddChild(Widget())
        -- root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
        -- root:SetVAnchor(1) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
        -- root:SetPosition(80,-80)
        -- root:MoveToBack()
        -- root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC) --- 缩放模式

        -- local main_scale = 0.6

        -- local main_button = root:AddChild(ImageButton(
        --     "images/book/book_of_gods_and_demons.xml",
        --     "main.tex",
        --     "main.tex",
        --     "main.tex",
        --     "main.tex",
        --     "main.tex"
        -- ))
        -- main_button:SetScale(main_scale,main_scale,main_scale)
        -- main_button:SetOnDown(function()
        --     print("+++++++++++++++++++++++++")
        -- end)
        -- front_root.test_root = root
        --------------------------------------------------------------

        -- ThePlayer.__test_fn = function()
            

        --     local front_root = ThePlayer.HUD

        --     ------------------------------------------------------------------------------------
        --     --- 主节点
        --         local root = front_root:AddChild(Widget())
        --         root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
        --         root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
        --         root:SetPosition(0,0)
        --         -- root:MoveToBack()
        --         root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC) --- 缩放模式
        --         local main_scale = 0.6
        --     ------------------------------------------------------------------------------------
        --     --- 背景
        --         local bg = root:AddChild(Image())
        --         bg:SetTexture("images/book/book_of_gods_and_demons.xml","background.tex")
        --         bg:SetScale(main_scale,main_scale,main_scale)

        --     ------------------------------------------------------------------------------------
        --     --- 关闭按钮
        --         local close_button = root:AddChild(ImageButton(
        --             "images/book/book_of_gods_and_demons.xml",
        --             "close.tex",
        --             "close.tex",
        --             "close.tex",
        --             "close.tex",
        --             "close.tex"
        --         ))
        --         close_button:SetScale(main_scale,main_scale,main_scale)
        --         close_button:SetOnDown(function()
        --             root:Kill()
        --         end)
        --         close_button:SetPosition(500,200)
        --     ------------------------------------------------------------------------------------
        --     --- 开始修仙按钮
        --         local start_button = root:AddChild(ImageButton(
        --             "images/book/book_of_gods_and_demons.xml",
        --             "start.tex",
        --             "start.tex",
        --             "start.tex",
        --             "start.tex",
        --             "start.tex"
        --         ))
        --         start_button:SetScale(main_scale,main_scale,main_scale)
        --         start_button:SetOnDown(function()
        --             ThePlayer.replica.bogd_com_rpc_event:PushEvent("bogd_event.book_cmd_start")
        --         end)
        --         start_button:SetPosition(-275,158)
        --     ------------------------------------------------------------------------------------
        --     --- 停止修仙按钮
        --         local stop_button = root:AddChild(ImageButton(
        --             "images/book/book_of_gods_and_demons.xml",
        --             "stop.tex",
        --             "stop.tex",
        --             "stop.tex",
        --             "stop.tex",
        --             "stop.tex"
        --         ))
        --         stop_button:SetScale(main_scale,main_scale,main_scale)
        --         stop_button:SetOnDown(function()
        --             ThePlayer.replica.bogd_com_rpc_event:PushEvent("bogd_event.book_cmd_stop")

        --         end)
        --         stop_button:SetPosition(280,158)
        --     ------------------------------------------------------------------------------------
        --     --- 二维码
        --         local qrcode_base_scale = 0.4
        --         local qrcode_scale = qrcode_base_scale * main_scale
        --         local qrcode = root:AddChild(Image())
        --         qrcode:SetTexture("images/book/book_of_gods_and_demons.xml","qrcode.tex")
        --         qrcode:SetScale(qrcode_scale,qrcode_scale,qrcode_scale)
        --         qrcode:SetPosition(460,-200)
        --         qrcode.OnGainFocus = function()
        --             qrcode:SetScale(main_scale,main_scale,main_scale)
        --             qrcode:SetPosition(440,-130)
        --         end
        --         qrcode.OnLoseFocus = function()
        --             qrcode:SetScale(qrcode_scale,qrcode_scale,qrcode_scale)
        --             qrcode:SetPosition(460,-200)
        --         end
        --     ------------------------------------------------------------------------------------

        --     ThePlayer:DoTaskInTime(3,function()
        --         root:Kill()
        --     end)
        -- end
        -- ThePlayer.__test_fn()
    ----------------------------------------------------------------------------------------------------------------
    --- 灵宝界面
        -- ThePlayer.__test_fn = function(inst)



        --     local front_root = ThePlayer.HUD.controls.status
        --     -----------------------------------------------------------------------------
        --     --- 参数表
        --         local level = inst.replica.bogd_com_treasure:GetLevel()
        --         local name = inst:GetDisplayName()
        --         local icon_atlas,icon = inst.replica.bogd_com_treasure:GetIcon()
        --         local main_scale = 0.4
        --     -----------------------------------------------------------------------------
        --     --- root 节点
        --         local root = front_root:AddChild(Widget())
        --         root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
        --         root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
        --         root:SetPosition(1000,500)
        --         root:MoveToBack()
        --         root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC) --- 缩放模式
        --     -----------------------------------------------------------------------------
        --     --- 图标
        --         if icon_atlas ~= nil and icon ~= nil then
        --             local background = root:AddChild(Image(icon_atlas,icon))
        --             background:SetScale(main_scale,main_scale,main_scale)
        --         end
        --     -----------------------------------------------------------------------------
        --     --- 名字
        --         local DisplayName = root:AddChild(Text(TITLEFONT,25,"3000/3000",{ 255/255 , 255/255 ,255/255 , 1}))
        --         DisplayName:SetPosition(0,45)
        --         DisplayName:SetString(tostring(name))
        --     -----------------------------------------------------------------------------
        --     --- 等级
        --         local DisplayLevel = root:AddChild(Text(TITLEFONT,25,"3000/3000",{ 0/255 , 0/255 ,0/255 , 1}))
        --         DisplayLevel:SetPosition(0,0)
        --         DisplayLevel:SetString("Lv."..tostring(level))
        --     -----------------------------------------------------------------------------
        --     --- CD 
        --         local DisplayCD = root:AddChild(Text(TITLEFONT,20,"3000/3000",{ 255/255 , 255/255 ,255/255 , 1}))
        --         DisplayCD:SetPosition(0,-45)
        --         -- DisplayCD:SetString("CD:"..tostring(cd_time))
        --         DisplayCD:Hide()
        --     -----------------------------------------------------------------------------
        --     --- CD
        --         root.inst:ListenForEvent("treasure_hud_update",function()
        --             -- local cd_time = inst.replica.bogd_com_treasure:GetCDTime()
        --             local cd_time_left = inst.replica.bogd_com_treasure:GetCDTimeLeft()
        --             if cd_time_left > 0 then
        --                 DisplayCD:Show()
        --                 DisplayCD:SetString("CD : "..tostring(cd_time_left))
        --             else
        --                 DisplayCD:Hide()
        --             end
        --         end,inst)
        --     -----------------------------------------------------------------------------
        --     --- 其他显示参数
        --         root.inst:ListenForEvent("update",function()
        --             level = inst.replica.bogd_com_treasure:GetLevel()
        --             DisplayLevel:SetString("Lv."..tostring(level))    
        --         end)
        --     -----------------------------------------------------------------------------




        --     return root
        -- end
    ----------------------------------------------------------------------------------------------------------------
    ---
            -- local item = ThePlayer.components.inventory:GetEquippedItem(EQUIPSLOTS.TREASURE)
            -- item:Remove()
            -- ThePlayer.components.bogd_com_level_sys:OnBecomeGod()
            -- ThePlayer.components.bogd_com_level_sys:OnBecomeDemon()
            -- ThePlayer.components.bogd_com_level_sys:OnBecomeHuman()

            -- print(ThePlayer.replica.bogd_com_level_sys:GetBodyType())
    ----------------------------------------------------------------------------------------------------------------
    ---
            -- ThePlayer.SoundEmitter:PlaySound("dontstarve/music/music_work_ruins")
            -- ThePlayer.SoundEmitter:PlaySound("dontstarve/impacts/impact_forcefield_armour_dull")
            -- ThePlayer.SoundEmitter:PlaySound("rifts3/mutated_varg/blast_pre_f17")
            -- local inst = ThePlayer:SpawnChild("bogd_sfx_green_snap")
            -- inst:PushEvent("Set",{
            --     pt = Vector3(0,4.5,0),
            --     color = Vector3(1,1,1),
            --     a = 0.8,
            --     MultColour_Flag = true,
            -- })

            -- inst:DoTaskInTime(5,inst.Remove)
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- local item = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.TREASURE)
        -- item:PushEvent("treasure_hud_update")
        ThePlayer.components.bogd_com_level_sys:Exp_DoDelta(1000000000000000)
        -- ThePlayer.components.bogd_com_level_sys:Level_DoDelta(55)
        -- ThePlayer.components.bogd_com_level_sys:Level_Up_With_Lock_Break()

    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))