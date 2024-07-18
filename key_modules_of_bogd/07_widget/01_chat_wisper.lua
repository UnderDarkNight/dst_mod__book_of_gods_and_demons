---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

        widgets/text   偶发性的崩溃：  [string "scripts/widgets/text.lua"]:58: bad argument #3 to 'SetColour' (number expected, got no value)
        widgets/text SetColour

]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddClassPostConstruct("widgets/text",function(self)
    local old_fn = self.SetColour
    self.SetColour = function(self,r,g,b,a)
        local colour = type(r) == "number" and { r, g, b, a } or r
        r,g,b,a = unpack(colour)
        old_fn(self,r or 1,g or 1,b or 1 ,a or 1)
    end
end)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    hook chathistory 模块，实现系统悄悄话。  chathistory.lua
    function ChatHistoryManager:GenerateChatMessage(type, sender_userid, sender_netid, sender_name, message, colour, icondata, whisper, localonly, text_filter_context)
    改掉其中一个参数
    客户端用 ChatHistory:AddToHistory 执行显示语句，该函数内部会调用 ChatHistory.GenerateChatMessage

    icondata : "profileflair_treasurechest_monster" ,"default"  在文件 misc_items.lua 里，部分需要玩家解锁。
    icon 的尺寸为90x90像素，具体参数前往 profileflair.tex 和 profileflair.xml 查看。如果是自己制作，推荐使用 autocompiler.exe 自动编译 png 成 tex + xml (png放文件夹里会自动进行)
    ChatHistory:AddToHistory({flag = "bogd" , ChatType = ChatTypes.Message , m_colour = {0,0,255} , s_colour = {255,255,0}},nil,nil,"NPC","656565",{0,255,0})
    m_colour 文本颜色，  s_colour 名字颜色
    colour 参数 和官方的有出入，  需要除以255才能成任意色。
    ChatType 在 chatline.lua 里有执行逻辑

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


ChatHistory.GenerateChatMessage_old_bogd = ChatHistory.GenerateChatMessage
ChatHistory.GenerateChatMessage = function(self,Chat_type, sender_userid, sender_netid, sender_name, message, colour, icondata, whisper, localonly, text_filter_context)
    local bogd_cmd_table = {}
    if Chat_type and type(Chat_type) == "table" and Chat_type.flag == "bogd" then
        bogd_cmd_table = deepcopy(Chat_type)
        Chat_type = bogd_cmd_table.ChatType or ChatTypes.Message                        ---- 文本类型
        localonly = true                                                                ---- 只在本地
        icondata = bogd_cmd_table.icondata or icondata -- or "default"                     ---- 图标
        sender_name = bogd_cmd_table.sender_name or sender_name                         ---- 发送者名字
        message = bogd_cmd_table.message or message                                     ---- 文字内容
        colour = bogd_cmd_table.s_colour or bogd_cmd_table.m_colour or {255/255,255/255,255/255}    ---- 颜色初始化。
    end

    local ret_chat_message = self:GenerateChatMessage_old_bogd(Chat_type, sender_userid, sender_netid, sender_name, message, colour, icondata, whisper, localonly, text_filter_context)
    
    if bogd_cmd_table.flag == "bogd" then
        if bogd_cmd_table.m_colour then            
            ret_chat_message.m_colour = bogd_cmd_table.m_colour --- 文本颜色
        end
        if bogd_cmd_table.s_colour then
            ret_chat_message.s_colour = bogd_cmd_table.s_colour --- 文本颜色
        end
    end

    return ret_chat_message
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 在 client 端 给玩家添加 event
AddPlayerPostInit(function(inst)
    
    if TheNet:IsDedicated() then    -- 是服务器加载到这就返回。 事件添加到 客户端足够了，用 RPC EVENT 下发
        return
    end

    inst:ListenForEvent("bogd_event.whisper",function(_,_table)
        if _table and _table.message then
            _table.flag = "bogd"
            ChatHistory:AddToHistory(_table)
        end
    end)

end)