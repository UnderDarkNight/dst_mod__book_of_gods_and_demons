--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/bogd_treasure_excample.zip"),

    Asset( "IMAGE", "images/inventoryimages/bogd_treasure_excample.tex" ),  -- 物品贴图
    Asset( "ATLAS", "images/inventoryimages/bogd_treasure_excample.xml" ),  -- 物品贴图

    Asset( "IMAGE", "images/treasure/bogd_treasure_excample.tex" ),         -- UI贴图
    Asset( "ATLAS", "images/treasure/bogd_treasure_excample.xml" ),         -- UI贴图


}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 界面UI
    local function client_ui_setup(inst)
        
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 主函数
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("bogd_treasure_excample")
        inst.AnimState:SetBuild("bogd_treasure_excample")
        inst.AnimState:PlayAnimation("idle")

        inst:AddTag("bogd_treasure")  -- 用于快捷键标记识别

        inst.entity:SetPristine()

        ----------------------------------------------------------------------------------------------
        -- 修改穿戴组件，屏蔽指定玩家
            local function hook_IsRestricted(com)
                com.IsRestricted = function(self,player)    --- 是否被屏蔽，return false 才能穿戴
                    --- client/server 统一在这里
                    return false
                end
            end
            inst:ListenForEvent("BOGD_OnEntityReplicated.equippable", function(inst, replica_com)
                -- replica_com.IsRestricted = function(self,player) end
                hook_IsRestricted(replica_com)
            end)
            if TheWorld.ismastersim then
                inst:AddComponent("equippable")
                -- inst.components.equippable.IsRestricted = function(self,player)  end
                hook_IsRestricted(inst.components.equippable)
            end
        ----------------------------------------------------------------------------------------------
        ---
            client_ui_setup(inst)
        ----------------------------------------------------------------------------------------------

        if not TheWorld.ismastersim then
            return inst
        end



        ----------------------------------------------------------------------------------------------
        --- 标准物品库
            inst:AddComponent("inspectable")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.keepondeath = true        --- 死亡不掉落
            inst.components.inventoryitem:SetSinks(true) --- 落水消失
            inst.components.inventoryitem.imagename = "bogd_treasure_excample"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/bogd_treasure_excample.xml"
        ----------------------------------------------------------------------------------------------
        --- 灵宝关键组件
            inst:AddComponent("bogd_com_treasure")
            inst.components.bogd_com_treasure:SetCDTime(10)
            inst.components.bogd_com_treasure:SetIcon("images/treasure/bogd_treasure_excample.xml","bogd_treasure_excample.tex")
            inst.components.bogd_com_treasure:SetSpellFn(function(inst,doer,pt)
                print("灵宝触发",pt)
                SpawnPrefab("log").Transform:SetPosition(pt.x,0,pt.z)
                inst.components.bogd_com_treasure:SetCDStart()
            end)
        ----------------------------------------------------------------------------------------------
        --- 装备组件
            -- inst:AddComponent("equippable")
            inst.components.equippable:SetOnEquip(function(inst, owner)
                inst.components.bogd_com_treasure:OnEquipped(owner)
            end)
            inst.components.equippable:SetOnUnequip(function(inst, owner)
                inst.components.bogd_com_treasure:OnUnequipped(owner)
                inst:Remove()  --- 脱下即消失
            end)
            inst.components.equippable.equipslot = EQUIPSLOTS.TREASURE
            -- inst.components.equippable.equipslot = EQUIPSLOTS.BODY
            inst.components.equippable:SetPreventUnequipping(true)  --- 避免被脱下
        ----------------------------------------------------------------------------------------------
        MakeHauntableLaunch(inst)

        return inst
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("bogd_treasure_excample", fn, assets)
