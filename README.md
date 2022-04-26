# SceneManager
## Overview
The "SceneManager" plugin for Solar2d allows you to easily create, manage and transition  between individual scenes (screens).
## Project Settings
To use this plugin, add an entry into the plugins table of ***build.settings***.
```lua

settings = 
{
	plugins = {
		["plugin.scenemanager"] = { publisherId = "com.narkoz" },
	},
}
```
## Require
```lua
local scenemanager = require "plugin.scenemanager"
```
## Functions
> Initializes the **scenemanager** plugin. This call is required and must be executed before making other **scenemanager** calls.
> ```lua
> scenemanager.init(params)
> ```
> The ***params*** table includes parameters for **scenemanager** initialization. <br/>
> * **scenes** (optional) <br/>
> `Table`. List of scenes for the scene manager in the format: ***key*** - scene name (or identifier), ***value*** - require "lua scene module name". Default is `{}`. <br/>
> * **updateThemeSec** (optional) <br/>
> `Number`. Device theme update interval in seconds. Dark Mode recognition time and update scene objects. Default is `2` sec. <br/>
> * **testTheme** (optional) <br/>
> `Boolean`. Enable test **scenemanager** theme change at a specified interval (see ***updateThemeSec***). Default is `false`. <br/>
> * **debug** (optional) <br/>
> `Boolean`. Includes additional debugging information for the plugin. Default is `false`. <br/>
> `Example:` <br/>
> ```lua
> local scenemanager = require "plugin.scenemanager"
> 
> scenemanager.init({
> 	scenes = {
> 		["First"] = require "scFirstScene",
> 	},
> 	updateThemeSec = 2,
> 	testTheme = false,
> 	debug = false,
> })
> ```

> Calling this function creates the specified scene in your app. Note that after the scene is created, the show phase is executed.
> ```lua
> scenemanager.create(sceneName,params)
> ```
> * **sceneName** (required) <br/>
> `String`. The scene name (or identifier) specified when **scenemanager** was initialized. <br/>
> 
> The ***params*** table includes parameters for creating a scene via **scenemanager**. <br/>
> * **effect** (optional) <br/>
> `String`. Specifies the effect for the ***show*** or ***hide*** transition. See [...] for a list of valid options. If no effect is specified, the scene will appear or disappear instantaneously. Default is `defShow` to ***create***. Default is `defHide` to ***hide***. <br/>
> * **effectTimeMs** (optional) <br/>
> `Number`. The time duration for the effect in milliseconds, if a valid effect has been specified. Default is `500` ms. <br/>
> * **effectIntensity** (optional) <br/>
> `Number`. The intensity of the scene effect, if a valid effect has been specified. Not all effects support this parameter. Default is `1`. <br/>
> * **onInit** (optional) <br/>
> `Function`. Only for the ***create*** function. This function will be executed before the scene is created. Default is `nil`. <br/>
> * **onCreate** (optional) <br/>
> `Function`. Only for the ***create*** function. This function will be executed after the scene has been created. Default is `nil`. <br/>
> * **onShow** (optional) <br/>
> `Function`. Only for the ***create*** or ***show*** function. This function will be executed after the scene is shown. Default is `nil`. <br/>
> * **onHide** (optional) <br/>
> `Function`. Only for the ***hide*** function. This function will be executed after the scene is hidden. Default is `nil`. <br/>
> * **onDestroy** (optional) <br/>
> `Function`. Only for the ***destroy*** function. This function will be executed after the scene is destroyed. Default is `nil`. <br/>
## Usage
## Extras
## Example
## Support
stalker66.production@gmail.com
