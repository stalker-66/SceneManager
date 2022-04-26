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
<br/>

> Calling this function creates the specified scene in your app. Note that after the scene is created, the show phase is executed.
> ```lua
> scenemanager.create(sceneName,params)
> ```
> * **sceneName** (required) <br/>
> `String`. The scene name (or identifier) specified when **scenemanager** was initialized. <br/>
> 
> The ***params*** table includes parameters for creating a scene via **scenemanager**. <br/>
> * **effect** (optional) <br/>
> `String`. Specifies the effect for the show transition. See [...] for a list of valid options. If no effect is specified, the scene will appear instantaneously. Default is `defShow`. <br/>
> * **effectTimeMs** (optional) <br/>
> `Number`. The time duration for the effect in milliseconds, if a valid effect has been specified. Default is `500` ms. <br/>
> * **effectIntensity** (optional) <br/>
> `Number`. The intensity of the scene effect, if a valid effect has been specified. Not all effects support this parameter. Default is `1`. <br/>
> * **onInit** (optional) <br/>
> `Function`. This function will be executed before the scene is created. Default is `nil`. <br/>
> * **onCreate** (optional) <br/>
> `Function`. This function will be executed after the scene has been created. Default is `nil`. <br/>
> * **onShow** (optional) <br/>
> `Function`. This function will be executed after the scene is shown. Default is `nil`. <br/>
<br/>

> Calling this function shows the specified scene in your app. Note that the specified scene must be hidden.
> ```lua
> scenemanager.show(sceneName,params)
> ```
> * **sceneName** (required) <br/>
> `String`. The scene name (or identifier) specified when **scenemanager** was initialized. <br/>
> 
> The ***params*** table includes parameters for showing a scene via **scenemanager**. <br/>
> * **effect** (optional) <br/>
> `String`. Specifies the effect for the show transition. See [...] for a list of valid options. If no effect is specified, the scene will appear instantaneously. Default is `defShow`. <br/>
> * **effectTimeMs** (optional) <br/>
> `Number`. The time duration for the effect in milliseconds, if a valid effect has been specified. Default is `500` ms. <br/>
> * **effectIntensity** (optional) <br/>
> `Number`. The intensity of the scene effect, if a valid effect has been specified. Not all effects support this parameter. Default is `1`. <br/>
> * **onShow** (optional) <br/>
> `Function`. This function will be executed after the scene is shown. Default is `nil`. <br/>
<br/>

> Calling this function hides the specified scene in your app. Note that the specified scene must be shown.
> ```lua
> scenemanager.hide(sceneName,params)
> ```
> * **sceneName** (required) <br/>
> `String`. The scene name (or identifier) specified when **scenemanager** was initialized. <br/>
> 
> The ***params*** table includes parameters for hiding a scene via **scenemanager**. <br/>
> * **effect** (optional) <br/>
> `String`. Specifies the effect for the hide transition. See [...] for a list of valid options. If no effect is specified, the scene will disappear instantaneously. Default is `defHide`. <br/>
> * **effectTimeMs** (optional) <br/>
> `Number`. The time duration for the effect in milliseconds, if a valid effect has been specified. Default is `500` ms. <br/>
> * **effectIntensity** (optional) <br/>
> `Number`. The intensity of the scene effect, if a valid effect has been specified. Not all effects support this parameter. Default is `1`. <br/>
> * **onHide** (optional) <br/>
> `Function`. This function will be executed after the scene is hidden. Default is `nil`. <br/>
<br/>

> Calling this function will destroy the specified scene in your app. Note that the specified scene must be created.
> ```lua
> scenemanager.destroy(sceneName,params)
> ```
> * **sceneName** (required) <br/>
> `String`. The scene name (or identifier) specified when **scenemanager** was initialized. <br/>
> 
> The ***params*** table includes parameters for destroying a scene via **scenemanager**. <br/>
> * **effect** (optional) <br/>
> `String`. Specifies the effect for the hide transition. See [...] for a list of valid options. If no effect is specified, the scene will disappear instantaneously. Default is `defHide`. <br/>
> * **effectTimeMs** (optional) <br/>
> `Number`. The time duration for the effect in milliseconds, if a valid effect has been specified. Default is `500` ms. <br/>
> * **effectIntensity** (optional) <br/>
> `Number`. The intensity of the scene effect, if a valid effect has been specified. Not all effects support this parameter. Default is `1`. <br/>
> * **onDestroy** (optional) <br/>
> `Function`. This function will be executed after the scene is destroyed. Default is `nil`. <br/>
<br/>

> Calling this function hides all showed scenes in your app.
> ```lua
> scenemanager.hideAll(params)
> ```
> The ***params*** table includes parameters for hide all scenes via **scenemanager**. <br/>
> * **effect** (optional) <br/>
> `String`. Specifies the effect for the hide transition. See [...] for a list of valid options. If no effect is specified, the scene will disappear instantaneously. Default is `defHide`. <br/>
> * **effectTimeMs** (optional) <br/>
> `Number`. The time duration for the effect in milliseconds, if a valid effect has been specified. Default is `500` ms. <br/>
> * **effectIntensity** (optional) <br/>
> `Number`. The intensity of the scene effect, if a valid effect has been specified. Not all effects support this parameter. Default is `1`. <br/>
> * **onHide** (optional) <br/>
> `Function`. This function will be executed after the all scenes is hidden. Default is `nil`. <br/>
<br/>

> Calling this function destroy all created scenes in your app.
> ```lua
> scenemanager.destroyAll(params)
> ```
> The ***params*** table includes parameters for destroy all scenes via **scenemanager**. <br/>
> * **effect** (optional) <br/>
> `String`. Specifies the effect for the hide transition. See [...] for a list of valid options. If no effect is specified, the scene will disappear instantaneously. Default is `defHide`. <br/>
> * **effectTimeMs** (optional) <br/>
> `Number`. The time duration for the effect in milliseconds, if a valid effect has been specified. Default is `500` ms. <br/>
> * **effectIntensity** (optional) <br/>
> `Number`. The intensity of the scene effect, if a valid effect has been specified. Not all effects support this parameter. Default is `1`. <br/>
> * **onHide** (optional) <br/>
> `Function`. This function will be executed after the all scenes is hidden. Default is `nil`. <br/>
> * **onDestroy** (optional) <br/>
> `Function`. This function will be executed after the all scenes is destroyed. Default is `nil`. <br/>
<br/>

## Usage
## Extras
## Example
## Support
stalker66.production@gmail.com
