--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

TUNING.BOGD_FN = TUNING.BOGD_FN or {}

-----------------------------------------------------------------------
-- 文本相关
    function TUNING.BOGD_FN:GetStringWithName(index1,index2,name)
        local creash_flag, ret = pcall(function()            
            local str = TUNING.BOGD_GET_STRINGS(index1)[index2] or "unkown info string with {name}"
            local replacedText = str:gsub("{name}",tostring(name))
            return replacedText
        end)
        if creash_flag then
            return ret
        else
            return "unkown info string with"..tostring(index1).."   "..tostring(index2).."   "..tostring(name)
        end
    end
    function TUNING.BOGD_FN:GetStrings(prefab,index)
        local prefab_table = TUNING.BOGD_GET_STRINGS(prefab) or {}
        if index then
            return prefab_table[index]
        else
            return prefab_table
        end
    end
    function TUNING.BOGD_FN:GetAllStrings()
        return TUNING.BOGD_GET_ALL_STRINGS()
    end
-----------------------------------------------------------------------
-- 
    function TUNING.BOGD_FN:GetSurroundPoints(CMD_TABLE) -- 获取一圈坐标
        -- local CMD_TABLE = {
        --     target = inst or Vector3(),
        --     range = 8,
        --     num = 8
        -- }
        if CMD_TABLE == nil then
            return
        end
        if CMD_TABLE.pt then
            CMD_TABLE.target = CMD_TABLE.pt
        end
        local theMid = nil
        if CMD_TABLE.target == nil then
            theMid = Vector3( self.inst.Transform:GetWorldPosition() )
        elseif CMD_TABLE.target.x then
            theMid = CMD_TABLE.target
        elseif CMD_TABLE.target.prefab then
            theMid = Vector3( CMD_TABLE.target.Transform:GetWorldPosition() )
        else
            return
        end
        -- --------------------------------------------------------------------------------------------------------------------
        -- -- 8 points
        -- local retPoints = {}
        -- for i = 1, 8, 1 do
        --     local tempDeg = (PI/4)*(i-1)
        --     local tempPoint = theMidPoint + Vector3( Range*math.cos(tempDeg) ,  0  ,  Range*math.sin(tempDeg)    )
        --     table.insert(retPoints,tempPoint)
        -- end
        -- --------------------------------------------------------------------------------------------------------------------
        local num = CMD_TABLE.num or 8
        local range = CMD_TABLE.range or 8
        local retPoints = {}
        for i = 1, num, 1 do
            local tempDeg = (2*PI/num)*(i-1)
            local tempPoint = theMid + Vector3( range*math.cos(tempDeg) ,  0  ,  range*math.sin(tempDeg)    )
            table.insert(retPoints,tempPoint)
        end

        return retPoints


    end
-----------------------------------------------------------------------
-- 热键
    local keys_by_index  = {
        KEY_A = 97,
        KEY_B = 98,
        KEY_C = 99,
        KEY_D = 100,
        KEY_E = 101,
        KEY_F = 102,
        KEY_G = 103,
        KEY_H = 104,
        KEY_I = 105,
        KEY_J = 106,
        KEY_K = 107,
        KEY_L = 108,
        KEY_M = 109,
        KEY_N = 110,
        KEY_O = 111,
        KEY_P = 112,
        KEY_Q = 113,
        KEY_R = 114,
        KEY_S = 115,
        KEY_T = 116,
        KEY_U = 117,
        KEY_V = 118,
        KEY_W = 119,
        KEY_X = 120,
        KEY_Y = 121,
        KEY_Z = 122,
        KEY_F1 = 282,
        KEY_F2 = 283,
        KEY_F3 = 284,
        KEY_F4 = 285,
        KEY_F5 = 286,
        KEY_F6 = 287,
        KEY_F7 = 288,
        KEY_F8 = 289,
        KEY_F9 = 290,
        KEY_F10 = 291,
        KEY_F11 = 292,
        KEY_F12 = 293,
    }
    local function check_is_text_inputting()    
        -- 代码来自  TheFrontEnd:OnTextInput
        local screen = TheFrontEnd and TheFrontEnd:GetActiveScreen()
        if screen ~= nil then
            if TheFrontEnd.forceProcessText and TheFrontEnd.textProcessorWidget ~= nil then
                return true
            else
                return false
            end
        end
        return false
    end
    function TUNING.BOGD_FN:IsKeyPressed(str_index,key)
        if check_is_text_inputting() then
            return false
        end
        if key == keys_by_index[str_index] then
            return true
        end
        return false
    end
-----------------------------------------------------------------------