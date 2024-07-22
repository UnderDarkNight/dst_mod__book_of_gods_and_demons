----------------------------------------------------------------------------------------------------------------------------------
--[[
    
]]--
----------------------------------------------------------------------------------------------------------------------------------
local bogd_com_map_jumper = Class(function(self, inst)
    self.inst = inst
end,
nil,
{

})

function bogd_com_map_jumper:SetSpellFn(fn)
    if type(fn) == "function" then
        self.spellFn = fn
    end
end
function bogd_com_map_jumper:CastSpell(pt)
    if self.spellFn then
        return self.spellFn(self.inst,pt)
    end
end

function bogd_com_map_jumper:SetPreSpellFn(fn)
    if type(fn) == "function" then
        self.preSpellFn = fn
    end
end
function bogd_com_map_jumper:CastPreSpell(pt)
    if self.preSpellFn then
        return self.preSpellFn(self.inst,pt)
    end
end

return bogd_com_map_jumper


