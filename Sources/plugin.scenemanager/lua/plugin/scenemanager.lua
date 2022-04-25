-- init
local publisherId = "com.narkoz"
local pluginName = "scenemanager"

local public = require "CoronaLibrary":new{ name=pluginName, publisherId=publisherId }

-- add modules/optimization
local json = require "json"
local json_prettify = json.prettify
local string_len = string.len
local string_sub = string.sub
local math_round = math.round
local math_random = math.random
local math_abs = math.abs
local _pairs = pairs

-- private
local private = {
	init = false,
	debug = false,
	testTheme = false,
	updateThemeSec = 2,
	list = {},
	createList = {},
	showList = {},
}

private.table_copy = function(tb)
	if type(tb)~="table" then return tb end
	local a = {}
	for k, v in _pairs(tb) do a[private.table_copy(k)] = private.table_copy(v) end
	return a
end

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
public.init = function(params)
	if private.init then return false end

	local params = params or {}
	params.scenes = params.scenes or {}
	params.debug = params.debug
	params.testTheme = params.testTheme

	if params.debug then
		private.debug = params.debug
	end
	if params.testTheme then
		private.testTheme = params.testTheme
	end
	if params.updateThemeSec then
		private.updateThemeSec = params.updateThemeSec
	end

	for k,v in _pairs(params.scenes) do
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

	transition.ignoreEmptyReference = true
	timer.allowInterationsWithinFrame = true

	return true
end

public.stop = function()
	if not private.init then return false end

	private.init = false
	private.debug = false
	private.testTheme = false
	private.updateThemeSec = 2
	private.list = {}
	private.createList = {}
	private.showList = {}

	transition.ignoreEmptyReference = false
	timer.allowInterationsWithinFrame = false

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

public.getCreateList = function()
	return private.createList
end

