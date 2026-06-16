--[[
--       Title:      rc.lua
--       Brief:      Arquivo de configuração modular do Awesome WM
--       Path:       /home/jkyon/.config/awesome/rc.lua
--       Author:     John Kennedy a.k.a. jKyon
--       Created:    2025-03-14
--       Updated:    2026-03-15
--       Notes:
--]]


-- If LuaRocks is installed, make sure that packages installed through it are
pcall(require, "luarocks.loader")

-- Load JSON library
-- package.path = package.path .. "/home/jkyon/.config/awesome/lib/json.lua/json.lua"
-- local json = require("json")

-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")
local free_focus = true

--- Logger and debug loader ---
local logger = require("modules.logger")
local debug_loader = require("modules.debug_loader")

logger.info("===== Awesome session started =====")

-- Theme handling library
local beautiful = require("beautiful")
beautiful.init("/home/jkyon/.config/awesome/themes/jkyon/theme.lua")


--- Variable definitions ---

logger.info("===== Load variables =====")

terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"


logger.info("===== Load modules =====")

--- Load modules ---
local notification_manager = debug_loader.safe_require("modules.notification_manager")
local notification_panel = debug_loader.safe_require("modules.notification_panel")
local error_handling = debug_loader.safe_require("modules.error_handling")
local layouts = debug_loader.safe_require("modules.layouts")
local buttons = debug_loader.safe_require("modules.buttons")
local wibar_manager = debug_loader.safe_require("modules.wibar_manager")
local tags_utils = debug_loader.safe_require("modules.tags_utils")
local tags = debug_loader.safe_require("modules.tags")
    if wibar_manager and buttons then
        debug_loader.safe_call("wibar_manager.setup", function()
            wibar_manager.setup(buttons.taglist_buttons, buttons.tasklist_buttons)
        end)
    end
local keys = debug_loader.safe_require("modules.keys")
    if globalkeys then
        debug_loader.safe_call("root.keys(globalkeys)", function()
            root.keys(globalkeys)
        end)
    end
local rules = debug_loader.safe_require("modules.rules")
local signals = debug_loader.safe_require("modules.signals")
local wallpaper = debug_loader.safe_require("modules.wallpaper")


-- Garbage collector settings --
local garbage_collector = debug_loader.safe_require("modules.garbage_collector")