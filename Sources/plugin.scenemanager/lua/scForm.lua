-- Scene template for the SceneManager plugin
-- @author Narkoz
-- @skype stalker66_vlad

local scenemanager = require "plugin.scenemanager"
local scene = scenemanager.new()

scene.init = function(p)
	print( "scene.init" )
end

scene.create = function(p)
	print( "scene.create" )
end

scene.show = function(p)
	print( "scene.show" )
end

scene.hide = function(p)
	print( "scene.hide" )
end

scene.destroy = function(p)
	print( "scene.destroy" )
end

return scene