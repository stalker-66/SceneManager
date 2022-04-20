-- init
local publisherId = "com.narkoz"
local pluginName = "scenemanager"

local public = require "CoronaLibrary":new{ name=pluginName, publisherId=publisherId }

-- add modules/optimization
local json = require "json"
local json_prettify = json.prettify
local _pairs = pairs

-- private
local private = {
	init = false,
	debug = false,
	list = {},
	createList = {},
	showList = {},
}

private.addCreateList = function(sceneName)
	if not private.init then return false end

	local sceneName = sceneName or "nil"
	private.createList[#private.createList+1] = sceneName

	return true
end

private.remCreateList = function(sceneName)
	if not private.init then return false end

	local sceneName = sceneName or "nil"
	local newCreateList = {}
	for i=1,#private.createList do
		if private.createList[i]~=sceneName then
			newCreateList[#newCreateList+1] = private.createList[i]
		end
	end
	private.createList = newCreateList

	return true
end

private.addShowList = function(sceneName)
	if not private.init then return false end

	local sceneName = sceneName or "nil"
	private.showList[#private.showList+1] = sceneName

	return true
end

private.remShowList = function(sceneName)
	if not private.init then return false end

	local sceneName = sceneName or "nil"
	local newShowList = {}
	for i=1,#private.showList do
		if private.showList[i]~=sceneName then
			newShowList[#newShowList+1] = private.showList[i]
		end
	end
	private.showList = newShowList

	return true
end

-- public
public.init = function(sceneList,params)
	if private.init then return false end

	local sceneList = sceneList or {}
	local params = params or {}
	params.debug = params.debug

	if params.debug then
		private.debug = params.debug
	end

	for k,v in _pairs(sceneList) do
		private.list[k] = v

		if private.list[k] then
			if private.debug then
				print( "SceneManager: Scene is Loaded: \""..k.."\"" )
			end
		else
			if private.debug then
				print( "SceneManager: Error Scene Loading: \""..k.."\"" )
			end
		end
	end

	private.init = true

	return true
end

public.stop = function()
	if not private.init then return false end

	private.init = false
	private.debug = false
	private.list = {}
	private.createList = {}
	private.showList = {}

	return true
end

public.isCreate = function(sceneName)
	if not private.init then return false end

	local sceneName = sceneName or "nil"
	local isExist = false
	for i=1,#private.createList do
		if private.createList[i]==sceneName then
			isExist = true
			break
		end
	end
	return isExist
end

public.create = function(sceneName,params)
	if not private.init then return false end

	local sceneName = sceneName or "nil"
	local params = params or {}

	if private.list[sceneName] then
		if public.isCreate(sceneName) then
			if private.debug then
				print( "SceneManager: Error Scene Create. Scene is Exist: \""..sceneName.."\"" )
			end

			return false
		end
		private.addCreateList(sceneName)
		private.list[sceneName].defCreate(
			{
				sceneName = sceneName,
			}
		)

		return true
	else
		if private.debug then
			print( "SceneManager: Error Scene Create. Scene Doesn't Exist: \""..sceneName.."\"" )
		end

		return false
	end
end

public.destroy = function(sceneName,params)
	if not private.init then return false end

	local sceneName = sceneName or "nil"
	local params = params or {}

	if private.list[sceneName] then
		if not public.isCreate(sceneName) then
			if private.debug then
				print( "SceneManager: Error Scene Destroy. Scene not Сreated: \""..sceneName.."\"" )
			end

			return false
		end
		private.remCreateList(sceneName)
		private.list[sceneName].defDestroy(
			{
				sceneName = sceneName,
			}
		)
	else
		if private.debug then
			print( "SceneManager: Error Scene Destroy. Scene Doesn't Exist: \""..sceneName.."\"" )
		end
	end
end

public.isShow = function(sceneName)
	if not private.init then return false end

	local sceneName = sceneName or "nil"
	local isExist = false
	for i=1,#private.showList do
		if private.showList[i]==sceneName then
			isExist = true
			break
		end
	end
	return isExist
end

public.show = function(sceneName,params)
	if not private.init then return false end

	local sceneName = sceneName or "nil"
	local params = params or {}

	if private.list[sceneName] then
		if not public.isCreate(sceneName) then
			if private.debug then
				print( "SceneManager: Error Scene Show. Scene not Сreated: \""..sceneName.."\"" )
			end

			return false
		end
		if public.isShow(sceneName) then
			if private.debug then
				print( "SceneManager: Error Scene Show. Scene is Showed: \""..sceneName.."\"" )
			end

			return false
		end
		private.addShowList(sceneName)
		private.list[sceneName].defShow(
			{
				sceneName = sceneName,
			}
		)

		return true
	else
		if private.debug then
			print( "SceneManager: Error Scene Show. Scene Doesn't Exist: \""..sceneName.."\"" )
		end

		return false
	end
end

public.hide = function(sceneName,params)
	if not private.init then return false end

	local sceneName = sceneName or "nil"
	local params = params or {}

	if private.list[sceneName] then
		if not public.isCreate(sceneName) then
			if private.debug then
				print( "SceneManager: Error Scene Hide. Scene not Сreated: \""..sceneName.."\"" )
			end

			return false
		end
		if not public.isShow(sceneName) then
			if private.debug then
				print( "SceneManager: Error Scene Hide. Scene is Hidden: \""..sceneName.."\"" )
			end
		
			return false
		end
		private.remShowList(sceneName)
		private.list[sceneName].defHide(
			{
				sceneName = sceneName,
			}
		)
	else
		if private.debug then
			print( "SceneManager: Error Scene Hide. Scene Doesn't Exist: \""..sceneName.."\"" )
		end
	end
end

public.new = function()
	local scene = {}

	scene.init = function(params)
	end
	scene.create = function(params)
	end
	scene.destroy = function(params)
	end
	scene.show = function(params)
	end
	scene.hide = function(params)
	end
	scene.update = function(e)
	end

	scene.defContent = {
		width = display.contentWidth,
		height = display.contentHeight,
	}
	scene.defInit = function(defParams,params)
		local defParams = defParams or {}
		local params = params or {}

		scene.init(params)

		if private.debug then
			print( "SceneManager: Scene is Init: \""..defParams.sceneName.."\"" )
		end
	end
	scene.defCreate = function(defParams,params)
		local defParams = defParams or {}
		local params = params or {}

		scene.create(params)

		if private.debug then
			print( "SceneManager: Scene is Create: \""..defParams.sceneName.."\"" )
		end
	end
	scene.defDestroy = function(defParams,params)
		local defParams = defParams or {}
		local params = params or {}

		scene.destroy(params)

		if private.debug then
			print( "SceneManager: Scene is Destroy: \""..defParams.sceneName.."\"" )
		end
	end
	scene.defShow = function(defParams,params)
		local defParams = defParams or {}
		local params = params or {}

		scene.show(params)
		Runtime:addEventListener("enterFrame", scene.defUpdate )

		if private.debug then
			print( "SceneManager: Scene is Show: \""..defParams.sceneName.."\"" )
		end
	end
	scene.defHide = function(defParams,params)
		local defParams = defParams or {}
		local params = params or {}

		scene.hide(params)
		Runtime:removeEventListener("enterFrame", scene.defUpdate )

		if private.debug then
			print( "SceneManager: Scene is Hide: \""..defParams.sceneName.."\"" )
		end
	end
	scene.defUpdate = function(e)
		scene.update(e)
	end

	return scene
end

return public
