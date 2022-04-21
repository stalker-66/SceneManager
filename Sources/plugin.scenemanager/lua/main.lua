-- Sample app for the SceneManager plugin for Solar2D
-- Documentation: https://github.com/stalker-66/SceneManager/

local scenemanager = require "plugin.scenemanager"

scenemanager.init({
	scenes = {
		["scForm"] = require "scForm",
	},
	debug = true,
	-- testTheme = true,
	-- updateThemeSec = 2,
})

scenemanager.create("scForm",{
	testVar = "TestCreateVar",

	effect = "showAlpha",
	effectTimeMs = 500,
	-- effectIntensity = 1,

	onInit = function() print("onInit") end,
	onCreate = function() print("onCreate") end,
	onShow = function() print("onShow") end,
})

-- scenemanager.show("scForm",{
-- 	testVar = "TestCreateVar",
-- 	onShow = function() print("onShow") end,
-- })

-- scenemanager.hide("scForm",{
-- 	testVar = "TestCreateVar",
-- 	onHide = function() print("onHide") end,
-- })

-- scenemanager.destroy("scForm",{
-- 	testVar = "TestCreateVar",
-- 	onHide = function() print("onHide") end,
-- 	onDestroy = function() print("onDestroy") end,
-- })

-- print( "scForm is show:", scenemanager.isShow("scForm") )
-- print( "scForm is create:", scenemanager.isCreate("scForm") )