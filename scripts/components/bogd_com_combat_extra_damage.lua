----------------------------------------------------------------------------------------------------------------------------------
--[[

    独立额外的伤害加成

]]--
----------------------------------------------------------------------------------------------------------------------------------
local bogd_com_combat_extra_damage = Class(function(self, inst)
    self.inst = inst

    self.damage = 0

    --------------------------------------------------
    ---
        self.__modifier_fn = {}
        self.__tempInst_onremove_fn = function(tempInst)
            self:RemoveModifier(tempInst)
        end
    --------------------------------------------------

end,
nil,
{

})
---------------------------------------------------------------------------------------------------
----
---------------------------------------------------------------------------------------------------
----
    function bogd_com_combat_extra_damage:DoDelta(value)
        self.damage = self.damage + value
    end
---------------------------------------------------------------------------------------------------
    function bogd_com_combat_extra_damage:GetDamage()
        return self.damage
    end
---------------------------------------------------------------------------------------------------
--- 额外定义器
    function bogd_com_combat_extra_damage:SetModifier(tempInst,fn)
        self.__modifier_fn[tempInst] = fn
        tempInst:ListenForEvent("onremove",self.__tempInst_onremove_fn)
    end
    function bogd_com_combat_extra_damage:RemoveModifier(tempInst)
        local new_table = {}
        for k, v in pairs(self.__modifier_fn) do
            if k ~= tempInst then
                new_table[k] = v
            end
        end
        self.__modifier_fn = new_table
        tempInst:RemoveEventCallback("onremove",self.__tempInst_onremove_fn)
    end
    function bogd_com_combat_extra_damage:GetModifierDMG(origin_damage)
        local ret_dmg = 0
        for index_inst, fn in pairs(self.__modifier_fn) do
            ret_dmg = ret_dmg + (fn(origin_damage) or 0)
            index_inst:PushEvent("bogd_com_combat_extra_damage_get_modifier_dmg")
        end
        return ret_dmg
    end
---------------------------------------------------------------------------------------------------
return bogd_com_combat_extra_damage







