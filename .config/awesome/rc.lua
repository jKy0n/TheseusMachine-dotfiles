-- If LuaRocks is installed, make sure that packages installed through it are
pcall(require, "luarocks.loader")

-- Load JSON library
-- package.path = package.path .. "/home/jkyon/.config/awesome/lib/json.lua/json.lua"
-- local json = require("json")

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
local notification_panel = require("modules.notification_panel")
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
local wallpaper = require("modules.wallpaper")


-- jKyon Adds --

-- Garbage collector settings --
local garbage_collector = require("modules.garbage_collector")