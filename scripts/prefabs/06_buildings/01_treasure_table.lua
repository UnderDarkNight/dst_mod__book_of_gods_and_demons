----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    灵宝台

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 素材
    local assets = {
        Asset("ANIM", "anim/bogd_building_treasure_table.zip"), 
    }
------------------------------------------------------------------------------------------------------
--- 参数表
    local ACTIVE_REMAIN_DAYS = 3 --- 激活存在天数
------------------------------------------------------------------------------------------------------
--- 交互事件
    local function events_setup(inst)
        --------------------------------------------------------------------------
        --- 激活事件
            inst:ListenForEvent("active_start",function(inst,onload_flag)
                if inst:HasTag("started") then
                    return
                end
                if not onload_flag then
                    inst.components.bogd_data:Set("start_day",TheWorld.state.cycles)
                end
                inst:AddTag("started")
                ------ 创建特效
                local beam_fx = inst:SpawnChild("bogd_sfx_terra_beam")
                inst.beam_fx = beam_fx
                beam_fx:PushEvent("TurnOn",{
                    pt = Vector3(0,-1,0)
                })

            end)
        --------------------------------------------------------------------------
        --- 事件停止
            inst:ListenForEvent("active_stop",function(inst)
                if not inst:HasTag("started") then
                    return
                end
                if inst.linked_boss and inst.linked_boss:IsValid() then -- 在BOSS战斗中，不进行停止
                    return
                end

                inst:RemoveTag("started")
                inst.components.bogd_data:Set("start_day",nil)

                ------ 关闭特效
                if inst.beam_fx then
                    inst.beam_fx:PushEvent("TurnOff")
                    inst.beam_fx = nil
                end


            end)
        --------------------------------------------------------------------------
        ---- 每天循环检查
            inst:WatchWorldState("cycles",function(inst)
                local days = TheWorld.state.cycles - inst.components.bogd_data:Add("start_day",0) 
                if days > ACTIVE_REMAIN_DAYS then
                    inst:PushEvent("active_stop")
                end
            end)
        --------------------------------------------------------------------------
        ---- OnLoad 的时候检查
            inst.components.bogd_data:AddOnLoadFn(function(com)
                if com:Get("has_boss") then -- 召唤过BOSS
                    com:Set("start_day",nil)
                    com:Set("has_boss",false)
                end
                if TheWorld.state.cycles - com:Add("start_day",0) <= ACTIVE_REMAIN_DAYS then
                    inst:PushEvent("active_start",true)
                end
            end)
        --------------------------------------------------------------------------
        --- 启动事件检查 ：月圆/月黑  的结束后第二天开启事件
            inst:WatchWorldState("isnewmoon",function()
                inst:DoTaskInTime(1,function()
                    if TheWorld.state.isnewmoon then
                        inst.components.bogd_data:Set("auto_start",true)
                    end
                end)
            end)
            inst:WatchWorldState("isfullmoon",function()
                inst:DoTaskInTime(1,function()
                    if TheWorld.state.isfullmoon then
                        inst.components.bogd_data:Set("auto_start",true)
                    end
                end)
            end)
            inst:WatchWorldState("cycles",function()
                inst:DoTaskInTime(5,function()
                    if inst.components.bogd_data:Get("auto_start") then
                        inst.components.bogd_data:Set("auto_start",false)
                        inst:PushEvent("active_start")
                    end
                end)
            end)
        --------------------------------------------------------------------------
    end
