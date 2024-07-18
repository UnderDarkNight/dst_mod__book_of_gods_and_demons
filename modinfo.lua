author = "幕夜之下"
-- from stringutil.lua
local the_version = "0.00.01.00"

--------------------------------------------------------------------------------------------------------------------------------------------------------
-- 语言相关的基础API  ---- 参数表： loc.lua 里面的localizations 表，code 为 这里用的index
  local function IsChinese()
    if locale == nil then
      return true
    else
      return locale == "zh" or locate == "zht" or locate == "zhr" or false
    end
  end
  local function ChooseTranslationTable_Test(_table)
    if ChooseTranslationTable then
      return ChooseTranslationTable(_table)
    else
      return _table["zh"]
    end
  end
--------------------------------------------------------------------------------------------------------------------------------------------------------
-- from stringutil.lua
  local function tostring(arg)
    if arg == true then
      return "true"
    elseif arg == false then
      return "false"
    elseif arg == nil then
      return "nil"
    end    
    return arg .. ""
  end
  local function ipairs(tbl)
    return function(tbl, index)
      index = index + 1
      local next = tbl[index]
      if next then
        return index, next
      end
    end, tbl, 0
  end
--------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetName()  
  local temp_table = {
      "Book of Gods and Demons",                               ----- 默认情况下(英文)
      ["zh"] = "神魔修仙录",                                 ----- 中文
  }
  return ChooseTranslationTable_Test(temp_table)
end

local function GetDesc()
  local temp_table = {
    [[

      Book of Gods and Demons

    ]],
    ["zh"] = [[

      神魔修仙录

    ]]
  }
  local ret = the_version .. "  \n\n"..ChooseTranslationTable_Test(temp_table)
  return ret
end

name = GetName() or "神魔修仙录"
description = GetDesc() or "神魔修仙录"

version = the_version or 0.1 ------ MOD版本，上传的时候必须和已经在工坊的版本不一样

api_version = 10
icon_atlas = "modicon.xml"
icon = "modicon.tex"
forumthread = ""
dont_starve_compatible = true
dst_compatible = true
all_clients_require_mod = true

priority = 100000000000000  -- MOD加载优先级 影响某些功能的兼容性，比如官方Com 的 Hook
  ----------------------------------------------------------------------------------------------------------

  ----------------------------------------------------------------------------------------------------------
  --- options
    local function Create_Number_Setting(start_num,stop_num,delta_num)
        local temp_options = {}
        local temp_index = 1
        delta_num = delta_num or 1
        for i = start_num, stop_num, delta_num do
            temp_options[temp_index] = {description = tostring(i), data = i}
            temp_index = temp_index + 1
        end
        return temp_options
    end
    local options_number_0_to_100 = Create_Number_Setting(0,100)
    local options_number_1_to_100 = Create_Number_Setting(1,100)
    local options_number_1_to_20 = Create_Number_Setting(1,20)
  ----------------------------------------------------------------------------------------------------------
  --- options percent
    local function Create_Percent_Setting(start_num,stop_num,delta_num)
        local temp_options = {}
        local temp_index = 1
        delta_num = delta_num or 0.01
        for i = start_num, stop_num, delta_num do
            temp_options[temp_index] = {description = tostring(i*100).."%", data = i}
            temp_index = temp_index + 1
        end
        return temp_options
    end
  ----------------------------------------------------------------------------------------------------------
  --- 按键
      local keys_option = {
        {description = "KEY_A", data = "KEY_A"},
        {description = "KEY_B", data = "KEY_B"},
        {description = "KEY_C", data = "KEY_C"},
        {description = "KEY_D", data = "KEY_D"},
        {description = "KEY_E", data = "KEY_E"},
        {description = "KEY_F", data = "KEY_F"},
        {description = "KEY_G", data = "KEY_G"},
        {description = "KEY_H", data = "KEY_H"},
        {description = "KEY_I", data = "KEY_I"},
        {description = "KEY_J", data = "KEY_J"},
        {description = "KEY_K", data = "KEY_K"},
        {description = "KEY_L", data = "KEY_L"},
        {description = "KEY_M", data = "KEY_M"},
        {description = "KEY_N", data = "KEY_N"},
        {description = "KEY_O", data = "KEY_O"},
        {description = "KEY_P", data = "KEY_P"},
        {description = "KEY_Q", data = "KEY_Q"},
        {description = "KEY_R", data = "KEY_R"},
        {description = "KEY_S", data = "KEY_S"},
        {description = "KEY_T", data = "KEY_T"},
        {description = "KEY_U", data = "KEY_U"},
        {description = "KEY_V", data = "KEY_V"},
        {description = "KEY_W", data = "KEY_W"},
        {description = "KEY_X", data = "KEY_X"},
        {description = "KEY_Y", data = "KEY_Y"},
        {description = "KEY_Z", data = "KEY_Z"},
        {description = "KEY_F1", data = "KEY_F1"},
        {description = "KEY_F2", data = "KEY_F2"},
        {description = "KEY_F3", data = "KEY_F3"},
        {description = "KEY_F4", data = "KEY_F4"},
        {description = "KEY_F5", data = "KEY_F5"},
        {description = "KEY_F6", data = "KEY_F6"},
        {description = "KEY_F7", data = "KEY_F7"},
        {description = "KEY_F8", data = "KEY_F8"},
        {description = "KEY_F9", data = "KEY_F9"},
      
      }
  ----------------------------------------------------------------------------------------------------------

 configuration_options =
  {
  ----------------------------------------------------------------------------------------------------------
  ---
      {
        name = "LANGUAGE",
        label = "Language/语言",
        hover = "Set Language/设置语言",
        options =
        {
          {description = "Auto/自动", data = "auto"},
          {description = "English", data = "en"},
          {description = "中文", data = "ch"},
        },
        default = "auto",
      }, 
      
  ----------------------------------------------------------------------------------------------------------
  ---
      {name = "AAAB",label = "",hover = "",options ={{description = "", data = true}},default = true,}, 
      {
        name = "EXP_MULT",
        label = IsChinese() and "经验倍率" or "Experience Multiplier",
        hover = IsChinese() and "经验倍率" or "Experience Multiplier",
        options = Create_Number_Setting(0.5,20,0.5),
        default = 1,
      }, 
  ----------------------------------------------------------------------------------------------------------
  ---
      {name = "AAAB",label = "",hover = "",options ={{description = "", data = true}},default = true,}, 
      {
        name = "DEBUGGING_MODE",
        label = "测试模式",
        hover = "测试模式",
        options =
        {
          {description = "ON", data = true},
          {description = "OFF", data = false},
        },
        default = false,
      }, 
  ----------------------------------------------------------------------------------------------------------
  
}

