-- @author Narkoz
-- @mail stalker66.production@gmail.com
-- Scene template for the SceneManager plugin

local scenemanager = require "plugin.scenemanager"
local scene = scenemanager.new({modeTheme="auto"})

-- Executed before calling "create"
scene.init = function(p)
	local content = p.content 	-- table: basic scene parameters
	local custom = p.custom 	-- table: custom-parameters when scene create

	print( "scene.init" )
end

-- Executed when the scene is created
-- Suitable for static objects
scene.create = function(p)
	local content = p.content 	-- table: basic scene parameters
	local gr = p.parent			-- DisplayObject: basic create group(removed when destroyed)
	local ui = p.ui 			-- table: base create-table for ui objects(removed when destroyed)
	local specUI = p.specUI 	-- table: special create-table for ui objects(each object in the table will be deleted separately/removed when destroyed)
	local timers = p.timers 	-- table: base create-table for timers(pause when hide/resume when show/cancel when destroyed)
	local custom = p.custom 	-- table: custom-parameters when scene create

	-- example ui-object create
	ui.uiRect = display.newRect(gr,content.centerX,content.centerY-content.height*.25,content.width*.25,content.height*.25)
	-- example filling for light and dark mode
	scene.setColor(ui.uiRect,{default="Orange",dark="Lime"})

	-- example specUI-object create
	specUI.specRect = display.newRect(gr,content.centerX,content.centerY+content.height*.25,content.width*.25,content.height*.25)
	-- example default fill
	scene.setColor(specUI.specRect,"CadetBlue")

	-- timer example
	-- timers.timerTest = timer.performWithDelay( 1000, function(e)
	-- 	print( "tic-tac", e.count )
	-- end, 0 )

	print( "scene.create" )
end

-- Executed after calling "create"
-- Suitable for dynamic objects
scene.show = function(p)
	local content = p.content 	-- table: basic scene parameters
	local gr = p.parent			-- DisplayObject: basic show group(added to basic create group/removed when hide)
	local ui = p.ui 			-- table: base show-table for ui objects(removed when hide)
	local specUI = p.specUI 	-- table: special show-table for ui objects(each object in the table will be deleted separately/removed when hide)
	local timers = p.timers 	-- table: base show-table for timers(cancel when hide)
	local custom = p.custom 	-- table: custom-parameters when scene create/show

	-- timer example
	timers.timerTest = timer.performWithDelay( 500, function(e)
		-- example ui-object create
		ui.uiCircle = display.newCircle(gr,content.centerX,content.centerY,content.height*.1)
		-- example filling for light and dark mode
		scene.setColor(ui.uiCircle,{default="HotPink",dark="Black"})
	end, 1 )

	print( "scene.show" )
end

-- Executed before calling "destroy"
scene.hide = function(p)
	print( "scene.hide" )
end

-- Executed when the scene is destroy
scene.destroy = function(p)
	print( "scene.destroy" )
end

-- Executed when the application is suspend
scene.suspend = function()
	print( "scene.suspend" )
end

-- Executed when the application is resume
scene.resume = function()
	print( "scene.resume" )
end

-- Events occur at the frames-per-second interval of the application
-- Either 30 or 60 frames-per-second as specified in config.lua
-- If scene is hide, then the update will not be work
scene.update = function(e)
	-- print( "scene.update", e.frame )
end

return scene