-- Sample app for the SceneManager plugin for Solar2D
-- Documentation: https://github.com/stalker-66/SceneManager/

local scenemanager = require "plugin.scenemanager"

scenemanager.init({
	["scForm"] = require "scForm",
},{
	debug = true,
})

-- scenemanager.create("scForm")
-- scenemanager.show("scForm")
-- scenemanager.hide("scForm")
-- scenemanager.destroy("scForm")