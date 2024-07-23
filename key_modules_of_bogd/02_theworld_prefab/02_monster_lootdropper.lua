--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit(
    "world",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        --------------------------------------------------------------------------------------------------
        ---
            local check_is_monster = function(target)
                if target == nil then
                    return false
                end
                if not target.brainfn then -- 不带脑子的不算数
                    return false
                end

                if target.components.lootdropper == nil then -- 没有组件
                    return false
                end

                if target:HasTag("epic") then
                    return true , true
                end
                return true
            end
        --------------------------------------------------------------------------------------------------
        inst:ListenForEvent("entity_droploot",function(_,_table)
            --------------------------------------------------------------------------------------------------
            ---
                local target = _table and _table.inst
                local is_monster , boss_flag = check_is_monster(target)
                if not is_monster then
                    return
                end
            --------------------------------------------------------------------------------------------------
            --- 2%的掉率
                if boss_flag then
                    local loots = {"bogd_item_blood_of_god","bogd_item_blood_of_demon"}
                    if TUNING.BOGD_DEBUGGING_MODE or math.random(10000)/10000 <= 2/100 then
                        target.components.lootdropper:SpawnLootPrefab(loots[math.random(#loots)])
                    end
                else
                    local loots = {"bogd_item_shard_of_god","bogd_item_shard_of_demon"}
                    if TUNING.BOGD_DEBUGGING_MODE or math.random(10000)/10000 <= 2/100 then
                        target.components.lootdropper:SpawnLootPrefab(loots[math.random(#loots)])
                    end
                end
            --------------------------------------------------------------------------------------------------
        end)

    end)