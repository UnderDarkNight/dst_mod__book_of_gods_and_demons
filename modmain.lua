GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 语言检查
	--- en  ch
	TUNING.BOGD_LANGUAGE = GetModConfigData("LANGUAGE") --- 语言
	TUNING.BOGD_GET_LANGUAGE = TUNING.BOGD_GET_LANGUAGE or function()
		if TUNING.BOGD_LANGUAGE == "auto" then
			if LOC.GetLanguage() == LANGUAGE.CHINESE_S or LOC.GetLanguage() == LANGUAGE.CHINESE_S_RAIL or LOC.GetLanguage() == LANGUAGE.CHINESE_T then
				TUNING.BOGD_LANGUAGE = "ch"
				return TUNING.BOGD_LANGUAGE
			else
				TUNING.BOGD_LANGUAGE = "en"
				return TUNING.BOGD_LANGUAGE
			end
		else
			return TUNING.BOGD_LANGUAGE
		end
	end
	
	TUNING.BOGD_GET_STRINGS = function()
		return {}
	end
	TUNING.BOGD_GET_ALL_STRINGS = function()
		return {}
	end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 测试模式
	TUNING.BOGD_DEBUGGING_MODE = GetModConfigData("DEBUGGING_MODE") --- 开发者模式
	TUNING.BOGD_CONFIG = {}
	TUNING.BOGD_CONFIG.modname = modname
	if TUNING.BOGD_DEBUGGING_MODE then
		AddPlayerPostInit(function(player_inst)	---- 玩家进入后再执行。检查。
			if not TheWorld.ismastersim then
				return
			end
			player_inst:DoTaskInTime(2,function()
				TheNet:SystemMessage("神魔修仙录 测试模式 已开启")
			end)
		end)
	end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
	Assets = {	}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 加载基础的素材库
	modimport("imports_of_bogd/__all_imports_init.lua")	---- 所有 import  文本库（语言库），素材库

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 关键函数库
	modimport("key_modules_of_bogd/_all_modules_init.lua")	---- 载入关键功能模块
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 物品prefab
	PrefabFiles = {
		"bogd__all_prefabs"
	}	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------