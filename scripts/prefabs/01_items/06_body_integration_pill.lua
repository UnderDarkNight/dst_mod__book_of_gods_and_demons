----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    合体丹

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local prefab_name = "bogd_item_body_integration_pill"

    local assets = {
        Asset("ANIM", "anim/bogd_item_body_integration_pill.zip"), 
        Asset( "IMAGE", "images/inventoryimages/bogd_item_body_integration_pill.tex" ),  -- 背包贴图
        Asset( "ATLAS", "images/inventoryimages/bogd_item_body_integration_pill.xml" ),
    }
------------------------------------------------------------------------------------------------------
--- 

------------------------------------------------------------------------------------------------------
local function item_fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    -- inst.AnimState:SetBank("bogd_item_body_integration_pill") -- 地上动画
    -- inst.AnimState:SetBuild("bogd_item_body_integration_pill") -- 材质包，就是anim里的zip包
    -- inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画
    inst.AnimState:SetBank(prefab_name) -- 地上动画
    inst.AnimState:SetBuild(prefab_name) -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画

    MakeInventoryFloatable(inst)

    inst:AddTag("usedeploystring")  -- 部署的时候显示的文本

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = prefab_name
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..prefab_name..".xml"

    --------------------------------------------------------------------------
    -- 可烧毁
        -- inst:AddComponent("bogd_data")
    --------------------------------------------------------------------------
    -- 可烧毁
        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    --------------------------------------------------------------------------
    --- 能量

    --------------------------------------------------------------------------
    --- 放置
        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = function(inst, pt, deployer)
            -- SpawnPrefab(inst.prefab.."_building").Transform:SetPosition(pt.x,0,pt.z)
            SpawnPrefab(inst.prefab.."_building"):PushEvent("Set",{
                pt = pt,
                doer = deployer,
            })
            inst:Remove()
        end
        inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)
    --------------------------------------------------------------------------

    MakeHauntableLaunch(inst)
    --------------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                inst.AnimState:Hide("SHADOW")
            else                                
                inst.AnimState:Show("SHADOW")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    --------------------------------------------------------------------------
    
    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 建筑容器+界面
    local all_container_widgets = require("containers")
    local params = all_container_widgets.params

    params.bogd_item_body_integration_pill_container =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = "ui_chest_3x3",
            pos = Vector3(300, 0, 0),
            top_align_tip = 50,
            buttoninfo =
            {
                text = STRINGS.ACTIONS.APPLYCONSTRUCTION.GENERIC,
                position = Vector3(0, -220, 0),
            },
            --V2C: -override the default widget sound, which is heard only by the client
            --     -most containers disable the client sfx via skipopensnd/skipclosesnd,
            --      and play it in world space through the prefab instead.
            opensound = "dontstarve/wilson/chest_open",
            closesound = "dontstarve/wilson/chest_close",
            --
        },
        usespecificslotsforitems = true,
        type = "cooker",
    }

    local slot_size = 120
    for y = 2, 0, -1 do
        for x = 0, 2 do
            table.insert(params.bogd_item_body_integration_pill_container.widget.slotpos, Vector3(slot_size * x - slot_size * 2 + slot_size, slot_size * y - slot_size * 2 + slot_size, 0))
        end
    end

    function params.bogd_item_body_integration_pill_container.itemtestfn(container, item, slot)

        local doer = container.inst.entity:GetParent()
        return doer ~= nil
            and doer.components.constructionbuilderuidata ~= nil
            and doer.components.constructionbuilderuidata:GetIngredientForSlot(slot) == item.prefab
    end

    function params.bogd_item_body_integration_pill_container.widget.buttoninfo.fn(inst, doer)
        ----------------------------------------------------------------------------------
        --- 检查是指定玩家
            if not inst:HasTag(doer.userid) then
                local announce_inst = nil
                if TheWorld.ismastersim then
                    announce_inst = doer.components.bogd_com_rpc_event
                elseif ThePlayer == doer then
                    announce_inst = doer
                end
                if announce_inst then
                    announce_inst:PushEvent("bogd_event.whisper",{
                        m_colour = {255/255,100/255,100/255},
                        message = TUNING.BOGD_FN:GetStrings("bogd_item_body_integration_pill_building","wrong_building") or "错误建筑",
                        sender_name = "󰀀󰀀󰀀",
                        -- icondata = "emoji_abigail",
                    })
                end
                return
            end
        ----------------------------------------------------------------------------------
        --- 检查玩家等级 和 经验
            local level = doer.replica.bogd_com_level_sys:Level_Get()
            local exp_precent = doer.replica.bogd_com_level_sys:Exp_Get_Percent()
            if not (level == 59 and exp_precent >= 1) then
                local announce_inst = nil
                if TheWorld.ismastersim then
                    announce_inst = doer.components.bogd_com_rpc_event
                elseif ThePlayer == doer then
                    announce_inst = doer
                end
                if announce_inst then
                    announce_inst:PushEvent("bogd_event.whisper",{
                        m_colour = {255/255,100/255,100/255},
                        message = TUNING.BOGD_FN:GetStrings("bogd_item_body_integration_pill_building","wrong_level") or "错误建筑",
                        sender_name = "󰀀󰀀󰀀",
                        -- icondata = "emoji_abigail",
                    })
                end
                return
            end
        ----------------------------------------------------------------------------------
        --- 按钮成功激活
            if inst.components.container ~= nil then
                BufferedAction(doer, inst, ACTIONS.APPLYCONSTRUCTION):Do()
            elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
                SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.APPLYCONSTRUCTION.code, inst, ACTIONS.APPLYCONSTRUCTION.mod_name)
            end
        ----------------------------------------------------------------------------------
    end

    function params.bogd_item_body_integration_pill_container.widget.buttoninfo.validfn(inst)
        return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()
    end

    local function container_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddNetwork()

        inst:AddTag("bundle")

        --V2C: blank string for controller action prompt
        inst.name = " "
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("container")
        inst.components.container:WidgetSetup("bogd_item_body_integration_pill_container")

        inst.persists = false
        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 建筑
    local function building_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(prefab_name)
        inst.AnimState:SetBuild(prefab_name)
        inst.AnimState:PlayAnimation("building")

        inst.entity:SetPristine()

        inst:AddTag("constructionsite")

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        ----------------------------------------------------
        --- 数据库
            inst:AddComponent("bogd_data")

        ----------------------------------------------------
        --- 界面
            inst:AddComponent("constructionsite")
            inst.components.constructionsite:SetConstructionPrefab("bogd_item_body_integration_pill_container")
            inst.components.constructionsite:SetOnConstructedFn(function(inst,doer)
                inst.components.constructionsite.enabled  = false
                ----------------------------------------------------
                --- 执行晋升逻辑。建筑先发光，然后玩家发光。
                    inst:SpawnChild("bogd_sfx_terra_beam"):PushEvent("Set",{
                        pt = Vector3(0,-1,0),
                        end_time = 15,
                        end_fn = function()
                            -- print("info  beam fx end")
                            inst:Remove()
                        end,
                    })
                    inst:DoTaskInTime(10,function()
                        doer:SpawnChild("bogd_sfx_terra_beam"):PushEvent("Set",{
                            pt = Vector3(0,-1,0),
                            end_time = 10,
                            end_fn = function()
                                doer.components.bogd_com_level_sys:Level_Up_With_Lock_Break()
                            end,
                        })
                    end)
                ----------------------------------------------------
            end)
            inst.components.constructionsite:SetOnStartConstructionFn(function(inst,doer) -- 打开界面后，给界面inst上tag，方便按钮那边确定是否激活
                if doer.components.constructionbuilder then
                    local widget_inst = doer.components.constructionbuilder.constructioninst
                    if widget_inst then
                        widget_inst:AddTag(inst.components.bogd_data:Get("userid") or "NIL")
                    end
                end
            end)
        ----------------------------------------------------
        --- 建造事件、初始化上tag
            inst:ListenForEvent("Set",function(inst,_table)
                local pt = _table.pt
                local doer = _table.doer
                local userid = doer.userid

                inst.Transform:SetPosition(pt.x,0,pt.z)
                inst.components.bogd_data:Set("userid",userid)
            end)
            inst:DoTaskInTime(0,function()
                local userid = inst.components.bogd_data:Get("userid")
                if userid then
                    inst:AddTag(userid)
                end
            end)
        ----------------------------------------------------
        --- 拆除的时候
            inst:AddComponent("lootdropper")
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
            inst.components.workable:SetWorkLeft(3)
            inst.components.workable:SetOnFinishCallback(function(inst, doer)
                local fx = SpawnPrefab("collapse_small")
                fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                if inst.components.constructionsite.enabled then
                    inst.components.lootdropper:SpawnLootPrefab(prefab_name)
                end
                inst:Remove()
            end)
            -- inst.components.workable:SetOnWorkCallback(onhit)
        ----------------------------------------------------



        MakeHauntableLaunch(inst)
        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--[[ 配方
        绝望石x1                dreadstone
        纯粹辉煌x1              purebrilliance
        充能的火花柜x1，        security_pulse_cage_full
        量茄碎片x1，            lunarplant_husk
        墨荒的碎布x1，          voidcloth
        眼球x1，                deerclops_eyeball
        一角鲸的角x1，          gnarwail_horn
        龙鳞x1，                dragon_scales
        邪天翁的羽毛x1          malbatross_feather
    ]]--
    CONSTRUCTION_PLANS[prefab_name.."_building"] = { 
        Ingredient("dreadstone", 1),
        Ingredient("purebrilliance", 1),
        Ingredient("security_pulse_cage_full", 1),
        Ingredient("lunarplant_husk", 1),
        Ingredient("voidcloth", 1),
        Ingredient("deerclops_eyeball", 1),
        Ingredient("gnarwail_horn", 1),
        Ingredient("dragon_scales", 1),
        Ingredient("malbatross_feather", 1),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 放置器
    local function placer_postinit_fn(inst)

    end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab(prefab_name, item_fn, assets),
    MakePlacer(prefab_name.."_placer", prefab_name,prefab_name, "building", nil, nil, nil, nil, nil, nil, placer_postinit_fn, nil, nil),
    Prefab(prefab_name.."_building", building_fn, assets),
    Prefab(prefab_name.."_container", container_fn, assets)

