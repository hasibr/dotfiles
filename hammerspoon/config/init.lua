local utils = require("utils")
local hideAllApps = utils.hideAllApps

local function focusApp(appName)
	return function()
		utils.focusApp(appName)
	end
end

local function toggleApp(appName)
	return function()
		utils.toggleApp(appName)
	end
end

local function weakFocus(appName)
	return function()
		utils.weakFocus(appName)
	end
end

local cmd2 = { "command", "ctrl" }

-- for more apps, see /Applications
hs.hotkey.bind(cmd2, "a", toggleApp("Alacritty"))
hs.hotkey.bind(cmd2, "s", weakFocus("Slack"))
hs.hotkey.bind(cmd2, "c", focusApp("Google Chrome"))
hs.hotkey.bind(cmd2, "j", weakFocus("IntelliJ IDEA"))
hs.hotkey.bind(cmd2, "m", focusApp("Spotify"))
hs.hotkey.bind(cmd2, "h", hideAllApps)