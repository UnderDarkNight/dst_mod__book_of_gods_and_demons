--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    在格罗姆雕像附近，找位置生成 灵宝台

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit(
    "world",
    function(inst)
        if not inst.ismastersim then
            return
        end

        if inst:HasTag("cave") then
            return
        end

        inst:DoTaskInTime(0,function()
            

            local treasure_table = TheSim:FindFirstEntityWithTag("bogd_building_treasure_table")
            if treasure_table then
                print("info already has treasure_table")
                return
            end

            local statueglommer = TheSim:FindFirstEntityWithTag("statueglommer")
            if statueglommer == nil then
                print("error can not find the statueglommer")
                return
            end

            local treasure_table = SpawnPrefab("bogd_building_treasure_table")


            local x,y,z = statueglommer.Transform:GetWorldPosition()

            local range = 40
            local ret_spawn_pt = nil
            while ( ret_spawn_pt == nil and range > 10 ) do
                local points = TUNING.BOGD_FN:GetSurroundPoints({
                    target = Vector3(x,y,z),
                    range = range,
                    num = 30,
                })
                local ret_points = {}
                for k, temp_pt in pairs(points) do
                    if TheWorld.Map:CanDeployAtPoint(temp_pt,treasure_table) then
                        table.insert(ret_points,temp_pt)
                    end
                end
                if #ret_points > 0 then
                    ret_spawn_pt = ret_points[math.random(#ret_points)]
                    break
                else
                    range = range - 3
                end
            end

            if ret_spawn_pt then
                treasure_table.Transform:SetPosition(ret_spawn_pt.x,0,ret_spawn_pt.z)
            else
                treasure_table:Remove()
            end




        end)
    end)