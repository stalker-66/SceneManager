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
> * **debug** (optional) <br/>
> `Boolean`. Includes additional debugging information for the plugin. Default is `false`. <br/>
## Usage
## Extras
## Example
## Support
stalker66.production@gmail.com
