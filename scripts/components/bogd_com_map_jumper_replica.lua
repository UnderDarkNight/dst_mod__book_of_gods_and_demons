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

function bogd_com_map_jumper:SetTestFn(fn)
    if type(fn) == "function" then
        self.test_fn = fn
    end
end
function bogd_com_map_jumper:Test(pt)
    if self.test_fn then
        return self.test_fn(self.inst,pt)
    end
    return false
end

return bogd_com_map_jumper


