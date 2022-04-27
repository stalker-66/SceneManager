# SceneManager - Init
## Overview
Initializes the **scenemanager** plugin. This call is required and must be executed before making other **scenemanager** calls.
## Syntax
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
## Example
> ```lua
> scenemanager.init({
> 	scenes = {
> 		["First"] = require "scFirstScene",
> 	},
> 	updateThemeSec = 2,
> 	testTheme = false,
> 	debug = false,
> })
> ```