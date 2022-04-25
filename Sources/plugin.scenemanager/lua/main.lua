-- Sample app for the SceneManager plugin for Solar2D
-- Documentation: https://github.com/stalker-66/SceneManager/

local scenemanager = require "plugin.scenemanager"

scenemanager.init({
	scenes = {
		["scForm"] = require "scForm",
		["scScene1"] = require "scScene1",
	},
	debug = true,
	-- testTheme = true,
	-- updateThemeSec = 2,
})

scenemanager.create("scForm",{
	testVar = "TestCreateVar",

	-- effect = "shakeScale",
	-- effectTimeMs = 250,
	-- effectIntensity = 1.35,

	onInit = function() print("onInit") end,
	onCreate = function() print("onCreate") end,
	onShow = function() print("onShow") end,
})

scenemanager.create("scScene1",{
	testVar = "TestCreateVar",

	-- effect = "shakeScale",
	-- effectTimeMs = 250,
	-- effectIntensity = 1.35,

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

-- scenemanager.hideAll({
-- 	effect = "hideAlpha",
-- 	effectTimeMs = 500,
-- 	onHide = function() print( "onHideAll" ) end,
-- })

-- print( "scForm is show:", scenemanager.isShow("scForm") )
-- print( "scForm is create:", scenemanager.isCreate("scForm") )

-- timer.performWithDelay( 1000, function()
-- 	scenemanager.hide("scForm",{
-- 		testVar = "TestCreateVar",

-- 		effect = "hideHeightDown",
-- 		effectTimeMs = 500,
-- 	})
-- end )


-- timer.performWithDelay( 1000, function()
-- 	scenemanager.hideAll({
-- 		effect = "hideAlpha",
-- 		effectTimeMs = 500,
-- 		onHide = function()
-- 			print( "onHideAll" )
-- 		end,
-- 	})
-- end )