public.getCreateLast = function()
	return private.createList[#private.createList]
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
		private.list[sceneName].defInit(
			{
				sceneName = sceneName,
			},
			params
		)
		private.list[sceneName].defCreate(
			{
				sceneName = sceneName,
			},
			params
		)
		public.show(sceneName,params)

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

		params.skipCheckCreate = true

		local _onHide = params.onHide
		params.onHide = function()
			if _onHide then
				_onHide()
				_onHide = nil
			end

			private.list[sceneName].defDestroy(
				{
					sceneName = sceneName,
				},
				params
			)
		end
		public.hide(sceneName,params)
		
	else
		if private.debug then
			print( "SceneManager: Error Scene Destroy. Scene Doesn't Exist: \""..sceneName.."\"" )
		end
	end
end

public.destroyAll = function(params)
	if not private.init then return false end

	local params = params or {}

	local createList = public.getCreateList()
	for i=1,#createList do
		local p = {
			effect = params.effect,
			effectTimeMs = params.effectTimeMs,
			effectIntensity = params.effectIntensity,
		}
		if i==#createList then
			p.onHide = params.onHide
			p.onDestroy = params.onDestroy
		end
		public.destroy(createList[i],p)
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

public.getShowList = function()
	return private.showList
end

public.getShowLast = function()
	return private.showList[#private.showList]
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
			},
			params
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
		if not public.isCreate(sceneName) and not params.skipCheckCreate then
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

		params.skipCheckCreate = nil

		private.list[sceneName].defHide(
			{
				sceneName = sceneName,
			},
			params
		)
	else
		if private.debug then
			print( "SceneManager: Error Scene Hide. Scene Doesn't Exist: \""..sceneName.."\"" )
		end
	end
end

public.hideAll = function(params)
	if not private.init then return false end

	local params = params or {}

	local showList = public.getShowList()
	for i=1,#showList do
		local p = {
			effect = params.effect,
			effectTimeMs = params.effectTimeMs,
			effectIntensity = params.effectIntensity,
		}
		if i==#showList then
			p.onHide = params.onHide
		end
		public.hide(showList[i],p)
	end
end

public.new = function(constructor)
	local constructor = constructor or {}
	constructor.width = constructor.width or display.contentWidth
	constructor.height = constructor.height or display.contentHeight
	constructor.centerX = constructor.centerX or display.contentWidth*.5
	constructor.centerY = constructor.centerY or display.contentHeight*.5
	constructor.safeX = constructor.safeX or display.safeScreenOriginX
	constructor.safeY = constructor.safeY or display.safeScreenOriginY
	constructor.modeTheme = constructor.modeTheme or "auto"

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
	scene.suspend = function()
	end
	scene.resume = function()
	end

	scene.defContent = {
		width = constructor.width,
		height = constructor.height,
		centerX = constructor.centerX,
		centerY = constructor.centerY,
		safeX = constructor.safeX,
		safeY = constructor.safeY,
		sceneTheme = public.getTheme(),
		modeTheme = constructor.modeTheme,
		startSec = 0,
	}
	scene.defLockTouch = function()
		return true
	end

	scene.effectSceneList = {
		["showAlpha"] = true,			["hideAlpha"] = true,
		["showLeft"] = true,			["hideLeft"] = true,
		["showRight"] = true,			["hideRight"] = true,
		["showUp"] = true,				["hideUp"] = true,
		["showDown"] = true,			["hideDown"] = true,
		["showClock"] = true,			["hideClock"] = true,
		["showCardUp"] = true,			["hideCardUp"] = true,
		["showCardDown"] = true,		["hideCardDown"] = true,
		["showZoom"] = true,			["hideZoom"] = true,
		["showWidthLeft"] = true,		["hideWidthLeft"] = true,
		["showWidthRight"] = true,		["hideWidthRight"] = true,
		["showHeightUp"] = true,		["hideHeightUp"] = true,
		["showHeightDown"] = true,		["hideHeightDown"] = true,
		["shake"] = true,				["shakeScale"] = true,
		["defShow"] = true,				["defHide"] = true,
	}
	scene.setAnimation = function(params)
		local params = params or {}
		params.effect = params.effect or "nil"
		params.effectTimeMs = params.effectTimeMs or 0
		params.effectIntensity = params.effectIntensity or 1

		if scene.defSceneTransition then
			transition.cancel(scene.defSceneTransition)
			scene.defSceneTransition = nil
		end
		
		if scene.grCreate then
			scene.defShake = nil
			scene.grCreate.alpha = 1
			scene.grCreate.isVisible = true
			scene.grCreate.x = 0
			scene.grCreate.y = 0
			scene.grCreate.rotation = 0
			scene.grCreate.xScale = 1
			scene.grCreate.yScale = 1
			scene.grCreate.anchorChildren = false
		end

		if scene.effectSceneList[params.effect] then
			if scene.grCreate then
				if params.effect=="showAlpha" then
					scene.grCreate.alpha = 0
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						alpha = 1,
						onComplete = function()
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="hideAlpha" then
					scene.grCreate.alpha = 1
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						alpha = 0,
						onComplete = function()
							scene.grCreate.isVisible = false
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="showLeft" then
					scene.grCreate.x = -scene.grCreate.width
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						x = 0,
						onComplete = function()
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="showRight" then
					scene.grCreate.x = scene.grCreate.width
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						x = 0,
						onComplete = function()
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="showUp" then
					scene.grCreate.y = -scene.grCreate.height
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						y = 0,
						onComplete = function()
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="showDown" then
					scene.grCreate.y = scene.grCreate.height
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						y = 0,
						onComplete = function()
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="hideLeft" then
					scene.grCreate.x = 0
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						x = -scene.grCreate.width,
						onComplete = function()
							scene.grCreate.isVisible = false
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="hideRight" then
					scene.grCreate.x = 0
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						x = scene.grCreate.width,
						onComplete = function()
							scene.grCreate.isVisible = false
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="hideUp" then
					scene.grCreate.y =0
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						y = -scene.grCreate.height,
						onComplete = function()
							scene.grCreate.isVisible = false
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="hideDown" then
					scene.grCreate.y = 0
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						y = scene.grCreate.height,
						onComplete = function()
							scene.grCreate.isVisible = false
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="showClock" then
					scene.grCreate.rotation = -90
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						rotation = 0,
						onComplete = function()
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="hideClock" then
					scene.grCreate.rotation = 0
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						rotation = -90,
						onComplete = function()
							scene.grCreate.isVisible = false
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="showCardUp" then
					scene.grCreate.x = -scene.grCreate.width
					scene.grCreate.y = -scene.grCreate.height
					scene.grCreate.rotation = -50
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						x = 0,
						y = 0,
						rotation = 0,
						onComplete = function()
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="hideCardUp" then
					scene.grCreate.x = 0
					scene.grCreate.y = 0
					scene.grCreate.rotation = 0
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						x = -scene.grCreate.width,
						y = -scene.grCreate.height,
						rotation = -50,
						onComplete = function()
							scene.grCreate.isVisible = false
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="showCardDown" then
					scene.grCreate.x = -scene.grCreate.width
					scene.grCreate.y = scene.grCreate.height*1.2
					scene.grCreate.rotation = -50
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						x = 0,
						y = 0,
						rotation = 0,
						onComplete = function()
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="hideCardDown" then
					scene.grCreate.x = 0
					scene.grCreate.y = 0
					scene.grCreate.rotation = 0
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						x = -scene.grCreate.width,
						y = scene.grCreate.height*1.2,
						rotation = -50,
						onComplete = function()
							scene.grCreate.isVisible = false
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="showZoom" then
					scene.grCreate.anchorChildren = true

					scene.grCreate.xScale = .001
					scene.grCreate.yScale = .001
					scene.grCreate.rotation = 360
					scene.grCreate.x = scene.defContent.centerX
					scene.grCreate.y = scene.defContent.centerY

					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						xScale = 1,
						yScale = 1,
						rotation = 0,
						onComplete = function()
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="hideZoom" then
					scene.grCreate.anchorChildren = true

					scene.grCreate.xScale = 1
					scene.grCreate.yScale = 1
					scene.grCreate.rotation = 0
					scene.grCreate.x = scene.defContent.centerX
					scene.grCreate.y = scene.defContent.centerY

					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						xScale = .001,
						yScale = .001,
						rotation = 360,
						onComplete = function()
							scene.grCreate.isVisible = false
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="showWidthLeft" then
					scene.grCreate.xScale = .001
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						xScale = 1,
						onComplete = function()
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="hideWidthLeft" then
					scene.grCreate.xScale = 1
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						xScale = .001,
						onComplete = function()
							scene.grCreate.isVisible = false
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="showWidthRight" then
					scene.grCreate.xScale = .001
					scene.grCreate.x = scene.grCreate.width
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						x = 0,
						xScale = 1,
						onComplete = function()
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="hideWidthRight" then
					scene.grCreate.xScale = 1
					scene.grCreate.x = 0
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						x = scene.grCreate.width,
						xScale = .001,
						onComplete = function()
							scene.grCreate.isVisible = false
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="showHeightUp" then
					scene.grCreate.yScale = .001
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						yScale = 1,
						onComplete = function()
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="hideHeightUp" then
					scene.grCreate.yScale = 1
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						yScale = .001,
						onComplete = function()
							scene.grCreate.isVisible = false
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="showHeightDown" then
					scene.grCreate.yScale = .001
					scene.grCreate.y = scene.grCreate.height
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						y = 0,
						yScale = 1,
						onComplete = function()
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="hideHeightDown" then
					scene.grCreate.yScale = 1
					scene.grCreate.y = 0
					scene.defSceneTransition = transition.to( scene.grCreate, { 
						time = params.effectTimeMs,
						y = scene.grCreate.height,
						yScale = .001,
						onComplete = function()
							scene.grCreate.isVisible = false
							if params.onComplete then
								params.onComplete()
							end
						end
					} )
				elseif params.effect=="shake" then
					scene.grCreate.anchorChildren = true

					scene.grCreate.rotation = 0
					scene.grCreate.x = scene.defContent.centerX
					scene.grCreate.y = scene.defContent.centerY

					local totalShake = math_round(params.effectTimeMs/180)
					local currentShake = 0
					local time = params.effectTimeMs/(totalShake+1)
					local min,max = math_round(5*params.effectIntensity),math_round(10*params.effectIntensity)
					local rotation = math_random(min,max)
					local symbol = math_random(1,2)

					scene.defShake = function(_rotation)
						if scene.defSceneTransition then
							transition.cancel(scene.defSceneTransition)
							scene.defSceneTransition = nil
						end
						rotation = _rotation or math_random(min,max)
						symbol = symbol==1 and 2 or 1
						scene.defSceneTransition = transition.to( scene.grCreate, { 
							time = time,
							rotation = symbol==1 and rotation or -rotation,
							onComplete = function()
								if rotation==0 then
									if params.onComplete then
										params.onComplete()
									end
								else
									currentShake = currentShake+1
									if currentShake>=totalShake then
										scene.defShake(0)
									else
										scene.defShake()
									end
								end
							end
						} )
					end
					scene.defShake()
				elseif params.effect=="shakeScale" then
					scene.grCreate.anchorChildren = true

					scene.grCreate.rotation = 0
					scene.grCreate.x = scene.defContent.centerX
					scene.grCreate.y = scene.defContent.centerY

					local totalShake = math_round(params.effectTimeMs/180)
					local currentShake = 0
					local time = params.effectTimeMs/(totalShake+1)
					local rmin,rmax = math_round(5*params.effectIntensity),math_round(10*params.effectIntensity)
					local rotation = math_random(rmin,rmax)
					local symbol = math_random(1,2)
					local smin,smax = math_round(90*params.effectIntensity),math_round(120*params.effectIntensity)
					local scale = math_random(smin,smax)/100

					scene.defShake = function(_rotation,_scale)
						if scene.defSceneTransition then
							transition.cancel(scene.defSceneTransition)
							scene.defSceneTransition = nil
						end
						rotation = _rotation or math_random(rmin,rmax)
						symbol = symbol==1 and 2 or 1
						scale = _scale or math_random(smin,smax)/100
						scene.defSceneTransition = transition.to( scene.grCreate, { 
							time = time,
							rotation = symbol==1 and rotation or -rotation,
							xScale = scale,
							yScale = scale,
							onComplete = function()
								if rotation==0 then
									if params.onComplete then
										params.onComplete()
									end
								else
									currentShake = currentShake+1
									if currentShake>=totalShake then
										scene.defShake(0,1)
									else
										scene.defShake()
									end
								end
							end
						} )
					end
					scene.defShake()
				elseif params.effect=="defShow" then
					if params.onComplete then
						params.onComplete()
					end
				elseif params.effect=="defHide" then
					scene.grCreate.isVisible = false
					if params.onComplete then
						params.onComplete()
					end
				end 
			else
				if private.debug then
					print( "SceneManager: The scene has not been created." )
				end
			end
		else
			if private.debug then
				print( "SceneManager: Unidentified Scene Effect: \""..params.effect.."\"" )
			end

			if params.onComplete then
				params.onComplete()
			end
		end
	end

	scene.effectTouchList = {
		["defaultBegan"] = true,		["defaultEnded"] = true,
		["zoomInBegan"] = true,			["zoomInEnded"] = true,
		["zoomOutBegan"] = true,		["zoomOutEnded"] = true,
		["widthBegan"] = true,			["widthEnded"] = true,
		["heightBegan"] = true,			["heightEnded"] = true,
		["rotateLeftBegan"] = true,		["rotateLeftEnded"] = true,
		["rotateRightBegan"] = true,	["rotateRightEnded"] = true,
	}
	scene.setTouchAnimation = function(params)
		local params = params or {}
		params.object = params.object
		params.effect = params.effect or "nil"
		params.effectIntensity = params.effectIntensity or 1

		if scene.defTouchTransition then
			transition.cancel(scene.defTouchTransition)
			scene.defTouchTransition = nil
		end
		
		if params.object then
			if not params.object.defAlpha then
				params.object.defAlpha = params.object.alpha
			end
			params.object.alpha = params.object.defAlpha

			if not params.object.defXScale then
				params.object.defXScale = params.object.xScale
			end
			params.object.xScale = params.object.defXScale

			if not params.object.defYScale then
				params.object.defYScale = params.object.yScale
			end
			params.object.yScale = params.object.defYScale

			if not params.object.defRotation then
				params.object.defRotation = params.object.rotation
			end
			params.object.rotation = params.object.defRotation
		end

		if scene.effectTouchList[params.effect] then
			if params.object then
				if params.effect=="defaultBegan" then
					local intensity = params.effectIntensity*.5
					params.object.alpha = params.object.defAlpha*intensity
				elseif params.effect=="zoomInBegan" then
					local intensity = params.effectIntensity*1.15
					params.object.xScale = params.object.defXScale*intensity
					params.object.yScale = params.object.defYScale*intensity
				elseif params.effect=="zoomOutBegan" then
					local intensity = params.effectIntensity*.85
					params.object.xScale = params.object.defXScale*intensity
					params.object.yScale = params.object.defYScale*intensity
				elseif params.effect=="widthBegan" then
					local intensity = params.effectIntensity*.85
					params.object.xScale = params.object.defXScale*intensity
				elseif params.effect=="heightBegan" then
					local intensity = params.effectIntensity*.85
					params.object.yScale = params.object.defYScale*intensity
				elseif params.effect=="rotateLeft" then
					local intensity = params.effectIntensity*30
					params.object.rotation = params.object.defRotation-intensity
				elseif params.effect=="rotateRight" then
					local intensity = params.effectIntensity*30
					params.object.rotation = params.object.defRotation+intensity
				end
			else
				if private.debug then
					print( "SceneManager: The scene-object has not been created." )
				end
			end
		else
			if private.debug then
				print( "SceneManager: Unidentified Touch Effect: \""..params.effect.."\"" )
			end
		end
	end
	scene.setLockListener = function(obj,params)
		if not obj then return false end
		local obj = obj or {}
		local params = params or {}
		params.value = params.value
		params.clickEffect = params.clickEffect or "default"
		params.effectIntensity = params.effectIntensity or 1

		if params.value then
			obj.isLock = true
			scene.setTouchAnimation({object=obj,effect=params.clickEffect.."Began",effectIntensity=params.effectIntensity})
		else
			obj.isLock = false
			scene.setTouchAnimation({object=obj,effect=params.clickEffect.."Ended",effectIntensity=params.effectIntensity})
		end
	end
	scene.setTouchListener = function(obj,params)
		if not obj then return false end
		local obj = obj or {}
		local params = params or {}
		params.clickEffect = params.clickEffect or "default"
		params.effectIntensity = params.effectIntensity or 1
		params.onInit = params.onInit or function(e) end
		params.onBegan = params.onBegan or function(e) end
		params.onMoved = params.onMoved or function(e) end
		params.onEnded = params.onEnded or function(e) end
		params.onLossFocusX = params.onLossFocusX
		params.onLossFocusY = params.onLossFocusY
		params.offsetLossX = math_round(scene.defContent.height*.05)
		params.offsetLossY = math_round(scene.defContent.height*.05)
		params.isReturn = params.isReturn~=false
		params.isMultyClick = params.isMultyClick

		obj.isLock = false
		obj:addEventListener( "touch", function(e)
			if obj.isLock then return true end
			params.onInit(e)

			if e.phase=="began" then
				scene.setTouchAnimation({object=e.target,effect=params.clickEffect.."Began",effectIntensity=params.effectIntensity})

				params.onBegan(e)

				e.target.isFocus = true
				display.getCurrentStage():setFocus(e.target)
			end
			if e.phase=="moved" and e.target.isFocus==true then
				params.onMoved(e)

				local defOffsetX = math_abs(e.x-e.xStart)
				if defOffsetX>params.offsetLossX then
					scene.setTouchAnimation({object=e.target,effect=params.clickEffect.."Ended",effectIntensity=params.effectIntensity})

					e.target.isFocus = false
					display.getCurrentStage():setFocus(nil)

					if params.onLossFocusX then
						params.onLossFocusX(e)
					end
				end
				local defOffsetY = math_abs(e.x-e.xStart)
				if defOffsetY>params.offsetLossY then
					scene.setTouchAnimation({object=e.target,effect=params.clickEffect.."Ended",effectIntensity=params.effectIntensity})

					e.target.isFocus = false
					display.getCurrentStage():setFocus(nil)

					if params.onLossFocusY then
						params.onLossFocusY(e)
					end
				end
			end
			if (e.phase=="ended" or e.phase=="cancelled") and e.target.isFocus==true then
				scene.setTouchAnimation({object=e.target,effect=params.clickEffect.."Ended",effectIntensity=params.effectIntensity})
				if not params.isMultyClick then
					scene.setLockListener(e.target,{
						value = true,
						clickEffect = params.clickEffect,
						effectIntensity = params.effectIntensity,
					})
				end

				params.onEnded(e)
				
				e.target.isFocus = false
				display.getCurrentStage():setFocus(nil)
			end
			if params.isReturn then
				return true
			end
		end )
	end
	scene.setColor = function(obj,color)
		if not obj then return false end
		local obj = obj or {}
		local color = color or "white"
		obj.colorsTheme = color

		scene.defUpdateTheme(obj)
	end
	scene.defUpdateTheme = function(obj)
		if not obj then return false end
		if obj.colorsTheme then
			local color = "ffffff"
			if type(obj.colorsTheme)=="table" then
				if scene.defContent.modeTheme=="auto" then
					local theme = public.getTheme()
					if private.testTheme then
						theme = scene.defContent.sceneTheme=="default" and "dark" or "default"
					end
					if obj.colorsTheme[theme] then
						color = obj.colorsTheme[theme]
					end
				else
					local theme = scene.defContent.modeTheme
					if obj.colorsTheme[theme] then
						color = obj.colorsTheme[theme]
					end
				end
			else
				color = obj.colorsTheme
			end
			color = public.colors[color] and public.colors[color] or color
			obj:setFillColor(public.toRGB(color))
		else
			return false
		end
	end
	
	scene.defInit = function(defParams,params)
		local defParams = defParams or {}
		local params = params or {}

		scene.defContent.sceneName = defParams.sceneName
		local p = {
			content = scene.defContent,

			custom = params
		}
		scene.init(p)

		if private.debug then
			print( "SceneManager: Scene is Init: \""..defParams.sceneName.."\"" )
		end

		if params.onInit then
			params.onInit()
		end
	end
	scene.defCreate = function(defParams,params)
		local defParams = defParams or {}
		local params = params or {}
		local content = scene.defContent

		scene.grCreate = display.newGroup()
		scene.uiCreate = {}
		scene.specUICreate = {}
		scene.timersCreate = {}

		scene.uiCreate.background = display.newRect(scene.grCreate,content.centerX,content.centerY,content.width,content.height)
		scene.setColor(scene.uiCreate.background,{default="NavajoWhite",dark="SaddleBrown"})
		scene.uiCreate.background:addEventListener( "touch", scene.defLockTouch )
		scene.uiCreate.background:addEventListener( "tap", scene.defLockTouch )

		local p = {
			content = scene.defContent,
			parent = scene.grCreate,
			ui = scene.uiCreate,
			specUI = scene.specUICreate,
			timers = scene.timersCreate,

			custom = params
		}
		scene.create(p)

		if private.debug then
			print( "SceneManager: Scene is Create: \""..defParams.sceneName.."\"" )
		end

		if params.onCreate then
			params.onCreate()
		end
	end
	scene.defDestroy = function(defParams,params)
		local defParams = defParams or {}
		local params = params or {}

		scene.destroy(params)

		if scene.defSceneTransition then
			transition.cancel(scene.defSceneTransition)
			scene.defSceneTransition = nil
		end
		if scene.defTouchTransition then
			transition.cancel(scene.defTouchTransition)
			scene.defTouchTransition = nil
		end

		scene.defTimerCancel(scene.timersCreate)
		scene.defRemove(scene.specUICreate)
		display.remove(scene.grCreate)
		scene.grCreate = nil
		scene.uiCreate = {}
		scene.specUICreate = {}

		if private.debug then
			print( "SceneManager: Scene is Destroy: \""..defParams.sceneName.."\"" )
		end

		if params.onDestroy then
			params.onDestroy()
		end
	end
	scene.defShow = function(defParams,params)
		local defParams = defParams or {}
		local params = params or {}
		params.effect = params.effect or "defShow"
		params.effectTimeMs = params.effectTimeMs or 0

		scene.grShow = display.newGroup()
		scene.grCreate:insert(scene.grShow)
		scene.uiShow = {}
		scene.specUIShow = {}
		scene.timersShow = {}

		local p = {
			content = scene.defContent,
			parent = scene.grShow,
			ui = scene.uiShow,
			specUI = scene.specUIShow,
			timers = scene.timersShow,

			custom = params
		}
		scene.show(p)
		Runtime:addEventListener("enterFrame", scene.defUpdate )
		Runtime:addEventListener( "system", scene.defSystem )
		scene.defTimerResume(scene.timersCreate)

		scene.setAnimation({
			effect = params.effect,
			effectTimeMs = params.effectTimeMs,
			effectIntensity = params.effectIntensity,
			onComplete = function()
				if private.debug then
					print( "SceneManager: Scene is Show: \""..defParams.sceneName.."\"" )
				end

				if params.onShow then
					params.onShow()
				end
			end
		})
	end
	scene.defHide = function(defParams,params)
		local defParams = defParams or {}
		local params = params or {}
		params.effect = params.effect or "defHide"
		params.effectTimeMs = params.effectTimeMs or 0

		scene.hide(params)
		Runtime:removeEventListener("enterFrame", scene.defUpdate )
		Runtime:removeEventListener( "system", scene.defSystem )
		scene.defTimerPause(scene.timersCreate)

		scene.setAnimation({
			effect = params.effect,
			effectTimeMs = params.effectTimeMs,
			effectIntensity = params.effectIntensity,
			onComplete = function()
				scene.defTimerCancel(scene.timersShow)
				scene.defRemove(scene.specUIShow)
				display.remove(scene.grShow)
				scene.grShow = nil
				scene.uiShow = {}
				scene.specUIShow = {}

				if private.debug then
					print( "SceneManager: Scene is Hide: \""..defParams.sceneName.."\"" )
				end

				if params.onHide then
					params.onHide()
				end
			end
		})
	end
	scene.defUpdate = function(e)
		scene.update(e)

		local sec = math_round(e.time/1000)
		if sec>scene.defContent.startSec then
			scene.defContent.startSec = sec

			if scene.defContent.modeTheme=="auto" then
				if scene.defContent.startSec%private.updateThemeSec==0 then
					local theme = public.getTheme()
					if private.testTheme then
						theme = scene.defContent.sceneTheme=="default" and "dark" or "default"
					end
					if theme~=scene.defContent.sceneTheme then
						scene.defContent.sceneTheme = theme
						
						scene.defUpdateColors(scene.uiCreate)
						scene.defUpdateColors(scene.specUICreate)
						scene.defUpdateColors(scene.uiShow)
						scene.defUpdateColors(scene.specUIShow)

						if private.debug then
							print( "SceneManager: Scene is Update Theme: \""..scene.defContent.sceneName.."\", sceneTheme: "..scene.defContent.sceneTheme )
						end
					end
				end
			end
		end
	end
	scene.defSystem = function(e)
		if e.type=="applicationSuspend" then
			scene.suspend()
		end
		if e.type=="applicationResume" then
			scene.resume()
		end
	end
	scene.defUpdateColors = function(table)
		local table = table or {}
		for k,v in pairs(table) do
			if table[k].setFillColor then
				scene.defUpdateTheme(table[k])
			else
				scene.defUpdateColors(v)
			end
		end
	end
	scene.defRemove = function(table)
		local table = table or {}
		for k,v in pairs(table) do
			if table[k].removeSelf or table[k].remove then
				display.remove(table[k])
				table[k] = nil
			else
				scene.defRemove(v)
			end
		end
	end
	scene.defTimerCancel = function(table)
		local table = table or {}
		for k,v in pairs(table) do
			if table[k] and table[k]._time then
				timer.cancel(table[k])
				table[k] = nil
			else
				scene.defTimerCancel(v)
			end
		end
	end
	scene.defTimerPause = function(table)
		local table = table or {}
		for k,v in pairs(table) do
			if table[k] and table[k]._time then
				timer.pause(table[k])
			else
				scene.defTimerPause(v)
			end
		end
	end
	scene.defTimerResume = function(table)
		local table = table or {}
		for k,v in pairs(table) do
			if table[k] and table[k]._time then
				timer.resume(table[k])
			else
				scene.defTimerResume(v)
			end
		end
	end

	return scene
end

public.getTheme = function()
	local isDark = system.getInfo("darkMode")
	local colorTheme = isDark and "dark" or "default"
	return colorTheme
end

public.toRGB = function(hex)
	if string_len(hex) == 3 then
		return 
		(tonumber("0x"..string_sub(hex,1,1)) * 17)/255,
		(tonumber("0x"..string_sub(hex,2,2)) * 17)/255,
		(tonumber("0x"..string_sub(hex,3,3)) * 17)/255
	elseif string_len(hex) == 6 then
		return
		(tonumber("0x"..string_sub(hex,1,2)))/255,
		(tonumber("0x"..string_sub(hex,3,4)))/255,
		(tonumber("0x"..string_sub(hex,5,6)))/255
	else
		return
		1,1,1
	end
end

public.colors = {
	["IndianRed"] = "CD5C5C",
	["LightCoral"] = "F08080",
	["Salmon"] = "FA8072",
	["DarkSalmon"] = "E9967A",
	["LightSalmon"] = "FFA07A",
	["Crimson"] = "DC143C",
	["FireBrick"] = "B22222",
	["DarkRed"] = "8B0000",

	["Pink"] = "FFC0CB",
	["LightPink"] = "FFB6C1",
	["HotPink"] = "FF69B4",
	["DeepPink"] = "FF1493",
	["MediumVioletRed"] = "C71585",
	["PaleVioletRed"] = "DB7093",

	["LightSalmon"] = "FFA07A",
	["Coral"] = "FF7F50",
	["Tomato"] = "FF6347",
	["OrangeRed"] = "FF4500",
	["DarkOrange"] = "FF8C00",
	["Orange"] = "FFA500",

	["Gold"] = "FFD700",
	["LightYellow"] = "FFFFE0",
	["LemonChiffon"] = "FFFACD",
	["LightGoldenrodYellow"] = "FAFAD2",
	["PapayaWhip"] = "FFEFD5",
	["Moccasin"] = "FFE4B5",
	["PeachPuff"] = "FFDAB9",
	["PaleGoldenrod"] = "EEE8AA",
	["Khaki"] = "F0E68C",
	["DarkKhaki"] = "BDB76B",

	["Lavender"] = "E6E6FA",
	["Thistle"] = "D8BFD8",
	["Plum"] = "DDA0DD",
	["Violet"] = "EE82EE",
	["Orchid"] = "DA70D6",
	["Magenta"] = "FF00FF",
	["MediumOrchid"] = "BA55D3",
	["MediumPurple"] = "9370DB",
	["BlueViolet"] = "8A2BE2",
	["DarkViolet"] = "9400D3",
	["DarkOrchid"] = "9932CC",
	["DarkMagenta"] = "8B008B",
	["Indigo"] = "4B0082",
	["SlateBlue"] = "6A5ACD",
	["DarkSlateBlue"] = "483D8B",

	["Cornsilk"] = "FFF8DC",
	["BlanchedAlmond"] = "FFEBCD",
	["Bisque"] = "FFE4C4",
	["NavajoWhite"] = "FFDEAD",
	["Wheat"] = "F5DEB3",
	["BurlyWood"] = "DEB887",
	["Tan"] = "D2B48C",
	["RosyBrown"] = "BC8F8F",
	["SandyBrown"] = "F4A460",
	["Goldenrod"] = "DAA520",
	["DarkGoldenRod"] = "B8860B",
	["Peru"] = "CD853F",
	["Chocolate"] = "D2691E",
	["SaddleBrown"] = "8B4513",
	["Sienna"] = "A0522D",
	["Brown"] = "A52A2A",

	["Black"] = "000000",
	["Gray"] = "808080",
	["Silver"] = "C0C0C0",
	["White"] = "FFFFFF",
	["Fuchsia"] = "FF00FF",
	["Purple"] = "800080",
	["Red"] = "FF0000",
	["Maroon"] = "800000",
	["Yellow"] = "FFFF00",
	["Olive"] = "808000",
	["Lime"] = "00FF00",
	["Green"] = "008000",
	["Aqua"] = "00FFFF",
	["Teal"] = "008080",
	["Blue"] = "0000FF",
	["Navy"] = "000080",

	["GreenYellow"] = "ADFF2F",
	["Chartreuse"] = "7FFF00",
	["LawnGreen"] = "7CFC00",
	["LimeGreen"] = "32CD32",
	["PaleGreen"] = "98FB98",
	["LightGreen"] = "90EE90",
	["MediumSpringGreen"] = "00FA9A",
	["SpringGreen"] = "00FF7F",
	["MediumSeaGreen"] = "3CB371",
	["SeaGreen"] = "2E8B57",
	["ForestGreen"] = "228B22",
	["DarkGreen"] = "006400",
	["YellowGreen"] = "9ACD32",
	["OliveDrab"] = "6B8E23",
	["DarkOliveGreen"] = "556B2F",
	["MediumAquamarine"] = "66CDAA",
	["DarkSeaGreen"] = "8FBC8F",
	["LightSeaGreen"] = "20B2AA",
	["DarkCyan"] = "008B8B",

	["Cyan"] = "00FFFF",
	["LightCyan"] = "E0FFFF",
	["PaleTurquoise"] = "AFEEEE",
	["Aquamarine"] = "7FFFD4",
	["Turquoise"] = "40E0D0",
	["MediumTurquoise"] = "48D1CC",
	["DarkTurquoise"] = "00CED1",
	["CadetBlue"] = "5F9EA0",
	["SteelBlue"] = "4682B4",
	["LightSteelBlue"] = "B0C4DE",
	["PowderBlue"] = "B0E0E6",
	["LightBlue"] = "ADD8E6",
	["SkyBlue"] = "87CEEB",
	["LightSkyBlue"] = "87CEFA",
	["DeepSkyBlue"] = "00BFFF",
	["DodgerBlue"] = "1E90FF",
	["CornflowerBlue"] = "6495ED",
	["MediumSlateBlue"] = "7B68EE",
	["RoyalBlue"] = "4169E1",
	["MediumBlue"] = "0000CD",
	["DarkBlue"] = "00008B",
	["MidnightBlue"] = "191970",

	["Snow"] = "FFFAFA",
	["Honeydew"] = "F0FFF0",
	["MintCream"] = "F5FFFA",
	["Azure"] = "F0FFFF",
	["AliceBlue"] = "F0F8FF",
	["GhostWhite"] = "F8F8FF",
	["WhiteSmoke"] = "F5F5F5",
	["Seashell"] = "FFF5EE",
	["Beige"] = "F5F5DC",
	["OldLace"] = "FDF5E6",
	["FloralWhite"] = "FFFAF0",
	["Ivory"] = "FFFFF0",
	["AntiqueWhite"] = "FAEBD7",
	["Linen"] = "FAF0E6",
	["LavenderBlush"] = "FFF0F5",
	["MistyRose"] = "FFE4E1",

	["Gainsboro"] = "DCDCDC",
	["LightGrey"] = "D3D3D3",
	["LightGray"] = "D3D3D3",
	["DarkGray"] = "A9A9A9",
	["DarkGrey"] = "A9A9A9",
	["Grey"] = "808080",
	["DimGray"] = "696969",
	["DimGrey"] = "696969",
	["LightSlateGray"] = "778899",
	["LightSlateGrey"] = "778899",
	["SlateGray"] = "708090",
	["SlateGrey"] = "708090",
	["DarkSlateGray"] = "2F4F4F",
	["DarkSlateGrey"] = "2F4F4F",
}

return public