------------------------------------------------------------------------------------------------------
--- 刷BOSS、给奖励
    local function SpawnBoss(inst,doer)
        if inst.linked_boss and inst.linked_boss:IsValid() then
            return
        end
        local boss_list = {
            "beequeen",     -- 蜂后
            "spat",         -- 钢羊
            "spiderqueen",  -- 蜘蛛女王
            "dragonfly",    -- 龙蝇
            "deerclops",    -- 巨鹿
            "bearger",      -- 巨熊
            "mutateddeerclops",     -- 晶体巨鹿
            "mutatedbearger",       -- 晶体巨熊
        }
        local ret_boss_prefab = boss_list[math.random(#boss_list)]
        local x,y,z = inst.Transform:GetWorldPosition()
        local boss = SpawnPrefab(ret_boss_prefab)
        if boss == nil then
            return
        end
        boss.Transform:SetPosition(x,y,z)
        inst.linked_boss = boss
        boss.linked_item = inst
        ------ 给BOSS上buff
        local debuff_name = "bogd_debuff_treasure_table_boss_buff"
        while true do
            local debuff = boss:GetDebuff(debuff_name)
            if debuff then
                break
            end
            boss:AddDebuff(debuff_name,debuff_name)
        end
        ------ BOSS 死后，上标记位
        boss:ListenForEvent("death",function(boss)            
            inst.linked_boss = nil
            inst.components.bogd_data:Set("has_reward",true)

            --- 广播BOSS死亡
            for k, temp_player in pairs(AllPlayers) do
                temp_player.components.bogd_com_rpc_event:PushEvent("bogd_event.whisper",{
                    m_colour = {0/255,245/255,255/255},
                    message = TUNING.BOGD_FN:GetStrings(inst.prefab,"boss_death"),
                })
            end

        end)
        inst.components.bogd_data:Set("has_boss",true)
    end
    local function SpawnReward(inst,doer)
        inst.components.bogd_data:Set("has_reward",false)
        inst:PushEvent("active_stop")
        local reward_list = {
            "bogd_treasure_divine_punishment",							--- 灵·神罚
            "bogd_treasure_shadow_tentacle",							--- 灵·影鞭
            "bogd_treasure_magic_shield",								--- 灵·护体
            "bogd_treasure_map_blink", 									--- 灵·缩地
            "bogd_treasure_damage_enhancement",							--- 灵·强化
            "bogd_treasure_pet_summon",									--- 灵·神宠
            "bogd_treasure_treatment", 									--- 灵·妙手
            "bogd_treasure_frostfall", 									--- 灵·霜降
            "bogd_treasure_poison_ring",								--- 灵·流逝
            "bogd_treasure_meteorites",									--- 灵·天罚
        }
        local ret_reward = reward_list[math.random(#reward_list)]
        local item = SpawnPrefab(ret_reward)
        doer.components.inventory:GiveItem(item)
    end
------------------------------------------------------------------------------------------------------
--- workable setup
    local function workable_setup(inst)
        inst:ListenForEvent("BOGD_OnEntityReplicated.bogd_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                return inst:HasTag("started")
            end)
            replica_com:SetSGAction("dolongaction")
            replica_com:SetText("bogd_building_treasure_table",STRINGS.ACTIONS.OPEN_CRAFTING.USE)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("bogd_com_workable")
            inst.components.bogd_com_workable:SetOnWorkFn(function(inst,doer)
                
                if inst.components.bogd_data:Get("has_reward") then
                    -- 给玩家物品
                    SpawnReward(inst,doer)
                else
                    -- 刷BOSS
                    SpawnBoss(inst,doer)
                end
                return true
            end)
            -- inst.components.bogd_com_workable:SetCanWorlk(false)
        end
    end
------------------------------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体


    inst.AnimState:SetBank("bogd_building_treasure_table") -- 地上动画
    inst.AnimState:SetBuild("bogd_building_treasure_table") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画
    inst.AnimState:SetFinalOffset(1)


    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetPriority(4)
    inst.MiniMapEntity:SetIcon("bogd_building_treasure_table.tex")

    MakeObstaclePhysics(inst, 1)

    inst:AddTag("bogd_building_treasure_table") -- 添加标签

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    ---
        workable_setup(inst)
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    -- 数据储存库
        inst:AddComponent("bogd_data")
    --------------------------------------------------------------------------
    -- 检查文本
        inst:AddComponent("inspectable")
    --------------------------------------------------------------------------
    -- 
        events_setup(inst)
    --------------------------------------------------------------------------

        MakeHauntableLaunch(inst)
    --------------------------------------------------------------------------

    --------------------------------------------------------------------------

    return inst
end

return Prefab("bogd_building_treasure_table", fn, assets)