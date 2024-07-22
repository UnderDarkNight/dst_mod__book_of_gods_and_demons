local assets = {
    -- Asset("IMAGE", "images/inventoryimages/spell_reject_the_npc.tex"),
	-- Asset("ATLAS", "images/inventoryimages/spell_reject_the_npc.xml"),
	-- Asset("ANIM", "anim/npc_fx_chat_bubble.zip"),
}


local function fx()
    local inst = CreateEntity()

    inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("emote_fx")
    inst.AnimState:SetBuild("emote_fx")
    inst.AnimState:PlayAnimation("emote_fx", true)
    inst.AnimState:SetFinalOffset(1)


    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
    inst:ListenForEvent("Set",function(inst,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     color = Vector3(255,255,255),        -- color / colour 都行
        --     MultColour_Flag = false ,        
        --     a = 0.1,
        --     speed = 1,
        --     sound = ""
        --     scale = Vector3(0,0,0),
        -- }
        if _table == nil then
            return
        end
        if _table.pt and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)
        end
        ------------------------------------------------------------------------------------------------------------------------------------
        --- 颜色
            _table.color = _table.color or _table.colour
            if _table.color and _table.color.x then
                if _table.MultColour_Flag ~= true then
                    inst:AddComponent("colouradder")
                    inst.components.colouradder:OnSetColour(_table.color.x/255 , _table.color.y/255 , _table.color.z/255 , _table.a or 1)
                else
                    inst.AnimState:SetMultColour(_table.color.x,_table.color.y, _table.color.z, _table.a or 1)
                end
            end
        ------------------------------------------------------------------------------------------------------------------------------------
        --- 缩放
            if type(_table.scale) == "table" and _table.scale.x then
                inst.AnimState:SetScale(_table.scale.x,_table.scale.y,_table.scale.z)
            end
        ------------------------------------------------------------------------------------------------------------------------------------
        --- 音效
            if _table.sound then
                inst.SoundEmitter:PlaySound(_table.sound)
            end
        ------------------------------------------------------------------------------------------------------------------------------------
        --- 动画播放速度
            if type(_table.speed) == "number" then
                inst.AnimState:SetDeltaTimeMultiplier(_table.speed)
            end
        ------------------------------------------------------------------------------------------------------------------------------------

        inst.Ready = true
    end)

    inst:DoTaskInTime(0,function()
        if inst.Ready ~= true then
            inst:Remove()
        end
    end)

    return inst
end

return Prefab("bogd_sfx_damage_enhancement",fx,assets)