--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    1-3级 : 练气前期
    4-6级 : 练气中期
    7-9级 : 练气后期
    10-13级 : 先天前期
    14-16级 : 先天中期
    17-19级 : 先天后期，经验满了，显示圆满（需要突破，突破后额外增加15点护盾）
    20-23级 : 筑基前期
    24-26级 : 筑基中期
    27-29级 : 筑基后期，经验满了，显示圆满（需要突破，突破后额外增加15点护盾）
    30-33级 : 金丹前期
    34-36级 : 金丹中期
    37-39级 : 金丹后期，经验满了，显示圆满（需要突破，突破后额外增加15点护盾）
    40-43级 : 元婴前期
    44-46级 : 元婴中期
    47-49级 : 元婴后期，经验满了，显示圆满（需要突破，突破后额外增加15点护盾）
    50-59级 : 化神期
    60-69级 : 合体期
    70-79级 : 大乘期

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function GetNameByLevel(level)
        if level <= 3 then
            return "练气前期"
        elseif level <= 6 then
            return "练气中期"
        elseif level <= 9 then
            return "练气后期"
        elseif level <= 13 then
            return "先天前期"            
        elseif level <= 16 then
            return "先天中期"
        elseif level <= 19 then
            return "先天后期"
        elseif level <= 23 then
            return "筑基前期"            
        elseif level <= 26 then
            return "筑基中期"
        elseif level <= 29 then
            return "筑基后期"
        elseif level <= 33 then
            return "金丹前期"
        elseif level <= 36 then
            return "金丹中期"            
        elseif level <= 39 then
            return "金丹后期"            
        elseif level <= 43 then
            return "元婴前期"            
        elseif level <= 46 then
            return "元婴中期"
        elseif level <= 49 then
            return "元婴后期"
        elseif level <= 53  then
            return "化神前期"
        elseif level <= 56  then
            return "化神中期"
        elseif level <= 59  then
            return "化神后期"
        elseif level <= 63  then
            return "合体前期"
        elseif level <= 66  then
            return "合体中期"
        elseif level <= 69  then
            return "合体后期"
        elseif level <= 73  then
            return "大乘前期"
        elseif level <= 76  then
            return "大乘中期"
        elseif level <= 79  then
            return "大乘后期"
        end            
        return "未知"
    end
    local function GetTranslatedStr(index)
        if TUNING.BOGD_GET_LANGUAGE() == "ch" then
            return index
        end
        return TUNING.BOGD_FN:GetStrings("level_name",index) or "NIL"
    end
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
        local data = TUNING.BOGD_FN:Get_ThePlayer_Cross_Archived_Data("exp_bar_location")
        if data == nil then
            return 0.5,0.5
        else
            return data.x,data.y
        end
    end
    local function SetBadgeLoation(x,y)
        TUNING.BOGD_FN:Set_ThePlayer_Cross_Archived_Data("exp_bar_location",{x = x,y = y})
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 经验条
    local function badge_setup(inst)
        local front_root = inst.HUD.controls.status
        ----------------------------------------------------------------------------------------------------------------
        --- 
            if front_root.bogd_exp_bar then
                return
            end
        ----------------------------------------------------------------------------------------------------------------
        --- 经验条颜色切换
            local function exp_bar_color_switch(bar)
                if inst.replica.bogd_com_level_sys:IsGod() then
                    bar:GetAnimState():Hide("YELLOW")
                    bar:GetAnimState():Show("GREEN")
                    bar:GetAnimState():Hide("RED")
                elseif inst.replica.bogd_com_level_sys:IsDemon() then
                    bar:GetAnimState():Hide("YELLOW")
                    bar:GetAnimState():Hide("GREEN")
                    bar:GetAnimState():Show("RED")
                else
                    bar:GetAnimState():Show("YELLOW")
                    bar:GetAnimState():Hide("GREEN")
                    bar:GetAnimState():Hide("RED")
                end
            end
        ----------------------------------------------------------------------------------------------------------------
        --- 创建 root
            local root = front_root:AddChild(Widget())
            root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetPosition(1000,500)
            root:MoveToBack()
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC) --- 缩放模式

            local main_scale = 0.7
        ----------------------------------------------------------------------------------------------------------------
        --- 创建经验条
            local exp_bar = root:AddChild(UIAnim())
            exp_bar:SetScale(main_scale,main_scale,main_scale)
            local exp_bar_anim = exp_bar:GetAnimState()
            exp_bar_anim:SetBank("bogd_hud_exp_bar")
            exp_bar_anim:SetBuild("bogd_hud_exp_bar")
            exp_bar_anim:PlayAnimation("idle",true)
            exp_bar_anim:Pause() -- 暂停动画

        ----------------------------------------------------------------------------------------------------------------
        --- 经验条掉落动画
            local exp_bar2 = root:AddChild(UIAnim())
            exp_bar2:SetScale(main_scale,main_scale,main_scale)
            local exp_bar2_anim = exp_bar2:GetAnimState()
            exp_bar2_anim:SetBank("bogd_hud_exp_bar")
            exp_bar2_anim:SetBuild("bogd_hud_exp_bar")
            -- exp_bar2_anim:PlayAnimation("idle",true)
            exp_bar2:Hide()
            inst:ListenForEvent("bogd_exp_bar_drop",function()
                exp_bar2:Show()
                exp_bar2_anim:SetDeltaTimeMultiplier(0.25)
                exp_bar2_anim:PlayAnimation("idle2",false)
                inst:DoTaskInTime(4,function()
                    exp_bar2:Hide()
                end)
            end)
        ----------------------------------------------------------------------------------------------------------------
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
            
            root.x_percent,root.y_percent = GetBadgeLoation()
            root:LocationScaleFix()

            root.inst:DoPeriodicTask(2,function()
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
        --- 等级文本
            local level_text = root:AddChild(Text(TITLEFONT,20,"3000/3000",{ 255/255 , 255/255 ,255/255 , 1}))
            level_text:SetPosition(-40,28)
            level_text:SetString("Lv.01")
            root.level_text = level_text
        ----------------------------------------------------------------------------------------------------------------
        --- 境界文本
            local text = root:AddChild(Text(TITLEFONT,30,"3000/3000",{ 255/255 , 255/255 ,255/255 , 1}))
            text:SetPosition(25,30)
            text:SetString("筑基中期")
            root.text = text
        ----------------------------------------------------------------------------------------------------------------
        ---  经验值
            local exp_text = root:AddChild(Text(CODEFONT,20,"3000/3000",{ 0/255 , 0/255 ,0/255 , 0.5}))
            exp_text:SetPosition(0,0)
            exp_text:SetString("1500 / 3000")
            exp_text:SetScale(0.8,1,1)
            root.exp_text = exp_text
        ----------------------------------------------------------------------------------------------------------------
        --- 神魔状态
            local body_type = root:AddChild(Text(TITLEFONT,30,"神",{ 255/255 , 255/255 ,255/255 , 1}))
            body_type:SetPosition(-80,0)
            body_type:Hide()
            root.body_type = body_type
        ----------------------------------------------------------------------------------------------------------------
        --- warning
            -- local warning = root:AddChild(UIAnim())
            -- local warning_anim = warning:GetAnimState()
            -- warning_anim:SetBank("bogd_hud_exp_bar")
            -- warning_anim:SetBuild("bogd_hud_exp_bar")
            -- warning_anim:PlayAnimation("warning",true)
            -- warning:SetScale(main_scale,main_scale,main_scale)
            -- warning:SetPosition(0,-50)
            -- warning:Hide()

            local warning = root:AddChild(Text(TITLEFONT,30,"3000/3000",{ 255/255 , 255/255 ,255/255 , 1}))
            warning:SetPosition(25,-30)
            warning:SetString(GetTranslatedStr("需要突破") or "需要突破")
            warning:Hide()
            warning.text_front_size = 30
            root.warning = warning
            function warning:Show2()
                self:Show()
                if self.task == nil then
                    self.task = self.inst:DoPeriodicTask(0.7,function()
                        if self.text_front_size == 30 then
                            self.text_front_size = 35
                            self:SetSize(self.text_front_size)
                            self:SetColour({1,0,0,1})
                        else
                            self.text_front_size = 30
                            self:SetSize(self.text_front_size)
                            self:SetColour({1,1,1,1})
                        end
                    end)
                end
            end
            function warning:Hide2()
                if self.task then
                    self.task:Cancel()
                    self.task = nil
                end
                self:Hide()
            end

        ----------------------------------------------------------------------------------------------------------------
        ---- 设置数值
            local function value_refresh()
                local level = inst.replica.bogd_com_level_sys:Level_Get()
                level_text:SetString("Lv."..level)

                local exp_current = inst.replica.bogd_com_level_sys:Exp_Get()
                local exp_max = inst.replica.bogd_com_level_sys:Exp_Max_Get()                
                exp_text:SetString(exp_current.." / "..exp_max)

                local percent = exp_current/exp_max
                exp_bar_anim:SetPercent("idle",percent)

                if inst.replica.bogd_com_level_sys:GetLevelUpLock() then
                    warning:Show2()
                else
                    warning:Hide2()
                end

                text:SetString(GetTranslatedStr(GetNameByLevel(level)))

            end
            value_refresh()
            if inst.replica.bogd_com_level_sys.classified then
                inst.replica.bogd_com_level_sys.classified:ListenForEvent("bogd_exp_dirty",value_refresh)
            end
        ----------------------------------------------------------------------------------------------------------------
        ---- 神魔相关的切换
            local function Body_Type_Init()
                exp_bar_color_switch(exp_bar)
                exp_bar_color_switch(exp_bar2)
                if inst.replica.bogd_com_level_sys:IsHuman() then
                    body_type:SetString(GetTranslatedStr("人"))
                    body_type:Hide()
                    exp_text:SetColour({0/255,0/255,0/255,1})
                elseif inst.replica.bogd_com_level_sys:IsGod() then
                    body_type:SetString(GetTranslatedStr("神"))
                    body_type:Show()
                    exp_text:SetColour({0/255,0/255,0/255,1})
                elseif inst.replica.bogd_com_level_sys:IsDemon()then
                    body_type:SetString(GetTranslatedStr("魔"))
                    body_type:Show()
                    exp_text:SetColour({0/255,0/255,0/255,1})
                end
            end

            if inst.replica.bogd_com_level_sys.classified then
                inst.replica.bogd_com_level_sys.classified:ListenForEvent("bogd_body_type_dirty",Body_Type_Init)
            end
            root.inst:DoTaskInTime(0,Body_Type_Init)
        ----------------------------------------------------------------------------------------------------------------
            front_root.bogd_exp_bar = root
        ----------------------------------------------------------------------------------------------------------------

    end
    local function uninstall(inst)
        local front_root = inst.HUD.controls.status         
        if front_root.bogd_exp_bar then
            front_root.bogd_exp_bar:Kill()
            front_root.bogd_exp_bar = nil
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
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 渡劫风暴
    local function moon_storm_setup(inst)

        local root = inst.HUD

        local function create_strom(color)
            local MoonstormDustOver = require("widgets/moonstormdustover")
            local storm = root:AddChild(MoonstormDustOver(inst))
            storm:MoveToBack()
            local fx = storm:AddChild(UIAnim())
            fx:GetAnimState():SetBank("moonstorm_over_static")
            fx:GetAnimState():SetBuild("moonstorm_over_static")
            fx:GetAnimState():PlayAnimation("static_loop",true)
            if color then
                storm:GetAnimState():SetMultColour(255,0,0,1)
            else
                storm:GetAnimState():SetMultColour(unpack(color))
            end
            return storm
        end

        local storm = nil
        inst:ListenForEvent("bogd_event.level_strom",function(inst,_table)
            -- _table = _table or {

            -- }
            local trun_on = _table.trun_on or false
            local color = _table.color or {1,1,1,1}

            if trun_on then
                if storm then
                    storm:Kill()
                end
                storm = create_strom(color)
            else
                if storm then
                    storm:Kill()
                    storm = nil
                end
            end
        end)


    end
    AddPlayerPostInit(function(inst)
        inst:DoTaskInTime(1,function()
            if ThePlayer and ThePlayer == inst and inst.HUD then
                moon_storm_setup(inst)
            end
        end)
    end)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
