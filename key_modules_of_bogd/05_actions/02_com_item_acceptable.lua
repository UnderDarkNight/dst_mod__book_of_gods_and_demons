



local BOGD_COM_ACCEPTABLE_ACTION = Action({priority = 10})   --- 距离 和 目标物体的 碰撞体积有关，为 0 也没法靠近。
BOGD_COM_ACCEPTABLE_ACTION.id = "BOGD_COM_ACCEPTABLE_ACTION"
BOGD_COM_ACCEPTABLE_ACTION.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    local item = act.invobject
    local target = act.target
    local doer = act.doer
    if doer and target and target.replica.bogd_com_acceptable then
        local replica_com = target.replica.bogd_com_acceptable or target.replica._.bogd_com_acceptable
        if replica_com then
            return replica_com:GetTextIndex()
        end
    end
    return "DEFAULT"
end

BOGD_COM_ACCEPTABLE_ACTION.fn = function(act)    --- 只在服务端执行~
    local item = act.invobject
    local target = act.target
    local doer = act.doer
    if item and target and doer and target.components.bogd_com_acceptable then
        local replica_com = target.replica.bogd_com_acceptable or target.replica._.bogd_com_acceptable
        if replica_com and replica_com:Test(item,doer,true) then
            return target.components.bogd_com_acceptable:OnAccept(item,doer)
        end
    end
    return false
end
AddAction(BOGD_COM_ACCEPTABLE_ACTION)

--- 【重要笔记】AddComponentAction 函数有陷阱，一个MOD只能对一个组件添加一个动作。
--- 【重要笔记】例如AddComponentAction("USEITEM", "inventoryitem", ...) 在整个MOD只能使用一次。
--- 【重要笔记】modname 参数伪装也不能绕开。


-- AddComponentAction("EQUIPPED", "npng_com_book" , function(inst, doer, target, actions, right)    --- 装备后多个技能
-- AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- -- 一个物品对另外一个目标用的技能，物品身上有 这个com 就能触发
-- AddComponentAction("SCENE", "npng_com_book" , function(inst, doer, actions, right)-------    建筑一类的特殊交互使用
-- AddComponentAction("INVENTORY", "npng_com_book", function(inst, doer, actions, right)   ---- 拖到玩家自己身上就能用
-- AddComponentAction("POINT", "complexprojectile", function(inst, doer, pos, actions, right)   ------ 指定坐标位置用。

-- 在后续注册了，这里暂时注释掉。

AddComponentAction("USEITEM", "inventoryitem", function(item, doer, target, actions, right_click) -- -- 一个物品对另外一个目标用的技能，
    if doer and item and target then
        local bogd_com_acceptable_com = target.replica.bogd_com_acceptable or target.replica._.bogd_com_acceptable
        if bogd_com_acceptable_com and bogd_com_acceptable_com:Test(item,doer,right_click) then
            table.insert(actions, ACTIONS.BOGD_COM_ACCEPTABLE_ACTION)
        end        
    end
end)

local function handler_fn(player)
    local creash_flag , ret = pcall(function()
        local target = player.bufferedaction.target
        local item = player.bufferedaction.invobject
        local ret_sg_action = "give"
        local replica_com = target and ( target.replica.bogd_com_acceptable or target.replica._.bogd_com_acceptable )
        if replica_com then
            ret_sg_action = replica_com:GetSGAction()
            replica_com:DoPreAction(item,player)
        end
        return ret_sg_action

    end)
    if creash_flag == true then
        return ret
    else
        print("error in BOGD_COM_ACCEPTABLE_ACTION ActionHandler")
        print(ret)
    end
    return "give"
end

AddStategraphActionHandler("wilson",ActionHandler(BOGD_COM_ACCEPTABLE_ACTION,function(player)
    return handler_fn(player)
end))
AddStategraphActionHandler("wilson_client",ActionHandler(BOGD_COM_ACCEPTABLE_ACTION, function(player)    
    return handler_fn(player)
end))


STRINGS.ACTIONS.BOGD_COM_ACCEPTABLE_ACTION = STRINGS.ACTIONS.BOGD_COM_ACCEPTABLE_ACTION or {
    DEFAULT = STRINGS.ACTIONS.ADDCOMPOSTABLE
}



