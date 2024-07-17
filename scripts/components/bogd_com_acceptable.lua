----------------------------------------------------------------------------------------------------------------------------------
--[[

     
     
]]--
----------------------------------------------------------------------------------------------------------------------------------
local bogd_com_acceptable = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
end,
nil,
{

})



function bogd_com_acceptable:SetOnAcceptFn(fn)
    if type(fn) == "function" then
        self.on_accept_fn = fn
    end
end

function bogd_com_acceptable:OnAccept(item,doer)
    if self.on_accept_fn then
        return self.on_accept_fn(self.inst,item,doer)
    end
end


return bogd_com_acceptable






