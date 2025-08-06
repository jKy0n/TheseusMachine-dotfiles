

-- If LuaRocks is installed, make sure that packages installed through it are
pcall(require, "luarocks.loader")

-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")
local free_focus = true
-- Theme handling library
local beautiful = require("beautiful")
beautiful.init("/home/jkyon/.config/awesome/themes/jkyon/theme.lua")


--- Variable definitions ---

terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"


--- Load modules ---
local notification_manager = require("modules.notification_manager")
local error_handling = require("modules.error_handling")
local layouts = require("modules.layouts")
local buttons = require("modules.buttons")
local wibar_manager = require("modules.wibar_manager")
local tags_utils = require("modules.tags_utils")
local tags = require("modules.tags")
    wibar_manager.setup(buttons.taglist_buttons, buttons.tasklist_buttons)
local keys = require("modules.keys")
root.keys(globalkeys)
local rules = require("modules.rules")
local signals = require("modules.signals")


-- jKyon Adds --

local garbage_collector = require("modules.garbage_collector")
-- Adjust screen layout
awful.spawn.with_shell("sh /home/jkyon/.screenlayout/screenlayout.sh")
-- Set wallpaper
awful.spawn.with_shell("feh --no-xinerama --bg-fill ~/Pictures/Wallpapers/LinuxWallpapers/BlueNebula8K.jpg")

--- Start awesome target on systemd (screensaver dependency??)
-- awful.spawn.easy_async_with_shell(
--     "systemctl --user start awesomewm.target",
--     function() end
-- )
-- Start some programs at startup
awful.spawn.with_shell("sh /home/jkyon/.config/awesome/autorun.sh")
